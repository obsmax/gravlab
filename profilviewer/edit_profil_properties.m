function [profil,session]=edit_profil_properties(windows,session,profil)

%ici on peut mettre a jour des propriétes des structures mais a l'echelle
%de tout le profil
%
%ATTENTION : les propriétées sont attribuées a profil ssi l'utilisateur
%clique sur ok ou apply => aucune modif sur profil autrement que par les
%bouttons de fin d'édition
%cas particulier pour la propriete clockwise : si la propriete "order" est
%   modifiee ici, on ne touche pas au polygone correspondant, ce sera effectue
%   par refresh_profil qui detectera une incoherence entre la valeur de order
%   et le sens reel du polygone

%% cas d'un profil vide
if isempty(profil.model)
    errordlg('no structure found');
    return
end

%% blockage des autres actions
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','off')
end
block_structures(profil);

%% creation de la figure
hf=figure();
set(hf,'units','normalized',...
       'menubar','none',...
       'position',[0.0102    0.1400    0.4469    0.8213],...
       'deletefcn',{@fini,'cancel'})
axis off
%% bouttons hors du panel
% I) ok
    hb_ok=uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[.02,.01,.2,.04],...
        'string','OK',...
        'enable','on',...
        'callback',{@fini,'ok'});
% II) apply
    hb_apply=uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[(1-.2)/3,.01,.2,.04],...
        'string','Apply',...
        'enable','on',...
        'callback',{@fini,'apply'});
% III) cancel
    hb_cancel=uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[(1-.2)*2/3,.01,.2,.04],...
        'string','Cancel',...
        'callback',{@fini,'cancel'});
% IV) help
    hb_help=uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[(1-.2-.02),.01,.2,.04],...
        'string','Help',...
        'enable','on',...
        'callback','edit([session.HOME,session.SEP,''help'',session.SEP,''profil_properties.txt''])');
% V) switchers?

%% slidding panels
%% PANEL 1 : propriete des structures elles memes
    %avant dafficher le panel, on crée la cellule des indications a entrer dans la grille
        %1ere ligne = nom de la colonne
        %1 ligne par structure...
        hspStringCell=cell(length(profil.model)+1,6);
    %ligne 1 = indication du contenu de la colonne
        hspStringCell(1,:)={'','name','density','order','color','color display'};
        hspColumnsWidth   =[.05, .19 , .19     , .19   ,.19    ,.19];
    %colonne 1 = numero de la structure
        for i=2:length(profil.model)+1
            hspStringCell(i,1)={num2str(i-1)};
        end
        hspLinesHeight    =.04;
	%colonne 2  = nom de la structure
        for i=2:length(profil.model)+1
            hspStringCell(i,2)={profil.model(i-1).name};
        end
    %colonne 3 = densité de la structure
        for i=2:length(profil.model)+1
            hspStringCell(i,3)={profil.model(i-1).rho};
        end    
    %colonne 4 = ordre de la structure, 
        %c' est un popup => apres
        %l'initialisation du panel, on modifiera carrement dans le handle du
        %boutton
        
%initialisation, creation de la structure descriptive du panel glissant
    hsp=setspanel('Parent',hf,...
        'NormalizedPosition',[0,.2,1,1-.2],...
        'StringCell',hspStringCell,...
        'ColumnsWidth',hspColumnsWidth,...
        'LinesHeight',hspLinesHeight,...
        'HorizontalSliderHeightPixel',0.001,...
        'VerticalSliderStep',[1/length(profil.model),20/exp(.1*length(profil.model))]);
    
%reajustement des bouttons apres leur creation
    %si le slider n'est pas necessaire, on le rends tellement fin qu'il n'apparait plus
        if sum(hsp.LinesHeight)<=1
            hsp=setspanel(hsp,'VerticalSliderWidthPixel',0.001);
        end
    %ligne 1 = pushbuttons noms des colonnes
        for j=1:size(hsp.ButtonHandles_locked,2)
            set(hsp.ButtonHandles_locked(1,j),'style','pushbutton')
        end
	%boutton 1 1 = selection switcher
        %4 positions :
            %position 1 = selection courante (position du switcher des qu'on selectionne ou deselectionne une structure) =>sauvegarde et inversion de la selection
            %position 2 = selection inverse =>selection des non selectionnes
            %position 3 = selection complete => inversion des selectionnes (tous)
            %position 4 = selection nulle => réattribution de la selections sauvegardées
        SwitcherPosition=1;
        SavedSelection=zeros(1,length(profil.model));
        set(hsp.ButtonHandles_locked(1,1),...
            'callback',{@SwitchSelection},...
            'string','p1')
        function SwitchSelection(src,evnt)
            switch SwitcherPosition
                case 1 %on inverse la selection et on la sauve pour pouvoir eventuellement la remettre
                    for i=1:length(profil.model)
                        SavedSelection(i)=strcmp(get(profil.model(i).fill_handle,'selected'),'on');
                        InverseSelectionStruct(NaN,NaN,i);
                    end
                    SwitcherPosition=SwitcherPosition+1;
                case 3
                    for i=1:length(profil.model)
                        InverseSelectionStruct(NaN,NaN,i);
                    end
                    SwitcherPosition=SwitcherPosition+1;
                case 2
                    for i=1:length(profil.model)
                        isselected=strcmp(get(profil.model(i).fill_handle,'selected'),'on');
                        if ~isselected
                            InverseSelectionStruct(NaN,NaN,i);
                        end
                    end
                    SwitcherPosition=SwitcherPosition+1;
                case 4
                    for i=1:length(profil.model)
                        isselected=strcmp(get(profil.model(i).fill_handle,'selected'),'on');
                        if isselected~=SavedSelection(i)
                            InverseSelectionStruct(NaN,NaN,i);
                        end
                    end
                    SwitcherPosition=1;
            end
            set(hsp.ButtonHandles_locked(1,1),...
            'string',['p',num2str(SwitcherPosition)])
        end
    %colonne 1 = pushbuttons = selection de la structure
        for i=2:length(profil.model)+1
            hg_contourselection(i-1)=NaN;
            set(hsp.ButtonHandles_locked(i,1),'style','pushbutton',...
                'callback',{@InverseSelectionStruct,i-1,'clic'})
        end
        function InverseSelectionStruct(src,evnt,struct,mode)
            if nargin>3
                if strcmp(mode,'clic')
                    %l'utilisateur a cliqué=> le switcher bascule en position 1
                    SwitcherPosition=1;
                    set(hsp.ButtonHandles_locked(1,1),...
                        'string',['p',num2str(SwitcherPosition)])
                end
            end
            isselected=strcmp(get(profil.model(struct).fill_handle,'selected'),'on');
            if ~isselected
                set(profil.model(struct).fill_handle,'selected','on')
                figure(windows.homefig.handle)
                hg_contourselection(struct)=plot(...
                get(profil.model(struct).fill_handle,'Xdata'),...
                get(profil.model(struct).fill_handle,'Ydata'),...
                'linewidth',2,...
                'color','b');
                set(hsp.ButtonHandles_locked(struct+1,1),...
                    'Backgroundcolor','b')%le +1 vient de la premiere ligne qui contient les noms des colonnes
                figure(hf)
            else
                set(profil.model(struct).fill_handle,'selected','off')
                set(hg_contourselection(struct),'visible','off')
                set(hsp.ButtonHandles_locked(struct+1,1),...
                    'Backgroundcolor',[0.8314    0.8157    0.7843])%le +1 vient de la premiere ligne qui contient les noms des colonnes
            end
        end
    %colonne 4 = popups
        for i=2:length(profil.model)+1
            set(hsp.ButtonHandles_locked(i,4),'style','popup',...
                'string',{'clockwise','counterclockwise'},...
                'value',strcmp(profil.model(i-1).order,'counterclockwise')+1)
        end    
    %colonne 5 = ?
        for i=2:length(profil.model)+1
            set(hsp.ButtonHandles_locked(i,5),...
                'Backgroundcolor',profil.model(i-1).color,...
                'string',...
                    sprintf('[ %3.1f , %3.1f , %3.1f ]',...
                            profil.model(i-1).color(1),...
                            profil.model(i-1).color(2),...
                            profil.model(i-1).color(3)),...
                'HorizontalAlignment','center',...
                'Backgroundcolor',profil.model(i-1).color,...
                'Foregroundcolor',1-profil.model(i-1).color,...
                'callback',{@recolor,i});
        end
        function recolor(src,evnt,i)
            rvb=str2num(get(hsp.ButtonHandles_locked(i,5),'string'));
            eval(['try;',...
                     'set(hsp.ButtonHandles_locked(',num2str(i),',5),',...
                     ' ''Backgroundcolor'',',get(hsp.ButtonHandles_locked(i,5),'string'),',',...
                     ' ''Foregroundcolor'',[1 1 1]-',get(hsp.ButtonHandles_locked(i,5),'string'),',',...
                     ' ''string'',''',...
                            sprintf('[ %3.1f , %3.1f , %3.1f ]',...
                                rvb(1),...
                                rvb(2),...
                                rvb(3)),' '');',...
                     'catch;',...
                     '   errordlg(sprintf(''The rgb code must be a 1 x 3 element vector between 0 and 1\n example [ 0.1 , 1.0 , 0.9 ]\nplease correct it!''));',...
                     'end'])
        end
    %colonne 6 = popups
        for i=2:length(profil.model)+1
            colordisplaylist={'transparent','by_density','by_order','by_color','superposition_high'};
            value=1;
            while ~strcmp(colordisplaylist{value},profil.model(i-1).colordisplay)
                value=value+1;
            end
            set(hsp.ButtonHandles_locked(i,6),'style','popup',...
                'string',colordisplaylist,...
                'value',value);
        end
%% PANEL 2 : proprietes de la selection courante
    %cellule du contenu des cases
        %une ligne pour le nom de colonne
        hsp2StringCell=cell(3,size(hspStringCell,2));
        hsp2ColumnsWidth   =[.1, .18 , .18     , .18   ,.18    ,.18];
        %ligne 1 = indication du contenu de la colonne
        hsp2StringCell(1,:)=hspStringCell(1,:);
        %colonne 1 = indication du contenu de la ligne
        hsp2StringCell(:,1)={'ok & send';'mode';'value'};
    %initialisation du second spanel
        hsp2=setspanel('Parent',gcf(),...
          'Title','current selection properties',...
          'NormalizedPosition',[0,.08,1,1-.8-.08],...
          'StringCell',hsp2StringCell,...
          'ColumnsWidth',hsp2ColumnsWidth,...
          'LinesHeight',.33,...
          'HorizontalSliderHeightPixel',0.001,...
          'VerticalSliderWidthPixel'  ,0.001,...
          'BackgroundColor',[.3 .3 1]);
	%ajustement des bouttons        hsp2.ButtonHandles_locked
        %ligne 1 = pushbuttons ; APPLY et noms des colonnes
        for j=1:size(hsp2.StringCell,2)
            set(hsp2.ButtonHandles_locked(1,j),'style','pushbutton')
        end
        %colonne 1 = pushbuttons ; mode et value
        for i=2:size(hsp2.StringCell,1)
            set(hsp2.ButtonHandles_locked(i,1),'style','pushbutton')
        end
        %ligne 2 = popups pour le mode
            for j=2:size(hsp2.StringCell,2)
                set(hsp2.ButtonHandles_locked(2,j),'style','popup')
            end
            %popup de name mode
            set(hsp2.ButtonHandles_locked(2,2),'string',...
                {'','name=','add prefix','add suffix','name=structure number'},...
                'value',1,...
                'callback',{@BlocDeblocValue,2})
            %popup de density mode
            set(hsp2.ButtonHandles_locked(2,3),'string',...
                {'','dens=','dens=dens +','dens=dens *'},...
                'value',1,...
                'callback',{@BlocDeblocValue,3})
            %popup de order mode
            set(hsp2.ButtonHandles_locked(2,4),'string',...
                {'','order=','inverse order'},...
                'value',1,...
                'callback',{@BlocDeblocValue,4})
            %popup de color mode
            set(hsp2.ButtonHandles_locked(2,5),'string',...
                {'','color=[r,g,b]','inverse colors'},...
                'value',1,...
                'callback',{@BlocDeblocValue,5})
            %popup de color display mode
                set(hsp2.ButtonHandles_locked(2,6),'string',...
                {'','color display='},...
                'value',1,...
                'callback',{@BlocDeblocValue,6})
            %fonction qui bloc ou libere la case de valeur associé a la case de mode
            function BlocDeblocValue(src,evnt,column)
                    mode=get(hsp2.ButtonHandles_locked(2,column),'value');
                    modelist=get(hsp2.ButtonHandles_locked(2,column),'string');
                    if isempty(modelist{mode}) 
                        %on bloc la case de valeur si le mode est vide ie inactif
                        set(hsp2.ButtonHandles_locked(3,column),'enable','off')
                    elseif ~isempty(strfind(modelist{mode},'invers')) || ~isempty(strfind(modelist{mode},'name=struct'))
                        %pour certains modes il n'y a pas besoin de donner une valeur
                        set(hsp2.ButtonHandles_locked(3,column),'enable','off')
                    else
                        %on libere la case de valeur
                        set(hsp2.ButtonHandles_locked(3,column),'enable','on')                        
                    end
                end
        %ligne 3 = bouttons pour les valeurs
            %name = edit
            set(hsp2.ButtonHandles_locked(3,2),...
                'enable','off');
            %density = edit
            set(hsp2.ButtonHandles_locked(3,3),...
                'enable','off');
            %order = popup
            set(hsp2.ButtonHandles_locked(3,4),...
                'style','popup',...
                'string',{'clockwise','counterclockwise'},...
                'enable','off')
            %color = edit
            set(hsp2.ButtonHandles_locked(3,5),...
                'enable','off',...
                'callback',{@recolor_value});
                function recolor_value(src,evnt)
                    rvb=str2num(get(hsp2.ButtonHandles_locked(3,5),'string'));
                    eval(['try;',...
                     'set(hsp2.ButtonHandles_locked(3,5),',...
                     ' ''Backgroundcolor'',',get(hsp2.ButtonHandles_locked(3,5),'string'),',',...
                     ' ''Foregroundcolor'',[1 1 1]-',get(hsp2.ButtonHandles_locked(3,5),'string'),',',...
                     ' ''string'',''',...
                            sprintf('[ %3.1f , %3.1f , %3.1f ]',...
                                rvb(1),...
                                rvb(2),...
                                rvb(3)),' '');',...
                     'catch;',...
                     '   errordlg(sprintf(''The rgb code must be a 1 x 3 element vector between 0 and 1\n example [ 0.1 , 1.0 , 0.9 ]\nplease correct it!''));',...
                     'end'])
                end
            %colordisplay = popup
            set(hsp2.ButtonHandles_locked(3,6),...
                'style','popup',...
                'string',colordisplaylist,...
                'enable','off')
            %APPLY callback
            set(hsp2.ButtonHandles_locked(1,1),'callback',{@APPLYModif2Selection})
            function APPLYModif2Selection(src,evnt)
                %on lit le panel2 et on applique les modifs a la selection courante dans le panel 1
                CurrentSelection=zeros(1,length(profil.model));
                %1) get de selection
                    for i=1:length(profil.model)
                        CurrentSelection(i)=strcmp(get(profil.model(i).fill_handle,'selected'),'on');
                    end
                %2) si aucune selection n'a ete faite => erreur
                    if ~sum(CurrentSelection)
                        errordlg(sprintf(['Please make a selection in the upper panel!!\n\n',...
                            'This panel help you to define a set of modifications\n',...
                            'you want to apply to the selected structures (blue buttons) in the upper panel\n'...
                            'nb : to make the upper panel properties effective, you have to clic Apply or OK at the bottom of this window']))
                    end
                %3) Application des modifs a la selection bleue
                  %3.1) name
                    %namemodelist={'','name=','add prefix','add suffix','name=struct_number'};
                    namemode=get(hsp2.ButtonHandles_locked(2,2),'value');
                    namevalue=get(hsp2.ButtonHandles_locked(3,2),'string');
                    %3.1.0) empty
                    %3.1.1) name=
                        if namemode==2
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,2),'string',namevalue);
                            end
                    %3.1.2) add prefix
                        elseif namemode==3
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,2),'string',[namevalue,get(hsp.ButtonHandles_locked(i+1,2),'string')]);
                            end
                    %3.1.3) add suffix
                        elseif namemode==4
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,2),'string',[get(hsp.ButtonHandles_locked(i+1,2),'string'),namevalue]);
                            end
                    %3.1.4) name=struct_number
                        elseif namemode==5
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,2),'string',num2str(i));
                            end
                        end
                  %3.2) density
                    densmode=get(hsp2.ButtonHandles_locked(2,3),'value');
                    densvalue=get(hsp2.ButtonHandles_locked(3,3),'string');
                    %3.2.0) empty
                    %3.2.1) dens=
                        if densmode==2
                            for i=find(CurrentSelection)
                                if ~isempty(densvalue)%si la densitee entree est ok, (a ameliorer)
                                    set(hsp.ButtonHandles_locked(i+1,3),'string',densvalue);
                                else %sinon
                                    set(hsp.ButtonHandles_locked(i+1,3),'string','NaN');
                                end
                            end
                    %3.2.2) dens=dens+
                        elseif densmode==3
                            for i=find(CurrentSelection)
                                    set(hsp.ButtonHandles_locked(i+1,3),'string',num2str(str2double(densvalue)+str2double(get(hsp.ButtonHandles_locked(i+1,3),'string'))));
                            end
                    %3.2.3) dens=dens*
                        elseif densmode==4
                            for i=find(CurrentSelection)
                                    set(hsp.ButtonHandles_locked(i+1,3),'string',num2str(str2double(densvalue)*str2double(get(hsp.ButtonHandles_locked(i+1,3),'string'))));
                            end
                        end
                  %3.3) order
                    ordermode=get(hsp2.ButtonHandles_locked(2,4),'value');
                    ordervalue=get(hsp2.ButtonHandles_locked(3,4),'value');
                    %3.3.0)
                    %3.3.1) order=
                        if ordermode==2
                            for i=find(CurrentSelection)
                                    set(hsp.ButtonHandles_locked(i+1,4),'value',ordervalue);
                            end
                    %3.3.2) inverse order
                        elseif ordermode==3
                            for i=find(CurrentSelection)
                                    currentvalue=get(hsp.ButtonHandles_locked(i+1,4),'value')+1;
                                    if currentvalue==3
                                        currentvalue=1;
                                    end
                                    set(hsp.ButtonHandles_locked(i+1,4),'value',currentvalue);
                            end
                        end
                  %3.4) color
                    colormode=get(hsp2.ButtonHandles_locked(2,5),'value');
                    colorvalue=get(hsp2.ButtonHandles_locked(3,5),'string');
                    %3.4.0) empty
                    %3.4.1) color=
                        if colormode==2
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,5),'string',colorvalue,...
                                    'Backgroundcolor',str2num(colorvalue),...
                                    'Foregroundcolor',1-str2num(colorvalue));
                            end
                    %3.4.2) inverse color
                            elseif colormode==3
                                for i=find(CurrentSelection)
                                    currentcolor_str=get(hsp.ButtonHandles_locked(i+1,5),'string');
                                    invcurrentcolor=1-str2num(currentcolor_str);
                                    invcurrentcolor_str=sprintf('[ %.1f , %.1f , %.1f ]',invcurrentcolor(1),invcurrentcolor(2),invcurrentcolor(3));
                                    set(hsp.ButtonHandles_locked(i+1,5),'string',invcurrentcolor_str,...
                                        'Backgroundcolor',invcurrentcolor,...
                                        'Foregroundcolor',str2num(currentcolor_str));
                                end                                
                        end
                  %3.5) color display
                    colordisplaymode=get(hsp2.ButtonHandles_locked(2,6),'value');
                    colordisplayvalue=get(hsp2.ButtonHandles_locked(3,6),'value');
                    %3.5.0) empty
                    %3.5.1) color display=
                        if colordisplaymode==2
                            for i=find(CurrentSelection)
                                set(hsp.ButtonHandles_locked(i+1,6),'value',colordisplayvalue);
                            end
                        end
            end

disp([datestr(now),' : system is busy (edit_profil_properties.m)'])
uiwait(hf);





%% FIN GENERALE (de la): le uiresume a ete ordonne par la fnction de fin
disp([datestr(now),' : done'])

%on efface les contour des structures selectionnees et on les deselectionne
for i=1:length(hg_contourselection)
    if ~isnan(hg_contourselection(i))
        set(hg_contourselection(i),'visible','off')
        set(profil.model(i).fill_handle,'selected','off')
    end
end

%retablissement de la disponibilité des autres actions
fields=fieldnames(windows.homefig.menu);
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end
%on supprime le handle de fermeture
try
    set(hf,'deletefcn',[])
    close(hf)
    %si ca echoue c est que la figure est deja fermee...
end

% mise a jour du profil et reactivation des action (selectionnabilité,clic droit...)
profil=refresh_profil(windows,profil,{'model'});

% restoration des menus
for field=1:length(fields)
    set(windows.homefig.menu.(fields{field}).parent,'enable','on')
end
%% FIN GENERALE (a de la)





%% fonction de fin, si ok ou apply, on lit le panel et on l'applique +
%  on renvoie au niveau du uiwait qlq lignes +haut qui se charge de mettre
%  fin
function fini(src,evnt,mode)
        if strcmp(mode,'cancel')
            uiresume(hf);
        elseif strcmp(mode,'ok') || strcmp(mode,'apply')
            %on lit les info du panel et on attribu les nouvelles prop, si different et session sauvegardee, on la unsave
            unsave=0;
            for struct=1:length(profil.model)
                %name
                if ~strcmp(profil.model(struct).name,get(hsp.ButtonHandles_locked(struct+1,2),'string'))
                    profil.model(struct).name=get(hsp.ButtonHandles_locked(struct+1,2),'string');
                    unsave=1;
                end
                %density
                if profil.model(struct).rho~=str2num(get(hsp.ButtonHandles_locked(struct+1,3),'string')) && ~(isnan(profil.model(struct).rho) && isnan(str2num(get(hsp.ButtonHandles_locked(struct+1,3),'string'))))
                    profil.model(struct).rho=str2num(get(hsp.ButtonHandles_locked(struct+1,3),'string'));
                    unsave=1;
                end
                %order
                if get(hsp.ButtonHandles_locked(struct+1,4),'value')==1
                    neworder='clockwise';
                elseif get(hsp.ButtonHandles_locked(struct+1,4),'value')==2
                    neworder='counterclockwise';
                else
                    error('je comprends pas pk, la valeur du handle d''ordre est mauvaise')
                end
                if ~strcmp(neworder,profil.model(struct).order);
                    profil.model(struct).order=neworder;
                    unsave=1;
                end
                %color
                if sum(abs(profil.model(struct).color-str2num(get(hsp.ButtonHandles_locked(struct+1,5),'string'))))>0
                    if sum(abs(size(str2num(get(hsp.ButtonHandles_locked(struct+1,5),'string')))-[1,3]))>0 || ~isempty(find(str2num(get(hsp.ButtonHandles_locked(struct+1,5),'string'))>1.0 | str2num(get(hsp.ButtonHandles_locked(struct+1,5),'string'))<0.0))
                        errordlg(['the given rgb code (  ',get(hsp.ButtonHandles_locked(struct+1,5),'string'),'  ) is not correct, the color won''t be attribuated to your structure'])
                    else
                        profil.model(struct).color=str2num(get(hsp.ButtonHandles_locked(struct+1,5),'string'));
                        %unsave=1;
                    end
                end
                %colordisplay
                if ~strcmp(profil.model(struct).colordisplay,colordisplaylist{get(hsp.ButtonHandles_locked(struct+1,6),'value')})
                    profil.model(struct).colordisplay=colordisplaylist{get(hsp.ButtonHandles_locked(struct+1,6),'value')};
                    %unsave=1;
                end
            end

            %s'il y a eu des modifs et que la session est a l'état "saved"
            if unsave==1 && session.saved==1
                session.saved=0;
                set(windows.homefig.handle,...
                'name',[get(windows.homefig.handle,'name'),'*'])
            end
            
            %si on est en ok on resume, si on est en apply on rafraichit le
            %graph mais on resume pas
            if strcmp(mode,'ok')
                uiresume(hf);
            else
                CurrentSelection=zeros(1,length(profil.model));
                for i=1:length(profil.model)
                    CurrentSelection(i)=strcmp(get(profil.model(i).fill_handle,'selected'),'on');
                    if ~isnan(hg_contourselection(i))
                        set(hg_contourselection(i),'visible','off')
                    end
                end
                profil=refresh_profil(windows,profil,{'model'});
                block_structures(profil);
                for i=1:length(hg_contourselection)
                    if CurrentSelection(i)
                        hg_contourselection(i)=plot(...
                            get(profil.model(i).fill_handle,'Xdata'),...
                            get(profil.model(i).fill_handle,'Ydata'),...
                            'linewidth',2,...
                            'color','b');
                            set(profil.model(i).fill_handle,'selected','on')
                    else
                        hg_contourselection(i)=NaN;
                    end
                end 
            end
        end
end

end



%% rappel des proprietes disponible (et non disponibles "_locked") du slidding panel
%                                       Title: 'titre'
%                          NormalizedPosition: [0.1000 0.1000 0.5000 0.5000]
%                                      Parent: 1
%                             BackgroundColor: [0.5000 0.5000 0.5000]
%                    VerticalSliderWidthPixel: 10
%                         VerticalSliderValue: 1
%                          VerticalSliderStep: [0.0100 0.1000]
%                 HorizontalSliderHeightPixel: 10
%                       HorizontalSliderValue: 0
%                        HorizontalSliderStep: [0.1000 0.4000]
%                                 LinesHeight: [1x20 double]
%                                ColumnsWidth: [1x20 double]
%                                  StringCell: {20x20 cell}
%                                 PanelHandle: 158.0055
%                        VerticalSliderHandle: 160.0055
%                      HorizontalSliderHandle: 161.0055
%        NormalizedVerticalSliderWidth_locked: 0.0361
%     NormalizedHorizontalSliderHeight_locked: 0.0505
%                        ButtonHandles_locked: [20x20 double]