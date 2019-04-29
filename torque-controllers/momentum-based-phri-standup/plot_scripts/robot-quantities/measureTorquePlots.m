function measureTorquePlots(time, timeIndexes, tauMes,...
                            range, lineWidth, verticleLineWidth,...
                            fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                            xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                        
    %% Measured Torques with subplots

    yLimits = [];
    robot_part_label_dict = ["Torso $[Nm]$", "Left Arm $[Nm]$", "Right Arm $[Nm]$", "Left Leg $[Nm]$", "Right Leg $[Nm]$"];
    robot_part_joints = [3, 4, 4, 6, 6];
    robot_torso_joint_names = ["Torso Pitch","Torso Roll","Torso Yaw"];
    robot_arm_joint_names = ["Shoulder Pitch", "Shoulder Roll", "Shoulder Yaw", "Elbow"];
    robot_leg_joint_names = ["Hip Pitch", "Hip Roll", "Hip Yaw", "Knee", "Ankle Pitch", "Ankle Roll"];
    robot_joint_names = [robot_torso_joint_names robot_arm_joint_names robot_arm_joint_names robot_leg_joint_names robot_leg_joint_names];
    joint_number = 1;
    
    for i=1:5
        sH = subplot(5,1,i); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        p = plot(time(1:range),tauMes(1:range,joint_number: sum(robot_part_joints(1:i))),'-','LineWidth',lineWidth);
        joint_names = [robot_joint_names(joint_number: sum(robot_part_joints(1:i)))];
        lgd = legend(p, joint_names,'Location','best','Box','off','FontSize',legendFontSize); hold on;
        xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
        joint_number = joint_number + robot_part_joints(i);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(i,:) = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(i,1)-0.01,yLimits(i,2)+0.01,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
            s(j).Color = state_colors(j,:);
            uistack(p(1));
        end
        lgd.String(end)   = {"State 4"};
        lgd.String(end-1) = {"State 3"};
        lgd.String(end-2) = {"State 2"};
        lgd.NumColumns = size(lgd.String,2);
        ylabel(robot_part_label_dict(i), 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    end

% %     lgd = legend([s(1) s(2) s(3)],...
% %                 {'','','','','','','State 2','State 3', 'State 4'},...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% %     lgd.NumColumns = 3;

    currentFigure = gcf;
    title(currentFigure.Children(end), 'Measured Joint Torques', 'FontSize', titleFontSize);

end