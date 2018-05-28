function [profil,session]=rm_struct(windows,session,profil,struct)

if ~strcmp(questdlg(sprintf('!!! Do you realy want to permanently remove structure :\n\n%s',profil.model(struct).name)),'Yes')
    return
end
%unselect
set(profil.model(struct).fill_handle,'visible','off')
%remove
profil.model(struct)=[];
%refresh
profil=refresh_profil(windows,profil,{'model'});
%set seesion to unsaved status
if session.saved==1
    session.saved=0;
    set(windows.homefig.handle,'name',[get(windows.homefig.handle,'name'),'*'])
end