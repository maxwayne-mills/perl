#!/bin/bash

# Backup files to a mounted sdcard
# Script created on a Ubuntu trusty OS
# Dependencies are rsync

# Collect and check USB drive information
dest=$(mount | grep -i sdcard | awk '{print $3}')
dest2=$(mount | grep -iw Lexar | awk '{print $3}')
dest3=$(mount | grep -iw Lexar1 | awk '{print $3}')

# find and use locally installed rsync binary
rsync=`which rsync`

# Check to see if the dest exists and is read and writeable
if [ $dest -a -rw ]; then
	rsync -avz ~/.ssh $dest/ssh-configs
	rsync -auvp ~/.gitconfig $dest/git
	#rsync -auvp --exclude=VOICE --exclude=REC*.WAV --delete-excluded ~/Documents $dest/
	# Display free and used space.
	df -h $dest
else
	echo "sdcard is not mounted, insert and mount sdcard before proceeding"
fi 

# Check jump drive (Lexar)
if [ $dest2 -a -rw ]; then
	rsync -avz ~/Documents/  $dest2/Documents
	echo ""
	df -h $dest2
else
	echo "Lexar drive /media/oss/Lexar is not mounted"
fi

# Check jump drive 2 (Lexar)
if [ $dest3 -a -rw ]; then
	rsync -avz ~/.ssh $dest3/ssh
	rsync -avz ~/.gitconfig $dest3/git
	# Display free and used space.
	echo ""
	df -h $dest3
else
	echo "Lexar jump drive 2 /media/oss/Lexar1 is not mounted"
	exit
fi
