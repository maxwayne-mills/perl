#!/bin/bash

# Tar,gzip and encrypt using gpg
object="$1"

encrypt_directory(){
 echo "Tar / gzip directory"
 tar -czvf $object.tar.gz $object
 echo "Encrypting Directoy using GPG"
 gpg -c $object.tar.gz
 status=$(echo $?)
 if [ "$status" = 0 ]; then
	echo "Cleaning up, removing $object"
	rm -rf $object.tar.gz $object
 else
	File did not encrypt
 fi
}

encrypt_file(){
 echo "Encrypt file using GPG"
 gpg -c $object.tar.gz
 status=$(echo $?)
 if [ "$status" = 0 ]; then
	echo "Cleaning up, removing $object"
	rm -rf $object.tar.gz $object
 else
	File did not encrypt
 fi
}


if [ -z $object ]; then
	echo "Enter file or directory to encrypt"
	read object
	if [ -d $object ]; then
		echo "Call encrypt directory"
		encrypt_directory
	else
		echo "encryptng file"
		encrypt_file
	fi
else
	if [ -d $object ]; then
		echo "Call encrypt directory"
		encrypt_directory
	else
		echo "encryptng file"
		encrypt_file
	fi
fi

