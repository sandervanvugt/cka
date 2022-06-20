#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# this script supports centos 7 and Ubuntu 20.04 only
# run this script with sudo

if ! [ $USER = root ]
then
	echo run this script with sudo
	exit 3
fi

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

##### CentOS 7 config
if [ $MYOS = "CentOS" ]
then
	echo RUNNING CENTOS CONFIG
	cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

	# Set SELinux in permissive mode (effectively disabling it)
	setenforce 0
	sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

	# disable swap (assuming that the name is /dev/centos/swap
	sed -i 's/^\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/' /etc/fstab
	swapoff /dev/mapper/centos-swap

	yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

	systemctl enable --now kubelet
fi

if [ $MYOS = "Ubuntu" ]
then
	
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl
	sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	swapoff /swapfile
	
	sed -i 's/swapfile/#swapfile/' /etc/fstab

	
fi

# Set iptables bridging
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
