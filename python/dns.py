#!/usr/bin/env python

import os
from subprocess import call

def resolv_ip(servername):
  os.system('dig "servername" +short')

server = str("www.clarencemills.com")
resolv_ip(server)

call('dig www.clarencemills.com')
