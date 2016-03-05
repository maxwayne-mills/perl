#! /bin/sh
# Created Feb 13 2011
# Clarence Mills
# Dependent on external /usr/bin/rblcheck.pl
# Can be downloaded from http://www.salesianer.de/util/rblcheck.html

option=$1
question=$2

case $option in
rbl )
        # Ip address or FQDN of server would be an option that is passed in
	# show only where the IP is listed
        /usr/bin/rblcheck.pl IP $question | grep -i "$question rbl"
        ;;
*)
	echo "usage"
;;
esac
