#!/bin/bash

# specify Imagenarium version
VERSION="3.2.0.RC1"

# specify additional features
FEATURES="gc,conagent"

# specify Docker GC params if GC enabled (min)
IMAGE_GRACE_PERIOD=10080
CONTAINER_GRACE_PERIOD=60
VOLUME_GRACE_PERIOD=10080
NETWORK_GRACE_PERIOD=1440

# specify heap size for Cluster Control
JAVA_OPTS=-Xmx512m

# specify heap size for agents
AGENT_JAVA_OPTS=-Xmx64m
