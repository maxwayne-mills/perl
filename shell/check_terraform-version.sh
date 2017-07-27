#!/bin/bash

clear
echo "Downloading terraform version information ..."
curl --write-out '%{http_code}' -s https://releases.hashicorp.com/terraform/ > terraformv
grep -i terraform terraformv | awk 'BEGIN {FS="/"};{print $3}' > tversion
version=$(sed '/^$/d' tversion | head -n 1)

echo ""
echo "Terraform version: $version is available "
echo "Your have version" $(terraform version)
# Cleanup
rm terraformv tversion 
