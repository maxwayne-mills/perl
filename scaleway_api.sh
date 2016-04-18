#!/bin/sh

# API used to manage and create Scaleway servers on CLI.
# obtain access key and token from scaleway portal.


header(){
	echo "Scaleway - www.scaleway.net "	
	echo " "
	}

footer(){
	echo " "
	echo "				----			----				----				"
	}

commands(){
	# Print only the server name.
	scw ps -a | awk '{print $1}' | awk 'NR==2'

	# stop a particular server
	scw start `scw ps -a | grep srv4 | awk '{print $7}'`

	# Stop a server
	scw stop `scw ps -a | grep srv3 | awk '{print $7}'`
	}

case $1 in

list)
	# List servers
	header
	scw ps -a
	footer
	;;
*)
	echo "`basename $0` usage: list"
	;;
esac
