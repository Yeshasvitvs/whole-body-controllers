% % clc;
% % clear;
% % close all;

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
titleFontSize     = 20;

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
      
%% Load data
dataFolder = 'experiments19-Apr-2019';
addpath(strcat('./',dataFolder))
andyStandupData = load('exp_17-37');

time  = andyStandupData.tauMeasuredData.time;

%% Data range to consider
range = size(time,1);

state = andyStandupData.comData.signals(4).values;

state2StartIndex = find(state == 2,1);
state3StartIndex = find(state == 3,1);
state4StartIndex = find(state == 4,1);

state2StartTime = time(state2StartIndex);
state3StartTime = time(state3StartIndex);
state4StartTime = time(state4StartIndex);


stateIndexes = [state2StartIndex state3StartIndex state4StartIndex];
timeIndexes  = [state2StartTime state3StartTime state4StartTime];

%% Load Plot Scripts
addpath(strcat('./plot_scripts/robot-quantities'))


%% Robot Plot Flags
comErrorPlotFlag          = false;
momentumErrorPlotFlag     = false;
posturalTaskErrorPlotFlag = false;
vLyapunovFunctionPlotFlag = false;
alphaProjectionPlotsFlag  = false;
measuredToruquePlotsFlag  = false;
legsPowerPlotsFlag        = false;

%% Robot CoM Error Plots
if (comErrorPlotFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    comMes = squeeze(andyStandupData.comData.signals(1).values)';
    comDes = squeeze(andyStandupData.comData.signals(2).values)';
    comErrorPlots(time, timeIndexes, comMes, comDes, range, lineWidth, verticleLineWidth,...
                  fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                  xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder);
              
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'comError.pdf'),fH,300);
end

%% Robot Momentume Error Plots
if (momentumErrorPlotFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    Htilde = squeeze(andyStandupData.Htilde.signals(1).values);
    momentumErrorPlots(time, timeIndexes, Htilde, range, lineWidth, verticleLineWidth,...
                            fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                            xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                        
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'momentumError.pdf'),fH,300);
end

%% Postural Task Error Plots
if (posturalTaskErrorPlotFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    qError_torso     = andyStandupData.jointErrorData.signals(1).values;
    qError_left_arm  = andyStandupData.jointErrorData.signals(2).values;
    qError_right_arm = andyStandupData.jointErrorData.signals(3).values;
    qError_left_leg  = andyStandupData.jointErrorData.signals(4).values;
    qError_right_leg = andyStandupData.jointErrorData.signals(5).values;

    qError = [qError_torso qError_left_arm qError_right_arm qError_left_leg qError_right_leg];
    
    posturalTaskErrorPlots(time, timeIndexes, qError, range, lineWidth, verticleLineWidth,...
                                fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                            
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'qError.pdf'),fH,300);
end

%% Lyapunov Function Plots
if (vLyapunovFunctionPlotFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    vLyap = squeeze(andyStandupData.V_lyap.signals(1).values)';
    %%TODO Inset Box Autocompletion
    
    vLyapunovFunctionPlots(time, timeIndexes, vLyap, range, lineWidth, verticleLineWidth,...
                                fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                            
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'vLyap.pdf'),fH,300);
end

%% Alpha Projection Plots
if (alphaProjectionPlotsFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    alpha = squeeze(andyStandupData.alpha.signals(1).values)';
    
    alphaProjectionPlots(time, timeIndexes, alpha, range, lineWidth, verticleLineWidth,...
                              fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                              xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                          
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'alpha.pdf'),fH,300);
end

%% Measures Torque Plots
if (measuredToruquePlotsFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    tauMes_torso     = squeeze(andyStandupData.tauMeasuredData.signals(1).values);
    tauMes_left_arm  = squeeze(andyStandupData.tauMeasuredData.signals(2).values);
    tauMes_right_arm = squeeze(andyStandupData.tauMeasuredData.signals(3).values);
    tauMes_left_leg  = squeeze(andyStandupData.tauMeasuredData.signals(4).values);
    tauMes_right_leg = squeeze(andyStandupData.tauMeasuredData.signals(5).values);
    
    tauMes = [tauMes_torso tauMes_left_arm tauMes_right_arm tauMes_left_leg tauMes_right_leg];
    
    measureTorquePlots(time, timeIndexes, tauMes,...
                       range, lineWidth, verticleLineWidth,...
                       fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                       xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                   
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'tauMes.pdf'),fH,300);
    
end

%% Legs Power Plots
if (legsPowerPlotsFlag)
    
    fH = figure('units','normalized','outerposition',[0 0 1 1]);
    
    tauMes_torso     = squeeze(andyStandupData.tauMeasuredData.signals(1).values);
    tauMes_left_arm  = squeeze(andyStandupData.tauMeasuredData.signals(2).values);
    tauMes_right_arm = squeeze(andyStandupData.tauMeasuredData.signals(3).values);
    tauMes_left_leg  = squeeze(andyStandupData.tauMeasuredData.signals(4).values);
    tauMes_right_leg = squeeze(andyStandupData.tauMeasuredData.signals(5).values);
    
    tauMes = [tauMes_torso tauMes_left_arm tauMes_right_arm tauMes_left_leg tauMes_right_leg];
    
    legsPowerPlots(time, timeIndexes, tauMes, tauMes_left_leg, tauMes_right_leg,...
                       range, lineWidth, verticleLineWidth,...
                       fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                       xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, state_colors, fullPlotFolder)
                   
    save2pdf(fullfile(strcat(fullPlotFolder, '/robotPlots/'), 'legsPower.pdf'),fH,300);
end


% % %% Assistant Quantities Plots
if (andyStandupData.Config.USING_ROBOT_ASSISTANT)
    assistant = "Robot";
elseif (andyStandupData.Config.USING_HUMAN_ASSISTANT)
    assistant = "Human";
end

plotAssistantQuantities_SingleExp(andyStandupData, assistant, time, timeIndexes,...
                                       range, lineWidth, verticleLineWidth,...
                                       fontSize, legendFontSize, axesLineWidth, axesFontSize,...
                                       xLabelFontSize, yLabelFontSize, titleFontSize, markerSize, statesMarker, colors, fullPlotFolder)

