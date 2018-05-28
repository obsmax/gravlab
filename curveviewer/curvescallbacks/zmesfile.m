function zmesfile(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');
button = findobj(gravitombuttongroup, 'tag', 'zmesfile');

zmesmode = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmesmode;']);
npts = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.npts;']);
if strcmpi(zmesmode,'constant')
    zstr = get(button,'string');
    evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmes = ',zstr,'*ones(1,',num2str(npts),');']);
elseif strcmpi(zmesmode,'file')
end

end