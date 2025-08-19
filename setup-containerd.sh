#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

echo printing MYOS $MYOS

##### CentOS 7 config
if [ $MYOS = "CentOS" ]
then
	if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
	fi
	echo setting up CentOS 7 with containerd 
	# Configure prerequisites
	modprobe overlay
	modprobe br_netfilter

	cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

	cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables 	= 1
net.ipv4.ip_forward 								= 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

	sysctl –system
	
	# Install containerd
	yum install -y dnf dnf-plugins-core
	dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
	dnf update -y
	dnf install -y containerd

	mkdir -p /etc/containerd
	containerd config default | tee /etc/containerd/config.toml
	# Set cgroupdriver to systemd
	sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
	systemctl restart containerd

	# Install weave CNI. & Make the Weave Net package executable:
	curl -L git.io/weave -o /usr/local/bin/weave
	chmod a+x /usr/local/bin/weave

	# Create a systemd service for Weave Net  /etc/systemd/system/weave.service 
  cat <<- WEAVE | tee /etc/systemd/system/weave.service
	[Unit]
	Description=Weave Net

	[Service]
	ExecStart=/usr/local/bin/weave launch

	[Install]
	WantedBy=multi-user.target
  
	WEAVE

	systemctl daemon-reload
	systemctl start weave
	systemctl enable weave

fi


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
        wget https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz 
        tar xvf containerd-1.6.15-linux-amd64.tar.gz
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

