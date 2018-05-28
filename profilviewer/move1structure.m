function [profil,session]=move1structure(windows,session,profil,struct)
%deplace toute une structure et les liens correspondants

%tableau des liens entre les sommets
scattlinks=find_links(profil,'sommet');

%indicateur de boutton enfoncé-relevé de la sourie
clicdown=0;

%variables a definir au moins une fios
xclicref=NaN;
yclicref=NaN;
xcliclast=NaN;
ycliclast=NaN;
cp=NaN;

%blockage de toute autre action
    fields=fieldnames(windows.homefig.menu);
    for field=1:length(fields)
       set(windows.homefig.menu.(fields{field}).parent,'enable','off')
    end
%sauvegarde des handles d'action
    window__buttondown_saved=get(windows.homefig.handle,'windowbuttonmotionfcn');
    window__buttonup_saved  =get(windows.homefig.handle,'windowbuttonupfcn');
%attribution des handles d'action
    %attraper la structure : la propriété initiale sera rétablie par refreshprofil
    set(profil.model(struct).fill_handle,'buttondownfcn',@attrapelastructure);
    %deplacer et poser la structure
    set(windows.homefig.handle,'windowbuttonmotionfcn',@deplacelastructure);
    set(windows.homefig.handle,'windowbuttonupfcn',@poselastructure);

%recuperation des lignes de scattlinks ou se trouvent mes sommets
    I_nearests=find(scattlinks(:,1)==struct);
    %recuperation des liens avec les structures voisines
    I_linkeds=zeros(length(I_nearests),12)*NaN;
    for i=1:length(I_nearests)
        tmp=[I_nearests(i),scattlinks(I_nearests(i),4+find(~isnan(scattlinks(I_nearests(i),5:15))))];
        I_linkeds(i,1:length(tmp))=tmp;
    end
%handles de graphique temporaires
    %lignes de contour
    hlines=line('Xdata',[],'Ydata',[],'color','g','visible','off');
    %points associés, yen a qui bougent et d'autres qui sont fixes
    hmovepoints=plot(0,0,'.');set(hmovepoints,'marker','o','markerfacecolor','g','visible','off');
    hfixpoints=plot(0,0,'.');set(hfixpoints,'marker','o','markerfacecolor','r','visible','off');
    xtmp=[];ytmp=[];
    
    %vecteur des indices de Xdata et Ydata qui sont a deplaces , il faudra
    %deplacer get(hlines,'Xdata')(Itomove==1) et pareil avec Ydata
    Itomove=[];
    
    %je parcours les sommets
    for i=1:profil.model(struct).n
        %je commence par ajouter le sommet "i" au vecteur a plotter
        xtmp=[xtmp,profil.model(struct).polyg(i,1)];
        ytmp=[ytmp,profil.model(struct).polyg(i,2)];
        Itomove=[Itomove,1];
        %je regarde si le sommet "i" a des liens
        if ~isnan(I_linkeds(i,2))%si oui
            %je recupere les liens de "i"
            liens=I_linkeds(i,find(~isnan(I_linkeds(i,:))));
            liens(1)=[];
            %je parcours les liens de "i", soit "j" le sommet. "j" et "i" sont au meme endroit
            for j=1:length(liens)
                 if scattlinks(liens(j),1)~=struct%si le sommet "j" appartient a une autre structure que la structure "struct"
                    %je regarde les voisins avant et ap le sommet "j", soient "av" et "ap" ces sommets
                        %sommet d'avant
                        if scattlinks(liens(j),2)>1
                            voisinavant=liens(j)-1;
                        else
                            voisinavant=liens(j)+(profil.model(scattlinks(liens(j),1)).n)-2;
                        end
                        %sommet apres
                        if scattlinks(liens(j),2)<(profil.model(scattlinks(liens(j),1)).n)
                            voisinap=liens(j)+1;
                        else
                            voisinap=liens(j)-(profil.model(scattlinks(liens(j),1)).n)+2;
                        end

                    %je cherche a savoir si "av" et "ap" sont lies a struct, je regarde les liens de "av" et "ap"
                    liensvoisinavant=scattlinks(voisinavant,4+find(~isnan(scattlinks(voisinavant,5:15))));
                    liensvoisinap   =scattlinks(voisinap   ,4+find(~isnan(scattlinks(voisinap   ,5:15))));

                    if isempty(liensvoisinavant)
                            xtmp=[xtmp,scattlinks(voisinavant,3),xtmp(length(xtmp))];
                            ytmp=[ytmp,scattlinks(voisinavant,4),ytmp(length(ytmp))];
                            Itomove=[Itomove,0,1];
                    else
                        ok=1;
                        for av=1:length(liensvoisinavant)
                            if scattlinks(liensvoisinavant(av),1)==struct
                                ok=0;
                                break;
                            end
                        end
                        if ok==1
                            xtmp=[xtmp,scattlinks(voisinavant,3),xtmp(length(xtmp))];
                            ytmp=[ytmp,scattlinks(voisinavant,4),ytmp(length(ytmp))];
                            Itomove=[Itomove,0,1];
                        end
                    end
                    if isempty(liensvoisinap)
                            xtmp=[xtmp,scattlinks(voisinap,3),xtmp(length(xtmp))];
                            ytmp=[ytmp,scattlinks(voisinap,4),ytmp(length(ytmp))];
                            Itomove=[Itomove,0,1];
                    else
                        ok=1;
                        for ap=1:length(liensvoisinap)
                            if scattlinks(liensvoisinap(ap),1)==struct
                                ok=0;
                                break;
                            end
                        end
                        if ok==1
                            xtmp=[xtmp,scattlinks(voisinap,3),xtmp(length(xtmp))];
                            ytmp=[ytmp,scattlinks(voisinap,4),ytmp(length(ytmp))];
                            Itomove=[Itomove,0,1];
                        end
                    end
                 end
            end
       end
    end
    XINI=xtmp;
    YINI=ytmp;
    set(hlines,'Xdata',xtmp,'Ydata',ytmp,'visible','on')
    set(hmovepoints,'Xdata',xtmp(Itomove==1),'Ydata',ytmp(Itomove==1),'visible','on')
    set(hfixpoints,'Xdata',xtmp(Itomove==0),'Ydata',ytmp(Itomove==0),'visible','on')

disp([datestr(now),' : the system is busy'])
uiwait(windows.homefig.handle);
disp([datestr(now),' : terminated'])

%on rend les autres actions possibles
    fields=fieldnames(windows.homefig.menu);
    for field=1:length(fields)
        set(windows.homefig.menu.(fields{field}).parent,'enable','on')
    end
%retablissement des handles d'action
    %le handle de surface a été rétabli par refresh_profil, surtout ne pas y toucher ici
    %deplacer et poser la structure
    set(windows.homefig.handle,'windowbuttonmotionfcn',window__buttondown_saved);
    set(windows.homefig.handle,'windowbuttonupfcn',window__buttonup_saved);


    function attrapelastructure(src,evnt)
        %la fonction est appelée qd l'utilisateur clic sur la structure
        
        %le boutton est enfoncé
        clicdown=1;
        %recuperation des coordonnées de référence pour le déplacement=lieu du clic
        cp=get(gca,'currentpoint');
        xclicref=cp(1,1);
        yclicref=cp(1,2);
    end
    function deplacelastructure(src,evnt)
        if clicdown==0
            return
        end
        xtmp=get(hlines,'Xdata');
        ytmp=get(hlines,'Ydata');
        cp=get(gca,'currentpoint');
        xcurrent=cp(1,1);
        ycurrent=cp(1,2);
        xtmp(Itomove==1)=XINI(Itomove==1)+(xcurrent-xclicref);
        ytmp(Itomove==1)=YINI(Itomove==1)+(ycurrent-yclicref);
        set(windows.homefig.dlgbox1,'string',sprintf('x+: %+8.4f',xcurrent-xclicref),...
                                'Foregroundcolor','k')
        set(windows.homefig.dlgbox2,'string',sprintf('y+: %+8.4f',ycurrent-yclicref),...
                                'Foregroundcolor','k') 
        set(hlines,'Xdata',xtmp,'Ydata',ytmp);
        set(hmovepoints,'Xdata',xtmp(Itomove==1),'Ydata',ytmp(Itomove==1),'visible','on')
    end
    function poselastructure(src,evnt)
        if clicdown==0
            return
        end
        clicdown=0;
        cp=get(gca,'currentpoint');
        xcliclast=cp(1,1);
        ycliclast=cp(1,2);
        uiresume(windows.homefig.handle);
        if strcmp(questdlg('Do you want to apply this displacement?'),'Yes')
            for i=1:profil.model(struct).n-1
                liens=I_linkeds(i,find(~isnan(I_linkeds(i,1:size(I_linkeds,2)))));
                for j=liens
                    profil.model(scattlinks(j,1)).polyg(scattlinks(j,2),:)=...
                        profil.model(scattlinks(j,1)).polyg(scattlinks(j,2),:)+...
                        [xcliclast-xclicref,ycliclast-yclicref];
                end
            end
            profil=refresh_profil(windows,profil,{'model'});
            if session.saved==1
                session.saved=0;
                set(windows.homefig.handle,'name',[get(windows.homefig.handle,'name'),'*'])
            end
        else
            profil=refresh_profil(windows,profil,{'model'});
        end
        set(hlines,'visible','off')
        set(hmovepoints,'visible','off')
        set(hfixpoints,'visible','off')
        set(windows.homefig.dlgbox1,'string',[])
        set(windows.homefig.dlgbox2,'string',[]) 
    end
end



