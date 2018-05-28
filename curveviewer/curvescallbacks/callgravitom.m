function callgravitom(ncurve)

xmes = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.xmes;']);
zmes = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.zmes;']);
    if isempty(zmes)
        errordlg('please specify an altitude')
        return
    end
irecal = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.activated;']);
    if irecal
        panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
        button = findobj(panel, 'tag', 'irecalXzfilenumber');
        Xzfilenumber = get(button, 'value');
        irecalmean = evalin('base', ['mean(session.Xzfiles(',num2str(Xzfilenumber),').data(:,2));'] );
    else
        irecalmean=NaN;
    end
prolh = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.prolh.activated;']);
    if prolh
        prolhdist = evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.prolh.distance;']);
    else
        prolhdist = NaN;
    end

g = gravitom_gravmanager(xmes, zmes, irecal, irecalmean, prolh, prolhdist);
evalin('base',['session.Xzfiles(',num2str(ncurve),').data = ', mat2str([xmes',g']),';']);
refreshcurves({'data','x'},ncurve)

end