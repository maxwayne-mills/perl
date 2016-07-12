#!/bin/bash
# Created July 5 2016
# Author: Clarence Mills
# Depeendency: PKI key in place on each remote-server to provide secure passwordless connection
# Sudo files in place to allow usage of User account managment
 
 
RMT_CONNECT_USER=cmills
RMT_SERVER=$1
FUNCTION=$2
USER=$3
CONNECT=$RMT_CONNECT_USER@$RMT_SERVER
 
show-hostname()
{
echo "Checking host name ...."
echo "Connected to (issued hostname command):" `ssh $CONNECT hostname`
echo ""
}
 
search-group()
{
echo
}
 
search-user()
{
if [ -z $USER ];then
        # Prompt for username if not provided
        echo "Enter the uername you would like to search for"
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
 
#echo -n "Home location:"
#read location

# Create hashed password
pass=`openssl passwd -crypt Temp1234`
 
# add user using useradd and fields entered from above
set -x
ssh -tt $CONNECT sudo groupadd $user -f -g $groupid
echo $?

ssh -tt $CONNECT sudo useradd -u $uuid -g $groupid -m -d $location -p $pass $user
echo $?

#ssh -tt $CONNECT sudo usermod -m -d $location $user
#echo $?
}
 
delete-user()
{
if [ -z $USER ];then
        echo -n "Enter username"
        read username
        USER=$username
        echo "Deleting user:$USER on Server:$RMT_SERVER"
        ssh -tt $CONNECT sudo userdel -fr $USER
else
        echo -n "Deleting user:$USER on Server:$RMT_SERVER"
        ssh -tt $CONNECT sudo userdel -r $USER
fi
}
 
case $2 in
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
*)
        echo `basename $0` "options: <servername or IP> | add-user | delete-user | search-user | username"
        echo `basename $0` "tor-lx-svn-d01 search-user cmills "
        ;;
esac
