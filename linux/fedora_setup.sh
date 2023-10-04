#!/bin/bash

echo "========================================================================================"
echo "Install docker-ce"
echo "========================================================================================"

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
mkdir -p /etc/docker/
systemctl restart docker && systemctl enable docker
