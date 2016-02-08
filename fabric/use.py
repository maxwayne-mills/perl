from fabric.api import *

#env.use_ssh_config == True
def host_type():
	run('uname -S')
