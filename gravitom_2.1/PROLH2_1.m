function polygpro=PROLH2_1(polyg,xmax,prolhdist)

X=polyg(:,1);%convention : repetition du dernier sommet!!!
Y=polyg(:,2);%convention : repetition du dernier sommet!!!

I1 = 1:length(X)-1;
I2 = 2:length(X);

Idoublet = X(I1)==X(I2);
Ileft = X(I1)==0;
Iright = X(I1)==xmax;

% Xpro = zeros(1,length(X)+3*sum(Idoublet & (Ileft | Iright)));
% Ypro = Xpro;

XXX = NaN * zeros(3,length(I1));
YYY = [Y(I1)';Y(I1)';Y(I2)'];
XXX(1,:)=X(I1);
YYY(1,:)=Y(I1);
XXX(2:3,Idoublet & Ileft)=-prolhdist;
XXX(2:3,Idoublet & Iright)=xmax + prolhdist;
Xpro = XXX(~isnan(XXX));
Ypro = YYY(~isnan(XXX));

polygpro(:,1)=[Xpro;Xpro(1)];%repetition du dernier sommet!!!
polygpro(:,2)=[Ypro;Ypro(1)];%repetition du dernier sommet!!!
% Xpro=[];Ypro=[];
% for i = 1 : length(X)-1
%     if X(i)==0 && X(i+1)==0
%         Xpro=[Xpro,X(i),-500000,-500000];
%         Ypro=[Ypro,Y(i),Y(i),Y(i+1)];
%     elseif X(i)==xmax && X(i+1)==xmax
%         Xpro=[Xpro,X(i),xmax+500000,xmax+500000];
%         Ypro=[Ypro,Y(i),Y(i),Y(i+1)];
%     else
%         Xpro=[Xpro,X(i)];
%         Ypro=[Ypro,Y(i)];
%     end
% end
% Xpro=[Xpro,Xpro(1)];
% Ypro=[Ypro,Ypro(1)];
