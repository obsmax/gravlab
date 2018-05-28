function scattlinks=find_links(profil,mode)

%links precision : deux sommets sont liés ssi ils sont égaux a 1e-3 pres
link_precision_x = 1e-3 * profil.xmax;
link_precision_y = 1e-3 * (profil.zmax - profil.zmin);


scattlinks=[];
%mode par defaut
if nargin == 1
    mode='sommet';
    warning(['gaffe, t''as pas précisé le mode pour find_links, le mode par défaut est ',mode])
end

%si on n'a pas encore de structures dans le model
if isempty(profil.model)
    scattlinks=[];
    return
end

switch mode
    
%% en mode 'sommet'
    case 'sommet'
        % %colonne 1 num de la structure dans profil.model
        % %colonne 2 num du sommet dans profil.model(colonne1).polyg
        % %colonnes 3 et 4 x et y du sommet
        % %colonnes 5 a 15 = lignes de scattlinks où trouver les sommets correspondants, si NaN=> il n'y a pas de liens
        % %colonne 16 = 1 pour le premier et le dernier sommet de chaque structure
        for i=1:length(profil.model)
            for j=1:profil.model(i).n%prend en compte la repetition du dernier sommet
                clear tmp
                tmp=( (j==1) || (j==profil.model(i).n) );
                scattlinks=[scattlinks;...
                    i,j,profil.model(i).polyg(j,:),NaN*zeros(1,11),tmp];
            end
        end
        %je parcours le nuage de point, je cherche dans les colonne 2 et 3 les
        %points de meme coordonnes, je vais trouver un vecteur d indices, l'un de
        %ces indices contient le sommet de base, je dois l ignorer. ensuite, je
        %complete les lignes indiquees par les indices

        for ligne=1:size(scattlinks,1)
            clear I Itmp
            I=find(  abs(  scattlinks(:,3)-scattlinks(ligne,3) ) <=link_precision_x ...
                   & abs(  scattlinks(:,4)-scattlinks(ligne,4) ) <=link_precision_y  )';
            %sum(Dscattclicpx(scattlinks(ligne,3:4), scattlinks(:,3:4), gca()) <= link_precision_px) == size(scattlinks,1)
            %I = find(Dscattclicpx(scattlinks(ligne,3:4), scattlinks(:,3:4), gca()) <= link_precision_px)';
            %I contient forcement la valeur ligne, on l enleve
            I(I==ligne)=[];
            if isempty(I)
                continue
            end
            %je cherche la premiere colonne libre de la ligne ligne
            Itmp=find(isnan(scattlinks(ligne,:)));
            colonnes=Itmp(1):Itmp(1)+length(I)-1;%si ca plente ici c est peut etre qu il y a plus de 10 liens sur ce sommet=> il n y a plus de place dans la ligne "ligne" de scattlinks
            scattlinks(ligne,colonnes)=I(1:length(I));
        end
%% mode segment
    case 'segment'
        % %colonne1    : numero de la structure dans profil.model
        % %colonne2    : numero du premier sommet du segment dans la structure décrite par la colonne 1
        % %colonne3    : xsommet1
        % %colonne4    : ysommet1
        % %colonne5    : numero du second  sommet du segment dans la structure décrite par la colonne 1
        % %colonne6    : xsommet2
        % %colonne7    : ysommet2
        % %colonne8    : ligne de la presente matrice ou trouver le segment lié au présent segment, il ne peu y en avoir qu'un, 2 segment ne peuvent pas etre lié sans partager leur deux sommets

        for i=1:length(profil.model)
            for j=1:profil.model(i).n-1
                scattlinks=[scattlinks;...
                    i,j,profil.model(i).polyg(j,:),j+1,profil.model(i).polyg(j+1,:),NaN];
            end
        end

        %vecteur des milieux de segments
        vms=[(scattlinks(:,3)+scattlinks(:,6))./2,(scattlinks(:,4)+scattlinks(:,7))./2];
        
        %recherche des milieux communs
        for ligne=1:size(scattlinks,1)
            clear I
            I=find( abs(vms(:,1)-vms(ligne,1))<=link_precision_x &...
                    abs(vms(:,2)-vms(ligne,2))<=link_precision_y );
            %I contient forcement la valeur ligne, on l enleve
            I(find(I==ligne))=[];
            if isempty(I)
                continue
            end
            %verification que les deux segment on au moins 1 sommet commun pour etre parfaitement sur
            if ( scattlinks(ligne,3)==scattlinks(I,3) && scattlinks(ligne,4)==scattlinks(I,4) ) || ( scattlinks(ligne,3)==scattlinks(I,6) && scattlinks(ligne,4)==scattlinks(I,7) )
                scattlinks(ligne,8)=I;
            end
        end
end

