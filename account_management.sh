#!/bin/bash
 
user=cmills
 
usage(){
        echo "`basename $0` search username servername"
        echo "`basename $0` adduser "
}
 
check_username(){
#set -x
rmt_user=$1
clear
 
if [ -z $rmt_user ];then
        echo -n "Enter username to search for: "
        read rmt_user
        rmt_user=$user
        echo $rmt_user
else
        echo $rmt_user
fi
}
 
check_servername(){
#set -x
rmt_server=$1
clear
 
if [ -z $rmt_server ];then
        echo "Enter servername: "
        read server
        rmt_server=$server
        echo $rmt_server
else
        echo $rmt_server
fi
}
 
search(){
#set -vx

rmt_user=$1
rmt_server=$2
clear
if [ -z $file ];then
	echo "enter file"
	read file
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		# Searching /etc/passwd file 
		echo "Searching passwd file"
        	ssh $user@$rmt_server grep $rmt_user /etc/passwd
		echo ""
		# Searching /etc/group file 
		echo "Searching group file"
       		ssh $user@$rmt_server grep $rmt_user /etc/group
		echo ""
	done
else
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		# Searching /etc/passwd file 
		echo "Searching passwd file"
        	ssh $user@$rmt_server grep $rmt_user /etc/passwd
		echo ""
		# Searching /etc/group file 
		echo "Searching group file"
       		ssh $user@$rmt_server grep $rmt_user /etc/group
		echo ""
	done
fi
}

add-user(){
#set -xv
# Create hashed password
pass=`openssl passwd -crypt Temp1234`
clear

echo -n "Enter username: "
read username

echo -en "Enter Comment: "
read comment

echo -n "Enter UID: "
read uuid

echo -n "Enter GID: "
read groupid

echo -n "Enter home directory: "
read location

file=$2
if [ -z $file ];then
	echo  "enter file"
	read file
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo "Adding user:$username to /etc/group"
		ssh -tt $user@$rmt_server sudo groupadd $username -f -g $groupid
		echo "Creating $username acount on $rmt_server"
		ssh -tt $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
		echo ""
		ssh -tt $user@$rmt_server sudo chage -d 0 $username
		echo ""
	done
else
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo "Adding user:$username to /etc/group"
		ssh -tt $user@$rmt_server sudo groupadd $username -f -g $groupid
		echo "Creating $username acount on $rmt_server"
		ssh -tt $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
		echo ""
		ssh -tt $user@$rmt_server sudo chage -d 0 $username
		echo ""
	done
fi
}

delete-user(){
set -xv
username=$2
file=$3

if [ -z $file ];then
	echo "enter file"
	read file
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo "Deleting user: $username"
		ssh -tt $user@$rmt_server sudo userdel -f $username
		echo ""
	done
else
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo "Deleting user: $username"	
		ssh -tt $user@$rmt_server sudo userdel -f $username
		echo ""
	done
fi

}
 
# Start program
rmt_user=$2
rmt_server=$3
 
case $1 in
search|s|-s)
        check_username $rmt_user
        search $rmt_user $rmt_server
        ;;
add-user|adduser|-a|a)
	add-user
	;;
delete|userdel)
	delete-user $1 $2
	;;
*)
        usage
        ;;
esac
