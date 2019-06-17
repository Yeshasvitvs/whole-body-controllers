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
xLabelFontSize    = 15;
yLabelFontSize    = 15;
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
% % dataFileNames = ["no-external-wrench-normal",...
% %                  "no-external-wrench-reactive",...
% %                  "forward-wrench-forward-motion-normal",...
% %                  "forward-wrench-forward-motion-reactive",...
% %                  "backward-wrench-forward-motion-normal",...
% %                  "backward-wrench-forward-motion-reactive"];

dataFileNames = ["forward-wrench-forward-motion-reactive",...
                 "backward-wrench-forward-motion-reactive",...
                 "orthogonal-y-wrench-forward-motion-reactive",...
                 "orthogonal-z-wrench-forward-motion-reactive"];
             
allData = cell(size(dataFileNames));
legendOptions = cell(size(dataFileNames));
             
for i = 1:size(dataFileNames,2)
    allData{i} = load(dataFileNames{i});
    legendOptions{i} = dataFileNames{i};
end

%%  Common plot options
xLabelOptions = 'Time $[s]$';
yPlotColors = colors;
subplotOption = false;
usePlotColoring = false;
legendColumns = 1;

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
subplotTitles = [];
fileNameSuffixes = "ee-joint-effort";
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
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);


%% Lyapunov Function
yLabelOptions = '$V_{lypunov}$';
plotTitle = 'Lyapunov Function';
fileNameSuffixes = "lyapunov-function";
allDataLypunovFunction = cell(1, size(allData,2));

for d = 1:size(allData,2)
    v_lyap = allData{1,d}.V_lyap.signals.values(startTimeIndex:endTimeIndex,:);
    allDataLypunovFunction{d} = v_lyap;
end

plotRobotQuantity(allDataLypunovFunction, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);
              
%% Alpha Value
yLabelOptions = '$\alpha$';
plotTitle = 'Alpha';
fileNameSuffixes = "alpha";
allDataAlphaValue = cell(1, size(allData,2));

for d = 1:size(allData,2)
    alpha = allData{1,d}.alpha.signals.values(startTimeIndex:endTimeIndex,:);
    allDataAlphaValue{d} = alpha;
end

plotRobotQuantity(allDataAlphaValue, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);
              

%% Legend common options for wrench plots
subplotOption = true;
usePlotColoring = false;
yPlotColors = colors;
yLabelOptions = '$N$';
legendOptions = {'$f_x$', '$f_y$', '$f_z$', '$\tau_x$', '$\tau_y$', '$\tau_z$'};
legendColumns = 1;

subplotTitles = cell(size(dataFileNames));
             
for i = 1:size(dataFileNames,2)
    subplotTitles{i} = dataFileNames{i};
end
              
%% End-Effector Wrench
plotTitle = 'End-Effector Wrench';
fileNameSuffixes = "ee-wrench";
allDataEEWrench = cell(1, size(allData,2));

for d = 1:size(allData,2)
    eeWrench = allData{1,d}.ee_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataEEWrench{d} = eeWrench;
end

plotRobotQuantity(allDataEEWrench, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);

%% Correction From Support Wrench
plotTitle = 'Correction From Support Wrench';
fileNameSuffixes = "correction-from-support-wrench";
allDataCorrectionFromSupportWrench = cell(1, size(allData,2));

for d = 1:size(allData,2)
    correctionFromSupportWrench = allData{1,d}.correctionFromSupportWrench.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataCorrectionFromSupportWrench{d} = correctionFromSupportWrench;
end

plotRobotQuantity(allDataCorrectionFromSupportWrench, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);


%% Legend common options for wrench plots
subplotOption = true;
usePlotColoring = false;
yPlotColors = colors;
yLabelOptions = '$m/s$';
legendOptions = {'$v_x$', '$v_y$', '$v_z$', '$\omega_x$', '$\omega_y$', '$\omega_z$'};
legendColumns = 1;

%% Velocity Error
plotTitle = 'Velocity Error $\dot{\widetilde{x}}$';
fileNameSuffixes = "velocity-error";
allDataVelocityError = cell(1, size(allData,2));

for d = 1:size(allData,2)
    vel_error = allData{1,d}.vel_error.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataVelocityError{d} = vel_error;
end

plotRobotQuantity(allDataVelocityError, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);
              
%% Velocity Error Parallel
plotTitle = 'Velocity Error Parallel  $\dot{\widetilde{x}}^{\parallel}$';
fileNameSuffixes = "velocity-error-parallel";
allDataVelocityErrorParallel = cell(1, size(allData,2));

for d = 1:size(allData,2)
    vel_error_parallel = allData{1,d}.vel_error_parallel.signals.values(startTimeIndex:endTimeIndex,1:3);
    allDataVelocityErrorParallel{d} = vel_error_parallel;
end

plotRobotQuantity(allDataVelocityErrorParallel, trimTime, subplotOption, usePlotColoring,...
                  yPlotColors, legendOptions, legendFontSize, legendColumns,...
                  fontSize, xLabelFontSize, yLabelFontSize, titleFontSize,...
                  axisOption, axesFontSize, axesLineWidth,...
                  gridOption, minorGridOption, lineWidth, plotTitle, subplotTitles,...
                  xLabelOptions, yLabelOptions, fileNameSuffixes, fullPlotFolder);



