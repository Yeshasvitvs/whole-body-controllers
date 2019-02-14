function offlineOrientationErrorPlots

    clf;
    close all;
    
    %NOTE: using evalin is discouraged
    Rdes = evalin('base','rotDesired');
    Ract = evalin('base','rotActual');
    
    for i = 1:1:size(Ract.Data,3)
        
        RPYdes = rotm2euler(Rdes.Data(:,:,i))*(180/pi);
        RPYact = rotm2euler(Ract.Data(:,:,i))*(180/pi);
        
        RPYerr(:,i) = RPYdes - RPYact;
        
    end
    
    figure;
    grid on;
    xlabel('Simulation Step');
    ylabel('Orientation Euler Angles Error');
    title('EE Orientation Error'); hold on;
    
    for i = 1:1:3
        plot(RPYerr(i,:));
    end
    
    legend('Roll','Pitch','Yaw','Location','NorthEast');
    

end