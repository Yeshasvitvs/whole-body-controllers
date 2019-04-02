function vLyapunovFunctionPlots(time, timeIndexes, vLyap, range, lineWidth, verticleLineWidth,...
                                fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                xLabelFontSize, yLabelFontSize, markerSize, statesMarker, colors, fullPlotFolder)
                            
    %% Lyapunov Function 
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    handle = get(gca, 'Position');
    p = plot(time(1:range),vLyap(1:range),'-','LineWidth',lineWidth); hold on;
    rectangle('Position',[1 -750 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
    rectangle('Position',[16 0 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');

    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = colors(j+3,:);
        uistack(p);
    end

    lgd = legend([p s(1) s(2) s(3)],...
                {'$\mathrm{V}_{lyapunov}$','State 2','State 3', 'State 4'},...
                 'Interpreter','latex','Location','best','Box','off','FontSize',legendFontSize);

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    ylabel('$\mathrm{V}_{lyapunov}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);

    ax = axes('Parent', gcf, 'Position', [handle(1)+0.03 handle(2)+0.55 handle(3)-.67 handle(4)-.67]);
    plot(time(100:200),vLyap(100:200),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');
    xLimits = get(gca,'XLim');
    set(ax, 'Xlim', [xLimits(1)-0.1 xLimits(2)+0.1],'Ylim', [yLimits(1)-0.5 yLimits(2)+0.5]);

    ax = axes('Parent', gcf, 'Position', [handle(1)+0.45 handle(2)+0.55 handle(3)-.67 handle(4)-.67]);
    plot(time(1600:1700),vLyap(1600:1700),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');
    xLimits = get(gca,'XLim');
    set(ax, 'Xlim', [xLimits(1)-0.1 xLimits(2)+0.1],'Ylim', [yLimits(1)-0.5 yLimits(2)+0.5]);
    
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'vLyap.pdf'),fH,300);
end