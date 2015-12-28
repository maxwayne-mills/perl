#!/bin/sh 
set -ex 

# Publish from git to your web directory
# Repos
repos=/opt/git/web
dir=$2

create_archive()
{
	#cd into repository
	cd $repos/$dir

	#Checkout dev repository
	sudo git archive --format=tar --output /tmp/$dir.tar HEAD
}

case $1 in

create)
	create_archive
	;;
publish)
	# Cd into the repostiory of your choice
	cd $repos/$dir

	# Get status of the branch currently checked out and if there are any files that are note being tracked or committed
	git checkout dev

	# Create the arhive
	sudo git archive  --format=tar --output /tmp/$dir.tar HEAD

	# Untar the arive to destination directory
	sudo tar -xvf /tmp/$dir.tar -C /var/www/html/$dir --overwrite

	# List destination directory
	ls -lart /var/www/html/$dir
	;;
*)
	echo "usage: $basename $0 | publish <path to git repository"
	;;
esac
