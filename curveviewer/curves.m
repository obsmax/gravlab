if ~isempty(windows.curveopenfig.handle)
    try 
        set(windows.curveopenfig.handle,'visible','on')
        return
    catch
        windows.curveopenfig.handle=[];
    end
end
        
    

windows.curveopenfig.handle = figure();
set(windows.curveopenfig.handle,'units','normalized',...
       'menubar','none',...
       'numbertitle','off',...
       'name','curves',...
       'position',[0.5039    0.5238    0.4461    0.4313],...
       'closerequestfcn','set(windows.curveopenfig.handle,''visible'',''off'');')
labels = cell(1, length(session.Xzfiles)); for i = 1:length(labels);labels{i}=session.Xzfiles(i).label;end
[windows.curveopenfig.handle, windows.curveopenfig.onglets]=onglets1_1(labels, ...
    windows.curveopenfig.handle);

for i = 1:length(session.Xzfiles) 
    buildsheet(curvesheet_skeleton(i), windows.curveopenfig.onglets(i).PanelHandle, i);
end
clear i labels
% 
% %% slidding panels
% hspColumnsWidth   =[.025, .05   , .1    , .1   ,.4         ,.1    ,.13      ,.1 ];
% hspLinesHeight    =1/11.5;
% buttons = cell(length(session.Xzfiles)+1,8,5);
%     %names
%     buttonsprop={'string','style','HorizontalAlignment','BackGroundColor','ForeGroundColor','callback','value'};
%     buttons(:,:,1) = ...    names
%         {'','label','mode'          ,'browse','file','save as...','color','';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,'';
%          '',''     ,'file|gravitom' ,'browse',''    ,'save as...',''     ,''};
%         for i = 2:size(buttons,1);%completion de la cellule precedente
%             buttons(i,2,1)={session.Xzfiles(i-1).label};
%             buttons(i,5,1)={session.Xzfiles(i-1).file};
%             c = session.Xzfiles(i-1).color;
%             buttons(i,7,1)={sprintf('[%.1f,%.1f,%.1f]',c(1),c(2),c(3))};
%         end
%      buttons(:,:,2) = ...
%         {'text'    ,'text','text' ,'text'       ,'text','text'       ,'text' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text';
%          'checkbox','text','popup','pushbutton' ,'edit','pushbutton' ,'edit' ,'text'};
%      buttons(:,:,3) = ...
%         {'center','center','center','center','center','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center';
%          'center','center','center','center','left','center','center' ,'center'};
%      buttons(:,:,4) = ... Backgroundcolor
%         {'default','default','default','default','default','default','default','default';
%          'default','default','default','default','default','default',str2num(buttons{2,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{3,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{4,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{5,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{6,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{7,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{8,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{9,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{10,7,1}),'default';
%          'default','default','default','default','default','default',str2num(buttons{11,7,1}),'default'};
%      buttons(:,:,5) = ... Foregroundcolor
%         {'default','default','default','default','default','default','default','default';
%          'default','default','default','default','default','default',1-str2num(buttons{2,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{3,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{4,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{5,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{6,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{7,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{8,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{9,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{10,7,1}),'default';
%          'default','default','default','default','default','default',1-str2num(buttons{11,7,1}),'default'};
%       buttons(:,:,6) = ...  callbacks   
%            {'','','','','','','','';
%             'visibility_Xz(1);','','mode_Xz(1);','browse_Xz(1);','','','','';
%             'visibility_Xz(2);','','mode_Xz(2);','browse_Xz(2);','','','','';
%             'visibility_Xz(3);','','mode_Xz(3);','browse_Xz(3);','','','','';
%             'visibility_Xz(4);','','mode_Xz(4);','browse_Xz(4);','','','','';
%             'visibility_Xz(5);','','mode_Xz(5);','browse_Xz(5);','','','','';
%             'visibility_Xz(6);','','mode_Xz(6);','browse_Xz(6);','','','','';
%             'visibility_Xz(7);','','mode_Xz(7);','browse_Xz(7);','','','','';
%             'visibility_Xz(8);','','mode_Xz(8);','browse_Xz(8);','','','','';
%             'visibility_Xz(9);','','mode_Xz(9);','browse_Xz(9);','','','','';
%             'visibility_Xz(10);','','mode_Xz(10);','browse_Xz(10);','','','',''};
%       buttons(:,:,7) = ...     values
%            {'default','default','default','default','default','default','default','default';
%             strcmp(session.Xzfiles(1).visibility,'on'),'default',strcmp(session.Xzfiles(1).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(2).visibility,'on'),'default',strcmp(session.Xzfiles(2).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(3).visibility,'on'),'default',strcmp(session.Xzfiles(3).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(4).visibility,'on'),'default',strcmp(session.Xzfiles(4).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(5).visibility,'on'),'default',strcmp(session.Xzfiles(5).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(6).visibility,'on'),'default',strcmp(session.Xzfiles(6).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(7).visibility,'on'),'default',strcmp(session.Xzfiles(7).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(8).visibility,'on'),'default',strcmp(session.Xzfiles(8).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(9).visibility,'on'),'default',strcmp(session.Xzfiles(9).mode,'gravitom')+1,'default','default','default','default','default';
%             strcmp(session.Xzfiles(10).visibility,'on'),'default',strcmp(session.Xzfiles(10).mode,'gravitom')+1,'default','default','default','default','default'};
%             
% %      buttons(:,:,6) = ...
% %         {'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels';
% %          'pixels','pixels','pixels','pixels','pixels','pixels','pixels' ,'pixels'};
% %     %colonne 1 = visibilité, radiobutton 
% % 	%colonne 2  = label de la courbe
% %         for i=2:length(session.Xzfiles)+1
% %             hspStringCell(i,2)={session.Xzfiles(i-1).label};
% %         end
% %     %colonne 3 = mode
% %         %c' est un popup => apres
% %         %l'initialisation du panel, on modifiera carrement dans le handle du
% %         %boutton
% %     %colonne 4 = browse
% %         for i=2:length(session.Xzfiles)+1
% %             hspStringCell(i,4)={'browse'};
% %         end
% %     %colonne 5 = file name
% %         for i=2:length(session.Xzfiles)+1
% %             hspStringCell(i,5)={session.Xzfiles(i-1).file};
% %         end        
% %     %colonne 6 = save as
% %         for i=2:length(session.Xzfiles)+1
% %             hspStringCell(i,6)={'save as'};
% %         end
% %     %colonne 8 = save as
% %         for i=2:length(session.Xzfiles)+1
% %             hspStringCell(i,8)={'properties'};
% %         end
%     %initialisation, creation de la structure descriptive du panel glissant
%     windows.curveopenfig.slidingpanel=setspanel('Parent',windows.curveopenfig.handle,...
%         'NormalizedPosition',[0,.15,1,1-.15],...
%         'StringCell',buttons(:,:,1),...
%         'ColumnsWidth',hspColumnsWidth,...
%         'LinesHeight',hspLinesHeight,...
%         'VerticalSliderWidthPixel',0.001);
% 
% %reajustement des bouttons apres leur creation
%     for i = 1:size(buttons,1)
%         for j=1:size(buttons,2)
%             for k = 1:size(buttons,3)
%                 set(windows.curveopenfig.slidingpanel.ButtonHandles_locked(i,j),buttonsprop{k},buttons{i,j,k})
%             end
%         end
%         %selon le mode, ca a un impact sur les autres bouttons, on appel le
%         %callback ici pour ajuster les bouttons
%         if i>1;
%             mode_Xz(i-1);
%         end
%     end
%     
%     
% % 
% %     %ligne 1 = pushbuttons noms des colonnes
% %         for j=1:size(hsp.ButtonHandles_locked,2)
% %             set(hsp.ButtonHandles_locked(1,j),'style','text')
% %         end
% % 	%colonne 1 = checkbox = curve visibility
% %         for j=2:size(hsp.ButtonHandles_locked,1)
% %             set(hsp.ButtonHandles_locked(j,1),'style','checkbox')
% %         end
% % 	%colonne 3 = mode
% %         for j=2:size(hsp.ButtonHandles_locked,1)
% %             switch session.Xzfiles(j-1).mode
% %                 case 'file'
% %                     val=1;  
% %                 case 'gravitom'
% %                     val=2;
% %             end
% %             set(hsp.ButtonHandles_locked(j,3),'style','popup',...
% %                 'string',{'file','gravitom'},...
% %                 'value',val)
% %         end    
% %     %colonne 4 = browse
% %         for j=2:size(hsp.ButtonHandles_locked,1)
% %             set(hsp.ButtonHandles_locked(j,4),'style','pushbutton')
% %         end    
% %     %colonne 5 = file name HorizontalAlignment
% % %         for j=2:size(hsp.ButtonHandles_locked,1)
% % %             set(hsp.ButtonHandles_locked(j,5),'HorizontalAlignment','left')
% % %         end    
% %     set(hsp.ButtonHandles_locked(2:size(hsp.ButtonHandles_locked,1),5),'HorizontalAlignment','left')
% % 
% %     %colonne 6 = save as
% %         for j=2:size(hsp.ButtonHandles_locked,1)
% %             set(hsp.ButtonHandles_locked(j,6),...
% %                 'style','pushbutton')
% %         end   
% %     %colonne 8 = properties...
% %         for j=2:size(hsp.ButtonHandles_locked,1)
% %             set(hsp.ButtonHandles_locked(j,8),'style','pushbutton')
% %         end   
% 
% clear i j k hspLinesHeight hspColumnsWidth defaultcolors c buttonsprop buttons 
% 
% %% rappel des proprietes disponible (et non disponibles "_locked") du slidding panel
% %                                       Title: 'titre'
% %                          NormalizedPosition: [0.1000 0.1000 0.5000 0.5000]
% %                                      Parent: 1
% %                             BackgroundColor: [0.5000 0.5000 0.5000]
% %                    VerticalSliderWidthPixel: 10
% %                         VerticalSliderValue: 1
% %                          VerticalSliderStep: [0.0100 0.1000]
% %                 HorizontalSliderHeightPixel: 10
% %                       HorizontalSliderValue: 0
% %                        HorizontalSliderStep: [0.1000 0.4000]
% %                                 LinesHeight: [1x20 double]
% %                                ColumnsWidth: [1x20 double]
% %                                  StringCell: {20x20 cell}
% %                                 PanelHandle: 158.0055
% %                        VerticalSliderHandle: 160.0055
% %                      HorizontalSliderHandle: 161.0055
% %        NormalizedVerticalSliderWidth_locked: 0.0361
% %     NormalizedHorizontalSliderHeight_locked: 0.0505
% %                        ButtonHandles_locked: [20x20 double]