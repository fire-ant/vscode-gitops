cmd/clusterctl/hack/create-local-repository.py
# You should be able to see the generated manifests at ~/..cluster-api/overrides/infrastructure-docker/latest/infrastructure-components.yaml, the only last thing we need to do is let clusterctl know where to find them:
clusterctl init \
   --core cluster-api:$provider_version \
   --bootstrap kubeadm:$provider_version \
   --control-plane kubeadm:$provider_version \
   --infrastructure docker:$provider_version \
   --config ~/.cluster-api/dev-repository/config.yaml