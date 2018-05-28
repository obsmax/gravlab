%debug.m
%a appliquer quand ca a planté et que les menus sont restés en position
%enable off

quest=sprintf(['This function will try to close all parallel applications, \n',...
    'restore the profile to its current state (variable profil in Matlab workspace),\n',...
    'and reactivate menus\n\n',...
    'Do you want to continue?']);
    
if ~strcmp(questdlg(quest),'Yes')
    return
end
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end
profil=refresh_profil(windows,profil,{'all'});

%% cleaning 
clear  quest fields field