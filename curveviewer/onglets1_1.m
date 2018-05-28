function [fig,B]=onglets1_1(OngletsNames, fighandle)

if nargin ==0
	fprintf('onglets version 1_0:\n')
	fprintf('M.Lehujeur\n')
	fprintf('creates a figure with several panels\n')
	fprintf('input : \n')
	fprintf('    OngletsNames = cell containing names of each panel\n')
	fprintf('output : \n')
	fprintf('    fig = handle of the parent figure\n')
	fprintf('    B = Structure containing panel titles, button handles, and axes handles\n')
	fprintf('\n')
    return
end
if nargin == 1
    fighandle = gcf();
end
fig=figure(fighandle);
set(fig,'units','normalized',...
    'resizefcn',@reszefig)

for i=1:length(OngletsNames) %#ok<FXUP>
    B(i).Title=OngletsNames{i}; %#ok<AGROW>
end

higlightcolor=[.9 0 0];
shadowcolor='default';%[0 .6 .9];
OngletPixelHeight=20;
OngletPixelWidth=80;%ou moins si la figure est trop etroite
reszefig(gcf,NaN,'create');






function reszefig(src,evnt,mode) %#ok<INUSL>
    if nargin==2
        mode='resize';
    end
    
    if strcmp(mode,'create')
        figpxsize  =getpixelposition(src);
        actualOngletPixelWidth=min([OngletPixelWidth,figpxsize(3)/length(B)]);
        for i=1:length(B) %#ok<FXUP>
            B(i).OngletHandle=uicontrol(...
            'style','pushbutton',...
            'units','pixel',...
            'tag', num2str(i),...
            'backgroundcolor',shadowcolor,...
            'position',[(i-1)*actualOngletPixelWidth,figpxsize(4)-OngletPixelHeight,actualOngletPixelWidth,OngletPixelHeight],...
            'string',B(i).Title,...
            'selectionHighlight','off',...
            'callback',{@showpanel,i});
            B(i).PanelHandle=uipanel(...
            'parent',src,...
            'units','pixel',...
            'position',figpxsize-[figpxsize(1) figpxsize(2) 0 OngletPixelHeight],...
            'visible','off');
            set(B(i).PanelHandle,'units','normalized')
            B(i).Axes=axes();
            set(B(i).Axes,'visible','off','parent',B(i).PanelHandle)
        end
            showpanel(fig,NaN,1)
    elseif strcmp(mode,'resize')
        figpxsize=getpixelposition(src);
        actualOngletPixelWidth=min([OngletPixelWidth,figpxsize(3)/length(B)]);
        for i=1:length(B) %#ok<FXUP>
            set(B(i).OngletHandle,...
            'position',[(i-1)*actualOngletPixelWidth,figpxsize(4)-OngletPixelHeight,actualOngletPixelWidth,OngletPixelHeight]);
            setpixelposition(B(i).PanelHandle,figpxsize-[figpxsize(1) figpxsize(2) 0 OngletPixelHeight])
        end
    end



    function showpanel(src,evnt,npanel) %#ok<INUSL>
        Ihide=1:length(B);
        Ishow=find(Ihide==npanel);
        Ihide(Ishow)=[];
        %show current panel
        set(B(Ishow).PanelHandle,'visible','on');
        %hilight the current onglet
        set(B(Ishow).OngletHandle,'backgroundcolor',higlightcolor, 'selected','on');
        axes(B(Ishow).Axes)
        for i=Ihide %#ok<FXUP>
            set(B(i).PanelHandle,'visible','off')
            set(B(i).OngletHandle,'backgroundcolor',shadowcolor, 'selected','off');
        end
    end
end
end




