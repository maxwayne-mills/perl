#!/bin/bash

date=$(date +%G-%b-%d)
mediahome=/media/oss
destination=~/Documents/voice

check_destination(){
# Check if destination directory exist
if [ -d $destination ]; then
	echo ""	
	status="0"
	echo $status
else
	echo "$destination does not exist, creating $destination ..."
	mkdir -v $destination
	status="$?"
	echo $status
fi
}


transfer(){
ls -l $mediahome/RECORD/
if [ -d $mediahome/RECORD/RECORD ]; then
	echo "exist transfering files .."
	mv -v $mediahome/RECORD/RECORD/* $destination/$date/$dir/
	
else
	exit 0
fi
}

if [ -d  $mediahome/RECORD ]; then
	echo "Media mounted"
	check_destination
	if [ "$status" = "0" ]; then
		mkdir -v $destination/$date
		echo "Enter directory name"
		read dir
		if [ -z $dir ]; then
			echo "Nothing entered exiting"
			exit 0
		else
			mkdir -v $destination/$date/$dir
			echo $dir
			transfer
		fi
	fi	
else
	echo "Media not mounted"
	exit 0
fi

