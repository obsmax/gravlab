function buildsheet(curvesheet, panelparent, numXzfile)



[uu,vv] = size(curvesheet.uibuttongrp.units);
ff = fieldnames(curvesheet.uibuttongrp);
curvesheet.uibuttongrp.handle = cell(uu,vv);
for i = 1 : uu
    for j = 1 : vv
        str = ['curvesheet.uibuttongrp.handle(i,j) = {uibuttongrp1_1(''parent'', panelparent,'];
        for prop = 1:length(ff)
            str = [str,'''',ff{prop},''','];
            if isstr(curvesheet.uibuttongrp.(ff{prop}){i,j})
                str = [str, '''', curvesheet.uibuttongrp.(ff{prop}){i,j}, ''','];
            else
                str = [str,  mat2str(curvesheet.uibuttongrp.(ff{prop}){i,j}), ','];
            end
        end
        str(length(str))=[];
        str = [str, ')};'];
        eval(str)
    end
end


% 
[u,v] = size(curvesheet.uictrl.units);
f = fieldnames(curvesheet.uictrl);
curvesheet.uictrl.handle = cell(u,v);
for i = 1 : u
    for j = 1 : v
        if strcmpi(curvesheet.uictrl.visible{i,j}, 'off')
            continue
        end
        str = ['curvesheet.uictrl.handle(i,j) = {uictrl1_1('];
        for prop = 1 : length(f)
            str = [str,'''',f{prop},''','];
            if strcmpi(f{prop},'parent')
                str = [str, 'curvesheet.', curvesheet.uictrl.(f{prop}){i,j}, ','];
                continue
            end

            if isstr(curvesheet.uictrl.(f{prop}){i,j})
                str = [str, '''', curvesheet.uictrl.(f{prop}){i,j}, ''','];
            else
                str = [str,  mat2str(curvesheet.uictrl.(f{prop}){i,j}), ','];
            end
        end
        str(length(str))=[];
        str = [str, ')};'];
%         curvesheet.uictrl.handle(i,j) = {uictrl1_0('visible','off','parent',panelparent)};
        eval(str)
    end
end


%%evaluate some callbacks
curvemode(numXzfile);

% for prop = 1 : length(f)
%     for i = 1 : u
%         for j = 1 : v
%             set(curvesheet.uictrl.handle{i,j}, f{prop}, curvesheet.uictrl.(f{prop}){i,j})
%         end
%     end
% end
% 
% set(panelparent, 'resizeFcn', @resizecurvePanel)
% feval(@resizecurvePanel,panelparent)%mise d'applomb

%%
%     function resizecurvePanel(src, evnt) %#ok<INUSD>
%         %on aligne tout sur le haut du panel
%         %on conserve les dimensions en basculant tous les childrens sur pixel 
%         %src vaut le handel du panel parent
%         %les children ont dans leur userdata le nom de la resizefcn a utiliser
%         %pour eux
%         set(get(src,'children'),'units','pixel')
%         H = getpixelposition(src) * [0;0;0;1] - 5;
%         L = getpixelposition(src) * [0;0;1;0];
% 
%         a = cell2mat(get(get(src,'children'),'position'));
%         hcorr = max(a(:,2)) - H;%on recheche de combien les bouttons dépassent vers le haut pour le réaligner au top panel
%         %lcorr = max(a(:,1)) - L;
%         for iii = 1 : u
%             for jjj = 1 : v
%                 p =get(curvesheet.uictrl.handle{iii,jjj}, 'position');
%                 ud = get(curvesheet.uictrl.handle{iii,jjj}, 'userdata');
%                 if strcmp(ud, 'resize')
%                     %fonction par defaut, alignement sur le top
%                     set(curvesheet.uictrl.handle{iii,jjj}, 'position', ...
%                     p - [0, hcorr+p(4), 0,0] )                    
% %                 elseif strcmp(ud, 'resize_fixleft')
%                     %
%                 end
%                 
%             end
%         end
% 
%     end
%%

end