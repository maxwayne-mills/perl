# Script to backup Web directory to Rsync.net
#! /bin/sh -x

case $1 in

backup)
	#Backkup
	echo "Backing up Web directory"
	rsync -arvz --delete /var/www/html/* 17847@ch-s011.rsync.net://data1/home/17847/web_sites/
	;;

restore)
	# Restore
	echo "Restoring Web directory"
	rsync -avz 17847@ch-s011.rsync.net://data1/home/17847/web_sites/ /var/www/html/ 
	;;

*)	echo "usage: sync.sh restore | backup"
;;

esac
