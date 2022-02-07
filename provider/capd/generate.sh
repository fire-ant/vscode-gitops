#!/bin/bash

#variables
kube_version="1.21.1"
cluster_name="vscode-gitops"
tenant_name="capd-tenant"
target_ns="default"
control_plane_machine_count="1"
worker_machine_count="1"

#  create tenant directory
mkdir -p infra/tenants/

# generate the cluster config
clusterctl generate cluster $tenant_name --kubernetes-version v$kube_version \
--from cluster-api/test/infrastructure/docker/templates/cluster-template-development.yaml \
--target-namespace $target_ns \
--control-plane-machine-count=$control_plane_machine_count \
--worker-machine-count=$worker_machine_count \
> infra/tenants/$tenant_name.yaml

status=$?
[ $status -eq 0 ] && echo "$cmd configuration stored in provider/infra/tenants/$tenant_name.yaml" || echo "$cmd generating configuration from template failed"