#!/bin/sh 
set -xv 

# Publish from git to your web directory
# Repos
webdir=/var/www/html
repos=/opt/git/web
dir=$2

create_archive()
{
	base=$dir
	#cd into repository
	cd $repos/$base

	#Checkout dev repository
	sudo git archive --format=tar --output /tmp/$base.tar HEAD
}

case $1 in

create)
	create_archive
	;;
publish)
	# Create the arhive
	create_archive

	# Untar the arive to destination directory
	base=$dir
	sudo tar -xvf /tmp/$base.tar -C $webdir/$base --overwrite

	# List destination directory
	ls -lart $webdir/$dir
	;;
*)
	echo "usage: $basename $0 | publish <path to git repository"
	;;
esac
