function chnpts(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');
button = findobj(gravitombuttongroup, 'tag', 'npts');

newnpts = get(button,'string');

evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.npts = ',newnpts,';'])
xmesmode(ncurve);
zmesmode(ncurve);
end