function answer=isclockwise(P)

%P(:,1) = x coordinate
%P(:,2) = y coordinate
%!!!!!!!!!!!!!!!!!!!!!!! the last summit = the first one !!!!!!!!!!!!!!!!!!
if sqrt((P(size(P,1),:)-P(1,:)).^2) > 1e-3
	warning('le dernier sommet doit etre egale au premier a ~1e-3 près (par convention))')
    answer=NaN;
    return
end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

N=size(P,1);
A=sum(.5*(P(1:N-1,1).*P(2:N,2)-P(2:N,1).*P(1:N-1,2)));
answer=logical(-sign(A)/2+.5);


