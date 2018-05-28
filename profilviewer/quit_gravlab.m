if session.saved==1
    %qd on clic sur la ptte croix ca appel la fonction quit. Or la fonction
    %quit se charge de cliquer sur la petite croix => si on ne desactive
    %pas le fonction de deletion, on risque un appel recursif de
    %quit_gravlab.m
    try
        quit_curveviewer;
        %si la fermeture du curveviewer a echoué (sauvegarde)
        if ~isempty(windows.curvefig.handle)
            return
        end
    end
    set(windows.homefig.handle,'closerequestfcn','default');
    close(windows.homefig.handle)
elseif session.saved==0
    if strcmp(questdlg('quit without saving?'),'Yes')
        try
            quit_curveviewer;
            %si la fermeture du curveviewer a echoué (sauvegarde)
            if ~isempty(windows.curvefig.handle)
                return
            end
        end
        set(windows.homefig.handle,'closerequestfcn','default');
        close(windows.homefig.handle,'force')
    end
end

