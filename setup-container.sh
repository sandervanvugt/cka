#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

##### CentOS 7 config
if [ $MYOS = "centos" ]
then
	echo setting up CentOS 7 with Docker 
	yum install -y vim yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	# notice that only verified versions of Docker may be installed
	# verify the documentation to check if a more recent version is available

	yum install -y docker-ce
	[ ! -d /etc/docker ] && mkdir /etc/docker

	mkdir -p /etc/systemd/system/docker.service.d


	cat > /etc/docker/daemon.json <<- EOF
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


	systemctl daemon-reload
	systemctl restart docker
	systemctl enable docker

	systemctl disable --now firewalld
fi

echo printing MYOS $MYOS

if [ $MYOS = "Ubuntu" ]
then
	### setting up container runtime prereq
	cat <<- EOF | sudo tee /etc/modules-load.d/containerd.conf
	overlay
	br_netfilter
	EOF

	sudo modprobe overlay
	sudo modprobe br_netfilter

	# Setup required sysctl params, these persist across reboots.
	cat <<- EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
	net.bridge.bridge-nf-call-iptables  = 1
	net.ipv4.ip_forward                 = 1
	net.bridge.bridge-nf-call-ip6tables = 1
	EOF

	# Apply sysctl params without reboot
	sudo sysctl --system

	# (Install containerd)
	sudo apt-get update && sudo apt-get install -y containerd
	# Configure containerd
	sudo mkdir -p /etc/containerd
	containerd config default | sudo tee /etc/containerd/config.toml
	# Restart containerd
	sudo systemctl restart containerd	
fi

