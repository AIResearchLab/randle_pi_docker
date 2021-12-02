# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

basename -a /sys/class/net/* > ipconfigs.txt

while read p; do
  IPTEST=`ip addr show $p | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
  #echo $IPTEST
  SUB='10.0.0'

if [[ "$IPTEST" =~ .*"$SUB".* ]]; then
  export YOUR_IP=$IPTEST
  echo 'The identified baxter network IP is ' $YOUR_IP
fi
done <ipconfigs.txt

rm ipconfigs.txt

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
#Todo, make this some kind of environmental variable, not sure how to do yet, will figure out
export ROS_IP=$YOUR_IP
export ROS_ETC_DIR=/opt/ros/kinetic/etc/ros
