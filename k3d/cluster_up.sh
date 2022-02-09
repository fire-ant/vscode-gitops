#!/bin/zsh

# set cluster name:
export CLUSTER_NAME=mgmt-lcl

# cluster_up:

k3d cluster create --config ./k3d/config.yaml --volume "$MANIFESTS/cluster-components:/var/lib/rancher/k3s/server/manifests/cluster-components" --volume "$MANIFESTS/cni/$1/:/var/lib/rancher/k3s/server/manifests/cni/$1/"

# replace_loopback:
sed -i "s/0.0.0.0.*/$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-$CLUSTER_NAME-server-0):6443/" ~/.kube/config 


if [[ $1 == "cilium" ]]; then
echo "running cilium specific docker mount commands";
docker exec -it k3d-$CLUSTER_NAME-agent-0 mount bpffs /sys/fs/bpf -t bpf;
docker exec -it k3d-$CLUSTER_NAME-agent-0 mount --make-shared /sys/fs/bpf;
docker exec -it k3d-$CLUSTER_NAME-server-0 mount bpffs /sys/fs/bpf -t bpf;
docker exec -it k3d-$CLUSTER_NAME-server-0 mount --make-shared /sys/fs/bpf;
fi