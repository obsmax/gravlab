function xmesmode(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');

v = get(findobj(gravitombuttongroup,'tag', 'xmesmode'), 'value');

if v == 1%mode file
    warndlg('sorry, this property is not evailable yet')
    set(findobj(gravitombuttongroup,'tag', 'xmesmode'),'value',2)
    %set(findobj(gravitombuttongroup,'tag', 'xmesbrowse'),'enable','on');
    %set(findobj(gravitombuttongroup,'tag', 'xmesfile'),'enable','on',...
    %    'string', evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.xmesfile']));
    %xmesfile(ncurve);
else%mode linspace
    set(findobj(gravitombuttongroup,'tag', 'xmesbrowse'),'enable','off');
    str= [' linspace(0, ',...
                    num2str(evalin('base','profil.xmax;')),', ',...
                    num2str(evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.npts;'])),...
                    ');'];
    set(findobj(gravitombuttongroup,'tag', 'xmesfile'),'enable','off',...
        'string', str);
    evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.xmes = ',str]);
end