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

echo "Cleaning Images on nodes..."

for i in "${nodes[@]}"
do
  echo "Cleaning images on ${i}.${domain}..."
  echo "------------------------------------"
  ssh -i /home/pi/.ssh/id_rsa pi@${i}.${domain} docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm || echo "No exited images to remove..."
  ssh -i /home/pi/.ssh/id_rsa pi@${i}.${domain} docker rmi $(docker images | grep "^<none>" | awk "{print $3}") || echo "No untagged images to remove..."
  ssh -i /home/pi/.ssh/id_rsa pi@${i}.${domain} docker rmi $(docker images --filter "dangling=true" -q --no-trunc) || echo "No dangling images to remove..."
done

echo "Cleaning images on self..."
echo "------------------------------------"
docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm || echo "No exited images to remove..."
docker rmi $(docker images | grep "^<none>" | awk "{print $3}") || echo "No untagged images to remove..."
docker rmi $(docker images --filter "dangling=true" -q --no-trunc) || echo "No dangling images to remove..."