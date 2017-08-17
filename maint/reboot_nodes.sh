#!/bin/bash

# Collect host and domain info
hostname=`hostname`
domain=`awk '/^domain/ {print $2}' /etc/resolv.conf`

# Collect swarm nodes
nodes=($(docker node ls | grep -oh "piarmy\S*"))

# Remove self node
for i in ${!nodes[@]};do
  if [ "${nodes[$i]}" == "$hostname" ]; then
    unset nodes[$i]
  fi 
done

echo "Rebooting nodes..."

for i in "${nodes[@]}"
do
  # Reboot
  ssh -i /home/pi/.ssh/id_rsa pi@${i}.${domain} sudo reboot
  echo "Rebooted ${i}.${domain}..."
done

echo "Rebooting self..."
sudo reboot