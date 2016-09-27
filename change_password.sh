#!/usr/bin/expect

set username [lindex $argv 0] 
set server [lindex $argv 1] 

spawn /home/oss/repos/clients/account-management.sh -o $server "pfexec passwd $username"
expect "Password:"
send "Temp1234\r"
expect "Re-enter new Password:"
send "Temp1234\r"
expect "passwd: password successfully changed for $username"
send "exit\n"
 
