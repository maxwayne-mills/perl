#!/bin/bash

DIGITALOCEAN=(Get Key From https://cloud.digitalocean.com/settings/api/tokens)
SLACK=(Get Key From https://my.slack.com/services/new/bot) 

rm do.txt
  
curl -sXGET "https://api.digitalocean.com/v2/droplets" \
       -H "Authorization: Bearer $DIGITALOCEAN" \
       -H "Content-Type: application/json" |\
       python -c 'import sys,json;data=json.loads(sys.stdin.read());\
                  print "ID\tName\tIP\tPrice\n";\
                  print "\n".join(["%s\t%s\t%s\t$%s"%(d["id"],d["name"],d["networks"]["v4"][0]["ip_address"],d["size"]["price_monthly"])\
                  for d in data["droplets"]])'| column -t > do.txt

curl -F file=@do.txt -F initial_comment="Running Droplets" -F channels=#do -F token=$SLACK https://slack.com/api/files.upload

m https://my.slack.com/services/new/bot
