#!/bin/bash
####################
# Glances (BARE) Setup
# REF: https://github.com/nicolargo/glances/
# 
# Execute: wget -O- https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/glancesServiceSetup.sh | sh
# Test web: http://{{hostname}}:81
# Test API: http://{{hostname}}:81/api/2/all
# ps aux | grep glances
# root      2903 19.6  2.1  69912 20260 ?        Rsl  14:43   0:10 /usr/bin/python /usr/local/bin/glances -w -p 81

####################
# Install Glances Service

echo "Installing Glances Service..."
sudo tee "/lib/systemd/system/glances.service" > /dev/null <<EOF
[Unit]
Description=Glances
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python /usr/local/bin/glances -w -p 81
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

####################
# Prep, Start, and Run service

sudo chmod 644 /lib/systemd/system/glances.service
sudo systemctl daemon-reload
sudo systemctl enable glances.service
sudo systemctl start glances.service
sudo systemctl status glances.service