#!/bin/bash

set +e

echo "Stopping Cluster Control..."
docker service rm clustercontrol &> /dev/null
echo "Done"

echo "Stopping Console Agent..."
docker service rm $(docker service ls --filter name=console-agent -q) &> /dev/null
echo "Done"

echo "Stopping File Agent..."
docker service rm $(docker service ls --filter name=file-agent -q) &> /dev/null
echo "Done"

echo "Stopping Auth sync..."
docker service rm authsync-agent &> /dev/null
echo "Done"

echo "Stopping Healthchecker..."
docker service rm healthchecker-agent &> /dev/null
echo "Done"

echo "Stopping Docker GC..."
docker service rm dockergc-agent &> /dev/null
echo "Done"

echo "Stopping Swarm Proxy..."
docker service rm swarmproxy-agent &> /dev/null
echo "Done"

echo "Stopping StandBy..."
docker service rm standby-agent &> /dev/null
echo "Done"

echo "Stopping Volume Controller..."
docker service rm volumecontroller &> /dev/null
echo "Done"

echo "Stopping Volume Agent..."
docker service rm volume-agent &> /dev/null
echo "Done"
