#!/bin/bash
####################
# PiArmy Setup
#
# Execute: bash -c "$(wget -O - https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/deviceSetup.sh)"
#
# Pre-boot Steps:
# 
# RPi Zero/RPi2/3:
# Grab image (Raspian Jessie Lite): https://www.raspberrypi.org/downloads/raspbian/
# Make SD Card using Etcher (https://etcher.io/):
# [Windows] https://learn.adafruit.com/introducing-the-raspberry-pi-zero/making-an-sd-card-using-a-windows-vista-slash-7
# [Mac] https://learn.adafruit.com/introducing-the-raspberry-pi-zero/making-an-sd-card-using-a-mac
# 
# Add Pre-boot Options by creating 2 files on imaged SD card:
# *Make sure that unix/linux line endings are used in text editor*
# 
# WIRELESS
# /boot/wpa_supplicant.conf:
# ----------
# network={
#     ssid="YOUR_SSID"
#     psk="YOUR_PASSWORD"
#     key_mgmt=WPA-PSK
# }
# 
# ENABLE SSH
# /boot/ssh:
# ----------
# {empty}
#
# On first boot, hostname will be raspberrypi and uerp/pass will be default: pi/raspberry

####################
# Change password for user: pi
echo "Change password for user: pi (current password is: raspberry)"
passwd

####################
# Change hostname from default (raspberrypi)
echo "Enter a hostname for this device, e.g.: piarmy01, followed by [ENTER]:"
while read hostname; do
 if [[ -z "${hostname}" ]]; then
  echo "Hostname cannot be blank, please enter a hostname..."
 else
  break
 fi
done

####################
# Change hostname on system

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOSTNAME=$hostname

echo $hostname | sudo tee /etc/hostname
sudo sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts

sudo hostname $hostname

echo "The hostname has been changed to: $hostname"


####################
# Generate ssh key
echo "Creating ssh key..."

cat /dev/zero | ssh-keygen -q -N ""
echo "Copy this key to your github account:"
more /home/pi/.ssh/id_rsa.pub
read -p "Press enter to continue."


####################
# Create directories

echo "Creating /home/pi/images and home/pi/projects directories..."
mkdir -p /home/pi/images && chmod 777 /home/pi/images
mkdir -p /home/pi/projects && chmod 777 /home/pi/projects


####################
# Remove dash as default shell
# Ref: https://ubuntuforums.org/showthread.php?t=1377218
echo "Setting dash default to false..."
echo "dash dash/sh boolean false" | sudo debconf-set-selections


####################
# Expand Filesystem
sudo raspi-config --expand-rootfs


####################
# Set localization
echo 'America/Los_Angeles' | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata
sudo sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen

sudo locale-gen
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

. ~/.bashrc


####################
# Update, Upgrade, Install packages
sudo apt-get -yq dist-upgrade && \
  sudo apt-get -yq update && \
  sudo apt-get -yq upgrade && \
  sudo apt-get -yq install bc git samba nano build-essential jq python-dev htop stress nmap sshpass && \
  sudo apt-get -yq autoremove && \
  sudo apt-get -yq autoclean

####################
# Set up Samba configuration

echo "Installing Samba config..."
sudo tee -a "/etc/samba/smb.conf" > /dev/null <<EOF
[$hostname]
  comment=$hostname
  path=/home/pi
  browseable=Yes
  writeable=Yes
  create mask=0777
  directory mask=0777
  public=yes
EOF

####################
# Install Docker

echo "Installing Docker"

curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker pi

echo "The Docker install may throw an error. Most likely this will be fixed with a reboot."
echo "After rebooting, test the install by running: docker info"
echo "If the output is a list of Docker config vars, you're good to go!"
echo ""
echo "Installation finished, please reboot."
