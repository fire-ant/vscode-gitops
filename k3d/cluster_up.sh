#!/bin/zsh

# set cluster name:
export CLUSTER_NAME=mgmt-lcl

# cluster_up:

k3d cluster create --config ./k3d/config.yaml --volume "$~MANIFESTS:/var/lib/rancher/k3s/server/manifests/"

# replace_loopback:
sed -i "s/0.0.0.0.*/$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-$CLUSTER_NAME-server-0):6443/" ~/.kube/config 

