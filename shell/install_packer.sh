#!/bin/bash


ver="1.0.4"
link=https://releases.hashicorp.com/packer/"$ver"/packer_"$ver"_linux_amd64.zip
dlfile=packer_"$ver"_linux_amd64.zip
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
if [ -d ~/bin ];then
	echo "Moving packer binary ($image_name) to ~/bin"
	mv packer ~/bin
	echo ""
else 
	mkdir ~/bin
	echo "Moving packer binary ($image_name) to ~/bin"
	echo ""
fi

# Check to see if you can reference packer
echo "Checking if packer is installed - sending command "packer""
packer
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
