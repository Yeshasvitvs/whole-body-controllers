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
axisOption        = 'tight';

colors = [0        0.4470   0.7410;
          0.8500   0.3250   0.0980;
          0.9290   0.6940   0.1250;
          0.4940   0.1840   0.5560;
          0.4660   0.6740   0.1880;
          0.9010   0.2450   0.6300];
      
state_colors = [0.725 0.22 0.35;
                0.35 0.725 0.22;
                0.22 0.35 0.725];
      
statesMarker = ["o",":","d"];

%% Time tolerance in data
timeTolerance = 0.05;
endBufferTime = 3;

%% Load data folder
dataFolder = 'andy_standup_experiments_data_02_may_2019';
addpath(strcat('./',dataFolder));

normalStandupDataFolder = dataFolder + "/normal";
pHRI1HelpStandupDataFolder = dataFolder + "/pHRI1-help";
pHRI1OpposeStandupDataFolder = dataFolder + "/pHRI1-oppose";
pHRI1UntrainedStandupDataFolder = dataFolder + "/pHRI1-untrained";
pHRI3StandupDataFolder = dataFolder + "/pHRI3";

%% Analyze data set
normalStandUpData = analyzeAnDyStandupDataSet(normalStandupDataFolder, timeTolerance, endBufferTime);
pHRI1HelpStandUpData = analyzeAnDyStandupDataSet(pHRI1HelpStandupDataFolder, timeTolerance, endBufferTime);
pHRI1OpposeStandUpData = analyzeAnDyStandupDataSet(pHRI1OpposeStandupDataFolder, timeTolerance, endBufferTime);
pHRI1UntrainedStandUpData = analyzeAnDyStandupDataSet(pHRI1UntrainedStandupDataFolder, timeTolerance, endBufferTime);
pHRI3StandUpData = analyzeAnDyStandupDataSet(pHRI3StandupDataFolder, timeTolerance, endBufferTime);

allData = {normalStandUpData pHRI1HelpStandUpData pHRI3StandUpData};
legendOptions = {'Normal Standup', 'pHRI1 Trained Helping Standup', 'pHRI3 Standup'...
                 'State 2', 'State 3', 'State 4'};

%% Get state times
state2time = 0.0;
state3time = mean(allData{1,1}.start3time-allData{1,1}.start2time);
state4time = mean(allData{1,1}.start3time-allData{1,1}.start2time)... 
             + mean(allData{1,1}.start4time-allData{1,1}.start3time);

timeIndexes = [state2time state3time state4time];

%% CoM Desired Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
yLimits = [];
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];

for i = 1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    for d = 1:size(allData,2)
        dataHandle(d) = plotMeanAndSTD(sH, allData{1,d}.time,...
                                       allData{1,d}.comDes_statistics_mean(i,:)',...
                                       allData{1,d}.comDes_statistics_confidence(i,:)',...
                                       lineWidth, colors(d,:));
        hold on;
    end
    
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits(i,:) = get(gca,'YLim');
    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(i,1)-0.001,yLimits(i,2)+0.001,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
    end
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    
    ylabel(CoM_label_dict(i), 'FontSize', yLabelFontSize);
    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);
    lgd.NumColumns = 2;
end


currentFigure = gcf;
title(currentFigure.Children(end), 'Center of Mass Desired', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetCoMDesired.pdf'),fH,300);

%% CoM Error Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
yLimits = [];
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];

for i = 1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    for d = 1:size(allData,2)
        dataHandle(d) = plotMeanAndSTD(sH, allData{1,d}.time,...
                                       allData{1,d}.comErr_statistics_mean(i,:)',...
                                       allData{1,d}.comErr_statistics_confidence(i,:)',...
                                       lineWidth, colors(d,:));
        hold on;
    end
    
    set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
    yLimits(i,:) = get(gca,'YLim');
    for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(i,1)-0.001,yLimits(i,2)+0.001,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth', verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
    end
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    
    ylabel(CoM_label_dict(i), 'FontSize', yLabelFontSize);
    xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);
    lgd.NumColumns = 2;
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
        for d = 1:size(allData,2)
            dataHandle(d) = plotMeanAndSTD(sH, allData{1,d}.time,...
                                           allData{1,d}.Htilde_statistics_mean(i+3*(j-1),:)',...
                                           allData{1,d}.Htilde_statistics_confidence(i+3*(j-1),:)',...
                                           lineWidth, colors(d,:));
            hold on;
        end

        set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
        yLimits(index,:) = get(gca,'YLim');
        for k=1:3
            xvalues = timeIndexes(k)*ones(10,1);
            yValues = linspace(yLimits(index,1),yLimits(index,2),10)';
            s(k) = plot(xvalues,yValues,statesMarker(k),'LineWidth', verticleLineWidth); hold on;
            s(k).Color = state_colors(k,:);
            uistack(dataHandle);
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
        
        lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
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
for d = 1:size(allData,2)
    dataHandle(d) = plotMeanAndSTD(ax, allData{1,d}.time,...
                                           allData{1,d}.LyapunovV_statistics_mean',...
                                           allData{1,d}.LyapunovV_statistics_confidence',...
                                           lineWidth, colors(d,:));
    hold on;
end
  
set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
             'Location','best','Box','off','FontSize',legendFontSize);
lgd.NumColumns = 2;

xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('$V_{lyap}$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Lyapunov Function', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLyapunovFunction.pdf'),fH,300);

%% Effort Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
for d = 1:size(allData,2)
    dataHandle(d) = plotMeanAndSTD(ax, allData{1,d}.time,...
                                       allData{1,d}.effort_statistics_mean',...
                                       allData{1,d}.effort_statistics_confidence',...
                                       lineWidth, colors(d,:));
    hold on;
end

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
             'Location','best','Box','off','FontSize',legendFontSize);
lgd.NumColumns = 2;
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Joint Effort', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Joint Efforts', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetRobotEffort.pdf'),fH,300);

%% Leg Power Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
for d = 1:size(allData,2)
    dataHandle(d) = plotMeanAndSTD(ax, allData{1,d}.time,...
                                       allData{1,d}.legPower_statistics_mean',...
                                       allData{1,d}.legPower_statistics_confidence',...
                                       lineWidth, colors(d,:));
    hold on;
end

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
             'Location','best','Box','off','FontSize',legendFontSize);
lgd.NumColumns = 2;
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Power', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Legs Power', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLegsPower.pdf'),fH,300);

%% Leg Torque Norm Plots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
for d = 1:size(allData,2)
    dataHandle(d) = plotMeanAndSTD(ax, allData{1,d}.time,...
                                       allData{1,d}.legTorqueNorm_statistics_mean',...
                                       allData{1,d}.legTorqueNorm_statistics_confidence',...
                                       lineWidth, colors(d,:));
    hold on;
end

set (gca, 'FontSize' , axesFontSize, 'LineWidth', axesLineWidth);
yLimits = get(gca,'YLim');
for j=1:3
        xvalues = timeIndexes(j)*ones(10,1);
        yValues = linspace(yLimits(1)-1,yLimits(2)+1,10)';
        s(j) = plot(xvalues,yValues,statesMarker(j),'LineWidth',verticleLineWidth); hold on;
        s(j).Color = state_colors(j,:);
        uistack(dataHandle);
end

ax = gca;
axis(ax,axisOption);
ax.XGrid = gridOption;
ax.YGrid = gridOption;
ax.XMinorGrid = minorGridOption;
ax.YMinorGrid = minorGridOption;

lgd = legend([dataHandle s(1) s(2) s(3)], legendOptions,...
             'Location','best','Box','off','FontSize',legendFontSize);
lgd.NumColumns = 2;
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
ylabel('Torque Norm', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
title('Robot Legs Torques Norm', 'FontSize', titleFontSize);

save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'MultiDataSetLegsTorqueNorm.pdf'),fH,300);


