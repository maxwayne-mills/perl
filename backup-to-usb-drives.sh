#!/bin/bash

# Backup files to a mounted sdcard
# Script created on a Ubuntu trusty OS
# Dependencies are rsync

# check to see if sdcard is mounted
dest=$(mount | grep -i sdcard | awk '{print $3}')
dest2=$(mount | grep -iw Lexar | awk '{print $3}')
dest3=$(mount | grep -iw Lexar1 | awk '{print $3}')
# find and use locally installed rsync binary
rsync=`which rsync`

# Check to see if the dest exists and is read and writeable
if [ $dest -a -rw ]; then
	rsync -avz ~/.ssh $dest/ssh-configs
	rsync -avz ~/.gitconfig $dest/git
	rsync -avz --exclude=VOICE --exclude=REC*.WAV --delete-excluded ~/Documents $dest/
	
	# Display free and used space.
	df -h $dest
else
	echo "sdcard is not mounted, insert and mount sdcard before proceeding"
fi 

# Check jump drive (Lexar)
if [ $dest2 -a -rw ]; then
	rsync -avz ~/Documents/personal/VOICE/*  $dest2/audio
else
	echo "Lexar drive "/media/oss/Lexar" is not mounted"
fi

# Check jump drive 2 (Lexar)
if [ $dest3 -a -rw ]; then
	rsync -avz ~/.ssh $dest3/ssh
	rsync -avz ~/.gitconfig $dest/git
	rsync -avz --exclude=VOICE --exclude=REC*.WAV --delete-excluded ~/Documents $dest/
else
	echo "Lexar jump drive 2 "/media/oss/Lexar1" is not mounted"
	exit
fi
