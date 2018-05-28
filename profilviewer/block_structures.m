function block_structures(profil,excludedeselect,excluderightclic)
% deselectionne tout le monde,
% réattribu les couleurs et la transparence selon le mode de couleur choisi
% desactive le handle de clic sur structure
% desactive le clic droit
% le tout sera retabli par refresh_profil en mode model

%excludedeselect= vecteur des structures a NE PAS deselectionner (on les laisse en l'etat)
%exculderightclic= vecteur des structures pour lesquelles on NE DESACTIVE PAS les menus de clic droit (on les laisse en l'etat)
if nargin<2
    excludedeselect=[];
    excluderightclic=[];
elseif nargin < 3
    excluderightclic=[];
end


for struct=1:length(profil.model)
    %attribution de la couleur de la structure selon le colordisplay
    switch profil.model(struct).colordisplay
        case 'transparent'
            struct_color='none';
            struct_alpha=0;
        case 'by_color'
            struct_color=profil.model(struct).color;
            struct_alpha=1;
        case 'by_density'
            struct_color=getcolorfrom('density',profil.model(struct).rho);
            struct_alpha=1; 
        case 'by_order'
            struct_color=getcolorfrom('order',profil.model(struct).order);
            struct_alpha=1;
        case 'superposition_high'
            struct_color=profil.model(struct).color;
            struct_alpha=.2;
    end
    if isempty(find(excludedeselect==struct))
            %je passe la structure en mode deselectiné-tionable
            set(profil.model(struct).fill_handle,'selected','off',...
                'Edgecolor','k',...
                'linewidth',.5,...
                'Facecolor',struct_color,...
                'Facealpha',struct_alpha,...
                'buttonDownFcn',[])
            set(profil.model(struct).orig_handle,'visible','off')
    end
    if isempty(find(excluderightclic==struct))
            set(profil.model(struct).fill_handle,'uicontextmenu',[])
            set(profil.model(struct).orig_handle,'visible','off')
    end
end
