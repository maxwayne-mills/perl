#! /bin/sh

srcdir="/var/www/html/opensitesolutions.com"
scanfile=`md5sum $srcdir/tag.html`
echo $scanfile >> /tmp/tagcheck.txt
scanfile=`md5sum $srcdir/tag.html | awk '{print $1}'`

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
