#!/bin/sh

# API used to manage and create Scaleway servers on CLI.
# Install SCW on local server/computer
# curl -L https://github.com/scaleway/scaleway-cli/releases/download/v1.1.0/scw-`uname -s`-`uname -m` > /usr/local/bin/scw
# authenticate: scw login --token=XXXXX --organization=YYYYY, credentials available from web UI in Scaleway


header(){
	echo "Scaleway API-SCW - www.scaleway.net "
	echo " "
	}

footer(){
	echo " "
	echo "				----			----				----				"
	}

list(){
	scw ps -a
	}

commands(){
	# Print only the server name.
	scw ps -a | awk '{print $1}' | awk 'NR==2'

	# start a particular server
	scw start `scw ps -a | grep srv4 | awk '{print $7}'`

	# Stop a particular server
	scw stop `scw ps -a | grep srv3 | awk '{print $7}'`

	# Wait for the server to be created and then start the server, image number required.
	scw start --wait `scw create ec6c0cd4`

	# Remove C1
	scw rm 680551f5
	}

case $1 in

list)
	# List servers
	header
	list
	footer
	;;
start)
	# Start all servers
	echo "Starting All servers"
	scw start --wait `scw ps -a | grep srv | awk '{print $7}'`
	list
	;;
stop)
	# Stop all servers
	echo "Stopping All servers"
	scw stop `scw ps -a | grep srv | awk '{print $7}'`
	echo ""
	list
	;;
images)
	# Print all images
	scw images -a --no-trunc=false
	;;
create)
	# Create server with selected image
	If $1
	scw start --wait `scw create $2`
	;;
*)
	echo "Usage: `basename $0` list | start | stop | images"
	;;
esac
