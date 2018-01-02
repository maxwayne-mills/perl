#!/usr/bin/env python
import socket

list = ['www.clarencemills.com','www.millsresidence.com','www.opensitesolutions.com','www.toolsforthecloud.com']
numlist = len(list)

num = 0
for server_name in list:
    s = socket.socket()
    s.connect((server_name,22))
    result = s.recv(1024)
    print ("received from %s: %s") % (server_name,result)
    s.close()
    num += num
