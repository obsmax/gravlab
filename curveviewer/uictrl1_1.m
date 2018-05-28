function handle = uictrl1_1(varargin)

%ML 2012
% handle = uictrl(propertyname, propertyvalue,...)
% generates a uicontrol object by attribuating propertyvalues to
% propertynames.
% availabe properties are all uicontrol properties, 
% see uicontrol properties in Matlab documentation
% additional properties are :
%    lowerleftalignment : 
%        {'lowerleft'} | 'lowerright' | 'upperleft' | upperright
%        defines which corner of the parent object to use as a reference 
%        for the lowerleft corner of the uictrl object
%    upperrightalignment : 
%        {'lowerleft'} | 'lowerright' | 'upperleft' | upperright
%        defines which corner of the parent object to use as a reference 
%        for the upperright corner of the uictrl object
%    lowerleftxposition : 
%        {'fixed'} | 'normalized' 
%        if fixed, the distance between the lowerleft corner of the uictrl
%        object and the lowerleftalignment corner is keept constant.
%        if normalized, this distance varies depending on the parent width
%    lowerleftyposition : 
%        {'fixed'} | 'normalized'
%    upperrightxposition : 
%        {'fixed'} | 'normalized' 
%    upperrightyposition : 
%        {'fixed'} | 'normalized' 
%
%this function operates by modifying the resizefcn property of the parent 
%object.

h = struct();
newproperties.names = {...
    'lowerleftalignment', 'h.userdata.resizerule.lowerleft.alignment';...
    'lowerleftxposition', 'h.userdata.resizerule.lowerleft.xposition';...
    'lowerleftyposition', 'h.userdata.resizerule.lowerleft.yposition';...
    'upperrightalignment','h.userdata.resizerule.upperright.alignment';...
    'upperrightxposition','h.userdata.resizerule.upperright.xposition';...
    'upperrightyposition','h.userdata.resizerule.upperright.yposition'};
newproperties.default = {...
    'lowerleft'; ...
    'fixed'; ...
    'fixed'; ...
    'lowerleft';...
    'fixed';...
    'fixed'};    
%attribution des defauts
for i = 1 :size(newproperties.names,1)
    eval([newproperties.names{i,2}, '=', '''', newproperties.default{i} , ''';']);
end
if ~sum(strcmpi(varargin, 'parent'))
    h.parent = gcf();
end


%attribution des propriétés
for i = 1:2:length(varargin)
    I = strcmpi(varargin{i}, newproperties.names);
    if ~sum(I)%cas des propriétés usuelles de uicontrol
        h.(varargin{i}) = varargin{i+1};
    else %cas des propriétés additionnelles
        eval([newproperties.names{I,2}, '=', '''', varargin{i+1}, ''';']);
    end
end


handle = makebutton(h);



end




function handle = makebutton(h)

    handle = uicontrol('parent',h.parent);%
    f = fieldnames(h);
    %je veux que units vienne avant position, je la met tout de suite
    if sum(strcmpi(f, 'units'))
        set(handle, 'units', h.units);
    end

    for i = 1:length(f)
        if strcmpi(f{i},'userdata') || strcmpi(f{i},'units')
            continue
        end
        set(handle, f{i}, h.(f{i}))
    end
    h.userdata.initialparentpixelposition = getpixelposition(h.parent);
    h.userdata.initialpixelposition = getpixelposition(handle);
    set(handle, 'userdata', h.userdata);


    
    
    %on ajoute des instructions a la resizefcn du parent (src) en ce qui
    %concerne l'enfant h.handle
    fcn = get(h.parent, 'resizefcn');
    if isa(fcn, 'function_handle')
        set(h.parent, 'resizefcn', @FCN)
    elseif isa(fcn, 'cell')
        set(h.parent, 'resizefcn', @CELLFCN)
    elseif isa(fcn,'char')
        set(h.parent, 'resizefcn', @STRFCN)
    end
     
    %ajout à la resizefcn parentale de la partie concernant l'enfant
    function FCN(src, evnt)
        resizectrl()
        feval(fcn);
    end
    function CELLFCN(src, evnt)
        resizectrl()
        feval(fcn{1}, [],[], fcn{2:length(fcn)}) 
    end
    function STRFCN(src, evnt)
        resizectrl()
        eval(fcn) 
    end

	function resizectrl(src, evnt)
        P = getpixelposition(h.parent);
        Pip = h.userdata.initialparentpixelposition;
        ip = h.userdata.initialpixelposition;
        lowerleft = h.userdata.initialpixelposition(1:2);
        upperright = lowerleft + h.userdata.initialpixelposition(3:4);
        %position du coin lower left
        if strcmpi(h.userdata.resizerule.lowerleft.alignment, 'upperleft') || strcmpi(h.userdata.resizerule.lowerleft.alignment, 'lowerleft')
            if strcmpi(h.userdata.resizerule.lowerleft.xposition, 'fixed')
                lowerleft(1) = ip(1);
            elseif strcmpi(h.userdata.resizerule.lowerleft.xposition, 'normalized')
                lowerleft(1) = P(3) * ip(1) / Pip(3);
            end
        elseif strcmpi(h.userdata.resizerule.lowerleft.alignment, 'upperright') || strcmpi(h.userdata.resizerule.lowerleft.alignment, 'lowerright')
            if strcmpi(h.userdata.resizerule.lowerleft.xposition, 'fixed')
                lowerleft(1) = P(3) -(Pip(3) - ip(1)); 
            elseif strcmpi(h.userdata.resizerule.lowerleft.xposition, 'normalized')
                lowerleft(1) = P(3) * ip(1) / Pip(3);
            end
        end
        if strcmpi(h.userdata.resizerule.lowerleft.alignment, 'upperleft') || strcmpi(h.userdata.resizerule.lowerleft.alignment, 'upperright')
            if strcmpi(h.userdata.resizerule.lowerleft.yposition, 'fixed')
                lowerleft(2) = P(4) - (Pip(4) - ip(2));
            elseif strcmpi(h.userdata.resizerule.lowerleft.yposition, 'normalized')
                lowerleft(2) = P(4) * ip(2) / Pip(4); 
            end
        elseif strcmpi(h.userdata.resizerule.lowerleft.alignment, 'lowerleft') || strcmpi(h.userdata.resizerule.lowerleft.alignment, 'lowerright')
            if strcmpi(h.userdata.resizerule.lowerleft.yposition, 'fixed')
                lowerleft(2) = ip(2);
            elseif strcmpi(h.userdata.resizerule.lowerleft.yposition, 'normalized')
                lowerleft(2) = P(4) * ip(2) / Pip(4);
            end
        end
        %position du coin upperright
        if strcmpi(h.userdata.resizerule.upperright.alignment, 'upperleft') || strcmpi(h.userdata.resizerule.upperright.alignment, 'lowerleft')
            if strcmpi(h.userdata.resizerule.upperright.xposition, 'fixed')
                upperright(1) = ip(1) + ip(3);
            elseif strcmpi(h.userdata.resizerule.upperright.xposition, 'normalized')
                upperright(1) = P(3) * (ip(1) + ip(3)) / Pip(3);
            end
        elseif strcmpi(h.userdata.resizerule.upperright.alignment, 'upperright') || strcmpi(h.userdata.resizerule.upperright.alignment, 'lowerright')
            if strcmpi(h.userdata.resizerule.upperright.xposition, 'fixed')
                upperright(1) = P(3) -(Pip(3) - ip(1) - ip(3));
            elseif strcmpi(h.userdata.resizerule.upperright.xposition, 'normalized')
                upperright(1) = P(3) * (ip(1) + ip(3)) / Pip(3);
            end
        end
        if strcmpi(h.userdata.resizerule.upperright.alignment, 'upperleft') || strcmpi(h.userdata.resizerule.upperright.alignment, 'upperright')
            if strcmpi(h.userdata.resizerule.upperright.yposition, 'fixed')
                upperright(2) = P(4) - (Pip(4) - ip(2) - ip(4));
            elseif strcmpi(h.userdata.resizerule.upperright.yposition, 'normalized')
                upperright(2) = P(4) * (ip(2) + ip(4)) / Pip(4);
            end
        elseif strcmpi(h.userdata.resizerule.upperright.alignment, 'lowerleft') || strcmpi(h.userdata.resizerule.upperright.alignment, 'lowerright')
            if strcmpi(h.userdata.resizerule.upperright.yposition, 'fixed')
                upperright(2) = ip(2) + ip(4);
            elseif strcmpi(h.userdata.resizerule.upperright.yposition, 'normalized')
                upperright(2) = P(4) * (ip(2) + ip(4)) / Pip(4);
            end
        end
        width  = upperright(1)- lowerleft(1);
        height = upperright(2)- lowerleft(2);        
        

        setpixelposition(handle, [lowerleft(1), lowerleft(2), width, height]);
    end
end
