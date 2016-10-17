#!/bin/bash

link=https://releases.hashicorp.com/vault/0.6.2/vault_0.6.2_linux_amd64.zip
dlfile=vault_0.6.2_linux_amd64.zip
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')

# Get vault: 
echo "Downloading vault: $image_name from $link ...."
curl -O $link 
echo ""

# unpack the downloaded zip file
echo "Unzipping $dlfile"
unzip $dlfile
echo ""

# Move to ~/bin
if [ -d ~/bin ];then
	echo "Moving vault binary ($image_name) to ~/bin"
	mv vault ~/bin
	echo ""
else 
	mkdir ~/bin
	echo "Moving vault binary ($image_name) to ~/bin"
	echo ""
fi

# Check to see if you can reference vault
echo "Checking if vault is installed - sending command "vault""
vault
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
