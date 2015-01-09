FROM centos:centos6
# Based on centos:6.5

MAINTAINER Pseudot <pseudot@outlook.com>

# Add the EPEL repo
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
COPY os/epel-release-6-8.noarch.rpm /tmp/
RUN rpm -ivh /tmp/epel-release-6-8.noarch.rpm

# Install Supervisor to control processes

# Install easy_setup, python is already installed
COPY python/ez_setup.py /tmp/ez_setup.py
RUN python /tmp/ez_setup.py

# Easy install supervisor, for running multiple procersses
RUN easy_install pip==1.5.6
RUN pip install supervisor==3.0

# Copy supervisord configuration.
RUN mkdir -p /usr/local/etc
COPY supervisor/supervisord.conf /usr/local/etc/supervisord.conf
COPY supervisor/supervisord_plex.conf /usr/local/etc/supervisor.d/supervisord_plex.conf
## Supervisor Port: 41091

# Fix missing locale definitions
RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8

# Run plex rpm
RUN yum -y install wget
RUN wget https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver-0.9.11.7.803-87d0708.x86_64.rpm -O /tmp/plexmediaserver.rpm 
#COPY plex/plexmediaserver.rpm /tmp/plexmediaserver.rpm
RUN rpm -ivh /tmp/plexmediaserver.rpm

# add the plex configuration, changes;
# Update user to root, as su plex doesn't work, causing plex not to start up
# Set the plex library directory to the mount point to ensure no re-configuration after upgrades of the container.
COPY plex/PlexMediaServer /etc/sysconfig/PlexMediaServer

# Update start script with absolute paths, and source the plex configuration data
COPY plex/start.sh /usr/lib/plexmediaserver/start.sh
RUN chmod +x /usr/lib/plexmediaserver/start.sh

# Remaining errors
#  warning: %post(plexmediaserver-0.9.9.12.504-3e7f93c.x86_64) scriptlet failed, exit status 127
# Can be ignored if selinux is not installed. This doesn't seem to work in docker, 
# can't get selinux to start and semodule commands fail.

# If this is a new plex server library and the container will not be run with --net=host, 
# then the library IP addresses need to be updated. Run setup_plex after creating the image to allow the local subnet IP addresses range 192.168.x.x
COPY plex/setup_plex.sh  /usr/lib/plexmediaserver/setup_plex.sh
RUN chmod +x /usr/lib/plexmediaserver/setup_plex.sh 
RUN cd /usr/lib/plexmediaserver; /usr/lib/plexmediaserver/setup_plex.sh -f

# Remove temp files
RUN rm -rf /tmp/*

# Expose volumes
VOLUME [ "/var/log", "/mnt/plex" ]

# Expose container ports
# Best to run with --net=host, rather than the bridged adapter (or creating a new one)
EXPOSE 41022 32400 41091 1900 5353 32410 32413 32414 32469

# Run the supervisor
WORKDIR /usr/bin
CMD ["/usr/bin/supervisord","--configuration=/usr/local/etc/supervisord.conf"]