#!/bin/bash

# Create Ansible configuration file
if [ -f ansible.cfg ]; then
rm ansible.cfg
tee << EOF > ansible.cfg
[defaults]
retry_files_enabled = False
host_key_checking = False
roles_path = ansible/roles
#inventory = inventory

[ssh_connection]
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
scp_if_ssh = True
EOF
else
tee << EOF > ansible.cfg
[defaults]
retry_files_enabled = False
host_key_checking = False
roles_path = ansible/roles
#inventory = inventory

[ssh_connection]
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
scp_if_ssh = True
EOF
fi
