#!/usr/bin/env python
import socket
s = socket.socket()

list = ['www.clarencemills.com', 'www.millsresidence.com']
print(list[:])
s.connect(("www.clarencemills.com",22))
result = s.recv(1024)
print ("received from www.clarencemills.com: %s") % result
s.close()
