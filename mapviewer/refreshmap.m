function refreshmap()

windows = evalin('base','windows;');
session = evalin('base','session;');

figure(windows.mapfig.handle);
try
    if ~isempty(session.xyzfile.handle)
        set(session.xyzfile.handle, 'visible', 'off');
    end
end

hold off
set(gca, 'Xlimmode', 'auto', 'Ylimmode', 'auto')
try
    session.xyzfile.handle = pcolor(session.xyzfile.data.X,...
                session.xyzfile.data.Y,...
                session.xyzfile.data.Z);
	set(session.xyzfile.handle, 'visible', 'on');
    shading flat;
    axis square
end
hold on
set(gca, 'Xlimmode', 'manual', 'Ylimmode', 'manual')
windows.mapfig.cursor.handle = plot(zeros(1,4), zeros(1,4),...
    'k+', 'visible', 'off', 'tag', 'cursor');


assign;


%% ASSIGN IN MAIN WORKSPACE
    function assign
        assignin('base','windows',windows);
        assignin('base','session',session);
    end
%%
end