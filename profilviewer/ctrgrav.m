function [xgrav, ygrav]=ctrgrav(nstr)

%retourne le centre de gravite de la structure nstr lue dans le workspace commun

p = evalin('base',['profil.model(',num2str(nstr),').polyg;']);
p(size(p,1),:)=[];%supression du sommet de répétition
N = size(p,1);

xgrav = sum(p(:,1))/ N;
ygrav = sum(p(:,2))/ N;
