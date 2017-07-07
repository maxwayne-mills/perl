#/bin/bash
## Set up working enviroment 

# Clone ansible repository
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

# Create Vagrant file
echo "Enter Vagrant machine name: "
read vagrant_machine_name

echo "Listing your ethernet cards"
ifconfig
echo ""
echo "Enter wireless card name: "
read wifi_card

ansible-playbook playbooks/create_vagrant_file.yml -e "servername=localhost ip_address=192.168.1.254 vagrant_machine_name=$vagrant_machine_name wifi_card=$wifi_card" -vvvv

# Set up environment 
cd ../
mv /tmp/Vagrantfile .

# Copy setup file 
cp ~/repositories/scripts/shell/setup.yml .

if [ -f Vagrantfile ]; then
	vagrant up
else
	echo "can't find vagrant file"
	exit 1
fi
