function [a, err]=readXz(Xzfile)
%la premiere ligne du fichier contient le nombre d'echantillons
fid = fopen(Xzfile,'r');
if fid == -1 
    errordlg(sprintf('cannot open Xz file %s\n',Xzfile))
    a = NaN; err = true;
    return
end
A = textscan(fid,'%f %f\n','Headerlines',1);
a = [A{1},A{2}];
err = false;
end