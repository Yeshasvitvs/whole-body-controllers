function offlinePositionErrorPlots

    clf;
    close all;

    animated_plot = false;

    %NOTE: using in evalin is discouraged!
    Xdes = evalin('base', 'Xdesired');
    Xact = evalin('base', 'Xactual');

    figure;
    view(90,0); hold on;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title('EE Position'); hold on;

    if(animated_plot)

        curve_desired_position = animatedline('Color','r','LineWidth',1);
        curve_actual_position  = animatedline('Color','b','LineWidth',1);

        curve_desired_position_marker = animatedline('Color','r','LineWidth',1,'Marker','*');
        curve_actual_position_marker  = animatedline('Color','b','LineWidth',1,'Marker','o');
        
        addpoints(curve_desired_position,...
                  Xdes.signal1.Data(1,1),...
                  Xdes.signal2.Data(1,1),...
                  Xdes.signal3.Data(1,1));

        addpoints(curve_actual_position,...
                  Xact.signal1.Data(1,1),...
                  Xact.signal2.Data(1,1),...
                  Xact.signal3.Data(1,1));

        drawnow;

    else

        plot3(Xdes.signal1.Data,Xdes.signal2.Data,Xdes.signal3.Data,'r');
        plot3(Xact.signal1.Data,Xact.signal2.Data,Xact.signal3.Data,'b');
        
        plot3(Xdes.signal1.Data(end,1),Xdes.signal2.Data(end,1),Xdes.signal3.Data(end,1),'r*');
        plot3(Xact.signal1.Data(end,1),Xact.signal2.Data(end,1),Xact.signal3.Data(end,1),'bo');

    end


    legend('Desired Position','Actual Position','Location','NorthWest');

    figure;
    view(90,0); hold on;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title('EE Position Error'); hold on;
    axis([-0.2 0.2 -0.2 0.2 -0.2 0.2]);

    if(animated_plot)

        curve_position_error = animatedline('LineWidth',1);
        curve_position_error_marker = animatedline('Color','r','LineWidth',1,'Marker','*');

        for i = 2:1:size(Xdes.signal1.Data,1)

            figure(1);
            addpoints(curve_desired_position,...
                      Xdes.signal1.Data(i,1),...
                      Xdes.signal2.Data(i,1),...
                      Xdes.signal3.Data(i,1));

            addpoints(curve_actual_position,...
                      Xact.signal1.Data(i,1),...
                      Xact.signal2.Data(i,1),...
                      Xact.signal3.Data(i,1));

            addpoints(curve_desired_position_marker,...
                      Xdes.signal1.Data(i,1),...
                      Xdes.signal2.Data(i,1),...
                      Xdes.signal3.Data(i,1));

            addpoints(curve_actual_position_marker,...
                      Xact.signal1.Data(i,1),...
                      Xact.signal2.Data(i,1),...
                      Xact.signal3.Data(i,1));

            figure(2);

            addpoints(curve_position_error,...
                      Xact.signal1.Data(i,1)-Xdes.signal1.Data(i,1),...
                      Xact.signal2.Data(i,1)-Xdes.signal2.Data(i,1),...
                      Xact.signal3.Data(i,1)-Xdes.signal3.Data(i,1));


            addpoints(curve_position_error_marker,...
                      Xact.signal1.Data(i,1)-Xdes.signal1.Data(i,1),...
                      Xact.signal2.Data(i,1)-Xdes.signal2.Data(i,1),...
                      Xact.signal3.Data(i,1)-Xdes.signal3.Data(i,1));


            drawnow;

            clearpoints(curve_desired_position_marker);
            clearpoints(curve_actual_position_marker);

            clearpoints(curve_position_error_marker);

        end

    else

        plot3(Xact.signal1.Data-Xdes.signal1.Data,...
              Xact.signal2.Data-Xdes.signal2.Data,...
              Xact.signal3.Data-Xdes.signal3.Data,'k');
        
        plot3(Xact.signal1.Data(end,1) -Xdes.signal1.Data(end,1) ,...
              Xact.signal2.Data(end,1) -Xdes.signal2.Data(end,1),...
              Xact.signal3.Data(end,1) -Xdes.signal3.Data(end,1) ,'r*');
         

    end

end