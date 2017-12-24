#!/bin/bash

tversion="0.10.8"
dlfile="terraform_"$tversion"_linux_amd64.zip"
link="https://releases.hashicorp.com/terraform/$tversion/$dlfile"
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')

# Get terraform: 
echo "Downloading terraform: $image_name from $link ...."
curl -O $link 
echo ""

# unpack the downloaded zip file
echo "Unzipping $dlfile"
unzip $dlfile
echo ""

# Move to ~/bin
if [ -d ~/bin ];then
	echo "Moving terraform binary ($image_name) to ~/bin"
	mv terraform ~/bin
	echo ""
else 
	mkdir ~/bin
	echo "Moving terraform binary ($image_name) to ~/bin"
	echo ""
fi

# Check to see if you can reference terraform
echo "Checking if terraform is installed - sending command "terraform""
terraform version
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
