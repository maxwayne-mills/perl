#/bin/bash -eux
ver="1.9.1"
link="https://releases.hashicorp.com/vagrant/$ver/vagrant_"$ver"_x86_64.deb"
dlfile=vagrant_1.9.1_x86_64.deb
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')

# Get Vagrant: 
echo "Downloading vagrant: $image_name from $link ...."
curl -O $link 
echo ""

# Install vagrant
sudo dpkg -i $(pwd)/$dlfile && sudo apt-get install -f $(pwd)/$dlfile
# Check to see if you can reference vagrant
echo "Checking if vagrant is installed - sending command "vagrant""
vagrant --version
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
