% ConfigROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
Config.ON_GAZEBO         = true;

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
    GAINS.POSITION.Kp			    = diag([1000,1000,1000]);
    GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
    GAINS.POSITION.Eps			    = 1e-20;

    %% Orientation control gains
    GAINS.ORIENTATION.Kp			= 50;
    GAINS.ORIENTATION.Kd			= 2*sqrt(GAINS.ORIENTATION.Kp);
    GAINS.ORIENTATION.Eps			= 1e-20;

    %% Postural task gains
    GAINS.POSTURAL.Kp			    = diag([100,100,100,30,30,30,30,30,100,100,100,100,100]);
    GAINS.POSTURAL.Kd			    = 2;
end

