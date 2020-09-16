#!/bin/bash
#
# echo script to set up load balancing on cluster nodes
# for use in CKA courses by Sander van Vugt
# version 0.1 - may be buggy!
# currently only supporting CentOS 7.x
# run this AFTER running setup-docker.sh and setup-kubetools.sh
# read and try to udnerstand before running this!

# install required software
yum install haproxy keepalived -y

# create keepalived config
# change IP address to anything that works in your environment!
cat << EOF >> /etc/keepalived/check_apiserver.sh
APISERVER_VIP=192.168.4.100
APISERVER_DEST_PORT=6443

errorExit() {
        echo "* * * $*" 1>&2
        exit 1
}

curl --silent --max-time 2 --insecure https://localhost:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://localhost:${APISERVER_DEST_PORT}/"
if ip addr | grep -q ${APISERVER_VIP}; then
        curl --silent --max-time 2 --insecure https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/"
EOF

#### creating second script, make sure to change IP addresses!

cat << EOF >> /etc/keepalived/keepalived.conf
! /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  weight -2
  fall 10
  rise 2
}

vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 151
    priority 255
    authentication {
        auth_type PASS
        auth_pass Password
    }
    virtual_ipaddress {
        192.168.4.100/24
    }
    track_script {
        check_apiserver
    }
}
EOF

chmod +x /etc/keepalived/check_apiserver.sh

### setting up haproxy
echo > /etc/haproxy/haproxy.cfg
cat << EOF >> /etc/haproxy/haproxy.cfg

    #   /etc/sysconfig/syslog
    #
    #    local2.*                       /var/log/haproxy.log
    #
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
#---------------------------------------------------------------------
# apiserver frontend which proxys to the masters
#---------------------------------------------------------------------
frontend apiserver
    bind *:8443
    mode tcp
    option tcplog
    default_backend apiserver
#---------------------------------------------------------------------
# round robin balancing for apiserver
#---------------------------------------------------------------------
backend apiserver
    option httpchk GET /healthz
    http-check expect status 200
    mode tcp
    option ssl-hello-chk
    balance     roundrobin
        server control1 192.168.4.87:6443 check
        server control2 192.168.4.88:6443 check
        server control3 192.168.4.89:6443 check
EOF

echo enter IP address of second HA node
read SECONDNODE

echo enter IP address of third HA node
read THIRDNODE

systemctl enable keepalived --now
systemctl enable haproxy --now

echo now edit the keepalived.conf file on $SECONDNODE and $THIRDNODE
echo change "state MASTER" to "state SLAVE"
echo set priority to 254 on $SECONDNODE and 253 on $THIRDNODE
echo and use systemctl to enable --now keepalived and haproxy services
echo I will automate this in a later version of this script
for i in $SECONDNODE $THIRDNODE; do scp /etc/keepalived/check_apiserver.sh /etc/keepalived/keepalived.conf root@$i:/etc/keepalived; scp /etc/haproxy/haproxy.cfg root@$i:/etc/haproxy; done
