%This program will install gravamanager 1.2
%  -> generates program getHOME.m that is used by other functions
%  -> set and save MATLAB path
clear all
close all

if strcmp(computer,'PCWIN')
	SEP='\';
else
	SEP='/';
end

HOME = pwd;
%% getHOME
fid = fopen([HOME,SEP,'getHOME.m'],'w');
if fid == -1 
	error('cannot generate getHOME.m')
end
fprintf(fid,'session.VERSION=''1.2'';\nsession.HOME=''%s'';',HOME);
fclose(fid);

%% MATLAB PATH
fprintf('%s\n',HOME);
fprintf('%s\n',[HOME,SEP,'profilviewer']);
fprintf('%s\n',[HOME,SEP,'curveviewer']);
fprintf('%s\n',[HOME,SEP,'curveviewer',SEP,'curvescallbacks']);
fprintf('%s\n',[HOME,SEP,'mapviewer']);
fprintf('%s\n',[HOME,SEP,'volumeviewer']);
fprintf('%s\n',[HOME,SEP,'gravitom_2.1']);
fprintf('%s\n',[HOME,SEP,'help']);
addpath(HOME)
addpath([HOME,SEP,'profilviewer'])
addpath([HOME,SEP,'curveviewer'])
addpath([HOME,SEP,'curveviewer',SEP,'curvescallbacks'])
addpath([HOME,SEP,'mapviewer'])
addpath([HOME,SEP,'gravitom_2.1'])
addpath([HOME,SEP,'help'])
savepath


%%% lock this mfile
%movefile([HOME,SEP,'install.m'],[HOME,SEP,'install.m.done'])



fprintf('GRAVLAB 1.2 sucessfully installed in directory \n\t%s\n',HOME)
%% clean up
clear fid HOME SEP
