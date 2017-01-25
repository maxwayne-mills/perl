#!/bin/bash

vb=$(which VBoxManage)
vg=$(which vagrant)

if [ -z "$vg" ]; then
	echo "Virtualbox is not installed"
else
	# Show virtualbox vms 
	echo "Show Virutalbox Virtual Machines"
	echo "============================="
	$vb list vms
fi

if [ -z "$vg" ]; then
	echo "Vagrant is not installed"
else
	echo ""
	echo "Show Status of Vagrant images"
	echo "============================="
	echo ""

	# Check whether this is a vagrant environment
	if [ -f Vagrantfile ]; then
		# Found Vagrant file - List vagrant machines from Vagrant file
		$vg status

		echo ""
		echo "All Vagrant machines"
 		$vg global-status --prune
	else
		# Did not fing Vagrant file - list vagrant machines registered if any.
		echo "All Vagrant machines"
 		$vg global-status --prune
		echo ""
	fi
fi
