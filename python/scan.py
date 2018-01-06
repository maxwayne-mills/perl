#!/usr/bin/env python
import socket

list = ['www.clarencemills.com','www.millsresidence.com','www.opensitesolutions.com','www.toolsforthecloud.com']

def get_ops(server_name, port): # this function is untested
    port = 22
    s = socket.socket()
    s.connect((server_name,port))
    result = s.recv(1024)
    print ("Openssh version on %s: \t%s") % (server_name,result),  # the comma at the end removes the trailing newline
    s.close()

for server_name in list:
    get_ops(server_name, 22)
