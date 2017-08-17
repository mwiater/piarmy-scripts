#!/bin/bash

#nodes=($(docker network inspect --format "{{range .Peers}} {{.Name}},{{.IP}} {{end}}" piarmy))

#nodes=$(docker network inspect --format "{{range .Peers}}{{.Name}},{{.IP}} {{end}}" piarmy)

# Get data
nodes=$(docker network inspect --format "{{range .Peers}}{{.Name}} {{.IP}}{{end}}" piarmy)

# strip out spaces
nodes=$(echo $nodes | tr -d ' ')

echo $nodes

echo $nodes | jq '.[]'

#for node in "${nodes[@]}"
#do
#   echo $node
#done