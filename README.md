Plex on Centos 6.5

Docker container for running Plex. 
  Access via http://localhost:32400/web
  Supervisor via http://localhost:9091

Host setup
 
  The container requires privileged access to run, e.g. --privileged=true

  Run the container with --net=host    
  When running without --net=host, Plex GDM doesn't work (clients don't auto-discover the server)
  as the docker container runs inside the docker network range, e.g. 172.x.x.x.  Setup_plex.sh 
  needs to be run, to enable the host IP range that is outside the docker subnet 

  The addition the host needs to have:
    ulimit -l 4000
    Firewall disable, or all the ports opened. 

  When running these items should be exposed or mapped.
     
  Volumes

        /mnt/plex 	  	Plex settings directory, with the sub-directoris Library/Application Support. This
                     	is mapped to PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR.
                     	It is best to run outsite the container, copy out of the docker container and map.
       	/var/log
		/mnt/media    The media directory needs to be mounted and added to Plex

   Ports
       5353:5353/udp
       1900:1900/udp
       32410:32410/udp
       32412:32412/udp 
       32413:32413/udp
       32414:32414/udp
       32469:32469
       32400:32400
       9091:41091

Build Container

	docker build --rm=true -t="plex" .

Run Container

	docker run --name plex -v /host//media:/container/media --privileged=true --net=host
