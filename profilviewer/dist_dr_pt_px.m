function [Dpx,M,verif]=dist_dr_pt_px(A,B,P,axe_handle)

% Calcul le projeté orthogonal apparent d'un point sur un segment
% Soit R le repère réel, basé sur les coordonnées des axes
% ce repère est orthogonal mais rarement orthonormé
% Soit R' le repère apparent ie en pixels, il est toujours orthonormé,
%         on se sert des dimensions des axes au moment de l'appel
% Si on projette P sur (AB) dans R et que R n'est pas normé, la projection aura l'air fausse
% => necessité de projeter dans R' même s'il ne sagit pas d'une véritable projection orthogonale
%A   = vecteur 2x1 : coordonnees du point A dans le repere R
%B   = vecteur 2x1 : coordonnees du point B dans le repere R
%P   = vecteur 2x1 : coordonnees du point P dans le repere R
%[axe_handle] = handle d'axe a utiliser pour R', par defaut on utilise gca
% on projette P sur la droite (AB) dans R'
%M   = vecteur 2x1 : coordonnees du projeté de M dans le repere R
%Dpx = distance PM dans le repère R', cette distance s'exprime en pixels
%verif vaut 1 si M est entre A et B

if nargin == 0
    help dist_dr_pt_px
    return
elseif nargin < 4
    axe_handle = gca();
end

%a optimiser serieusement!!!!!!!!!!!!!!!!!!!!!!
%de plus il s agit d une projection hortognale mais ca ne marche pas dans
%un repere non orthonorme


% ajout 4-03-2012 pour une projection apparament orthogonale
limx = xlim();
limy = ylim();
tmp = getpixelposition(axe_handle) * [0 0;0 0;1 0;0 1];
Lpx = tmp(1); Hpx = tmp(2);
A(:,1) = Lpx * (A(:,1) - limx(1))./(diff(limx));
B(:,1) = Lpx * (B(:,1) - limx(1))./(diff(limx));
A(:,2) = Hpx * (A(:,2) - limy(1))./(diff(limy));
B(:,2) = Hpx * (B(:,2) - limy(1))./(diff(limy));
P(1) = Lpx * (P(1) - limx(1))./(diff(limx));
P(2) = Hpx * (P(2) - limy(1))./(diff(limy));
% fin ajout, il reprend en fin de fonction

%----------
Dpx=zeros(size(A,1),1);
M=zeros(size(A,1),2);
verif=zeros(size(A,1),1);
%----------

x=P(1);y=P(2);
for i=1:size(A,1)
    xA=A(i,1);yA=A(i,2);
    xB=B(i,1);yB=B(i,2);

    
    if xB~=xA || yB~=yA
        Dpx(i)=abs((xB-xA)*y+(yA-yB)*x+(xA*(yB-yA)-yA*(xB-xA)))/(sqrt((yA-yB)^2+(xB-xA)^2));
%     else
%         D(i)=0;
    end
    if xA~=xB && yA~=yB
        xM=(x+xA*((yB-yA)/(xB-xA))^2+(y-yA)*((yB-yA)/(xB-xA)))/((yB-yA)^2/((xB-xA)^2)+1);
        yM=(x-xM)*(xB-xA)/(yB-yA)+y;
    elseif xA==xB
        yM=y;
        xM=xA;
    else
        xM=x;
        yM=yA;
    end

    M(i,:)=[xM,yM];
    verif(i)=1;
    if xM< min([xA,xB]) || xM > max([xA,xB])
        verif(i)=0;
    end
    if yM< min([yA,yB]) || yM > max([yA,yB])
        verif(i)=0;
    end
end



% ajout 4-03-2012 pour une projection apparament orthogonale
M(:,1) = limx(1) + M(:,1) * diff(limx) / Lpx;
M(:,2) = limy(1) + M(:,2) * diff(limy) / Hpx;
% fin ajout

end


