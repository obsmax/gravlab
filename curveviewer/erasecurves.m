%erasecurves
if strcmpi(questdlg('do you really want to erase all curves and restart curviewer?'),'Yes')
    quit_curveviewer
    inicurves;
    main_curveviewer1_1
end