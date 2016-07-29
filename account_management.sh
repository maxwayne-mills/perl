#!/bin/bash
# Created July 5 2016
# Author: Clarence Mills
# Depeendency: PKI key in place on each remote-server to provide secure passwordless connection
# Sudo files in place to allow usage of User account managment applications
 
user=cmills
 
usage(){
	scriptname=`basename $0`
	echo ""
	echo "Scotiabank Account management script for managing user accounts on Linux systesms"
	echo "Remote user accounts are created and modified on mass from this central server (`hostname`)." 
	echo ""
	echo "Usage: $scriptname [Options]"
	echo ""
	echo "Options:"
        echo -e "  -a | adduser \t\t\t Add users to systems(s)"
        echo -e "  -c | check username \t\t Show user details."
	echo -e "	\t\t\t Show account Status"
	echo -e "	\t\t\t Show pamtally2 status"
	echo ""
        echo -e "  -d | delete-user username \t Delete users from the system"
	echo -e "  -h | help \t\t\t Display this help message"
	echo -e "  -m | maintenance \t\t Administration of user account"
	echo -e "	\t\t\t Reset passwords"
	echo -e "	\t\t\t Lock Account"
	echo -e "	\t\t\t Unlock Account"
	echo -e "	\t\t\t PamTally2 reset"
	echo -e "	\t\t\t Add account to additional Groups"
	echo -e "	\t\t\t Change primary group"
	echo ""
        echo -e "  -s | search username \t\t Search /etc/passwd and /etc/group for username"
	echo ""
	echo "Example:"
	echo -e "  $scriptname adduser"
	echo -e "  $scriptname -a"
	echo ""
	echo -e "  $scriptname delete-user jdoe"
	echo -e "  $scriptname -d jdoe"
	echo ""
	echo -e "  $scriptname search jdoe"
	echo -e "  $scriptname -s jdoe"
	echo ""
	echo -e "  $scriptname check jdoe"
	echo -e "  $scriptname -c jdoe"
	echo ""
	echo -e "  $scriptname maintenance"
	echo -e "  $scriptname -m"
	echo ""
	echo -e "Note:"
	echo "When prompted you will be required to enter the complete path to a file containing IP addresses or hostname of the servers which will be used for account modification."
}
 
check_username(){
#set -x
rmt_user=$1
clear
 
if [ -z $rmt_user ];then
        echo -n "Enter username you would like to search for on $rmt_server: "
        read rmt_user
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
clear
}
 
search(){
#set -vx

rmt_user=$1
rmt_server=$2
clear

if [ -z $file ];then
	echo "Enter name of the file containing the list of servers"
	read file
	echo ""
	for line in $(cat $file); do
		echo "Connected to $line"
		rmt_server=$line
		echo ""
		# Searching /etc/passwd file 
		echo "Searching passwd file"
        	ssh -q $user@$rmt_server grep $rmt_user /etc/passwd
		echo ""
		# Searching /etc/group file 
		echo "Searching group file"
       		ssh -q $user@$rmt_server grep $rmt_user /etc/group
		echo ""
	done
else
	for line in $(cat $file); do
		echo "Connected to $line"
		rmt_server=$line
		echo ""
		# Searching /etc/passwd file 
		echo "Searching passwd file"
        	ssh -q $user@$rmt_server grep $rmt_user /etc/passwd
		echo ""
		# Searching /etc/group file 
		echo "Searching group file"
       		ssh -q $user@$rmt_server grep $rmt_user /etc/group
		echo ""
	done
fi
}

add-user(){
#set -xv

# Create hashed password
pass=`openssl passwd -crypt Temp1234`
today=`date +%Y-%m-%d`
clear

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

file=$2
if [ -z $file ];then
	echo  "enter file"
	read file
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo ""
		echo "Adding user:$username to /etc/group"
		ssh -q -t $user@$rmt_server sudo groupadd $username -f -g $groupid
		echo ""
		echo "Creating $username on $rmt_server"
		ssh -q -t $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
		echo $?
		ssh -q -t $user@$rmt_server sudo chfn -f "$comment" $username
		echo $?
		ssh -q -t $user@$rmt_server sudo chage -d0 $username
		echo $?
		# Set account expiration date 
		ssh -q -t $user@$rmt_server sudo chage -E $today -m 90 -M 90 $username

		# Specify inactive days after password expires
		ssh -q -t $user@$rmt_server sudo chage -I 3 $username

		# Sety warning days before password expires
		ssh -q -t $user@rmt_server sudo chage -W 7 $username
		echo $?
	done
else
	for line in $(cat $file); do
		echo "Connected to $line"
		rmt_server=$line
		echo ""
		echo "Adding user:$username to /etc/group"
		ssh -q -t $user@$rmt_server sudo groupadd $username -f -g $groupid
		echo ""
		echo "Creating $username on $rmt_server"
		ssh -q -t $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
		echo $?
		ssh -q -t $user@$rmt_server sudo chfn -f "$comment" $username
		echo $?
		ssh -q -t $user@$rmt_server sudo chage -d0 $username
		echo $?
		# Set account expiration date 
		ssh -q -t $user@$rmt_server sudo chage -E $today -m 90 -M 90 $username

		# Specify inactive days after password expires
		ssh -q -t $user@$rmt_server sudo chage -I 3 $username

		# Sety warning days before password expires
		ssh -q -t $user@rmt_server sudo chage -W 7 $username
		echo $?
	done
fi
}

delete-user(){
#set -xv
rmt_user=$1

if [ -z $file ];then
	echo "Enter file containning list of servers"
	read file
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo ""
		echo "Deleting user: $rmt_user on $rmt_server"
		ssh -q -t $user@$rmt_server sudo userdel -fr $rmt_user
		echo $?
	done
else
	for line in $(cat $file); do
		echo "$line"
		rmt_server=$line
		echo ""
		echo "Deleting user: $rmt_usere on $rmt_server"	
		ssh -q -t $user@$rmt_server sudo userdel -fr $rmt_user
		echo $?
	done
fi

}

check(){
rmt_user=$1

if [ -z $rmt_user ];then
	echo -n "Enter username: "
	read rmt_user
fi

if [ -z $file ]; then
	echo -n "Enter file containing list of servers: "
	read file
	for line in $(cat $file); do
		rmt_server=$line
		echo ""
		echo "User: $rmt_user on Server:$rmt_server"
		echo -n "Passwd file: " 
		ssh -q -t $user@$rmt_server grep $rmt_user /etc/passwd
		echo -n "User and groups: "
		ssh -q -t $user@$rmt_server sudo id $rmt_user
		echo ""
		echo "Account Status:"
		ssh -q -t $user@$rmt_server sudo chage -l $rmt_user
		echo ""
		echo "Login Status:"
		ssh -q -t  $user@$rmt_server sudo pam_tally2 --user=$rmt_user
	done
else
	for line in $(cat $file); do
		rmt_server=$line
		echo ""
		echo "User: $rmt_user on Server:$rmt_server"
		echo -n "Passwd file: "
		ssh  $user@$rmt_server grep $rmt_user /etc/passwd
		echo -n "User and groups: "
		ssh -q -t  $user@$rmt_server sudo id $rmt_user
		echo ""
		echo "Account Status:"
		ssh -q -t $user@$rmt_server sudo chage -l $rmt_user
		echo ""
		echo "Login Status:"
		ssh -q -t $user@$rmt_server sudo pam_tally2 --user=$rmt_user
		echo ""
	done
fi
}

reset-pass(){
#set -x
# Create hashed password
pass=`openssl passwd -crypt Temp1234`

echo -n "Enter username: "
read username

echo -n "Enter file: "
read file

for line in $(cat $file); do
	rmt_server=$line
	echo ""
	echo "Setting password to corporate default for $username on $rmt_server"
	ssh -q -t $user@$rmt_server sudo usermod -p $pass $username
	result="$?"	

	if [ $result == 0 ]; then
		echo "Password reset to default for $username"
	else
		echo "Password reset not completed for $username."
	fi
done
}

lock-account(){
echo -n "Enter username: "
read username

echo -n "Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
        echo "Connected to $rmt_server:"
        echo "$username account will be locked on $rmt_server"
        ssh -q -t $user@$rmt_server sudo usermod -L $username
        result="$?"

	if [ $result == 0 ]; then
        	echo "$username account is locked"
	else
        	echo "Could not lock account for $username"
	fi
done
}

unlock-account(){
echo -n "Enter username: "
read username

echo -n "Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
        echo "Connected to $rmt_server:"
        echo "$username account will be ulocked on $rmt_server"
        ssh -q -t $user@$rmt_server sudo usermod -U $username
        result="$?"

	if [ $result == 0 ]; then
       		echo "User:$username account is unlocked"
	else
        	echo "Could not unlock account"
	fi
done
}

pamtally2(){
echo -n "Enter username: "
read username

echo -n "Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
	echo ""
        echo "$username account will be reset on $rmt_server"
        ssh -q -t $user@$rmt_server sudo pam_tally2 --user=$username --reset
        result="$?"

	if [ $result == 0 ]; then
        	echo "$username account reset"
	else
        	echo "Could not reeset account"
	fi
done
}

addtogroup(){
echo -n "Enter user name: "
read username

echo -n "Seperate multiple groups by comma's"
echo -n "Enter group name: "
read group

echo -n "Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
        echo "Adding $username to $group on $rmt_server"
        ssh -q -t $user@$rmt_server sudo usermod -a -G $group $username
        result="$?"
done

if [ $result == 0 ]; then
	echo ""
        echo "$username added to $group on $rmt_server"
	ssh -q -t $user@$rmt_server sudo id $username
else
        echo "Could not add $username to $group"
fi
}

changeprimarygroup(){
echo -n "Enter user name: "
read username

echo -n "Enter group name: "
read group

echo -n "Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
	echo ""
        echo "Change primary group for $username to $group on $rmt_server"
        ssh -q -t $user@$rmt_server sudo usermod -g $group $username
        result="$?"
	if [ $result == 0 ]; then
		echo ""
        	echo "$username changed primary group to $group"
        	ssh -q -t $user@$rmt_server sudo id $username
	else
        	echo "Could not change to $group"
	fi
done
}

maintenance(){

menu(){

	clear
	echo -e ""
        echo -e "\t\t\t ---------------------------"
        echo -e "\t\t\t    Account Administration  "
        echo -e "\t\t\t ---------------------------"
	echo -e ""
        echo -e "\t\t\t 1. Reset password"
        echo -e "\t\t\t 2. Lock Account  "
        echo -e "\t\t\t 3. Unlock Account"
        echo -e "\t\t\t 4. Pam Tally2 reset"
        echo -e "\t\t\t 5. Add user to group"
        echo -e "\t\t\t 6. Change Primary Group"
        echo -e "\t\t\t 7. Check account status"
        echo -e "\t\t\t 8. Exit"
	echo -e ""
}

	menu
	echo -en "\t\t\t Enter selection from 1-8: "
	read choice
	case $choice in
	1)
		reset-pass
		;;
	2)
		lock-account
		;;
	3)
		unlock-account
		;;
	4)
		pamtally2
		;;
	5)
		addtogroup
		;;
	6)
		changeprimarygroup
		;;
	7)
		check 
		;;
	8)
		exit 0
		;;
	*)	
		menu
		;;
	esac
}
 
# Start program
rmt_user=$2
rmt_server=$3
 
case $1 in
add-user|-a)
	add-user
	;;
delete-user|-d)
	if [ -z $rmt_user ]; then
		echo "Missing paramaters"
		echo ""
		usage
		exit 1
	else
		delete-user $2
	fi
	;;
search|-s)
	check_username $rmt_user
	search $rmt_user $rmt_server
	;;
check|-c)
	if [ -z $rmt_user ]; then
        	echo "Enter username: "
		read rmt_user
	else
       		 continue
	fi

	
	check $rmt_user
	;;
maintenance|-m)
 	maintenance
	;;	
-h|help|*)
        usage
        ;;
esac
