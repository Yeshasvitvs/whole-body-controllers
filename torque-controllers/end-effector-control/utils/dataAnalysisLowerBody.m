clc;
clear;
close all;

plotFolder = 'plots/lower-body';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

%% configuration parameters
lineWidth         = 7.5;
fontSize          = 40;
legendFontSize    = 40;
axesLineWidth     = 7.5;
axesFontSize      = 45;
xLabelFontSize    = 45;
yLabelFontSize    = 45;
markerSize        = 2;
verticleLineWidth = 2;
titleFontSize     = 60;
gridOption        = 'off';
minorGridOption   = 'off';
axisOption        = 'tight';
axisLimitBuffer   = 0.05;

colors = [0        0.4470   0.7410;
          0.8500   0.3250   0.0980;
          0.9290   0.6940   0.1250;
          0.4940   0.1840   0.5560;
          0.4660   0.6740   0.1880;
          0.9010   0.2450   0.6300];
      
state_colors = [0.725 0.22 0.35;
                0.35 0.725 0.22;
                0.22 0.35 0.725];
                        
%% Experiment Parameters
amplitude = 0.05;
            
%% Load data folder
dataFolder = 'experiments/lower-body';
addpath(strcat('./',dataFolder));

% % %% Normal Trajectory Tracking
% % normalXTrajectoryData = load('normal-x-untimed');
% % normalYTrajectoryData = load('normal-y-untimed');
% % 
% % allData = {normalXTrajectoryData normalYTrajectoryData};
% % legendOptions = {'Normal Trajectory'};
% % 
% % %%Time
% % time = allData{1,2}.tout;
% % 
% % %% Time indexes
% % startTimeIndex = ceil(size(time,1)*0.1);
% % endTimeIndex = ceil(size(time,1));
% % legendOptions = ["Reference","Actual"];
% % 
% % fileNameSuffixes = ["x","y"];
% % 
% % %%Plot 2D Trajectory Tracking
% % for d = 1:size(allData,2)
% %     
% %     fH = figure('units','normalized','outerposition',[0 0 0.5 1]);
% %     ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% %     
% %     
% %     Xdesired = allData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
% %     Xactual = allData{1,d}.Xactual.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(Xdesired(:,1), Xdesired(:,2),'LineWidth',lineWidth);
% %     hold on;
% %     plot(Xactual(:,1), Xactual(:,2),'LineWidth',lineWidth);
% %     
% %     ax = gca;
% %     axis(ax,axisOption);
% %     ax.XGrid = gridOption;
% %     ax.YGrid = gridOption;
% %     ax.XMinorGrid = minorGridOption;
% %     ax.YMinorGrid = minorGridOption;
% %     ax.FontSize = axesFontSize;
% %     ax.LineWidth = axesLineWidth;
% %     
% %     xLimits(d,:) = get(gca,'XLim');
% %     yLimits(d,:) = get(gca,'YLim');
% %     
% %     xlim([xLimits(d,1)-amplitude*axisLimitBuffer xLimits(d,2)+amplitude*axisLimitBuffer]);
% %     ylim([yLimits(d,1)-amplitude*axisLimitBuffer yLimits(d,2)+amplitude*axisLimitBuffer]);
% %     
% %     ylabel('Y $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('X $[m]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% %     currentFigure = gcf;
% %     title(currentFigure.Children(end), 'Trajectory Tracking',...
% %           'Interpreter', 'latex','FontSize', titleFontSize);
% %     lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% %     save2pdf(fullfile(fullPlotFolder, strcat('NormalTrajectoryTracking-' + fileNameSuffixes(d) + '.pdf')),fH,300);
% %     
% % end

%% 1D X Plots
assistiveXTrajectoryData = load('assistive-x-timed');
agnosticXTrajectoryData = load('agnostic-x-timed');

allXData = {assistiveXTrajectoryData agnosticXTrajectoryData};
yPlotColors = [colors(2,:);colors(1,:)];
legendOptions = {'Assistive Wrench', 'Agnostic Wrench'};
fileNameSuffixes = ["Helping", "Agnostic"];

%%Time
totalTime = allXData{1,1}.tout;

%% Time indexes
startTimeIndex = ceil(size(totalTime,1)*0.1);
endTimeIndex = ceil(size(totalTime,1));

%% Trim time
trimTime = totalTime(startTimeIndex:endTimeIndex);

%% Reference Trajectory Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allXData,2)
       
    Xdesired = allXData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,Xdesired(:,1), 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('X $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Reference 1D Trajectory along X-axis',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'ReferenceTrajectory-x.pdf'),fH,300);

%% Trajectory Tracking Error Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allXData,2)
       
    Xdesired = allXData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
    Xactual = allXData{1,d}.Xactual.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,Xdesired(:,1)-Xactual(:,1), 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('X $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Trajectory Tracking Error along X-axis',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'TrajectoryTrackingError-x.pdf'),fH,300);

%% S value Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allXData,2)
       
    s = allXData{1,d}.s.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,s, 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
    
    ylabel('$\psi$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Trajectory Free Parameter $\psi$',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'Svalue-x.pdf'),fH,300);

%% Wrench Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allXData,2)
    
    sH = subplot(size(allXData,2),1,d); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    
    rHandForces = allXData{1,d}.lhand_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    
    plot(trimTime,rHandForces, 'LineWidth',lineWidth);
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
    
    ylabel('Force $[N]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    lgd = legend('f_x','f_y','f_z','Interpreter', 'latex',...
                 'Location','best','Box','off');
    lgd.NumColumns = 3;
    lgd.Box = 'off';
    title(legendOptions(d), 'FontSize', titleFontSize,...
          'Interpreter', 'latex');
        
end

save2pdf(fullfile(fullPlotFolder, 'wrench-x.pdf'),fH,300);



%% 1D Y Plots
assistiveYTrajectoryData = load('assistive-y-timed');
agnosticYTrajectoryData = load('agnostic-y-timed');

allYData = {assistiveYTrajectoryData agnosticYTrajectoryData};
yPlotColors = [colors(2,:);colors(1,:)];
legendOptions = {'Assistive Wrench', 'Agnostic Wrench'};
fileNameSuffixes = ["Helping", "Agnostic"];

%%Time
totalTime = allYData{1,1}.tout;

%% Time indexes
startTimeIndex = ceil(size(totalTime,1)*0.1);
endTimeIndex = ceil(size(totalTime,1));

%% Trim time
trimTime = totalTime(startTimeIndex:endTimeIndex);

%% Reference Trajectory Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allYData,2)
       
    Xdesired = allYData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,Xdesired(:,2), 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('Y $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Reference 1D Trajectory along Y-axis',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'ReferenceTrajectory-y.pdf'),fH,300);

%% Trajectory Tracking Error Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allYData,2)
       
    Xdesired = allYData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
    Xactual = allYData{1,d}.Xactual.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,Xdesired(:,2)-Xactual(:,2), 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('Y $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Trajectory Tracking Error along Y-axis',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'TrajectoryTrackingError-y.pdf'),fH,300);

%% S value Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allYData,2)
       
    s = allYData{1,d}.s.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(trimTime,s, 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
    
    ylabel('$\psi$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

currentFigure = gcf;
title(currentFigure.Children(end), 'Trajectory Free Parameter $\psi$',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

save2pdf(fullfile(fullPlotFolder, 'Svalue-y.pdf'),fH,300);

%% Wrench Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allYData,2)
    
    sH = subplot(size(allYData,2),1,d); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    
    rHandForces = allYData{1,d}.lhand_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    
    plot(trimTime,rHandForces, 'LineWidth',lineWidth);
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
    
    ylabel('Force $[N]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    lgd = legend('f_x','f_y','f_z','Interpreter', 'latex',...
                 'Location','best','Box','off');
    lgd.NumColumns = 3;
    lgd.Box = 'off';
    title(legendOptions(d), 'FontSize', titleFontSize,...
          'Interpreter', 'latex');
        
end

save2pdf(fullfile(fullPlotFolder, 'wrench-y.pdf'),fH,300);


