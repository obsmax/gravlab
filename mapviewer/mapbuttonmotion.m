function mapbuttonmotion
    fig = findobj('type','figure', 'name','mapviewer');
    ax = findobj(fig, 'type', 'axes');
    cp = get(ax, 'currentpoint');
    xmouse = cp(1,1);
    ymouse = cp(1,2);

    cursor = findobj(fig, 'tag', 'cursor');

    dlgbox1 = findobj(fig, 'tag', 'mapdlgbox1');
    dlgbox2 = findobj(fig, 'tag', 'mapdlgbox2');

	limx = get(ax, 'Xlim');
    limy = get(ax, 'Ylim');

    xmouse = min([max([xmouse, limx(1)]), limx(2)]);
    ymouse = min([max([ymouse, limy(1)]), limy(2)]);
    
    
    set(cursor, 'Xdata', [limx(1), xmouse, limx(2), xmouse], 'visible', 'on')
    set(dlgbox1,'string',sprintf('x : %+8.4f',xmouse),...
                                'Foregroundcolor','k')
                            
    set(cursor, 'Ydata', [ymouse, limy(1), ymouse, limy(2)], 'visible', 'on')
    set(dlgbox2,'string',sprintf('y : %+8.4f',ymouse),...
                                'Foregroundcolor','k')  

end