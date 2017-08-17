#!/bin/bash
####################
# PiArmy Swarm Remove Stack
#
# 

clear

ps -ef | grep "collector.sh" | grep -v grep | awk '{print $2}' | xargs kill -9

docker stack rm piarmy