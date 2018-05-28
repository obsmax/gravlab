%change_dimensions.m

%permet de mettre a jour les dimentions du profil, attention, on ne peut
%pas regler xmin...
%refresh_profil se charge de verifier la coherence de la saisie et de
%redemander des valeurs en cas d erreur

%% get new dimensions
answer=inputdlg({['xmax (',profil.units,') (this is saved in the .in file)'],...
                 ['zmin (',profil.units,') (this is not saved in the .in file)'],...
                 ['zmax (',profil.units,') (this is not saved in the .in file)']},...
                 'new profil dimensions',1,...
                 {num2str(profil.xmax),num2str(profil.zmin),num2str(profil.zmax)});
if isempty(answer)
    clear answer;
    return;
end
profil.xmax=str2num(answer{1});
profil.zmin=str2num(answer{2});
profil.zmax=str2num(answer{3});

%% set new dimensions and controls
profil=refresh_profil(windows,profil,{'xmax','zmin','zmax'});

%% cleaning the workspace
clear answer