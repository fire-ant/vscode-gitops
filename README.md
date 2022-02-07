This is a quick and dirty all-in-one VScode setup for exploring clusterctl. Note its totally WIP and likely to break all the time.

 VSCode Environment

A Remote-Containers Devellopment/boostrap setup which compiles all the tools necessary to have fun and learn about Kubernetes on your laptop.

Requires:
VSCode
Docker

Uses a combination of: 
- Docker-in-Docker 
- Weaveworks binaries (Flux, Weave GitOps)
- Cluster-API Dev tooling (clusterctl, Make, Go)
- VScode plugins, including the Flux-GitOps integration
- Kubectl, Helm (but not MiniKube)
- Kind and K3D for dev clusters
- GH Cli

A bunch of shorthand commands listed under [.vscode/tasks.json](.vscode/tasks.json) to standup a local cluster on which you can load the cluster-api CRDs/Providers and learn about deploying tenant clusters (Docker/Kind).

Guide:

using Command+Shift+P and selecting 'Run Task:' will provide access to the list of commands. these are mostly self explanatory and work alongside the clusterctl bootstrap process which will deploy a local cluster, build a provider and bootstrap up to become a mgmt cluster. This will also generate the and init the tenant cluster config which can be found under [provider/cluster-api/infra/tenants](provider/cluster-api/infra/tenants). It should be straight forward to bring a cluster online and then use the add-on command the add its CNI.

Other ideas TBD

