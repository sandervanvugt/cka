This Git repository contains supporting files for my "Certified Kubernetes Administrator (CKA)" video course. See https://sandervanvugt.com for more details. It is also used in the "CKA Crash Course" that I'm teaching at https://learning.oreilly.com. 

In this course you need to have your own lab environment. This lab environment should consist of 3 virtual machines, using Ubuntu LTS server 20.4 or later (22.4 is recommended)
Make sure the virtual machines meet the following requirements
*	2GB RAM
*	2 vCPUs
*	20 GB disk space
*	No swap
For instructions on how to set up Ubuntu Server 22.04, see the document "Installing Ubuntu 22-04" in this Git repository.
For information on getting started with VirtualBox, see this video: https://www.youtube.com/watch?v=4qwUHSaIJdY
Alternatively, check out my video course "Virtualization for Everyone" for an introduction to different virtualization solution. 

To set up the required tools on the cluster nodes, the following scripts are provided:
*	setup-container.sh installs containerd. Run this script first
*	setup-kubetools.sh install the latest version of kubelet, kubeadm and kubectl
*	setup-kubetool-previousversion.sh installs the previous major version of the kubelet, kubeadm and kubectl. Use this if you want to practice cluster upgrades

