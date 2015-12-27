#! /bin/sh

srcdir="/var/www/html/opensitesolutions.com"
scanfile=`md5sum $srcdir/tag.html | awk '{print $1}'`

echo $scanfile
