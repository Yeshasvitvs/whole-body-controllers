% ConfigROBOT initializes parameters specific of a particular robot
%             (e.g., iCubGenova02)
%

%% --- Initialization ---
Config.ON_GAZEBO = false;
Config.WAIT_TIME = 2; %Time to wait before starting tracking

%% WBD Configuration
if(strcmp(Config.PARTS,'single_arm') || strcmp(Config.PARTS,'upper_body'))
    if(strcmp(Config.EE,'r_hand'))
        Ports.EE         = '/wholeBodyDynamics/right_arm/cartesianEndEffectorWrench:o'; %%Given frames (r_hand,r_hand_dh_frame,root_link)
    elseif(strcmp(Config.EE,'l_hand'))
        Ports.EE         = '/wholeBodyDynamics/left_arm/cartesianEndEffectorWrench:o'; %%Given frames (l_hand,l_hand_dh_frame,root_link)
    end
elseif(strcmp(Config.PARTS,'lower_body'))
    if(strcmp(Config.EE,'r_foot'))
        Ports.EE         = '/wholeBodyDynamics/right_foot_ee/cartesianEndEffectorWrench:o'; %%Given frames (r_foot,r_sole,root_link)
    elseif(strcmp(Config.EE,'l_foot'))
        Ports.EE         = '/wholeBodyDynamics/left_foot_ee/cartesianEndEffectorWrench:o'; %%Given frames (l_foot,l_sole,root_link)
    end
end

if (Config.TRAJECTORY_TYPE == 0 || Config.TRAJECTORY_TYPE == 1 || Config.TRAJECTORY_TYPE == 2)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.095;
    
    if (strcmp(Config.PARTS,'upper_body') || strcmp(Config.PARTS,'single_arm'))
        
        Config.SDOT_REGULARIZATION = 1000;
        
    elseif (strcmp(Config.PARTS,'lower_body'))
        
        Config.SDOT_REGULARIZATION = 10;
        
    end
    
elseif (Config.TRAJECTORY_TYPE == 3 || Config.TRAJECTORY_TYPE == 4 || Config.TRAJECTORY_TYPE == 5)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.05;
    
    if (strcmp(Config.PARTS,'upper_body') || strcmp(Config.PARTS,'single_arm'))
        
        Config.SDOT_REGULARIZATION = 1000;
        
    elseif (strcmp(Config.PARTS,'lower_body'))
        
        Config.SDOT_REGULARIZATION = 1000;
        
    end
        
end

%% Gains
if(strcmp(Config.PARTS,'single_arm'))
    
    ROBOT_DOF                       = 5;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = 200;
    GAINS.POSITION.Kd			    = 0*2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-7;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 50;
    GAINS.ORIENTATION.Kd			= 0*2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-7;
    
    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([30,30,30,5,5,5,5,5,5,5,5,5,5]);
    GAINS.POSTURAL.Kd			    = 2;
    
elseif(strcmp(Config.PARTS,'upper_body'))
    
    ROBOT_DOF                       = 13;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([300,100,300]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp)/10;
    GAINS.POSITION.Eps			    = 1e-5;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= diag([600,600,600]);
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp)/10;
    GAINS.ORIENTATION.Eps			= 1e-5;

    if(strcmp(Config.EE,'r_hand'))
        
        %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([30,30,30,5,5,5,5,5,30,30,30,30,30]);
    GAINS.POSTURAL.Kd			    = 2*sqrt(GAINS.POSTURAL.Kp)/10;
        
    elseif(strcmp(Config.EE,'l_hand'))
        
        %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([30,30,30,30,30,30,30,30,5,5,5,5,5]);
    GAINS.POSTURAL.Kd			    = 2*sqrt(GAINS.POSTURAL.Kp)/10;
    end
    
elseif(strcmp(Config.PARTS,'lower_body'))
    
    ROBOT_DOF                       = 6;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([100,100,100])*15;
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp)/2;
    GAINS.POSITION.Eps			    = 1e-5;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 1000;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;

    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([50.0,50.0,50.0,50.0,50.0,50.0]);
    GAINS.POSTURAL.Kd			    = diag([2.0,2.0,2.0,2.0,2.0,2.0]);
    
end

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);
