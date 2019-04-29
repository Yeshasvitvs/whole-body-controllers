function alphaProjectionPlots(time, timeIndexes, alpha, range, lineWidth, verticleLineWidth,...
                                   fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                   xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                               
    %% Alpha Projection
    
    p = plot(time(1:range),alpha(1:range),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');

    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(p);
    end

    lgd = legend([p s(1) s(2) s(3)],...
                {'$\alpha$','State 2','State 3', 'State 4'},...
                 'Interpreter','latex','Location','best','Box','off','FontSize',legendFontSize);

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    ylabel('$\alpha$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    title('Alpha projection', 'FontSize', titleFontSize);
    
end