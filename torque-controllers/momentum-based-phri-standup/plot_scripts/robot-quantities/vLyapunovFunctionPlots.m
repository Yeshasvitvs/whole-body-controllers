function vLyapunovFunctionPlots(time, timeIndexes, vLyap, range, lineWidth, verticleLineWidth,...
                                fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                xLabelFontSize, yLabelFontSize, titleFontSize, markerSize,...
                                statesMarker, colors, state_colors,...
                                gridOption, minorGridOption, axisOption, fullPlotFolder)
                            
    %% Lyapunov Function 
    p = plot(time(1:range),vLyap(1:range),'-','LineWidth',lineWidth); hold on;
    handle = get(gca, 'Position');
    
    %% pHRI
% %     rectangle('Position',[1 -750 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
% %     rectangle('Position',[16 0 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
    
    %% pRRI
    rectangle('Position',[1 vLyap(100)-750 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
    rectangle('Position',[16 vLyap(1600)-750 1 1500], 'EdgeColor','r', 'LineWidth',axesLineWidth);
    
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');

    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(p);
    end
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;

    lgd = legend([p s(1) s(2) s(3)],...
                {'$\mathrm{V}_{lyapunov}$','State 2','State 3', 'State 4'},...
                 'Interpreter','latex','Location','best','Box','off','FontSize',legendFontSize);

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    ylabel('$\mathrm{V}_{lyapunov}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    title('Lyapunov function', 'FontSize', titleFontSize);

% %     ax = axes('Parent', gcf, 'Position', [handle(1)+0.03 handle(2)+0.55 handle(3)-0.67 handle(4)-0.67]); %% pHRI
    ax = axes('Parent', gcf, 'Position', [handle(1)+0.015 handle(2)+0.6 handle(3)-0.67 handle(4)-0.67]); %% pRRI
    plot(time(100:200),vLyap(100:200),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');
    xLimits = get(gca,'XLim');
    set(ax, 'Xlim', [xLimits(1)-0.1 xLimits(2)+0.1],'Ylim', [yLimits(1)-0.5 yLimits(2)+0.5]);

% %     ax = axes('Parent', gcf, 'Position', [handle(1)+0.45 handle(2)+0.55 handle(3)-0.67 handle(4)-0.67]); %% pHRI
    ax = axes('Parent', gcf, 'Position', [handle(1)+0.375 handle(2)+0.35 handle(3)-0.67 handle(4)-0.67]); %% pRRI
    plot(time(1600:1700),vLyap(1600:1700),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');
    xLimits = get(gca,'XLim');
    set(ax, 'Xlim', [xLimits(1)-0.1 xLimits(2)+0.1],'Ylim', [yLimits(1)-0.5 yLimits(2)+0.5]);

end