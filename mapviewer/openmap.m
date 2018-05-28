%openmap

%%
[file, path] = uigetfile('*.xyz', 'Chose a map to open');
session.xyzfile.file = [path, file];

[X,Y,Z] = rxyz2_0(session.xyzfile.file);

session.xyzfile.data.X = X;
session.xyzfile.data.Y = Y;
session.xyzfile.data.Z = Z;

refreshmap;
%% clean workspace
clear file path X Y Z
