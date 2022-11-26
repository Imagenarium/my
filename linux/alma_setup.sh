#!/bin/bash

echo "========================================================================================"
echo "Install repositories"
echo "========================================================================================"

dnf -y install https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
dnf -y install epel-release
dnf -y update

echo "========================================================================================"
echo "Install docker-ce"
echo "========================================================================================"

dnf -y remove buildah
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io
mkdir -p /etc/docker/
systemctl restart docker && systemctl enable docker