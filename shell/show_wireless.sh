#!/bin/bash

# list wireless card output
clear
iwconfig 
nmcli dev wifi

echo ""
echo "Show link quality"
#watch -n 1 cat /proc/net/wireless
cat /proc/net/wireless
