function curvecolor(ncurve)

   panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
   button = findobj(panel, 'tag', 'color');
   try 
       c = str2num(get(button, 'string'));
       set(button, 'backgroundcolor', c,...
                   'foregroundcolor', 1-c);
   catch
       errordlg(sprintf('please specify a color using matlab syntax\na color is defined by its red-green-blue code : a 3-by-1 array of floats between 0 and 1'))
       c = defaultcurvcolor(ncurve);
       set(button, 'backgroundcolor', c,...
                   'foregroundcolor', 1-c);
   end
   
str = ['[ ', sprintf('%.1f  ', c(1)),sprintf('%.1f  ', c(2)),sprintf('%.1f', c(3)) ,' ]'];
evalin('base', ['session.Xzfiles(',num2str(ncurve),').color = ', str , ';']);
set(button, 'string', str)
refreshcurves({'color'}, ncurve)

end



