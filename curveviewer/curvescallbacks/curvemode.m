function curvemode(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');

autorefreshbutton1 = findobj(gravitombuttongroup,'tag','txtautorefresh');
autorefreshbutton2 = findobj(gravitombuttongroup,'tag','autorefresh');

v = get(findobj(panel,'tag', 'mode'), 'value');
if v ==1%mode file
    set(get(gravitombuttongroup, 'children'), 'enable','off')
    set(findobj(panel,'tag', 'browse'), 'enable','on')
    set(findobj(panel,'tag', 'file'), 'enable','on')
    evalin('base', ['session.Xzfiles(',num2str(ncurve),').mode=''file'';'])
    refreshcurves({'file'},ncurve)
else%mode gravitom
    set(get(gravitombuttongroup, 'children'), 'enable','on')
    set(findobj(panel,'tag', 'browse'), 'enable','off')
    set(findobj(panel,'tag', 'file'), 'enable','off')
    evalin('base', ['session.Xzfiles(',num2str(ncurve),').mode=''gravitom'';'])
    set(autorefreshbutton1, 'enable','off');
    set(autorefreshbutton2, 'enable','off');

end

xmesmode(ncurve);
zmesmode(ncurve);
    