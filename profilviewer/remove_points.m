%remove_points.m


%% blockage de toute autre action
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','off')
end


%% on deselectionne toutes les structures et on les rends non selectionnables + on empeche les menus de clic droit
block_structures(profil);

%% affichage des sommets-noeuds disponibles
for struct=1:length(profil.model)
    set(profil.model(struct).fill_handle,'marker','o','markeredgecolor','k','markerfacecolor','g')
end

%% on sauve les actions de clic avant de les remplacer
%sauvegarde des handle de callback a remettre a la fin
windowbuttondownfcn_save=get(windows.homefig.handle,'windowButtondownFcn');


%% remove ici
profil=remove_points_func(windows,session,profil);
%on rend la session non sauvegardée
if session.saved==1
    session.saved=0;
    set(windows.homefig.handle,'name',[get(windows.homefig.handle,'name'),'*'])
end



%% on efface les noeuds dispo
for struct=1:length(profil.model)
    set(profil.model(struct).fill_handle,'marker','none')
end
%% on rends les structures selectionnables a nouveau
%on fait un refresh profil même si les structures ont été déplacées aux fur
%et a mesure, ca permet entre autre de rendre les structures
%selectionnables a nouveau
profil=refresh_profil(windows,profil,{'model'});
set(windows.homefig.dlgbox1,'string','')
set(windows.homefig.dlgbox2,'string','')



%% on remet en place les menus et les actoins de clic
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end
set(windows.homefig.handle,'windowButtondownFcn',windowbuttondownfcn_save);





%% cleaning the workspace
clear scattlinks windowbuttondownfcn_save field fields struct