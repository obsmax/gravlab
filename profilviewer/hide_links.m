%hide_links

set(a.plot_handle ,'visible','off')
set(b.plot_handle ,'visible','off')
set(c.plot_handle ,'visible','off')
set(d.plot_handle ,'visible','off')
set(endbutton,'visible','off')

%% on rends les structures selectionnables a nouveau
%on fait un refresh profil même si les structures ont été déplacées aux fur
%et a mesure, ca permet entre autre de rendre les structures
%selectionnables a nouveau
profil=refresh_profil(windows,profil,{'model'});


%% on remet en place les menus
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end

set(windows.homefig.dlgbox,...
    'Foregroundcolor','k',...
    'string','')
%% clean up
clear field fields endbutton a b c d scattlinks Ia Ib Ic Id