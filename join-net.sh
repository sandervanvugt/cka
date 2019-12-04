#!/bin/bash
# run this on worker node only
# make sure this matches the mey in the output of the kubeadm init command

kubeadm join 192.168.4.110:8080 --token d0xzor.dns5rialmgzp5asv \
    --discovery-token-ca-cert-hash sha256:79e7203a963d1445d19707ea2c6f5c3c6f3c568bd97f825542575dea15a597ba
