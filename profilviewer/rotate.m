function [profil,session]=rotate(windows,session,profil,nstr,sens)

if ~strcmp(sens, 'clock') && ~strcmp(sens, 'counterclock')
    error('unkown rotation mode :%s\n',sens)
end


isclock = isclockwise(profil.model(nstr).polyg);
if isclock && strcmp(sens,'clock')
    rotup();
elseif isclock && strcmp(sens,'counterclock')
    rotdown();
elseif ~isclock && strcmp(sens,'clock')
    rotdown();
elseif ~isclock && strcmp(sens,'counterclock')
    rotup();
end

profil = refresh_profil(windows, profil, {'model'});
if  session.saved
    session.saved = 0;
    set(windows.homefig.handle,'name',[get(windows.homefig.handle,'name'),'*'])
end
%reselection
a = get(profil.model(nstr).fill_handle,'ButtonDownFcn');
feval(a{1},[],[],a{2},a{3})


%% intra-func
    function rotdown
        I = [profil.model(nstr).n-1, 1 : profil.model(nstr).n-1];
        profil.model(nstr).polyg = profil.model(nstr).polyg(I,:);
    end
    function rotup
        I = [2 : profil.model(nstr).n, 2];
        profil.model(nstr).polyg = profil.model(nstr).polyg(I,:);
    end
end