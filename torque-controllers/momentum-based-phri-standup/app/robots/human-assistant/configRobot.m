% CONFIGROBOT initializes parameters specific of a particular human
%             (e.g., subject01)
%

%% --- Initialization ---
ASSISTANT_DOF                = 66;
ASSISTANT_DOF_FOR_SIMULINK   = eye(ASSISTANT_DOF);

ASSISTANT_ON_GAZEBO          = false;

% Human configuration for WBT3.0
ASSISTANT_WBTConfigRobot           = WBToolbox.Configuration;
ASSISTANT_WBTConfigRobot.UrdfFile  = 'humanSubject03_66dof.urdf';
ASSISTANT_WBTConfigRobot.LocalName = 'ASSISTANT_WBT';

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
left_ankle              =   {'jLeftAnkle_rotx','jLeftAnkle_roty','jLeftAnkle_rotz'};
left_ball_foot          =    {'jLeftBallFoot_rotx','jLeftBallFoot_roty','jLeftBallFoot_rotz'};

right_hip               =    {'jRightHip_rotx','jRightHip_roty','jRightHip_rotz'};
right_knee              =    {'jRightKnee_rotx','jRightKnee_roty','jRightKnee_rotz'};
right_ankle             =    {'jRightAnkle_rotx','jRightAnkle_roty','jRightAnkle_rotz'};
right_ball_foot         =    {'jRightBallFoot_rotx','jRightBallFoot_roty','jRightBallFoot_rotz'};

if (~ASSISTANT_ON_GAZEBO)
    ASSISTANT_WBTConfigRobot.RobotName          = 'Human';
    ASSISTANT_WBTConfigRobot.ControlBoardsNames = {'HumanControlBoard'};
else
    ASSISTANT_WBTConfigRobot.RobotName          = 'sub0';
    ASSISTANT_WBTConfigRobot.ControlBoardsNames = {'head','neck','torso_1','torso_2','torso_3','torso_4',...
                                                   'left_hip','left_knee','left_ankle','left_ball_foot',...
                                                   'right_hip','right_knee','right_ankle','right_ball_foot',...
                                                   'left_shoulder_internal','left_shoulder','left_elbow','left_wrist',...
                                                   'right_shoulder_internal','right_shoulder','right_elbow','right_wrist',...
                                                  };
end

ASSISTANT_WBTConfigRobot.ControlledJoints         =  {torso_4{:},...
                                                      torso_3{:},...
                                                      torso_2{:},...
                                                      torso_1{:},...
                                                      neck{:},...
                                                      head{:},...
                                                      right_shoulder_internal{:},...
                                                      right_shoulder{:},...
                                                      right_elbow{:},...
                                                      right_wrist{:},...
                                                      left_shoulder_internal{:},...
                                                      left_shoulder{:},...
                                                      left_elbow{:},...
                                                      left_wrist{:},...
                                                      right_hip{:},...
                                                      right_knee{:},...
                                                      right_ankle{:},...
                                                      right_ball_foot{:},...
                                                      left_hip{:},...
                                                      left_knee{:},...
                                                      left_ankle{:},...
                                                      left_ball_foot{:},...
                                                     };
% Frames list
ASSISTANT_Frames.BASE              = 'Pelvis';
ASSISTANT_Frames.LEFT_FOOT         = 'LeftFoot';
ASSISTANT_Frames.RIGHT_FOOT        = 'RightFoot';
ASSISTANT_Frames.LEFT_HAND         = 'LeftHand';
ASSISTANT_Frames.RIGHT_HAND        = 'RightHand';

%% Checking Configuration Success
if ~ASSISTANT_WBTConfigRobot.ValidConfiguration
    return
end

%% comment out robot assistance data dump and visualization subsystem
set_param(strcat(model_name,'/Assistant system/Real system/Dump and visualize/Assistant Data/Using Robot Assistant/'), 'Commented', 'on');
set_param(strcat(model_name,'/Assistant system/Real system/Robot Assistant Position Control/'), 'Commented', 'on');
