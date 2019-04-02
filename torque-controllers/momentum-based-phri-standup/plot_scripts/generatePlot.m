clc
clear
close all

%% Config plots
outputDir     = './plots';
lineWidth     = 5;
fontSize      = 40;
fontSize_axis = 40;
fontSize_leg  = 38;

%% ERROR NORM
experiments = dir('*.mat');

n_exp       = size(experiments,1);

time             = 0:0.01:45;
tEnd             = 45;
t_plot           = 0:0.01:(tEnd-25);
time_index_init  = sum(time<25);
time_index_final = sum(time<=tEnd);
errorNormMatrix  = zeros(n_exp,length(25:0.01:tEnd));

for k = 1:n_exp
    
    data_i_name = experiments(k).name;
    
    load(data_i_name);
    
    errorNormMatrix(k,:) = taskRotErrNorm_SCOPE.signals.values(time_index_init+1:time_index_final)';
end
    

avg_old = sum(errorNormMatrix([1:5,16:20, 26:30],:))/(0.5*n_exp);
avg_new = sum(errorNormMatrix([6:10,11:15, 21:25],:))/(0.5*n_exp);

cov_old     = cov(errorNormMatrix([1:5,16:20, 26:30],:));
cov_vec_old = diag(cov_old); 
cov_new     = cov(errorNormMatrix([6:10,11:15, 21:25],:));
cov_vec_new = diag(cov_new); 

fH    = figure('units','normalized','outerposition',[0 0 1 1]);
axes1 = axes('Parent',fH,'FontSize',fontSize_axis);
              box(axes1,'on');
              hold(axes1,'on');
              grid on;

plot(t_plot, avg_old,'r','lineWidth',lineWidth);
hold on 
plot(t_plot, avg_new,'b','lineWidth',lineWidth);

shadedErrorBar(t_plot,avg_old,sqrt(cov_vec_old)/sqrt((0.5*n_exp)),'r',1.5); 
shadedErrorBar(t_plot,avg_new,sqrt(cov_vec_new)/sqrt((0.5*n_exp)),'b',1.5);

xlabel('Time [s]','HorizontalAlignment','center',...
       'FontWeight','bold',...
       'FontSize',fontSize,...
       'Interpreter','latex');
   
ylabel('$||$ rot error $||$ [deg]','HorizontalAlignment','center',...
       'FontWeight','bold',...
       'FontSize',fontSize,...
       'Interpreter','latex');

title ('Performances Comparison');
grid on;

% legend 
leg = legend({'IEEE-RAL control','Task-based control'},'Location','northeast');
set(leg,'Interpreter','latex', ...
        'Orientation','vertical');

set(leg,'FontSize',fontSize_leg);
legend boxoff;

save2pdf(fullfile(outputDir, 'errorNorm.pdf'),fH,600);