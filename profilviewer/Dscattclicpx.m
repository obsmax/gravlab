function Dpx = Dscattclicpx(CLIC,SCATT,AXE)

% retourne le vecteur des distances EN PIXELS entre le point CLIC 
% et le nuage de point SCATT
%input :
%    CLIC  = vecteur 2x1 ou 1x2 des coordonnées du clic
%    SCATT = matrice Nx2 des coordonnées des nuages de point
%   [AXE   = handle d'axe dans lequel vous travaillez, par default, on
%            utilise gca]

if nargin == 0
    help Dscattclic
    return
elseif nargin == 2
    AXE = gca();
end


limx = xlim();
limy = ylim();
tmp = getpixelposition(AXE) * [0 0;0 0;1 0;0 1];
Lpx = tmp(1); Hpx = tmp(2);
SCATT(:,1) = Lpx * (SCATT(:,1) - limx(1))./(diff(limx));
SCATT(:,2) = Hpx * (SCATT(:,2) - limy(1))./(diff(limy));
CLIC(1) = Lpx * (CLIC(1) - limx(1))./(diff(limx));
CLIC(2) = Hpx * (CLIC(2) - limy(1))./(diff(limy));

Dpx = sqrt( sum(([ SCATT(:,1) - CLIC(1),  SCATT(:,2) - CLIC(2)]).^2, 2) );