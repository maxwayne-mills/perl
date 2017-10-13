#!/usr/bin/env bash

cd /tmp  
git clone git@github.com:sorah/envchain.git

#install dependencies
sudo apt-get -y install libsecret-1-0
sudo apt-get -y insall libsecret-1-dev
sudo apt-get -y install libsecret-common
sudo apt-get -y install libreadline-dev
sudo apt-get -y install libreeadline-common
sudo apt-get -y install readline-common

cd /tmp/envchain
make && make install
which envchain
