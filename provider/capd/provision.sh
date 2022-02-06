#! /bin/bash

kubectl apply -f infra/tenants/capd-tenant.yaml

# wait for the cluster to appear
kubectl wait cluster/capd-tenant --for condition=ready --timeout=10m

# copy the kubeconfig to file
clusterctl get kubeconfig capd-tenant >> /tmp/capd-tenant
