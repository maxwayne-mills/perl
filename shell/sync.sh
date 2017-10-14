#! /bin/sh

# Created December 26, 2015
# Script to backup Web directory to Rsync.net
# Created by Clarence Mills cmills@opensitesolutions.com
# Open Source license
# Relies on PKI public key installed on the remote end, if not you will be prompted
# to provide the password.

user=17847
server=ch-s011.rsync.net

case $1 in

backup)
	#Backkup to remote backup server
	echo "Backing up Web directory"
	rsync -arvz --delete /var/www/html/* $user@$server://data1/home/17847/web_sites/
	#rsync -arvz --delete /var/www/html/* 17847@ch-s011.rsync.net://data1/home/17847/web_sites/
	;;

restore)
	# Restore from Remote server
	echo "Restoring Web directory"
	rsync -avz $user@$server://data1/home/17847/web_sites/ /var/www/html/ 
	;;
list)
	# List remote directories on backup server
	echo "listing remote ...."
	ssh 17847@ch-s011.rsync.net ls -la $2
	;;

*)	
	echo "usage: basename $0 {backup | restore | list}"
	exit $1
	;;

esac
