#!/bin/bash

set +e

mkdir static
mkdir templates

source ./setenv.sh &> /dev/null
source ./i9m.app/setenv.sh &> /dev/null

docker node ls &> /dev/null

status=$?

if [[ "${status}" != "0" ]]; then
  echo "[IMAGENARIUM]: Initializing swarm..."
  docker swarm init --advertise-addr 127.0.0.1
fi

if [ ! "$(docker network ls | grep "\sclustercontrol-net\s")" ];then
  echo "Creating network clustercontrol-net..."
  docker network create --driver overlay --attachable clustercontrol-net
fi

if [ ! "$(docker network ls | grep "\sdockersocketproxy-net\s")" ];then
  echo "Creating network dockersocketproxy-net..."
  docker network create --driver overlay --attachable dockersocketproxy-net
fi

export SPRING_PROFILES_ACTIVE=${FEATURES}

dataPathAddr=$(docker run --rm --platform linux/amd64 -ti toolbelt/dig +short host.docker.internal | tr -d "\n\r")

if [[ "$dataPathAddr" == "" ]]; then
  dataPathAddr="172.17.0.1"
fi

curNode=$(docker info | grep NodeID | head -n1 | awk '{print $2;}')
docker node update --label-add imagenarium=true $curNode
docker node update --label-add _dataPathAddr=${dataPathAddr} $curNode

mkdir $HOME/.img &> /dev/null || true

OS_TYPE=$(uname)

docker service create --name clustercontrol \
--endpoint-mode dnsrr \
--with-registry-auth \
--network clustercontrol-net \
--log-driver=json-file --log-opt max-size=10m --log-opt max-file=10 \
--publish mode=host,target=8080,published=${IMG_PORT} \
-e "SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}" \
-e "IMAGE_GRACE_PERIOD=${IMAGE_GRACE_PERIOD}" \
-e "CONTAINER_GRACE_PERIOD=${CONTAINER_GRACE_PERIOD}" \
-e "VOLUME_GRACE_PERIOD=${VOLUME_GRACE_PERIOD}" \
-e "JAVA_OPTS=${JAVA_OPTS}" \
-e "AGENT_JAVA_OPTS=${AGENT_JAVA_OPTS}" \
-e "DOCKER_CONFIG_HOME=$HOME/.img" \
-e "OS_TYPE=${OS_TYPE}" \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
--mount "type=bind,source=${HOME}/.img,target=/root/.docker" \
--mount "type=bind,source=${PWD}/static,target=/classes/static" \
--mount "type=bind,source=${PWD}/templates,target=/classes/templates" \
--mount "type=volume,destination=/tmp" \
quay.io/imagenarium/clustercontrol:${VERSION}

while true; do
  curl -sf http://127.0.0.1:${IMG_PORT} > /dev/null

  status=$?

  if [[ "${status}" == "0" ]]; then
    echo "[IMAGENARIUM]: Done"
    break;
  else
    echo "[IMAGENARIUM]: starting web-console, please wait..."
  fi

  sleep 3
done