#!/bin/bash

set +e


function stopService {
  echo "Stopping $1..."

  if [[ $(docker service ls -q --filter name=$1 | wc -l) != "0" ]]; then
    docker service rm $(docker service ls --filter name=$1 -q) &> /dev/null
  fi

  sleep 2
  echo "Done"
}

stopService "clustercontrol"
stopService "console-agent"
stopService "file-agent"
stopService "authsync-agent"
stopService "healthchecker-agent"
stopService "dockergc-agent"
stopService "swarmproxy-agent"
stopService "standby-agent"
stopService "volumecontroller"
stopService "volume-agent"
