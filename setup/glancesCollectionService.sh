#!/bin/bash
####################
# Glances (Collection) Setup
# 
# Execute: wget -O- https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/glancesCollectionService.sh | sh

####################
# Unistall Glances (Base) Service

sudo systemctl disable glances.service
sudo systemctl stop glances.service
sudo systemctl daemon-reload
sudo systemctl status glances.service

####################
# Install Glances Collection Service

echo "Installing Glances Collection Service..."
sudo tee "/lib/systemd/system/glancesCollection.service" > /dev/null <<EOF
[Unit]
Description=GlancesCollection
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/pi/projects/piarmy-glances/glances_boot.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

####################
# Prep, Start, and Run service

sudo chmod 644 /lib/systemd/system/glancesCollection.service
sudo systemctl daemon-reload
sudo systemctl enable glancesCollection.service
sudo systemctl start glancesCollection.service
sudo systemctl status glancesCollection.service