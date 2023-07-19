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
AGENT_JAVA_OPTS=-Xmx128m

# Настройка актуальна только для работы стека DNS и только для MacOS
# Для MacOS необходимо указать реальный физический интерфейс, тк
# в MacOS нельзя прокидывать порты на 172.17.0.1
# Также для MacOS желательно сделать IP адрес статическим (в настройках wi-fi)
# Также в различных wi-fi сетях требуется указывать один и тот же статический IP адрес
DATA_PATH_ADDR=172.17.0.1