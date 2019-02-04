clc;
clear;
close all;

plotFolder = '../plots';

fullPlotFolder = fullfile(pwd, plotFolder);

if ~exist(fullPlotFolder, 'dir')
   mkdir(fullPlotFolder);
end

global t_critical;

t_critical = [
    12.7062047361747
    4.30265272974946
    3.18244630528371
    2.77644510519779
    2.57058183563632
    2.44691185114497
    2.36462425159278
    2.30600413520417
    2.2621571627982
    2.22813885198627
    2.20098516009164
    2.17881282966723
    2.16036865646279
    2.1447866879178
    2.13144954555978
    2.11990529922125
    2.10981557783332
    2.10092204024104
    2.09302405440831
    2.08596344726586
    2.07961384472768
    2.07387306790403
    2.06865761041905
    2.06389856162802
    2.0595385527533
    2.05552943864287
    2.05183051648029
    2.04840714179524
    2.0452296421327
    2.04227245630124
    2.03951344639641
    2.0369333434601
    2.03451529744934
    2.03224450931772
    2.03010792825034
    2.02809400098045
    2.02619246302911
    2.02439416391197
    ];

%% configuration parameters
lineWidth = 5;
fontSize = 24;

%%TODO: Check how the joint data is used in previous analysis. If it is
%%radians or degrees

soloRobot = analyzeDataSet('../experiments10-Sep-2018','only robot');
helpData = analyzeDataSet('../experiments10-Sep-2018', 'only robot');

fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
claHandle = plotMeanAndSTD(ax, helpData.time, helpData.torques_statistics_mean, helpData.torques_statistics_confidence);
for i = 1 : length(claHandle)
    claHandle(i).LineWidth = lineWidth;
end
grid on;
legend([claHandle], {'Around $x$','Around $y$','Around $z$'}, 'Interpreter', 'latex', 'FontSize', fontSize,  'Location','northoutside','Orientation','horizontal');
ylabel({'L5-S1 Torque $[\mathrm{Nm}]$'}, 'Interpreter', 'latex', 'FontSize', fontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
% ylim([-100, 10]);
set(gca,'FontSize',fontSize)
% xlim([0, helpData.time(end) + 0.05 * helpData.time(end)]);
save2pdf(fullfile(fullPlotFolder, 'effort_human.pdf'),fH,600);

%%Plotting
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
soloMeanHandle = plotMeanAndSTD(ax, soloRobot.time, soloRobot.effort_statistics_mean', soloRobot.effort_statistics_confidence');
soloMeanHandle.LineWidth = lineWidth;
hold on;
helpMeanHandle = plotMeanAndSTD(ax, helpData.time, helpData.effort_statistics_mean', helpData.effort_statistics_confidence');
helpMeanHandle.LineWidth = lineWidth;
grid on;
legend([soloMeanHandle, helpMeanHandle], {'No Assistance','Human Assistance'}, 'Interpreter', 'latex', 'FontSize', fontSize,  'Location','northoutside','Orientation','horizontal');
ylabel({'Robot torques norm $[\mathrm{Nm}]$'}, 'Interpreter', 'latex', 'FontSize', fontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
set(gca,'FontSize',fontSize);
maxTime = max([soloRobot.time(end), helpData.time(end)]);
xlim([0, maxTime + 0.05 * maxTime]);
% ylim(yaxislim);
save2pdf(fullfile(fullPlotFolder, 'effort.pdf'),fH,600);

% plot of lyapunov functions
fH = figure;
ax = axes('Units', 'normalized', 'Parent',fH, 'FontSize', fontSize);
soloMeanHandle = plotMeanAndSTD(ax, soloRobot.time, soloRobot.LyapunovV_statistics_mean', soloRobot.LyapunovV_statistics_confidence');
soloMeanHandle.LineWidth = lineWidth;
hold on;
helpMeanHandle = plotMeanAndSTD(ax, helpData.time, helpData.LyapunovV_statistics_mean', helpData.LyapunovV_statistics_confidence');
helpMeanHandle.LineWidth = lineWidth;
grid on;
legend([soloMeanHandle, helpMeanHandle], {'No assistance','Human Assistance'}, 'Interpreter', 'latex', 'FontSize', fontSize,  'Location','northoutside','Orientation','horizontal');
ylabel({'Lyapunov Function'}, 'Interpreter', 'latex', 'FontSize', fontSize);
xlabel('time $[\mathrm{s}]$', 'Interpreter', 'latex', 'FontSize', fontSize);
set(gca,'FontSize',fontSize);
% maxTime = max([soloRobot.time(end), helpData.time(end)]);
% xlim([0, 6]);
save2pdf(fullfile(fullPlotFolder, 'lyapunov.pdf'),fH,600);

function allData = analyzeDataSet(dataSetFolder, name, pattern)
 % t_student value for 0.95 confidence interval
global t_critical;

timeTolerance = 0.2;

if ~exist('pattern', 'var')
    pattern = '*';
else
    pattern = strcat('*', pattern, '*');
end

filePattern = fullfile(dataSetFolder, sprintf('**/%s.mat', pattern));
files = dir(filePattern);

% variable initialization
time = []; %%Time variable which is loaded with the data stored in the workspace

% robot variables
allData = struct;
comX_data = [];
comY_data = [];
comZ_data = [];

legNorm_data  = [];
legPower_data = [];
effort_data   = [];

V_data = []; %%Lyapunov function

% human variables
humanJoint_data = [];
humanJointVel_data = [];
humanJoint1Torque_data = [];
humanJoint2Torque_data = [];
humanJoint3Torque_data = [];
humanJointTorque_data = [];

for fIdx = 1 : length(files)
    data = load(fullfile(files(fIdx).folder, files(fIdx).name));

    currentTime = data.tauMeasuredData.time; %%This is a column vector storing time from simulink
    state = data.comData.signals(4).values; %%States at each time step for each trail
    
    state2StartIndex = find(state == 2,1); %%Collect the indexes for the states
    % state4StartIndex = find(state == 4,1);
    state4StartIndex = find(state == 4,1);
    
    state2StartTime = currentTime(state2StartIndex); %%Collect the time corresponding to the indexes of the states
    state4StartTime = currentTime(state4StartIndex);
    
    endTimeIndex = find(currentTime > state4StartTime + 3.5,1); %%Index of the time step 3.5 seconds beyond state 4
    if isempty(endTimeIndex)
        endTimeIndex = length(currentTime); %%If the time is not beyond 3.5 seconds of the state 4 get the index of the last time step
    end
    
    currentCoMData = squeeze(data.comData.signals(1).values(:,:,state2StartIndex:endTimeIndex)); %%CoM data at each time step during the trial
    currentLeftLegTorque = data.tauMeasuredData.signals(4).values(state2StartIndex:endTimeIndex,:); %%Legs torque data at each time step during the trial
    currentRightLegTorque = data.tauMeasuredData.signals(5).values(state2StartIndex:endTimeIndex,:);
    currentLeftLegJointsVelocity = data.jointVelocitiesData.signals(4).values(state2StartIndex:endTimeIndex,:); %%Legs joints velocity data at each time step during the trial
    currentRightJointsVelocity = data.jointVelocitiesData.signals(5).values(state2StartIndex:endTimeIndex,:);
    currentV = data.V_lyap.signals(1).values(state2StartIndex:endTimeIndex,:); %%Lyapunov function scalar value at each time step during the trial
    currentAllTorques = [data.tauMeasuredData.signals(1).values(state2StartIndex:endTimeIndex, :), ...
                         data.tauMeasuredData.signals(2).values(state2StartIndex:endTimeIndex, :), ...
                         data.tauMeasuredData.signals(3).values(state2StartIndex:endTimeIndex, :), ...
                         data.tauMeasuredData.signals(4).values(state2StartIndex:endTimeIndex, :), ...
                         data.tauMeasuredData.signals(5).values(state2StartIndex:endTimeIndex, :)];
    
    currentLegTorqueNorm = zeros(1, size(currentRightLegTorque, 1)); %%Variable to store the leg torque norm values
    for i = 1 : size(currentRightLegTorque, 1)
        currentLegTorqueNorm(i) = norm([currentLeftLegTorque(i,:), currentRightLegTorque(i,:)]);
    end
    
    currentLegPower = zeros(1, size(currentRightLegTorque, 1)); %%Variable to store the leg power values
    for i = 1 : size(currentRightLegTorque, 1)
        currentLegPower(i) =  [currentLeftLegTorque(i,:), currentRightLegTorque(i,:)] *  [currentLeftLegTorque(i,:), currentRightLegTorque(i,:)]';
    end
    
    currentAllEffort = zeros(1, size(currentAllTorques, 1)); %%Variable to store the joint effort values
    for i = 1 : size(currentAllTorques, 1)
        currentAllEffort(i) = sqrt(currentAllTorques(i,:) * currentAllTorques(i,:)');
    end
    
    
    % each human joint has 3 DoFs so this is a structure of cells
    % containing joint data with each cells containing 3 DoF values
    joint_index = 1; %%NOTE: This is the joint index according to the variables stored in matlab workspace
    currentHumanJointTorquesData = data.human_jointTorquesData.signals(1).values(state2StartIndex:endTimeIndex,:)'; %% This dimension is 3 x time

    allData.initialTimeOffsetMatlab = currentTime(state2StartIndex); %%Get the time value corresponding to the first index of state2
    
    currentTime = currentTime - repmat(currentTime(state2StartIndex), size(currentTime)); %%Correct the time with the time corresponding to the beginning of state2 as 0 time
    if (isempty(time) || length(currentTime(state2StartIndex:endTimeIndex)) == length(time))
        % sizes match!
        time = currentTime(state2StartIndex:endTimeIndex); %%Getting the time duration of the standup phase from state2 to state4 with start value at zero
        comX_data = [comX_data; currentCoMData(1,:)]; %%Concatenate the values across all the trials
        comY_data = [comY_data; currentCoMData(2,:)];
        comZ_data = [comZ_data; currentCoMData(3,:)];
        
        legNorm_data = [legNorm_data; currentLegTorqueNorm];
        legPower_data = [legPower_data; currentLegPower];
        V_data = [V_data; currentV'];
        
        effort_data = [effort_data; currentAllEffort];

        humanJoint1Torque_data = [humanJoint1Torque_data; currentHumanJointTorquesData(1,:)];
        humanJoint2Torque_data = [humanJoint2Torque_data; currentHumanJointTorquesData(2,:)];
        humanJoint3Torque_data = [humanJoint3Torque_data; currentHumanJointTorquesData(3,:)];

    else
        % check that time length is inside a tolerance value (why?)
        if abs(length(currentTime(state2StartIndex:endTimeIndex)) - length(time)) > length(currentTime(state2StartIndex: endTimeIndex)) * timeTolerance
            warning('Skipping dataset %s as dataset length is outside of specified tolerance.\n Expected length %d. Current length %d. Tolerance %.2f%%', ...
                files(fIdx).name, length(time), length(currentTime(state2StartIndex:endTimeIndex)), timeTolerance * 100);
            % %         continue;
        end
        
        % adapt time & data
        if length(currentTime(state2StartIndex:endTimeIndex)) < length(time)
            %two cases: if currentTime has less sample, append NaN to the
            %current CoM data.
            comX_data = [comX_data; [currentCoMData(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            comY_data = [comY_data; [currentCoMData(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            comZ_data = [comZ_data; [currentCoMData(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];

            legNorm_data = [legNorm_data; [currentLegTorqueNorm, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            legPower_data = [legPower_data; [currentLegPower, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];

            V_data = [V_data; [currentV', NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            effort_data = [effort_data; [currentAllEffort, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            
            % NOTE: The way NaN is concatenated here is different from the
            % above variables
            humanJoint1Torque_data = [humanJoint1Torque_data; [currentHumanJointTorquesData(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            humanJoint2Torque_data = [humanJoint2Torque_data; [currentHumanJointTorquesData(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            humanJoint3Torque_data = [humanJoint3Torque_data; [currentHumanJointTorquesData(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
            
        else
            % new data has more samples. Append the new time
            newSamples = length(currentTime(state2StartIndex:endTimeIndex)) - length(time);
            time((end+1):(end+newSamples)) = currentTime((endTimeIndex-newSamples+1):endTimeIndex);
            
            comX_data(:, end + 1 : end + newSamples) = NaN(size(comX_data, 1), newSamples);
            comY_data(:, end + 1 : end + newSamples) = NaN(size(comY_data, 1), newSamples);
            comZ_data(:, end + 1 : end + newSamples) = NaN(size(comZ_data, 1), newSamples);
            
            legNorm_data(:, end + 1 : end + newSamples) = NaN(size(legNorm_data, 1), newSamples);
            legPower_data(:, end + 1 : end + newSamples) = NaN(size(legPower_data, 1), newSamples);
            
            V_data(:, end + 1 : end + newSamples) = NaN(size(V_data, 1), newSamples);
            effort_data(:, end + 1 : end + newSamples) = NaN(size(effort_data, 1), newSamples);

            humanJoint1Torque_data(:, end + 1 : end + newSamples) = NaN(size(humanJoint1Torque_data, 1), newSamples);
            humanJoint2Torque_data(:, end + 1 : end + newSamples) = NaN(size(humanJoint2Torque_data, 1), newSamples);
            humanJoint3Torque_data(:, end + 1 : end + newSamples) = NaN(size(humanJoint3Torque_data, 1), newSamples);
            
            comX_data(end + 1, :) = currentCoMData(1,:);
            comY_data(end + 1, :) = currentCoMData(2,:);
            comZ_data(end + 1, :) = currentCoMData(3,:);
            
            legNorm_data(end + 1, :) = currentLegTorqueNorm;
            legPower_data(end + 1, :) = currentLegPower;
            
            V_data(end + 1, :) = currentV';
            effort_data(end + 1, :) = currentAllEffort;
            
            humanJoint1Torque_data(end + 1, :) = currentHumanJointTorquesData(1,:);
            humanJoint2Torque_data(end + 1, :) = currentHumanJointTorquesData(2,:);
            humanJoint3Torque_data(end + 1, :) = currentHumanJointTorquesData(3,:);
        end
        
    end
    
end

% compute mean and std of CoM data
com_statistics_mean = [
    mean(comX_data, 1, 'omitnan');
    mean(comY_data, 1, 'omitnan');
    mean(comZ_data, 1, 'omitnan')
    ];

com_statistics_std = [
    std(comX_data, 1, 'omitnan');
    std(comY_data, 1, 'omitnan');
    std(comZ_data, 1, 'omitnan')
    ];

legTorqueNorm_statistics_mean = mean(legNorm_data, 1, 'omitnan');
legTorqueNorm_statistics_std = std(legNorm_data, 1, 'omitnan');

legPower_statistics_mean = mean(legPower_data, 1, 'omitnan');
legPower_statistics_std = std(legPower_data, 1, 'omitnan');

% integrate effort over time
avg_effort = trapz(time,legPower_statistics_mean');

LyapunovV_statistics_mean = mean(V_data, 1, 'omitnan');
LyapunovV_statistics_std = std(V_data, 1, 'omitnan');


allEffort_statistics_mean = mean(effort_data, 1, 'omitnan');
allEffort_statistics_std = std(effort_data, 1, 'omitnan');

humanJointTorque_data(:, :, 1) = humanJoint1Torque_data;
humanJointTorque_data(:, :, 2) = humanJoint2Torque_data;
humanJointTorque_data(:, :, 3) = humanJoint3Torque_data;

dataSize = size(comX_data, 1); %%Size for the data from all the trials
t_student_param = t_critical(dataSize - 1);
com_statistics_confidence = (com_statistics_std * t_student_param)./ sqrt(dataSize); %This is t-distribution for confidence interval
legTorqueNorm_statistics_confidence = (legTorqueNorm_statistics_std * t_student_param)./ sqrt(dataSize);
legPower_statistics_confidence = (legPower_statistics_std * t_student_param)./ sqrt(dataSize);
LyapunovV_confidence = (LyapunovV_statistics_std * t_student_param)./ sqrt(dataSize);
allEffort_confidence = (allEffort_statistics_std * t_student_param)./ sqrt(dataSize);

allData.comX_data = comX_data;
allData.comY_data = comY_data;
allData.comZ_data = comZ_data;
allData.legNorm_data = legNorm_data;
allData.legPower_data = legPower_data;
allData.time = time;
allData.V_data = V_data;

allData.com_statistics_mean = com_statistics_mean;
allData.com_statistics_std = com_statistics_std;
allData.legTorqueNorm_statistics_mean = legTorqueNorm_statistics_mean;
allData.legTorqueNorm_statistics_std = legTorqueNorm_statistics_std;
allData.legPower_statistics_mean = legPower_statistics_mean;
allData.legPower_statistics_std = legPower_statistics_std;
allData.avg_effort = avg_effort;
allData.LyapunovV_statistics_mean = LyapunovV_statistics_mean;
allData.LyapunovV_statistics_std = LyapunovV_statistics_std;
allData.effort_statistics_mean = allEffort_statistics_mean;
allData.effort_statistics_std = allEffort_statistics_std;


allData.com_statistics_confidence = com_statistics_confidence;
allData.legTorqueNorm_statistics_confidence = legTorqueNorm_statistics_confidence;
allData.legPower_statistics_confidence = legPower_statistics_confidence;
allData.LyapunovV_statistics_confidence = LyapunovV_confidence;
allData.effort_statistics_confidence = allEffort_confidence;

allData.torques_statistics_mean = squeeze(mean(humanJointTorque_data, 1, 'omitnan'));
size(allData.torques_statistics_mean);
allData.torques_statistics_std = squeeze(std(humanJointTorque_data, 1, 'omitnan'));
allData.torques_statistics_confidence = (allData.torques_statistics_std .* t_student_param)./ sqrt(size(humanJointTorque_data, 1));

end