function allData = analyzeAnDyStandupDataSet(dataSetFolder, timeTolerance, endBufferTime)

    
    global t_critical;

    %% student t-distribution values
    % These are 2 tail t-distribution values computed using
    % https://www.danielsoper.com/statcalc/calculator.aspx?id=10
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

    allData = struct;
    
    time = [];
    
    state2time = [];
    state3time = [];
    state4time = [];
    
    comXMes_data = [];
    comYMes_data = [];
    comZMes_data = [];
    
    comXDes_data = [];
    comYDes_data = [];
    comZDes_data = [];
    
    comXErr_data = [];
    comYErr_data = [];
    comZErr_data = [];
    
    legNorm_data  = [];
    legPower_data = [];
    effort_data   = [];
    V_lyap        = [];
    
    HtildeX_data   = [];
    HtildeY_data   = [];
    HtildeZ_data   = [];
    HtildeR1_data  = [];
    HtildeR2_data  = [];
    HtildeR3_data  = [];
    
    filePattern = fullfile(dataSetFolder, sprintf('*.mat'));
    files = dir(filePattern);
    
    for fIdx = 1 : length(files)
        
        data = load(fullfile(files(fIdx).folder, files(fIdx).name));
        
        currentTime = data.tauMeasuredData.time;
        state = data.comData.signals(4).values;
        
        state2StartIndex = find(state == 2,1);
        state3StartIndex = find(state == 3,1);
        state4StartIndex = find(state == 4,1);
        
        state2StartTime = currentTime(state2StartIndex);
        state3StartTime = currentTime(state3StartIndex);
        state4StartTime = currentTime(state4StartIndex);
        
        state2time = [state2time; state2StartTime];
        state3time = [state3time; state3StartTime];
        state4time = [state4time; state4StartTime];
        
        endTimeIndex = find(currentTime > state4StartTime + endBufferTime,1);
        if isempty(endTimeIndex)
            endTimeIndex = length(currentTime);
        end
        
        currentComMesData = squeeze(data.comData.signals(1).values(:,:,state2StartIndex:endTimeIndex));
        currentComDesData = squeeze(data.comData.signals(2).values(:,:,state2StartIndex:endTimeIndex));
        currentComErrData = squeeze(data.comData.signals(3).values(state2StartIndex:endTimeIndex,:))';

        currentHtilde = data.Htilde.signals(1).values(state2StartIndex:endTimeIndex,:)';
        
        currentLeftLegTorque  =  data.tauMeasuredData.signals(4).values(state2StartIndex:endTimeIndex,:);
        currentRightLegTorque =  data.tauMeasuredData.signals(5).values(state2StartIndex:endTimeIndex,:);
        
        currentAllTorques     = [data.tauMeasuredData.signals(1).values(state2StartIndex:endTimeIndex, :), ...
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
        
        currentV      = data.V_lyap.signals(1).values(state2StartIndex:endTimeIndex,:);
        
        allData.initialTimeOffsetMatlab = currentTime(state2StartIndex);
        
        currentTime = currentTime - repmat(currentTime(state2StartIndex), size(currentTime));
        
        %% When the datasets time match
        if (isempty(time) || length(currentTime(state2StartIndex:endTimeIndex)) == length(time)) 
            
            disp("Time matching")
            time = currentTime(state2StartIndex:endTimeIndex);
            comXMes_data = [comXMes_data; currentComMesData(1,:)];
            comYMes_data = [comYMes_data; currentComMesData(2,:)];
            comZMes_data = [comZMes_data; currentComMesData(3,:)];
            
            comXDes_data = [comXDes_data; currentComDesData(1,:)];
            comYDes_data = [comYDes_data; currentComDesData(2,:)];
            comZDes_data = [comZDes_data; currentComDesData(3,:)];
            
            comXErr_data = [comXErr_data; currentComErrData(1,:)];
            comYErr_data = [comYErr_data; currentComErrData(2,:)];
            comZErr_data = [comZErr_data; currentComErrData(3,:)];
            
            HtildeX_data = [HtildeX_data; currentHtilde(1,:)];
            HtildeY_data = [HtildeY_data; currentHtilde(2,:)];
            HtildeZ_data = [HtildeZ_data; currentHtilde(3,:)];
            HtildeR1_data = [HtildeR1_data; currentHtilde(4,:)];
            HtildeR2_data = [HtildeR2_data; currentHtilde(5,:)];
            HtildeR3_data = [HtildeR3_data; currentHtilde(6,:)];
            
            legNorm_data = [legNorm_data; currentLegTorqueNorm];
            legPower_data = [legPower_data; currentLegPower];
            effort_data = [effort_data; currentAllEffort];
            
            V_lyap = [V_lyap; currentV'];
        
        else
            % check that time length is inside a tolerance value
            if abs(length(currentTime(state2StartIndex : endTimeIndex)) - length(time)) > length(currentTime(state2StartIndex : endTimeIndex)) * timeTolerance
                disp("Skipping dataset")
                warning('Skipping dataset %s as dataset length is outside of specified tolerance.\n Expected length %d. Current length %d. Tolerance %.2f%%', ...
                   files(fIdx).name, length(time), length(currentTime(state2StartIndex : endTimeIndex)), timeTolerance * 100);
                continue;
            end

            disp("Time mismatch")
            %% When the current dataset time is less than before - Add NaN values
            if length(currentTime(state2StartIndex:endTimeIndex)) < length(time)
                disp("Time mismatch - Adding NaN values")
                comXMes_data = [comXMes_data; [currentComMesData(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comYMes_data = [comYMes_data; [currentComMesData(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comZMes_data = [comZMes_data; [currentComMesData(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                
                comXDes_data = [comXDes_data; [currentComDesData(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comYDes_data = [comYDes_data; [currentComDesData(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comZDes_data = [comZDes_data; [currentComDesData(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                
                comXErr_data = [comXErr_data; [currentComErrData(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comYErr_data = [comYErr_data; [currentComErrData(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                comZErr_data = [comZErr_data; [currentComErrData(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                
                HtildeX_data = [HtildeX_data; [currentHtilde(1,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                HtildeY_data = [HtildeY_data; [currentHtilde(2,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                HtildeZ_data = [HtildeZ_data; [currentHtilde(3,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                HtildeR1_data = [HtildeR1_data; [currentHtilde(4,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                HtildeR2_data = [HtildeR2_data; [currentHtilde(5,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                HtildeR3_data = [HtildeR3_data; [currentHtilde(6,:), NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                
                legNorm_data = [legNorm_data; [currentLegTorqueNorm, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                legPower_data = [legPower_data; [currentLegPower, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                effort_data = [effort_data; [currentAllEffort, NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
                
                V_lyap = [V_lyap; [currentV', NaN(1, length(time) - length(currentTime(state2StartIndex:endTimeIndex)))]];
         
            else
                
                %% When the current dataset time is greater than before - Add new samples
                disp("Time mismatch - Adding new samples")
                newSamples = length(currentTime(state2StartIndex:endTimeIndex)) - length(time);
                time((end+1):(end+newSamples)) = currentTime((endTimeIndex-newSamples+1):endTimeIndex);
            
                comXMes_data(:, end + 1 : end + newSamples) = NaN(size(comXMes_data, 1), newSamples);
                comYMes_data(:, end + 1 : end + newSamples) = NaN(size(comYMes_data, 1), newSamples);
                comZMes_data(:, end + 1 : end + newSamples) = NaN(size(comZMes_data, 1), newSamples);
                
                comXDes_data(:, end + 1 : end + newSamples) = NaN(size(comXDes_data, 1), newSamples);
                comYDes_data(:, end + 1 : end + newSamples) = NaN(size(comYDes_data, 1), newSamples);
                comZDes_data(:, end + 1 : end + newSamples) = NaN(size(comZDes_data, 1), newSamples);
                
                comXErr_data(:, end + 1 : end + newSamples) = NaN(size(comXErr_data, 1), newSamples);
                comYErr_data(:, end + 1 : end + newSamples) = NaN(size(comYErr_data, 1), newSamples);
                comZErr_data(:, end + 1 : end + newSamples) = NaN(size(comZErr_data, 1), newSamples);
                
                HtildeX_data(:, end + 1 : end + newSamples) = NaN(size(HtildeX_data, 1), newSamples);
                HtildeY_data(:, end + 1 : end + newSamples) = NaN(size(HtildeY_data, 1), newSamples);
                HtildeZ_data(:, end + 1 : end + newSamples) = NaN(size(HtildeZ_data, 1), newSamples);
                HtildeR1_data(:, end + 1 : end + newSamples) = NaN(size(HtildeR1_data, 1), newSamples);
                HtildeR2_data(:, end + 1 : end + newSamples) = NaN(size(HtildeR2_data, 1), newSamples);
                HtildeR3_data(:, end + 1 : end + newSamples) = NaN(size(HtildeR3_data, 1), newSamples);
                
                legNorm_data(:, end + 1 : end + newSamples) = NaN(size(legNorm_data, 1), newSamples);
                legPower_data(:, end + 1 : end + newSamples) = NaN(size(legPower_data, 1), newSamples);
                effort_data(:, end + 1 : end + newSamples) = NaN(size(effort_data, 1), newSamples);
                
                V_lyap(:, end + 1 : end + newSamples) = NaN(size(V_lyap, 1), newSamples);
                
                comXMes_data(end + 1, :) = currentComMesData(1,:);
                comYMes_data(end + 1, :) = currentComMesData(2,:);
                comZMes_data(end + 1, :) = currentComMesData(3,:);
                
                comXDes_data(end + 1, :) = currentComDesData(1,:);
                comYDes_data(end + 1, :) = currentComDesData(2,:);
                comZDes_data(end + 1, :) = currentComDesData(3,:);
                
                comXErr_data(end + 1, :) = currentComErrData(1,:);
                comYErr_data(end + 1, :) = currentComErrData(2,:);
                comZErr_data(end + 1, :) = currentComErrData(3,:);
                
                HtildeX_data(end + 1, :) = currentHtilde(1,:);
                HtildeY_data(end + 1, :) = currentHtilde(2,:);
                HtildeZ_data(end + 1, :) = currentHtilde(3,:);
                HtildeR1_data(end + 1, :) = currentHtilde(4,:);
                HtildeR2_data(end + 1, :) = currentHtilde(5,:);
                HtildeR3_data(end + 1, :) = currentHtilde(6,:);
                
                legNorm_data(end + 1, :) = currentLegTorqueNorm;
                legPower_data(end + 1, :) = currentLegPower;
                effort_data(end + 1, :) = currentAllEffort;
                
                V_lyap(end + 1, :) = currentV';
                
            end
        end
    end
    
    comMes_statistics_mean = [mean(comXMes_data, 1, 'omitnan');
                              mean(comYMes_data, 1, 'omitnan');
                              mean(comZMes_data, 1, 'omitnan')
                             ];

    comMes_statistics_std = [std(comXMes_data, 1, 'omitnan');
                             std(comYMes_data, 1, 'omitnan');
                             std(comZMes_data, 1, 'omitnan')
                            ];
                        
    comDes_statistics_mean = [mean(comXDes_data, 1, 'omitnan');
                              mean(comYDes_data, 1, 'omitnan');
                              mean(comZDes_data, 1, 'omitnan')
                             ];

    comDes_statistics_std = [std(comXDes_data, 1, 'omitnan');
                             std(comYDes_data, 1, 'omitnan');
                             std(comZDes_data, 1, 'omitnan')
                            ];
                        
    comErr_statistics_mean = [mean(comXErr_data, 1, 'omitnan');
                              mean(comYErr_data, 1, 'omitnan');
                              mean(comZErr_data, 1, 'omitnan')
                             ];

    comErr_statistics_std = [std(comXErr_data, 1, 'omitnan');
                             std(comYErr_data, 1, 'omitnan');
                             std(comZErr_data, 1, 'omitnan')
                            ];
                     
    Htilde_statistics_mean = [mean(HtildeX_data, 1, 'omitnan');
                              mean(HtildeY_data, 1, 'omitnan');
                              mean(HtildeZ_data, 1, 'omitnan');
                              mean(HtildeR1_data, 1, 'omitnan');
                              mean(HtildeR2_data, 1, 'omitnan');
                              mean(HtildeR3_data, 1, 'omitnan')];
                          
    Htilde_statistics_std = [std(HtildeX_data, 1, 'omitnan');
                             std(HtildeY_data, 1, 'omitnan');
                             std(HtildeZ_data, 1, 'omitnan');
                             std(HtildeR1_data, 1, 'omitnan');
                             std(HtildeR2_data, 1, 'omitnan');
                             std(HtildeR3_data, 1, 'omitnan')];
                     
    legTorqueNorm_statistics_mean = mean(legNorm_data, 1, 'omitnan');
    legTorqueNorm_statistics_std = std(legNorm_data, 1, 'omitnan');

    legPower_statistics_mean = mean(legPower_data, 1, 'omitnan');
    legPower_statistics_std = std(legPower_data, 1, 'omitnan');
    
    % integrate effort over time
    avg_effort = trapz(time,legPower_statistics_mean');
    
    allEffort_statistics_mean = mean(effort_data, 1, 'omitnan');
    allEffort_statistics_std = std(effort_data, 1, 'omitnan');
    
    LyapunovV_statistics_mean = mean(V_lyap, 1, 'omitnan');
    LyapunovV_statistics_std = std(V_lyap, 1, 'omitnan');
                     
    dataSize = size(comXMes_data, 1);
    t_student_param = t_critical(dataSize - 1);
    comMes_statistics_confidence = (comMes_statistics_std * t_student_param)./ sqrt(dataSize);
    comDes_statistics_confidence = (comDes_statistics_std * t_student_param)./ sqrt(dataSize);
    comErr_statistics_confidence = (comErr_statistics_std * t_student_param)./ sqrt(dataSize);
    Htilde_statistics_confidence = (Htilde_statistics_std * t_student_param)./ sqrt(dataSize);
    legTorqueNorm_statistics_confidence = (legTorqueNorm_statistics_std * t_student_param)./ sqrt(dataSize);
    legPower_statistics_confidence = (legPower_statistics_std * t_student_param)./ sqrt(dataSize);
    allEffort_confidence = (allEffort_statistics_std * t_student_param)./ sqrt(dataSize);
    LyapunovV_confidence = (LyapunovV_statistics_std * t_student_param)./ sqrt(dataSize);

    allData.time = time;
    
    allData.start2time = state2time;
    allData.start3time = state3time;
    allData.start4time = state4time;
    
    allData.comXMes_data = comXMes_data;
    allData.comYMes_data = comYMes_data;
    allData.comZMes_data = comZMes_data;
    
    allData.comXDes_data = comXDes_data;
    allData.comYDes_data = comYDes_data;
    allData.comZDes_data = comZDes_data;
    
    allData.comXErr_data = comXErr_data;
    allData.comYErr_data = comYErr_data;
    allData.comZErr_data = comZErr_data;
    
    allData.HtildeX_data = HtildeX_data;
    allData.HtildeY_data = HtildeY_data;
    allData.HtildeZ_data = HtildeZ_data;
    allData.HtildeR1_data = HtildeR1_data;
    allData.HtildeR2_data = HtildeR2_data;
    allData.HtildeR3_data = HtildeR3_data;
    
    allData.legNorm_data = legNorm_data;
    allData.legPower_data = legPower_data;
    allData.avg_effort = avg_effort;
    
    allData.comMes_statistics_mean = comMes_statistics_mean;
    allData.comMes_statistics_std = comMes_statistics_std;
    allData.comDes_statistics_mean = comDes_statistics_mean;
    allData.comDes_statistics_std = comDes_statistics_std;
    allData.comErr_statistics_mean = comErr_statistics_mean;
    allData.comErr_statistics_std = comErr_statistics_std;
    allData.Htilde_statistics_mean = Htilde_statistics_mean;
    allData.Htilde_statistics_std = Htilde_statistics_std;
    allData.legTorqueNorm_statistics_mean = legTorqueNorm_statistics_mean;
    allData.legTorqueNorm_statistics_std = legTorqueNorm_statistics_std;
    allData.legPower_statistics_mean = legPower_statistics_mean;
    allData.legPower_statistics_std = legPower_statistics_std;
    allData.effort_statistics_mean = allEffort_statistics_mean;
    allData.effort_statistics_std = allEffort_statistics_std;
    allData.LyapunovV_statistics_mean = LyapunovV_statistics_mean;
    allData.LyapunovV_statistics_std = LyapunovV_statistics_std;
    
    allData.comMes_statistics_confidence = comMes_statistics_confidence;
    allData.comDes_statistics_confidence = comDes_statistics_confidence;
    allData.comErr_statistics_confidence = comErr_statistics_confidence;
    allData.Htilde_statistics_confidence = Htilde_statistics_confidence;
    allData.legTorqueNorm_statistics_confidence = legTorqueNorm_statistics_confidence;
    allData.legPower_statistics_confidence = legPower_statistics_confidence;
    allData.effort_statistics_confidence = allEffort_confidence;
    allData.LyapunovV_statistics_confidence = LyapunovV_confidence;
    
end