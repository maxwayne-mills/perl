#!/bin/bash  
## Script to create/manage Virtual environments using 
## Virtualbox, vagrant, ansible

## 
set -xv

marker="## Created by OpenSiteSolutions: $(basename $0)"
file=Vagrantfile

# list installed vagrant box's
list_box(){
vagrant box list | sort -u | awk '{print $1}'
}

build_vagrantfile(){
vm-box=$1
vm-name=$2
	echo "Creating Vagranfile"
	echo $marker >> $file
	echo "" >> $file
	echo "Vagrant.configure(\"2\") do |config|" >> $file
  	echo -e "\tconfig.vm.box = \"\$vm-box\"" >> $file
	echo -e "\tconfig.vm.hostname = \"\$vm-name\"" >> $file
	echo -e "\tconfig.vm.provider \"virtualbox\" do |virt0|" >> $file
	echo -e "\t\tvirt0.memory = \"1024\"" >> $file
	echo -e "\t\tvirt0.name = \"\$vm-name\"" >> $file
	echo -e "\t\tvirt0.gui = false" >> $file
  	echo -e "\tend" >> $file
	echo "end" >> $file
}

case $1 in
-c)
	clear
	#check if there's an existing $file

	echo "Existing Vagrant box's available"
	echo "================================"
	echo ""

	list_box
	echo ""

	echo -n "Enter name of vagrant box"
	read box 

	echo -n "Enter name of the server"
	read server


	if [ -f "$file" ]; then
		echo "Direcoty: $(pwd)"
		echo "Found existing vagrant $file, remove it"
		echo -n "If you choose Y, then this will also destroy the existing environment Y/N: "
		read value
		if [ "$value" == "Y" -o "$value" == "y" ]; then
			echo "Destroying current vagrant file and environment"
			vagrant destroy -f
			rm $file
			build_vagrantfile $box $server
		else
			echo "Not removing current file creating new file $file.new"
			file="Vagrantfile.new"
			echo "Creating $file.new"
			if [ -f $file.new ]; then
				rm $file.new
				build_vagrantfile $box $server
				cat $file.new
			else
				build_vagrantfile $box $server
				cat $file.new
			fi
			exit 0
		fi
	fi

	echo ""
	echo -n "Do you want to bring up the environment Y/N ?:"
	read value

	if [ "$value" == "Y"  -o "$value" == "y" ]; then
		echo "Bringing up the environment and logging you in"
		vagrant up && vagrant ssh
	else
		vagrant status
	fi
	;;
-svirtbox)
	VirtualBox
	;;
*)
	echo "$basename $0 | -c | -svirtbox"
	;;
esac
