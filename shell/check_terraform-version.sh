#!/bin/bash

clear
echo "Downloading terraform version information ..."
curl https://releases.hashicorp.com/terraform/ > terraformv
grep -i terraform terraformv | awk 'BEGIN {FS="/"};{print $3}' > tversion
version=$(sed '/^$/d' tversion | head -n 1)

echo ""
echo "Terraform version: $version available "
#echo ""
#curl https://releases.hashicorp.com/terraform/$version/ > versionv 
#cat versionv | grep -i linux | grep -i amd | grep -i "href="

# Cleanup
rm terraformv tversion 
