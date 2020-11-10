#!/bin/bash
#
# source https://github.com/sandervanvugt/cka/setup-lb.sh

# script to set up load balancing on cluster nodes
# for use in CKA courses by Sander van Vugt
# version 0.5
# currently only supporting CentOS 7.x
# run this AFTER running setup-docker.sh and setup-kubetools.sh

## establish key based SSH with remote hosts
# obtain node information
echo this script requires three nodes: control1 control2 and control3
echo enter the IP address for control1
read CONTROL1_IP
echo enter the IP address for control2
read CONTROL2_IP
echo enter the IP address for control3
read CONTROL3_IP
echo ##### READ ALL OF THIS BEFORE CONTINUING ######
echo this script requires you to run setup-docker.sh and setup-kubetools.sh first
echo this script is based on the NIC name ens33
echo if your networkcard has a different name, edit keepalived.conf
echo before continuing and change "interface ens33" to match your config
echo .
echo this script will create a keepalived apiserver at 192.168.4.100
echo if this IP address does not match your network configuration,
echo manually change the check_apiserver.sh file before continuing
echo press enter to continue or Ctrl-c to interrupt and apply modifications
read

# performing check on critical files
for i in keepalived.conf check_apiserver.sh haproxy.cfg
do
	if [ ! -f $i ]
	then
		echo $i should exist in the current directory && exit 2
	fi
done

# create /etc/hosts for all nodes
echo $CONTROL1_IP control1 >> /etc/hosts
echo $CONTROL2_IP control2 >> /etc/hosts
echo $CONTROL3_IP control3 >> /etc/hosts

# generating and distributing SSH keys
ssh-keygen
ssh-copy-id control1
ssh-copy-id control2
ssh-copy-id control3

# install required software
yum install haproxy keepalived -y
ssh control2 "yum install haproxy keepalived -y"
ssh control3 "yum install haproxy keepalived -y"

# copying /etc/hosts file
scp /etc/hosts control2:/etc/
scp /etc/hosts control3:/etc/

# create keepalived config
# change IP address to anything that works in your environment!
chmod +x check_apiserver.sh
cp check_apiserver.sh /etc/keepalived/
scp check_apiserver.sh control2:/etc/keepalived/
scp check_apiserver.sh control3:/etc/keepalived/

#### creating site specific keepalived.conf file
cp keepalived.conf keepalived-control2.conf
cp keepalived.conf keepalived-control3.conf

sed -i 's/state MASTER/state SLAVE/' keepalived-control2.conf
sed -i 's/state MASTER/state SLAVE/' keepalived-control3.conf
sed -i 's/priority 255/priority 254/' keepalived-control2.conf
sed -i 's/priority 255/priority 253/' keepalived-control3.conf

cp keepalived.conf /etc/keepalived/
scp keepalived-control2.conf control2:/etc/keepalived/keepalived.conf
scp keepalived-control3.conf control3:/etc/keepalived/keepalived.conf

### rewriting haproxy.cfg with site specific IP addresses
sed -i s/server\ control1\ 1.1.1.1\:6443\ check/server\ control1\ $CONTROL1_IP\:6443\ check/ haproxy.cfg
sed -i s/server\ control2\ 1.1.1.2\:6443\ check/server\ control2\ $CONTROL2_IP\:6443\ check/ haproxy.cfg
sed -i s/server\ control3\ 1.1.1.3\:6443\ check/server\ control3\ $CONTROL3_IP\:6443\ check/ haproxy.cfg

# copy haproxy.cfg to destinations
cp haproxy.cfg /etc/haproxy/
scp haproxy.cfg control2:/etc/haproxy/
scp haproxy.cfg control3:/etc/haproxy/

# start and enable services
systemctl enable keepalived --now
systemctl enable haproxy --now
ssh control2 systemctl enable keepalived --now
ssh control2 systemctl enable haproxy --now
ssh control3 systemctl enable keepalived --now
ssh control3 systemctl enable haproxy --now

echo setup is now done, please verify
echo control1 should run the virtual IP address 192.168.4.100
