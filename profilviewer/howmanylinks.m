function [Nlinks,Autolink] = howmanylinks(nstr,nsom,scattlinks)

%Nlinks vaut le nombre de liens entre un sommet et les autres structures
%Autolink vaut 1 si le sommet est premier oudernier de sa structure

I = (scattlinks(:,1) == nstr & scattlinks(:,2) == nsom);
Autolink = scattlinks(I,16);
Nlinks = sum(~isnan(scattlinks(I,5:15))) - Autolink;

