function helpdlgwait(varargin)

h = helpdlg(varargin);
childs = get(h,'Children');
for i =1:length(childs)
    if strcmp(get(childs(i),'type'),'uicontrol')
        if strcmp(get(childs(i),'string'),'OK')
            set(childs(i),'callback', {@newokcallback,get(childs(i),'callback')});
            uiwait(h);
        end
    end
end


function newokcallback(src,evnt,oldcallback)
    uiresume(h);
    eval(oldcallback);
end 

end