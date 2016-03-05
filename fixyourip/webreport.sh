#!/bin/sh 
# Web Report of a given domain
# Dependent Software nettools.sh
# Written by:Clarence Mills 
# December 2009

domain="$1"
backcolor="#CCFFCC"
backcolor2="#CCCCFF"
domain="$1"
ip_address=$(dig +short -ta $domain)

echo "<table border=0 cellpadding=4 cellspacing=4>"
echo "<tr bgcolor=$backcolor>"
	echo "<td>Domain</td>"
	echo "<td>$domain</td>"
	echo "<td>Information</td>"
echo "</tr>"

echo "<tr bgcolor=$backcolor>"
	echo "<td>Server Software</td>"
	echo "<td>$(ab -v 3 -n 1 http://$domain:80/ | grep -i "Server Software:" | awk 'BEGIN { FS = ":" };{print $2}')</td>"
	echo "<td>Information</td>"
echo "</tr>"

echo "<tr bgcolor=$backcolor2>"
        echo "<td>IP Address</td>"
        echo "<td>$ip_address</td>"
	echo "<td>Information</td>"
echo "</tr>"
echo "<tr bgcolor=$backcolor>"
        echo "<td>Reverse IP Address - PTR record</td>"
        echo "<td>$(dig +short -x $ip_address)</td>"
	echo "<td>Information</td>"
echo "</tr>"
echo "<tr bgcolor=$backcolor2>"
        echo "<td>IP Owner Information</td>"
        echo "<td>$(whois -h whois.cyberabuse.org -p 43 $domain| sed '/\[/d' | sed '/\%/d'| sed '/^$/d')</td>"
	echo "<td>Information</td>"
echo "</tr>"

echo "</table>"

echo "<table>"
echo "<tr>"
        echo "<td align=left>"
		echo "<form action=/reports/web_report.php method=post>"
                echo "Web Report <input type=text name=web><input type=submit value=check>"
                echo "<input type=hidden name=tool_option value=webreport>"
                echo "</form>"
        echo "</td>"
echo "</tr>"
echo "</table>"
