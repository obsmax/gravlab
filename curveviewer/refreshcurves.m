function refreshcurves(mode, curvenumbers)


windows = evalin('base','windows;');
session = evalin('base','session;');    
if nargin < 2
    curvenumbers = 1:length(session.Xzfiles);
end

homeaxes = findobj(windows.homefig.handle, 'type','axes');
homeaxes = homeaxes(1);%in case of multi axes
figure(windows.curvefig.handle)
set(gca,'units',get(homeaxes,'units'), 'position', get(homeaxes, 'position'))
box on
hold on


if strcmp(mode{1},'all')
    refresh_handles;
%     refresh_file;
%     refresh_visibility;
%     refresh_x;
%     refresh_color;
    assign;
else
    for i =1 : length(mode)
        try
            eval(['refresh_',mode{i}])
        catch
            warning('unkown refresh mode : %s\n',mode{i})
        end
        assign;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function refresh_handles
        hold off
        for iii = curvenumbers
            session.Xzfiles(iii).handle = plot(...
                    session.Xzfiles(iii).data(:,1),...
                    session.Xzfiles(iii).data(:,2),...
                    'color',session.Xzfiles(iii).color,...
                    'visible',session.Xzfiles(iii).visibility);
                if iii ==curvenumbers(1); hold on; end
        end
    end
    function refresh_x
        set(gca, 'xlim',[0,evalin('base','profil.xmax;')])
    end
    function refresh_file
        for iii = curvenumbers
            if strcmp(session.Xzfiles(iii).mode,'file')
                if ~isempty(session.Xzfiles(iii).file)
                    [a,err] = readXz(session.Xzfiles(iii).file);
                    if err 
                        session.Xzfiles(iii).file = '';
                        session.Xzfiles(iii).data = [0,0];
                    else
                        session.Xzfiles(iii).data=a;
                        set(session.Xzfiles(iii).handle,...
                            'Xdata', a(:,1),...
                            'Ydata', a(:,2));
                    end
                else
                    session.Xzfiles(iii).data = [0,0];
                    set(session.Xzfiles(iii).handle,...
                            'Xdata', 0,...
                            'Ydata', 0);
                end
            end
        end
    end
    
    function refresh_visibility
        for iii = curvenumbers
            set(session.Xzfiles(iii).handle,...
                'visible',session.Xzfiles(iii).visibility)
        end 
    end
    function refresh_data
        for iii = curvenumbers
            set(session.Xzfiles(iii).handle,...
                'Xdata',session.Xzfiles(iii).data(:,1),...
                'Ydata',session.Xzfiles(iii).data(:,2))
        end 
    end
    function refresh_color
        for iii = curvenumbers
            set(session.Xzfiles(iii).handle,...
                'color',session.Xzfiles(iii).color)
        end         
    end
    function assign
        assignin('base','session',session);
    end
end