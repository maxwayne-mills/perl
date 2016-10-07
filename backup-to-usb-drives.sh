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
clear && echo "Backing up to $dest"
if [ $dest -a -rw ]; then
	echo ""&&  echo "Backing up .ssh directory"
	if [ -d $dest/ssh ];then 
		rsync -avz ~/.ssh $dest/ssh
		sleep 3
	else
		mkdir $dest/ssh 	
		rsync -avz ~/.ssh $dest/ssh
		sleep 3
	fi
		
	echo "" && echo "Backing up Git config directory"
	if [ -d $dest/git ];then 
		rsync -avz ~/.gitconfig $dest/git
		sleep 3
	else
		mkdir $dest/git
		rsync -avz ~/.gitconfig $dest/git
		sleep 3
	fi

	echo "" && echo "Backup passwd file"
	if [ -d $dest/passwordsafe ];then
		rsync -avz ~/Documents/*.psafe3 $dest/passwordsafe
		sleep 3
	else 
		mkdir $dest/passwordsafe
		rsync -avz ~/Documents/*/psae3 $dest/passwordsafe
		sleep 3
	fi
	
	echo "" && echo "File System usage"
	df -h $dest
else
	echo "sdcard is not mounted, insert and mount sdcard before proceeding"
	sleep 3
fi 

# Check jump drive (Lexar)
clear && echo "Backing up to $dest2"
if [ $dest2 -a -rw ]; then
	echo "" &&  echo "Backing up Document Directory"
	rsync -avz ~/Documents/  $dest2/Documents
	sleep 3
	echo "" && echo "Backing up .ssh directory"
	rsync -avz ~/.ssh $dest/ssh-configs
	sleep 3
	echo "" && echo "Backing up Git config directory"
	rsync -avz ~/.gitconfig $dest/git
	sleep 3
	echo "" && echo "File System usage"
	df -h $dest2
else
	echo ""
	echo "Lexar drive /media/oss/Lexar is not mounted"
	sleeep 3
fi

# Check jump drive 2 (Lexar)
clear && echo "Backing up to $dest3"
if [ $dest3 -a -rw ]; then
	echo "" && echo "Backing up Document directory"
	rsync -avz ~/Documents/  $dest3/Documents
	sleep 3
	echo "Backing up .ssh directory"
	rsync -avz ~/.ssh $dest3/ssh
	sleep 3
	echo "Backing up Git config directory"
	rsync -avz ~/.gitconfig $dest3/git
	sleep 3
	echo "" && echo "File System usage"
	df -h $dest3
else
	echo "" &&  echo "Error"
	echo "Lexar jump drive 2 /media/oss/Lexar1 is not mounted"
	sleep 3
	exit
fi
