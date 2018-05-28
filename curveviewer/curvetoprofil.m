%curvetoprofil
% affiche un curseur sur la fenêtre principale en fonction de la position
% de la sourie sur le curvviewer

cp = get(gca, 'currentPoint');
set(windows.homefig.curvecursor.handle,...
    'Xdata', cp(1,1)*ones(1,2),...
    'Ydata', get(findobj(windows.homefig.handle, 'type','axes'), 'Ylim'));
clear cp