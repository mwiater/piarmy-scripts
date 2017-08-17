#!/bin/bash
# This script sends a message of up to 127 bytes to a websocket server.
# It works by initiating a connection with netcat, doing the websocket
# handshake, then framing/masking the message to send to the sever.
# Usage: send_to_websocket.sh "My awesome message"

# ps -ef | grep "nc " | grep -v grep | awk '{print $2}' | xargs kill -9 && . send_ws_message.sh '{"msgType":"loadStatus", "msgData":{"node":"piarmy01","status":"red"}}'
# . send_ws_message.sh '{"msgType":"loadStatus", "msgData":{"node":"piarmy01","status":"yellow"}}'
# . send_ws_message.sh '{"msgType":"loadStatus", "msgData":{"node":"piarmy01","status":"green"}}'
# . send_ws_message.sh '{"msgType":"loadStatus", "msgData":{"node":"piarmy01","status":"off"}}'

# ====== Set the constants below =======

domain=`awk '/^domain/ {print $2}' /etc/resolv.conf`

echo "Sending message..."
sudo pkill -f "nc "

# The websocket server and port
WS_SERVER="piarmy01"
WS_PORT=8888

# The header values to use when performing a websocket handshake.
HS_GET="/ws/dashing"
HS_ORIGIN="https://piarmy01:8888"
HS_HOST="piarmy01"

# This script uses a local netcat server to forward messages to the remote server.
WS_LOCAL_PORT=6666

# ===== Do not edit below this line =====

# generate a random Sec-WebSocket-Key
echo "Generating key..."
random_bytes=$(dd if=/dev/urandom bs=16 count=1 2> /dev/null)
HS_KEY=`echo "$random_bytes" | base64`

echo "Generating handshake..."
handshake="\
GET $HS_GET HTTP/1.1\r
Origin: $HS_ORIGIN\r
Connection: Upgrade\r
Host: $HS_HOST\r
Sec-WebSocket-Key: $HS_KEY\r
Upgrade: websocket\r
Sec-WebSocket-Version: 13\r\n\r\n"

dec_to_hex() {
   num=`echo 'obase=16; ibase=10; '"$1"| bc`
   if [ ${#num} -eq 1 ]
   then
      num=0"$num"
   fi
   printf "%s" $num
}

# translate a char or byte to an int
ord() {
   echo -n "$1" | hexdump -v -e '"%d"'
}

# mask a message ($1) with a masking key ($2).
mask_msg() {
   msg=$1; msg_len=${#msg}
   mk=$2; mk_len=${#mk}

   masked=""

   for (( i=0; i<$msg_len; i++ ))
   #for i in `seq 2 $msg_len`
   do
      mk_i=`expr $i % $mk_len`

      msg_chr=${msg:$i:1}
      mk_chr=${mk:$mk_i:1}

      msg_int=`ord "$msg_chr"`
      mk_int=`ord "$mk_chr"`

      let "msg_int ^= $mk_int"

      chr_val="\x`dec_to_hex $msg_int`"
      masked+=$chr_val
   done
   echo -n -e $masked
}

# generate the opcode and message length for the message
make_header() {
   msg_size=${#1}
   first_byte="\x81"
   second_byte=128
   let "second_byte ^= $msg_size"
   second_byte=$(dec_to_hex $second_byte)
   echo -n -e "$first_byte\x$second_byte"
}

# start a local nc server to forward the handshake
# and message to the websocket server
# redirect to something other than /dev/null to see responses

nc -l -k -p $WS_LOCAL_PORT | nc $WS_SERVER $WS_PORT > /dev/null &
nc1_pid=$!
nc2_pid=`jobs -p`
echo -ne "$handshake" | nc localhost $WS_LOCAL_PORT

# message to send
msg="$1"

# generate a random 4-byte masking key
#masking_key="$(dd if=/dev/urandom bs=4 count=1 2> /dev/null)"

# Using stable, hard-coded key. Seems like some keys break message, maybe adding new lines?
masking_key="????"

# generate the header and mask the message
echo "Generating header..."
header=$(make_header "$msg")
#echo "Generating masked message..."
#masked_msg=$(mask_msg "$msg" "$masking_key")
echo "Concatenating packet..."
#to_send="$header$masking_key$masked_msg"
to_send="$header$msg"

echo ""
echo "-----"
echo $msg
#echo $masked_msg
echo "-----"


# echo ""
# echo "Header:"
# echo "----------"
# echo $header
# echo ""
# echo "Masking Key:"
# echo "----------"
# echo $masking_key
# echo ""
# echo "Message:"
# echo "----------"
# echo $masked_msg
# echo ""
# echo "Full:"
# echo "----------"
# echo $to_send
# echo ""

echo -n "$to_send" | nc localhost $WS_LOCAL_PORT

echo "Targeting:"
ps aux | grep "nc -l -k -p " | grep -v grep
processToKill=$(ps aux | grep "nc -l -k -p " | grep -v grep | awk '{print $2}')
echo "Killing PID: $processToKill"
sudo kill $processToKill