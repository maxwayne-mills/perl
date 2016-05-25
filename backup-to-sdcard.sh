#!/bin/bash
# Back up files to sdcard

# check to see if sdcard is mounted
dest=$(mount | grep -i sdcard | awk '{print $3}')
# find and use locally installed rsync binary
rsync=`which rsync`

if [ $dest ]; then
	rsync -avz ~/.ssh $dest/ssh-configs
	rsync -avz ~/.gitconfig $dest/git
	rsync -avz --exclude=REC*.WAV --delete-excluded ~/Documents $dest/
	#tree $dest/
	du -hs $dest
	exit 0
else
	echo "sdcard is not mounted, insert and mount sdcard before proceding"
	exit 0
fi 
