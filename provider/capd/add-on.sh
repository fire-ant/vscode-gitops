cd infra/tenants

# install calico
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O

# apply calico to cluster
kubectl apply -f calico.yaml --kubeconfig /tmp/capd-tenant