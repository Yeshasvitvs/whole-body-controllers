clc;
clear;
close all;

plotFolder = '../plots';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

%% configuration parameters
lineWidth = 2.5;
fontSize = 24;

normalStandup = analyzeDataSet('../data/exp_19-51.mat');
humanTorqueStandup = analyzeDataSet('../data/exp_20-0.mat');

%% Lyapunov function
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
plot(ax,normalStandup.v_lyap,'-','LineWidth',lineWidth);
plot(ax,humanTorqueStandup.v_lyap,'--','LineWidth',lineWidth);
title('Lyapunov function value');
xlabel('time[s]');
ylabel('V [scalar]');
legend('Normal Standup','Using \tau^{H}');
legend('boxoff');

%% CoM Plots
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];
for i=1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = 24;
    sH.Units = 'normalized';
    plot(sH,normalStandup.comMes(i,:),'-','LineWidth',lineWidth);
    plot(sH,humanTorqueStandup.comMes(i,:),'--','LineWidth',lineWidth);
    xlabel('time[s]');
    ylabel(CoM_label_dict(i));
    legend('Normal Standup','Using \tau^{H}');
    legend('boxoff');
end
annotation('textbox', [0 0.9 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'CoM Measured', ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');
           
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];
for i=1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = 24;
    sH.Units = 'normalized';
    plot(sH,normalStandup.comError(:,i),'-','LineWidth',lineWidth);
    plot(sH,humanTorqueStandup.comError(:,i),'--','LineWidth',lineWidth);
    xlabel('time[s]');
    ylabel(CoM_label_dict(i));
    legend('Normal Standup','Using \tau^{H}');
    legend('boxoff');
end
annotation('textbox', [0 0.9 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'CoM Error', ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');

%% Robot Torques
title_dict = ["hip pitch","hip roll","hip yaw","knee","ankle pitch","ankle roll"];
for leg=1:1:2
    if leg == 1
        normal_leg_data = normalStandup.tauMes_left_leg;
        humanTau_leg_data = humanTorqueStandup.tauMes_left_leg;
        main_title = "Left Leg Robot Torques";
    else
        normal_leg_data = normalStandup.tauMes_right_leg;
        humanTau_leg_data = humanTorqueStandup.tauMes_right_leg;
        main_title = "Right Leg Robot Torques";
    end
    fH = figure;
    ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
    for i = 1:1:6
        sH = subplot(3,2,i); hold on;
        sH.FontSize = 24;
        sH.Units = 'normalized';
        plot(sH,normal_leg_data(:,i),'-','LineWidth',lineWidth);
        plot(sH,humanTau_leg_data(:,i),'--','LineWidth',lineWidth);
        title(title_dict(i));
        xlabel('time[s]');
        ylabel('Nm');
        legend('Normal Standup','Using \tau^{H}');
        legend('boxoff');
    end
    annotation('textbox', [0 0.9 1 0.1], ...
               'FontSize', fontSize,...
               'String', main_title, ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');
end

%% Power plots
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
plot(ax,normalStandup.power_stats(:,1),'-','LineWidth',lineWidth);
plot(ax,humanTorqueStandup.power_stats(:,1),'--','LineWidth',lineWidth);
xlabel('time[s]');
ylabel('');
title('Leg Torques Norm')
legend('Normal Standup','Using \tau^{H}');
legend('boxoff');

fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
plot(ax,normalStandup.power_stats(:,2),'-','LineWidth',lineWidth);
plot(ax,humanTorqueStandup.power_stats(:,2),'--','LineWidth',lineWidth);
xlabel('time[s]');
ylabel('');
title('Leg Power')
legend('Normal Standup','Using \tau^{H}');
legend('boxoff');

fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
plot(ax,normalStandup.power_stats(:,3),'-','LineWidth',lineWidth);
plot(ax,humanTorqueStandup.power_stats(:,3),'--','LineWidth',lineWidth);
xlabel('time[s]');
ylabel('');
title('Robot Effort')
legend('Normal Standup','Using \tau^{H}');
legend('boxoff');

% % power_stats_title = ["Leg Torques Norm","Leg Power","Robot Effort"];
% % for i = 1:1:3
% %     sH = subplot(4,1,i); hold on;
% %     sH.FontSize = 24;
% %     sH.Units = 'normalized';
% %     plot(sH,normalStandup.power_stats(:,i),'-','LineWidth',lineWidth);
% %     plot(sH,humanTorqueStandup.power_stats(:,i),'--','LineWidth',lineWidth);
% %     xlabel('time[s]');
% %     ylabel(power_stats_title(i));
% %     legend('Normal Standup','Using \tau^{H}');
% %     legend('boxoff');
% % end
% % 
% % sH = subplot(4,1,4); hold on;
% % sH.FontSize = 24;
% % sH.Units = 'normalized';
% % plot(sH,normalStandup.standing_states,'-','LineWidth',lineWidth);
% % plot(sH,humanTorqueStandup.standing_states,'--','LineWidth',lineWidth)
% % legend('Normal Standup','Using \tau^{H}');
% % legend('boxoff');
% % title('State');

function allData = analyzeDataSet(dataMat)
    
    data = load(dataMat);
    allData = struct;
    
    allData.time = data.tauMeasuredData.time;
    allData.state = data.comData.signals(4).values(:,1);
    
    state2StartIndex = find(allData.state == 2,1); %%Collect the indexes for the states
    state4StartIndex = find(allData.state == 4,1);
    
    state2StartTime = allData.time(state2StartIndex); %%Collect the time corresponding to the indexes of the states
    state4StartTime = allData.time(state4StartIndex);
    
    endTimeIndex = find(allData.time > state4StartTime + 1.0,1); %%Index of the time step 1.0 seconds beyond state 4
    if isempty(endTimeIndex)
        endTimeIndex = length(time); %%If the time is not beyond 3.5 seconds of the state 4 get the index of the last time step
    end
    
    allData.standing_states = allData.state(state2StartIndex:endTimeIndex);
    
    allData.v_lyap = data.V_lyap.signals(1).values(:,1);
    
    allData.comMes = squeeze(data.comData.signals(1).values(:,1,state2StartIndex:endTimeIndex));
    allData.comError = squeeze(data.comData.signals(3).values(state2StartIndex:endTimeIndex,:));

    allData.tauMes_torso     = squeeze(data.tauMeasuredData.signals(1).values(state2StartIndex:endTimeIndex,:));
    allData.tauMes_left_arm  = squeeze(data.tauMeasuredData.signals(2).values(state2StartIndex:endTimeIndex,:));
    allData.tauMes_right_arm = squeeze(data.tauMeasuredData.signals(3).values(state2StartIndex:endTimeIndex,:));
    allData.tauMes_left_leg  = squeeze(data.tauMeasuredData.signals(4).values(state2StartIndex:endTimeIndex,:));
    allData.tauMes_right_leg = squeeze(data.tauMeasuredData.signals(5).values(state2StartIndex:endTimeIndex,:));
    
    allData.tauMes_all       = [allData.tauMes_torso,...
                                allData.tauMes_left_arm,...
                                allData.tauMes_right_arm,...
                                allData.tauMes_left_leg,...
                                allData.tauMes_right_leg];
    
    leg_torque_norm = zeros(1,size(allData.tauMes_left_leg,1));
    for k=1:size(leg_torque_norm,2)
        leg_torque_norm(k) = norm([allData.tauMes_left_leg(k,:),allData.tauMes_right_leg(k,:)]);
    end
    
    leg_power = zeros(1,size(allData.tauMes_left_leg,1));
    for k=1:size(leg_power,2)
        leg_power(k)       = [allData.tauMes_left_leg(k,:),allData.tauMes_right_leg(k,:)] * [allData.tauMes_left_leg(k,:),allData.tauMes_right_leg(k,:)]';
    end
    
    all_effort = zeros(1,size(allData.tauMes_all,1));
    for k=1:size(all_effort,2)
        all_effort(k)      = sqrt(allData.tauMes_all(k,:)*allData.tauMes_all(k,:)');
    end
    
    allData.power_stats = [leg_torque_norm' leg_power' all_effort'];
    
end