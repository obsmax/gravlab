function FV = POLYG2_1(XMES,ZMES,X,Z,RHO)
    %convention X(length(X))==X(1) && Z(length(Z))==Z(1)
    %XMES/ZMES = vecteurs de mesures
    %X/Z vecteurs de coordonnees AVEC REPETITION DU DERNIER!!!
    %RHO est un scalaire
    NMES = length(XMES);
    NP = length(X)-1;
    FV = zeros(NMES,NP);
    ANGL =zeros(NMES,NP);

    [X,XMES] = meshgrid(X,XMES);
    [Z,ZMES] = meshgrid(Z,ZMES);

    
    X = X-XMES;
    Z = Z-ZMES;
    XPHIt = diff(X,[],2);
    ZPHIt = diff(Z,[],2);
    XPHI=XPHIt(1:numel(XPHIt))';
    ZPHI=ZPHIt(1:numel(ZPHIt))';
    R = X.^2 + Z.^2;

    I0 = true(NMES,NP);
    I1 = [I0,false(NMES,1)];
    I2 = [false(NMES,1),I0];
	ANGL = difarcopt(X(I2),Z(I2),X(I1),Z(I1));
    
    IR = R(I1) == 0 | R(I2) == 0;
    IANGL = ~IR & ANGL == 0;
    IX1 = ~IR & ~IANGL & XPHI == 0;
    IX2 = find(IX1)+NMES;%[false(NMES,1);IX1(1:length(IX1)-NMES)];
    IZ1 = ~IR & ~IANGL & ~IX1 & ZPHI == 0;
    %IZ2 = [false;IZ1(1:length(IZ1)-1)];
    IO1 = ~IR & ~IANGL &  ~IX1 & ~IZ1;
    IO2 = find(IO1)+NMES;%[false(NMES,1);IO1(1:length(IO1)-NMES)];

    
    FV(IX1) = .5 * X(IX1) .* log(R(IX2)./R(IX1));
    
    FV(IZ1) = -Z(IZ1) .* ANGL(IZ1);
    
    XPHI = XPHI(IO1);
    ZPHI = ZPHI(IO1);
    TGPHI = ZPHI./XPHI;
    A = (X(IO1).*Z(IO2) - X(IO2).*Z(IO1)).*XPHI;
    A  = A ./ (XPHI.^2 + ZPHI.^2);
    FV(IO1) = A .* (ANGL(IO1) + .5 * TGPHI .* log(R(IO2)./R(IO1)) );
    FV = 6.67*2*RHO*sum(FV,2)';
end

function R3 = difarcopt(RN1,D1,RN2,D2)
    if ~((length(RN1) == length(D1)) && (length(RN1) == length(RN2)) && (length(RN1) == length(D2)))
        error('~((length(RN1) == length(D1)) && (length(RN1) == length(RN2)) && (length(RN1) == length(D2)))')
    end
    R3 = arctopt(RN1, D1) - arctopt(RN2, D2);
    I1 = (abs(R3) > pi) & (R3 >= 0);
	I2 = (abs(R3) > pi) & (R3 < 0);
    R3(I1) = R3(I1) - 2*pi;
    R3(I2) = R3(I2) + 2*pi;
end

function R = arctopt(RN,D)
    if length(RN) ~= length(D)
        error('length(RN) ~= length(D)')
    end
    %indexation booleenne
    I1 = D==0 & RN == 0;
    I2 = D>0;
    I3 = RN >0;
    R = atan(RN./D) + pi;
    R(I3) = atan(RN(I3)./D(I3)) - pi;
    R(I2) = atan(RN(I2)./D(I2));
    R(I1) = 0;
end


% function R3 = DIFARC(RN1,D1,RN2,D2)
%     R3 = ARCT(RN1, D1) - ARCT(RN2, D2);
%     if abs(R3) > pi
%         if R3 >= 0
%             R3 = R3 -2*pi;
%         else
%             R3 = R3 +2*pi;
%         end
%     end
% end
% 
% function R = ARCT(RN,D)
%     if D==0 && RN == 0
%         R=0;
%     elseif D>0
%         R = atan(RN/D);
%     elseif RN >0
%         R = atan(RN/D) - pi;
%     else
%         R = atan(RN/D) + pi;
%     end
% end
