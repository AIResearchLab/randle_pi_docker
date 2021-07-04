#!/bin/bash
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

if [[ -z "${YOUR_IP}" ]]; then
  export SYS_IP_ADDR=10.0.0.171
else
  export SYS_IP_ADDR="${YOUR_IP}"
fi

docker run -t -d --name="rpi_controller" \
    --network=host \
    --add-host=011502P0001.local:10.0.0.10 \
    --device=/dev/dri:/dev/dri \
    --privileged -v /dev/bus/usb:/dev/bus/usb -e YOUR_IP=SYS_IP_ADDR \
    rpi_conf
