%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * @author: Yeshasvi Tirupachuri
%  * Permission is granted to copy, distribute, and/or modify this program
%  * under the terms of the GNU General Public License, version 2 or any
%  * later version published by the Free Software Foundation.
%  *
%  * A copy of the license can be found at
%  * http://www.robotcub.org/icub/license/gpl.txt
%  *
%  * This program is distributed in the hope that it will be useful, but
%  * WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
%  * Public License for more details
%  */
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; 
clc;

%% GENERAL SIMULATION INFO
% If you are simulating the robot with Gazebo, 
% remember that you have to launch Gazebo as follow:
% 
% gazebo -slibgazebo_yarp_clock.so
% 
% and set the environmental variable YARP_ROBOT_NAME = icubGazeboSim.
% To do this, you can uncomment the

setenv('YARP_ROBOT_NAME','icubGazeboSim');
% % setenv('YARP_ROBOT_NAME','iCubGenova04'); %%Greeny
% % setenv('YARP_ROBOT_NAME','iCubGenova02'); %%Purple


% Simulation time in seconds
Config.SIMULATION_TIME = 15;

% If Config.SAVE_WORKSPACE = True, every time the simulink model is run the
% workspace is saved after stopping the simulation
Config.SAVE_WORKSPACE  = true;

% Controller period [s]
Config.Ts              = 0.01; 

% End Effector link name
Config.EE                               = 'r_foot';

% This sections contains information on the robot parts considered
%
% SM.SM_TYPE: defined the parts of the robot considered
%
% 'single_arm': the end effector defined by 'Config.EE_link_name' will be
%               moved along a desired trajectory using the joints in a single arm
% 'upper_body': the end effector defined by 'Config.EE_link_name' will be
%               moved along a desired trajectory using the joints in both the arms and
%               the torso of the robot
%               moved along a desired trajectory using 

% %Config.PARTS                            = 'single_arm';
% % Config.PARTS                           = 'upper_body';
Config.PARTS                           = 'lower_body';

if(strcmp(Config.PARTS,'single_arm'))
    Config.SOLO_ARM                     = true;
else
    Config.SOLO_ARM                     = false;
end

%% Trajectory generation flagr_hand
Config.ANALYTICAL_TRAJECTORY            = true;

%% Reactive control option
Config.REACTIVE_CONTROL                 = true;

%% Trajectory parametrization control
Config.TRAJECTORY_PARAMETRIZATION       = false;

%% Sdot upper limit
Config.SDOT_UPPER_LIMIT                 = 5;

%% Trajectory type
%% straight-x (0) straight-y (1) straight-z (2) or circular-yz (3) circular-xz (4) circular-xy (5)
Config.TRAJECTORY_TYPE                  = 0;


%% WBD Configuration
%% Configuration Object
WBTConfigRobot                          = WBToolbox.Configuration;

%% RobotConfiguration Data
WBTConfigRobot.RobotName                = 'icubSim';
WBTConfigRobot.UrdfFile                 = 'model.urdf';

if(strcmp(Config.PARTS,'single_arm') && strcmp(Config.EE,'r_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'r_shoulder_pitch','r_shoulder_roll',...
                                           'r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'right_arm'};

elseif (strcmp(Config.PARTS,'single_arm') && strcmp(Config.EE,'l_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'l_shoulder_pitch','l_shoulder_roll',...
                                           'l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'left_arm'};
    
elseif (strcmp(Config.PARTS,'upper_body'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'torso_yaw','torso_roll','torso_pitch',...
                                           'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                           'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'torso','left_arm','right_arm'};

elseif (strcmp(Config.PARTS,'lower_body') && strcmp(Config.EE,'r_foot'))
    
    WBTConfigRobot.ControlledJoints     = {'r_hip_pitch','r_hip_roll','r_hip_yaw',...
                                           'r_knee','r_ankle_pitch','r_ankle_roll'
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'right_leg'};
    
elseif (strcmp(Config.PARTS,'lower_body') && strcmp(Config.EE,'l_foot'))
    
    WBTConfigRobot.ControlledJoints     = {'l_hip_pitch','l_hip_roll','l_hip_yaw',...
                                           'l_knee','l_ankle_pitch','l_ankle_roll'
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'left_leg'};

end

WBTConfigRobot.LocalName                = 'WBT';

%% Checking Configuration Success
if ~WBTConfigRobot.ValidConfiguration
    return
end

%% Load Gains
run(strcat('app/robots/',getenv('YARP_ROBOT_NAME'),'/gains.m'));

%% Add utils directory to path
addpath('utils')

