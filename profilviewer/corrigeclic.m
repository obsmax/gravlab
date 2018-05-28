function [xrctre,yrctre,isdifferent]=corrigeclic(x,y,windows,session,profil,mode)
    %cette fonction se charge de lire le profil et de corriger les coordonnees de clic si necessaire
    %en entree :
    %x y sont les coordonnees brutes
    %profil permet de nous renseigner sur les structures deja existente
    %session nous donne les options de recentrage
    %mode='creation'     utilisation des options de recentrage pour la saisie d'une nouvelle structure, 
         %'deplacement'  utilisation des options de recentrage pour le déplacement d'un jeu de sommets
    %en sortie :
    %xrctre, yrctre = coordonnees apres correction
    %isdifferent={} s'il n y a pas eu de recentrage
    %           ={'som',nstr,nstrpt}, si recentrage sur sommet
    %                   nstr = numero de la structure a laquelle appartient le sommet sur lequel on se recentre
    %                   nstrpt = numero du sommet de nstr sur lequel on se recentre
    %           ={'seg',nstr,nstrpt} si recentrage sur segment
    %                   nstr = numero de la structure a laquelle appartient le segment sur lequel on se recentre
    %                   nstrpt = numero du sommet de nstr qui precede le sommet a ajouter dans nstr
    %           ={'bor'} si recentrage sur bord de profil 
    %           ={'top'} si on recentre sur le top profil
    %           ={'bot'} si on recentre sur le bottom profil
    %           ={'bor','top'} ou {'bor','bot'} en cas de double recentrage
    
    %initialisation
    isdifferent={};
    xrctre=x;
    yrctre=y;
    scattlinks=find_links(profil,'sommet');
    segscattlinks=find_links(profil,'segment');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % mode d'appel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(mode,'creation')
        rs             =session.options.recentrage_sommet;
        rs_units       =session.options.recentrage_sommet_units;
        rs_distance    =session.options.recentrage_sommet_distance;
        rseg           =session.options.recentrage_segment;
        rseg_units     =session.options.recentrage_segment_units;
        rseg_distance  =session.options.recentrage_segment_distance;
        rbor           =session.options.recentrage_bords;
        rbor_units     =session.options.recentrage_bords_units;
        rbor_distance  =session.options.recentrage_bords_distance;
        rbot           =session.options.recentrage_bottom;
        rbot_units     =session.options.recentrage_bottom_units;
        rbot_distance  =session.options.recentrage_bottom_distance;
        rtop           =session.options.recentrage_top;
        rtop_units     =session.options.recentrage_top_units;
        rtop_distance  =session.options.recentrage_top_distance;
    elseif strcmp(mode,'deplacement')
        rs             =session.options.recentrage_deplacement_sommet;
        rs_units       =session.options.recentrage_deplacement_sommet_units;
        rs_distance    =session.options.recentrage_deplacement_sommet_distance;
        rseg           =session.options.recentrage_deplacement_segment;
        rseg_units     =session.options.recentrage_deplacement_segment_units;
        rseg_distance  =session.options.recentrage_deplacement_segment_distance;
        rbor           =session.options.recentrage_deplacement_bords;
        rbor_units     =session.options.recentrage_deplacement_bords_units;
        rbor_distance  =session.options.recentrage_deplacement_bords_distance;
        rbot           =session.options.recentrage_deplacement_bottom;
        rbot_units     =session.options.recentrage_deplacement_bottom_units;
        rbot_distance  =session.options.recentrage_deplacement_bottom_distance;
        rtop           =session.options.recentrage_deplacement_top;
        rtop_units     =session.options.recentrage_deplacement_top_units;
        rtop_distance  =session.options.recentrage_deplacement_top_distance;
    else
         warning('unknown mode %s, correction not applied',mode)
         return
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) corrections sur sommet
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(rs,'on') && length(profil.model)>=1 

        clear is_nearpoint D_scatt_clic Dmin iDmin
        
        %vecteur des distances entre la saisie et les points disponibles
        D_scatt_clic=Dscattclicpx([xrctre,yrctre],scattlinks(:,[3,4]));%sqrt((xrctre-scattlinks(:,3)).^2+(yrctre-scattlinks(:,4)).^2);
        

        
        %estimation de la distance absolue de recentrage sur sommet
        switch rs_units
            case {'pixels'}          %la distance de recentrage sur sommet s'exprime dans la meme unite que les distances du profil
                recentrage_sommet_distance_pixels=rs_distance;
            otherwise
                error('seul le mode pixels est accepté')
        end
        
        %indices des sommets de scattlinks qui satisfont au critere de proximite
        is_nearpoint=find( D_scatt_clic <= recentrage_sommet_distance_pixels );
        
        %si il y a des candidats
        if ~isempty(is_nearpoint)
            
            %on recherche parmis les candidat ceux qui sont le plus proche ex-aequo
            [Dmin,iDmin]=min(D_scatt_clic(is_nearpoint));
            
            %on garde le premier des ex-aequo
            xrctre=scattlinks(is_nearpoint(iDmin(1)),3);
            yrctre=scattlinks(is_nearpoint(iDmin(1)),4);
            
            %on rends le mot clé 'som', le numero de la structure sur laquelle on se recentre et le numero du sommet sur lequel on se recentre
            isdifferent={'som',scattlinks(is_nearpoint(iDmin(1)),1),scattlinks(is_nearpoint(iDmin(1)),2)};
            
            %on affiche un message dans la boite de diqlogues
            set(windows.homefig.dlgbox,'string','recentrage sur sommet','Foregroundcolor','r');
            
            %si on a recentré sur sommet on peut quitter la correction de clic
            return
            
        end
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %2) corrections sur segment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(rseg,'on') && length(profil.model)>=1
        %segscattlinks possede en 
        %    colonne 1  : numero de la structure concernee
        %    colonne 2  : numero du premier sommet du segment dans profil.model(colonne1).polyg
        %    colonne 3  : x du debut de segment
        %    colonne 4  : y du debut de segment
        %    colonne 5  : numero du premier sommet du segment dans profil.model(colonne1).polyg
        %    colonne 6  : x de la fin de segment
        %    colonne 7  : y de la fin de segment
        %    colonne 8  : NaN ou ligne de segscattlinks ou trouver le segment lié

        
        %calcul de la distance entre le clic et les segment disponibles, 
            %la projection orthogonale et on verifie si on est entre les deux extremites
            %D_segscatt_clic_px s'exprime en pixels
        [D_segscatt_clic_px,Mproj_clic_seg,isbetween]=dist_dr_pt_px(segscattlinks(:,3:4),segscattlinks(:,6:7),[xrctre,yrctre]);

        
        %calcul de la distance de recentrage sur segment
        switch rseg_units
            case {'pixels'}
                recentrage_segment_distance_pixels=rseg_distance;
            otherwise 
                error('seul le mode de recentrage sur segment "pixels" est accepté')
        end
        
        
        %on cherche les segments pour lesquels la projection du clic est entre les deux sommets 
            % et la distance est inferieure a la distance de recentrage sur segment
        isok_ind=find(isbetween & D_segscatt_clic_px <= recentrage_segment_distance_pixels);
        
        %%%%si on a plusieurs candidats, on prend le premier mais il faut prendre le plus proche
        %penser a ajouter une point dans la structure numeros scatt_seg(isok_ind(1),1)
        %juste apres le sommet numero scatt_seg(isok_ind(1),2)
        if ~isempty(isok_ind)
            
            xrctre=Mproj_clic_seg(isok_ind(1),1);
            yrctre=Mproj_clic_seg(isok_ind(1),2);
            
            %on rend 'seg' le numero de la structure sur laquelle on se recentre et le numero du premier sommet
            isdifferent={'seg',segscattlinks(isok_ind(1),1),segscattlinks(isok_ind(1),2)};

            %on affiche un message pour annoncer qu'il y a eu recentrage
            set(windows.homefig.dlgbox,'string','recentrage sur segment','Foregroundcolor','r');
            
            %si on a recentré sur segment on peut quitter la correction de clic
            return
            
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %3) corrections sur bord de profil
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ici on ne gere que les bords lateraux

    if strcmp(rbor,'on')
        
        %calcul de la distance absolue de recentrage sur bords
        switch rbor_units
            case {'pixels'}          %la distance de recentrage sur bords s'exprime dans la meme unite que les distances du profil
                recentrage_bords_distance_absolue=rbor_distance * diff(xlim()) / (getpixelposition(gca()) * [0;0;1;0]);
            otherwise
                error('seul le mode pixels est accepté')
        end

        
        %correction de x sur les bords gauche puis droit
        if xrctre <= recentrage_bords_distance_absolue
            xrctre=0;
            isdifferent={'bor'};
        elseif xrctre >= profil.xmax-recentrage_bords_distance_absolue
            xrctre=profil.xmax;
            isdifferent={'bor'};
        end

        if ~isempty(isdifferent)
            %message
            set(windows.homefig.dlgbox,'string','recentrage sur bord de profil','Foregroundcolor','r');
            %return, il se peut qu il y ait un recentrage sur top ou bottom
            %a faire!!!
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %4) corrections sur le bottom du profil
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %correction de y sur le fond du profil
    if strcmp(rbot,'on')
        
        %calcul de la distance de recentrage sur fond de profil
        switch rbot_units
            case {'pixels'}          %la distance de recentrage sur bottom s'exprime dans la meme unite que les distances du profil
                recentrage_bottom_distance_absolue = rbot_distance * diff(ylim()) / (getpixelposition(gca()) * [0;0;0;1]);
            otherwise
                error('recentrage sur bottom, seul le mode pixels est desormais autorisé')
        end
 
        if yrctre <= profil.zmin+recentrage_bottom_distance_absolue
            yrctre=profil.zmin;
            isdifferent=[isdifferent,{'bot'}];

            %message
            set(windows.homefig.dlgbox,'string','recentrage sur bottom de profil','Foregroundcolor','r');
            return
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %5) corrections sur le top du profil
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(rtop,'on')
        %calcul de la distance de recentrage sur top de profil
        switch rtop_units
            case {'pixels'}          %la distance de recentrage sur top s'exprime dans la meme unite que les distances du profil
                recentrage_top_distance_absolue = rtop_distance * diff(ylim()) / (getpixelposition(gca()) * [0;0;0;1]);
            otherwise
                error('seul le mode pixels est autorisé')
        end
        
        if yrctre>=profil.zmax-recentrage_top_distance_absolue
            yrctre=profil.zmax;
            if isempty(isdifferent)
                isdifferent={'top'};
                set(windows.homefig.dlgbox,'string','recentrage sur le top profil','Foregroundcolor','r');
            else %on a aussi un correction de bord
                isdifferent=[isdifferent,{'top'}];%au cas ou on ai une correction sur bord et sur top            
                set(windows.homefig.dlgbox,'string','recentrage sur bord de profil + recentrage top','Foregroundcolor','r');
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %fonctions annexes de meme workspace que corrigeclic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function closewarn(src,evtn,Hwarn,Hwarnchildrens)
        uiresume(Hwarn);
        close(Hwarn);
        clear Hwarn Hwarnchildrens;
    end


    %qd meme, on verifie 
    if xrctre==x && yrctre==y
        isdifferent={};
    end
        
end
