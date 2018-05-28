function profil=moveprofil_notslide(windows,session,profil)

%permet de deplacer des sommets avec ou non recentrage sur
    %-> les autres sommets
    %-> les autres segments
    %-> les bords du profil
    %-> le bottom profil
    %-> le top profil


    
%% généralités
%on se place dans la figure ppale, 
    figure(windows.homefig.handle)
    hold on
    set(gca,'Xlimmode','manual','Ylimmode','manual') %pour eviter que matlab resize le graphe tout seul

%attricution des handle d action
    set(windows.homefig.handle,'windowbuttondown',@clic) 
    set(windows.homefig.handle,'windowbuttonmotion',@movept)

%determination du nuage de point et du tableau de lien entre les points
    %colonne 1 : num de la structure dans profil.model
    %colonne 2 : num du sommet dans profil.model(colonne1).polyg
    %colonnes 3 et 4 : x et y du sommet
    %colonnes 5 a 15 : lignes de scattlinks où trouver les sommets correspondants, si NaN=> il n'y a pas de liens
    %clonne 16 : 1 pour le premier et le dernier sommet de la structure 0 sinon, car ces deux sommets sont liés
    scattlinks=find_links(profil,'sommet');

%determination du nuage de segment et des liens entre eux
    segscattlinks=find_links(profil,'segment');

%vaut 1 qand on est en deplacement 0 sinon
    clicdown=0;

%handle de graphique temporaire
    %handle de graphique pour montrer le point selectionné
    hselectedpoint=plot(0,0,'visible','off');
    %handle de graphique des lignes qui bougent qd le pt est selectionné
    hmovinglines=line('Xdata',[],'Ydata',[],'visible','off','linestyle','-','color','g');
    %handle des curseurs x
    hxcursor =plot(0,0,'Xdata',[],'Ydata',[],'marker','+','markeredgecolor','k','linestyle','none');
    %handle des curseurs y
    hycursor =plot(0,0,'Xdata',[],'Ydata',[],'marker','+','markeredgecolor','k','linestyle','none');

%boutton de fin de fonction
    endbutton=uimenu('label','|   ok',...
                    'callback',@findelafcn);

%boutton pour la saisie manuelle du point d'arrivée
    manualinput=uimenu('label','manual',...
                    'enable','off',...
                    'callback',@manualclic);

%variables communes aux sous fonction, doivent etre definie au moins une fois avant l'appel (c'est comme ca)
    %ligne de scattlinks indiquant le sommet selectionné
    I_nearest=NaN;
    %ligneS de scattlinks, I_nearest compris!!, indiquant les sommets liés a celui de I_nearest
    I_linked=NaN;
    

%% actions 
function clic(src,evnt)
%lorsqu'on clic sur la figure

%affichage de la consigne de base, ce message sera remplacé en cas de
%correction de clic
set(windows.homefig.dlgbox,'string','1st clic to select the summit, 2nd to release it',...
    'Foregroundcolor','k')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1) clic gauche de selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(get(src,'selectiontype'),'normal') && clicdown==0
        
    %nettoyage de sécurité
    clear I_linked I_nearest
        
    %recupération de l'éventuel point selectionné, on se sert des parametre de recentrage sur sommet
    cp=get(gca,'currentpoint');
    
    %vecteur de distance entre le point de clic et le nuage de sommets
    D_scatt_clic=Dscattclicpx(cp(1,[1,2]), scattlinks(:,[3,4]))';%sqrt((scattlinks(:,3)-cp(1,1)).^2+(scattlinks(:,4)-cp(1,2)).^2)';
    
    %calcul de la distance absolue de recentrage sur sommet 
    switch session.options.recentrage_sommet_units
        case {'pixels'}          
            recentrage_sommet_distance_pixels=session.options.recentrage_sommet_distance;
        otherwise
            error('')
    end
    
    %recherche des sommets qui satisfont au critere de proximité
    I_scatt_clic=find(D_scatt_clic <= recentrage_sommet_distance_pixels);
    
    %recherche de ceux qui sont le plus proche
    [D_scatt_clic_min,I_scatt_clic_min]=min(D_scatt_clic(I_scatt_clic));
    I_nearest=I_scatt_clic(I_scatt_clic_min);%I_nearest est tjrs un scalaire, le sommet selectionné est scattlinks(I_nearest,:)

    %si un point a été selectionné
    if ~isempty(I_nearest)
        
        %on passe en mode déplacement
        clicdown=1;
        
        %on plot en rouge le point selectionné
        set(hselectedpoint,'Xdata',scattlinks(I_nearest,3),'Ydata',scattlinks(I_nearest,4),'MarkerFaceColor','r','marker','o','visible','on')
        
        %on autorise la saise manuelle 
        set(manualinput,'enable','on')
    else 
        %sinon on interromp ici
        return
    end
    
    %recuperation des points liés au point de clic
    I_linked=[I_nearest,scattlinks(I_nearest,4+find(~isnan(scattlinks(I_nearest,5:15))))];
    
    %recuperations des segments qui ont une extremité = au point de clic
    for i=1:length(I_linked)
        %si on a pas a faire au premier sommet de la structure on lit celui d'avant           
        if scattlinks(I_linked(i),2)~=1
            set(hmovinglines,'Xdata',[get(hmovinglines,'Xdata'),scattlinks(I_linked(i)-1,3),scattlinks(I_nearest,3)],...
                             'Ydata',[get(hmovinglines,'Ydata'),scattlinks(I_linked(i)-1,4),scattlinks(I_nearest,4)],'visible','on')
        else 
            %on lit l'avant dernier ie le point + (le nombre de sommet-1)-1
            set(hmovinglines,'Xdata',[get(hmovinglines,'Xdata'),scattlinks(I_linked(i)+profil.model(scattlinks(I_linked(i),1)).n-2,3),scattlinks(I_nearest,3)],...
                             'Ydata',[get(hmovinglines,'Ydata'),scattlinks(I_linked(i)+profil.model(scattlinks(I_linked(i),1)).n-2,4),scattlinks(I_nearest,4)],'visible','on')            
        end
        %si on a pas a faire au dernier sommet de la structure on lit celui d'apres
        if scattlinks(I_linked(i),2)~=profil.model(scattlinks(I_linked(i),1)).n
            set(hmovinglines,'Xdata',[get(hmovinglines,'Xdata'),scattlinks(I_linked(i)+1,3),scattlinks(I_nearest,3)],...
                             'Ydata',[get(hmovinglines,'Ydata'),scattlinks(I_linked(i)+1,4),scattlinks(I_nearest,4)],'visible','on')
        else 
            %on lit le premier sommet de la structure +1 ie on lit le sommet courant -(le nombre de sommet de la structure -1 )+1
            set(hmovinglines,'Xdata',[get(hmovinglines,'Xdata'),scattlinks(I_linked(i)-profil.model(scattlinks(I_linked(i),1)).n+2,3),scattlinks(I_nearest,3)],...
                             'Ydata',[get(hmovinglines,'Ydata'),scattlinks(I_linked(i)-profil.model(scattlinks(I_linked(i),1)).n+2,4),scattlinks(I_nearest,4)],'visible','on')            
        end
    end
    
else %clic gauche de deplacement ou droit pour la deselection
    
    %on efface les traits de construction et on quitte le mode déplacement on interdit la saise manuelle
    clicdown=0;
    set(hselectedpoint,'visible','off')    
    set(hmovinglines,'Xdata',[],'Ydata',[],'visible','off')
    set(manualinput,'enable','off')
    
    if strcmp(get(src,'selectiontype'),'normal')
        %on get la position du déclic et on modifie les structures
        cp=get(gca,'currentpoint');
        xsourie=cp(1,1);
        ysourie=cp(1,2);
        
        %corrections de clics
        clear isdiff
        [xsourie,ysourie,isdiff]=corrigeclic(xsourie,ysourie,windows,session,profil,'deplacement');
        
        %si le recentrage a eu lieu sur le point en cours de déplacement, j'annule la correction
        if length(isdiff)>=2
            if strcmp(isdiff{1},'som')
                if ~isempty(find(scattlinks(I_linked,1)==isdiff{2})) && ~isempty(find(scattlinks(I_linked,2)==isdiff{3}))
                    set(windows.homefig.dlgbox,'string','');%corrigeclic a annocé un recentrage
                    isdiff={};
                    xsourie=cp(1,1);
                    ysourie=cp(1,2);
                end  
            end
        end
        
        %de meme si le recentrage c'est produit sur l'un des segments impliquant le point a deplacer, j'annule la correction
        if length(isdiff)>=2
            if strcmp(isdiff{1},'seg')
                segscattlinks=find_links(profil,'segment');%mise a jour car profil change a chaque recentrage sur segment
                %je retrouve dans segscattlinks le segment hote
                %si l'une de ses extremites est le point selectionné ou l'un de ses lien...
                clear I_seghote
                I_seghote=find(segscattlinks(:,1)==isdiff{2} & segscattlinks(:,2)==isdiff{3});
                %extremites : segscattlinks(I_seghote,[3,4,6,7])
                xA=segscattlinks(I_seghote,3);
                yA=segscattlinks(I_seghote,4);
                xB=segscattlinks(I_seghote,6);
                yB=segscattlinks(I_seghote,7);
                if (~isempty(find(xA==scattlinks(I_linked,3))) && ~isempty(find(yA==scattlinks(I_linked,4)))) || (~isempty(find(xB==scattlinks(I_linked,3))) && ~isempty(find(yB==scattlinks(I_linked,4))))
                    set(windows.homefig.dlgbox,'string',[]);
                    isdiff={};
                    xsourie=cp(1,1);
                    ysourie=cp(1,2);
                end
            end
        end
                
        %on interdit la fusion de deux sommet de la meme structure et le recentrage d'un sommet sur un segment de sa propre structure
        if length(isdiff)>=2
            if strcmp(isdiff{1},'som')
                %si l'utilisateur essai de fusionner 2 sommets de la meme structure
                if ~isempty(find(scattlinks(I_linked,1)==isdiff{2}))
                    errordlg('Merging two summit of the same structure is not allowed')
                    return
                end
            elseif strcmp(isdiff{1},'seg')
                segscattlinks=find_links(profil,'segment');%mise car profil change a chaque recentrage sur segment
                clear I_seghote
                %je recher la ligne de seglinks qui decrit le segment sur lequel je me recentre
                I_seghote=find(segscattlinks(:,1)==isdiff{2} & segscattlinks(:,2)==isdiff{3});
                %ce segment appartient il a ma structure ou est il lié a un segment de ma structure?
                if ~isempty(find(segscattlinks(I_seghote,1)==scattlinks(I_linked,1)))
                    errordlg('You cannot merge a summit with a segment of the same structure')
                    return
                elseif ~isnan(segscattlinks(I_seghote,8))
                    if ~isempty(find(segscattlinks(segscattlinks(I_seghote,8),1)==scattlinks(I_linked,1)))
                        errordlg('You cannot merge a summit with a segment of the same structure')
                        return
                    end
                end               
            end
        end
        
        
        %normalement I_linked contient les lignes de scattlinks concernées par la modif
        %MODIF des VALEURS de scattlinks, profil, et des handle de graph...
        scattlinks(I_linked,3)=xsourie;
        scattlinks(I_linked,4)=ysourie;
        for i=1:length(I_linked)
            profil.model(scattlinks(I_linked(i),1)).polyg(scattlinks(I_linked(i),2),1)=xsourie;
            profil.model(scattlinks(I_linked(i),1)).polyg(scattlinks(I_linked(i),2),2)=ysourie;
            set(profil.model(scattlinks(I_linked(i),1)).fill_handle,...
                'Xdata',profil.model(scattlinks(I_linked(i),1)).polyg(:,1),...
                'Ydata',profil.model(scattlinks(I_linked(i),1)).polyg(:,2))
        end

        

        if ~isempty(isdiff)
            %si il ya eu recentrage sur sommet il faut mettre a jour
            %completement scattlinks pour que le nouveau lien soit pris en compte
            if strcmp(isdiff{1},'som')
                clear scattlinks
                scattlinks=find_links(profil,'sommet');
            end
        
            %si il y a eu recentrage sur segment on doit creer le nouveux point
            %sur la structure accueillante et mettre tout a jour            
            if strcmp(isdiff{1},'seg')
                profil.model(isdiff{2}).polyg=insert_pt(profil.model(isdiff{2}).polyg,isdiff{3},[xsourie,ysourie]);
                profil.model(isdiff{2}).n=size(profil.model(isdiff{2}).polyg,1);
                tmp_nearest=scattlinks(I_nearest,[1,3,4]);%pour retrouver notre point selectionne apres l'update de scattlinks
                clear scattlinks I_nearest I_linked I_nearest_multiple
                scattlinks=find_links(profil,'sommet');
                I_nearest_multiple=find(scattlinks(:,1)==tmp_nearest(1) & scattlinks(:,3)==tmp_nearest(2) & scattlinks(:,4)==tmp_nearest(3));
                I_nearest=I_nearest_multiple(1);
                I_linked=[I_nearest,scattlinks(I_nearest,4+find(~isnan(scattlinks(I_nearest,5:15))))];
            end
        end


        
        
    end
end
end
function manualclic(src,evnt)
    %pareil qu'un clic gauche de confirmation mais on demande les
    %coordonnées manuellement
    answer=inputdlg({['new x coordinate (',profil.units,')'],...
                 ['new z coordinate (',profil.units,') ']},...
                 'new point coordinates',1,...
                 {num2str(scattlinks(I_nearest,3)),num2str(scattlinks(I_nearest,4))});
	%si cancel
    if isempty(answer)
        clear answer;
        return
    end

    xsourie=str2num(answer{1});
    ysourie=str2num(answer{2});
    
    [xsourie_corrected,ysourie_corrected,isdiff]=corrigeclic(xsourie,ysourie,windows,session,profil,'deplacement');
    
    %si le recentrage a eu lieu sur le point en cours de déplacement, j'annule la correction
    if length(isdiff)>=2
        if strcmp(isdiff{1},'som')
            if ~isempty(find(scattlinks(I_linked,1)==isdiff{2})) && ~isempty(find(scattlinks(I_linked,2)==isdiff{3}))
                set(windows.homefig.dlgbox,'string','');%corrigeclic a annocé un recentrage
                isdiff={};
            end  
        end
    end
    
    %de meme si le recentrage c'est produit sur l'un des segments impliquant le point a deplacer, j'annule la correction
    if length(isdiff)>=2
        if strcmp(isdiff{1},'seg')
            segscattlinks=find_links(profil,'segment');%mise a jour car profil change a chaque recentrage sur segment
            %je retrouve dans segscattlinks le segment hote
            %si l'une de ses extremites est le point selectionné ou l'un de ses lien...
            clear I_seghote
            I_seghote=find(segscattlinks(:,1)==isdiff{2} & segscattlinks(:,2)==isdiff{3});
            %extremites : segscattlinks(I_seghote,[3,4,6,7])
            xA=segscattlinks(I_seghote,3);
            yA=segscattlinks(I_seghote,4);
            xB=segscattlinks(I_seghote,6);
            yB=segscattlinks(I_seghote,7);
            if (~isempty(find(xA==scattlinks(I_linked,3))) && ~isempty(find(yA==scattlinks(I_linked,4)))) || (~isempty(find(xB==scattlinks(I_linked,3))) && ~isempty(find(yB==scattlinks(I_linked,4))))
                set(windows.homefig.dlgbox,'string',[]);
                isdiff={};
            end
        end
    end
    
    %on interdit la fusion de deux sommet de la meme structure et le recentrage d'un sommet sur un segment de sa propre structure
    if length(isdiff)>=2
        if strcmp(isdiff{1},'som')
            %si l'utilisateur essai de fusionner 2 sommets de la meme structure
            if ~isempty(find(scattlinks(I_linked,1)==isdiff{2}))
                errordlg('WOW! there is already a summit at that place!!!')
                return
            end
        elseif strcmp(isdiff{1},'seg')
            segscattlinks=find_links(profil,'segment');%mise a jour car profil change a chaque recentrage sur segment
            clear I_seghote
            %je recher la ligne de seglinks qui decrit le segment sur lequel je me recentre
            I_seghote=find(segscattlinks(:,1)==isdiff{2} & segscattlinks(:,2)==isdiff{3});
            %ce segment appartient il a ma structure ou est il lié a un segment de ma structure?
            if ~isempty(find(segscattlinks(I_seghote,1)==scattlinks(I_linked,1)))
                errordlg('NO!You entered a point belonging to a segment of the same structure as the summit to move')
                return
            elseif ~isnan(segscattlinks(I_seghote,8))
                if ~isempty(find(segscattlinks(segscattlinks(I_seghote,8),1)==scattlinks(I_linked,1)))
                    errordlg('NO!You entered a point belonging to a segment of the same structure as the summit to move')
                    return
                end
            end
        end
    end
    
    if ~isempty(isdiff)
        rep=questdlg(sprintf('You entered :\n    x=%f\n    y=%f\nthe input correction mode is going to correct it to :\n    x=%f\n    y=%f\n\n-> Clic "Yes" to allow this correction\n-> Clic "No" to force\n->Clic "Cancel" to go back to mouse\n',xsourie,ysourie,xsourie_corrected,ysourie_corrected));
        if strcmp(rep,'Yes')
            xsourie=xsourie_corrected;
            ysourie=ysourie_corrected;
        elseif strcmp(rep,'Cancel') || isempty(rep)
            clear rep xsourie ysourie
            return
        end
    end
    clear rep
    

    
    %on efface les traits de construction et on relève le crayon on
    %interdit la saise manuelle
    clicdown=0;
    set(hselectedpoint,'visible','off')    
    set(hmovinglines,'Xdata',[],'Ydata',[],'visible','off')
    set(manualinput,'enable','off') 
    
    %normalement I_linked contient les lignes de scattlinks concernées par la modif
    %addaptation de scattlinks, profil, et des handle de graph...
    scattlinks(I_linked,3)=xsourie;
    scattlinks(I_linked,4)=ysourie;
    for i=1:length(I_linked)
        profil.model(scattlinks(I_linked(i),1)).polyg(scattlinks(I_linked(i),2),1)=xsourie;
        profil.model(scattlinks(I_linked(i),1)).polyg(scattlinks(I_linked(i),2),2)=ysourie;
        set(profil.model(scattlinks(I_linked(i),1)).fill_handle,...
            'Xdata',profil.model(scattlinks(I_linked(i),1)).polyg(:,1),...
            'Ydata',profil.model(scattlinks(I_linked(i),1)).polyg(:,2))
    end

    
    if ~isempty(isdiff)
        %si il ya eu recentrage sur sommet il faut mettre a jour
        %completement scattlinks pour que le nouveau lien soit pris en compte
        if strcmp(isdiff{1},'som')
            clear scattlinks
            scattlinks=find_links(profil,'sommet');
        end

        %si il y a eu recentrage sur segment on doit creer le nouveux point
        %sur la structure accueillante et mettre tout a jour            
        if strcmp(isdiff{1},'seg')
            profil.model(isdiff{2}).polyg=insert_pt(profil.model(isdiff{2}).polyg,isdiff{3},[xsourie,ysourie]);
            profil.model(isdiff{2}).n=size(profil.model(isdiff{2}).polyg,1);
            tmp_nearest=scattlinks(I_nearest,[1,3,4]);%pour retrouver notre point selectionne apres l'update de scattlinks
            clear scattlinks I_nearest I_linked I_nearest_multiple
            scattlinks=find_links(profil,'sommet');
            I_nearest_multiple=find(scattlinks(:,1)==tmp_nearest(1) & scattlinks(:,3)==tmp_nearest(2) & scattlinks(:,4)==tmp_nearest(3));
            I_nearest=I_nearest_multiple(1);
            I_linked=[I_nearest,scattlinks(I_nearest,4+find(~isnan(scattlinks(I_nearest,5:15))))];
        end
    end
    
end


function movept(src,evnt)
    cp=get(gca,'currentpoint');
    xsourie=cp(1,1);
    ysourie=cp(1,2);
    
    %dès le lancement on veut voir les coordonnees mouvantes et les
    %curseurs
    set(windows.homefig.dlgbox1,'string',sprintf('x : %+8.4f',xsourie),...
                                'Foregroundcolor','k')
    set(windows.homefig.dlgbox2,'string',sprintf('y : %+8.4f',ysourie),...
                                'Foregroundcolor','k')
    set(hxcursor,'Xdata',[xsourie,xsourie],...
                 'Ydata',ylim(gca))
    set(hycursor,'Xdata',xlim(gca),...
                 'Ydata',[ysourie,ysourie])
             
    if clicdown~=1
        return        
    end

    clear xtmp ytmp
    %1 point sur 2 des données de hmovinglines doit etre le point de clic=>
    %c'est ces valeurs qu'on doit mettre a jour
    xtmp=get(hmovinglines,'Xdata');
    ytmp=get(hmovinglines,'Ydata');
    xtmp(2:2:length(xtmp))=xsourie*ones(1,length(2:2:length(xtmp)));
    ytmp(2:2:length(ytmp))=ysourie*ones(1,length(2:2:length(ytmp)));
    set(hmovinglines,'Xdata',xtmp,'Ydata',ytmp)
end

function findelafcn(src,evnt)
    set(hxcursor,'visible','off');
    set(hycursor,'visible','off');
    set(endbutton,'visible','off');
    set(manualinput,'visible','off')
    if clicdown==1 %au cas ou le gars quitte en plein deplacement
        clicdown=0;
        set(hselectedpoint,'visible','off')    
        set(hmovinglines,'Xdata',[],'Ydata',[],'visible','off')
    end
    uiresume(gcf);
end

uiwait
end





