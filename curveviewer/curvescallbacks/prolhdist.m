function prolhdist(ncurve)


    panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
    button = findobj(panel, 'tag', 'distance');
    
    v=get(button,'string');
    
    evalin('base', ['session.Xzfiles(',num2str(ncurve),').gravitom_options.prolh.distance=',v,';'])

end