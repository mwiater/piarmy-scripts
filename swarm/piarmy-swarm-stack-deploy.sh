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

#ps -ef | grep "collector.sh" | grep -v grep | awk '{print $2}' | xargs kill -9

#(sh /home/pi/images/piarmy-collector/collector.sh &) > /dev/null 2>&1
docker stack deploy -c piarmy-stack.yml piarmy
docker service ls