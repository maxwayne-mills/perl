#!/bin/bash

# Script to create SSH Key
comment="cmills@opensitesolutions.com"
bits="4096"
keytype="rsa"
destdir=$(pwd)

check_for_idkeys(){
dir=$(pwd)
if [ -f $dir/.ssh/id_rsa ] || [ -f $dir/.ssh/id_rsa.pub ]; then
	echo "ssh keys exist"
	exit 1
else
	echo "key don't exist"
fi
}

check_for_idkeys

Check whether .ssh directory exists
if [ -d "$destdir/.ssh" ]; then
	echo "SSH Directory exists creating key"
	check_for_idkeys
	ssh-keygen -t $keytype -b $bits -C $comment -P "" -f "$destdir/.ssh/id_rsa"
	echo "IdentityFile $destdir/.ssh/id_rsa" >> "$destdir/.ssh/config"
else
	echo "Creating .ssh directory to store key"
	mkdir -v "$destdir/.ssh"
	ssh-keygen -t $keytype -b $bits -C $comment -P "" -f "$destdir/.ssh/id_rsa"
	echo "IdentityFile $destdir/.ssh/id_rsa" >> "$destdir/.ssh/config"
fi
