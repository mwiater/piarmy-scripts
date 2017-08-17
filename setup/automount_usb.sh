#!/bin/bash
uuid=$(sudo blkid | grep sda1 | awk '{print $3}')
uuid=$(echo $uuid | sed 's/"//g')

echo "Setting up automount:"
sudo mkdir /media/usb
echo -e "\n${uuid} /media/usb auto nosuid,nodev,nofail 0 0" | sudo tee --append /etc/fstab