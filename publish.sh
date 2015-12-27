#!/bin/sh -x
 
# Publish from git to your web directory

case $1 in

publish)
	# Cd into the repostiory of your choice
	cd /home/cmills/repos/git/web/office.opensitesolutions.com

	# Get status of the branch currently checked out and if there are any files that are note being tracked or committed
	git checkout dev

	# Create the arhive
	sudo git archive  --format=tar --output /tmp/office.tar HEAD

	# Untar the arive to destination directory
	sudo tar -xvf /tmp/office.tar -C /var/www/html/office.opensitesolutions.com --overwrite

	# List destination directory
		ls -lart /var/www/html/office.opensitesolutions.com
	;;
*)
	echo "usage: publish publish"
	;;
esac
