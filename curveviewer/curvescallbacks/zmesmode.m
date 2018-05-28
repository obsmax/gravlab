function zmesmode(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');

v = get(findobj(gravitombuttongroup,'tag', 'zmesmode'), 'value');

if v == 1%mode file
    warndlg('sorry, this property is not evailable yet')
    set(findobj(gravitombuttongroup,'tag', 'zmesmode'),'value',2)
    %set(findobj(gravitombuttongroup,'tag', 'zmesbrowse'),'enable','on');
    %set(findobj(gravitombuttongroup,'tag', 'zmesfile'),'enable','on');
    %evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmesmode=''file'';']);
    %set(findobj(gravitombuttongroup,'tag', 'zmesfile'),...
    %    'string', evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmesfile']));
else%mode constant
    set(findobj(gravitombuttongroup,'tag', 'zmesbrowse'),'enable','off');
    set(findobj(gravitombuttongroup,'tag', 'zmesfile'),'string',num2str(evalin('base', 'profil.zmax')+1));
    evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmesmode=''constant'';']);
    zmesfile(ncurve)
end