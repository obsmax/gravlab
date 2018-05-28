function  cs = curvesheet_skeleton(numXzfile)


Xzfile = num2str(numXzfile);
h1 = 1/5.1;h2 = 1/8;
l = 0.15;
H = 1;
%L = 1;
editcolor = [.95, .95, .95];
propcolor = [.9,.9,.9];
gravitomcolor = [.9, .9, 1];


%% UIBUTTONGROUPS
cs.uibuttongrp.units               = {'normalized',                'normalized'};
cs.uibuttongrp.position            = {[0,.60, 1,.40] ,               [0,0,1,.60]};
cs.uibuttongrp.title               = {'curve properties',          'gravitom options'};
cs.uibuttongrp.tag               = {'curvesbuttongroup',         'gravitombuttongroup'};
cs.uibuttongrp.backgroundcolor     = {propcolor,                    gravitomcolor};
cs.uibuttongrp.lowerleftalignment  = {'upperleft',                 'upperleft'};
cs.uibuttongrp.upperrightalignment = {'upperleft',                 'upperleft'};
cs.uibuttongrp.lowerleftxposition  = {'fixed',                     'fixed'};
cs.uibuttongrp.lowerleftyposition  = {'fixed',                     'fixed'};
cs.uibuttongrp.upperrightxposition = {'normalized',                'normalized'};
cs.uibuttongrp.upperrightyposition = {'fixed',                     'fixed'};

%% UICONTROLS
cs.uictrl.parent    = {...
    'uibuttongrp.handle{1}',   'uibuttongrp.handle{1}',      'uibuttongrp.handle{1}',          'uibuttongrp.handle{1}';
    'uibuttongrp.handle{1}',   'uibuttongrp.handle{1}',      'uibuttongrp.handle{1}',          'uibuttongrp.handle{1}';
    'uibuttongrp.handle{1}',   'uibuttongrp.handle{1}',      'uibuttongrp.handle{1}',          'uibuttongrp.handle{1}';
    'uibuttongrp.handle{1}',   'uibuttongrp.handle{1}',      'uibuttongrp.handle{1}',          'uibuttongrp.handle{1}';
    'uibuttongrp.handle{1}',   'uibuttongrp.handle{1}',      'uibuttongrp.handle{1}',          'uibuttongrp.handle{1}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}';
    'uibuttongrp.handle{2}',   'uibuttongrp.handle{2}',      'uibuttongrp.handle{2}',          'uibuttongrp.handle{2}'};
%-------------------------------------------------------------
cs.uictrl.string     = {'visible',              '',                          '',                 '';
                       'label',                rp('label'),                 '',                 '';
                       'mode',                 'file|gravitom',             '',                 '';
                       'color',                rp('color','string'),        '',                 '';
                       'browse',               rp('file'),                  '',                 '';
                       'gravitom',             '',                          '',                 'help';
                       'autorefresh',          '',                          '',                 '';
                       'npts',                 rp('gravitom_options.npts','string'),            '',                 '';%rp('gravitom.npts');
                       'xmes',                 'file|linspace',             'browse',           '';
                       'zmes',                 'file|constant',             'browse',           '';
                       'irecal',               '',                          'to',               getlabels();
                       'boundaries',           '',                          'distance',         rp('gravitom_options.prolh.distance','string')};
%-------------------------------------------------------------
cs.uictrl.tag       = {'txtvisibility',        'visibility',                '',                 '';
                       'txtlabel',             'label',                     '',                 '';
                       'txtmode',              'mode',                      '',                 '';
                       'txtcolor',             'color',                     '',                 '';
                       'browse',               'file',                      '',                 '';
                       'gravitom',             '',                          '',                 'gravitompanelhelp';
                       'txtautorefresh',       'autorefresh',               '',                 '';
                       'txtnpts',              'npts',                      '',                 '';%rp('gravitom.npts');
                       'txtxmes',              'xmesmode',                  'xmesbrowse',       'xmesfile';
                       'txtzmes',              'zmesmode',                  'zmesbrowse'        'zmesfile';
                       'txtirecal',            'irecal',                    'txtto',            'irecalXzfilenumber';
                       'txtprolh',             'prolh',                     'txtdistance',      'distance'};
%-------------------------------------------------------------
cs.uictrl.HorizontalAlignment = {...
                       'default',              'default'                   'default',          'default';
                       'default',              'left'                      'default',          'default';
                       'default',              'default'                   'default',          'default';
                       'default',              'default'                   'default',          'default';
                       'default',              'left'                      'default',          'default';
                       'default',              'default'                   'default',          'default';
                       'default',              'default'                   'default',          'default';
                       'default',              'left'                      'default',          'default';
                       'default',              'default'                   'default',          'left';
                       'default',              'default'                   'default',          'left';
                       'default',              'default'                   'default',          'default';
                       'default',              'default'                   'default',          'left'};
%-------------------------------------------------------------
cs.uictrl.style            = {...
                       'text',                 'checkbox',                 'default',          'default';
                       'text',                 'edit',                     'default',          'default';
                       'text',                 'popupmenu',                'default',          'default';
                       'text',                 'edit',                     'default',          'default';
                       'pushbutton',           'edit',                     'default',          'default';
                       'pushbutton',           'default',                  'default',          'pushbutton';
                       'text',                 'checkbox',                 'default',          'default';
                       'text',                 'edit',                     'default',          'default';
                       'text',                 'popupmenu',                'pushbutton',       'edit';
                       'text',                 'popupmenu',                'pushbutton',       'edit';
                       'text',                 'checkbox',                 'text',             'popupmenu';
                       'text',                 'checkbox',                 'text',             'edit'};
%-------------------------------------------------------------
%unites normalisees pour pouvoir positionner les bouttons.
cs.uictrl.units            = {...
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized';
                       'normalized',           'normalized',               'normalized',          'normalized'};
%-------------------------------------------------------------
cs.uictrl.visible          = {...    
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'off',                      'off',              'on';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'off',              'off';
                       'on',                   'on',                       'on',              'on';
                       'on',                   'on',                       'on',              'on';
                       'on',                   'on',                       'on',              'on';
                       'on',                   'on',                       'on',              'on'};
%-------------------------------------------------------------
cs.uictrl.enable           = {...
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'off',                  'off',                      'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on';
                       'on',                   'on',                       'on',               'on'};
%-------------------------------------------------------------
cs.uictrl.Foregroundcolor  = {...
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              1-rp('color'),              'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default'};
%-------------------------------------------------------------
cs.uictrl.Backgroundcolor  = {...
                       propcolor,              propcolor,                  propcolor,          propcolor;
                       propcolor,              editcolor,                  'default',          propcolor;
                       propcolor,              editcolor,                  'default',          'default';
                       propcolor,              rp('color'),                'default',          'default';
                       'default',              editcolor,                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       gravitomcolor,          gravitomcolor,              gravitomcolor,      gravitomcolor;
                       gravitomcolor,          editcolor,                  gravitomcolor,      gravitomcolor;
                       gravitomcolor,          editcolor,                  'default',          editcolor;
                       gravitomcolor,          editcolor,                  'default',          editcolor;
                       gravitomcolor,          gravitomcolor,              gravitomcolor,      editcolor;
                       gravitomcolor,          gravitomcolor,              gravitomcolor,      editcolor};
%-------------------------------------------------------------
cs.uictrl.value            = {...
                       'default',              rp('visibility','value'),   'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              rp('mode','value'),         'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              rp('autorefresh','value'),  'default',          'default';
                       'default',              'default',                  'default',          'default';
                       'default',              rp('xmesmode', 'value'),    'default',          'default';
                       'default',              rp('zmesmode', 'value'),    'default',          'default';
                       'default',              rp('irecal', 'value'),      'default',          rp('Xzfilenumber', 'value');
                       'default',              rp('prolh', 'value'),       'default',          'default'};
%-------------------------------------------------------------
cs.uictrl.position         = {...
    [0, H-1*h1, l, .75*h1],       [l, H-1*h1, l, h1],        [],                              [];
    [0, H-2*h1, l, .75*h1],       [l, H-2*h1, l, h1],        [],                              [];
    [0, H-3*h1, l,.75* h1],       [l, H-3*h1, l, h1],        [],                              [];
    [0, H-4*h1, l, .75*h1],       [l, H-4*h1, l, h1],        [],                              [];
    [0, H-5*h1, l, h1],           [l, H-5*h1, .999-l, h1],   [],                              [];
    [0, H-1*h2, l, h2],           [l, H-1*h2, l, h2],        [],                              [1-1*l, H-1*h2, l, h2];
    [0, H-2*h2, l, .75*h2],       [l, H-2*h2, l, h2],        [],                              [];
    [0, H-3*h2, l, .75*h2],       [l, H-3*h2, l, h2],        [],                              [];
    [0, H-4*h2, l, .75*h2],       [l, H-4*h2, l, h2],        [2*l,   H-4*h2, l, h2],          [9*l/3, H-4*h2, 1-9*l/3, h2];
    [0, H-5*h2, l, .75*h2],       [l, H-5*h2, l, h2],        [2*l,   H-5*h2, l, h2],          [9*l/3, H-5*h2, 1-9*l/3, h2];
    [0, H-6*h2, l, .75*h2],       [l, H-6*h2, l/3, .8*h2],   [4*l/3, H-6*h2, l, .75*h2],      [7*l/3, H-6*h2, l, h2];
    [0, H-7*h2, l, .75*h2],       [l, H-7*h2, l/3, .8*h2],   [4*l/3, H-7*h2, l, .75*h2],      [7*l/3, H-7*h2, l, h2]};
%-------------------------------------------------------------
cs.uictrl.lowerleftalignment = {...
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperright';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft'};
%-------------------------------------------------------------
cs.uictrl.lowerleftxposition =  {...
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed'};
%-------------------------------------------------------------
cs.uictrl.lowerleftyposition =  {...
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed'};
%-------------------------------------------------------------
cs.uictrl.upperrightalignment = {...
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperright';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft';
                       'upperleft',                   'upperleft',        'upperleft',                   'upperleft'};
%------------------------------------------------------------- 
cs.uictrl.upperrightxposition =  {...
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'normalized',        'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'normalized';
                       'fixed',                   'fixed',             'fixed',                   'normalized';
                       'fixed',                   'fixed',             'fixed',                   'fixed';
                       'fixed',                   'fixed',             'fixed',                   'fixed'};
%-------------------------------------------------------------
cs.uictrl.upperrightyposition  =  {...
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed';
                       'fixed',                   'fixed',                 'fixed',                   'fixed'};
%-------------------------------------------------------------
cs.uictrl.callback = {...
    '',                        'curvevisibility(gccurve())',  '',  '';
    '',                        'curvelabel(gccurve())',       '',  '';
    '',                        'curvemode(gccurve())',        '',  '';
    '',                        'curvecolor(gccurve())',       '',  '';
    'browsecurve(gccurve())',  '',                            '',  '';
    'callgravitom(gccurve())', '',                            '',  'gravitompanelhelp()';
    '',                        '',                            '',  '';
    '',                        'chnpts(gccurve())',           '',  '';
    '',                        'xmesmode(gccurve())',         '',  '';
    '',                        'zmesmode(gccurve())',         '',  'zmesfile(gccurve())';
    '',                        'irecal(gccurve())',           '',  'irecalXzfilenumber(gccurve())';
    '',                        'bounds(gccurve())',           '',  'prolhdist(gccurve())'};
%-------------------------------------------------------------


    function rep = rp(prop, out)%read property to fill the sheet
        if nargin < 2
            out = 'whatever';
        end
        if strcmpi(out, 'value')
            if strcmpi(prop,'visibility')%we return value not string
                rep = strcmpi(evalin('base', ['session.Xzfiles(',Xzfile,').visibility;']),'on');
            elseif strcmpi(prop,'mode')
                rep = find(strcmpi({'file','gravitom'},evalin('base', ['session.Xzfiles(',Xzfile,').mode;'])));
            elseif strcmpi(prop,'autorefresh')
                rep = evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.autorefresh']);
            elseif strcmpi(prop,'xmesmode')
                rep = find(strcmpi({'file','linspace'},evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.xmesmode;'])));
            elseif strcmpi(prop,'zmesmode')
                rep = find(strcmpi({'file','constant'},evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.zmesmode;'])));
            elseif strcmpi(prop,'irecal')
                rep = evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.irecal.activated']);
            elseif strcmpi(prop,'Xzfilenumber')
                rep = evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.irecal.Xzfilenumber']);
            elseif strcmpi(prop,'prolh')
                rep = evalin('base', ['session.Xzfiles(',Xzfile,').gravitom_options.prolh.activated']);
            else
                error('')
            end
        elseif strcmp(out,'string')
            if strcmp(prop,'color')
                rep = ['[',sprintf(' %.1f ',evalin('base', ['session.Xzfiles(',Xzfile,').',prop,';'])),']'];
            else
                rep = num2str(evalin('base', ['session.Xzfiles(',Xzfile,').',prop,';']));
            end
        else
            rep = evalin('base', ['session.Xzfiles(',Xzfile,').',prop,';']);
        end
    end
end