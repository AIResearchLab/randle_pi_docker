#!/bin/bash
#This file should be run from its directory
./kill.bash
docker build . -t rpi_conf --platform linux/amd64 --build-arg ssh_prv_key="$(cat ~/.ssh/id_ed25519)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_ed25519.pub)"
./run_system.bash
./run_hand.bash
