
if(strcmp(CONFIG.PARTS,'single_arm'))
    ROBOT_DOF                                   = 5;
else
    ROBOT_DOF                                   = 13;
end

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);

%% Position Control Gains
GAINS.POSITION.Kp			    = diag([1000,1000,1000]);
GAINS.POSITION.Kd			    = 2*sqrt(GAINS.POSITION.Kp);
GAINS.POSITION.Eps			    = 1e-20;

%% Orientation Control Gains
GAINS.ORIENTATION.Kp			    = 50;
GAINS.ORIENTATION.Kd			    = 2*sqrt(GAINS.ORIENTATION.Kp);
GAINS.ORIENTATION.Eps			    = 1e-20;

%% Postural Task Gains
GAINS.POSTURAL.Kp			    = diag([100,100,100,30,30,30,30,30,100,100,100,100,100]);
GAINS.POSTURAL.Kd			    = 2;


