%--------------------------------------------------------------------------
% impulse2LTI_plotCommon.m
% Common plotting tasks
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
switch flag
    case 'preliminary'
        % pre tasks
        fontlabel = 20; % x,y label font size
        fontlegend = 13; % x,y legend font size
        fonttick = 15; % x,y tick font size
        wcolor = [1 1 1]; % white color
        bcolor = [0 0 0]; % black color
        set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
        set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
        set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

    case 'axis'
        ha = gca; % get current axis handle
        ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
        ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
        ha.XAxis.FontSize = fonttick; % change x tick font size
        ha.YAxis.FontSize = fonttick; % change y tick font size
        ha.XAxis.Label.FontSize = fontlabel; % change x label font size
        ha.YAxis.Label.FontSize = fontlabel; % change y label font size
        ha.Layer = 'top'; % place the axes on top of the data
        ha.LineWidth = 1; % increase axis line width

    case 'legend'
        hl.FontSize = fontlegend; % change legend font size
        hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)

    case 'save'
        if opts.saveflag
            % save a pdf version
            pathpdf = fullfile(opts.path,'pdf');
            if (exist(pathpdf,'dir') == 0)
                mkdir(pathpdf) % create the folder
            end
            filename = fullfile(pathpdf,[opts.name,'-',figname]);
            str = ['export_fig ''',filename,''' -pdf'];
            eval(str)
        end

end