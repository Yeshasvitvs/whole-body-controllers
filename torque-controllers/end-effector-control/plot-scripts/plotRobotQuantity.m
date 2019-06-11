function plotRobotQuantity(robotQuantity, trimTime, subplotOption, usePlotColoring,...
                           yPlotColors, legendOptions, legendFontSize, legendColumns,...
                           fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                           axisOption, axesFontSize, axesLineWidth,...
                           gridOption, minorGridOption, lineWidth, plotTitle,...
                           xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder)

                       fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(robotQuantity,2)
    
    if (subplotOption)
        sH = subplot(size(robotQuantity,2),1,d); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
    end
    
    if (usePlotColoring)
        plot(trimTime,robotQuantity{d}, 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    else
        plot(trimTime,robotQuantity{d}, 'LineWidth',lineWidth);
    end
    
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel(yLabelOptions, 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel(xLabelOptions, 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    if (subplotOption)
        lgd = legend(legendOptions,'Interpreter', 'latex',...
                 'Location','best','Box','off','FontSize',legendFontSize);
        lgd.NumColumns = legendColumns;
    end
    
end

currentFigure = gcf;
title(currentFigure.Children(end), plotTitle,...
      'Interpreter', 'latex','FontSize', titleFontSize);

if (~subplotOption)
    lgd = legend(legendOptions,'Interpreter', 'latex',...
                 'Location','best','Box','off','FontSize',legendFontSize);
    lgd.NumColumns = legendColumns;
end
             
% % save2pdf(fullfile(fullPlotFolder, 'ee-joint-efforts.pdf'),fH,300);
                      
end