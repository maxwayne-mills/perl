#!/bin/bash

# Script to create SSH Key
comment="cmills@opensitesolutions.com"
bits="4096"
keytype="rsa"
destdir=$(pwd)

#Check whether .ssh directory exists
if [ -d "$destdir/.ssh" ]; then
	echo "SSH Directory exists creating key"
	ssh-keygen -t $keytype -b $bits -C $comment -P "" -f "$destdir/.ssh/id_rsa"
	echo "IdentityFile $destdir/.ssh/id_rsa" >> "$destdir/.ssh/config"
else
	echo "Creating .ssh directory to store key"
	mkdir -v "$destdir/.ssh"
	ssh-keygen -t $keytype -b $bits -C $comment -P "" -f "$destdir/.ssh/id_rsa"
	echo "IdentityFile $destdir/.ssh/id_rsa" >> "$destdir/.ssh/config"
fi
