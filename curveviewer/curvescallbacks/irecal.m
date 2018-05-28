function irecal(ncurve)

    panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
    button = findobj(panel, 'tag', 'irecal');
    v = get(button, 'value');
    
    if v %irecal is on
        xzfilenumber = evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.Xzfilenumber;']);
        d = evalin('base', ['session.Xzfiles(',num2str(xzfilenumber),').data;']);
        if xzfilenumber==ncurve
                errordlg('you can''t scale a curve to it''s own mean')
                set(button, 'value',0);
        elseif numel(d)==2
            if sum(abs(d-[0,0]))==0
                errordlg(sprintf('no data were assigned to curve %s', ...
                    evalin('base', ['session.Xzfiles(',num2str(xzfilenumber),').label;'])))
                set(button, 'value',0);
                return
            end
        end
        evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.activated=true;'])
    else
        evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.irecal.activated=false;'])
    end
end
