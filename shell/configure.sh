#/bin/bash
## Set up working enviroment 

echo "Creating Virtual environment"
sleep 1.5

# Clone ansible repository
echo "Dowloading Ansible git repository"
git clone git@github.com:becomeonewiththecode/ansible.git

## Create .ssh directory and private and public keys
key=$(which create_ssh_key.sh)

# Create keys to be imported within the environent, keys will need to be imported within GITHUB security settings.
clear
echo "Creating SSH keys .... "
$key
sleep 2.5

# Create Ansible inventory file
clear
echo "Creating Ansible configuration file"
cd ansible
echo "localhost  ansible_ssh_host=127.0.0,1" > inventory
sleep 2.5

# List vagrant box availble on system
echo "Listing local available Vagrant box's"
vagrant box list

echo -n "Select a vagrant box from the list above: "
read vbox_image

# Create Vagrant file
echo "Listing current vagrant servers"
vboxmanage list vms
echo ""
echo "Enter Vagrant machine name: "
read vagrant_machine_name

echo "Listing ethernet cards"
ifconfig
echo ""
echo "Enter wireless card name: "
read wifi_card

ansible-playbook playbooks/create_vagrant_file.yml -e "servername=localhost ip_address=192.168.1.254 vbox_image=$vbox_image vagrant_machine_name=$vagrant_machine_name wifi_card=$wifi_card" -vvvv

# Set up environment 
cd ../
mv /tmp/Vagrantfile .

# Copy setup file 
cp ~/repositories/scripts/shell/setup.yml .

if [ -f Vagrantfile ]; then
	echo "Do you want to start the Virtual enfironment"
	read answer
	if [ "$answer" == "Y" ] || [ $answer == "y" ]; then
		vagrant up
		vagrant status
		vagrant ssh-config
	else
		echo "Virtual environment built, exiting ...."
	fi
else
	echo "can't find vagrant file, exiting ... "
	exit 1
fi
