Why local kubernetes clusters?

A proper Kubernetes cluster needs minimum 2–3 VMs (EC2, local machines, or EKS) — all cost money.

To avoid cost, use a local mini cluster — works like a real cluster for ~99% of use cases.

Popular local cluster tools: kind (Kubernetes IN Docker), minikube, k3s.

The session uses kind — it runs a full cluster inside a Docker container on your local machine.

Installation

Windows / other OS
# Visit kind's official site and follow OS-specific installer

-------

kubectl — the CLI tool
kubectl is the command-line interface to talk to a Kubernetes cluster.

Kubernetes is an API system — kubectl translates plain commands into API calls on your behalf.

Just like AWS CLI for AWS, kubectl is the go-to CLI for Kubernetes ops.

Syntax is simple, almost plain-English: kubectl get pods, kubectl describe pod <name>, etc.

Must install alongside kind
brew install kubectl # Mac # or follow https://kubernetes.io/docs/tasks/tools/

----------------

# Creating a kind cluster

kind runs your entire Kubernetes cluster inside a Docker container on your laptop.

You can create multi-node clusters (control plane + worker nodes) without extra VMs.

Check existing clusters
kind get clusters

Create a new cluster
kind create cluster

On first run, no extra config needed — kind sets everything up automatically.

-------
Basic kubectl usage & namespaces (theory)

Namespace = a way to divide and isolate cluster resources — like splitting a team into sub-teams where each team gets its own space and resources.

Built on the same Linux concept used for containers: 
namespaces for isolation, 
cgroups for resource limits.

Get pods in default namespace
kubectl get pod # short: kubectl get p # Returns "No resources found" if default namespace is empty
Get pods across ALL namespaces
kubectl get pod -A # or --all-namespaces
By default all kubectl commands target the default namespace unless you specify otherwise.


----

Built-in namespaces
List all namespaces
kubectl get namespace # or kubectl get ns
Four default namespaces are auto-created when a cluster is started:

default → your working namespace; resources go here if no namespace specified 
kube-system → Kubernetes own internal components run here
 kube-public → publicly readable cluster info 
 kube-node-lease → used for node heartbeat / health tracking
kind-only extra namespace: local-path-storage — lets the kind cluster mount paths from your laptop as volumes. 
Not present in real/cloud clusters.

-----

kube-system namespace — what runs there
Kubernetes runs its own control-plane components as pods inside kube-system.

Everything in Kubernetes that "does something" runs as a pod. Configs are the only other type of resource.

Components found in kube-system (seen via kubectl get pod -A):

etcd-... → distributed key-value store (cluster state) 
kube-apiserver-... → API server (entry point for all requests) 
kube-controller-manager → runs controller loops (keeps desired state) 
kube-scheduler-... → assigns pods to nodes 
kube-proxy-... → networking/proxy on each node 
coredns-... → internal DNS for the cluster 
kindnet-... → CNI networking plugin (kind-specific)
 local-path-provisioner → volume support (kind-specific)

List pods in kube-system namespace
kubectl get pod -n kube-system

-----------

How default namespace works & -n flag
Any pod/resource you create without specifying a namespace lands in default.

To target a specific namespace, use the -n flag.

Commands

kubectl get pod # default namespace only
 kubectl get pod -A # all namespaces 
 kubectl get pod -n kube-system # specific namespace

In a single-node kind cluster, both control plane and worker roles are on the same container — that's why kube-proxy appears in kube-system (normally it lives on worker nodes in real clusters).

CoreDNS provides internal DNS resolution inside the cluster so pods can talk to each other by name.

--

# YAML files vs command line

Resources can be created via command line or YAML files — production teams always use YAML files.

Command line limits you to default arguments; YAML files give full control over all parameters.

Every Kubernetes resource is backed by an API — apiVersion in the YAML tells Kubernetes which API to use.

The kind field in the YAML = type of resource: Pod, Deployment, Service, etc.

Apply a YAML file (preferred over create)

kubectl apply -f <filename>.yaml # Use apply (not create) — it works for both new and updates

Don't memorise YAML syntax — use the official Kubernetes docs or GitHub Copilot to scaffold files.

#

