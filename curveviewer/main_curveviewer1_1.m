try
    a=session.HOME;clear a;
catch
    errordlg('please run gravlab as a parent application')
    return
end

%% gestion des fenetres de travail
try 
    figure(windows.curvefig.handle)
    return
end
windows.curvefig.handle=figure();
set(windows.curvefig.handle,...
        'units','normalized',...
        'position',[0.1492    0.5212    0.4375    0.3738],...
        'numbertitle','off',...
        'name','curveviewer',...
        'closerequestfcn','quit_curveviewer;',...
        'menubar','none',...
        'windowButtonMotionFcn','curvetoprofil;')

windows.curveopenfig.handle=[];
set(windows.homefig.curvecursor.handle, 'visible','on')

refreshcurves({'all'});
%% menus :
%1) File
windows.curvefig.menu.File.parent=uimenu('label','File','parent',windows.curvefig.handle);
    windows.curvefig.menu.File.curves=uimenu(windows.curvefig.menu.File.parent,...
                                'label','curves...',...
                                'callback','curves');                                
    windows.curvefig.menu.File.erasecurves=uimenu(windows.curvefig.menu.File.parent,...
                                'label','erase curves',...
                                'callback','erasecurves');       
    windows.curvefig.menu.File.quit=uimenu(windows.curvefig.menu.File.parent,...
                                'label','quit',...
                                'separator','on',...
                                'callback','quit_curveviewer',...
                                'accelerator','Q'); 
clear i









