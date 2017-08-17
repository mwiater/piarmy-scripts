#!/bin/bash
####################
# PiArmy Copy Keys
#
# Execute: bash -c "$(wget -O - https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/piarmyCopyKeys.sh)"

# Notes: sudo apt-get install sshpass
# export DOCKER_SWARM_PASSWORD="mypassword!"
# Use: sshpass -p ${DOCKER_SWARM_PASSWORD} ssh-copy-id -i /home/pi/.ssh/id_rsa.pub pi@piarmy04

clear

password="xxx"

####################
# Config
# The current host will become the Swarm Manager
# Add device hostnames that you want to join the Docker Swarm, e.g.: nodes=( piarmy02 piarmy03 piarmy04 )
hostname=$(hostname)

nodes=( piarmy01 piarmy02 piarmy03 piarmy04 )
#newNodes=()

# Check to see if hosts are reachable at .local instead of bare domain
#for node in "${nodes[@]}"
#do
#  if [ "${hostname}" != "${node}" ] ; then
#    if ping -c 1 $node &> /dev/null
#    then
#      newNodes+=($node)
#    else
#      if ping -c 1 "${node}.local" &> /dev/null
#      then
#        newNodes+=("${node}.local")
#      else
#        newNodes+=($node)
#      fi
#    fi
#  else
#    if ping -c 1 "${node}.local" &> /dev/null
#    then
#      newNodes+=("${node}.local")
#    else
#      newNodes+=($node)
#    fi
#  fi
#
#done


####################
# Copy ssh keys
for node in "${nodes[@]}"
do
  if [ "${hostname}" != "${node}" ] ; then

    echo "Copying key from ${hostname} to: ${node}"
    sshpass -p ${password} ssh-copy-id -oStrictHostKeyChecking=no -i /home/pi/.ssh/id_rsa.pub pi@${node}
    echo "-----"
  fi
done
