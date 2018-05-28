function erreur=write_in(xmax,model,infiletowrite)

fid=fopen(infiletowrite,'w');
if fid==-1
    erreur=1;
    return
end

fprintf(fid,'%f',xmax);
for i=1:length(model)
    fprintf(fid,'\n\n%d    %4.2f    %s',model(i).n,model(i).rho,model(i).name);
    for j=1:model(i).n
        fprintf(fid,'\n%+.8f    %+.8f',model(i).polyg(j,1),model(i).polyg(j,2));
    end
end
fclose(fid);
erreur=0;
