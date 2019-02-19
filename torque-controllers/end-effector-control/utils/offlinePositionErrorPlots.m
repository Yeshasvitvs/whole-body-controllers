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
                  Xdes.signals.values(1,1),...
                  Xdes.signals.values(1,1),...
                  Xdes.signals.values(1,1));

        addpoints(curve_actual_position,...
                  Xact.signals.values(1,1),...
                  Xact.signals.values(1,1),...
                  Xact.signals.values(1,1));

        drawnow;

    else

        plot3(Xdes.signals.values(:,1),...
              Xdes.signals.values(:,2),...
              Xdes.signals.values(:,3),'r');
        plot3(Xact.signals.values(:,1),...
              Xact.signals.values(:,2),...
              Xact.signals.values(:,3),'b');
        
        plot3(Xdes.signals.values(end,1),...
              Xdes.signals.values(end,2),...
              Xdes.signals.values(end,3),'r*');
        plot3(Xact.signals.values(end,1),...
              Xact.signals.values(end,2),...
              Xact.signals.values(end,3),'bo');

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
                      Xdes.signals.values(i,1),...
                      Xdes.signals.values(i,2),...
                      Xdes.signals.values(i,3));

            addpoints(curve_actual_position,...
                      Xact.signals.values(i,1),...
                      Xact.signals.values(i,2),...
                      Xact.signals.values(i,3));

            addpoints(curve_desired_position_marker,...
                      Xdes.signals.values(i,1),...
                      Xdes.signals.values(i,2),...
                      Xdes.signals.values(i,3));

            addpoints(curve_actual_position_marker,...
                      Xact.signals.values(i,1),...
                      Xact.signals.values(i,2),...
                      Xact.signals.values(i,3));

            figure(2);

            addpoints(curve_position_error,...
                      Xact.signals.values(i,1)-Xdes.signals.values(i,1),...
                      Xact.signals.values(i,2)-Xdes.signals.values(i,2),...
                      Xact.signals.values(i,3)-Xdes.signals.values(i,3));


            addpoints(curve_position_error_marker,...
                      Xact.signals.values(i,1)-Xdes.signals.values(i,1),...
                      Xact.signals.values(i,2)-Xdes.signals.values(i,2),...
                      Xact.signals.values(i,3)-Xdes.signals.values(i,3));


            drawnow;

            clearpoints(curve_desired_position_marker);
            clearpoints(curve_actual_position_marker);

            clearpoints(curve_position_error_marker);

        end

    else

        plot3(Xact.signals.values(:,1)-Xdes.signals.values(:,1),...
              Xact.signals.values(:,2)-Xdes.signals.values(:,2),...
              Xact.signals.values(:,3)-Xdes.signals.values(:,3),'k');
        
        plot3(Xact.signals.values(end,1) -Xdes.signals.values(end,1) ,...
              Xact.signals.values(end,2) -Xdes.signals.values(end,2),...
              Xact.signals.values(end,3) -Xdes.signals.values(end,3) ,'r*');
         

    end

end