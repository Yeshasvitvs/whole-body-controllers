clc;
clear;
close all;

plotFolder = 'plots';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

%% configuration parameters
lineWidth         = 2;
fontSize          = 10;
legendFontSize    = 10;
axesLineWidth     = 2;
axesFontSize      = 10;
xLabelFontSize    = 10;
yLabelFontSize    = 10;
markerSize        = 2;
verticleLineWidth = 2;
titleFontSize     = 10;
gridOption        = 'on';
minorGridOption   = 'off';
axisOption        = 'normal';

colors = [0        0.4470   0.7410;
          0.8500   0.3250   0.0980;
          0.9290   0.6940   0.1250;
          0.4940   0.1840   0.5560;
          0.4660   0.6740   0.1880;
          0.9010   0.2450   0.630];
      
state_colors = [0.725 0.22 0.35;
                0.35 0.725 0.22;
                0.22 0.35 0.725];
      
statesMarker = ["o",":","d"];

%% Time tolerance in data
timeTolerance = 0.2;
endBufferTime = 3.5;

%% Load data folder
dataFolder = 'andy_standup_experiments_data';
addpath(strcat('./',dataFolder));

normalStandupDataFolder = dataFolder + "/normal";
pHRIMeasuredFTStandupDataFolder = dataFolder + "/pHRI-measured-ft";
pRRIStandupDataFolder = dataFolder + "/pRRI";

%% Analyze data set
normalStandUpData = analyzeAnDyStandupDataSet(normalStandupDataFolder, timeTolerance, endBufferTime);
% % pHRIMeasuredFTStandUpData = analyzeAnDyStandupDataSet(pHRIMeasuredFTStandupDataFolder, timeTolerance, endBufferTime);
pRRIStandUpData = analyzeAnDyStandupDataSet(pRRIStandupDataFolder, timeTolerance, endBufferTime);

%% Get state times
state2time = 0.0;
state3time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time);
state4time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time)... 
             + mean(pRRIStandUpData.start4time-pRRIStandUpData.start3time);

timeIndexes = [state2time state3time state4time];

%% CoM Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
yLimits = [];
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];

for i = 1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    normalHandle = plotMeanAndSTD(sH, normalStandUpData.time,...
                                      normalStandUpData.comErr_statistics_mean(i,:)',...
                                      normalStandUpData.comErr_statistics_confidence(i,:)',...
                                      lineWidth, colors(1,:));

    hold on;
    pRRIHandle = plotMeanAndSTD(sH, pRRIStandUpData.time,...
                                    pRRIStandUpData.comErr_statistics_mean(i,:)',...
                                    pRRIStandUpData.comErr_statistics_confidence(i,:)',...
                                    lineWidth, colors(4,:));
    hold on;
    
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits(i,:) = get(gca,'YLim');
    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(i,1)-0.001,yLimits(i,2)+0.001,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
    end
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    
    ylabel(CoM_label_dict(i), 'FontSize', yLabelFontSize);
    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    lgd = legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
                {'Normal Standup','pRRI Standup','State 2','State 3', 'State 4'},...
                 'Location','best','Box','off','FontSize',legendFontSize);
    lgd.NumColumns = size(lgd.String,2);
end


currentFigure = gcf;
title(currentFigure.Children(end), 'Center of Mass Error', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetCoMError.pdf'),fH,300);

%% Momentum Error Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
yLimits = [];

mom_label_dict1 = ["X $[Kg-m/s]$","Y $[Kg-m/s]$","Z $[Kg-m/s]$"];
mom_label_dict2 = ["X $[kg-m^2/s]$","Y $[kg-m^2/s]$","Z $[kg-m^2/s]$"];

index = 1;

for i=1:3
    for j=1:2
        sH = subplot(3,2,index); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        normalHandle = plotMeanAndSTD(sH, normalStandUpData.time,...
                                      normalStandUpData.Htilde_statistics_mean(i+3*(j-1),:)',...
                                      normalStandUpData.Htilde_statistics_confidence(i+3*(j-1),:)',...
                                      lineWidth, colors(1,:));

        hold on;
        pRRIHandle = plotMeanAndSTD(sH, pRRIStandUpData.time,...
                                    pRRIStandUpData.Htilde_statistics_mean(i+3*(j-1),:)',...
                                    pRRIStandUpData.Htilde_statistics_confidence(i+3*(j-1),:)',...
                                    lineWidth, colors(4,:));
        hold on;
        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(index,:) = get(gca,'YLim');
        for k=1:3
            xvalues = timeIndexes(k)*ones(10,1);
            yValues = linspace(yLimits(index,1),yLimits(index,2),10)';
            s(k) = plot(xvalues,yValues,statesMarker(k),'LineWidth', verticleLineWidth); hold on;
            s(k).Color = state_colors(k,:);
            uistack(pRRIHandle);
        end
        index = index + 1;
        
        ax = gca;
        axis(ax,axisOption);
        ax.XGrid = gridOption;
        ax.YGrid = gridOption;
        ax.XMinorGrid = minorGridOption;
        ax.YMinorGrid = minorGridOption;
        
        xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
        if j == 1 
            ylabel(mom_label_dict1(i),'Interpreter', 'latex', 'FontSize', yLabelFontSize);
        else
            ylabel(mom_label_dict2(i),'Interpreter', 'latex', 'FontSize', yLabelFontSize);
        end
        
        lgd = legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
                     {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'},...
                     'Location','best','Box','off','FontSize',legendFontSize);
        lgd.NumColumns = 2;
        
    end
end

currentFigure = gcf;
t = title(currentFigure.Children(end), 'Momentum Error', 'FontSize', titleFontSize);
set(t,'Position',[6.9 17.0 0.0]);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetMomentumError.pdf'),fH,300);

%% Lyapunov Function Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.LyapunovV_statistics_mean',...
                                  normalStandUpData.LyapunovV_statistics_confidence',...
                                  lineWidth, colors(1,:));
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.LyapunovV_statistics_mean',...
                                pRRIStandUpData.LyapunovV_statistics_confidence',...
                                lineWidth, colors(4,:));
hold on;  

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'},...
       'Location','best','Box','off','FontSize',legendFontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('$V_{lyap}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Lyapunov Function', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLyapunovFunction.pdf'),fH,300);

%% Effort Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.effort_statistics_mean',...
                                  normalStandUpData.effort_statistics_confidence',...
                                  lineWidth, colors(1,:));
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.effort_statistics_mean',...
                                pRRIStandUpData.effort_statistics_confidence',...
                                lineWidth, colors(4,:));
hold on;

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'},...
       'Location','best','Box','off','FontSize',legendFontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Joint Effort', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Joint Efforts', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetRobotEffort.pdf'),fH,300);

%% Leg Power Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.legPower_statistics_mean',...
                                  normalStandUpData.legPower_statistics_confidence',...
                                  lineWidth, colors(1,:));
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.legPower_statistics_mean',...
                                pRRIStandUpData.legPower_statistics_confidence',...
                                lineWidth, colors(4,:));
hold on;

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'},...
       'Location','best','Box','off','FontSize',legendFontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Power', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Legs Power', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLegsPower.pdf'),fH,300);

%% Leg Torque Norm Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.legTorqueNorm_statistics_mean',...
                                  normalStandUpData.legTorqueNorm_statistics_confidence',...
                                  lineWidth, colors(1,:));
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.legTorqueNorm_statistics_mean',...
                                pRRIStandUpData.legTorqueNorm_statistics_confidence',...
                                lineWidth, colors(4,:));
hold on;

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'},...
       'Location','best','Box','off','FontSize',legendFontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Torque Norm', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Legs Torques Norm', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLegsTorqueNorm.pdf'),fH,300);


