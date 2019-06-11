% ConfigROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
Config.ON_GAZEBO = true;
Config.WAIT_TIME = 2; %Time to wait before starting tracking

%% External Wrench
Config.EXT_WRENCH_PORT      = '/iCub/applyExternalWrench/rpc:i';
Config.EXT_WRENCH_SMOOTHING = 'smoothing on';
Config.EXT_WRENCH_COMMAND   = 'r_foot 10 0 0 0 0 0 1';

%% Rpc Port
Config.WBD_RPC_PORT         = '/wholeBodyDynamics/rpc';
Config.WBD_CALIB            = 'calibStandingOnOneLink root_link 300';

if(strcmp(Config.PARTS,'single_arm') || strcmp(Config.PARTS,'upper_body'))
    if(strcmp(Config.EE,'r_hand'))
        Ports.EE         = '/wholeBodyDynamics/right_arm/endEffectorWrench:o'; %%Given frames (r_hand,r_hand_dh_frame,root_link)
    elseif(strcmp(Config.EE,'l_hand'))
        Ports.EE         = '/wholeBodyDynamics/left_arm/endEffectorWrench:o'; %%Given frames (l_hand,l_hand_dh_frame,root_link)
    end
elseif(strcmp(Config.PARTS,'lower_body'))
    if(strcmp(Config.EE,'r_foot'))
        Ports.EE         = '/wholeBodyDynamics/right_leg/cartesianEndEffectorWrench:o'; %%Given frames (r_foot,r_sole,root_link)
    elseif(strcmp(Config.EE,'l_foot'))
        Ports.EE         = '/wholeBodyDynamics/left_leg/cartesianEndEffectorWrench:o'; %%Given frames (l_foot,l_sole,root_link)
    end
end

if (Config.TRAJECTORY_TYPE == 0 || Config.TRAJECTORY_TYPE == 1 || Config.TRAJECTORY_TYPE == 2)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.05;
    
    if (strcmp(Config.PARTS,'upper_body') || strcmp(Config.PARTS,'single_arm'))
        
        Config.SDOT_REGULARIZATION = 1e-2;
        Config.WRENCH_REGULARIZATION = 1e-10;
        
    elseif (strcmp(Config.PARTS,'lower_body'))
        
        Config.SDOT_REGULARIZATION = 1e-2;
        Config.WRENCH_REGULARIZATION = 1e-10;
        
    end
    
elseif (Config.TRAJECTORY_TYPE == 3 || Config.TRAJECTORY_TYPE == 4 || Config.TRAJECTORY_TYPE == 5)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.05;
    
    if (strcmp(Config.PARTS,'upper_body') || strcmp(Config.PARTS,'single_arm'))
        
        Config.SDOT_REGULARIZATION = 1e-2;
        Config.WRENCH_REGULARIZATION = 1e-10;
        
    elseif (strcmp(Config.PARTS,'lower_body'))
        
        Config.SDOT_REGULARIZATION = 1e-2;
        Config.WRENCH_REGULARIZATION = 1e-10;
        
    end
        
end


%% Gains
if(strcmp(Config.PARTS,'single_arm'))
    
    ROBOT_DOF                       = 5;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([100,100,100]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-20;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 5;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;
    
    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([30,30,30,30,30]);
    GAINS.POSTURAL.Kd			    = 2;
    
elseif(strcmp(Config.PARTS,'upper_body'))
    
    ROBOT_DOF                       = 13;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([500,500,500]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-20;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 50;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;

    if(strcmp(Config.EE,'r_hand'))
        
        %% Postural task gains
        GAINS.POSTURAL.Kp			    = diag([25,25,25,50,50,50,50,50,50,50,50,50,50]);
        GAINS.POSTURAL.Kd			    = diag([5.0,5.0,5.0,2.75,2.75,2.75,2.75,2.75,2.0,2.0,2.0,2.0,2.0]);
        
    elseif(strcmp(Config.EE,'l_hand'))
        
        %% Postural task gains
        GAINS.POSTURAL.Kp			    = diag([25,25,25,50,50,50,50,50,50,50,50,50,50]);
        GAINS.POSTURAL.Kd			    = diag([5.0,5.0,5.0,2.0,2.0,2.0,2.0,2.0,2.75,2.75,2.75,2.75,2.75]);
        
    end
    
elseif(strcmp(Config.PARTS,'lower_body'))
    
    ROBOT_DOF                       = 6;
    
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([100,100,100])*15;
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-20;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 10*25;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;

    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([50.0,50.0,50.0,50.0,50.0,50.0])*0;
    GAINS.POSTURAL.Kd			    = diag([2.0,2.0,2.0,2.0,2.0,2.0])*0;
    
end

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);
