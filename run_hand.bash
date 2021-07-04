#!/bin/bash
docker exec -d rpi_controller bash -c "/home/baxter/catkin_ws/devel/env.sh roslaunch randle_control serial_com_exe.launch"
