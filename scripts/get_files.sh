#/bin/bash

# Get setuptools
wget https://bootstrap.pypa.io/ez_setup.py --no-check-certificate -O /tmp/ez_setup.py

# download plex media server
wget https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver-0.9.11.7.803-87d0708.x86_64.rpm -O /tmp/plexmediaserver.rpm 

# get the epel rpm
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O /tmp/epel-release-6-8.noarch.rpm
