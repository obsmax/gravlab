function [X,Y,Z]=rxyz2_0(xyzfile)
A=load(xyzfile);
x=A(:,1);
y=A(:,2);
z=A(:,3);
%rep vaut 1 si on doit commencer une nouvelle ligne
rep=ones(length(x),1);
rep=abs(diff([x(1);x]));
rep(find(rep<mean(rep)))=0;
rep=logical(rep);


%recuperation des indices de debut et fin de ligne de x
tmp=find(rep);
a=[[1;tmp],[tmp;length(rep)+1]-1];

X=NaN*zeros(max(diff(a,1,2)),size(a,1));
Y=X;
Z=X;


for i=1:size(a,1)
    X(1:(a(i,2)-a(i,1))+1,i)=x(a(i,1):a(i,2));
    Y(1:(a(i,2)-a(i,1))+1,i)=y(a(i,1):a(i,2));
    Z(1:(a(i,2)-a(i,1))+1,i)=z(a(i,1):a(i,2));
end

X(find(X==0))=NaN;
Y(find(Y==0))=NaN;


% pcolor(X,Y,Z)
% shading flat
% axis square