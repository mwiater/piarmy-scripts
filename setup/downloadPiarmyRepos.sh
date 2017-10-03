#!/bin/bash
####################
# Download PiArmy Repos
#
# Execute: bash -c "$(wget -O - https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/downloadPiarmyRepos.sh)"
#

cd /home/pi/images
git clone git@github.com:piarmy/piarmy-elasticsearch-cluster.git
git clone git@github.com:piarmy/piarmy-lambda.git
git clone git@github.com:piarmy/piarmy-collector.git
git clone git@github.com:piarmy/piarmy-resque-stack.git
git clone git@github.com:piarmy/piarmy-webserver.git

cd /home/pi/projects
git clone git@github.com:piarmy/piarmy-scripts.git
