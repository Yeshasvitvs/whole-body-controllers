clc;
clear;
close all;

plotFolder = '../plots';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

%% configuration parameters
lineWidth = 5;
fontSize = 24;

colors = [0        0.4470   0.7410;
          0.8500   0.3250   0.0980;
          0.9290   0.6940   0.1250;
          0.4940   0.1840   0.5560;
          0.4660   0.6740   0.1880;
          0.3010   0.7450   0.9330];

andyStandupData = analyzeAnDyStandupDataSet('../data/AnDyStandup');

%% CoM Plots with subplots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
CoM_label_dict = ["CoM X [m]","CoM Y [m]","CoM Z [m]"];
for i=1:3
    sH = subplot(3,1,i); hold on;
    sH.FontSize = fontSize;
    sH.Units = 'normalized';
    plotMeanAndSTD(sH, andyStandupData.time, andyStandupData.comErr_statistics_mean(i,:)', andyStandupData.comErr_statistics_confidence(i,:)',lineWidth,colors(i,:));
    ylabel(CoM_label_dict(i));
end
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
annotation('textbox', [0 0.88 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'CoM Error', ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');
           
save2pdf(fullfile(fullPlotFolder, 'ComError.pdf'),fH,600);
           
%% Momentum Eror Plots with subplots
fH = figure('units','normalized','outerposition',[0 0 1 1]);
index = 1;
for i=1:3
    for j=1:2
        sH = subplot(3,2,index); hold on;
        sH.FontSize = fontSize;
        sH.Units = 'normalized';
        plotMeanAndSTD(sH, andyStandupData.time, andyStandupData.Htilde_statistics_mean(i+3*(j-1),:)', andyStandupData.Htilde_statistics_confidence(i+3*(j-1),:)',lineWidth,colors(i+3*(j-1),:));
%         xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
        index = index + 1;
    end
end

annotation('textbox', [0.2 0.88 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'Linear Momentum Error', ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'left');
annotation('textbox', [0.24 0.88 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'Angular Momentum Error', ...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');
annotation('textbox', [0.48 0.025 1 0.1], ...
               'FontSize', fontSize,...
               'String', 'Time [s]', ...
               'EdgeColor', 'none', ...
               'VerticalAlignment', 'bottom');
           
text(-8.5,0.25,'Kg-m/s','Rotation',90,'FontSize',14,...
         'FontSize', fontSize,...
         'HorizontalAlignment', 'center',...
         'VerticalAlignment', 'middle');

text(-0.75,0.25,'kg-m^2/sec','Rotation',90,'FontSize',14,...
         'FontSize', fontSize,...
         'HorizontalAlignment', 'center',...
         'VerticalAlignment', 'middle');

save2pdf(fullfile(fullPlotFolder, 'Htilde.pdf'),fH,600);
     
     

%% CoM Plots without subplots
% % fH = figure;
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% % plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.comMes_statistics_mean', andyStandupData.comMes_statistics_confidence');
% % xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % ylabel('$\mathrm{meters}$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % title('CoM Measured', 'Interpreter', 'latex', 'FontSize', fontSize)
% % 
% % fH = figure;
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% % plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.comDes_statistics_mean', andyStandupData.comDes_statistics_confidence');
% % xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % ylabel('$\mathrm{meters}$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % title('CoM Desired', 'Interpreter', 'latex', 'FontSize', fontSize)
% % 
% % fH = figure;
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% % plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.comErr_statistics_mean', andyStandupData.comErr_statistics_confidence');
% % xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % ylabel('$\mathrm{meters}$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % title('CoM Error', 'Interpreter', 'latex', 'FontSize', fontSize)
% % 
% % %% Momentum Error
% % fH = figure;
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% % plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.Htilde_statistics_mean(1:3,:)', andyStandupData.Htilde_statistics_confidence(1:3,:)');
% % xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
% % ylabel(' ', 'Interpreter', 'latex', 'FontSize', fontSize);
% % title('Momentum Error', 'Interpreter', 'latex', 'FontSize', fontSize)


%% Leg Norm
% % fH = figure;
% % ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% % plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.legPower_statistics_mean', andyStandupData.legPower_statistics_confidence');
% % xlabel('time[s]');
% % ylabel('');
% % title('Leg Power')

% %% Leg Norm
% fH = figure;
% ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize); hold on;
% plotMeanAndSTD(ax, andyStandupData.time, andyStandupData.legTorqueNorm_statistics_mean', andyStandupData.legTorqueNorm_statistics_confidence');
% xlabel('time[s]');
% ylabel('');
% title('Leg Torques Norm')
