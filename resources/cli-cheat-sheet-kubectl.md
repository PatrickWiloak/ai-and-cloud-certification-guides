# kubectl CLI Cheat Sheet

Quick reference for kubectl commands used in Kubernetes administration and CKA/CKAD/CKS exam preparation.

**Official Documentation:** https://kubernetes.io/docs/reference/kubectl/

---

## Table of Contents

- [Context and Namespace Management](#context-and-namespace-management)
- [Cluster Management](#cluster-management)
- [Pod Operations](#pod-operations)
- [Deployment Operations](#deployment-operations)
- [Service and Networking](#service-and-networking)
- [ConfigMap and Secret Management](#configmap-and-secret-management)
- [RBAC Commands](#rbac-commands)
- [Debugging Commands](#debugging-commands)
- [Imperative vs Declarative Patterns](#imperative-vs-declarative-patterns)
- [Useful Aliases and Shortcuts](#useful-aliases-and-shortcuts)

---

## Context and Namespace Management

```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context my-cluster

# Set default namespace for current context
kubectl config set-context --current --namespace=my-namespace

# View all namespaces
kubectl get namespaces

# Create a namespace
kubectl create namespace dev

# Delete a namespace (deletes all resources within it)
kubectl delete namespace dev

# View kubeconfig settings
kubectl config view

# Merge multiple kubeconfig files
KUBECONFIG=~/.kube/config:~/.kube/cluster2 kubectl config view --merge --flatten > merged-config

# Rename a context
kubectl config rename-context old-name new-name

# Delete a context
kubectl config delete-context my-context

# Set cluster credentials
kubectl config set-credentials user --token=my-token
```

---

## Cluster Management

```bash
# View cluster info
kubectl cluster-info

# View cluster info with more detail
kubectl cluster-info dump

# Check component statuses
kubectl get componentstatuses

# View nodes
kubectl get nodes

# View node details
kubectl describe node node-name

# Cordon a node (mark unschedulable)
kubectl cordon node-name

# Uncordon a node (mark schedulable)
kubectl uncordon node-name

# Drain a node (evict pods for maintenance)
kubectl drain node-name --ignore-daemonsets --delete-emptydir-data

# Taint a node
kubectl taint nodes node-name key=value:NoSchedule

# Remove a taint
kubectl taint nodes node-name key=value:NoSchedule-

# Label a node
kubectl label nodes node-name disktype=ssd

# Remove a label
kubectl label nodes node-name disktype-

# View API resources
kubectl api-resources

# View API versions
kubectl api-versions

# Check kubectl version
kubectl version --client
```

---

## Pod Operations

```bash
# List pods in current namespace
kubectl get pods

# List pods in all namespaces
kubectl get pods -A

# List pods with wide output (shows node, IP)
kubectl get pods -o wide

# List pods with labels
kubectl get pods --show-labels

# Filter pods by label
kubectl get pods -l app=nginx

# Filter pods by field selector
kubectl get pods --field-selector status.phase=Running

# Watch pods in real time
kubectl get pods -w

# Describe a pod (detailed info)
kubectl describe pod pod-name

# Get pod YAML definition
kubectl get pod pod-name -o yaml

# Get pod JSON definition
kubectl get pod pod-name -o json

# View pod logs
kubectl logs pod-name

# View logs for a specific container in a multi-container pod
kubectl logs pod-name -c container-name

# Follow logs in real time
kubectl logs -f pod-name

# View previous container logs (after crash)
kubectl logs pod-name --previous

# View last N lines of logs
kubectl logs pod-name --tail=100

# View logs since a time duration
kubectl logs pod-name --since=1h

# Execute a command in a running pod
kubectl exec pod-name -- ls /app

# Get an interactive shell in a pod
kubectl exec -it pod-name -- /bin/bash

# Execute command in a specific container
kubectl exec -it pod-name -c container-name -- /bin/sh

# Port-forward to a pod
kubectl port-forward pod-name 8080:80

# Port-forward to a pod (bind to all interfaces)
kubectl port-forward --address 0.0.0.0 pod-name 8080:80

# Copy files to/from a pod
kubectl cp local-file.txt pod-name:/remote/path
kubectl cp pod-name:/remote/file.txt ./local-file.txt

# Delete a pod
kubectl delete pod pod-name

# Force delete a pod
kubectl delete pod pod-name --grace-period=0 --force

# Delete all pods in a namespace
kubectl delete pods --all -n my-namespace

# Run a temporary pod for debugging
kubectl run tmp-shell --rm -it --image=busybox -- /bin/sh

# Create a pod with a specific image
kubectl run nginx --image=nginx --port=80

# Create a pod and expose it
kubectl run nginx --image=nginx --port=80 --expose

# Get pod resource usage
kubectl top pods

# Sort pods by restart count
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

# Get pods using custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
```

---

## Deployment Operations

```bash
# Create a deployment
kubectl create deployment nginx --image=nginx --replicas=3

# List deployments
kubectl get deployments

# Describe a deployment
kubectl describe deployment nginx

# Scale a deployment
kubectl scale deployment nginx --replicas=5

# Autoscale a deployment
kubectl autoscale deployment nginx --min=3 --max=10 --cpu-percent=80

# Update a deployment image
kubectl set image deployment/nginx nginx=nginx:1.25

# View rollout status
kubectl rollout status deployment/nginx

# View rollout history
kubectl rollout history deployment/nginx

# View a specific revision
kubectl rollout history deployment/nginx --revision=2

# Rollback to previous revision
kubectl rollout undo deployment/nginx

# Rollback to a specific revision
kubectl rollout undo deployment/nginx --to-revision=2

# Pause a rollout
kubectl rollout pause deployment/nginx

# Resume a rollout
kubectl rollout resume deployment/nginx

# Restart all pods in a deployment (rolling restart)
kubectl rollout restart deployment/nginx

# Edit a deployment
kubectl edit deployment nginx

# Delete a deployment
kubectl delete deployment nginx

# Patch a deployment
kubectl patch deployment nginx -p '{"spec":{"replicas":5}}'

# Set environment variable on a deployment
kubectl set env deployment/nginx ENV_VAR=value

# View ReplicaSets for a deployment
kubectl get replicasets -l app=nginx

# Create a Job
kubectl create job my-job --image=busybox -- echo "Hello"

# Create a CronJob
kubectl create cronjob my-cron --image=busybox --schedule="*/5 * * * *" -- echo "Hello"

# View DaemonSets
kubectl get daemonsets -A

# View StatefulSets
kubectl get statefulsets
```

---

## Service and Networking

```bash
# Create a service (expose a deployment)
kubectl expose deployment nginx --port=80 --target-port=80 --type=ClusterIP

# Create a NodePort service
kubectl expose deployment nginx --port=80 --type=NodePort

# Create a LoadBalancer service
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# List services
kubectl get services

# Describe a service
kubectl describe service nginx

# Get endpoints for a service
kubectl get endpoints nginx

# Port-forward to a service
kubectl port-forward svc/nginx 8080:80

# List Ingress resources
kubectl get ingress

# Describe an Ingress
kubectl describe ingress my-ingress

# List NetworkPolicies
kubectl get networkpolicies

# Describe a NetworkPolicy
kubectl describe networkpolicy my-policy

# View all services across namespaces
kubectl get svc -A

# DNS debugging - run a DNS lookup pod
kubectl run dnsutils --image=registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3 -it --rm -- nslookup kubernetes
```

---

## ConfigMap and Secret Management

```bash
# Create a ConfigMap from literal values
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2

# Create a ConfigMap from a file
kubectl create configmap my-config --from-file=config.txt

# Create a ConfigMap from a directory
kubectl create configmap my-config --from-file=config-dir/

# Create a ConfigMap from an env file
kubectl create configmap my-config --from-env-file=config.env

# View ConfigMaps
kubectl get configmaps

# Describe a ConfigMap
kubectl describe configmap my-config

# Get ConfigMap data
kubectl get configmap my-config -o yaml

# Edit a ConfigMap
kubectl edit configmap my-config

# Delete a ConfigMap
kubectl delete configmap my-config

# Create a Secret (generic)
kubectl create secret generic my-secret --from-literal=username=admin --from-literal=password=secret

# Create a Secret from a file
kubectl create secret generic my-secret --from-file=ssh-key=~/.ssh/id_rsa

# Create a TLS Secret
kubectl create secret tls my-tls --cert=cert.pem --key=key.pem

# Create a Docker registry Secret
kubectl create secret docker-registry my-reg \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=pass

# View Secrets
kubectl get secrets

# Describe a Secret (does not show values)
kubectl describe secret my-secret

# Decode a Secret value
kubectl get secret my-secret -o jsonpath='{.data.password}' | base64 -d

# Delete a Secret
kubectl delete secret my-secret
```

---

## RBAC Commands

```bash
# Create a Role
kubectl create role pod-reader --verb=get,list,watch --resource=pods

# Create a ClusterRole
kubectl create clusterrole pod-reader --verb=get,list,watch --resource=pods

# Create a RoleBinding
kubectl create rolebinding read-pods --role=pod-reader --user=jane

# Create a ClusterRoleBinding
kubectl create clusterrolebinding read-pods --clusterrole=pod-reader --user=jane

# Bind a ClusterRole to a ServiceAccount
kubectl create rolebinding sa-binding --clusterrole=edit --serviceaccount=default:my-sa

# List Roles
kubectl get roles

# List ClusterRoles
kubectl get clusterroles

# List RoleBindings
kubectl get rolebindings

# List ClusterRoleBindings
kubectl get clusterrolebindings

# Check if a user can perform an action
kubectl auth can-i create pods --as=jane

# Check permissions in a namespace
kubectl auth can-i list secrets --as=system:serviceaccount:default:my-sa -n kube-system

# Check all permissions for current user
kubectl auth can-i --list

# Create a ServiceAccount
kubectl create serviceaccount my-sa

# List ServiceAccounts
kubectl get serviceaccounts

# View ServiceAccount details
kubectl describe serviceaccount my-sa
```

---

## Debugging Commands

```bash
# Debug a running pod (ephemeral container)
kubectl debug pod-name -it --image=busybox

# Debug a node
kubectl debug node/node-name -it --image=ubuntu

# Copy a pod for debugging (with modified command)
kubectl debug pod-name -it --copy-to=debug-pod --container=app -- /bin/sh

# View resource usage for nodes
kubectl top nodes

# View resource usage for pods
kubectl top pods

# View resource usage for pods sorted by CPU
kubectl top pods --sort-by=cpu

# View resource usage for pods sorted by memory
kubectl top pods --sort-by=memory

# View resource usage for containers
kubectl top pods --containers

# View cluster events
kubectl get events

# View events sorted by time
kubectl get events --sort-by='.lastTimestamp'

# View events for a specific resource
kubectl get events --field-selector involvedObject.name=pod-name

# Watch events in real time
kubectl get events -w

# View resource quotas
kubectl get resourcequotas

# View limit ranges
kubectl get limitranges

# View PersistentVolumes
kubectl get pv

# View PersistentVolumeClaims
kubectl get pvc

# Describe a PVC
kubectl describe pvc my-pvc

# View storage classes
kubectl get storageclasses

# Explain a resource (built-in docs)
kubectl explain pods
kubectl explain pods.spec.containers
kubectl explain pods.spec.containers.resources --recursive

# Diff local config against cluster
kubectl diff -f my-resource.yaml

# View pod priority classes
kubectl get priorityclasses
```

---

## Imperative vs Declarative Patterns

### Imperative Commands (quick tasks, exam scenarios)

```bash
# Create resources directly
kubectl run nginx --image=nginx
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80

# Generate YAML without creating (dry-run)
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deploy.yaml
kubectl expose deployment nginx --port=80 --dry-run=client -o yaml > svc.yaml

# Create a Job YAML template
kubectl create job my-job --image=busybox --dry-run=client -o yaml -- echo "hello" > job.yaml

# Create a CronJob YAML template
kubectl create cronjob my-cron --image=busybox --schedule="*/5 * * * *" --dry-run=client -o yaml -- echo "hello" > cron.yaml
```

### Declarative Commands (production workflows)

```bash
# Apply a manifest
kubectl apply -f resource.yaml

# Apply all manifests in a directory
kubectl apply -f ./manifests/

# Apply from URL
kubectl apply -f https://example.com/resource.yaml

# Apply with recording (tracks changes)
kubectl apply -f resource.yaml --record

# Delete resources defined in a manifest
kubectl delete -f resource.yaml

# Replace a resource (must exist)
kubectl replace -f resource.yaml

# Force replace (delete and recreate)
kubectl replace --force -f resource.yaml

# Apply with server-side apply
kubectl apply -f resource.yaml --server-side
```

---

## Useful Aliases and Shortcuts

```bash
# Common aliases for .bashrc / .zshrc
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kns='kubectl config set-context --current --namespace'

# Enable kubectl autocompletion (bash)
source <(kubectl completion bash)
echo 'source <(kubectl completion bash)' >> ~/.bashrc

# Enable autocompletion for alias
complete -o default -F __start_kubectl k

# Enable kubectl autocompletion (zsh)
source <(kubectl completion zsh)
echo 'source <(kubectl completion zsh)' >> ~/.zshrc

# JSONPath examples
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'

# Quick resource shortnames
# po = pods, svc = services, deploy = deployments
# ds = daemonsets, sts = statefulsets, rs = replicasets
# cm = configmaps, pv = persistentvolumes, pvc = persistentvolumeclaims
# ns = namespaces, no = nodes, ing = ingresses
# sa = serviceaccounts, ep = endpoints, sc = storageclasses
# hpa = horizontalpodautoscalers, netpol = networkpolicies
```

---

## Quick Reference - Output Formatting

```bash
# Output formats
kubectl get pods -o wide          # Additional columns
kubectl get pods -o yaml          # YAML format
kubectl get pods -o json          # JSON format
kubectl get pods -o name          # Resource names only
kubectl get pods -o jsonpath='{.items[*].metadata.name}'  # JSONPath

# Custom columns
kubectl get pods -o custom-columns=\
  NAME:.metadata.name,\
  STATUS:.status.phase,\
  IP:.status.podIP,\
  NODE:.spec.nodeName

# Sort output
kubectl get pods --sort-by='.metadata.creationTimestamp'
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'
```

---

## Resources

- kubectl Reference: https://kubernetes.io/docs/reference/kubectl/
- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- kubectl Commands: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands
- JSONPath Support: https://kubernetes.io/docs/reference/kubectl/jsonpath/
