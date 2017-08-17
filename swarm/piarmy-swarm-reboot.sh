#!/bin/bash
####################
# PiArmy Swarm Reboot
#
# Execute: . swarm/piarmy-swarm-reboot.sh

clear

read -r -p "Are you sure you want to reboot the swarm (including this machine)? [Y/n] " response
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
    	ssh pi@${ipAddress} "nohup sudo reboot &>/dev/null & exit" && echo "${node}: rebooting..."
  	fi
  done

  sudo reboot
else
  echo "Exiting..."
fi