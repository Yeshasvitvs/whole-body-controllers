% CONFIGROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
ASSISTANT_DOF                = 23;
ASSISTANT_DOF_FOR_SIMULINK   = eye(ROBOT_DOF);

ASSISTANT_ON_GAZEBO          = true;

% Robot configuration for WBT3.0
ASSISTANT_WBTConfigRobot           = WBToolbox.Configuration;
ASSISTANT_WBTConfigRobot.RobotName = 'icub';
ASSISTANT_WBTConfigRobot.UrdfFile  = 'model.urdf';
ASSISTANT_WBTConfigRobot.LocalName = 'WBT';

% Controlboards and joints list. Each joint is associated to the corresponding controlboard
ASSISTANT_WBTConfigRobot.ControlBoardsNames     = {'torso','left_arm','right_arm','left_leg','right_leg'};
ASSISTANT_WBTConfigRobot.ControlledJoints       = [];
ASSISTANT_Config.numOfJointsForEachControlboard = [];

ASSISTANT_ControlBoards                                        = struct();
ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{1}) = {'torso_pitch','torso_roll','torso_yaw'};
ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{2}) = {'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow'};
ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{3}) = {'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow'};
ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{4}) = {'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll'};
ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{5}) = {'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};

for n = 1:length(ASSISTANT_WBTConfigRobot.ControlBoardsNames)

    ASSISTANT_WBTConfigRobot.ControlledJoints       = [ASSISTANT_WBTConfigRobot.ControlledJoints, ...
                                                       ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{n})];
    ASSISTANT_Config.numOfJointsForEachControlboard = [ASSISTANT_Config.numOfJointsForEachControlboard; length(ASSISTANT_ControlBoards.(ASSISTANT_WBTConfigRobot.ControlBoardsNames{n}))];
end

% Frames list
ASSISTANT_Frames.BASE              = 'root_link';
ASSISTANT_Frames.LEFT_FOOT         = 'l_sole';
ASSISTANT_Frames.RIGHT_FOOT        = 'r_sole';
ASSISTANT_Frames.LEFT_HAND         = 'l_hand_dh_frame';
ASSISTANT_Frames.RIGHT_HAND        = 'r_hand_dh_frame';

%% Checking Configuration Success
if ~ASSISTANT_WBTConfigRobot.ValidConfiguration
    return
end

%% comment out human assistance data dump and visualization subsystem
set_param(strcat(model_name,'/Assistant system/Real system/Dump and visualize/Assistant Data/Using Human Assistant/'), 'Commented', 'on');