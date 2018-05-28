%save_in.m

%% get a file name
[Filename,Pathname]=uiputfile('*.in');
if Filename==0 & Pathname==0
    clear Filename Pathname
    return
end
session.infile=[Pathname,Filename];
set(windows.homefig.handle,'name',session.infile);
session.saved=1;


%% write the file here
erreur=write_in(profil.xmax,profil.model,session.infile);
%uiputfile se charge de verifier si le fichier existe deja et de demander une confirmation pour ecraser
if erreur==1
    Herr=errordlg(['cannot write',session.infile]);
         Herrchildrens=get(Herr,'Children');
         set(Herrchildrens(3),'Callback','uiresume(Herr);close(Herr);clear Herr Herrchildrens;');
         uiwait(Herr);
    set(windows.homefig.dlgbox,...
        'string','writing has failed',...
        'Foregroundcolor','red')
else
    set(windows.homefig.dlgbox,...
        'string','file written successfully',...
        'Foregroundcolor',[0 .7 0])
end


%% clean the workspace
clear Filename Pathname erreur