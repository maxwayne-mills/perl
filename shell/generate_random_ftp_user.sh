#!/bin/sh
# Author: Clarence Mills
# Date: October 31,2007
# Dependent Programs: APG, FTPPASSWD
# Generates random username and password and mails these to users
# selected from local files of email addresses.
# Username and passwords are enterd into local Proftpd authorizations file
# these username and password cannot be used by local system for any other Access.
 
authfile="/usr/local/etc/proftpd/ftpd.passwd"
groupfile="/usr/local/etc/proftpd/ftpd.group"
file="/usr/local/etc/proftpd/proftpd_auto_gen_users.txt"
file2="/usr/local/etc/proftpd/ftpd_users.txt"
mailfile="/usr/local/etc/proftpd/ftpd_mail_to_users.txt"
gen="`which ftpasswd`"
#pass="`/usr/local/bin/apg`"
uidnum=9999
gidnum=9999
 
# Use APG program to genereate random password
gen_password(){
        password=`/usr/local/bin/apg -n 1 -m 12 -E ()@-^!*%`
}
 
# Use APG program to generate random username
gen_user(){
        user=`/usr/local/bin/apg -a 1 -M n -n 1 -m 12 -E @23456789`
}
 
# Use ftppasswd program and variables from above functions to create user credentials
create_user(){
        $gen --passwd --name=$1 --uid=$uidnum --gid=$gidnum --home=/usr/home/$home --shell=/bin/tcsh --file=$authfile
}
 
generate(){
        gen_password
        gen_user
        echo $password | $gen --passwd --name=$user --uid=$uidnum --gid=$gidnum --home=/usr/home/$user --shell=/bin/tcsh --file=$authfile --stdin
}
 
auto_gen(){
        for person in `cat $mailfile`
        do
                generate
                # Keep track of username created to be removed after 7 days
                echo $user >> $file
                # Keep track of username password and who they are assigned to
                echo $user,$password,$person >> $file2
 
                # Send mail with username and password to user pulled from mail file
                mail -s "FTP Auto User Generation" $person <<- SEND
                Auto generated message from Borderware's FTP Server.
 
                Username: $user
                Password: $password
                Server: ftp.borderware.com
                Link URL: ftp://$user:$password@ftp.borderware.com
 
                Accounts automatically expire in seven days and associated directories and files will be deleted.
 
                Username password combination can be given to remote users to facilitate large file transfers between Borderware and remote users.
                Emailing users the URL ftp://$user:$password@ftp.borderware.com and entered directly into any browser will log them into BorderWare'
                FTP server automatically.
 
                BorderWare IT Services
                it_services@borderware.com
 
                SEND
        done
}
 
remove_user(){
        newfile=/usr/local/etc/proftpd/transition
        for account in `cat $file`
        do
                sed "/$account/d" $authfile > $newfile
                mv $newfile $authfile
                rm -rf /usr/home/$account
        done
        rm $file $file2
}
 
case $1 in
create)
        if [ $2 ];then
                create_user $2
        else
                echo -n "Enter username:"
                read name
                echo -n "Enter home directory:"
                read home
                if [ $home = "" ];then
                        home=$name
                else
                        create_user $name $home
                fi
        fi
        ;;
auto)
        auto_gen
        ;;
remove)
        remove_user
        ;;
reset)
        remove_user
        auto_gen
        ;;
single)
        gen_single
        ;;
*)
        echo "`basename $0` create | single | auto |reset |remove"
        ;;
esac
