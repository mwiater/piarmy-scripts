#!/bin/bash
####################
# PiArmy Swarm Deploy Stack
#
#

# Minio: USB Mount / Reset
# cd /media
# sudo umount /media/usb
# sudo rm -rf /media/usb
# sudo mkdir /media/usb
# sudo chown -R pi:pi /media/usb
# sudo mount -t ext4 -o defaults /dev/sda1 /media/usb
# mkdir export && chmod 777 export

clear

docker stack rm piarmy
docker stack deploy -c piarmy-stack.yml piarmy
docker service ls