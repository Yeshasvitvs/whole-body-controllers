%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * Copyright (C) 2016 CoDyCo
%  * @author: Daniele Pucci
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
clear variables
clc

%% GENERAL SIMULATION INFO
% If you are simulating the robot with Gazebo, 
% remember that you have to launch Gazebo as follow:
% 
% gazebo -slibgazebo_yarp_clock.so
% 
% and set the environmental variable YARP_ROBOT_NAME = icubGazeboSim.
% To do this, you can uncomment the 

% setenv('YARP_ROBOT_NAME','iCubGenova04');
  setenv('YARP_ROBOT_NAME','icubGazeboSim');
% setenv('YARP_ROBOT_NAME','iCubGenova02');
% setenv('YARP_ROBOT_NAME','iCubGazeboV2_5');

%% Flags for considering the standup scenario
Config.USING_SOLO_ROBOT       = true;
Config.USING_ROBOT_ASSISTANT  = false;
Config.USING_HUMAN_ASSISTANT  = false;

%% Check if standup scenario is set correctly
if ((Config.USING_SOLO_ROBOT && Config.USING_ROBOT_ASSISTANT) || (Config.USING_SOLO_ROBOT && Config.USING_HUMAN_ASSISTANT))
    error('Standup scenario set with both solo robot flag and one of external agent flags set True. \n%s',...
          'Either set SOLO_ROBOT flag true or set one of the assitant flags true.');
end

if ((~Config.USING_SOLO_ROBOT && ~Config.USING_ROBOT_ASSISTANT) && (~Config.USING_SOLO_ROBOT && ~Config.USING_HUMAN_ASSISTANT))
    error('Standup scenario set with solo robot flag False but no assitant agent flags is set True. \n%s',...
          'Select a single assistant agent.');
end

%% Check if single assistant agent is set
if (Config.USING_ROBOT_ASSISTANT && Config.USING_HUMAN_ASSISTANT)
    error('Both the robot and human assistant agent flags are set True. \n%s',...
          'Select a single assistant agent.');
end

%% iCub STANDUP demo physical interaction options
Config.STANDUP_WITH_ASSISTANT_FORCE           = false;
Config.MEASURED_FT                            = false;
Config.STANDUP_WITH_ASSISTANT_TORQUE          = false;

if (Config.USING_SOLO_ROBOT && (Config.STANDUP_WITH_ASSISTANT_FORCE || Config.MEASURED_FT || Config.STANDUP_WITH_ASSISTANT_TORQUE))
    error('Standup scenario set up with only solo robot but some of the physical interaction options is set to True. \n%s', 'Please set that flags to false.');
elseif (~Config.USING_SOLO_ROBOT && (~Config.STANDUP_WITH_ASSISTANT_FORCE && ~Config.MEASURED_FT && ~Config.STANDUP_WITH_ASSISTANT_TORQUE))
    error('Standup scenario set up with an external agent but all of the physical interaction options are set False. \n%s','Please set one option of physical interaction to True.');
elseif (~Config.USING_SOLO_ROBOT && (Config.STANDUP_WITH_ASSISTANT_FORCE && Config.STANDUP_WITH_ASSISTANT_TORQUE))
    error('Standup scenario set up with an both assistant force and torque options true. \n%s','Please set only one of the options True.');
elseif (~Config.USING_SOLO_ROBOT && (Config.MEASURED_FT && ~Config.STANDUP_WITH_ASSISTANT_FORCE))
    error('Standup scenario set up with force option false but measured FT option is set true. \n%s','Please turn on the force option if you wish to use measured wrench through wholebodydynamics.')
end

if (~Config.USING_SOLO_ROBOT && (Config.STANDUP_WITH_ASSISTANT_FORCE && Config.MEASURED_FT))
    disp('Physical interaction option set to use assistant agent help in terms of measured wrench through wholebodydynamics.');
elseif (~Config.USING_SOLO_ROBOT && (Config.STANDUP_WITH_ASSISTANT_FORCE && ~Config.MEASURED_FT))
    disp('Physical interaction option set to use assistant agent help in terms of computed wrench through coupled dynamics.'); 
elseif (~Config.USING_SOLO_ROBOT && Config.STANDUP_WITH_ASSISTANT_TORQUE)
    disp('Physical intearction option set to use assistant agent joint torques.');
end

%% Trajectory parametrization info
% Trajectory type
Config.ANALYTICAL_TRAJECTORY      = true;

% Trajectory paramerization
Config.TRAJECTORY_PARAMETRIZATION = true;

if (~Config.ANALYTICAL_TRAJECTORY && ~Config.TRAJECTORY_PARAMETRIZATION)
    disp('Using simulink minimum-jerk trajectory with normal time parametrization');
elseif (~Config.ANALYTICAL_TRAJECTORY && Config.TRAJECTORY_PARAMETRIZATION)
    error('Trajectory parametrization cannot be achived using simulink minimum-jerk trajectory. \n%s', 'Please verify the options you are setting.')
elseif (Config.ANALYTICAL_TRAJECTORY && ~Config.TRAJECTORY_PARAMETRIZATION)
    disp('Using analytical minimum-jerk trajectory with normal time parametrization')
elseif (Config.ANALYTICAL_TRAJECTORY && Config.TRAJECTORY_PARAMETRIZATION)
    disp('Using analytical minimum-jerk trajectory with trajectory parametrization')
end

% Simulation time in seconds
Config.SIMULATION_TIME = inf;

%% PRELIMINARY CONFIGURATIONS 
% Sm.SM_TYPE: defines the kind of state machines that can be chosen.
%
% 'STANDUP': the robot will stand up from a chair. The associated
%            configuration parameters can be found under the folder
%
%            robots/YARP_ROBOT_NAME/initStateMachineStandup.m
%   
% 'COORDINATOR': the robot can either stay still, or follow a desired
%                center-of-mass trajectory. The associated configuration 
%                parameters can be found under the folder:
%
%                app/robots/YARP_ROBOT_NAME/initCoordinator.m
% 
SM_TYPE                      = 'STANDUP';

% Config.SCOPES: if set to true, all visualizers for debugging are active
Config.SCOPES_ALL            = true;

% You can also activate only some specific debugging scopes
Config.SCOPES_EXT_WRENCHES   = false;
Config.SCOPES_GAIN_SCHE_INFO = false;
Config.SCOPES_MAIN           = false;
Config.SCOPES_QP             = false;

% Config.CHECK_LIMITS: if set to true, the controller will stop as soon as 
% any of the joint limit is touched. 
Config.CHECK_LIMITS          = false;

% If Config.SAVE_WORKSPACE = True, every time the simulink model is run the
% workspace is saved after stopping the simulation
Config.SAVE_WORKSPACE        = false;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURATIONS COMPLETED: loading gains and parameters for the specific robot
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Controller period [s]
Config.Ts              = 0.01; 

addpath('./src/')
addpath(genpath('../../library'));

% Run robot-specific configuration parameters
run(strcat('app/robots/',getenv('YARP_ROBOT_NAME'),'/configRobot.m')); 

% Run demo-specific configuration parameters
Sm.SM_MASK_COORDINATOR = bin2dec('001');
Sm.SM_MASK_STANDUP     = bin2dec('010');

if strcmpi(SM_TYPE, 'COORDINATOR')
    
    Sm.SM_TYPE_BIN = Sm.SM_MASK_COORDINATOR;
    demoSpecificParameters = fullfile('app/robots',getenv('YARP_ROBOT_NAME'),'initCoordinator.m');
    run(demoSpecificParameters);
    % If true, the robot will perform the STANDUP demo
    Config.iCubStandUp = false; 
    
elseif strcmpi(SM_TYPE, 'STANDUP')
    
    Sm.SM_TYPE_BIN = Sm.SM_MASK_STANDUP;
    demoSpecificParameters = fullfile('app/robots',getenv('YARP_ROBOT_NAME'),'initStateMachineStandup.m');
    run(demoSpecificParameters);
    % If true, the robot will perform the STANDUP demo
    Config.iCubStandUp = true;
    
end

%% Contact constraints: legs and feet
% feet constraints
[ConstraintsMatrixFeet,bVectorConstraintsFeet] = constraints(forceFrictionCoefficient,numberOfPoints,torsionalFrictionCoefficient,feet_size,fZmin);
% legs constraints
[ConstraintsMatrixLegs,bVectorConstraintsLegs] = constraints(forceFrictionCoefficient,numberOfPoints,torsionalFrictionCoefficient,leg_size,fZmin);

%% Assistant Agent Configuration
model_name = 'torqueBalancingPHRIStandup_WBTv5';

% open simulink model
if (~slreportgen.utils.isModelLoaded(model_name))
    open_system(model_name,'window')
end

set_param(strcat(model_name,'/Assistant system/Real system'), 'Commented', 'off')
set_param(strcat(model_name,'/Assistant system/Dummy system'), 'Commented', 'off')

if ((Config.STANDUP_WITH_ASSISTANT_FORCE && ~Config.MEASURED_FT) || Config.STANDUP_WITH_ASSISTANT_TORQUE)
    set_param(strcat(model_name,'/Assistant system/Dummy system'), 'Commented', 'on')
    % Run assistant robot agent specifig configuration parameters
    if (~Config.USING_SOLO_ROBOT && Config.USING_ROBOT_ASSISTANT)
        disp('Standup scenario set up with robot assistant.');
        run(strcat('app/robots/robot-assistant/configRobot.m'));
        
        % Run assitant human agent specific configuration parameters
    elseif (~Config.USING_SOLO_ROBOT && Config.USING_HUMAN_ASSISTANT)
        disp('Standup scenario set up with human assistant.');
        run(strcat('app/robots/human-assistant/configRobot.m'));
    end
else
    set_param(strcat(model_name,'/Assistant system/Real system'), 'Commented', 'on')
    disp('Standup scenario set up without any external agent assistant.');
end