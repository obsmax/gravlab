function irecalXzfilenumber(ncurve)

    panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
    button = findobj(panel, 'tag', 'irecalXzfilenumber');
    irecalbutton = findobj(panel, 'tag', 'irecal');
    xzfilenumber = get(button, 'value');
    d = evalin('base', ['session.Xzfiles(',num2str(xzfilenumber),').data;']);
    if xzfilenumber == ncurve
        errordlg('you can''t scale a curve to it''s own mean')
        set(irecalbutton, 'value',0);
        evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.activated=false;'])
    elseif numel(d)==2
            if sum(abs(d-[0,0]))==0
                errordlg(sprintf('no data were assigned to curve %s', ...
                    evalin('base', ['session.Xzfiles(',num2str(xzfilenumber),').label;'])))
                set(irecalbutton, 'value',0);
                evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.activated=false;'])
            end
    end
    evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.Xzfilenumber=',num2str(xzfilenumber),';'])

end