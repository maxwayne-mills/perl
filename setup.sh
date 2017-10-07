#!/usr/bin/env bash

# Exit if any errors
set -e
clear

echo updating and upgrading packages
sudo apt-get -y update
sudo apt-get -y upgrade

# Install Application
sudo apt-get -y install tree
sudo apt-get -y install rsync
sudo apt-get -y install curl
sudo apt-get -y install git
sudo apt-get -y install python-pip
sudo apt-get -y install screen
#sudo apt-get -y install google-drive-ocamlfuse
sudo apt-get -y install golang

# Liquid-prompt requirement
sudo apt-get -y install acpi
# Install liquid-prompt
cd /tmp
git clone https://github.com/nojhan/liquidprompt.git
cp -Rvp /tmp/liquidprompt ~/bin
source ~/bin/liquidprompt/liquidprompt

# Set permissions
sudo chown -R cmills:cmills ~

# upgrade pip
pip install --upgrade pip

# Install Ansible
sudo pip install ansible

cd /tmp
git clone https://github.com/maxwayne-mills/workstation.git
cd workstation/system-setup
# Install aliases
cp bash_aliases ~/.bash_aliases
cp  gitconfig ~/.gitconfig

# Creature compfort stuff
gsettings set com.canonical.Unity.Launcher launcher-position Bottom

cd /tmp
git clone https://github.com/maxwayne-mills/scripts.git
cd /tmp/scripts/shell

cp show_wireless.sh ~/bin
cp manage-vm.sh ~/bin
cp manage_virt.sh ~/bin
cp backup-to-usb-drives.sh ~/bin

# Install Packer
./packer_install.sh

# Install Terraform
./terraform_install.sh

# Install vagrant
./install_vagrant.sh

# Install Vault
./install_vault.sh

# Install Atom
cd /tmp
echo "Installing Atom"
curl -L https://atom.io/download/deb/ --progress-bar -o atom.deb
sudo dpkg -i atom.deb
rm atom.deb

## This script is to download and install slack
dir=$(pwd)
dl="https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb"

# Cleanup uncompleted downloads before exiting
trap 'echo - ""; "     removing uncompleted download"; rm slack.deb' SIGINT SIGTERM SIGtSTP

# Download slack for ubuntu
clear
echo "Downloading Slack from $dl"
echo ""
curl -o $dir/slack.deb $dl 

# Install slack
echo ""
echo -n "Installing Slack within $dir, do you want to continue Y or N ... "
read answer
if [ $answer == "y" -o "Y" ]; then
	sudo dpkg -i $dir/slack.deb
else
	echo "You chose No, exiting ..."
	exit 0
fi

## Install dropbox
# link: https://www.dropbox.com/install-linux
arch=$(uname -a | awk 'BEGIN {fs=" "};{print $12}')
if [ "$arch" = "x86_64" ];then
	dropboxlink=https://www.dropbox.com/download?plat=lnx.x86_64
	cd ~ && wget -O - $dropboxlink | tar xzvf - 
	
	echo "Starting dropbox"
	~/.dropbox-dist/dropboxd &
	curl -L  https://www.dropbox.com/download?dl=packages/dropbox.py --progress-bar -o dropbox.py
	mv dropbox.py ~/bin
	chmod +x ~/bin/dropbox.py
else
	droplink=https://www.dropbox.com/download?plat=lnx.x86_64
	cd ~ && wget -O - $droplink | tar xzvf - 
	
	echo "Starting dropbox"
	~/.dropbox-dist/dropboxd &
	curl -L  https://www.dropbox.com/download?dl=packages/dropbox.py --progress-bar -o dropbox.py
	mv dropbox.py ~/bin
	chmod +x ~/bin/dropbox.py
fi

# Install passsword gorilla
curl -L http://ftp.us.debian.org/debian/pool/main/p/password-gorilla/password-gorilla_1.5.3.7-1_all.deb --progress-bar -o password-gorilla.deb
sudo dpkg -i password-gorilla.deb

# Cleanup
rm -rf /tmp/workstation
rm -rf /tmp/liquidprompt
rm -rf /tmp/lscript
echo "Finished"
