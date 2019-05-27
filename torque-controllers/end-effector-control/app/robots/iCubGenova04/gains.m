% ConfigROBOT initializes parameters specific of a particular robot
%             (e.g., iCubGenova02)
%

%% --- Initialization ---
Config.ON_GAZEBO = false;
Config.WAIT_TIME = 2; %Time to wait before starting tracking

%% WBD Configuration
Frames.LEFT_HAND         = 'l_hand';
Frames.RIGHT_HAND        = 'r_hand';
Ports.RIGHT_ARM        = '/wholeBodyDynamics/right_arm/cartesianEndEffectorWrench:o';
Ports.LEFT_ARM         = '/wholeBodyDynamics/left_arm/cartesianEndEffectorWrench:o';

if (Config.TRAJECTORY_TYPE == 1 || Config.TRAJECTORY_TYPE == 2)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.1;
    Config.SDOT_REGULARIZATION = 10000000;
    
elseif (Config.TRAJECTORY_TYPE == 3)
    
    Config.FREQUENCY = 0.1;
    Config.AMPLITUDE = -0.05;
    Config.SDOT_REGULARIZATION = 10000000;
    
end

if(strcmp(Config.PARTS,'single_arm'))
    ROBOT_DOF                                   = 5;
else
    ROBOT_DOF                                   = 13;
end

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);

%% Gains
if(strcmp(Config.PARTS,'single_arm'))
    
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
else
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([300,100,300]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp)/10;
    GAINS.POSITION.Eps			    = 1e-5;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= diag([600,600,600]);
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp)/10;
    GAINS.ORIENTATION.Eps			= 1e-5;

    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([30,30,30,5,5,5,5,5,30,30,30,30,30]);
    GAINS.POSTURAL.Kd			    = 2*sqrt(GAINS.POSTURAL.Kp)/10;
end


