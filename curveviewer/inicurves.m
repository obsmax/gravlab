%inicurves.m
for i = 1:10
    session.Xzfiles(i).label=['c',num2str(i-1)];
    session.Xzfiles(i).mode='file';
    session.Xzfiles(i).file='';
    session.Xzfiles(i).saved=true;  
    session.Xzfiles(i).visibility='off';
    session.Xzfiles(i).color=defaultcurvcolor(i);
    session.Xzfiles(i).data=[0,0];
    session.Xzfiles(i).handle=[];
    session.Xzfiles(i).gravitom_options = get_default_gravitom_options;
end
clear i