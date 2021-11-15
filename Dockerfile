#FROM ros:kinetic-ros-core-xenial@sha256:38fbb5c633fb11dbfccc6269bacceac38ced36de1b29930d8c52dea53c5bfd72
FROM ros:kinetic-ros-core-xenial@sha256:bdb0d5f7a8cc3f25d7520cd12ffb30f67e7ce4adfd35dde79b134fbeeb5f2da4
ARG ssh_prv_key
ARG ssh_pub_key

SHELL ["/bin/bash", "-c"]
# automatically sources the default ros on docker run
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
# Package for installing Baxter
RUN sudo apt-get update

#This section also moves your host private key for ssh repositories
RUN apt update && \
    apt install -y \
        git \
        openssh-server \
        libmysqlclient-dev

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > ~/.ssh/id_ed25519 && \
    echo "$ssh_pub_key" > ~/.ssh/id_ed25519.pub && \
    chmod 600 ~/.ssh/id_ed25519 && \
    chmod 600 ~/.ssh/id_ed25519.pub

#copy the profile configuration to the host system
COPY .profile /root/.profile
RUN   echo "source /home/baxter/catkin_ws/devel/setup.bash" >> /root/.bashrc

RUN sudo apt-get install --allow-unauthenticated -y build-essential wget git xterm x11-xserver-utils \
#Debugging
vim nano iproute2 net-tools inetutils-ping tree software-properties-common \
#ROS
ros-kinetic-cv-bridge ros-kinetic-xacro ros-kinetic-dynamic-reconfigure ros-kinetic-control-msgs ros-kinetic-actionlib ros-kinetic-ros-control

RUN sudo apt-get -y install python-wstool

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
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /home/baxter/catkin_ws/src; git clone git@github.com:AIResearchLab/randle_serial.git && git clone git@github.com:AIResearchLab/randle_core.git && git clone https://github.com/wjwwood/serial' 
WORKDIR /home/baxter/catkin_ws
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /home/baxter/catkin_ws; catkin_make'
