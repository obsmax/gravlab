function curvelabel(ncurve)

panel = evalin('base',['windows.curveopenfig.onglets(',num2str(ncurve),').PanelHandle;']);
button = findobj(panel, 'tag', 'label');
gravitombuttongroup = findobj(panel, 'tag', 'gravitombuttongroup');
newlabel =  get(button,'string');
if isempty(newlabel) ||  sum(isspace(newlabel))>0 || sum(isstrprop(newlabel, 'punct'))>0
    errordlg('empty labels, white spaces or punctuation caracters are not accepted')
    newlabel=['c', num2str(ncurve-1)];
    set(button, 'string', newlabel);
end

evalin('base', ['session.Xzfiles(',num2str(ncurve),').label=''',newlabel, ''';',...
    'windows.curveopenfig.onglets(',num2str(ncurve),').Title = ''',newlabel,''';',...
    'set(windows.curveopenfig.onglets(',num2str(ncurve),').OngletHandle, ''string'', ''',newlabel,''');']);
newlabellist = getlabels();
for i = 1:10
    panel = evalin('base',['windows.curveopenfig.onglets(',num2str(i),').PanelHandle;']);
    set(findobj(panel, 'tag', 'irecalXzfilenumber'),'string',newlabellist);
end

end


    