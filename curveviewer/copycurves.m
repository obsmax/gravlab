function copycurves(session, ax)

axes(ax)
hold on
str = '';
for i = 1:length(session.Xzfiles)
    if strcmpi(session.Xzfiles(i).visibility,'on')
       h(i)=plot(session.Xzfiles(i).data(:,1),...
            session.Xzfiles(i).data(:,2),...
           'color',session.Xzfiles(i).color,...
           'visible',session.Xzfiles(i).visibility); 
       str = [str, '''',session.Xzfiles(i).label,''','];
    end
end
str(length(str))=[];
['legend(',str,')']
eval(['legend(',str,')'])


box on
xlim([0, evalin('base', 'profil.xmax')])
xlabel('x (km)')
ylabel('g (mgal)')
