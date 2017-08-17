# Pi: Setup Walkthrough

### Script [approx 40m for 4 Pis]

1. Etcher.io: burn image [approx 2m 30s]
2. Save Empty ssh file on /boot
3. Login: `ssh pi@raspberrypi`, password `raspberry`
3. Run Setup script: `bash -c "$(wget -O - https://raw.githubusercontent.com/piarmy/piarmy-scripts/master/setup/deviceSetup.sh)"` [approx 6m]
4. Update password
5. Name host: `piarmy0[n]`
6. Copy ssh key to Github when prompted
7. After script completes, run `sudo smbpasswd -a pi` , entering same password as above when prompted
8. Reboot: `sudo reboot`
9. Check: `docker info`

### Post Setup config

#### Clone piarmy-scripts

1. `cd /home/pi/projects && git clone git@github.com:piarmy/piarmy-scripts.git && cd piarmy-scripts`

#### Copy keys accross all pis

Run this from piarmy01 (or whatever the manager node will be)

1. `cd /home/pi/projects/piarmy-scripts/setup`
2. Edit copy keys script: `nano piarmyCopyKeys.sh` (change password variable)
3. Run copy keys script: `. piarmyCopyKeys.sh`
4. Run script on remote nodes:

```
ssh pi@piarmy02 'bash -s' < piarmyCopyKeys.sh && \
  ssh pi@piarmy03 'bash -s' < piarmyCopyKeys.sh && \
  ssh pi@piarmy04 'bash -s' < piarmyCopyKeys.sh
```

#### USB mounting (optional)
Follow these steps if you have USB drives in your Pis.

ssh into each pi and format drive to EXT4: `sudo mkfs.ext4 /dev/sda1 -L minio`

From manager node, run:

```
cd /home/pi/projects/piarmy-scripts/setup && \
  . automount_usb.sh && \
  ssh pi@piarmy04 'bash -s' < automount_usb.sh && \
  ssh pi@piarmy04 'bash -s' < automount_usb.sh && \
  ssh pi@piarmy04 'bash -s' < automount_usb.sh
```

#### Git config
Replace: YOUR_EMAIL and YOUR_NAME with the proper values below and run command:
```
git config --global user.email "YOUR_EMAIL" && git config --global user.name "YOUR_NAME" && git config -l && \
  ssh pi@piarmy02 "git config --global user.email 'YOUR_EMAIL' && git config --global user.name 'YOUR_NAME' && git config -l" && \
  ssh pi@piarmy03 "git config --global user.email 'YOUR_EMAIL' && git config --global user.name 'YOUR_NAME' && git config -l" && \
  ssh pi@piarmy04 "git config --global user.email 'YOUR_EMAIL' && git config --global user.name 'YOUR_NAME' && git config -l"
```

#### Clone other project repos

```
cd /home/pi/images  && \
  git clone git@github.com:piarmy/piarmy-collector.git && \
  git clone git@github.com:piarmy/piarmy-webserver.git && \
  git clone git@github.com:piarmy/piarmy-lambda.git

```

#### Swarm Setup

1. `cd /home/pi/projects/piarmy-scripts/swarm`
2. Run Swarm init script: `. piarmy-swarm-init.sh`
3. Check: `docker node ls`

Should produce something similar:
```
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
jxv6a41hph8bililk5egd7zg1     piarmy02            Ready               Active              
o20038vfj6a5bxn0b5qihu8o8     piarmy04            Ready               Active              
ony0b9ai9zh08be877hltiw1u     piarmy03            Ready               Active              
s3nojsclw58dq6hhlfxlaukjt *   piarmy01            Ready               Active              Leader
```


