#! /bin/sh

srcdir="/var/www/html/opensitesolutions.com"
<<<<<<< HEAD
scanfile=`md5sum $srcdir/tag.html`
echo $scanfile >> /tmp/tagcheck.txt
=======
scanfile=`md5sum $srcdir/tag.html | awk '{print $1}'`
>>>>>>> fb4196bf4e9baa95d969662cf86df175fb7938eb

case $1 in

create)
	srcdir="/var/www/html/opensitesolutions.com"
	scanfile=`md5sum $srcdir/tag.html`
	echo $scanfile >> /tmp/tagcheck.txt
	;;
check)
	if `(md4sum $srcdir/tag.html | awk '{print $1}') == (cat /tmp/tagcheck.txt)` than
		echo "do something"
	else
		echo "do nothing"
	fi	
	;;
*)
	;;
esac
