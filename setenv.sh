#!/bin/bash

# specify Imagenarium version
VERSION="img4"

# specify additional features
FEATURES="gc"

# specify Docker GC params if GC enabled (min)
IMAGE_GRACE_PERIOD=10080
CONTAINER_GRACE_PERIOD=60
VOLUME_GRACE_PERIOD=10080
NETWORK_GRACE_PERIOD=1440

# specify heap size for Cluster Control
JAVA_OPTS=-Xmx512m

# specify heap size for agents
AGENT_JAVA_OPTS=-Xmx64m
