function [xmax,model,erreur]=read_in(infile)

%permet de lire un fichier .in
% -> la premiere ligne doit contenir xmax en km et c'est tout
% -> ensuite je lit les blocs un par un
%    -> les blocs doivent etre separes par des (autant qu on veut) lignes vides ou blanches
%    -> chaque bloc possede une premiere ligne indiquant :
%            -> le nb de sommet de la structure (dernier sommet=premier sommet et compte comme un sommet a part entiere)
%            -> la densite
%            -> le reste de la ligne est lu en %s et est attribué comme nom de la structure, je vire juste les espace qui precedent la premiere lettre et qui suivent la derniere
%               si le reste de la ligne est vide ou que des espaces, on
%               l'appel structi ou i est le numero de la structure en partant de 1 pour la premiere
%    -> ensuite on donne sommet par sommet les coordonnees x y, l'axes des z est vers le haut (z<0 sous la surface), tout en km
%
%en sortie : 
% xmax la longueur du profil en km
% model une structure qui possede autant d'element qu il y a de polygones
%    pour tout polygle i :
%         model(i).n=nb de sommet, repetion comprise (%d)
%         model(i).rho=densite de la structure       (%f)
%         model(i).name=nom de la structure          (%s)
%         model(i).polyg=matrice a model(i).n lignes fois 2 colonnes
%                        la premiere colonne est x, la 2eme est y
%         model(i).order='clockwise' ou 'counterclockwise'
%         model(i).color=vecteur rvb de la couleur de la structure,
%                        nb la structure sera effectivemnt de cette couleur
%                        si colordispay est by_color
%         model(i).colordisplay=mode de colorisation de la structure
%                        by_color           = on lit la proporiete color
%                        by_density         = couleur propL a la densité
%                        by_order           = selon la prop order
%                        transparent        = pas de couleur
%                        superposition_high = mode qui fait apparaitre les superpositions entre les structures
%
%attention, cette fonction autorise plusieurs lignes entre chaque structure
%mais gravitom n'aime pas du tout ca, write_in.m veille au grain, donc si
%vous avez un fichier foireux, l'ouvrir et le réécrire peut arranger le pb
%nb, si vous n'avez pas donne de noms au structures, j attribu les noms
%structi et a l'ecriture ca sera ajoute au fichier. gravitom n a pas ete
%prevu pour ca mais ca ne le gene pas a priori



fid=fopen(infile,'r');
if fid==-1
    xmax=[];
    model=[];
    erreur=1;
    return
end

xmax=str2num(fgetl(fid));


if ~isstr(fgetl(fid))
    model=[];
    erreur=0;
    %ce n est pas une erreur mais le profil est vide
    return
end


%on avance jusqu au premier bloc et on en lit la premiere ligne
while 1
    ligne=fgetl(fid);
    if ~isstr(ligne)
        model=[];
        erreur=1;
        return
    end
    if ~isempty(ligne) && sum(isspace(ligne))~=length(ligne)
        break
    end
end


struct=0;stop=0;
while 1
    struct=struct+1;
    
    %a ce stade, la premiere ligne du bloc est lue
    [n,tmp]=strtok(ligne);
    model(struct).n=str2num(n);
    [rho,tmp]=strtok(tmp);
    model(struct).rho=str2num(rho);
    while ~isempty(tmp)
        if isspace(tmp(1))
            tmp(1)=[];
        elseif isspace(tmp(length(tmp)))
            tmp(length(tmp))=[];
        else
            break
        end
    end
    if ~isempty(tmp)
        model(struct).name=tmp;
    else
        model(struct).name=['str',num2str(struct)];
    end
    clear tmp n rho
    
    model(struct).polyg=zeros(model(struct).n,2);
    for i=1:model(struct).n
        model(struct).polyg(i,:)=str2num(fgetl(fid));
    end
    
    switch isclockwise(model(struct).polyg)
        case 1
            model(struct).order='clockwise';
        case 0
            model(struct).order='counterclockwise';
        otherwise
            model(struct).order='error';
    end
   
    
    %on avance jusqu au bloc suivant et on en lit la premiere ligne
    while 1
        ligne=fgetl(fid);
        if ~isstr(ligne)
            stop=1;
            break
        end
        if ~isempty(ligne) && sum(isspace(ligne))~=length(ligne)
            break
        end
    end
    if stop
        clear stop
        break
    end
end
fclose(fid);
erreur=0;

    
%% default color
%attribution des couleur et couleurdisplay par defaut car inexistant dans
%le fichier
default_colordisplay='transparent';
for struct=1:length(model)
    model(struct).color=getcolorfrom('default',struct);
    model(struct).colordisplay=default_colordisplay;
end
%voir getpolyg.m pour la coloration des nouovelles structures

