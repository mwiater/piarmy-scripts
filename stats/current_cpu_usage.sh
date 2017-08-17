#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)
# Usage: . stats/current_cpu_usage.sh
 
PREV_TOTAL=0
PREV_IDLE=0
 

CPU=(`sed -n 's/^cpu\s//p' /proc/stat`)
IDLE=${CPU[3]} # Just the idle CPU time.

# Calculate the total CPU time.
TOTAL=0
for VALUE in "${CPU[@]}"; do
  let "TOTAL=$TOTAL+$VALUE"
done

# Calculate the CPU usage since we last checked.
let "DIFF_IDLE=$IDLE-$PREV_IDLE"
let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
echo -en "$DIFF_USAGE\n"