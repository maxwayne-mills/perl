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
	if [ -f Vagrantfile ];then
		$vg status
	else
 		$vg global-status --prune
	echo ""
	fi
fi
