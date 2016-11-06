#!/bin/bash -ex

# Tar,gzip and encrypt using gpg
object="$1"
encrypt="gpg -cv"

encrypt_directory(){
echo "Tar gzip directory"
tar -czvf $(pwd)/$object.tar.gz $object
echo "Encrypting Directoy using GPG"
if [ -f $object.tar.gz ]; then
	$encrypt $(pwd)/$object.tar.gz 
else
	echo "Directory did not get zipped"
	exit 1
fi

if [ -f $(pwd)/$object.tar.gz.gpg ]; then
	echo "Cleaning up, removing $object"
	rm -rf $object.tar.gz
	rm -rf $object
fi
}

encrypt_file(){
 echo "Zip file"
 tar -cvf $object.tar.gz $object
 echo "Encrypt file using GPG"
 $encrypt $object.tar.gz
 status=$(echo $?)
 if [ "$status" = "0" ]; then
	echo "Cleaning up, removing $object"
	if [ -f $object.tar.gz.gpg ]; then
		rm -rf $object.tar.gz $object
	else
		echo "File did not encrypt"
	fi
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
