#!/bin/bash
 
user=cmills
 
usage(){
        echo "`basename $0` search username servername"
        echo "`basename $0` adduser username servername"
}
 
check_username(){
set -x
rmt_user=$1
 
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
set -x
rmt_server=$1
 
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
set -vx
rmt_user=$1
rmt_server=$2
	# Searching /etc/passwd file 
	echo "Searching passwd file"
        ssh $user@$rmt_server grep $rmt_user /etc/passwd
	# Searching /etc/group file 
	echo "Searching group file"
        ssh $user@$rmt_server grep $rmt_user /etc/group
}

add-user(){
set -xv

echo -n "Enter username: "
read username

echo -n "Enter Comment: "
read comment

echo -n "Enter UID: "
read uuid

echo -n "Enter GID: "
read groupid

echo -n "Enter home directory: "
read location

echo -n "Enter hostname: "
read host
rmt_server=$host

# Create hashed password
pass=`openssl passwd -crypt Temp1234`

# add user using /etc/group
#set -x

echo "Adding user:$user to /etc/group"
ssh -tt $user@$rmt_server sudo groupadd $username -f -g $groupid
echo $?

# add user to /etc/passwd
echo "Creating $user acount on $rmt_server"
ssh -tt $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
echo $?

# Expire password forcing the user to set password on first-login
ssh -tt $user@$rmt_server sudo chage -d 0 $username
echo $?

#Update GECOS files
ssh -tt $user@$rmt_server sudo chfn $username -o "$comment"
echo $?


}
 
# Start program
rmt_user=$2
rmt_server=$3
 
case $1 in
search|s|-s)
        check_username $rmt_user
        check_servername $rmt_server
        search $rmt_user $rmt_server
        ;;
add-user|-a|a)
	add-user
	;;

*)
        usage
        ;;
esac
