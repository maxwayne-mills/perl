#!/bin/sh -x
 
# Publish from git to your web directory
# Repos
repos=/opt/git/web
dir=$2

case $1 in

publish)
	# Cd into the repostiory of your choice
	cd $repos/$2

	# Get status of the branch currently checked out and if there are any files that are note being tracked or committed
	git checkout dev

	# Create the arhive
	sudo git archive  --format=tar --output /tmp/office.tar HEAD

	# Untar the arive to destination directory
	sudo tar -xvf /tmp/$2.tar -C /var/www/html/office.opensitesolutions.com --overwrite

	# List destination directory
		ls -lart /var/www/html/office.opensitesolutions.com
	;;
*)
	echo "usage: $basename $0 | publish"
	;;
esac
