#!/bin/sh -x
# May 15 2011
# check if certain DNS Servers show the same results
# DNS propogation
# reerence http://www.speedguide.net/faq_in_q.php?qid=128
# refernce http://www.opennicproject.org/publictier2servers

name="$1"
ca="ON:66.206.229.101 QC:67.212.90.199"
us="google:8.8.8.8 dnsadvantage:156.154.70.22 opendns:208.67.222.222 servermatrix:69.56.222.10 vnsc-pri.sys.gtei.net:4.2.2.6"
europe="UK:89.16.173.11 DE:217.79.186.148 FR:95.142.171.235 SE:192.121.121.14 CZ:89.185.225.28"
oceania="NZ:27.110.120.30 AU:119.31.230.42"

backcolor="#CCFFCC"
backcolor2="#CCCCFF"

if [ "$name" == "" ];then
	echo "Enter FQDN of server example www.fixyourip.com"
	exit
fi

#show dns answer from domain ns server
TopLD=`echo $name | awk 'BEGIN { FS = "." };{ print $2"."$3 }'`
echo "<b>Top Level:</b> $TopLD"
echo "<b>Name Servers:</b>"
homens= echo "$(dig -tns +short $TopLD)"

for nsserver in `echo $homens`
do
	echo "$(dig +short $name @$nsserver)"
done

echo "<table cellpadding=2 cellspacing=8>"
echo "<tr>"
	echo "<td bgcolor=$backcolor><h2>DNS Server Location</h2></td>"
	echo "<td bgcolor=$backcolor><h2>DNS Server</h2></td>"
	echo "<td bgcolor=$backcolor><h2>A Record</h2></td>"
echo "<tr>"

for list in $(echo $ca)
do
	echo "<tr>"
                echo "<td valign=top bgcolor=$backcolor>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $1}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor2>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $2}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor>"
                        echo "$(dig -ta +short $name @$( echo $list | awk 'BEGIN { FS = ":" };{print $2}') | sort)"
                echo "</td>"
        echo "</tr>"
done

for list in $(echo $us )
do
	echo "<tr>"
                echo "<td valign=top bgcolor=$backcolor>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $1}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor2>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $2}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor>"
                        echo "$(dig -ta +short $name @$( echo $list | awk 'BEGIN { FS = ":" };{print $2}') | sort)"
                echo "</td>"
        echo "</tr>"
done

for list in $(echo $europe)
do
	echo "<tr>"
                echo "<td valign=top bgcolor=$backcolor>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $1}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor2>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $2}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor>"
                        echo "$(dig -ta +short $name @$( echo $list | awk 'BEGIN { FS = ":" };{print $2}') | sort)"
                echo "</td>"
        echo "</tr>"
done

for list in $(echo $oceania)
do
	echo "<tr>"
                echo "<td valign=top bgcolor=$backcolor>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $1}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor2>"
                        echo "<b> $( echo $list | awk 'BEGIN { FS = ":" };{print $2}') </b>"
                echo "</td>"

                echo "<td valign=top bgcolor=$backcolor>"
                        echo "$(dig -ta +short $name @$( echo $list | awk 'BEGIN { FS = ":" };{print $2}') | sort)"
                echo "</td>"
        echo "</tr>"

done
echo "</table>"
