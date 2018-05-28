function newsection()

fig = evalin('base', 'windows.mapfig.handle;');
figure(fig);
hold on

WindowButtonDownFcnSave = get(fig, 'WindowButtonDownFcn');
WindowButtonMotionFcnSave = get(fig, 'WindowButtonMotionFcn');


menus = findobj(fig, 'type', 'uimenu');
set(menus, 'enable', 'off');

N = inputdlg('NPTS?', 'choose number of values to extract',1, {'100'});
N = str2num(N{1});

xclic = [];
yclic = [];
hclicpoints = plot(0,0, 'ko-', 'visible', 'off');
hmovingline = plot(0,0, 'k', 'visible', 'off');
startsec = true;

set(fig, 'WindowButtonDownFcn', {@clic})
set(fig, 'WindowButtonMotionFcn', {@move})

    function clic(src, evnt)
        cp= get(gca, 'currentPoint');
        xclic = cp(1,1);
        yclic = cp(1,2);        
        clicdroit = strcmp(get(src,'selectiontype'), 'alt');
        if clicdroit
            set(hclicpoints, 'visible', 'on',...
                'Xdata',...
                [get(hclicpoints, 'Xdata'), xclic],...
                 'Ydata',...
                [get(hclicpoints, 'Ydata'), yclic]);
            drawnow();
            uiresume();
            return
        end
        if startsec
            set(hclicpoints, 'visible', 'on',...
                'Xdata', [xclic], 'Ydata', [yclic]);
            startsec=false;
        else    
            set(hclicpoints, 'visible', 'on',...
                'Xdata',...
                [get(hclicpoints, 'Xdata'), xclic],...
                 'Ydata',...
                [get(hclicpoints, 'Ydata'), yclic]);
        end
    end
    function move(src, evnt)
        feval(WindowButtonMotionFcnSave)
        if isempty(xclic) || isempty(yclic)
            return
        end
        cp = get(gca, 'currentPoint');
        set(hmovingline, 'visible', 'on' ,...
            'Xdata', [xclic, cp(1,1)],...
            'Ydata', [yclic, cp(1,2)])
    end



uiwait(fig);
%% FINISH
X = evalin('base', 'session.xyzfile.data.X');
Y = evalin('base', 'session.xyzfile.data.Y'); 
Z = evalin('base', 'session.xyzfile.data.Z');
lon = get(hclicpoints, 'Xdata');
lat = get(hclicpoints, 'Ydata');
[x,y,d,z, Dangle] = coo2sec(lon, lat, N,X,Y,Z);
% lon
% lat
% [x',y',d',z']

figtmp = figure();
plot(d, z)
hold on
for i = 1 : length(Dangle);
    plot(Dangle(i)*[1,1], ylim(), 'k')
end


set(menus, 'enable', 'on');
set(fig, 'WindowButtonDownFcn', WindowButtonDownFcnSave);
set(fig, 'WindowButtonMotionFcn', WindowButtonMotionFcnSave);

end

