#!/bin/bash

# Backup files to a mounted sdcard
# Script created on a Ubuntu trusty OS
# Dependencies are rsync

# check to see if sdcard is mounted
dest=$(mount | grep -i sdcard | awk '{print $3}')
# find and use locally installed rsync binary
rsync=`which rsync`

# Check to see if the dest exists and is read and writeable
if [ $dest -a -rw ]; then
	rsync -avz ~/.ssh $dest/ssh-configs
	rsync -avz ~/.gitconfig $dest/git
	rsync -avz --exclude=VOICE --exclude=REC*.WAV --delete-excluded ~/Documents $dest/
	
	# Display free and used space.
	df -h $dest
	exit 0
else
	echo "sdcard is not mounted, insert and mount sdcard before proceeding"
	exit 0
fi 
