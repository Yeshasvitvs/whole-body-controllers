function offlineJointPositionErrorPlots


    clf;
    close all;
    
    %NOTE: using in evalin is discouraged!
    Qdes = evalin('base','qDesired');
    Qact = evalin('base','qActual');
    Qerr = (Qdes.Data - Qact.Data)*(180/pi);

    figure;
    grid on;
    xlabel('Simulation Step');
    ylabel('Joint Angle Error');
    title('Torso Joints Error'); hold on;
    
    for i = 1:1:3
        plot(Qerr(:,i));
    end
    
    legend('Torso Yaw','Torso Roll','Torso Pitch','Location','NorthEast');
    print('../figures/TorsoJointErrors','-dpng','-r300')
    
    figure;
    grid on;
    xlabel('Simulation Step');
    ylabel('Joint Angle Error');
    title('Right Arm Joints Error'); hold on;
    
    for j = 4:1:4+((size(Qerr,2)-3)/2)
        plot(Qerr(:,j)); 
    end
    
    legend('Shoulder Pitch','Shoulder Roll','Shoulder yaw',...
           'Elbow','Wrist Prosup','Location','NorthEast');
    print('../figures/RightArmJointErrors','-dpng','-r300')
       
    figure;
    grid on;
    xlabel('Simulation Step');
    ylabel('Joint Angle Error');
    title('Left Arm Joints Error'); hold on;
    
    for k = 4+((size(Qerr,2)-3)/2):1:size(Qerr,2)
        plot(Qerr(:,k)); 
    end
    
    legend('Shoulder Pitch','Shoulder Roll','Shoulder yaw',...
           'Elbow','Wrist Prosup','Location','NorthEast');
    print('../figures/LeftArmJointErrors','-dpng','-r300')
end