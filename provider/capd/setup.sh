#!/bin/bash

#variables
repo="https://github.com/kubernetes-sigs/cluster-api"
local_repo_location="./cluster-api"
default_branch="main"
provider_version="v1.2.99"
kube_version="1.23.3"
clstrpref=~/.cluster-api/
clstryaml=$clstrpref/clusterctl.yaml
clstrset=clusterctl-settings.json


#create the repository destination directory
if [ ! -e "${local_repo_location}" ];then
  mkdir -p "${local_repo_location}"
elif [ ! -d "${local_repo_location}" ];then
  echo "ERROR: ${local_repo_location} exists but is not a directory."
  exit 1
fi
cd "${local_repo_location}"

#  build the CAPD image

make -C test/infrastructure/docker docker-build REGISTRY=gcr.io/k8s-staging-capi-docker PULL_POLICY=IfNotPresent
make -C test/infrastructure/docker generate-manifests REGISTRY=gcr.io/k8s-staging-capi-docker


# Next, we need side-load this image into a kind cluster to make it available to the future CAPD deployment

k3d image import gcr.io/k8s-staging-capi-docker/capd-manager-amd64:dev -c mgmt-lcl

# instruct clusterctl to use the relevant providers
cat > clusterctl-settings.json <<EOF
{
  "providers": [
    "cluster-api",
    "bootstrap-kubeadm",
    "control-plane-kubeadm", 
    "infrastructure-docker"
    ]
}
EOF

# use local repo overrides
mkdir -p $clstrpref
rm -f $clstryaml
cat > $clstryaml <<EOF 
providers:
  - name: docker
    url: $HOME/.cluster-api/overrides/infrastructure-docker/latest/infrastructure-components.yaml
    type: InfrastructureProvider
EOF

rm -f $clstrset
cat > $clstrset <<EOF 
{
  "providers": ["cluster-api","bootstrap-kubeadm","control-plane-kubeadm", "infrastructure-docker"]
}
EOF