#!/bin/bash -x

check=$(ping -c 1 www.google.com)
echo "$check"

if [ "$check" == "ping: unknown host www.google.com" ];then
	echo "not connecected"
else
	echo "connected"
fi
