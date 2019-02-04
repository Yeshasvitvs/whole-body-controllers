% CONFIGROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
HUMAN_DOF                = 23;
HUMAN_DOF_FOR_SIMULINK   = eye(ROBOT_DOF);

HUMAN_ON_GAZEBO          = true;

% Robot configuration for WBT3.0
HUMAN_WBTConfigRobot           = WBToolbox.Configuration;
HUMAN_WBTConfigRobot.RobotName = 'iCub_0';
HUMAN_WBTConfigRobot.UrdfFile  = 'model.urdf';
HUMAN_WBTConfigRobot.LocalName = 'WBT';

% Controlboards and joints list. Each joint is associated to the corresponding controlboard 
HUMAN_WBTConfigRobot.ControlBoardsNames     = {'torso','left_arm','right_arm','left_leg','right_leg'};
HUMAN_WBTConfigRobot.ControlledJoints       = [];
HUMAN_Config.numOfJointsForEachControlboard = [];

HUMAN_ControlBoards                                        = struct();
HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{1}) = {'torso_pitch','torso_roll','torso_yaw'};
HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{2}) = {'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow'};
HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{3}) = {'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow'};
HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{4}) = {'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll'};
HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{5}) = {'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};

for n = 1:length(HUMAN_WBTConfigRobot.ControlBoardsNames)

    HUMAN_WBTConfigRobot.ControlledJoints       = [HUMAN_WBTConfigRobot.ControlledJoints, ...
                                             HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{n})];
    HUMAN_Config.numOfJointsForEachControlboard = [HUMAN_Config.numOfJointsForEachControlboard; length(HUMAN_ControlBoards.(HUMAN_WBTConfigRobot.ControlBoardsNames{n}))];
end

% Frames list
HUMAN_Frames.BASE              = 'root_link'; 
HUMAN_Frames.LEFT_FOOT         = 'l_sole';
HUMAN_Frames.RIGHT_FOOT        = 'r_sole';
HUMAN_Frames.LEFT_HAND         = 'l_hand_dh_frame';
HUMAN_Frames.RIGHT_HAND        = 'r_hand_dh_frame';