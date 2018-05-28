function profil=getpolyg(windows,session,profil)

%% figure ppale :

%on se place dans la figure ppale, 
figure(windows.homefig.handle)
hold on
set(gca,'Xlimmode','manual','Ylimmode','manual')

%sauvegarde des handle de callback a remettre a la fin
windowbuttondownfcn_save=get(windows.homefig.handle,'windowButtondownFcn');
windowbuttonmotionfcn_save=get(windows.homefig.handle,'windowButtonMotionFcn');
windowbuttonupfcn_save=get(windows.homefig.handle,'windowButtonUpFcn');


%attribution des callbacks
set(windows.homefig.handle,'windowbuttondownfcn',{@clic,'mouse'},...
        'windowbuttonmotionfcn',@move)

%handles de graphique temporaires
hmoveline=plot(0,0,'Xdata',[],'Ydata',[]);%handle de la ligne mouvante
hxcursor =plot(0,0,'Xdata',[],'Ydata',[],'marker','+','markeredgecolor','k','linestyle','none');%handle des curseurs x
hycursor =plot(0,0,'Xdata',[],'Ydata',[],'marker','+','markeredgecolor','k','linestyle','none');%handle des curseurs y
hsummit  =plot(0,0,'Xdata',[],'Ydata',[],'marker','o','markeredgecolor','r');%handle des points plottes
hlines   =plot(0,0,'Xdata',[],'Ydata',[]);%handle des lignes qui les relient

%handle de menu temporaires
hmmanual=uimenu('parent',windows.homefig.handle,...
                'label','|  Manual',...
                'callback',{@clic,'manual'});


%coordonnees saisies
x=[];y=[];

%%%%%%%%%%%%%%%%%%%%%%%% callbacks
function move(src,evnt)
    %point ou se trouve la sourie
    cp=get(gca,'currentpoint');
    xsourie=cp(1,1);ysourie=cp(1,2);clear cp
    
    %dès le lancement on veut voir les coordonnees mouvantes et les curseurs
    set(windows.homefig.dlgbox1,'string',sprintf('x : %+8.4f',xsourie),...
                                'Foregroundcolor','k')
    set(windows.homefig.dlgbox2,'string',sprintf('y : %+8.4f',ysourie),...
                                'Foregroundcolor','k')    
    set(hxcursor,'Xdata',[xsourie,xsourie],...
                 'Ydata',ylim(gca))
    set(hycursor,'Xdata',xlim(gca),...
                 'Ydata',[ysourie,ysourie])
    %apres le premier clic on fait apparaitre le ligne mouvante
    if length(x)>=1
       set(hmoveline,'Xdata',[x(length(x)),xsourie],...
                     'Ydata',[y(length(y)),ysourie]);
    end
end

function clic(src,evnt,mode)
    
    if strcmp(mode,'mouse') %appel en mode clic
        %point ou se trouve la sourie au moment du clic
        cp=get(gca,'currentpoint');
        xclic=cp(1,1);yclic=cp(1,2);clear cp
    elseif strcmp(mode,'manual') %saisie des coordonnées
        answer=inputdlg({['x coordinate (',profil.units,')'],...
            ['z coordinate (',profil.units,') '],...
            ['close polygone?(y/n)']},...
            'new point coordinates',1,...
            {'','','n'});
        %si cancel
        if isempty(answer)
            clear answer;
            return
        end
        xclic=str2num(answer{1});
        yclic=str2num(answer{2});
    end

    %affichage de la consigne avant la correction de clic, si il y a
    %correction ce message sera remplacé
    set(windows.homefig.dlgbox,'string','right clic to leave input mode; don''t close the polygon',...
    'Foregroundcolor','k')

    %corrections de clics
    [xclic,yclic,isdiff]=corrigeclic(xclic,yclic,windows,session,profil,'creation');
    
    %si il y a eu recentrage sur segment, il faut completer la structure sur laquelle on s'est recentre
    if ~isempty(isdiff)
        if strcmp(isdiff{1},'seg')
            profil.model(isdiff{2}).polyg=insert_pt(profil.model(isdiff{2}).polyg,isdiff{3},[xclic,yclic]);
            profil.model(isdiff{2}).n=size(profil.model(isdiff{2}).polyg,1);
        end
    end
    
    %enregistrement des points de clic
    x=[x;xclic];
    y=[y;yclic];
    
    %plot des sommets ou on a cliqué
    set(hsummit,'Xdata',[get(hsummit,'Xdata'),xclic],...
                'Ydata',[get(hsummit,'Ydata'),yclic])
    %trace des lignes qui les rejoignent
    set(hlines,'Xdata',x,...
               'Ydata',y)
           
    %fin de saisie(si clic droit) ou 3eme champ de la saisie manuelle sur y
    fini=0;
    if strcmp(mode,'mouse')
        if strcmp(get(src,'selectiontype'),'alt')
            fini=1;
        end
    elseif strcmp(mode,'manual')
        if strcmp(answer{3},'y')
            fini=1;
        end
    end
    if fini
        %on ferme le polygone
        set(hlines,'Xdata',[x;x(1)],'Ydata',[y;y(1)])  
        %on efface les curseurs et la ligne mouvante
        set(hxcursor,'visible','off')
        set(hycursor,'visible','off')
        set(hmoveline,'visible','off')
        %on rends la main
        uiresume();
    end
end
%%%%%%%%%%%%%%%%%%%%%%%% callbacks

uiwait(windows.homefig.handle)
%si la structure a + de 2 sommet et que l utilisateur confirme, on cree la nouvelle structure dans le profil.model
if length(x)>2
    if strcmp(questdlg('Do you want to add this structure?'),'Yes')
        Nstruct_avant=length(profil.model);
        %nombre de sommets
        profil.model(Nstruct_avant+1).n=length(x)+1;
        %densite par defaut
        profil.model(Nstruct_avant+1).rho=NaN;
        %nom par defaut
        profil.model(Nstruct_avant+1).name=['str',num2str(Nstruct_avant+1),'_untitled'];
        %polygone saisi
        profil.model(Nstruct_avant+1).polyg=[x,y;x(1),y(1)];
        %handle de coloriage
        profil.model(Nstruct_avant+1).fill_handle=NaN;
        %ordre par defaut= ordre saisi par l'utilisateur
        switch isclockwise(profil.model(Nstruct_avant+1).polyg)
            case 1
                profil.model(Nstruct_avant+1).order='clockwise';
            case 0
                profil.model(Nstruct_avant+1).order='counterclockwise';
        end
        %couleur par defaut
        profil.model(Nstruct_avant+1).color=getcolorfrom('default',Nstruct_avant+1);
        %colordisplay par defaut
        profil.model(Nstruct_avant+1).colordisplay='transparent';
        
        %confirmation de succes
            set(windows.homefig.dlgbox,'string',...
                sprintf('structure %s successfully created, density : %.2f, order : %s',...
                 profil.model(Nstruct_avant+1).name,...
                 profil.model(Nstruct_avant+1).rho,...
                 profil.model(Nstruct_avant+1).order),...
                'Foregroundcolor',[0 0.7 0])
    end
end

%on restore les callback initiaux
set(windows.homefig.handle,'windowButtondownFcn',windowbuttondownfcn_save,...
                           'windowButtonmotionFcn',windowbuttonmotionfcn_save,...
                           'windowButtonupFcn',windowbuttonupfcn_save)
%suppression des trais de construction
set(hlines,'visible','off')
set(hsummit,'visible','off')
set(hmmanual,'visible','off')   
end


%% fonctions annexes de workspace independants: 
%%%%%%%%%%%%%%corrections de clics
%%%plus ici


%%%%%%%%%%%%%%distance d un point a un nuage de segments
%function [D,M,verif]=dist_dr_pt(A,B,P)
%deplace en dehors de la fontion

%%%%%%%%%%%%%%insertion d un sommet dans une structure
%function polyg_out=insert_pt(polyg_in,npt,P)
%deplace en dehors de la fontion
