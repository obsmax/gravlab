function browsecurve(ncurve)

   panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
   filebutton = findobj(panel, 'tag', 'file');

    [file, path] = uigetfile('*.Xz', 'open a curve data file');
    if file == 0
        return
    end
    file = [path, file];
    evalin('base', ['session.Xzfiles(',num2str(ncurve),').file=''',file,''';'])
    set(filebutton, 'string', file)
    refreshcurves({'file'}, ncurve)
end
