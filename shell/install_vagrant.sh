#/bin/bash -eux

link="https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.deb"
dlfile=vagrant_1.8.6_x86_64.deb
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')

# Get packer: 
echo "Downloading packer: $image_name from $link ...."
curl -O $link 
echo ""

# Install vagrant

# Check to see if you can reference packer
echo "Checking if packer is installed - sending command "packer""
packer
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile

