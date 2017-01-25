#!/usr/bin/expect

set username [lindex $argv 0] 
set server [lindex $argv 1] 
set password "changeme"

spawn /home/oss/repos/clients/account-management.sh -o $server "pfexec passwd $username"
expect "Password:"
send "$password\r"
expect "Re-enter new Password:"
send "$password\r"
expect "passwd: password successfully changed for $username"
send "exit\n"
