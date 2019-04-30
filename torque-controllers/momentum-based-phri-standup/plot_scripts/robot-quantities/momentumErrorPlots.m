function momentumErrorPlots(time, timeIndexes, Htilde, range, lineWidth, verticleLineWidth,...
                                 fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                 xLabelFontSize, yLabelFontSize, titleFontSize, markerSize,...
                                 statesMarker, colors, state_colors,...
                                 gridOption, minorGridOption, axisOption, fullPlotFolder)
                             
    %% Momentum Error Norm
    mom_label_dict1 = ["X $[Kg-m/s]$","Y $[Kg-m/s]$","Z $[Kg-m/s]$"];
    mom_label_dict2 = ["X $[kg-m^2/s]$","Y $[kg-m^2/s]$","Z $[kg-m^2/s]$"];

    index = 1;
    for i=1:3
        for j=1:2
            sH = subplot(3,2,index); hold on;
            sH.FontSize = fontSize;
            sH.Units = 'normalized';
            p = plot(time(1:range),Htilde(1:range,i+3*(j-1)),'-','LineWidth',lineWidth-0.5);
            p.Color = colors(i,:);
            set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
            yLimits(index,:) = get(gca,'YLim');
            for k=1:3
                xvalues = timeIndexes(k)*ones(10,1);
                yValues = linspace(yLimits(index,1),yLimits(index,2),10)';
                s = plot(xvalues,yValues,statesMarker(k),'LineWidth', verticleLineWidth); hold on;
                s.Color = state_colors(k,:);
                uistack(p);
            end
            
            ax = gca;
            axis(ax,axisOption);
            ax.XGrid = gridOption;
            ax.YGrid = gridOption;
            ax.XMinorGrid = minorGridOption;
            ax.YMinorGrid = minorGridOption;
            
            index = index + 1;
            if j ==1 
                ylabel(mom_label_dict1(i),'Interpreter', 'latex', 'FontSize', yLabelFontSize);
            else
                ylabel(mom_label_dict2(i),'Interpreter', 'latex', 'FontSize', yLabelFontSize);
            end
        end
    end

    annotation('textbox', [0.2 0.88 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'Linear Momentum Error',...
               'EdgeColor', 'none',...
               'HorizontalAlignment', 'left');
    annotation('textbox', [0.24 0.88 1 0.1],...
               'FontSize', fontSize,...
               'String', 'Angular Momentum Error',...
               'EdgeColor', 'none',...
               'HorizontalAlignment', 'center');
    annotation('textbox', [0.48 0.025 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'time [s]',...
               'EdgeColor', 'none',...
               'VerticalAlignment', 'bottom');
    
end