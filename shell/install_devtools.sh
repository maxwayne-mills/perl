#!/bin/bash

os=$(uname)

if [ "$os" = "Linux" ]; then
	sudo apt-get -y install tree
	sudo apt-get -y install golang
else
	sudo yum -y install tree
fi
