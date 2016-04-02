#!/bin/sh -x

# Shell script to download and install wordpress
# Dependency: mysql database installed
#  HTTPD daemon (apache,nginx) is installed

file=wordpress-4.4.2-en_CA.tar.gz
web_dir=/var/www/test.opensitesolutions.com/htdocs/
domain=test.opensitesolutions.com
url="https://en-ca.wordpress.org/$file"
tmplocation=/tmp/$domain

# Clean web_dir
clean(){
	rm -rf $web_dir/*
	rm  -rf $file $tmplocation /tmp/log
	}

dropdb(){
	mysqladmin -u root drop $domain
	}

case $1 in
build)
	clean && dropdb

	# Download wordpress 
	wget --directory-prefix=/tmp $url -o /tmp/log

	# Untar wordpress to destination directory
	mkdir $tmplocation
	tar -xzvf /tmp/$file -C $tmplocation
	mv $tmplocation/wordpress/* $web_dir

	#Copy wordpress config to destination directory
	cp /home/cmills/repos/wordpress/wp-config.php $web_dir

	#Create MYSQL database
	sudo mysqladmin create $domain
	;;
delete)
	dropdb && clean
	;;
*)
	echo "`basename $0` usage: build | delete"
	;;
esac
