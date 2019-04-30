function comErrorPlots(time, timeIndexes, comMes, comDes, range, lineWidth, verticleLineWidth,...
                            fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                            xLabelFontSize, yLabelFontSize, titleFontSize,...
                            markerSize, statesMarker, colors, state_colors,...
                            gridOption, minorGridOption, axisOption, fullPlotFolder)
    %% CoM Plots with subplots

    yLimits = [];
    CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];

    for i=1:3
        sH = subplot(3,1,i); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        p(i) = plot(time(1:range),comDes(1:range,i),'-','LineWidth',lineWidth);
        p(i).Color = colors(i,:);
        q(i) = plot(time(1:range),comMes(1:range,i),'-.','LineWidth',lineWidth);
        q(i).Color = colors(i,:);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(i,:) = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(i,1)-0.01,yLimits(i,2)+0.01,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
            s(j).Color = state_colors(j,:);
            uistack(p(i));
        end
        ylabel(CoM_label_dict(i), 'FontSize', yLabelFontSize);
        
        ax = gca;
        axis(ax,axisOption);
        ax.XGrid = gridOption;
        ax.YGrid = gridOption;
        ax.XMinorGrid = minorGridOption;
        ax.YMinorGrid = minorGridOption;
    end
    
    lgd = legend([p(1) p(2) p(3) q(1) q(2) q(3) s(1) s(2) s(3)],...
                {'','Desired','','','Measured','','State 2','State 3', 'State 4'},...
                 'Location','best','Box','off','FontSize',legendFontSize);
    lgd.NumColumns = 3;
   
    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    currentFigure = gcf;
    title(currentFigure.Children(end), 'Center of Mass Tracking', 'FontSize', titleFontSize);
    
end