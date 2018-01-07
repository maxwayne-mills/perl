#!/usr/bin/env python

import subprocess

def get_gsuite_domain_info():
    subprocess.call(["/home/cmills/bin/gam/gam","info","domain"])

get_gsuite_domain_info()
