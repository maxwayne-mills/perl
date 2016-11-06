#!/bin/bash -x

options="-q"
connect="ssh $options"
file=servers.txt

for line in $( cat $file); do
	serveros=$($connect $line uname)
	if [ "$serveros" != "Linux" ]; then
		echo "$line: Not linux"
	else
		echo "$line: Linux server"
	fi
done
