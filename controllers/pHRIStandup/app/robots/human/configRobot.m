% CONFIGROBOT initializes parameters specific of a particular robot
%             (e.g., icuGazeboSim)
%

%% --- Initialization ---
HUMAN_DOF                = 66;
HUMAN_DOF_FOR_SIMULINK   = eye(HUMAN_DOF);

% Robot configuration for WBT3.0
HUMAN_WBTConfigRobot           = WBToolbox.Configuration;
HUMAN_WBTConfigRobot.RobotName = 'human';
HUMAN_WBTConfigRobot.UrdfFile  = 'Claudia66DoF.urdf';
HUMAN_WBTConfigRobot.LocalName = 'HUMAN_WBT';

head                    =    {'jC1Head_rotx','jC1Head_roty','jC1Head_rotz'};
neck                    =    {'jT1C7_rotx','jT1C7_roty','jT1C7_rotz'};

torso_1                 =    {'jT9T8_rotx','jT9T8_roty','jT9T8_rotz'};
torso_2                 =    {'jL1T12_rotx','jL1T12_roty','jL1T12_rotz'};
torso_3                 =    {'jL4L3_rotx','jL4L3_roty','jL4L3_rotz'};
torso_4                 =    {'jL5S1_rotx','jL5S1_roty','jL5S1_rotz'};

left_shoulder_internal  =    {'jLeftC7Shoulder_rotx','jLeftC7Shoulder_roty','jLeftC7Shoulder_rotz'};
left_shoulder           =    {'jLeftShoulder_rotx','jLeftShoulder_roty','jLeftShoulder_rotz'};
left_elbow              =    {'jLeftElbow_rotx','jLeftElbow_roty','jLeftElbow_rotz'};
left_wrist              =    {'jLeftWrist_rotx','jLeftWrist_roty','jLeftWrist_rotz'};

right_shoulder_internal =    {'jRightC7Shoulder_rotx','jRightC7Shoulder_roty','jRightC7Shoulder_rotz'};
right_shoulder          =    {'jRightShoulder_rotx','jRightShoulder_roty','jRightShoulder_rotz'};
right_elbow             =    {'jRightElbow_rotx','jRightElbow_roty','jRightElbow_rotz'};
right_wrist             =    {'jRightWrist_rotx','jRightWrist_roty','jRightWrist_rotz'};

left_hip                =    {'jLeftHip_rotx','jLeftHip_roty','jLeftHip_rotz'};
left_knee               =    {'jLeftKnee_rotx','jLeftKnee_roty','jLeftKnee_rotz'};
left_ankle               =   {'jLeftAnkle_rotx','jLeftAnkle_roty','jLeftAnkle_rotz'};
left_ball_foot          =    {'jLeftBallFoot_rotx','jLeftBallFoot_roty','jLeftBallFoot_rotz'};

right_hip               =    {'jRightHip_rotx','jRightHip_roty','jRightHip_rotz'};
right_knee              =    {'jRightKnee_rotx','jRightKnee_roty','jRightKnee_rotz'};
right_ankle             =    {'jRightAnkle_rotx','jRightAnkle_roty','jRightAnkle_rotz'};
right_ball_foot         =    {'jRightBallFoot_rotx','jRightBallFoot_roty','jRightBallFoot_rotz'};


HUMAN_WBTConfigRobot.ControlBoardsNames = {'hde-readonly-controlboard-driver'};
HUMAN_WBTConfigRobot.ControlledJoints         =  {...
                                                     head{:},...
                                                     torso_2{:},...
                                                     torso_3{:},torso_4{:},...
                                                     left_ankle{:},left_ball_foot{:},...
                                                     left_shoulder_internal{:},...
                                                     left_elbow{:},...
                                                     left_hip{:},left_knee{:},...
                                                     left_shoulder{:},left_wrist{:},...
                                                     right_ankle{:},right_ball_foot{:},...
                                                     right_shoulder_internal{:},...
                                                     right_elbow{:},...
                                                     right_hip{:},right_knee{:},...
                                                     right_shoulder{:},right_wrist{:},...
                                                     neck{:},...
                                                     torso_1{:},...
                                                 };
% Frames list
HUMAN_Frames.BASE              = 'Pelvis'; 
HUMAN_Frames.LEFT_FOOT         = 'LeftFoot';
HUMAN_Frames.RIGHT_FOOT        = 'RightFoot';
HUMAN_Frames.LEFT_HAND         = 'LeftHand';
HUMAN_Frames.RIGHT_HAND        = 'RightHand';
