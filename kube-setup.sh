#!/bin/bash
#
# verified on Fedora 31 WS
egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

dnf clean all
dnf -y upgrade

# install KVM software
dnf install @virtualization -y
systemctl enable --now libvirtd

# install kubectl
echo installing kubectl
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

dnf install -y kubectl

# install minikube
echo downloading minikube, check version
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube
mv minikube /usr/local/bin

echo at this point, reboot your Fedora Workstation. After reboot, manually run as non-root
echo minikube start --memory 4096 --vm-driver=kvm2
