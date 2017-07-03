#!/bin/bash

# list wireless card output
clear
iwconfig 
nmcli dev wifi
sleep 5

# Show link quality
echo "Showing link quality"
watch -n 1 cat /proc/net/wireless
