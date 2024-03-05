#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

# changes March 14 2023: introduced $PLATFORM to have this work on amd64 as well as arm64

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')
# beta: building in ARM support
[ $(arch) = aarch64 ] && PLATFORM=arm64
[ $(arch) = x86_64 ] && PLATFORM=amd64

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
	# hopefully temporary bugfix as the containerd version provided in Ubu repo is tool old
	# added Jan 26th 2023
	# this needs to be updated when a recent enough containerd version will be in Ubuntu repos
	sudo systemctl stop containerd
	# cleanup old files from previous attempt if existing
	[ -d bin ] && rm -rf bin
	wget https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-${PLATFORM}.tar.gz 
	tar xvf containerd-1.6.15-linux-${PLATFORM}.tar.gz
	sudo mv bin/* /usr/bin/
	# Configure containerd
	sudo mkdir -p /etc/containerd
	cat <<- TOML | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    [plugins."io.containerd.grpc.v1.cri".containerd]
      discard_unpacked_layers = true
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
	TOML

	# Restart containerd
	sudo systemctl restart containerd	
fi

