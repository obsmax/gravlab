%move_in.m

%si il n'y a pas de structures
if isempty(profil.model)
    errordlg('no structures found')
    return
end

%% blockage de toute autre action
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','off')
end

%% on deselectionne toutes les structures et on les rends non selectionnables + on empeche les menus de clic droit
% for struct=1:length(profil.model)
%     set(profil.model(struct).fill_handle,...
%         'buttonDownFcn',[],...
%         'selected','off',...
%         'facecolor',[1 1 1],...
%         'uicontextmenu',[])
% end
block_structures(profil); %on ne devrais pas utiliser ca ici????me rappel plus
%refresh profil appelé en mode model se charge de rendre les structures
%selectionnables a nouveau


%% affichage des sommets-noeuds disponibles
for struct=1:length(profil.model)
    set(profil.model(struct).fill_handle,'marker','o','markeredgecolor','k','markerfacecolor','g')
end



%% on sauve les actions de clic avant de les remplacer
%sauvegarde des handle de callback a remettre a la fin
windowbuttondownfcn_save=get(windows.homefig.handle,'windowButtondownFcn');
windowbuttonmotionfcn_save=get(windows.homefig.handle,'windowButtonMotionFcn');
windowbuttonupfcn_save=get(windows.homefig.handle,'windowButtonUpFcn');

%% move ici
%profil=moveprofil_slide(windows,session,profil);
profil=moveprofil_notslide(windows,session,profil);
%profil=moveprofil_test(windows,session,profil);

%on rend la seesion non sauvegardée
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

%% on remet en place les menus
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end

%% on restaure les actions de clic
set(windows.homefig.handle,'windowButtondownFcn',windowbuttondownfcn_save);
set(windows.homefig.handle,'windowButtonMotionFcn',windowbuttonmotionfcn_save);
set(windows.homefig.handle,'windowButtonUpFcn',windowbuttonupfcn_save);


%% cleaning the workspace
clear fields field struct windowbuttondownfcn_save windowbuttonmotionfcn_save  windowbuttonupfcn_save