#!/bin/bash 

# Tar,gzip and encrypt using gpg
object="$1"
rootdir=$(dirname $1)
objectname=$(basename $1)
encrypt="gpg -cv"

encrypt_directory(){
echo "Tar gzip directory"
tar -czvf $rootdir/$objectname.tar.gz $rootdir/$objectname
echo "Encrypting Directoy using GPG"
if [ -f $rootdir/$objectname.tar.gz ]; then
	$encrypt $rootdir/$objectname.tar.gz 
else
	echo "Directory did not get zipped"
	exit 1
fi

if [ -f $rootdir/$objectname.tar.gz.gpg ]; then
	echo "Cleaning up, removing $object"
	rm -rf $rootdir/$objectname.tar.gz
	rm -rf $rootdir/$objectname
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
