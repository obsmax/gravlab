function profil=refresh_profil(windows,profil,profilprop)

%permet de rafraichir les proprietes profilprop de la structure profil
%l'attribution de handles de clic droit se fait ici

%figure de travail
figure(windows.homefig.handle);
%dimentions des axes
set(gca,'units','normalized',...
         'position',[.05,.2,.9,.75],...
         'visible','on')
box on


if strcmp(profilprop,'all')
    hold off
    refresh_xmax
    refresh_zmin
    refresh_zmax
    refresh_model
else
    for prop=1:length(profilprop)
        switch profilprop{prop}
            case 'xmax'
                refresh_xmax
            case 'zmin'
                refresh_zmin
            case 'zmax'
                refresh_zmax    
            case 'dimension'
                refresh_xmax
                refresh_zmin
                refresh_zmax
            case 'model'
                refresh_model
            otherwise
                fprintf('ne peut pas mettre a jour le champ %s\n',profilprop{prop})
        end
    end
end


%% fonction de rafraichissement individuelles
function refresh_xmax
    while profil.xmax<=0
            Hwarn=errordlg('xmax must be positive');
                Hwarnchildrens=get(Hwarn,'Children');
                set(Hwarnchildrens(3),'Callback',{@closewarn,Hwarn,Hwarnchildrens});
                uiwait(Hwarn);
        answer=inputdlg({['xmax (',profil.units,')']},...
                 'profil length',1,...
                 {num2str(profil.xmax)});
        profil.xmax=str2num(answer{1});
        clear answer;
    end
    xlim([0,profil.xmax])
end

function refresh_zmin
    %si zmin est vide, on lit dans modele, si modele est vide on donne une valeur par defaut
    if isempty(profil.zmin)
        if isempty(profil.model)
            profil.zmin=-50;
            Hwarn=warndlg(['zmin set to ',num2str(profil.zmin),' ',profil.units]);
                Hwarnchildrens=get(Hwarn,'Children');
                set(Hwarnchildrens(3),'Callback',{@closewarn,Hwarn,Hwarnchildrens});
                uiwait(Hwarn);
        else
            y=[];
            for i=1:length(profil.model)
                y=[y;profil.model(i).polyg(:,2)];
            end
            profil.zmin=min(y);
            clear y
        end
    end
    %verification de la coherence avec profil.zmax si celui ci est non vide
    if ~isempty(profil.zmax)
        while profil.zmin>=profil.zmax
            Hwarn=errordlg('zmax must be greater than zmin');
                Hwarnchildrens=get(Hwarn,'Children');
                set(Hwarnchildrens(3),'Callback',{@closewarn,Hwarn,Hwarnchildrens});
                uiwait(Hwarn);
            answer=inputdlg({['zmin (',profil.units,')'],['zmax (',profil.units,')']},...
                           'zmin & zmax',1,...
                           {num2str(profil.zmin),num2str(profil.zmax)});
            profil.zmin=str2num(answer{1});
            profil.zmax=str2num(answer{2});
        end
    end
    limy=get(gca,'Ylim');
    ylim([profil.zmin,limy(2)])
end

function refresh_zmax
    %si zmin est vide, on lit dans modele, si modele est vide on donne une valeur par defaut
    if isempty(profil.zmax)
        if isempty(profil.model)
            profil.zmax=+10;
            Hwarn=warndlg(['zmax set to ',num2str(profil.zmax),' ',profil.units]);
                Hwarnchildrens=get(Hwarn,'Children');
                set(Hwarnchildrens(3),'Callback',{@closewarn,Hwarn,Hwarnchildrens});
                uiwait(Hwarn);
        else
            y=[];
            for struct=1:length(profil.model)
                y=[y;profil.model(struct).polyg(:,2)];
            end
            profil.zmax=max(y);
            clear y
        end
    end
    %verification de la coherence avec profil.zmin si celui ci est non vide
    if ~isempty(profil.zmin)
        while profil.zmin>=profil.zmax
            Hwarn=errordlg('zmax must be greater than zmin');
                Hwarnchildrens=get(Hwarn,'Children');
                set(Hwarnchildrens(3),'Callback',{@closewarn,Hwarn,Hwarnchildrens});
                uiwait(Hwarn);
            answer=inputdlg({['zmin (',profil.units,')'],['zmax (',profil.units,')']},...
                           'zmin & zmax',1,...
                           {num2str(profil.zmin),num2str(profil.zmax)});
            profil.zmin=str2num(answer{1});
            profil.zmax=str2num(answer{2});
        end
    end
    limy=get(gca,'Ylim');
    ylim([limy(1),profil.zmax])   
end

function refresh_model
    hold on
   
    for struct=1:length(profil.model)
        try
            set(profil.model(struct).fill_handle,'visible','off')
        end

        %clic droit pour chaque structure
        profil.model(struct).RightClic.parent=uicontextmenu;
        profil.model(struct).RightClic.properties=uimenu(profil.model(struct).RightClic.parent,...
                                        'label','properties',...
                                        'enable','on',...
                                        'callback',['[profil,session]=edit_structur_properties(windows,session,profil,',num2str(struct),');']);
        profil.model(struct).RightClic.move=uimenu(profil.model(struct).RightClic.parent,...
                                        'label','move',...
                                        'enable','on',...
                                        'callback',['block_structures(profil);',...
                                                    '[profil,session]=move1structure(windows,session,profil,',num2str(struct),');']);
        profil.model(struct).RightClic.remove=uimenu(profil.model(struct).RightClic.parent,...
                                        'label','remove ',...
                                        'callback',['block_structures(profil);',...
                                                    '[profil,session]=rm_struct(windows,session,profil,',num2str(struct),');']);
        profil.model(struct).RightClic.rotate.parent=uimenu(profil.model(struct).RightClic.parent,...
                                        'label','rotate');
            profil.model(struct).RightClic.rotate.clockwise=uimenu(profil.model(struct).RightClic.rotate.parent,...
                                        'label','clockwise',...
                                        'callback',['block_structures(profil);',...
                                                    '[profil,session]=rotate(windows,session,profil,',num2str(struct),',''clock'');']); %'block_structures(profil);',...                          
            profil.model(struct).RightClic.rotate.clockwise=uimenu(profil.model(struct).RightClic.rotate.parent,...
                                        'label','counter clockwise',...
                                        'callback',['block_structures(profil);',...
                                                    '[profil,session]=rotate(windows,session,profil,',num2str(struct),',''counterclock'');']);                                                         
        %rafraichissement du handle de surface de chaque structure
        switch profil.model(struct).colordisplay
            case 'transparent'
                struct_color='none';
                struct_alpha=0;
            case 'by_color'
                struct_color=profil.model(struct).color;
                struct_alpha=1;
            case 'by_density'
                struct_color=getcolorfrom('density',profil.model(struct).rho);
                struct_alpha=1; 
            case 'by_order' %on se fie a ce qui est dans le champ order, plus bas on renverse le polyg si besoin
                struct_color=getcolorfrom('order',profil.model(struct).order);
                struct_alpha=1;
            case 'superposition_high'
                struct_color=profil.model(struct).color;
                struct_alpha=.2;
        end        
        profil.model(struct).fill_handle=fill(profil.model(struct).polyg(:,1),profil.model(struct).polyg(:,2),[1 1 1],...
                 'uicontextmenu',profil.model(struct).RightClic.parent,...
                 'SelectionHighlight','off',...
                 'Edgecolor','k',...
                 'linewidth',.5,...
                 'Facecolor',struct_color,...
                 'Facealpha',struct_alpha);
        profil.model(struct).orig_handle = plot(profil.model(struct).polyg(1,1),...
                                            profil.model(struct).polyg(1,2),...
                                            'ko','visible','off');
    end

    %une fois que tout est plotte, on attribut les callback aux aires et aux rightclics
    for struct=1:length(profil.model)
        set(profil.model(struct).fill_handle,'buttonDownFcn',{@select_struct,profil,struct})
    end
    %rafraichissement de l'ordre des sommet selon ce qui se trouve dans le champ "order"
    for struct=1:length(profil.model)
        if         (  isclockwise(profil.model(struct).polyg) && strcmp(profil.model(struct).order,'counterclockwise'))...
                || ( ~isclockwise(profil.model(struct).polyg) && strcmp(profil.model(struct).order,'clockwise')       )
%             warndlg(num2str(struct))
            profil.model(struct).polyg=profil.model(struct).polyg(profil.model(struct).n:-1:1,:);
        end
    end
end

%fonctions annexes aux refresh individuelles
function select_struct(src,evnt,profil,struct)
    %on deselectionne tout
    for struct_tmp=1:length(profil.model)
        %attribution de la couleur de la structure selon le colordisplay
        switch profil.model(struct_tmp).colordisplay
            case 'transparent'
                struct_color='none';
                struct_alpha=0;
            case 'by_color'
                struct_color=profil.model(struct_tmp).color;
                struct_alpha=1;
            case 'by_density'
                struct_color=getcolorfrom('density',profil.model(struct_tmp).rho);
                struct_alpha=1; 
            case 'by_order'
                struct_color=getcolorfrom('order',profil.model(struct_tmp).order);
                struct_alpha=1;
            case 'superposition_high'
                struct_color=profil.model(struct_tmp).color;
                struct_alpha=.2;
        end
        set(profil.model(struct_tmp).fill_handle,'selected','off',...
            'Edgecolor','k',...
            'linewidth',.5,...
            'Facecolor',struct_color,...
            'Facealpha',struct_alpha)
        set(profil.model(struct_tmp).orig_handle,...
            'Xdata',profil.model(struct).polyg(1,1),...
            'Ydata',profil.model(struct).polyg(1,2),...
            'visible','off')
    end
    %on inscrit le nom de la structure dans la boite de dialogue et on
    %selectionne la structure
    set(windows.homefig.dlgbox,'string',['structure : ',profil.model(struct).name,' ; density :',num2str(profil.model(struct).rho),' ; order : ',profil.model(struct).order],'Foregroundcolor','b')
    set(profil.model(struct).fill_handle,'selected','on','Edgecolor','r','linewidth',2)%'Facecolor',[.7,.7,1])
    set(profil.model(struct).orig_handle,'visible','on')
end

function closewarn(src,evtn,Hwarn,Hwarnchildrens)
    uiresume(Hwarn);
    close(Hwarn);
    clear Hwarn Hwarnchildrens;
end



%end final
end







% 
% hold off
% xlim([0,profil.xmax])
% try 
%     ylim([profil.zmin,profil.zmax])
% catch
%     %si on arrive pas a mettre l axe des z aux limites indiques, on va chercher dans le modele, les extremas,
%     %si le modele est vide on propose une valeur par defaut
%     if ~isempty(profil.model);
%         y=[];
%         for i=1:length(profil.model);
%             y=[y;profil.model(i).polyg(:,2)];
%         end;
%         profil.zmin=min(y);profil.zmax=max(y);
%         ylim([profil.zmin,profil.zmax])
%     else
%         Hwarn=warndlg('zaxis boundaries set to [-50  +10]');
%              Hwarnchildrens=get(Hwarn,'Children');
%              set(Hwarnchildrens(3),'Callback',@closewarn);
%              uiwait(Hwarn);
%         profil.zmin=-50;
%         profil.zmax=10;
%         ylim([profil.zmin,profil.zmax])
%     end
% end
% 
% set(gca,'units','normalized',...
%         'position',[.05,.2,.9,.75])
% if sign(profil.zmin)*sign(profil.zmax)<0
%     profil.Hzeroline=line(xlim,[0 0],'color','k');
% end
% box on
% 
% 
% function closewarn(src,evt)
%                   uiresume(Hwarn);
%                   close(Hwarn);
%                   clear Hwarn Hwarnchildrens;
% end
% 
% end