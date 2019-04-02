function posturalTaskErrorPlots(time, timeIndexes, qError, range, lineWidth, verticleLineWidth,...
                                     fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                     xLabelFontSize, yLabelFontSize, markerSize, statesMarker, colors, fullPlotFolder)
    
    %% Postural Task Error
    qError_norm = vecnorm(qError,2,2).*(pi/180);
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    p = plot(time(1:range),qError_norm(1:range),'-','LineWidth',lineWidth); hold on;
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits = get(gca,'YLim');
    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = colors(j+3,:);
        uistack(p);
    end

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    ylabel('$|q_j - q_j^d|$ $[\mathrm{rad}]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);

    
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'qError.pdf'),fH,300);
end