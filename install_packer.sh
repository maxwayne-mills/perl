#!/bin/bash

link=https://releases.hashicorp.com/packer/0.10.2/packer_0.10.2_linux_amd64.zip
dlfile=packer_0.10.2_linux_amd64.zip

# Get packer
echo "Downloading packger from $link ...."
curl -O $link 

# unpack the downloaded zip file
echo "Unzipping $dlfile"
unzip $dlfile

# Move to /usr/local/bin
sudo mv packer /usr/local/bin

# Check to see if you can reference packer
echo "Checking if packer is installing - sending command "packer""
packer

