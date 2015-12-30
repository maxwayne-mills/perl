#!/bin/sh 
set -xv 

# Publish from git to your web directory
# Repos
webdir=$3
repos=$2
dir=$3

create_archive()
{
	base=`basename $repos`
	#cd into repository
	cd $repos

	#Checkout dev repository
	git checkout dev

	#Create archinve
	sudo git archive --format=tar --output /tmp/$base.tar HEAD
	
	#Checkout the master head
	git checkout master
}

case $1 in

create)
	create_archive
	;;
publish)
	# Create the arhive
	create_archive
	
	#Clear out the directory
	sudo rm -rf $webdir/*

	# Untar the arive to destination directory
	base=`basename $repos`
	sudo tar -xvf /tmp/$base.tar -C $webdir --overwrite

	# List destination directory
	ls -lart $webdir
	;;
*)
	echo "usage: $basename $0 | publish <git repository> <web directory>"
	echo "usage: $basename $0 | create <git repository <web directory>"
	;;
esac
