try
    if isempty(windows.prtfig.handle)
        windows.prtfig.handle=figure();
    end
catch
	windows.prtfig.handle=figure();
end
set(windows.prtfig.handle, 'deletefcn', 'windows.prtfig.handle=[];')

curvison=false;
try
    if ~isempty(windows.curvefig.handle)
        for i = 1: length(session.Xzfiles)
            if strcmpi(session.Xzfiles(i).visibility,'on')
                curvison=true;break
            end
        end
    end
end
%% PLOT PROFIL
figure(windows.prtfig.handle)
clf()
if curvison
    subplot(212)
end
copyprofil(profil, gca());%no output
if curvison
    subplot(211)
    copycurves(session, gca());%no output
end



%% Cleaning
clear curvison i 