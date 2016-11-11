#!/bin/bash

# October 25, 2016
# Download and install terraform

version=terraform_0.7.10_linux_amd64.zip
versionnumber=$(echo $version | awk 'BEGIN {FS = "_"};{print $2}')
link=https://releases.hashicorp.com/terraform/$versionnumber/$version
dlfile=$version
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')
binhome="/home/oss/bin"

os=$(uname)
#Clear screen
clear

# Get terraform: 
echo ""
echo "Downloading terraform version $versionnumber: from $link ...."
echo ""
curl -O $link 
echo ""

# unpack the downloaded zip file
echo "Unzipping $dlfile"
if [ -d "$binhome" ]; then
	unzip -o $dlfile -d $binhome
	echo ""
else
	mkdir $binhome
	unzip $dlfile -o -d $binhome
fi	

# Check to see if you can reference terraform
echo "Checking if terraform is installed"
if [ -f $binhome/terraform ]; then
	echo "Found terraform, sending command terraform -v "
	terraform -v
else
	echo "Can't find terraform"
	exit 1
fi

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
