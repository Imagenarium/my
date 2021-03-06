#!/bin/bash

set +e

source ./setenv.sh &> /dev/null
source ./i9m.app/setenv.sh &> /dev/null

docker node ls &> /dev/null

status=$?

if [[ "${status}" != "0" ]]; then
  echo "[IMAGENARIUM]: Initializing swarm..."
  docker swarm init --advertise-addr 127.0.0.1
fi

if [ ! "$(docker network ls | grep "\sclustercontrol-net\s")" ];then
  echo "Creating network..."
  docker network create --driver overlay --attachable clustercontrol-net
fi

export SPRING_PROFILES_ACTIVE=${FEATURES}

echo "Login to Imagenarium registry..."
docker login registry.gitlab.com -u gitlab+deploy-token-10171 -p eKUxz4BsWFE95T9WNVV2

docker service create --name clustercontrol \
--endpoint-mode dnsrr \
--with-registry-auth \
--network clustercontrol-net \
--log-driver=json-file --log-opt max-size=10m --log-opt max-file=10 \
--publish mode=host,target=8080,published=5555 \
-e "SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}" \
-e "IMAGE_GRACE_PERIOD=${IMAGE_GRACE_PERIOD}" \
-e "CONTAINER_GRACE_PERIOD=${CONTAINER_GRACE_PERIOD}" \
-e "VOLUME_GRACE_PERIOD=${VOLUME_GRACE_PERIOD}" \
-e "NETWORK_GRACE_PERIOD=${NETWORK_GRACE_PERIOD}" \
-e "JAVA_OPTS=${JAVA_OPTS}" \
-e "AGENT_JAVA_OPTS=${AGENT_JAVA_OPTS}" \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
--mount "type=bind,source=/root,target=/root" \
--mount "type=volume,destination=/tmp" \
registry.gitlab.com/imagenarium/distrib/clustercontrol:${VERSION}

echo "Logout from Imagenarium registry..."
docker logout registry.gitlab.com

while true; do
  curl -sf http://127.0.0.1:5555 > /dev/null

  status=$?

  if [[ "${status}" == "0" ]]; then
    echo "[IMAGENARIUM]: Done"
    break;
  else
    echo "[IMAGENARIUM]: starting web-console, please wait..."
  fi

  sleep 3
done