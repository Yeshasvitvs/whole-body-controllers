% ConfigROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
Config.ON_GAZEBO         = true;
Config.SDOT_REGULARIZATION = 1e-1;
Config.WAIT_TIME = 2; %Time to wait before starting tracking

if(strcmp(Config.PARTS,'single_arm'))
    ROBOT_DOF                                   = 5;
else
    ROBOT_DOF                                   = 13;
end

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);

%% Gains
if(strcmp(Config.PARTS,'single_arm'))
    
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
else
    %% Position control gains
    GAINS.POSITION.Kp			    = diag([500,500,500]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-20;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 50;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;

    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([25,25,25,50,50,50,50,50,50,50,50,50,50]);
    GAINS.POSTURAL.Kd			    = diag([5.0,5.0,5.0,2.75,2.75,2.75,2.75,2.75,2.0,2.0,2.0,2.0,2.0]);
end

