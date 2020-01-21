#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

yum install -y vim yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# notice that only verified versions of Docker may be installed
# verify the documentation to check if a more recent version is available

yum install -y docker-ce
[ ! -d /etc/docker ] && mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

cat >> /etc/hosts << EOF
{
  192.168.4.110 control.example.com control
  192.168.4.111 worker1.example.com worker1
  192.168.4.112 worker2.example.com worker2
  192.168.4.113 worker3.example.com worker3
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

systemctl disable --now firewalld
