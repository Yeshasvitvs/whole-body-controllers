function plotAssistantQuantities_SingleExp(andyStandupData, assistant, time, timeIndexes,...
                                                range, lineWidth, verticleLineWidth,...
                                                fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                                xLabelFontSize, yLabelFontSize, titleFontSize,...
                                                markerSize, statesMarker, colors,...
                                                gridOption, minorGridOption, axisOption, fullPlotFolder)
                                            
    if (assistant == "Robot")
        
        %% Robot Assistant Joint Torques
        
        fH = figure('units','normalized','outerposition',[0 0 1 1]);

        assistantTau_torso       = andyStandupData.assistant_jointTorquesData.signals(1).values;
        assistantTau_left_arm    = andyStandupData.assistant_jointTorquesData.signals(2).values;
        assistantTau_right_arm   = andyStandupData.assistant_jointTorquesData.signals(3).values;
        assistantTau_left_leg    = andyStandupData.assistant_jointTorquesData.signals(4).values;
        assistantTau_right_leg   = andyStandupData.assistant_jointTorquesData.signals(5).values;
    
% %                         %torso pitch              Shoulder pitch               Elbow
% %         assistantTau = [assistantTau_torso(:,1)   assistantTau_left_arm(:,1)   assistantTau_left_arm(:,4)];
% % 
% %         for i=1:3
% %             sH(i,:) = subplot(3,1,i); hold on;
% %             sH(i,:).FontSize = fontSize;
% %             sH(i,:).Units = 'normalized';
% %             p(i) = plot(time(1:range),assistantTau(1:range,i),'-','LineWidth',lineWidth);
% %             p(i).Color = colors(i,:);
% %             set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
% %             yLimits(i,:) = get(gca,'YLim');
% %             for j=1:3
% %                 xvalues = timeIndexes(j)*ones(10,1);
% %                 yValues = linspace(yLimits(i,1)-1,yLimits(i,2)+1,10)';
% %                 s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
% %                 s(j).Color = colors(j+3,:);
% %                 uistack(p(i));
% %             end
% %             ylabel('$\tau$ $[\mathrm{Nm}]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %         end
% % 
% %         legend(sH(1,:),p(1),{'Torso pitch'},'Location','best','Box','off','FontSize', legendFontSize);
% %         legend(sH(2,:),p(2),{'Shoulder pitch'},'Location','best','Box','off','FontSize', legendFontSize);
% %         legend(sH(3,:),p(3),{'Elbow'},'Location','best','Box','off','FontSize', legendFontSize);

        assistantTau = [assistantTau_torso assistantTau_left_arm assistantTau_right_arm assistantTau_left_leg assistantTau_right_leg];

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
            p = plot(time(1:range),assistantTau(1:range,joint_number: sum(robot_part_joints(1:i))),'-','LineWidth',lineWidth);
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
                s(j).Color = colors(j+3,:);
                uistack(p(1));
            end
            
            ax = gca;
            axis(ax,axisOption);
            ax.XGrid = gridOption;
            ax.YGrid = gridOption;
            ax.XMinorGrid = minorGridOption;
            ax.YMinorGrid = minorGridOption;
        
            lgd.String(end)   = {"State 4"};
            lgd.String(end-1) = {"State 3"};
            lgd.String(end-2) = {"State 2"};
            lgd.NumColumns = size(lgd.String,2);
            ylabel(robot_part_label_dict(i), 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
        end
        
        xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
        currentFigure = gcf;
        title(currentFigure.Children(end), 'Robot Assistant Joint Torques', 'FontSize', titleFontSize);
        
        save2pdf(fullfile(strcat(fullPlotFolder, '/robotAssistantPlots/'), 'assistantTau.pdf'),fH,300);
        
        %% Robot Assistant Joint Position
        
        fH = figure('units','normalized','outerposition',[0 0 1 1]);

        assistantQ_torso       = andyStandupData.assistant_jointData.signals(1).values;
        assistantQ_left_arm    = andyStandupData.assistant_jointData.signals(2).values;
        assistantQ_right_arm   = andyStandupData.assistant_jointData.signals(3).values;
        assistantQ_left_leg    = andyStandupData.assistant_jointData.signals(4).values;
        assistantQ_right_leg   = andyStandupData.assistant_jointData.signals(5).values;
    
% %                       %torso pitch             Shoulder pitch             Elbow
% %         assistantQ = [assistantQ_torso(:,1)   assistantQ_left_arm(:,1)   assistantQ_left_arm(:,4)]*(180/pi);
% % 
% %         
% %         for i=1:3
% %             sH(i,:) = subplot(3,1,i); hold on;
% %             sH(i,:).FontSize = fontSize;
% %             sH(i,:).Units = 'normalized';
% %             p(i) = plot(time(1:range),assistantQ(1:range,i),'-','LineWidth',lineWidth);
% %             p(i).Color = colors(i,:);
% %             set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
% %             yLimits(i,:) = get(gca,'YLim');
% %             for j=1:3
% %                 xvalues = timeIndexes(j)*ones(10,1);
% %                 yValues = linspace(yLimits(i,1)-2,yLimits(i,2)+5,10)';
% %                 s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
% %                 s(j).Color = colors(j+3,:);
% %                 uistack(p(i));
% %             end
% %             if i == 1
% %                 legend(sH(i,:),[p(i) s(1) s(2) s(3)],{'Torso pitch','State 2','State 3','State 4'},'Location','best','Box','off','FontSize',legendFontSize);
% %             end
% %             ylabel('$\theta$ $[\mathrm{deg}]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %         end
% % 
% %         % legend(sH(1,:),p(1),{'Torso pitch','State 2','State 4','State 4'},'Location','best','Box','off','FontSize',legendFontSize);
% %         legend(sH(2,:),p(2),{'Shoulder pitch'},'Location','best','Box','off','FontSize',legendFontSize);
% %         legend(sH(3,:),p(3),{'Elbow'},'Location','best','Box','off','FontSize',legendFontSize);

        assistantQ = [assistantQ_torso assistantQ_left_arm assistantQ_right_arm assistantQ_left_leg assistantQ_right_leg];

        yLimits = [];
        robot_part_label_dict = ["Torso $[\mathrm{deg}]$", "Left Arm $[\mathrm{deg}]$", "Right Arm $[\mathrm{deg}]$", "Left Leg $[\mathrm{deg}]$", "Right Leg $[\mathrm{deg}]$"];
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
            p = plot(time(1:range),assistantQ(1:range,joint_number: sum(robot_part_joints(1:i))),'-','LineWidth',lineWidth);
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
                s(j).Color = colors(j+3,:);
                uistack(p(1));
            end
            
            ax = gca;
            axis(ax,axisOption);
            ax.XGrid = gridOption;
            ax.YGrid = gridOption;
            ax.XMinorGrid = minorGridOption;
            ax.YMinorGrid = minorGridOption;
            
            lgd.String(end)   = {"State 4"};
            lgd.String(end-1) = {"State 3"};
            lgd.String(end-2) = {"State 2"};
            lgd.NumColumns = size(lgd.String,2);
            ylabel(robot_part_label_dict(i), 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
        end
        

        xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
        currentFigure = gcf;
        title(currentFigure.Children(end), 'Robot Assistant Joint Positions', 'FontSize', titleFontSize);
        
        save2pdf(fullfile(strcat(fullPlotFolder, '/robotAssistantPlots/'), 'assistantQ.pdf'),fH,300);

        
    else if(assistant == "Human")
            %% TODO: Human Assistant Plots
    end                                        
    
end