#!/bin/sh 
# Network Tools
# Shell script that is called by resolve_dns.php and net_resolve.php
# Dependencies - jwhois, for whois lookups

set +x

question=$2
doptions="-4 +noall +answer +multiline +time=3"

base_file(){
	# create unique tmp file
	tfile=`mktemp` || exit 1
}

check_input(){
	if [ "$question" = "" ];then
		echo "Enter either an IP address or FQDN" && exit 1
	fi
}

usage(){
	# function to collect which options are chosen
	# stored in text file
	used="$1"
	month=`date | awk '{print $2}'`
        day=`date | awk '{print $3}'`
	file=/var/www/html/tmp/results/webuse_$month$day.txt
	echo "$used $question `date` " >> $file
}

checkwhois(){
	base_file
	#Show root registrars who answered
	reg=`whois $question| grep -i "\["`

        whoisserver=`whois $question| egrep -i "whois server:" | awk 'BEGIN { FS = ": "};{print $2}'`
        if [ -n "$whoisserver" ]; then
                echo "<b>$reg </b>"
                echo "<b>Authorative Registrar $whoisserver</b>"
		echo "<h4>&nbsp;</h4>"

                whois -h $whoisserver $question | sed '/\[/d' | sed '/\%/d' | sed '/\#/d'
        else
		#Show root registrars who answered
        	reg=`whois $question| grep -i "\^["`

		## At this point there is no obvious root registrar
		## or the input is an IP address

                #whois $question | sed '/\#/d' | sed '/\%/d' >> $tfile
                whois $question >> $tfile
                status=`egrep -i "(No match for domain \"$question\"| no entries found)" $tfile`
                if [ -z "$status" ];then
			echo "$reg"
                        cat $tfile
                else
			echo "$reg"
			echo "$status"
			echo "<br><br>"
                        echo "No Whois Information found for $question"
                        echo "<br>"
                        echo "<h4>Tips:</h4>"
                        echo "Make sure to include the .com, .net, .org or .info or the TLD suffix"
                        echo "<br>"
                        echo "Whois Servers only contain information for top-level domains, not sub-domains"
                        echo "or hostnames like www, ftp, pop or imap as these would be servers within the domain<br>"
                        echo "So search's for <b>$question</b> will not work as that is a server within the domain as well."
                        echo "You should do a whois lookup for <b>$question</b> without the first portion before the first period, which"
                        echo "would be the parent domain"
                        echo "<br>"
                        echo "If you want to find DNS information for a hostname within your domain use the DNS Lookup tools below."
                fi
        fi

# Cleanup
rm $tfile
}

mailcert(){
REMHOST=$question
REMPORT=25
#certfile=/var/www/html/fixyourip/cacert.pem
certfile=/etc/pki/tls/cert.pem
options="-starttls smtp -crlf -showcerts -connect"
doptions="-4 +noquestion +noauthority +noadditional +nostats +nocomments +nocmd +nocl +nottlid +nocdflag +nodnssec +novc +nonssearch +multiline +time=3"

	echo "View certificate Bundle <a href=/library/openssl/rootcas.php>Root Certificates</a>."

# After all checks passed connect to server
        #base_file
        #item="/var/www/html/fixyourip$tfile"
	echo "<h3>Certificate Report:</h3>"
        echo | openssl s_client $options ${REMHOST}:$REMPORT -CAfile $certfile| sed -ne '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' | openssl x509 -noout -text -nameopt multiline
	echo ""
	echo "<h3>Connection details:</h3>"
	echo | openssl s_client $options ${REMHOST}:$REMPORT -CAfile $certfile
	echo ""
	echo "<b>Verify return code of 0 is good</b> Read more about SSL/TLS <a href=/library/openssl/ssl_errors.php>errors</a>"
	echo "View certificate Bundle <a href=/library/openssl/rootcas.php>Root Certificates</a>."
	echo "<br>"
	echo "Learn more about <a href=/library/openssl/certificates.php>Certificates</a>."
}

webcert(){
	check_input
	mailsrv=$question
	certfile=/etc/pki/tls/cert.pem
	
	echo ""
	echo "<h4>Certificate Details</h4>"
	echo | /usr/bin/openssl s_client -showcerts -connect $mailsrv:443 -CAfile $certfile | sed -ne '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' | openssl x509 -noout -text -nameopt multiline
#	echo "^D" | /usr/bin/openssl s_client -showcerts -connect $mailsrv:443 -CAfile $certfile | sed -ne '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' | openssl x509 -noout -text -nameopt multiline
	echo ""
	echo ""
	echo "<h4>Verifying Certificate Chain Authority</h4>"
	echo | /usr/bin/openssl s_client -showcerts -connect $mailsrv:443 -CAfile $certfile
	echo ""
	echo "<b>Verify return code of 0 is good</b> Read more about TLS <a href=/library/openssl/ssl_errors.php>errors</a>"
	echo "View certificate Bundle <a href=/library/openssl/rootcas.php>Root Certificates</a>."
	echo ""
	echo "Learn more about <a href=/library/openssl/certificates.php>Certificates</a>."
}

check_valid_cert(){
	/usr/bin/ssl-cert-check -i -s $question -p 25 -x 90
	usage check_valid_cert
}
search(){
	check_input
	dig -4 +trace $question | grep -i received |sed '/\[/d'
	}

resolvemxip(){
	check_input
	dig -4 +nocmd +nocomments +nostats +noquestion +noadditional +noidentify +noauthority -x $question
	answer=`host -vtmx $question | grep MX | awk '{print $6}'`
        if [ "$answer" = "" ];then
                echo "No MX records found - without MX-record can't find A-records"
        else
                for item in `host -vtmx $question | grep MX | awk '{print $6}'| sort`
                do
                        # Get A records for each MX record returned from the command
                        # output from above.
                        aanswer=`dig -ta $doptions $item | awk '{print $5}'`
			dig $doptions -x $aanswer |awk '{print $1"\t""\t"$2"\t"$3"\t"$4"\t"$5}' | sort
			#/usr/bin/resolveip $aanswer
                done
        fi
	}

reversearecord(){
	check_input
	answer=`dig -ta $doptions $question`
	echo "<h3>PTR Records for $question</h3>"
        if [ "$answer" = "" ];then
                echo "No A record found"
        else
		for number in `dig -ta $doptions $question | awk '{print $5}'`
                do
		if [ "$number" = "" ];then
			echo "NO A record found - No reverse record found"
		else
                        reverse=`dig $doptions -x $number |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' | sort`
			if [ "$reverse" = "" ];then
				echo "<br><br>"
				echo "No PTR record found"
				exit
			else
				dig $doptions -x $number |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' | sort
			fi
		fi
                done
        fi
}

displaycert(){
	cafile="/etc/pki/tls/certs/ca-bundle.crt"
	outfile="/var/www/html/fixyourip/library/openssl/root.html"
	# Display certificate Root CA signers
	echo "<h2>Root Certificate Authorities used by Fixyourip</h2>" > $outfile
	echo "<pre>" >> $outfile
	#cat $cafile | grep -i subject | awk 'BEGIN {FS = ":"};{print $2}' >> $outfile
	cat $cafile | grep -i subject: | grep -i cn >> $outfile
	echo "</pre>" >> $outfile
}

convertcheckdomainreport(){
	tlddomain=$(echo $question | awk 'BEGIN { FS = "." };{print $2"."$3}')
	server=$(echo $question | awk 'BEGIN { FS = "." };{print $3}')
	if [ "$server" = "" ];then
		tlddomain=$(echo $question | awk 'BEGIN { FS = "." };{print $1"."$2}')	
		echo "<h4>&nbsp;</h4>"
		echo "<form action=reports/domain_report.php method=post>"
                echo "Domain Report for <input type=hidden name=domain value=$tlddomain><input type=submit value="$tlddomain">"
                echo "<input type=hidden name=tool_option value=domainreport>"
                echo "</form>"
	else
		echo "<h4>&nbsp;</h4>"
		echo "<form action=reports/domain_report.php method=post>"
        	echo "Domain Report for <input type=hidden name=domain value=$tlddomain><input type=submit value="$tlddomain">"
        	echo "<input type=hidden name=tool_option value=domainreport>"
        	echo "</form>"
	fi
}

convertcheckipreport(){
	ip=$(dig +short -ta $question)
	echo "<form action=reports/ip_report.php method=post>"
	echo "IP Report<input type=hidden name=ip value=$ip><input type=submit value=$ip>"
        echo "<input type=hidden name=tool_option value=ipreport>"
        echo "</form>"	
}


case $1 in
search)
	search
	;;
whois )
	check_input
	checkwhois
	usage whois
	;;
arecord)
	check_input
	
	 numpositions=$(echo $question | awk 'BEGIN { FS = "." };{print $2}')
         if [ "$numpositions" = "" ];then
         	echo "Did you mean" $question.com
		exit
         fi

	echo "<h3>A Records for $question</h3>"

	answer=`dig -ta $doptions $question`
	if [ "$answer" = "" ];then
	 	echo "No A record found"
	else
		dig -ta $doptions $question | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' | sort
	fi

	server=$(echo $question | awk 'BEGIN { FS = "." };{print $1}')
        if [ $server = "www" ];then
		echo "<h4>&nbsp;</h4>"
                echo "<form action=reports/web_report.php method=post>"
                echo "Web Report <input type=hidden name=web value=$question><input type=submit value=$question>"
                echo "<input type=hidden name=tool_option value=webreport>"
                echo "</form>"
        else
                continue
        fi

	convertcheckdomainreport
	echo "<h4>&nbsp;</h4>"

	reversearecord
	usage arecord
	
	;;
arecordreverse)
	check_input
	reversearecord
	usage arecordreverse
	;;	
mxrecord)
	check_input
	answer=`dig -tmx $doptions $question| sort`
	if [ "$answer" = "" ];then
		echo "No MX record found"
	else
		dig -tmx $doptions $question | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' | sort
	fi
	convertcheckdomainreport
	usage mxrecord
	;;
txtrecord)
	check_input
	answer=`dig -ttxt $doptions $question`
	if [ "$answer" = "" ];then
		echo "No TXT record found"
	else
		dig -ttxt $doptions $question
	fi
	usage txtrecord
	;;
crecord)
	check_input
	answer=`dig -tcname $doptions $question`
	if [ "$answer" = "" ];then
		echo "No Cname record found"
		echo "<br><br>"
		echo "Do not enter website address's (URL) like http://www.whateverdomain.com"
		echo "only enter www.whaterverdomain.com or whateverdomaind.com"
	else
		dig -tcname $doptions $question
	fi
	usage crecord
	;;
any_record)
	check_input
	answer=`dig -tany $doptions $question`
	if [ "$answer" = "" ];then
		echo "No records found"
	else
		dig -tany $doptions $question
	fi
	convertcheckdomainreport
	usage any_record
	;;
srvrecord)
	check_input
	answer=`dig $doptions -tsrv $question`
	if [ "$answer" = "" ];then
		echo "NO SRV record found"
		echo "<br><br>"
	else
		dig $doptions -tsrv $question
	fi
	usage srvrecord
	;;
getns )
	check_input
	answer=`host -vtns $question | grep NS | grep IN | awk '{print $5}'| sort`
	if [ "$answer" = "" ];then
		echo "NO Name servers found"
	else
		for item in `host -vtns $question | grep NS | grep IN | awk '{print $5}'| sort`
		do
       			 # Resolve A records for Name servers entered from above command.
        	 	echo "`dig -ta $doptions $item| awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}'| sort`" 
		done
	fi
	usage getns
	;;
convertmx )
	check_input
	answer=`host -vtmx $question | grep MX | awk '{print $6}'`
	if [ "$answer" = "" ];then
		echo -n "No MX records found - without an MX record can't find A-records"
	else
		for item in `host -vtmx $question | grep MX | awk '{print $6}'| sort`
		do
        		# Get A records for each MX record returned from the command
        		# output from above.
        		echo "`dig -ta $doptions $item| awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}'|sort`"
		done
	fi
	usage convertmx
	;;
spf )
	check_input
	# email address is the parameter passed to this script
	#dig $doptions -t txt `echo "$question" | awk 'BEGIN { FS = "@" } ; { print $2 }'`
	spfanswer=`dig $doptions -t txt $question`
	if [ "$spfanswer" = "" ];then
		echo "No SPF record found"
	else
		dig $doptions -t txt $question
	fi
	usage spf
	;;
pagerank )
	check_input
	# FQDN website (example www.cnn.com)
	url="http://www.google.com/search?client=navclient-auto&ch=6-1484155081&features=Rank&q=info"
	echo "Working to fix this issue - Check back at a later date"
	echo ""
	#lynx -dump "$url:http://$question" | awk 'BEGIN { FS = ":" } ; { print $3 }'| sed '/^$/d' | sed 's/^[ \t]*//'
	lynx -dump "$url:http://$question" 
	usage pagerank
	;;
iplocation )
	check_input
	# Ip address passed as a parameter
	lynx -dump "http://api.hostip.info/get_html.php?ip=$question"
	#echo -n "This tools is currently under going maintenance, check back soon"
	#usage iplocation
	;;
mxiplocation )
	check_input
	item=$question
        record=`dig $doptions -tmx $item| awk '{print $6}'`
        for mxip in `echo $record`
        do
                if [ "$mxip" = " " ]; then
                        echo -n "<br>"
                        echo -n "Can't find A record"
                else
                        echo "$item MX record $mxip is Located:"
			mxa=`dig $doptions -ta $mxip | awk '{print $5}'`
			whois -h whois.pwhois.org type=pwhois $mxa | sed '/\[/d' | grep -i "city:"
                        whois -h whois.pwhois.org type=pwhois $mxa | sed '/\[/d' | grep -i "region:"
                        whois -h whois.pwhois.org type=pwhois $mxa | sed '/\[/d' | grep -i "country:"
                        whois -h whois.pwhois.org type=pwhois $mxa | sed '/\[/d' | grep -i "latitude:"
                        whois -h whois.pwhois.org type=pwhois $mxa | sed '/\[/d' | grep -i "longitude:"
                        echo -n "<br>"
                fi
        done
	echo "!!! Coming Soon integration with Google Map"
	usage mxiplocation
	;;
nsiplocation )
        check_input
        item=$question
        record=`dig $doptions -tns $item| awk '{print $5}'`
        for nsip in `echo $record`
        do
                if [ "$nsip" = " " ]; then
                        echo -n "<br>"
                        continue
                else
                        echo "$item NS record $nsip is hosted by:"
                        nsa=`dig $doptions -ta $nsip | awk '{print$5}'`
                        whois -h whois.pwhois.org type=pwhois $nsa | sed '/\[/d'
                        echo -n "<br>"
                fi
        done
	usage nsiplocation
        ;;
reverseip)
	check_input
	reverse=`dig $doptions -x $question|awk '{print $1"\t""\t"$2"\t"$3"\t"$4"\t"$5}' | sort`
        if [ "$reverse" = "" ];then
                echo "No reverse DNS record found"
        else
		dig $doptions -x $question|awk '{print $1"\t""\t"$2"\t"$3"\t"$4"\t"$5}' | sort
        fi
	;;
getasn)
	check_input
	whois -h v4.whois.cymru.com " -v $question"  | sed '/\[/d'| sed '/\#/d'
	usage getasn
	;;

getasnpeer)
	check_input
	whois -h v4-peer.whois.cymru.com " -v $question" | sed '/\[/d'| sed '/\#/d'
	echo "<br>"
	echo "An IP Address needs to be entered to be able to successfully obtain an Autonomous System Number (ASN)"
	echo "<br>"
	echo "If you need to know the IP Address of a host/server on your network use the DNS lookkup"
	echo "Tool below"
	usage getasnpeer
	;;
cert )
	check_input
	mailcert
	usage cert
	;;
webcert )
	check_input
	webcert
	usage webcert
	;;
valid_cert)
	check_valid_cert
	usage valid_cert
	;;
soa )
	check_input
	answer=`dig -tns $doptions $question| awk '{print $3}'`
	if [ "$answer" = "" ];then
		echo "No name server found - therfore can't find SOA records"
	else
		names=`dig -tns $doptions $question| awk '{print $5}'|sort -u`
       		for n in `echo $names`
        	do
                	echo "SOA records for $n"
			doptions2="-4 +noquestion +noadditional +nostats +nocomments +multiline +nocmd +nocl +nottlid +nocdflag +nodnssec +novc"
                	dig $doptions2 -tsoa $n
               		echo "<br>"
        	done
	fi
	usage soa
	;;
routeinfo)
	check_input
	whois -h whois.radb.net $question | sed '/\[/d'
	usage routeinfo
	;;
scan)
	check_input
	nmap -A -T4 -P0 -p 25,80,443,21,23,8080 $question | grep -i "tcp"
	usage scan
	;;
reversemxip)
	check_input
	resolvemxip
	usage reversemxip
	;;
tracenet)
	check_input
	traceroute -w 3 -nA $question 
	usage tracenet
	;;
displaycerts)
	displaycert
	;;
* )
	echo `basename $0` "search | whois | any_record | arecord | arecordreverse | mxrecord | mxiplocation | txtrecord | crecord | svrecord | getns | nsiplocation | convertmx | spf | pagerank |  reverseip | iplocation | getasn | getasnpeer | cert | webcert | valid_cert | displaycerts | soa | routeinfo | scan| reversemxip | tracenet <FQDN>"
	;;
esac
