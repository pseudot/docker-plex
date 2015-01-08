#!/bin/bash

while [[ $# > 0 ]]
do
  key="$1"
  shift

  case $key in
    -f|--firsttime)
      FIRSTTIME=true
    ;;
    -h|--help|-?|--?)
      HELP=true
    ;;
    *)
      # unknown option
    ;;
  esac
done

if [ $HELP ]; then
  echo "setup_plex"
  echo ""
  echo "Setup plex for the first run."
  echo ""
  echo "-f|--firsttime      -  Run for the first time"
  echo ""
  echo "  e.g. ./setup_plex.sh"
  exit
fi

if [ $FIRSTTIME ]; then
  # Generate config file
  service plexmediaserver start
  service plexmediaserver stop

  # AllowedNetwork; update plex config to show start-up screen, as container runs a NAT on 172.
  #<Preferences MachineIdentifier="75ae47af-6176-4849-9826-b4781b38ef6e" ProcessedMachineIdentifier="c6e523d3f36168f5693fd8b3e9f51a5b0253a69a" allowedNetworks="192.168.1.0/255.255.255.0" />
  sed -c -i "s/\/>/ allowedNetworks=\"192.168.0.0\/255.255.0.0\" FriendlyName=\"plex_docker\" \/>/" "/mnt/plex/Library/Application Support/Plex Media Server/Preferences.xml"
fi