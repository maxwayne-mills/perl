#!/bin/bash -x
# Created July 5 2016
# Author: Clarence Mills
# Depeendency: PKI key in place on each remote-server to provide secure passwordless connection
# Sudo files in place to allow usage of User account managment
 
FUNCTION=$1
USER=$2
RMT_SERVER=$3
CONNECT=$RMT_SERVER
 
show-hostname()
{
echo "Checking host name ...."
echo "Connected to:" `ssh $CONNECT hostname`
echo ""
}
 
search-group()
{
echo
}
 
search-user()
{
echo -n "Enter hostname: "
read host
RMT_SERVER=$host
CONNECT=$RMT_SERVER

if [ -z $USER ];then
        # Prompt for username if not provided
        echo -n "Enter the uername you would like to search for: "
        read account
        USER=$account
        echo "Searching for user:$USER on Server:$RMT_SERVER"
         ssh $CONNECT grep -wi $USER /etc/passwd > ~/user.txt
         if [ $? = 1 ];then
                echo "User $USER not found"
         else
                echo "Found user: $USER"
                cat ~/user.txt
                echo ""
                echo "Group information /etc/group"
                ssh $CONNECT grep -i $USER /etc/group
         fi
else
        #Search for user within password file and ggroup file.
        echo "Searching for user:$USER on Server:$RMT_SERVER"
        ssh $CONNECT grep -wi $USER /etc/passwd > ~/user.txt
         if [ $? = 1 ];then
                echo "User $USER not found"
         else
                echo "Found user: $USER in /etc/passwd"
                cat ~/user.txt
                echo ""
                echo "Group information /etc/group"
                ssh $CONNECT grep -i $USER /etc/group
         fi
fi
}
 
add-user()
{
echo -n "Enter username: "
read user
 
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
RMT_SERVER=$host
CONNECT=$RMT_SERVER
 
# Create hashed password
pass=`openssl passwd -crypt Temp1234`
 
# add user using /etc/group
#set -x

echo "Adding user:$user to /etc/group"
ssh -tt $CONNECT sudo groupadd $user -f -g $groupid
echo $?
 
# add user to /etc/passwd
echo "Creating $user acount on $RMT_SERVER"
ssh -tt $CONNECT sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $user
echo $?
 
# Expire password forcing the user to set password on first-login
ssh -tt $CONNECT sudo chage -d 0 $user
echo $?
 
#Update GECOS files
ssh -tt $CONNECT sudo chfn -f "$comment"
echo $?
}
 
delete-user()
{
echo -n "Enter hostname: "
read host
RMT_SERVER=$host
CONNECT=$RMT_SERVER

if [ -z $USER ];then
        echo -n "Enter username: "
        read username
        USER=$username
        echo "Deleting user: $USER on Server: $RMT_SERVER"
        ssh -tt $CONNECT sudo userdel -fr $USER
else
        echo -n "Deleting user: $USER on Server: $RMT_SERVER"
        ssh -tt $CONNECT sudo userdel -r $USER
fi
}
 
listpass()
{
echo -n "Enter hostname: "
read host
RMT_SERVER=$host
CONNECT=$RMT_SERVER

ssh $CONNECT cat /etc/passwd
}
 
check-connection()
{
echo -n "Enter hostname: "
read host
RMT_SERVER=$host
CONNECT=$RMT_SERVER

 
  ssh -vvvv $CONNECT ls -la
}
 
case $1 in
add-user)
        clear
        add-user
        #search-user
        ;;
delete-user)
        clear
        show-hostname
        delete-user
        search-user
        ;;
search-user)
        clear
        show-hostname
        search-user
        ;;
listpass)
        listpass
        ;;
checknet)
        check-connection
        ;;
hosts)
#set -x

	Function=$2
	echo "enter file"
	read File
	for line in $(cat $File); do
		echo "$line"
		RMT_SERVER=$line
		CONNECT=$RMT_SERVER
		$Function
	done
        ;;
*)
        echo `basename $0` "options: search-user | add-user | delete-user | listpass | username <servername or IP>"
        echo "Options:"
        echo `basename $0` "search-user cmills tor-lx-svn-d01  	- Search remote server for username within /etc/passwd and /etc/group"
        echo `basename $0` "add-user            		- Add users to the system"
        echo `basename $0` "delete-user cmills tor-lx-svn-d01   - Delete users from remote server - home, mail and users will be removed from the system"
        echo `basename $0` "listpass             		- List remote servers /etc/passwd file"
        echo `basename $0` "checknet             		- Check connecting to a server"
	echo `basename $0` "hosts				- connect to multiple servers passed from a file from the command line"
        ;;
esac
