function legsPowerPlots(time, timeIndexes, tauMes, tauMes_left_leg, tauMes_right_leg,...
                          range, lineWidth, verticleLineWidth,...
                          fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                          xLabelFontSize, yLabelFontSize, titleFontSize, markerSize,...
                          statesMarker, colors, state_colors,...
                          gridOption, minorGridOption, axisOption, fullPlotFolder)
                      
    %% Legs Torque Norm
    legs_torque_norm = zeros(1, size(tauMes_left_leg,1));
    for i = 1:size(legs_torque_norm, 2)
        legs_torque_norm(i) = norm([tauMes_left_leg(i,:), tauMes_right_leg(i,:)]);
    end
    
    %% Legs Power
    legs_power = zeros(1, size(tauMes_left_leg,1));
    for i = 1:size(legs_power, 2)
        legs_power(i) = [tauMes_left_leg(i,:), tauMes_right_leg(i,:)] * [tauMes_left_leg(i,:), tauMes_right_leg(i,:)]';
    end
    
    %% Legs Effort
    all_effort = zeros(1, size(tauMes_left_leg,1));
    for i = 1:size(all_effort, 2)
        all_effort(i) = sqrt(tauMes(i,:) * tauMes(i,:)');
    end
    
    power_stats = [legs_torque_norm' legs_power' all_effort'];
    
    title_dict = ["Legs Torque Norm", "Legs Power", "Joints Effort"];
    ylabel_dict = ["Torque $[Nm]$", "Power $[Nm]^2$", "Effort $[Nm]^2$"];
    
    for j = 1:3
        sH = subplot(3,1,j); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        p = plot(time(1:range),power_stats(1:range, j),'-','LineWidth',lineWidth); hold on;
        xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
        ylabel(ylabel_dict(j), 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
        title(title_dict(j), 'FontSize', titleFontSize);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
            s(j).Color = state_colors(j,:);
            uistack(p(1));
        end
        
        ax = gca;
        axis(ax,axisOption);
        ax.XGrid = gridOption;
        ax.YGrid = gridOption;
        ax.XMinorGrid = minorGridOption;
        ax.YMinorGrid = minorGridOption;
    end

end