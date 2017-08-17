#!/bin/bash
####################
# PiArmy Swarm Halt
#
# Execute: . swarm/piarmy-swarm-halt.sh

clear

read -r -p "Are you sure you want to halt the swarm (including this machine)? [Y/n] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ || "$response" == "" ]]
then
	nodes=( $(docker node ls --format "{{.Hostname}}") )
	manager=$(hostname)

	for node in "${nodes[@]}"
  do
  	if [ ${node} != ${manager} ]
    then
    	ipAddress=$(docker node inspect ${node} --format "{{.Status.Addr}}")
    	ssh pi@${ipAddress} "nohup sudo halt &>/dev/null & exit" && echo "${node}: halting..."
  	fi
  done

  sudo halt
else
  echo "Exiting..."
fi