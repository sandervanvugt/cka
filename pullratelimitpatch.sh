#!/bin/bash

# this scripts creates a secret and sets that as the default for the default service account
# the purpose is to overcome the Docker imagepullratelimit restriction

echo enter your docker username
read -s DOCKERUSER
echo enter your docker password
read -s DOCKERPASS

kubectl create secret docker-registry dockercreds \
	--docker-username=$DOCKERUSER \
	--docker-password=$DOCKERPASS \

kubectl patch serviceaccount default \
	-p '{"imagePullSecrets": [{"name": "dockercreds"}]}'

