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