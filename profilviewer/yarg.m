function cmap=yarg(N)

%c'est gray a l'envers

cmap=gray(N);
cmap=cmap(size(cmap,1):-1:1,:);