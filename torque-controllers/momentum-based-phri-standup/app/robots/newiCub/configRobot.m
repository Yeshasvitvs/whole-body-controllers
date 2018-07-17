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

HUMAN_WBTConfigRobot.ControlBoardsNames = {'torso','left_arm','right_arm','left_leg','right_leg'};
HUMAN_WBTConfigRobot.ControlledJoints   = {'torso_pitch','torso_roll','torso_yaw', ...
                                          'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow', ...
                                          'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow', ...
                                          'l_hip_pitch','l_hip_roll','l_hip_yaw','l_knee','l_ankle_pitch','l_ankle_roll', ...
                                          'r_hip_pitch','r_hip_roll','r_hip_yaw','r_knee','r_ankle_pitch','r_ankle_roll'};
% Frames list
HUMAN_Frames.BASE              = 'root_link'; 
HUMAN_Frames.LEFT_FOOT         = 'l_sole';
HUMAN_Frames.RIGHT_FOOT        = 'r_sole';
HUMAN_Frames.LEFT_HAND         = 'l_hand_dh_frame';
HUMAN_Frames.RIGHT_HAND        = 'r_hand_dh_frame';