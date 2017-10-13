#!/bin/bash 
## This script is to download and install slack

# Exit if any errors
set -e

## Variables
dir=$(pwd)
dl="https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb"

# Cleanup uncompleted downloads before exiting
trap 'echo - ""; "     removing uncompleted download"; rm slack.deb' SIGINT SIGTERM SIGtSTP

# Download slack for ubuntu
clear
echo "Downloading Slack from $dl"
echo ""
curl -o $dir/slack.deb $dl 

# Install slack
echo ""
echo -n "Installing Slack within $dir, do you want to continue Y or N ... "
read answer
if [ $answer == "y" -o "Y" ]; then
	sudo dpkg -i $dir/slack.deb
else
	echo "You chose No, exiting ..."
	exit 0
fi


