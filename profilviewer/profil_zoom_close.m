%profil_zoom_close

% reactivation des autres actions
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end

set(windows.homefig.dlgbox,...
    'string','');

zoom off;
set(endbutton,'visible','off');
profil=refresh_profil(windows,profil,{'model'});
clear endbutton fields