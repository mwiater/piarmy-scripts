#!/bin/bash

clear
echo "Current:"
echo "----------"
free -h
sync
sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'
sudo swapoff -a
sudo swapon -a
echo "After:"
echo "----------"
free -h

#sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
#  ssh piarmy02 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
#  ssh piarmy03 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
#  ssh piarmy04 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh