#!/usr/bin/env python
import socket

list = ['www.clarencemills.com','www.millsresidence.com','www.opensitesolutions.com','www.toolsforthecloud.com']

def get_ops(server_name): # this function is untested
    s = socket.socket()
    s.connect((server_name,22))
    result = s.recv(1024)
    print ("Openssh version on %s: \t%s") % (server_name,result),  # the comma at the end removes the trailing newline
    return result
    s.close()

for server_name in list:
    get_ops(server_name)
