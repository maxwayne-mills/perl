#!/bin/bash

link=https://releases.hashicorp.com/packer/0.10.2/packer_0.10.2_linux_amd64.zip
dlfile=packer_0.10.2_linux_amd64.zip
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')

# Get packer: 
echo "Downloading packer: $image_name from $link ...."
curl -O $link 
echo ""

# unpack the downloaded zip file
echo "Unzipping $dlfile"
unzip $dlfile
echo ""

# Move to /usr/local/bin
echo "Moving packer binary ($image_name) to /usr/local/bin"
sudo mv packer /usr/local/bin
echo ""

# Check to see if you can reference packer
echo "Checking if packer is installed - sending command "packer""
packer
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
