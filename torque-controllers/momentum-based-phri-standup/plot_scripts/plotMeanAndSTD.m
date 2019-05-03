%% To be used for single plots
% % function [ meanHandle, fHandle ] = plotMeanAndSTD( axes_handle, xAxisValues,  meanValues, stdValues )
% % %PLOTMEANANDSTD Summary of this function goes here
% % %   Detailed explanation goes here
% % meanHandle = [];
% % fHandle = [];
% % 
% % for  i = 1 : size(meanValues, 2)
% %     meanHandle = [meanHandle, plot(axes_handle, xAxisValues, meanValues(:,i))];
% %     hold on;
% %     minVals = meanValues(:,i) - stdValues(:,i);
% %     maxVals = meanValues(:,i) + stdValues(:,i);
% % 
% %     ymin = min(minVals);
% %     ymax = max(maxVals);
% %     timeCont = [xAxisValues', fliplr(xAxisValues')];
% %     stdArea = [minVals', fliplr(maxVals')];
% %     fillHandle = fill(timeCont, stdArea', 'b');
% %     fillHandle.FaceColor = meanHandle(i).Color;
% %     fillHandle.FaceAlpha = 0.5;
% %     fillHandle.EdgeAlpha = 0.5;
% %     fHandle = [fHandle, fillHandle];
% %     
% % end
% % 
% % end
% % 
% % 
% % 
% % 
% % 


%% To be used for subplots
function [meanHandle,fHandle] = plotMeanAndSTD(axes_handle, xAxisValues,  meanValues, stdValues, lineWidth, color)

    meanHandle = [];
    fHandle = [];
             
    for  i = 1 : size(meanValues, 2)

        meanHandle = [meanHandle, plot(axes_handle, xAxisValues, meanValues(:,i),'LineWidth',lineWidth)];
        meanHandle.Color = color;
        hold on;
        minVals = meanValues(:,i) - stdValues(:,i);
        maxVals = meanValues(:,i) + stdValues(:,i);
    
        ymin = min(minVals);
        ymax = max(maxVals);
        
        timeCont = [xAxisValues', fliplr(xAxisValues')];
        stdArea = [minVals', fliplr(maxVals')];
        fillHandle = fill(timeCont, stdArea', 'b');
        fillHandle.FaceColor = color;
        fillHandle.FaceAlpha = 0.5;
        fillHandle.EdgeAlpha = 0.5;
        
        fHandle = [fHandle, fillHandle];
    
    end

end