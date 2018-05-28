function [xx, yy, dd, zz, Dangle]=coo2sec(lon, lat, N, X, Y, Z)

% lon = vecteur des longitudes en degrés des coins de la section 
% lat = vecteur des latitudes en degrés des coins de la section 
% N   = nombre de points voulus
% X, Y, Z = carte de donnees

% on se place dans l'approximation spherique

dist = zeros(1, length(lon)-1);%vecteur des distances en km de chaque tronçon
n = zeros(1, length(lon)-1);%vecteur des nombres de points par tronçon
for i = 1 : length(lon) -1 
    dist(i) = abs(Ll2D([lon(i), lat(i)], [lon(i+1), lat(i+1)]));
end

Nr = N / sum(dist); %nombre de point par unite de distance
n = round(Nr * dist);
dist = [0, cumsum(dist)];
%fid = fopen('bid.txt','w');
xx = [];
yy = [];
dd = [];
zz = [];
Dangle=[];
for i = 1 : length(lon) - 1 
    %fprintf('segment %d\nLon(deg) Lat(deg) Anom(?)\n', i)
    xi = linspace(lon(i), lon(i+1), n(i));
    yi = linspace(lat(i), lat(i+1), n(i));
    [Xi, Yi] = meshgrid(xi,yi);
    z = griddata(X,Y,Z,Xi,Yi, 'nearest');
    zi = diag(z)';
    di = linspace(dist(i), dist(i+1), n(i));
    %fprintf(fid, '%f %f %f %f\n', [xi', yi', di', zi']');
    xx = [xx,xi];
    yy = [yy,yi];
    zz = [zz,zi];
    dd = [dd,di];
    Dangle=[Dangle, di(length(di))];
end
Dangle(length(Dangle))=[];
%fclose(fid);


end



