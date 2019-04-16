function torquesNormPlots(time, timeIndexes, tauMes,...
                          range, lineWidth, verticleLineWidth,...
                          fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                          xLabelFontSize, yLabelFontSize, markerSize, statesMarker, colors, fullPlotFolder)
                      
    %% Measured Torque Norm
    tauMes_norm = vecnorm(tauMes,2,2).*(pi/180);
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    p = plot(time(1:range),tauMes_norm(1:range),'-','LineWidth',lineWidth); hold on;
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
    
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'tauNorm.pdf'),fH,300);
end