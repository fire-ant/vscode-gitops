#!/bin/bash

#variables
repo="https://github.com/kubernetes-sigs/cluster-api"
local_repo_location="./cluster-api"
default_branch="main"

#create the repository destination directory
if [ ! -e "${local_repo_location}" ];then
  mkdir -p "${local_repo_location}"
elif [ ! -d "${local_repo_location}" ];then
  echo "ERROR: ${local_repo_location} exists but is not a directory."
  exit 1
fi
cd "${local_repo_location}"

make -C test/infrastructure/docker docker-build REGISTRY=gcr.io/k8s-staging-capi-docker
make -C test/infrastructure/docker ge

# generate-manifests REGISTRY=gcr.io/k8s-staging-capi-docker
# Next, we need side-load this image into a kind cluster to make it available to the future CAPD deployment

# k3d image import clusterapi gcr.io/k8s-staging-capi-docker/capd-manager-amd64:dev

cat > clusterctl-settings.json <<EOF
{
  "providers": ["cluster-api","bootstrap-kubeadm","control-plane-kubeadm", "infrastructure-docker"]
}
EOF
cmd/clusterctl/hack/local-overrides.py
# You should be able to see the generated manifests at ~/..cluster-api/overrides/infrastructure-docker/latest/infrastructure-components.yaml, the only last thing we need to do is let clusterctl know where to find them:

cat > ~/.cluster-api/clusterctl.yaml <<EOF
providers:
  - name: docker
    url: $HOME/.cluster-api/overrides/infrastructure-docker/latest/infrastructure-components.yaml
    type: InfrastructureProvider
EOF
# Finally, we can use the clusterctl init command printed by the local-verrides.py script to create all CAPI and CAPD components inside our kind cluster:

# clusterctl init --core cluster-api:v0.3.0 --bootstrap kubeadm:v0.3.0 --control-plane kubeadm:v0.3.0 --infrastructure docker:v0.3.0