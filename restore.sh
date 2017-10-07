#!/usr/bin/env bash

user=$(whoami)

echo "Restoring SSH options"
if [ -d ~/.ssh ];then
	cp -Rvp /media/$user/Lexar/ssh/.ssh/* ~/.ssh
else	
	mkdir -v ~/.ssh
	cp -Rvp /media/$user/Lexar/ssh/.ssh/* ~/.ssh
fi

echo #Restroing Document files and folders
cp -Rvp /media/$user/Lexar/Documents/* ~/Documents
