#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

echo this script is now deprecated and provided for compatibility reasons only. 
echo run setup-container.sh instead. 
echo after running setup-container.sh, use setup-kubetools.sh to install the kubernetes tools
echo this script will now stop
echo use Ctrl-C to stop it now
sleep 30
exit

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

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

systemctl disable --now firewalld
