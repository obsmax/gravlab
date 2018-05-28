function  str=getlabels()
%renvoie les labels des différentes courbes dans une chaine de caractere
%separés par des |

str=[];
Xzfiles=evalin('base','session.Xzfiles;');
for i=1:length(Xzfiles)
    str=[str,Xzfiles(i).label,'|'];
end
str(length(str))=[];

end