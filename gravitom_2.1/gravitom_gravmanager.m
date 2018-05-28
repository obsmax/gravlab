function g = gravitom_gravmanager(xmes, zmes, irecal, irecalmean, prolh, prolhdist) 

xmax = evalin('base', 'profil.xmax');
model =  evalin('base', 'profil.model');

%g initialisation
g = zeros(size(xmes));
 
%prolh
polygtmp = cell(1,length(model));
for i = 1 : length(model)
    if prolh
        polygtmp{i} = PROLH2_1(model(i).polyg,...
                                    xmax,...
                                    prolhdist);
    else
        polygtmp{i} = model(i).polyg;
    end
end

%polyg
for i = 1 : length(model)
    g = g + POLYG2_1(xmes,...
                 zmes,...
                 polygtmp{i}(:,1),...
                 polygtmp{i}(:,2),...
                 model(i).rho);
end

%irecal
if irecal
    g = g - mean(g) + irecalmean;
end


end