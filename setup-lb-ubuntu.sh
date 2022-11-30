#!/bin/bash
#
# source https://github.com/sandervanvugt/cka/setup-lb.sh

# script to set up load balancing on cluster nodes
# for use in CKA courses by Sander van Vugt
# version 0.7
# currently only tested on Ubuntu 22.04 LTS Server
# run this AFTER running setup-container.sh and setup-kubetools.sh
#
# TODO: remove the many password prompts

if which kubectl
then
	echo all good moving on
else
	echo please run setup-container.sh and setup-kubetools.sh first and then run this again
	exit 6
fi

## establish key based SSH with remote hosts
# obtain node information
if grep control1 /etc/hosts | grep -v 127
then
	export CONTROL1_IP=$(awk '/control1/ { print $1 }' /etc/hosts | grep -v 127)
else
	echo enter IP address for control1
	read CONTROL1_IP
	export CONTROL1_IP=$CONTROL1_IP
	sudo sh -c "echo $CONTROL1_IP control1 >> /etc/hosts"
fi


if grep control2 /etc/hosts | grep -v 127
then
        export CONTROL2_IP=$(awk '/control2/ { print $1 }' /etc/hosts | grep -v 127)
else
        echo enter IP address for control2
        read CONTROL2_IP
        export CONTROL2_IP=$CONTROL2_IP
        sudo sh -c "echo $CONTROL2_IP control2 >> /etc/hosts"
fi


if grep control3 /etc/hosts | grep -v 127
then
        export CONTROL3_IP=$(awk '/control3/ { print $1 }' /etc/hosts | grep -v 127)
else
        echo enter IP address for control3
        read CONTROL3_IP
        export CONTROL3_IP=$CONTROL3_IP
        sudo sh -c "echo $CONTROL3_IP control3 >> /etc/hosts"
fi


echo ##### READ ALL OF THIS BEFORE CONTINUING ######
echo this script requires you to run setup-container.sh and setup-kubetools.sh first
echo this script is based on the NIC name ens33
echo if your networkcard has a different name, edit keepalived.conf
echo before continuing and change "interface ens33" to match your config
echo .
echo this script will create a keepalived apiserver at 192.168.29.100
echo if this IP address does not match your network configuration,
echo manually change the check_apiserver.sh file before continuing
echo also change the IP address in keepalived.conf
echo .
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

# generating and distributing SSH keys
ssh-keygen
ssh-copy-id control1
ssh-copy-id control2
ssh-copy-id control3

# configuring sudo for easier access
sudo sh -c "echo 'Defaults timestamp_type=global,timestamp_timeout=60' >> /etc/sudoers"
sudo scp -p /etc/sudoers student@control2:/tmp/ && ssh -t control2 'sudo -S chown root:root /tmp/sudoers' && ssh -t control2 'sudo -S cp -p /tmp/sudoers /etc/'
sudo scp -p /etc/sudoers student@control3:/tmp/ && ssh -t control3 'sudo -S chown root:root /tmp/sudoers' && ssh -t control3 'sudo -S cp -p /tmp/sudoers /etc/'
#ssh control2 sudo -S sh -c "echo 'Defaults timestamp_type=global,timestamp_timeout=60' >> /etc/sudoers"
#ssh control3 sudo -S sh -c "echo 'Defaults timestamp_type=global,timestamp_timeout=60' >> /etc/sudoers"

# install required software
sudo apt install haproxy keepalived -y
ssh control2 "sudo -S apt install haproxy keepalived -y"
ssh control3 "sudo -S apt install haproxy keepalived -y"

scp /etc/hosts control2:/tmp && ssh -t control2 'sudo -S cp /tmp/hosts /etc/'
scp /etc/hosts control3:/tmp && ssh -t control3 'sudo -S cp /tmp/hosts /etc/'

# create keepalived config
# change IP address to anything that works in your environment!
sudo chmod +x check_apiserver.sh
sudo cp check_apiserver.sh /etc/keepalived/


scp check_apiserver.sh control2:/tmp && ssh -t control2 'sudo -S cp /tmp/check_apiserver.sh /etc/keepalived'
scp check_apiserver.sh control3:/tmp && ssh -t control3 'sudo -S cp /tmp/check_apiserver.sh /etc/keepalived'

#### creating site specific keepalived.conf file
sudo cp keepalived.conf keepalived-control2.conf
sudo cp keepalived.conf keepalived-control3.conf

sudo sed -i 's/state MASTER/state SLAVE/' keepalived-control2.conf
sudo sed -i 's/state MASTER/state SLAVE/' keepalived-control3.conf
sudo sed -i 's/priority 255/priority 254/' keepalived-control2.conf
sudo sed -i 's/priority 255/priority 253/' keepalived-control3.conf

sudo cp keepalived.conf /etc/keepalived/
scp keepalived-control2.conf control2:/tmp && ssh -t control2 'sudo -S cp /tmp/keepalived-control2.conf /etc/keepalived/keepalived.conf'
scp keepalived-control3.conf control3:/tmp && ssh -t control3 'sudo -S cp /tmp/keepalived-control3.conf /etc/keepalived/keepalived.conf'
echo DEBUG check if files are copied over successfully
read

### rewriting haproxy.cfg with site specific IP addresses
sudo sed -i s/server\ control1\ 1.1.1.1\:6443\ check/server\ control1\ $CONTROL1_IP\:6443\ check/ haproxy.cfg
sudo sed -i s/server\ control2\ 1.1.1.2\:6443\ check/server\ control2\ $CONTROL2_IP\:6443\ check/ haproxy.cfg
sudo sed -i s/server\ control3\ 1.1.1.3\:6443\ check/server\ control3\ $CONTROL3_IP\:6443\ check/ haproxy.cfg

# copy haproxy.cfg to destinations
sudo cp haproxy.cfg /etc/haproxy/
scp haproxy.cfg control2:/tmp && ssh -t control2 'sudo -S cp /tmp/haproxy.cfg /etc/haproxy/'
scp haproxy.cfg control3:/tmp && ssh -t control3 'sudo -S cp /tmp/haproxy.cfg /etc/haproxy/'
echo DEBUG check if haproxy files are copied over successfully
read

# start and enable services
sudo systemctl enable keepalived --now
sudo systemctl enable haproxy --now
ssh control2 sudo -S systemctl enable keepalived --now
ssh control2 sudo -S systemctl enable haproxy --now
ssh control3 sudo -S systemctl enable keepalived --now
ssh control3 sudo -S systemctl enable haproxy --now

echo setup is now done, please verify
echo the first node that started the services - normally control1 -  should run the virtual IP address 192.168.29.100
