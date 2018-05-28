function bounds(ncurve)

    panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
    gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');
    button = findobj(gravitombuttongroup, 'tag', 'prolh');
    
    v = get(button, 'value');
    if v == 1 % 
        evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.prolh.activated=true;']);
    else
        evalin('base',['session.Xzfiles(',num2str(ncurve),').gravitom_options.prolh.activated=false;']);
    end

end