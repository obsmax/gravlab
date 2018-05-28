function [DIST, GCARC] = Ll2D(coo1, coo2)

%retourne la distance entre deux point du globe dans l'approximation spherique
%input :
% coo1 = vecteur 1 x 2, [Longitude, latitude] du point 1 en degres
% coo2 = vecteur 1 x 2, [Longitude, latitude] du point 2 en degres
%output :
% DIST  = distance separant les 2 point le long de l'equateur Eulerien qui
%        les relie
% GCARC = angle en radians entre ces 2 points

    lon1 = coo1(1);
    colat1 = 90 - coo1(2);
    lon2 = coo2(1);
    colat2 = 90 - coo2(2);
    
    GCARC = acos(cosd(colat1) * cosd(colat2) + sind(colat1) * sind(colat2) * cosd(lon2 - lon1));
    DIST = 6371 * GCARC;

end