#!/bin/bash
KUBEVERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name')
KUBEVERSION=${KUBEVERSION%.*}

CONTROLVERSION=$(kubectl get nodes | awk '/control/ { print $5 }')
CONTROLVERSION=${CONTROLVERSION%.*}

if [[ $KUBEVERSION == $CONTROLVERSION ]]
then
	echo -e "\033[32m[OK]\033[0m\t\t controlnode is running the latest version"
	SCORE=$(( SCORE + 20 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t controlnode is not running the latest version"
fi
TOTAL=$(( TOTAL + 20 ))

