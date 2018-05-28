function handle=buttonpos()
close all

% 1) renseigner la position
% 2) dimensions fixes/ dimensions normalisees/ dimensions normalisees dans
% une direction mais pas l'autre 
% 3) alignements de boutton




h.visible = 'on';
h.units    =  'normalized';
h.position =  [0.5,.5, .1, .1];
h.string   = 'test';
h.parent   = figure(10);
h.userdata.resizerule.lowerleft.alignment='lowerleft';
h.userdata.resizerule.lowerleft.xposition ='normalized';
h.userdata.resizerule.lowerleft.yposition ='normalized';
h.userdata.resizerule.upperright.alignment='lowerleft';
h.userdata.resizerule.upperright.xposition ='normalized';
h.userdata.resizerule.upperright.yposition ='normalized';


handle = makebutton(h);


end

function handle = makebutton(h)

    handle = uicontrol('parent',h.parent);%
    f = fieldnames(h);


    for i = 1:length(f)
        if strcmpi(f{i},'userdata')
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
