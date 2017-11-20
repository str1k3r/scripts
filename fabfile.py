#PREPARE
#apt-get install fabric
#RUN fab -f path_to_the_fabfile.py %ACTION -p $PASSWORD
from fabric.api import *

#HOSTS
env.hosts = [
    'A.A.A.A',
    'B.B.B.B'
]

#ENV
env.user   = "%USERNAME"

#FUNCTIONS
#update
def u():
    run("echo {} | sudo -S apt-get update".format(env.password))

#update and upgrade
def uu():
    u()
    run("echo {} | sudo -S apt-get -y upgrade".format(env.password))

#update and dist-upgrade
def ud():
    u()
    run("echo {} | sudo -S apt-get -y dist-upgrade".format(env.password))

#cleanup and autoremove
def c():
    run("echo {} | sudo -S apt-get clean".format(env.password))
    run("echo {} | sudo -S apt-get -y autoremove".format(env.password))

# update, upgrade, cleanup
def uuc():
   uu()
   c()

#update, dist-upgrade, cleanup
def udc():
    ud()
    c()
