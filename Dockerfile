FROM ros:kinetic-ros-core-xenial@sha256:38fbb5c633fb11dbfccc6269bacceac38ced36de1b29930d8c52dea53c5bfd72
SHELL ["/bin/bash", "-c"]
# automatically sources the default ros on docker run
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
# Package for installing Baxter
RUN sudo apt-get update
RUN sudo apt-get install --allow-unauthenticated -y build-essential wget git xterm x11-xserver-utils \
#Debugging
vim nano iproute2 net-tools inetutils-ping tree software-properties-common

#Installing baxter_sdk
RUN mkdir -p /home/baxter/catkin_ws/src
WORKDIR /home/baxter/catkin_ws/src
#Baxter firware needs release 1.1.1
RUN git clone -b release-1.1.1 https://github.com/AIResearchLab/baxter
WORKDIR /home/baxter/catkin_ws/src/baxter
# removing baxter entry in rosinstall file to avoid duplicate baxter_sdk folders
RUN sed -i '1,4d' baxter_sdk.rosinstall
RUN wstool init . baxter_sdk.rosinstall 
RUN wstool update
# replacing the default hostname with the hostname of the UC Baxter and changingthe distro to kinetic
RUN sed -i -e '22 s/baxter_hostname.local/011502P0001.local/g' -e '26 s/192.168.XXX.XXX/172.17.0.2/g'  -e '30 s/"indigo"/"kinetic"/g' baxter.sh
RUN mv *.sh ../..
# change font size for xterm to 18
RUN echo  "xterm*font:     *-fixed-*-*-*-18-*" > ~/.Xresources
WORKDIR /home/baxter/catkin_ws/src
RUN sed -i -e '16 s/value="0.1"/value="0.0"/g' /home/baxter/catkin_ws/src/moveit_robots/baxter/baxter_moveit_config/launch/trajectory_execution.launch
WORKDIR /home/baxter/catkin_ws
# it is neccesary to run 
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_make'
