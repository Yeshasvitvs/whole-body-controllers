clc;
clear;
close all;

plotFolder = 'plots';

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
dataFolder = 'experiments';
addpath(strcat('./',dataFolder));

%% Normal Trajectory Tracking
normalYTrajectoryData = load('normal-y-untimed');
normalZTrajectoryData = load('normal-z-untimed');
normalYZTrajectoryData = load('normal-yz-untimed');

allData = {normalYTrajectoryData normalZTrajectoryData normalYZTrajectoryData};
legendOptions = {'Normal Trajectory'};

%%Time
time = allData{1,1}.tout;

%% Time indexes
startTimeIndex = ceil(size(time,1)*0.1);
endTimeIndex = ceil(size(time,1));
legendOptions = ["Reference","Actual"];

fileNameSuffixes = ["y","z","yz"];

%%Plot 2D Trajectory Tracking
for d = 1:size(allData,2)
    
    fH = figure('units','normalized','outerposition',[0 0 0.5 1]);
    ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
    
    
    Xdesired = allData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
    Xactual = allData{1,d}.Xactual.signals.values(startTimeIndex:endTimeIndex,:);
    
    plot(Xdesired(:,2), Xdesired(:,3),'LineWidth',lineWidth);
    hold on;
    plot(Xactual(:,2), Xactual(:,3),'LineWidth',lineWidth);
    
    ax = gca;
    axis(ax,axisOption);
    ax.XGrid = gridOption;
    ax.YGrid = gridOption;
    ax.XMinorGrid = minorGridOption;
    ax.YMinorGrid = minorGridOption;
    ax.FontSize = axesFontSize;
    ax.LineWidth = axesLineWidth;
    
    xLimits(d,:) = get(gca,'XLim');
    yLimits(d,:) = get(gca,'YLim');
    
    xlim([xLimits(d,1)-amplitude*axisLimitBuffer xLimits(d,2)+amplitude*axisLimitBuffer]);
    ylim([yLimits(d,1)-amplitude*axisLimitBuffer yLimits(d,2)+amplitude*axisLimitBuffer]);
    
    ylabel('Z $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
    xlabel('Y $[m]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
    
    currentFigure = gcf;
    title(currentFigure.Children(end), 'Trajectory Tracking',...
          'Interpreter', 'latex','FontSize', titleFontSize);
    lgd = legend(legendOptions,...
                 'Location','best','Box','off','FontSize',legendFontSize);

    save2pdf(fullfile(fullPlotFolder, strcat('NormalTrajectoryTracking-' + fileNameSuffixes(d) + '.pdf')),fH,300);
    
end


% % %% 1D Y Plots
% % assistiveYTrajectoryData = load('assistive-y-timed');
% % %opposingYTrajectoryData = load('opposing-y-timed');
% % agnosticYTrajectoryData = load('agnostic-y-timed');
% % 
% % allYData = {assistiveYTrajectoryData agnosticYTrajectoryData};
% % yPlotColors = [colors(2,:);colors(1,:)];
% % legendOptions = {'Assistive Wrench', 'Agnostic Wrench'};
% % fileNameSuffixes = ["Helping", "Agnostic"];
% % 
% % %%Time
% % totalTime = allYData{1,1}.tout;
% % 
% % %% Time indexes
% % startTimeIndex = ceil(size(totalTime,1)*0.1);
% % endTimeIndex = ceil(size(totalTime,1));
% % 
% % %% Trim time
% % trimTime = totalTime(startTimeIndex:endTimeIndex);
% % 
% % %% Reference Trajectory Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %        
% %     Xdesired = allYData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(trimTime,Xdesired(:,2), 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
% %     hold on;
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
% %     ylabel('Y $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Reference 1D Trajectory along Y-axis',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'ReferenceTrajectory-y.pdf'),fH,300);
% % 
% % %% S value Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %        
% %     s = allYData{1,d}.s.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(trimTime,s, 'LineWidth',lineWidth,'Color',yPlotColors(d,:));
% %     hold on;
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
% %     ylabel('$\psi$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Trajectory Free Parameter $\psi$',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'Svalue-y.pdf'),fH,300);
% % 
% % %% Wrench Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %     
% %     sH = subplot(size(allYData,2),1,d); hold on;
% %     sH.FontSize = fontSize;
% %     sH.Units = 'normalized';
% %     
% %     rHandForces = allYData{1,d}.rhand_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
% %     
% %     plot(trimTime,rHandForces, 'LineWidth',lineWidth);
% %     hold on;
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
% %     ylabel('Force $[N]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% %     lgd = legend('f_x','f_y','f_z','Interpreter', 'latex',...
% %                  'Location','best','Box','off');
% %     lgd.NumColumns = 3;
% %     lgd.Box = 'off';
% %     title(legendOptions(d), 'FontSize', titleFontSize,...
% %           'Interpreter', 'latex');
% %         
% % end
% % 
% % save2pdf(fullfile(fullPlotFolder, 'wrench-y.pdf'),fH,300);

% % %% 1D Z Plots
% % assistiveZTrajectoryData = load('assistive-z-timed');
% % %opposingZTrajectoryData = load('opposing-z-timed');
% % agnosticZTrajectoryData = load('agnostic-z-timed');
% % 
% % allYData = {assistiveZTrajectoryData agnosticZTrajectoryData};
% % zPlotColors = [colors(3,:);colors(1,:)];
% % legendOptions = {'Assistive Wrench', 'Agnostic Wrench'};
% % fileNameSuffixes = ["Helping", "Agnostic"];
% % 
% % %%Time
% % totalTime = allYData{1,1}.tout;
% % 
% % %% Time indexes
% % startTimeIndex = ceil(size(totalTime,1)*0.1);
% % endTimeIndex = ceil(size(totalTime,1));
% % 
% % %% Trim time
% % trimTime = totalTime(startTimeIndex:endTimeIndex);
% % 
% % %% Reference Trajectory Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %        
% %     Xdesired = allYData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(trimTime,Xdesired(:,3), 'LineWidth',lineWidth,'Color',zPlotColors(d,:));
% %     hold on;
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
% %     ylabel('Z $[m]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Reference 1D Trajectory along Z-axis',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'ReferenceTrajectory-z.pdf'),fH,300);
% % 
% % %% S value Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %        
% %     s = allYData{1,d}.s.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(trimTime,s, 'LineWidth',lineWidth,'Color',zPlotColors(d,:));
% %     hold on;
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
% %     ylabel('$\psi$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Trajectory Free Parameter $\psi$',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'Svalue-z.pdf'),fH,300);
% % 
% % %% Wrench Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %     
% %     sH = subplot(size(allYData,2),1,d); hold on;
% %     sH.FontSize = fontSize;
% %     sH.Units = 'normalized';
% %     
% %     rHandForces = allYData{1,d}.rhand_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
% %     
% %     plot(trimTime,rHandForces, 'LineWidth',lineWidth);
% %     hold on;
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
% %     ylabel('Force $[N]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% %     lgd = legend('f_x','f_y','f_z','Interpreter', 'latex',...
% %                  'Location','best','Box','off');
% %     lgd.NumColumns = 3;
% %     lgd.Box = 'off';
% %     title(legendOptions(d), 'FontSize', titleFontSize,...
% %           'Interpreter', 'latex');
% %         
% % end
% % 
% % save2pdf(fullfile(fullPlotFolder, 'wrench-z.pdf'),fH,300);

% % %% 1D YZ Plots
% % assistiveYZTrajectoryData = load('assistive-yz-timed');
% % %opposingYZTrajectoryData = load('opposing-yz-timed');
% % agnosticYZTrajectoryData = load('agnostic-yz-timed');
% % 
% % allYData = {assistiveYZTrajectoryData agnosticYZTrajectoryData};
% % yzPlotColors = [colors(2,:);colors(3,:);colors(1,:);colors(1,:)];
% % legendOptions = {'Assistive Wrench', 'Agnostic Wrench'};
% % fileNameSuffixes = ["Helping", "Agnostic"];
% % 
% % %%Time
% % totalTime = allYData{1,1}.tout;
% % 
% % %% Time indexes
% % startTimeIndex = ceil(size(totalTime,1)*0.1);
% % endTimeIndex = ceil(size(totalTime,1));
% % 
% % %% Trim time
% % trimTime = totalTime(startTimeIndex:endTimeIndex);
% % 
% % %% Reference Trajectory Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % yLabelOptions = ["Y $[m]$","Z $[m]$"];
% % colorCount = 1;
% % 
% % for d = 1:size(allYData,2)
% %        
% %     Xdesired = allYData{1,d}.Xdesired.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     for i = 1:2
% %         sH = subplot(2,1,i); hold on;
% %         sH.FontSize = fontSize;
% %         sH.Units = 'normalized';
% %     
% %         plot(trimTime,Xdesired(:,1+i), 'LineWidth',lineWidth,'Color',yzPlotColors(colorCount,:));
% %         colorCount = colorCount + 1;
% %         hold on;
% %     
% %         ax = gca;
% %         axis(ax,axisOption);
% %         ax.XGrid = gridOption;
% %         ax.YGrid = gridOption;
% %         ax.XMinorGrid = minorGridOption;
% %         ax.YMinorGrid = minorGridOption;
% %         ax.FontSize = axesFontSize;
% %         ax.LineWidth = axesLineWidth;
% %      
% %         ylabel(yLabelOptions(i), 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %         xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %         
% %         lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% %         lgd.NumColumns = 1;
% %     
% %     end
% %         
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Reference 2D Trajectory along YZ-plane',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'ReferenceTrajectory-yz.pdf'),fH,300);
% % 
% % %% S value Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % yzPlotColors = [colors(4,:);colors(1,:)];
% % 
% % for d = 1:size(allYData,2)
% %        
% %     s = allYData{1,d}.s.signals.values(startTimeIndex:endTimeIndex,:);
% %     
% %     plot(trimTime,s, 'LineWidth',lineWidth,'Color',yzPlotColors(d,:));
% %     hold on;
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
% %     ylabel('$\psi$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% % end
% % 
% % currentFigure = gcf;
% % title(currentFigure.Children(end), 'Trajectory Free Parameter $\psi$',...
% %       'Interpreter', 'latex','FontSize', titleFontSize);
% % lgd = legend(legendOptions,...
% %                  'Location','best','Box','off','FontSize',legendFontSize);
% % 
% % save2pdf(fullfile(fullPlotFolder, 'Svalue-yz.pdf'),fH,300);
% % 
% % %% Wrench Plots
% % fH = figure('units','normalized','outerposition',[0 0 1 1]);
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
% % 
% % for d = 1:size(allYData,2)
% %     
% %     sH = subplot(size(allYData,2),1,d); hold on;
% %     sH.FontSize = fontSize;
% %     sH.Units = 'normalized';
% %     
% %     rHandForces = allYData{1,d}.rhand_wrench.signals.values(startTimeIndex:endTimeIndex,1:3);
% %     
% %     plot(trimTime,rHandForces, 'LineWidth',lineWidth);
% %     hold on;
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
% %     ylabel('Force $[N]$', 'Interpreter', 'latex', 'FontSize', yLabelFontSize);
% %     xlabel('Time $[s]$', 'Interpreter', 'latex', 'FontSize', xLabelFontSize);
% %     
% %     lgd = legend('f_x','f_y','f_z','Interpreter', 'latex',...
% %                  'Location','best','Box','off');
% %     lgd.NumColumns = 3;
% %     lgd.Box = 'off';
% %     title(legendOptions(d), 'FontSize', titleFontSize,...
% %           'Interpreter', 'latex');
% %         
% % end
% % 
% % save2pdf(fullfile(fullPlotFolder, 'wrench-yz.pdf'),fH,300);
% % 
