#/bin/bash
if [ ! -z "$1" ]; then
  LOC=$1
else 
  LOC=/tmp
fi

# Get setuptools
echo Downloading setuptools
if [ ! -d "$LOC/python" ]; then
  mkdir $LOC/python
fi
wget https://bootstrap.pypa.io/ez_setup.py --no-check-certificate -O $LOC/python/ez_setup.py -nv 

# download plex media server
echo Downloading Plex Media server
if [ ! -d "$LOC/plex" ]; then
  mkdir $LOC/plex
fi
wget https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver-0.9.11.7.803-87d0708.x86_64.rpm -O $LOC/plex/plexmediaserver.rpm  -nv 

# get the epel rpm
echo Downloading EPEL RPM
if [ ! -d "$LOC/os" ]; then
  mkdir $LOC/os
fi
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O $LOC/os/epel-release-6-8.noarch.rpm -nv 
