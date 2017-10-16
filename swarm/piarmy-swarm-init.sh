#!/bin/bash
####################
# PiArmy Swarm Init
#
# Execute: bash -c "$(wget -O - https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/swarm/piarmy-swarm-init.sh)"
# Test: Portainer
# http://{{hostname}}:5000
# Create PWD
# Logni admin/PWD
# Select: Manage the Docker instance where Portainer is running

####################
# Config
# The current host will become the Swarm Manager
# Add device hostnames that you want to join the Docker Swarm, e.g.: nodes=( piarmy02 piarmy03 piarmy04 )
nodes=( piarmy02 piarmy03 piarmy04 )

# Name the Docker Swarm Overlay Netwok
dockerSwarmNetwork="piarmy"


####################
# Begin Docker Swarm Init
clear

hostname=$(hostname)

ifconfig=$(ifconfig eth0 | grep inet -m 1)
ipAddress=$(echo "$ifconfig" | awk -v OFS="\n" '{ print $2 }' | grep -oE -m 1 "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b")
domain=`awk '/^domain/ {print $2}' /etc/resolv.conf`
domain="local"

####################
# Leave existing Swarm
docker swarm leave --force

####################
# Init nerw swarm with eth0 IP
docker swarm init --advertise-addr $ipAddress

joinToken=$(docker swarm join-token worker -q)

docker network create --driver=overlay --attachable $dockerSwarmNetwork

####################
# Add Swarm Nodes

echo "Setting up Swarm..."

for node in "${nodes[@]}"
do
  echo "Adding worker: ${node}..."
  # Leave existing Swarm
  ssh -i /home/pi/.ssh/id_rsa -q -o UserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no pi@${node}.${domain} docker swarm leave --force

  # Join new Swarm
  ssh -i /home/pi/.ssh/id_rsa -q -o UserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no pi@${node}.${domain} docker swarm join --token ${joinToken} ${ipAddress}:2377

  # Add node name label
  docker node update --label-add name=${node} ${node}
done

docker node update --label-add name=$hostname $hostname

docker service ls
