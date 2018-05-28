%new_in

%% a faire
%si on a un profil en cours et que l'utilisateur demande un nouveau profil,
%on doit rafraichir ce qu il y a a rafraichir et prevoir une sauvegarde !!!





%% get profil dimensions
set(windows.homefig.dlgbox,...
    'ForegroundColor',[.7 0 0],...
    'string','warning : z-axis oriented upward')
profil.units='km';
answer=inputdlg({['xmax (',profil.units,')'],...
                 ['zmin (',profil.units,')'],...
                 ['zmax (',profil.units,')']},...
                 'profil dimensions',1,...
                 {'100','-50','0'});

%cancel action : 
if isempty(answer)
    clear answer
    return
end

profil.xmax=str2num(answer{1});
profil.zmin=str2num(answer{2});
profil.zmax=str2num(answer{3});



%% cette fois on est sur
session.infile='new model';
session.saved=0;
set(windows.homefig.handle,'name',[session.infile,'*'])



%% initialisation des variables associees au nouveau modele
%profil.model est un vecteur de structures
profil.model=[];



%% draw the new profile
profil=refresh_profil(windows,profil,{'xmax','zmin','zmax'});


%% activate the menu buttons
% certain menus doivent etre disponibles maintenant qu on a un profil en memoire
set(windows.homefig.menu.Tools.parent,'enable','on')
set(windows.homefig.menu.Objects.parent,'enable','on')
set(windows.homefig.menu.Edit.parent,'enable','on')
set(windows.homefig.menu.File.open,'enable','off');
set(windows.homefig.menu.File.new,'enable','off');

%% clean the workspace
clear pathname answer