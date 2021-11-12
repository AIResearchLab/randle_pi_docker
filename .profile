# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
source /opt/ros/kinetic/setup.bash
source /home/baxter/catkin_ws/devel/setup.bash
export ROS_ROOT=/opt/ros/kinetic/share/ros
export ROS_PACKAGE_PATH=/home/baxter/catkin_ws/src:/opt/ros/kinetic/share
export ROS_MASTER_URI=http://011502P0001.local:11311
export ROS_PYTHON_VERSION=2
export ROS_VERSION=1
export ROSLISP_PACKAGE_DIRECTORIES=/home/baxter/catkin_ws/devel/share/common-lisp
export __ROS_PROMPT=1
export ROS_DISTRO=kinetic
export ROS_IP=$SYSTEM_IP
export ROS_ETC_DIR=/opt/ros/kinetic/etc/ros
