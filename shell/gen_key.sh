#!/bin/bash

# Generate PKI keys

dir=/home/oss/.ssh/keys/
keysize=4096
type=rsa
com=oss@opensitesolutions.com

echo -n "Enter directory name: "
read file

ssh-keygen -t $type -b $keysize -C $com -f $dir/$file

ls -l $dir/$file*
cat $dir/$file.pub
