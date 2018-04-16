This is a reactive controller designed for pHRI scenario of AnDy Y1 Demo.
It facilitates the iCub robot to standup exploiting the interaction wrench computed from human joint torque estimates from [human-dynamics-estimation](https://github.com/robotology/human-dynamics-estimation). 
This controller is built on top of [momentum-based-standup](https://github.com/robotology-playground/whole-body-controllers/tree/master/torque-controllers/momentum-based-standup).
It consists of two subsystems, a `human system` and a `robot system`.

Follow these steps to run the controller with icub robot in gazebo simulation environment

* Run yarpserver

     `$ yarpserver`
     
* This controller needs [standup world](https://github.com/robotology-playground/icub-gazebo-wholebody/tree/master/worlds/icub_standup_world). 
Add the following alias to your `/.bashrc` file

     `alias gazebo_standup="gazebo -slibgazebo_yarp_clock.so /<path-to-icub-gazebo-wholebody>/worlds/icub_standup_world/icub_standup_world"`
 
* Lauch gazebo by running `$ gazebo_standup`

* Run yarprobotinterface

     `$ yarprobotinterface --config launch-wholebodydynamics.xml`
     
* This controller needs the ports from [human-dynamics-estimation](https://github.com/robotology/human-dynamics-estimation). So, you need a datadump containing atleast the data from HDE modules i.e.,
`human-state-provider`, `human-forces-provider` and `human-dynamics-estimator`. Lauch yarpdataplayer and load the datadump

     `$ yarpdataplayer`
     
* Run [hde-readonly-controlboard](https://github.com/Yeshasvitvs/human-dynamics-estimation/tree/hde_interface/hde-readonly-controlboard)

     `$ ./hde-readonly-controlboard --from ../conf/hde_readonly_driver.ini`

* Run matlab and start the standup controller [model](https://github.com/Yeshasvitvs/wholeBodyControllers/blob/pHRI_standup/controllers/pHRIStandup/torqueBalancingStandup.mdl)

     `$ matlab`
     
* Make sure `Config.STANDUP_WITH_HUMAN_TORQUE` is set to **true** in the [robot configuration file](https://github.com/Yeshasvitvs/wholeBodyControllers/blob/pHRI_standup/controllers/pHRIStandup/app/robots/icubGazeboSim/configRobot.m) before running the controller!

For running this controller on the real robot, you can skip the steps `2,3,4,5`
