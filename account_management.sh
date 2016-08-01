#!/bin/bash
# Created July 5 2016
# Author: Clarence Mills
# Depeendency: PKI key in place on each remote-server to provide secure passwordless connection
# Sudo files in place to allow usage of User account managment applications
 
user=root
today=`date +%Y-%m-%d`
log=logfile-$today.txt
 
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
	echo -e "  -m | menu \t\t Administration of user account"
	echo -e "	\t\t\t Reset passwords"
	echo -e "	\t\t\t Lock Account"
	echo -e "	\t\t\t Unlock Account"
	echo -e "	\t\t\t PamTally2 reset"
	echo -e "	\t\t\t Add account to additional Groups"
	echo -e "	\t\t\t Change group ID"
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
	echo -e "  $scriptname menu"
	echo -e "  $scriptname -m"
	echo ""
	echo -e "Note:"
	echo "When prompted you will be required to enter the complete path to a file containing IP addresses or hostname of the servers which will be used for account modification."
}
 
check_username(){
#set -x
rmt_user=$1
 
if [ -z $rmt_user ];then
        echo -ne "\t\t\t Enter the username to search for. "
        read rmt_user
else
        echo $rmt_user
fi
}
 
check_servername(){
#set -x
rmt_server=$1
 
if [ -z $rmt_server ];then
        echo -ne "\t\t\t Enter servername. "
        read rmt_server
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

if [ -z $file ];then
	echo -ne "\t\t\t Enter filename containing the list of servers. "
	read file
	echo ""
	for line in $(cat $file); do
		rmt_server=$line
		echo $rmt_server

		# Search /etc/passwd file 
		echo -n "/etc/passwd file "
        	ssh -q $user@$rmt_server grep $rmt_user /etc/passwd
		if [ $? != 0 ];then
			echo "$rmt_user not found"
		fi

		# Searching /etc/group file 
		echo -n "/etc/group "
       		ssh -q $user@$rmt_server grep $rmt_user /etc/group
		if [ $? != 0 ];then
			echo "$rmt_user not found" 
		fi
		echo ""
	done
else
	for line in $(cat $file); do
		rmt_server=$line
		echo ""

		# Searching /etc/passwd file 
		echo "Searching passwd file on $rmt_server"
        	ssh -q $user@$rmt_server grep $rmt_user /etc/passwd
		if [ $? != 0 ];then
			echo "$rmt_user not found"
		fi
		echo ""

		# Searching /etc/group file 
		echo "Searching group file on $rmt_server"
       		ssh -q $user@$rmt_server grep $rmt_user /etc/group
		if [ $? != 0 ];then
			echo "$rmt_user not found"
		fi
		echo ""
	done
fi
}

add-user(){
#set -xv
# Create hashed password
pass=`openssl passwd -crypt Temp1234`

echo ""
echo -e "\t\t\t Add user option"
echo ""

echo -ne "\t\t\t Enter username: "
read username

echo -ne "\t\t\t Enter Comment: "
read "comment"

echo -ne "\t\t\t Enter UID: "
read uuid

echo -ne "\t\t\t Enter GID: "
read groupid

echo -ne "\t\t\t Enter home directory: "
read location

file=$2
if [ -z $file ];then
	echo -ne  "\t\t\t Enter file. "
	read file
	for line in $(cat $file); 
	do
		rmt_server=$line
		echo $rmt_server

		# Adding user to /etc/group
		echo "Adding user:$username to /etc/group"
		ssh -q -t $user@$rmt_server sudo groupadd $username -g $groupid
		groupresult=$?
		
		# Create User	
		echo "Adding user:$username to /etc/passwd"
		ssh -q -t $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username -s /bin/bash
		userresult=$?

		# Insert comment of first name
		ssh -q -t $user@$rmt_server sudo chfn -o $comment $username
		commentresults=$?

		# Expire password, requires user to reset on first login
		ssh -q -t $user@$rmt_server sudo chage -d 0 $username
		passwordresult=$?

		# Set account expiration date 
		ssh -q -t $user@$rmt_server sudo chage -m 90 -M 90 $username

		# Specify 7 day before account is inactive days after password expires
		ssh -q -t $user@$rmt_server sudo chage -I 3 $username

		# Set warning days before password expires
		ssh -q -t $user@rmt_server sudo chage -W 7 $username

		# log options
		echo $rmt_server add-user $username,$uuid,$location $userresult - group $groupid,$groupresult - password-set,$passwordresult >> $log
	done
else
	for line in $(cat $file); 
	do
		echo "Connected to $line"
		rmt_server=$line
		echo ""
		echo "Adding user:$username to /etc/group"
		ssh -q -t $user@$rmt_server sudo groupadd $username -g $groupid
		groupresult=$?
		echo ""

		echo "Creating $username on $rmt_server"
		ssh -q -t $user@$rmt_server sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $username
		userresult=$?

		# Insert comment of user first name
		ssh -q -t $user@$rmt_server sudo chfn -o $comment $username
		commentresults=$?

		# Expire password requiring user to reset on first login
		ssh -q -t $user@$rmt_server sudo chage -d 0 $username
		passwordresults=$?

		# Set account expiration date 
		ssh -q -t $user@$rmt_server sudo chage -E $today -m 90 -M 90 $username

		# Specify inactive days after password expires
		ssh -q -t $user@$rmt_server sudo chage -I 3 $username

		# Set warning days before password expires
		ssh -q -t $user@rmt_server sudo chage -W 7 $username
		echo $?

		# log options
		echo $rmt_server add-user $username,$uuid,$location $userresult - $groupid $groupresult - password-set $passwordresults >> $log
	done
fi
}

delete-user(){
#set -xv

echo ""
echo -e "\t\t\t Delete user option"
echo ""

if [ -z $rmt_user ];then
	echo -ne "\t\t\t Enter username. "
	read rmt_user
fi

if [ -z $file ];then
	echo -ne "\t\t\t Enter file containing list of servers. "
	read file
	for line in $(cat $file); 
	do
		rmt_server=$line
		echo ""
		echo -e "\t\t\t\t\t ===== $rmt_server ====="

		echo "Deleting user and group for $rmt_user"
		ssh -q -t $user@$rmt_server sudo userdel -f -r $rmt_user
		result=$?

		# Send output to log file
		echo $rmt_server delete-user $rmt_user $result >> $log
	done
else
	for line in $(cat $file); 
	do
		rmt_server=$line
		echo ""
		echo -e "\t\t\t\t\t ===== $rmt_server ====="

		echo "Deleting user and group: $rmt_usere on $rmt_server"	
		ssh -q -t $user@$rmt_server sudo userdel -f -r $rmt_user
		result=$?

		# Send output to log file
		echo $rmt_server delete-user $rmt_user $result >> $log
	done
fi

}

check(){
rmt_user=$1

if [ -z $rmt_user ];then
	echo -ne "\t\t\t Enter username. "
	read rmt_user
fi

if [ -z $file ]; then
	echo -ne "\t\t\t Enter file containing list of servers. "
	read file
	for line in $(cat $file); do
		rmt_server=$line
		echo ""
		echo -e "\t\t\t\t\t ===== $rmt_server ====="
		echo ""

		echo "User: $rmt_user"
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
		echo -e "\t\t\t\t\t ===== $rmt_server ====="
		echo ""

		echo "User: $rmt_user"
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

echo ""
echo -e "\t\t\t Reset password option"
echo -ne "\t\t\t Enter username: "
read username

echo -ne "\t\t\t Enter file: "
read file

for line in $(cat $file); do
	rmt_server=$line
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

	echo "Setting password to corporate default for $username on $rmt_server"
	ssh -q -t $user@$rmt_server sudo usermod -p $pass $username
	result="$?"	

	if [ $result == 0 ]; then
		echo "Password reset to default for $username"
		echo $rmt_server reset-pass $username $result >> $Log
	else
		echo "Password reset not completed for $username."
		echo $rmt_server reset-pass $username $result >> $Log
	fi
done
}

lock-account(){
echo -ne "\t\t\t Enter username: "
read username

echo -ne "\t\t\t Enter file. "
read file

for line in $(cat $file); do
        rmt_server=$line
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

        echo "$username account will be locked"
        ssh -q -t $user@$rmt_server sudo usermod -L $username
        result="$?"

	if [ $result == 0 ]; then
        	echo "$username account is locked"
		echo $rmt_server account-lock $username $result >> $log
	else
        	echo "Could not lock account for $username"
		echo $rmt_server account-lock $username $result >> $log
	fi
done
}

unlock-account(){
echo -ne "\t\t\t Enter username: "
read username

echo -ne "\t\t\t Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line  
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

        echo "$username account will be ulocked"
        ssh -q -t $user@$rmt_server sudo usermod -U $username
        result="$?"

	if [ $result == 0 ]; then
       		echo "User:$username account is unlocked"
		echo $rmt_server unlock-account $username $result >> $log
	else
        	echo "Could not unlock account"
		echo $rmt_server unlock-account $username $result >> $log
	fi
done
}

pamtally2(){
echo -ne "\t\t\t Enter username: "
read username

echo -ne "\t\t\t Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

        echo "Resetting $username password to default"
        ssh -q -t $user@$rmt_server sudo pam_tally2 --user=$username --reset
        result="$?"

	if [ $result == 0 ]; then
        	echo "$username account reset"
		echo $rmt_server pammtall-reset $username $result >> $log
	else
        	echo "Could not reeset account"
		echo $rmt_server pammtall-reset $username $result >> $log
	fi
done
}

addtogroup(){
echo -ne "\t\t\t Enter user name: "
read username

echo -ne "\t\t\t Seperate multiple groups by comma's"
echo -ne "\t\t\t Enter group name: "
read group

echo -ne "\t\t\t Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line 
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

        echo "Adding $username to $group on $rmt_server"
        ssh -q -t $user@$rmt_server sudo usermod -a -G $group $username
        result="$?"
done

if [ $result == 0 ]; then
	echo ""
        echo "$username added to $group on $rmt_server"
	ssh -q -t $user@$rmt_server sudo id $username
	# Send data to log file
	echo $rmt_server add-to-group $username $result >> $log
else
        echo "Could not add $username to $group"
	# Send data to log file
	echo $rmt_server add-to-group $username $result >> $log
fi
}

changeprimarygroup(){
echo -ne "\t\t\t Enter user name: "
read username

echo -ne "\t\t\t Enter group new name or GUID: "
read group

echo -ne "\t\t\t Enter file: "
read file

for line in $(cat $file); do
        rmt_server=$line
	echo ""
	echo -e "\t\t\t\t\t ===== $rmt_server ====="
	echo ""

        echo "Change primary group for $username to $group on $rmt_server"
        ssh -q -t $user@$rmt_server sudo groupmod -g $group $username
        result="$?"
	if [ $result == 0 ]; then
		echo ""
        	echo "$username changed primary group to $group"
        	ssh -q -t $user@$rmt_server sudo id $username
		# Send results to log file
		echo $rmt_server changeprimarygroup $username $group $results >> $log
	else
        	echo "Could not change to $group"
		primarygroupchangeresults=$?
		# Send results to log file
		echo $rmt_server changeprimarygroup $username $group $results >> $log
	fi
done
}

menu(){

menu(){

	clear
	echo -e ""
        echo -e "\t\t\t --------------------------------"
        echo -e "\t\t\t    User Account Administration  "
        echo -e "\t\t\t --------------------------------"
	echo -e ""
        echo -e "\t\t\t 1. Search User"
        echo -e "\t\t\t 2. Add User"
        echo -e "\t\t\t 3. Delete User"
        echo -e "\t\t\t 4. Reset password"
        echo -e "\t\t\t 5. Lock Account  "
        echo -e "\t\t\t 6. Unlock Account"
        echo -e "\t\t\t 7. Pam Tally2 reset"
        echo -e "\t\t\t 8. Add user to group"
        echo -e "\t\t\t 9. Change Group ID"
        echo -e "\t\t\t 10. Check account status"
        echo -e "\t\t\t 11. Exit"
	echo -e ""
}

	menu
	echo -en "\t\t\t Enter selection from 1-11: "
	read choice
	case $choice in
	1)
		check_username $rmt_user
		search $rmt_user $rmt_server
		;;
	2)
		add-user
		;;
	3)
                delete-user
		;;
	4)
		reset-pass
		;;
	5)
		lock-account
		;;
	6)
		unlock-account
		;;
	7)
		pamtally2
		;;
	8)
		check_servername
		addtogroup
		;;
	9)
		changeprimarygroup
		;;
	10)
		check 
		;;
	11)
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
menu|-m)
 	menu
	;;	
-h|help|*)
        usage
        ;;
esac
