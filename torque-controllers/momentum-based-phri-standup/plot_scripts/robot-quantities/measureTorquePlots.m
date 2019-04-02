function measureTorquePlots(time, timeIndexes, tauMes,...
                            range, lineWidth, verticleLineWidth,...
                            fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                            xLabelFontSize, yLabelFontSize, markerSize, statesMarker, colors, fullPlotFolder)
                        
    %% Measured Torques with subplots

    yLimits = [];
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    robot_part_label_dict = ["Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"];
    robot_part_joints = [3, 4, 4, 6, 6];
    joint_number = 1;
    for i=1:5
        sH = subplot(5,1,i); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        p = plot(time(1:range),tauMes(1:range,joint_number: sum(robot_part_joints(1:i))),'-','LineWidth',lineWidth);
        joint_number = joint_number + robot_part_joints(i);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(i,:) = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(i,1)-0.01,yLimits(i,2)+0.01,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
            s(j).Color = colors(j+3,:);
            uistack(p(1));
        end
        ylabel(robot_part_label_dict(i), 'FontSize', yLabelFontSize);
    end

% %     lgd = legend([s(1) s(2) s(3)],...
% %                 {'','','','','','','State 2','State 3', 'State 4'},...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% %     lgd.NumColumns = 3;
   
    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     title('Measured Joint Torques', 'FontSize', fontSize);

    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'tauMes.pdf'),fH,300);
end