#!/bin/bash


host=192.168.1.240
app=$(basename $0)
file="Vagrantfile"
logfile=/home/oss/repos/vagrant/ubuntu-64/log.txt

ftp -vd $host > ftp.session 2> ftp.failed <<EOF
ascii
put $file
bye
EOF

if [ -f $file ];then
	# Check whether the file was sent
	filestatus=$(grep -i "successfully transferred" ftp.session)

	# Record whether file status code was found
	status=$? 

	# Change variable filestatus to register based on status code in ftp.session file
	if [ "$status" == "0" ];then
		filestatus="File transferred sucessfully"
		echo $app,$file,$filestatus >> $logfile
	else
		filestatus="Problem transferrring file"
		echo $app,$file,$filestatus >> $logfile
	fi
else
	filestatus="FTP failed"
	echo $app,$file,$filestatus >> $logfile
fi
	
	
