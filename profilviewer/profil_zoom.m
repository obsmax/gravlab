%profil_zoom

%% blockage de toute autre action
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','off')
end


%% on deselectionne toutes les structures et on les rends non selectionnables + on empeche les menus de clic droit
block_structures(profil);
%refresh profil appelé en mode model se charge de rendre les structures
%selectionnables a nouveau

%%
%pour la fin de la fonction
endbutton=uimenu('label','|   ok');
set(endbutton,...
   'callback','profil_zoom_close');
zoom
set(windows.homefig.dlgbox,...
    'string','click ok to leave the zoom mode, double clic to unzoom',...
    'ForegroundColor','k')

