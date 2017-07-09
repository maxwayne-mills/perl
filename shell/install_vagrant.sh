#/bin/bash -eux
ver="1.9.7"
link="https://releases.hashicorp.com/vagrant/$ver/vagrant_"$ver"_x86_64.deb"
dlfile=vagrant_"$ver"_x86_64.deb
image_name=$(echo $link | awk 'BEGIN {FS="\/"};{print $6}')
location=$(pwd)

clear
# Get Vagrant:
echo "Downloading vagrant: $image_name from $link ...."
echo ""
curl -O $link
echo ""

# Install vagrant
echo "InstalliNg vagrant version $dlfile"
sudo dpkg -i $location/$dlfile && sudo apt-get install -f $location/$dlfile

# Check to see if you can reference vagrant
echo "Checking if vagrant is installed - sending command "vagrant --version""
vagrant --version
echo ""

# Cleaning up
echo "Cleaning up - removing $dlfile"
rm -rf $dlfile
