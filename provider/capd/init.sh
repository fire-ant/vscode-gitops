provider_version=1.2.99

cd cluster-api/
cmd/clusterctl/hack/create-local-repository.py
# You should be able to see the generated manifests at ~/.cluster-api/dev-repository/infrastructure-docker/latest/infrastructure-components.yaml, the only last thing we need to do is let clusterctl know where to find them:
clusterctl init \
   --core cluster-api:v$provider_version \
   --bootstrap kubeadm:v$provider_version \
   --control-plane kubeadm:v$provider_version \
   --infrastructure docker:v$provider_version \
   --config ~/.cluster-api/dev-repository/config.yaml