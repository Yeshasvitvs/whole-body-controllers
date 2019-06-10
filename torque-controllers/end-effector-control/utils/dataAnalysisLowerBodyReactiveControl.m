clc;
clear;
close all;

plotFolder = 'plots/reactive-control/simulation';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

%% configuration parameters
lineWidth         = 2.5;
fontSize          = 20;
legendFontSize    = 20;
axesLineWidth     = 2.5;
axesFontSize      = 25;
xLabelFontSize    = 25;
yLabelFontSize    = 25;
markerSize        = 2;
verticleLineWidth = 2;
titleFontSize     = 20;
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
            
%% Load data folder
dataFolder = 'experiments/reactive-control/simulation/x-direction';
addpath(strcat('./',dataFolder));

%% Load data
assistiveData = load('assistive-wrench-timed-forwards');
opposingData = load('opposing-wrench-timed-forwards');
% agnosticData = load('agnostic-wrench-timed-backwards-lower-wrench');

allData = {assistiveData opposingData};
yPlotColors = [colors(1,:);colors(2,:);colors(3,:)];
legendOptions = {'Assistive Wrench', 'Opposing Wrench'};
fileNameSuffixes = ["Assistive", "Opposing"];

%%Time
totalTime = allData{1,1}.tout;

%% Time indexes
startTimeIndex = ceil(size(totalTime,1)*0.1);
endTimeIndex = ceil(size(totalTime,1));

%% Trim time
trimTime = totalTime(startTimeIndex:endTimeIndex);

%% EE Joint Efforts
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);

for d = 1:size(allData,2)
    
    eeMeasuredTorques = allData{1,d}.eeTorques{1}.Values.Data(startTimeIndex:endTimeIndex,:);
   
    %% Compute joint efforts
    eeJointsEffort = zeros(1, size(eeMeasuredTorques,1));
    for i = 1 : size(eeMeasuredTorques, 1)
        eeJointsEffort(i) = sqrt(eeMeasuredTorques(i,:) * eeMeasuredTorques(i,:)');
    end

    plot(trimTime,eeJointsEffort, 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('Joint Effort', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
end

 currentFigure = gcf;
title(currentFigure.Children(end), 'End-Effector Joint Efforts',...
      'Interpreter', 'latex','FontSize', titleFontSize);
lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

% % save2pdf(fullfile(fullPlotFolder, 'ee-joint-efforts.pdf'),fH,300);

%% End-Effector Wrench
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
legendOptions = {'$f_x$', '$f_y$', '$f_z$','$\tau_x$','$\tau_y$','$\tau_z$'};
yLabelOption = {'Assistive Wrench', 'Opposing Wrench', 'Agnostic Wrench'};

for d = 1:size(allData,2)
    
    eeWrench = allData{1,d}.ee_wrench.signals.values(startTimeIndex:endTimeIndex,:);
    
    sH = subplot(size(allData,2),1,d); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
   
    plot(trimTime,eeWrench(:,1:3), 'LineWidth',lineWidth);
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel(yLabelOption{d}, 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize,...
                 'Interpreter', 'latex');
    lgd.NumColumns = 3;
    
end

 currentFigure = gcf;
title(currentFigure.Children(end), 'End-Effector Wrench',...
      'Interpreter', 'latex','FontSize', titleFontSize);

%% Correction From Support Wrench
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
legendOptions = {'$f_x$', '$f_y$', '$f_z$','$\tau_x$','$\tau_y$','$\tau_z$'};
yLabelOption = {'Assistive Wrench', 'Opposing Wrench', 'Agnostic Wrench'};

for d = 1:size(allData,2)
    
    correctionFromSupportWrench = allData{1,d}.correctionFromSupportWrench.signals.values(startTimeIndex:endTimeIndex,:);
    
    sH = subplot(size(allData,2),1,d); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
   
    plot(trimTime,correctionFromSupportWrench(:,1:3), 'LineWidth',lineWidth);
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel(yLabelOption{d}, 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize,...
                 'Interpreter', 'latex');
    lgd.NumColumns = 3;
    
end

 currentFigure = gcf;
title(currentFigure.Children(end), 'Correction From Support Wrench',...
      'Interpreter', 'latex','FontSize', titleFontSize);
  
%% Lyapunov Function
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
legendOptions = {'Lyapunov Function'};

for d = 1:size(allData,2)
    
    v_lyap = allData{1,d}.V_lyap.signals.values(startTimeIndex:endTimeIndex,:);
   
    plot(trimTime,v_lyap, 'LineWidth',lineWidth);
    hold on;
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
     
    ylabel('$V_{lyapunov}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize,...
                 'Interpreter', 'latex');
    lgd.NumColumns = 3;
    
end

 currentFigure = gcf;
title(currentFigure.Children(end), 'Correction From Support Wrench',...
      'Interpreter', 'latex','FontSize', titleFontSize);



