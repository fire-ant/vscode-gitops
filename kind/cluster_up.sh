#!/bin/zsh

# set_network:
export KIND_EXPERIMENTAL_DOCKER_NETWORK=vscode-gitops
export CLUSTER_NAME=vscode-gitops

# cluster_up:

kind create cluster --config=./kind/kind.yml --name vscode-gitops

# replace_loopback:
sed -i "s/127.0.0.1.*/$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CLUSTER_NAME-control-plane):6443/" ~/.kube/config 

# get_context:
kubectl cluster-info --context kind-$CLUSTER_NAME
