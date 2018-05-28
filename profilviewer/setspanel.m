function p=setspanel(varargin)%(Parent,Title,NormalizedPosition,Nl,Nc,LinesHeight,ColumnsWidth,cstyle,NormalizedVerticalSliderWidth_locked,VerticalSliderValue,NormalizedHorizontalSliderHeight_locked,HorizontalSliderValue,StringCell)

%essai

if nargin==0
    home
    disp('permet de creer ou modifier un panel glissant');
    disp('-------------------------------------------------');
    disp('*utilisation 1 : creation d un spanel')
    disp('    p=setspanel(propertie1,value1,propertie2,value2,...);')
    disp('    %p est la structure des caracteristiques du spanel')
    disp('    %exemple :')
    disp('       p0=setspanel(''Title'',''essai'',''NormalizedPosition'',[0,0,.5,.5])')
    disp('*utilisation 2 : modification d un spanel')
    disp('    p1=setspanel(p0,propertie1,value1,propertie2,value2,...);')
    disp('    %p0 est la structure des caracteristiques du spanel avant modification')
    disp('    %p1 est la structure des caracteristiques du spanel apres modification')
    disp('    %exemple :')
    disp('       p0=setspanel(''Title'',''essai'',''NormalizedPosition'',[0,0,.5,.5])')
    disp('       p0=setspanel(p0,''Title'',''essai de modification'',''NormalizedPosition'',[.5,.5,.5,.5])');
    disp('*utilisation 2 bis :')
    disp('    %vous pouvez creer un spanel avec l utilisation 1,')
    disp('    %modifier la structure manuellement,')
    disp('    %et mettre a jour le spanel, attention certaines prop doivent rester coherentes entre elles')
    disp('    %exemple :')
    disp('       p0=setspanel(''Title'',''essai'',''NormalizedPosition'',[0,0,.5,.5])')
    disp('       p0.Title=''essai de modification''')
    disp('       p0.NormalizedPosition=[.5 .5 .5 .5];')
    disp('       p0=setspanel(p0);')
    disp('-------------------------------------------------');
    disp('proprietes disponibles :')
    disp('Parent       = handle de la figure hote')
    disp('                  [gcf]')
    disp('Title           = Titre du panel');
    disp('                  ['''']')
    disp('BackgroundColor = couleur de fond')
    disp('                  [[.5,.5,.5]]')
    disp('NormalizedPosition         = [abscisse bord gauche, ordonne bord inf, largeur, hauteur] en unit normalisee')
    disp('                  [pas de valeur par defaut]')
    disp('VerticalSliderWidthPixel             = largeur du slider vertical   en pixels')
    disp('                  ')
    disp('VerticalSliderValue           = position initiale du slider vertical   entre 0 et 1')
    disp('                  ')
    disp('VerticalSliderStep          = step du slider vertical, vecteur de 2 elements entre 0 et 1')
    disp('                  ')
    disp('HorizontalSliderHeightPixel             = hauteur du slider horizontal en pixels')
    disp('                  ')
    disp('HorizontalSliderValue           = position initiale du slider horizontal entre 0 et 1')
    disp('                  ')
    disp('HorizontalSliderStep          = step du slider vertical, vecteur de 2 elements entre 0 et 1')
    disp('                  ')
    disp('StringCell            = cellule 2D des inscriptions a mettre dans les cases')
    disp('                  ')
    disp('LinesHeight              = vecteur des hauteurs de lignes')
    disp('                  ')
    disp('ColumnsWidth              = vecteur des largeurs des colonnes')
    disp('---------------- liste des propriete adjacentes non modifiables via cette fction mais recupérables')
    disp('NormalizedVerticalSliderWidth_locked')
    disp('NormalizedHorizontalSliderHeight_locked')
    disp('ButtonHandles_locked')

    return
end

%%%%%%%%%%%%%%%%%%%
% % il y a deux appels possibles :
% % un appel pour la cration de spanel et un appel de modification
% % si on est en mode modification, toutes les options qui ne sont pas precisees sont deja definies
% % alors qu en mode creation, les options qui n ont pas ete indiquees doivent recevoir la valeur par defaut
if isstruct(varargin{1})
    %mode='modification';
    p=varargin{1};
    set(p.PanelHandle,'visible','off');
    %si l'utilisateur a modifié le contenu des cases via les handles, il
    %faut que la matrice de StringCell corresponde, dans le doute :
    for iii=1:size(p.ButtonHandles_locked,1)
        for jjj=1:size(p.ButtonHandles_locked,2)
            p.StringCell{iii,jjj}=get(p.ButtonHandles_locked(iii,jjj),'string');
        end
    end
%else
    %mode='creation';
end
%%%%%%%%%%%%%%%%%%%


%definition de la liste des proprietes disponibles
%pprop={'Parent','Title','NormalizedPosition','BackgroundColor','NormalizedVerticalSliderWidth_locked','VerticalSliderValue','VerticalSliderStep','NormalizedHorizontalSliderHeight_locked','HorizontalSliderValue','HorizontalSliderStep','LinesHeight','ColumnsWidth','StringCell'};
pprop={'Parent','Title','NormalizedPosition','BackgroundColor','VerticalSliderWidthPixel','VerticalSliderValue','VerticalSliderStep','HorizontalSliderHeightPixel','HorizontalSliderValue','HorizontalSliderStep','LinesHeight','ColumnsWidth','StringCell'};
%definition des proprietes par defaut (dans le meme ordre que pprop !!!)
itmp=[];jtmp=[];fensize=[];
LinesHeightstat='nondefault';ColumnsWidthstat='nondefault';StringCellstat='nondefault';
defaultprop={'p.Parent=figure();',...
             'p.Title='''';',...
              [],...
             'p.BackgroundColor=[.5,.5,.5];',...             'p.NormalizedVerticalSliderWidth_locked=0.03;',...
             'p.VerticalSliderWidthPixel=10;',...
             'p.VerticalSliderValue=1;',...
             'p.VerticalSliderStep=[.01,.1];'...            ['fensize=get(p.Parent,''position'');',...                  'p.NormalizedHorizontalSliderHeight_locked=p.NormalizedVerticalSliderWidth_locked*p.NormalizedPosition(3)*fensize(3)/p.NormalizedPosition(4)/fensize(4);'],...
             'p.HorizontalSliderHeightPixel=10;',...
             'p.HorizontalSliderValue=0;',...
             'p.HorizontalSliderStep=[.1,.4];',...
             'p.LinesHeight=.17*ones(1,20);LinesHeightstat=''default'';',...
             'p.ColumnsWidth=.1*ones(1,20);ColumnsWidthstat=''default'';',...
            ['p.StringCell=cell(length(p.LinesHeight),length(p.ColumnsWidth));',...
                  'for itmp=1:length(p.LinesHeight);',...
                      'for jtmp=1:length(p.ColumnsWidth);',...
                          'p.StringCell{itmp,jtmp}=[num2str(itmp),''-'',num2str(jtmp)];',...
                      'end;',...
                  'end;StringCellstat=''default'';']};

%attribution des prop renseignees par l utilisateur
for iii=1:length(pprop)
    for jjj=1:length(varargin)
        if strcmp(pprop{iii},varargin{jjj})
            p.(varargin{jjj})=varargin{jjj+1};
        end
    end
end
%on parcours les fields de p, si ils sont inexistants c est qu on est en mode creation ou qu il y a un pb et on attribut la valeur par defaut
%si la propriete par defaut est vide c est que la prop est obligatoirement a definir par l utilisateur=> c est une erreur
for iii=1:length(pprop)
    if ~isfield(p,pprop{iii})
        if isempty(defaultprop{iii})
            error([pprop{iii},' must be defined']);
        end
        eval(defaultprop{iii});
    end
end
%cas de merde, StringCell est fourni mais LinesHeight et ColumnsWidth sont par defaut
if strcmp(LinesHeightstat,'default') && strcmp(StringCellstat,'nondefault')
    p.LinesHeight=p.LinesHeight(1)*ones(1,size(p.StringCell,1));
end
if strcmp(ColumnsWidthstat,'default') && strcmp(StringCellstat,'nondefault')
    p.ColumnsWidth=p.ColumnsWidth(1)*ones(1,size(p.StringCell,2));
end

%%%%%%%%%%%%
p.PanelHandle=uipanel('Parent',p.Parent,...
           'Title',p.Title,...
           'Units','normalized',...
           'BackgroundColor',p.BackgroundColor,...
           'Position',p.NormalizedPosition,...
           'resizeFcn',@reszsliders);
p.VerticalSliderHandle=uicontrol('parent',p.PanelHandle,...
              'units','normalized',...
              'style','slider',...
              'value',p.VerticalSliderValue,...
              'sliderstep',p.VerticalSliderStep,...
              'position',[0,0,.01,.01]);

p.HorizontalSliderHandle=uicontrol('parent',p.PanelHandle,...
              'units','normalized',...
              'style','slider',...
              'value',p.HorizontalSliderValue,...
              'sliderstep',p.HorizontalSliderStep,...
              'position',[0,0,.01,.01]);
    reszsliders;
    function reszsliders(src,evt)
        set(p.PanelHandle,'borderwidth',1)
        set(p.PanelHandle,'units','pixel')
        set(p.VerticalSliderHandle,'units','pixel')
        set(p.HorizontalSliderHandle,'units','pixel')
        PanelHandlepos=get(p.PanelHandle,'position');PanelHandlepos(4)=PanelHandlepos(4)-10;PanelHandlepos(3)=PanelHandlepos(3)-1;%acause du Title
        set(p.HorizontalSliderHandle,'position',[1,1,PanelHandlepos(3)-p.VerticalSliderWidthPixel-2,p.HorizontalSliderHeightPixel])
        set(p.VerticalSliderHandle,'position',[PanelHandlepos(3)-p.VerticalSliderWidthPixel-2,p.HorizontalSliderHeightPixel+1,p.VerticalSliderWidthPixel,PanelHandlepos(4)-p.HorizontalSliderHeightPixel-2])
        p.NormalizedVerticalSliderWidth_locked=p.VerticalSliderWidthPixel/(PanelHandlepos(3)-2);%-1.1*slider_width_cm);
        p.NormalizedHorizontalSliderHeight_locked=p.HorizontalSliderHeightPixel/(PanelHandlepos(4)-2);%-1.1*slider_width_cm);
        set(p.PanelHandle,'units','normalized')
        set(p.VerticalSliderHandle,'units','normalized')
        set(p.HorizontalSliderHandle,'units','normalized')
        clear PanelHandlepos
    end

%p=createpanel(p);
%set(p.VerticalSliderHandle,'callback',{@slidepanel,p});
%set(p.HorizontalSliderHandle,'callback',{@slidepanel,p});
createpanel
set(p.VerticalSliderHandle,'callback',@slidepanel);
set(p.HorizontalSliderHandle,'callback',@slidepanel);


function createpanel%p=createpanel(p)
    reszsliders;
Nl=size(p.StringCell,1);
Nc=size(p.StringCell,2);
p.ButtonHandles_locked=zeros(Nl,Nc);

if size(p.StringCell,1)~=length(p.LinesHeight)
    if length(p.LinesHeight)==1 
        p.LinesHeight=p.LinesHeight*ones(1,size(p.StringCell,1));
    else
        error('LinesHeight must have the same number of elements as the number of lines in StringCell')
    end
end
if size(p.StringCell,2)~=length(p.ColumnsWidth)
    if length(p.ColumnsWidth)==1
        p.ColumnsWidth=p.ColumnsWidth*ones(1,size(p.StringCell,2));
    else
        error('ColumnsWidth must have the same number of elements as the number of columns in StringCell')
    end
end



for i=1:Nl
    for j=1:Nc
        vopt='on';
        xocase=(((1-p.NormalizedVerticalSliderWidth_locked)-sum(p.ColumnsWidth)))*p.HorizontalSliderValue+(sum(p.ColumnsWidth(1:j))-p.ColumnsWidth(j));%abscisse du cote gauche de la case ij
        yocase=(((1-p.LinesHeight(1)))-(sum(p.LinesHeight)-p.LinesHeight(1)+p.NormalizedHorizontalSliderHeight_locked))*p.VerticalSliderValue+(sum(p.LinesHeight)-p.LinesHeight(1)+p.NormalizedHorizontalSliderHeight_locked)-(sum(p.LinesHeight(1:i))-p.LinesHeight(1));%ordonne du cote inf de la case ij


        correction_c=0;
        if xocase>=1-p.NormalizedVerticalSliderWidth_locked || xocase+p.ColumnsWidth(j)<=0;
            vopt='off';
        elseif xocase<0
            correction_c=-xocase;
            xocase=0;
        elseif xocase+p.ColumnsWidth(j)> 1-p.NormalizedVerticalSliderWidth_locked
            correction_c= xocase+p.ColumnsWidth(j) -(1-p.NormalizedVerticalSliderWidth_locked);
        end

        correction_l=0;
        if yocase>=1 || yocase+p.LinesHeight(i)<=p.NormalizedHorizontalSliderHeight_locked 
            vopt='off';
        elseif yocase+p.LinesHeight(i)>1
            correction_l=yocase+p.LinesHeight(i)-1;
        elseif yocase<p.NormalizedHorizontalSliderHeight_locked
            correction_l=p.NormalizedHorizontalSliderHeight_locked-yocase;%+p.LinesHeight(i)-p.NormalizedHorizontalSliderHeight_locked;
            yocase=p.NormalizedHorizontalSliderHeight_locked;
        end

        %on cree la case
        p.ButtonHandles_locked(i,j)=uicontrol('parent',p.PanelHandle,...
                               'units','normalized',...
                               'style','edit',...
                               'position',[xocase,yocase,p.ColumnsWidth(j)-correction_c,p.LinesHeight(i)-correction_l],...
                               'string',p.StringCell{i,j},...
                               'visible',vopt);
    end
end
end

%function slidepanel(src,eventStringCell,p)
function slidepanel(src,eventStringCell)
    reszsliders;
Nl=size(p.StringCell,1);
Nc=size(p.StringCell,2);

%on lit les valeurs des sliders et on reattribue des positions a chaque
%boutton
p.VerticalSliderValue=get(p.VerticalSliderHandle,'value');
p.HorizontalSliderValue=get(p.HorizontalSliderHandle,'value');

if size(p.StringCell,1)~=length(p.LinesHeight)
    if length(p.LinesHeight)==1
        p.LinesHeight=p.LinesHeight*ones(1,size(p.StringCell,1));
    else
        error('LinesHeight must have the same number of elements as the number of lines in StringCell')
    end
end
if size(p.StringCell,2)~=length(p.ColumnsWidth)
    if length(p.ColumnsWidth)==1
        p.ColumnsWidth=p.ColumnsWidth*ones(1,size(p.StringCell,2));
    else
        error('ColumnsWidth must have the same number of elements as the number of columns in StringCell')
    end
end

for i=1:Nl
    for j=1:Nc
        vopt='on';
        xocase=(((1-p.NormalizedVerticalSliderWidth_locked)-sum(p.ColumnsWidth)))*p.HorizontalSliderValue+(sum(p.ColumnsWidth(1:j))-p.ColumnsWidth(j));%abscisse du cote gauche de la case ij
        yocase=(((1-p.LinesHeight(1)))-(sum(p.LinesHeight)-p.LinesHeight(1)+p.NormalizedHorizontalSliderHeight_locked))*p.VerticalSliderValue+(sum(p.LinesHeight)-p.LinesHeight(1)+p.NormalizedHorizontalSliderHeight_locked)-(sum(p.LinesHeight(1:i))-p.LinesHeight(1));%ordonne du cote inf de la case ij

        correction_c=0;
        if xocase>=1-p.NormalizedVerticalSliderWidth_locked || xocase+p.ColumnsWidth(j)<=0;
            vopt='off';
            set(p.ButtonHandles_locked(i,j),'visible',vopt);
            continue
        elseif xocase<0
            correction_c=-xocase;
            xocase=0;
        elseif xocase+p.ColumnsWidth(j)> 1-p.NormalizedVerticalSliderWidth_locked
            correction_c= xocase+p.ColumnsWidth(j) -(1-p.NormalizedVerticalSliderWidth_locked);
        end
        
        correction_l=0;
        if yocase>=1 || yocase+p.LinesHeight(i)<=p.NormalizedHorizontalSliderHeight_locked 
            vopt='off';
            set(p.ButtonHandles_locked(i,j),'visible',vopt);
            continue
        elseif yocase+p.LinesHeight(i)>1
            correction_l=yocase+p.LinesHeight(i)-1;
        elseif yocase<p.NormalizedHorizontalSliderHeight_locked
            correction_l=p.NormalizedHorizontalSliderHeight_locked-yocase;%+p.LinesHeight(i)-p.NormalizedHorizontalSliderHeight_locked;
            yocase=p.NormalizedHorizontalSliderHeight_locked;
        end

        %on ne fait que mettre a jour la posititon et la visibilite de la case
        set(p.ButtonHandles_locked(i,j),'position',[xocase,yocase,p.ColumnsWidth(j)-correction_c,p.LinesHeight(i)-correction_l],'visible',vopt);
    end
end
end

end

