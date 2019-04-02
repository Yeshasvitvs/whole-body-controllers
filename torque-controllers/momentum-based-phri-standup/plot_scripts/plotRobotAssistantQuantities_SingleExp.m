function plotRobotAssistantQuantities_SingleExp()
    
    %% Robot Assistant Joint Torques

    assistantTau_torso       = andyStandupData.assistant_jointTorquesData.signals(1).values;
    assitantTau_left_arm     = andyStandupData.assistant_jointTorquesData.signals(2).values;
    assistantTau_right_arm   = andyStandupData.assistant_jointTorquesData.signals(3).values;
    assistantTau_left_leg    = andyStandupData.assistant_jointTorquesData.signals(4).values;
    assistantTau_right_leg   = andyStandupData.assistant_jointTorquesData.signals(5).values;
                    %torso pitch              Shoulder pitch               Elbow
    assistantTau = [assistantTau_torso(:,1)   assistantTau_left_arm(:,1)   assistantTau_left_arm(:,4)];

    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    for i=1:3
        sH(i,:) = subplot(3,1,i); hold on;
        sH(i,:).FontSize = fontSize;
        sH(i,:).Units = 'normalized';
        p(i) = plot(time(1:range),assistantTau(1:range,i),'-','LineWidth',lineWidth);
        p(i).Color = colors(i,:);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(i,:) = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(i,1)-1,yLimits(i,2)+1,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
            s(j).Color = colors(j+3,:);
            uistack(p(i));
        end
        ylabel('$\tau$ $[\mathrm{Nm}]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    end

    legend(sH(1,:),p(1),{'Torso pitch'},'Location','best','Box','off','FontSize',legendFontSize);
    legend(sH(2,:),p(2),{'Shoulder pitch'},'Location','best','Box','off','FontSize',legendFontSize);
    legend(sH(3,:),p(3),{'Elbow'},'Location','best','Box','off','FontSize',legendFontSize);

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);

% % annotation('textbox', [0 0.88 1 0.1],...
% %                'FontSize', fontSize,...
% %                'String', 'Helping Agent Joint Torques',...
% %                'EdgeColor', 'none',...
% %                'HorizontalAlignment', 'center');

    save2pdf(fullfile(fullPlotFolder, 'robotAssistantTau.pdf'),fH,300);

    %% Robot Assistant Joint Position

    assistantQ_torso       = andyStandupData.assistant_jointData.signals(1).values;
    assistantQ_left_arm    = andyStandupData.assistant_jointData.signals(2).values;
    assistantQ_right_arm   = andyStandupData.assistant_jointData.signals(3).values;
    assistantQ_left_leg    = andyStandupData.assistant_jointData.signals(4).values;
    assistantQ_right_leg   = andyStandupData.assistant_jointData.signals(5).values;
                 %torso pitch             Shoulder pitch             Elbow
    assistantQ = [assistantQ_torso(:,1)   assistantQ_left_arm(:,1)   assistantQ_left_arm(:,4)]*(180/pi);

    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    for i=1:3
        sH(i,:) = subplot(3,1,i); hold on;
        sH(i,:).FontSize = fontSize;
        sH(i,:).Units = 'normalized';
        p(i) = plot(time(1:range),assistantQ(1:range,i),'-','LineWidth',lineWidth);
        p(i).Color = colors(i,:);
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(i,:) = get(gca,'YLim');
        for j=1:3
            xvalues = timeIndexes(j)*ones(10,1);
            yValues = linspace(yLimits(i,1)-2,yLimits(i,2)+5,10)';
            s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
            s(j).Color = colors(j+3,:);
            uistack(p(i));
        end
        if i == 1
            legend(sH(i,:),[p(i) s(1) s(2) s(3)],{'Torso pitch','State 2','State 3','State 4'},'Location','best','Box','off','FontSize',legendFontSize);
        end
        ylabel('$\theta$ $[\mathrm{deg}]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    end

    % legend(sH(1,:),p(1),{'Torso pitch','State 2','State 4','State 4'},'Location','best','Box','off','FontSize',legendFontSize);
    legend(sH(2,:),p(2),{'Shoulder pitch'},'Location','best','Box','off','FontSize',legendFontSize);
    legend(sH(3,:),p(3),{'Elbow'},'Location','best','Box','off','FontSize',legendFontSize);

    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);

% % annotation('textbox', [0 0.88 1 0.1],...
% %                'FontSize', fontSize,...
% %                'String', 'Helping Agent Joint Positions',...
% %                'EdgeColor', 'none',...
% %                'HorizontalAlignment', 'center');

    save2pdf(fullfile(fullPlotFolder, 'robotAssistantQ.pdf'),fH,300);
end