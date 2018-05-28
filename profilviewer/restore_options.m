function restore_options(session)
%permet d'ecrire le fichier d options par default qui sera lu au lancement
%les variables contenues dans le fichier default_options.mat seront loadees
%dans session.options au demarrage
%intéret, si on modifie ce fichier à la fermeture du programme, les options
%préférées de l'utilisateur seront conservées



%delete([session.HOME,session.SEP,'default_options.mat']);



%% options pour le racine.recentrage lors de la saisie d'une structure
racine.recentrage_sommet='on';
racine.recentrage_sommet_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_sommet_distance=5;%distance de racine.recentrage sur sommet en unites du profil (profil.units)

racine.recentrage_segment='on';%racine.recentrage sur les segments des structures voisines
racine.recentrage_segment_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_segment_distance=3;

racine.recentrage_bords='on';%racine.recentrage sur les bords de profils
racine.recentrage_bords_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_bords_distance=3;

racine.recentrage_top='on';%racine.recentrage sur le top du profil
racine.recentrage_top_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_top_distance=3;

racine.recentrage_bottom='on';%racine.recentrage sur le top du profil
racine.recentrage_bottom_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_bottom_distance=3;

%% options pour le racine.recentrage lors du déplacement d'un point
racine.recentrage_deplacement_sommet='on';
racine.recentrage_deplacement_sommet_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_deplacement_sommet_distance=5;%distance de racine.recentrage sur sommet en unites du profil (profil.units)

racine.recentrage_deplacement_segment='on';%racine.recentrage sur les segments des structures voisines
racine.recentrage_deplacement_segment_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_deplacement_segment_distance=3;

racine.recentrage_deplacement_bords='on';%racine.recentrage sur les bords de profils
racine.recentrage_deplacement_bords_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_deplacement_bords_distance=3;

racine.recentrage_deplacement_top='on';%racine.recentrage sur le top du profil
racine.recentrage_deplacement_top_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_deplacement_top_distance=3;

racine.recentrage_deplacement_bottom='on';%racine.recentrage sur le bottom du profil
racine.recentrage_deplacement_bottom_units='pixels';%{'profil','diag_percent','x_percent','z_percent'}
racine.recentrage_deplacement_bottom_distance=3;

%% GRAVITOM
% %a mettre dans les options
% racine.gravitom.nmes = 100;
% racine.gravitom.xmes = linspace(0, profil.xmax, session.options.gravitom.nmes);
% racine.gravitom.zmes = 1.0 * ones(1,session.options.gravitom.nmes);
% racine.gravitom.irecal.activated = 'on';
% racine.gravitom.irecal.Xzfilenumber = 1;
% racine.gravitom.prolh.activated = 'on';
% racine.gravitom.prolh.distance = 500000;

%% fichier des options de démarrage
save([session.HOME,session.SEP,'profilviewer',session.SEP,'default_options.mat'],'racine');

