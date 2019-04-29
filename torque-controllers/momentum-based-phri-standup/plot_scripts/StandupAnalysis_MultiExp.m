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

%% TODO: Add the state indication plots

%% Effort Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.effort_statistics_mean',...
                                  normalStandUpData.effort_statistics_confidence',...
                                  lineWidth, colors(1,:));
normalStandUpData.LineWidth = lineWidth;
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.effort_statistics_mean',...
                                pRRIStandUpData.effort_statistics_confidence',...
                                lineWidth, colors(4,:));
pRRIHandle.LineWidth = lineWidth;
grid on;

state2time = 0.0;
state3time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time);
state4time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time)... 
             + mean(pRRIStandUpData.start4time-pRRIStandUpData.start3time);

timeIndexes = [state2time state3time state4time];

yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'});
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Joint Effort', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Joint Efforts', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetRobotEffort.pdf'),fH,300);

%% Lyapunov Function Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
normalHandle = plotMeanAndSTD(ax, normalStandUpData.time,...
                                  normalStandUpData.LyapunovV_statistics_mean',...
                                  normalStandUpData.LyapunovV_statistics_confidence',...
                                  lineWidth, colors(1,:));
normalStandUpData.LineWidth = lineWidth;
hold on;
pRRIHandle = plotMeanAndSTD(ax, pRRIStandUpData.time,...
                                pRRIStandUpData.LyapunovV_statistics_mean',...
                                pRRIStandUpData.LyapunovV_statistics_confidence',...
                                lineWidth, colors(4,:));
pRRIHandle.LineWidth = lineWidth;
grid on;

state2time = 0.0;
state3time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time);
state4time = mean(pRRIStandUpData.start3time-pRRIStandUpData.start2time)... 
             + mean(pRRIStandUpData.start4time-pRRIStandUpData.start3time);

timeIndexes = [state2time state3time state4time];

yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(pRRIHandle);
end

legend([normalHandle pRRIHandle s(1) s(2) s(3)],...
       {'Normal Standup','pRRI Standup','State 2', 'State 3', 'State 4'});
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('$V_{lyap}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Lyapunov Function', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLyapunovFunction.pdf'),fH,300);
