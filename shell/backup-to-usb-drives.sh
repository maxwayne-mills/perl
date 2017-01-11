#!/bin/bash

# Backup files to a mounted sdcard
# Script created on a Ubuntu trusty OS should work on any Linux OS.
# Dependencies are rsync

# Collect and check USB drive information
dest=$(mount | grep -i sdcard | awk '{print $3}')
dest2=$(mount | grep -iw Lexar | awk '{print $3}')
dest3=$(mount | grep -iw Lexar1 | awk '{print $3}')
options="-hrptuv --delete-before --delete-excluded --exclude /home/oss/Documents/voice/*"

# Sync password safe to in dropbox to google drive
clear
echo "Copying Password safe from Dropbox directory to google-drive"
cp ~/Dropbox/*.psafe3 ~/google-drive/
sleep 3

# find and use locally installed rsync binary
rsync=`which rsync`

# Check to see if the dest exists and is read and writeable
clear && echo "Backing up to $dest"
if [ $dest -a -rw ]; then
	echo ""&&  echo "Backing up .ssh directory"
	if [ -d $dest/ssh ];then 
		rsync $options ~/.ssh $dest/ssh
		sleep 3
	else
		mkdir $dest/ssh 	
		rsync $options ~/.ssh $dest/ssh
		sleep 3
	fi
		
	echo "" && echo "Backing up Git config directory"
	if [ -d $dest/git ];then 
		rsync $options ~/.gitconfig $dest/git
		sleep 3
	else
		mkdir $dest/git
		rsync $options ~/.gitconfig $dest/git
		sleep 3
	fi

	echo "" && echo "Backup passwd file"
	if [ -d $dest/passwordsafe ];then
		rsync $options ~/Dropbox/*.psafe3 $dest/passwordsafe
		sleep 3
	else 
		mkdir $dest/passwordsafe
		rsync $options ~/Dropbox/*.psafe3 $dest/passwordsafe
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
	rsync $options ~/Documents/  $dest2/Documents
	sleep 3

	echo "" && echo "Backing up .ssh directory"
	rsync $options ~/.ssh $dest/ssh-configs
	sleep 3

	echo "" && echo "Backing up Git config directory"
	rsync $options ~/.gitconfig $dest/git
	sleep 3

	echo "" && echo "Backup passwd file"
	if [ -d $dest2/passwordsafe ];then
		rsync $options ~/Dropbox/*.psafe3 $dest2/passwordsafe
		sleep 3
	else 
		mkdir $dest/passwordsafe
		rsync $options ~/Dropbox/*.psafe3 $dest2/passwordsafe
		sleep 3
	fi

	echo "" && echo "File System usage"
	df -h $dest2
else
	echo ""
	echo "Lexar drive /media/oss/Lexar is not mounted"
	sleep 3
fi

# Check jump drive 2 (Lexar)
clear && echo "Backing up to $dest3"
if [ $dest3 -a -rw ]; then
	echo "" && echo "Backing up Document directory"
	rsync $options ~/Documents/  $dest3/Documents
	sleep 3

	echo "Backing up .ssh directory"
	rsync $options ~/.ssh $dest3/ssh
	sleep 3

	echo "Backing up Git config directory"
	rsync $options ~/.gitconfig $dest3/git
	sleep 3

	echo "" && echo "Backup passwd file"
	if [ -d $dest3/passwordsafe ];then
		rsync $options ~/Dropbox/*.psafe3 $dest3/passwordsafe
		sleep 3
	else 
		mkdir $dest3/passwordsafe
		rsync $options ~/Dropbox/*.psafe3 $dest3/passwordsafe
		sleep 3
	fi

	echo "" && echo "File System usage"
	df -h $dest3
else
	echo "" &&  echo "Error"
	echo "Lexar jump drive 2 /media/oss/Lexar1 is not mounted"
	sleep 3
	exit
fi
