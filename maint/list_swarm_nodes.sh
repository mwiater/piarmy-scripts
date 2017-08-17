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
# for i in ${!nodes[@]};do echo $i = ${nodes[$i]}; done

for i in "${nodes[@]}"
do
  echo "${i}.${domain}..."
done