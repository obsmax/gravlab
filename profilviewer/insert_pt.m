function polyg_out=insert_pt(polyg_in,npt,P)
%permet d inserer un sommet de coordonnees P (1x2) au polygone polyg_in apres le npt-ieme sommet
%attention, pour polyg, le dernier sommet correspond au premier

polyg_out=zeros(size(polyg_in,1)+1,2);
polyg_out(1:npt,:)=polyg_in(1:npt,:);
polyg_out(npt+1,:)=[P(1),P(2)];
polyg_out(npt+2:size(polyg_out,1),:)=polyg_in(npt+1:size(polyg_in,1),:);
end