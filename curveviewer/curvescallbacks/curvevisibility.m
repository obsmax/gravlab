function curvevisibility(ncurve)
   panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
   button = findobj(panel, 'tag', 'visibility');
   v = get(button, 'value');
   
   if v%visibility on
       evalin('base', ['session.Xzfiles(',num2str(ncurve),').visibility=''on'';'])
   else%visibility off
       evalin('base', ['session.Xzfiles(',num2str(ncurve),').visibility=''off'';'])
   end
refreshcurves({'visibility'}, ncurve)   

end
