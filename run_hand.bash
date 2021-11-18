#!/bin/bash
docker exec -d rpi_controller bash -c "source ~/.profile;/home/baxter/catkin_ws/devel/env.sh roslaunch randle_serial run_hand.launch button_sensor:=false"
