#!/bin/bash

os=$(uname)

if [ "$os" = "Linux" ]; then
	sudo apt-get -y install tree
else
	sudo yum -y install tree
fi
