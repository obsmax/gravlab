function rvb=getcolorfrom(mode,value)


%retourne le code rvb correspondant a la proriete definie par mode.
%l'echelle de couleur est definie ici, on ne touche pas a la colormap ca
%n'a rien a voir.

switch mode
    case 'density'
        if isnan(value)
            rvb=[1 0 0];
        else
            Ncolor=100;%nombre de couleurs entre la min et la max
            cmin=1.5;  %valeur coté blanc
            cmax=3.5;  %valeur coté noir
        
            cmap=yarg(Ncolor); %echelle de couleur= gray a l'envers
        
            set(gca,'climmode','manual','clim',[cmin,cmax])
            i=floor((Ncolor-1)*max([0.0,min([(value-cmin)/(cmax-cmin),1.0])]))+1;
            %nb la color map est clippée, ie si on dépasse les bord, l'échelle
            %de couleur ne s'adapte pas=> tout ce qui est au dessus de cmax
            %reste noir
            rvb=cmap(i,:);
        end
    case 'order'
        rvb=[strcmp(value,'counterclockwise'),...
            strcmp(value,'clockwise')*2/3,...
            0.05*strcmp(value,'clockwise')];
    case 'default'
        defaultcolormap=[0    0    1  ;
                         0    1    0  ;
                         0    .5   .5 ;
                         1    1    0  ;
                         .5   0    .5
                         1   .5   0   ;
                         .3   .7   1  ;
                         .5   0    0  ;
                         1    0    1  ;
                         0    .5   0];
                     
        while value>size(defaultcolormap,1)
            value=value-size(defaultcolormap,1);
        end
        rvb=defaultcolormap(value,:);
                         
    otherwise
        rvb=[0 0 0];
        warning(['unkown mode ',mode])
end

end