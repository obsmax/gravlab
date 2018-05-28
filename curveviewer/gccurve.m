function Xzfilenumber = gccurve()
%renvoie le numéro de la courbe qui est affiché dans le curve manager
%en cherchant lequel des onglets est selectionné

fig = evalin('base', 'windows.curveopenfig.handle');
Xzfilenumber = str2num(get(findobj(fig, 'selected','on'),'tag')); %#ok<ST2NM>