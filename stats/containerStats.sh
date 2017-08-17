#!/bin/bash
# Container stats test

clear

hostname=$(hostname)

containerStats=$(docker stats --format "{{.ID}} {{.Name}} {{.CPUPerc}} {{.MemPerc}}" --no-stream=true)

containerStatsFile=/home/pi/projects/piarmy-glances/data/containerStats-$hostname.json
containerStatsTmpFile=/home/pi/projects/piarmy-glances/data/containerStatsTmp.json

if [ ! -e $sysInfo ] ; then
  touch $sysInfo
  chmod 777 $sysInfo
fi

if [ ! -e $tmpFile ] ; then
  touch $tmpFile
  chmod 777 $tmpFile
fi

echo "${containerStats}"
echo ""
echo "${containerStats//[$'\t\r\n']}"
echo ""
echo "{\"msgType\":\"xxx\", \"msgData\":{\"node\":\"$hostname\",\"status\":\"${containerStats//[$'\t\r\n']}\"}}"


# Working
#. ws_send_message.sh "{\"msgType\":\"xxx\", \"msgData\":{\"node\":\"$hostname\",\"status\":\"green\"}}"

# Trying to send containerStats
#. ws_send_message.sh '{"msgType":"xxx", "msgData":{"node":"piarmy01","status":"daeb05dc1ef9803b6ec0be71d1883c4c8fd445725e84c355953fdc7e85cfda7e piarmy-ws-server.1.htyu6lgpltaz6pd6o8yy2xwnf 0.85% 1.21%518675fd1be1e47f48793491392157401a025b6021d4607dc835794701046b2d piarmy-ws-client-piarmy01.1.mff50ft74u34iwh0k63ybrzw4 0.00% 1.10%cad4310c6a7edf233f3e971fdc0f8417f242eb66eef8254a3d6b84ec3f819214 piarmy-lambda.4.i2x47djuhi39b8zt7nweonfbr 0.01% 1.20%5990d43a7ea57928ff78f0d1e3014134efa152b2834ba9303f158a5cd3a4400a piarmy-webserver.3.tctiu7paokkdggxz6x9e2l2r2 0.00% 0.04%8dade7fdb9bfb468baaa3a3ddcfefe55d24848fa95878e13e5d3fb89e07c147e portainer.1.qnogwyze41jz8atsx6gmotlo1 0.00% 0.24%"}}'
. ws_send_message.sh "{\"msgType\":\"xxx\", \"msgData\":{\"node\":\"piarmy01\",\"status\":\"905dfa2d9ab6a124bc13e4a8721f226bc638ab4bd2cb1051857324b8ab699a15 piarmy-ws-server.1.zfrw8o0qd3gchu2t213v8x9vh 0.00% 1.29%518675fd1be1e47f48793491392157401a025b6021d4607dc835794701046b2d piarmy-ws-client-piarmy01.1.mff50ft74u34iwh0k63ybrzw4 0.00% 1.10%cad4310c6a7edf233f3e971fdc0f8417f242eb66eef8254a3d6b84ec3f819214 piarmy-lambda.4.i2x47djuhi39b8zt7nweonfbr 0.01% 1.20%5990d43a7ea57928ff78f0d1e3014134efa152b2834ba9303f158a5cd3a4400a piarmy-webserver.3.tctiu7paokkdggxz6x9e2l2r2 0.00% 0.04%8dade7fdb9bfb468baaa3a3ddcfefe55d24848fa95878e13e5d3fb89e07c147e portainer.1.qnogwyze41jz8atsx6gmotlo1 0.00% 0.24%\"}}"