function copyprofil(profil, ax)

axes(ax)
set(ax,'units','normalized',...
         'visible','on')
box on
xlim([0,profil.xmax])
ylim([profil.zmin, profil.zmax])
xlabel('x (km)')
ylabel('z (km)')
c=colorbar('location', 'EastOutside', ...
    'units','normalized',...
    'Xaxislocation','top',...
    'position', [.94,0, .01, 0]+get(gca(),'position').*[0,1,0,1]);
set(get(c,'xlabel'),'string', 'rho(g/cm^3)')
colormap(yarg(100))

hold on
for struct=1:length(profil.model)
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
        case 'by_order' %on se fie a ce qui est dans le champ order, plus bas on renverse le polyg si besoin
            struct_color=getcolorfrom('order',profil.model(struct).order);
            struct_alpha=1;
        case 'superposition_high'
            struct_color=profil.model(struct).color;
            struct_alpha=.2;
    end
    profil.model(struct).fill_handle=fill(profil.model(struct).polyg(:,1),profil.model(struct).polyg(:,2),[1 1 1],...
        'SelectionHighlight','off',...
        'Edgecolor','k',...
        'linewidth',.5,...
        'Facecolor',struct_color,...
        'Facealpha',struct_alpha);
end

