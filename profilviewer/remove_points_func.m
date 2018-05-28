function profil=remove_points_func(windows,session,profil)
    


%%
%determination du nuage de point et du tableau de lien entre les points
    %colonne 1 : num de la structure dans profil.model
    %colonne 2 : num du sommet dans profil.model(colonne1).polyg
    %colonnes 3 et 4 : x et y du sommet
    %colonnes 5 a 15 : lignes de scattlinks où trouver les sommets correspondants, si NaN=> il n'y a pas de liens
    %clonne 16 : 1 pour le premier et le dernier sommet de la structure 0 sinon, car ces deux sommets sont liés
    scattlinks=find_links(profil,'sommet');
    
%attribution des callbacks d'action
    endbutton=uimenu('label','|   ok',...
                    'callback',@findelafcn);               
    set(windows.homefig.handle,'windowbuttondown',@clic) 
    function clic(src,evnt)
        cp = get(gca,'currentpoint');
        xsourie = cp(1,1);
        ysourie = cp(1,2);
        [xsourie,ysourie,isdiff]=corrigeclic(xsourie,ysourie,windows,session,profil,'deplacement');
        if ~isempty(isdiff)
            if strcmp(isdiff{1},'som') %si l'utilisateur a cliqué sur un sommet
                %nstr = isdiff{2};nsom = isdiff{3};
                isoktoremove(isdiff{2}, isdiff{3}, scattlinks)
            end
        end
    end
    function findelafcn(src,evnt)
        set(endbutton,'visible','off');
        uiresume(gcf);
    end


uiwait
%% fonction interne / post uiwait
    function rep=isoktoremove(nstr,nsom,scattlinks)
        error('utiliser howmanylinks')
        I = (scattlinks(:,1) == nstr & scattlinks(:,2) == nsom);
        Nlink=sum(~isnan(scattlinks(I,5:15)));
        %pour effacer un sommet on s'assure qu'il n'ai pas de liens 
        %et que la structure aie strictement plus de 3 sommet (4 avec
        %la repetition)
        rep = false;
        if Nlink == 0 && size(profil.model(nstr).polyg,1) > 4
            rep = true;
        end
    end
end