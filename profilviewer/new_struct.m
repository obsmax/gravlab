%new_struct.m

%% blockage de toute autre action
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','off')
end

%% on deselectionne toutes les structures et on les rends non selectionnables + on empeche les menus de clic droit
block_structures(profil);
%refresh profil appelé en mode model se charge de rendre les structures
%selectionnables a nouveau




%% affichage des sommets-noeuds disponibles
for struct=1:length(profil.model)
    %en vert si la correction sur sommet est active, en rouge sinon
    if strcmp(session.options.recentrage_sommet,'on')
        set(profil.model(struct).fill_handle,'marker','o','markeredgecolor','k','markerfacecolor','g')
    else
    	set(profil.model(struct).fill_handle,'marker','o','markeredgecolor','k','markerfacecolor','r')
    end
end




%% get des coordonnes,et update du profil
profil=getpolyg(windows,session,profil);






%% reactivation des autres actions
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end

%% on efface les noeuds dispo
for struct=1:length(profil.model)-1
    set(profil.model(struct).fill_handle,'marker','none')
end

%% rafraichissement de l ecran
%refresh profil appelé en mode model se charge de rendre les structures
%selectionnables a nouveau
profil=refresh_profil(windows,profil,{'model'});
set(windows.homefig.dlgbox1,'string','')
set(windows.homefig.dlgbox2,'string','')

%% on passe la session en mode unsaved pour avoir un message au cas ou l utilisateur veuille quitter
if session.saved==1
    session.saved=0;
    set(windows.homefig.handle,'name',[get(windows.homefig.handle,'name'),'*'])
end

%% cleaning the workspace
clear fields field struct scatt hlines hsummit