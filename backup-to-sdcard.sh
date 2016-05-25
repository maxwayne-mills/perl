#!/bin/bash
# Back up files to sdcard

# check to see if sdcard is mounted
dest=$(mount | grep -i sdcard | awk '{print $3}')
rsync=`which rsync`
if [ $dest ]; then
	ls -la $dest
	rsync -avz ~/.ssh $dest/ssh-configs
	rsync -avz ~/.gitconfig $dest/git
	rsync -avz --exclude=REC* --delete-after ~/Documents $dest/
else
	echo "sdcard is not mounted"
fi 
