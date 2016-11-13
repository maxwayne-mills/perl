#!/bin/bash

# Generate PKI keys

dir=/home/oss/.ssh/keys
keysize=4096
type=rsa
com=oss@opensitesolutions.com

clear
echo -n "Enter directory name: "
read  directory
if [ -d "$dir/$directory" ];then
	echo -n "Enter file to store PKI keys: "
	read file
	ssh-keygen -t $type -b $keysize -C $com -f $dir/$directory/$file
else
	mkdir -v $dir/$directory
	echo -n "Enter file to store PKI keys: "
	read file
	ssh-keygen -t $type -b $keysize -C $com -f $dir/$directory/$file
fi

ls -l $dir/$directory/*
cat $dir/$directory/$file.pub
