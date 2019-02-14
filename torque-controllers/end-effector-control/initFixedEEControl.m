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
clear; 
clc;

% End Effector link name
CONFIG.EE                               = 'r_hand';

% This sections contains information on the robot parts considered
%
% SM.SM_TYPE: defined the parts of the robot considered
%
% 'single_arm': the end effector defined by 'CONFIG.EE_link_name' will be
%               moved along a desired trajectory using the joints in a single arm
% 'upper_body': the end effector defined by 'CONFIG.EE_link_name' will be
%               moved along a desired trajectory using the joints in both the arms and
%               the torso of the robot
%               moved along a desired trajectory using 

%CONFIG.PARTS                            = 'single_arm';
CONFIG.PARTS                            = 'upper_body';

%% Configuration Object
WBTConfigRobot                          = WBToolbox.Configuration;

%% RobotConfiguration Data
WBTConfigRobot.RobotName                = 'icubSim';
WBTConfigRobot.UrdfFile                 = 'model.urdf';

if(strcmp(CONFIG.PARTS,'single_arm') && strcmp(CONFIG.EE,'r_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'r_shoulder_pitch','r_shoulder_roll',...
                                           'r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'right_arm'};

elseif (strcmp(CONFIG.PARTS,'single_arm') && strcmp(CONFIG.EE,'l_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'l_shoulder_pitch','l_shoulder_roll',...
                                           'l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'left_arm'};
    
else
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'torso_pitch','torso_roll','torso_yaw',...
                                           'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                           'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'torso','left_arm','right_arm'};

end

WBTConfigRobot.LocalName                = 'WBT';

%% Checking Configuration Success
if ~WBTConfigRobot.ValidConfiguration
    return
end

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

%% Load Gains
run(strcat('app/robots/',getenv('YARP_ROBOT_NAME'),'/gains.m'));


