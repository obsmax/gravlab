set(windows.curvefig.handle,...
    'closerequestfcn','default')
%verifier la sauvegarde???

close(windows.curvefig.handle)

windows.curvefig.handle=[];
try
set(windows.curveopenfig.handle,...
    'closerequestfcn','default')
end
try
close(windows.curveopenfig.handle)
set(windows.homefig.curvecursor.handle, 'visible','off')
windows.curveopenfig.handle=[];
end
