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
noWrenchNormal = load('no-external-wrench-timed-normal');
noWrenchReactive = load('no-external-wrench-timed-reactive');

assistiveDataForwardsNormal = load ('assistive-wrench-timed-forwards-normal');
opposingDataForwardsNormal = load ('opposing-wrench-timed-forwards-normal');

assistiveDataForwardsReactive = load ('assistive-wrench-timed-forwards-reactive');
opposingDataForwardsReactive = load ('opposing-wrench-timed-forwards-reactive');

assistiveDataBackwardsNormal = load ('assistive-wrench-timed-backwards-normal');
opposingDataBackwardsNormal = load ('opposing-wrench-timed-backwards-normal');

assistiveDataBackwardsReactive = load ('assistive-wrench-timed-backwards-reactive');
opposingDataBackwardsReactive = load ('opposing-wrench-timed-backwards-reactive');


allData = {noWrenchNormal noWrenchReactive};

%%  Common plot options
xLabelOptions = 'Time $[s]$';
yPlotColors = [colors(1,:);colors(2,:);colors(3,:)];
legendOptions = {'No External Wrench Normal', 'No External Wrench Reactive'};
fileNameSuffixes = ["Assistive", "Opposing",'No External Wrench'];

%%Time
totalTime = allData{1,1}.tout;

%% Time indexes
startTimeIndex = ceil(size(totalTime,1)*0.1);
endTimeIndex = ceil(size(totalTime,1));

%% Trim time
trimTime = totalTime(startTimeIndex:endTimeIndex);



%% Plot Joints Effort
yLabelOptions = 'Joint Effort';
plotTitle = 'End-Effector Joint Efforts';
subplotOption = false;
usePlotColoring = true;
legendColumns = 1;
allDataEEJointEfforts = cell(1, size(allData,2));

%% EE Joints Efforts
for d = 1:size(allData,2)
    eeMeasuredTorques = allData{1,d}.eeTorques{1}.Values.Data(startTimeIndex:endTimeIndex,:);
    %% Compute joint efforts
    eeJointsEffort = zeros(1, size(eeMeasuredTorques,1));
    for i = 1 : size(eeMeasuredTorques, 1)
        eeJointsEffort(i) = sqrt(eeMeasuredTorques(i,:) * eeMeasuredTorques(i,:)');
    end
    allDataEEJointEfforts{d} = eeJointsEffort;
end


plotRobotQuantity(allDataEEJointEfforts, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);


%% Lyapunov Function
yLabelOptions = '$V_{lypunov}$';
plotTitle = 'Lyapunov Function';
subplotOption = false;
usePlotColoring = true;
legendColumns = 1;
allDataLypunovFunction = cell(1, size(allData,2));

for d = 1:size(allData,2)
    v_lyap = allData{1,d}.V_lyap.signals.values(startTimeIndex:endTimeIndex,:);
    allDataLypunovFunction{d} = v_lyap;
end

plotRobotQuantity(allDataLypunovFunction, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);



%% Alpha Value
yLabelOptions = '$\alpha$';
plotTitle = 'Alpha';
subplotOption = false;
usePlotColoring = true;
legendColumns = 1;
allDataAlphaValue = cell(1, size(allData,2));

for d = 1:size(allData,2)
    alpha = allData{1,d}.alpha.signals.values(startTimeIndex:endTimeIndex,:);
    allDataAlphaValue{d} = alpha;
end

plotRobotQuantity(allDataAlphaValue, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);
              

%% Legend common options for wrench plots
yPlotColors = colors;
legendOptions = {'$f_x$', '$f_y$', '$f_z$', '$\tau_x$', '$\tau_y$', '$\tau_z$'};
              
%% End-Effector Wrench
yLabelOptions = '$N$';
plotTitle = 'End-Effector Wrench';
subplotOption = true;
usePlotColoring = false;
legendColumns = 2;
allDataEEWrench = cell(1, size(allData,2));

for d = 1:size(allData,2)
    eeWrench = allData{1,d}.ee_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataEEWrench{d} = eeWrench;
end

plotRobotQuantity(allDataEEWrench, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);

%% Correction From Support Wrench
yLabelOptions = '$N$';
plotTitle = 'Correction From Support Wrench';
subplotOption = true;
usePlotColoring = false;
legendColumns = 2;
allDataCorrectionFromSupportWrench = cell(1, size(allData,2));

for d = 1:size(allData,2)
    correctionFromSupportWrench = allData{1,d}.correctionFromSupportWrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataCorrectionFromSupportWrench{d} = correctionFromSupportWrench;
end

plotRobotQuantity(allDataCorrectionFromSupportWrench, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);


