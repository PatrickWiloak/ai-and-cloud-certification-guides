# CKAD Fact Sheet - Certified Kubernetes Application Developer

## Exam Overview

**Exam Code:** CKAD
**Duration:** 2 hours
**Format:** Performance-based, hands-on terminal
**Passing Score:** 66%
**Cost:** $395 USD (includes one free retake)
**Delivery:** PSI online proctoring
**Validity:** 3 years
**Kubernetes Docs Access:** Allowed during the exam

**[📖 Official CKAD Page](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)** - Linux Foundation CKAD certification page
**[📖 CKAD Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam curriculum on GitHub
**[📖 CNCF Certification FAQ](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks)** - Frequently asked questions about the exam
**[📖 Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2)** - Exam policies and procedures
**[📖 Exam Tips from CNCF](https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad)** - Official tips for the exam environment

## Target Audience

The CKAD is designed for Kubernetes application developers who:
- Build, configure, and deploy applications on Kubernetes
- Understand core Kubernetes concepts and workload resources
- Work with container images and multi-container Pods
- Manage application configuration, storage, and networking
- Implement observability and debugging strategies

This certification does not focus on cluster administration tasks (that is the CKA). The CKAD is specifically about deploying and managing applications on an existing Kubernetes cluster.

## Exam Domain Breakdown

| Domain | Weight | Focus Areas |
|--------|--------|-------------|
| Application Design and Build | 20% | Pods, multi-container patterns, Jobs, CronJobs, volumes |
| Application Deployment | 20% | Deployments, rolling updates, Helm, Kustomize |
| Application Observability and Maintenance | 15% | Probes, logging, debugging, monitoring |
| Application Environment, Configuration and Security | 25% | ConfigMaps, Secrets, SecurityContexts, RBAC, quotas |
| Services and Networking | 20% | Services, Ingress, NetworkPolicies, DNS |

---

## Domain 1: Application Design and Build (20%)

### Pod Design and Multi-Container Patterns

- **[📖 Pods Overview](https://kubernetes.io/docs/concepts/workloads/pods/)** - Core Pod concepts and lifecycle
- **[📖 Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)** - Pod phases and container states
- **[📖 Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)** - Containers that run before app containers
- **[📖 Sidecar Containers](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/)** - Native sidecar container support
- **[📖 Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)** - PostStart and PreStop hooks
- **[📖 Container Environment Variables](https://kubernetes.io/docs/concepts/containers/container-environment-variables/)** - Environment variable sources

**Multi-Container Pod Patterns:**
- **Sidecar**: Extends the main container (e.g., log shipper, config reloader, proxy). Runs alongside the main container for the entire Pod lifecycle.
- **Init Container**: Runs to completion before the main container starts. Used for setup tasks like waiting for a service, populating volumes, or running migrations.
- **Ambassador**: Proxy container that handles outbound connections. The main container connects to localhost and the ambassador routes to the appropriate external service.
- **Adapter**: Normalizes or transforms the main container's output (e.g., reformatting logs for a centralized system).

### Container Images

- **[📖 Images Overview](https://kubernetes.io/docs/concepts/containers/images/)** - Container image concepts
- **[📖 Image Pull Policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy)** - Always, IfNotPresent, Never
- **[📖 Private Registry Authentication](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)** - Using imagePullSecrets

**Key Concepts:**
- Image naming: `registry/repository:tag` (e.g., `docker.io/library/nginx:1.25`)
- Default pull policy: `IfNotPresent` for tagged images, `Always` for `:latest`
- Use specific image tags in production, never rely on `:latest`
- ImagePullSecrets reference a Secret with registry credentials

### Jobs and CronJobs

- **[📖 Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)** - Run-to-completion workloads
- **[📖 CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)** - Scheduled Jobs
- **[📖 Automatic Cleanup for Finished Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/)** - TTL controller

**Job Configuration:**
- `completions`: Number of times the Job should complete successfully
- `parallelism`: Number of Pods running concurrently
- `backoffLimit`: Number of retries before marking the Job as failed
- `activeDeadlineSeconds`: Maximum time a Job can run
- `restartPolicy`: Must be `Never` or `OnFailure` (not `Always`)

**CronJob Configuration:**
- `schedule`: Cron expression (e.g., `"*/5 * * * *"` for every 5 minutes)
- `concurrencyPolicy`: `Allow`, `Forbid`, or `Replace`
- `startingDeadlineSeconds`: Deadline for starting a Job if the schedule is missed
- `successfulJobsHistoryLimit`: Number of successful Jobs to retain (default 3)
- `failedJobsHistoryLimit`: Number of failed Jobs to retain (default 1)

### Persistent and Ephemeral Volumes

- **[📖 Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)** - Volume types and usage
- **[📖 Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)** - PV and PVC lifecycle
- **[📖 Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)** - Dynamic provisioning
- **[📖 Ephemeral Volumes](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/)** - Temporary storage
- **[📖 Projected Volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/)** - Combining multiple sources

**Volume Types to Know:**
- `emptyDir`: Temporary directory, exists for the life of the Pod
- `hostPath`: Mounts a file or directory from the node (use carefully)
- `persistentVolumeClaim`: References a PVC for persistent storage
- `configMap` / `secret`: Mount ConfigMap or Secret data as files
- `projected`: Combines multiple volume sources into a single directory

**PVC Access Modes:**
- `ReadWriteOnce (RWO)`: Mounted as read-write by a single node
- `ReadOnlyMany (ROX)`: Mounted as read-only by many nodes
- `ReadWriteMany (RWX)`: Mounted as read-write by many nodes
- `ReadWriteOncePod (RWOP)`: Mounted as read-write by a single Pod

---

## Domain 2: Application Deployment (20%)

### Deployments and Rolling Updates

- **[📖 Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** - Declarative application management
- **[📖 Rolling Update Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)** - Zero-downtime updates
- **[📖 Managing Resources](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)** - Deployment management patterns
- **[📖 Scaling a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)** - Horizontal scaling

**Rolling Update Parameters:**
- `maxUnavailable`: Max Pods that can be unavailable during update (default 25%)
- `maxSurge`: Max Pods that can be created above desired count (default 25%)
- `minReadySeconds`: Minimum seconds a Pod must be ready before considered available
- `revisionHistoryLimit`: Number of old ReplicaSets to retain (default 10)

**Rollback Commands:**
```bash
kubectl rollout status deployment/myapp
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp
kubectl rollout undo deployment/myapp --to-revision=2
kubectl rollout pause deployment/myapp
kubectl rollout resume deployment/myapp
```

### Deployment Strategies

- **[📖 Canary Deployments](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments)** - Gradual traffic shifting

**Blue-Green Deployment:**
1. Deploy the new version as a separate Deployment with different labels
2. Verify the new version is healthy
3. Update the Service selector to point to the new version
4. Keep the old version running temporarily for quick rollback

**Canary Deployment:**
1. Create a small Deployment of the new version alongside the existing one
2. Both Deployments share the same label so the Service routes to both
3. Gradually scale up the canary and scale down the old version
4. Monitor for errors before completing the rollout

### Helm Package Manager

- **[📖 Helm Documentation](https://helm.sh/docs/)** - Official Helm docs
- **[📖 Helm Quickstart](https://helm.sh/docs/intro/quickstart/)** - Getting started with Helm
- **[📖 Helm Charts](https://helm.sh/docs/topics/charts/)** - Chart structure and development

**Essential Helm Commands:**
```bash
# Add a chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Search for charts
helm search repo nginx
helm search hub wordpress

# Install a chart
helm install my-release bitnami/nginx
helm install my-release bitnami/nginx --set replicaCount=3
helm install my-release bitnami/nginx -f values.yaml

# List releases
helm list
helm list -n my-namespace

# Upgrade a release
helm upgrade my-release bitnami/nginx --set replicaCount=5

# Rollback a release
helm rollback my-release 1

# Uninstall a release
helm uninstall my-release

# Show chart information
helm show values bitnami/nginx
helm show chart bitnami/nginx
```

### Kustomize

- **[📖 Kustomize Documentation](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)** - Managing objects with Kustomize
- **[📖 Kustomize Feature List](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#kustomize-feature-list)** - Available features

**Key Kustomize Features:**
- Generates ConfigMaps and Secrets from files or literals
- Applies common labels, annotations, and namespace
- Patches resources with strategic merge patches or JSON patches
- Builds and applies with `kubectl apply -k ./`

```yaml
# kustomization.yaml example
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
namespace: production
commonLabels:
  app: myapp
  env: production
configMapGenerator:
  - name: app-config
    literals:
      - DB_HOST=db.production.svc
      - LOG_LEVEL=info
```

---

## Domain 3: Application Observability and Maintenance (15%)

### Probes and Health Checks

- **[📖 Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)** - Detailed probe configuration
- **[📖 Pod Lifecycle - Container Probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)** - Probe concepts

**Probe Types:**
| Probe | Purpose | Failure Action |
|-------|---------|---------------|
| Liveness | Is the container running correctly? | Restart the container |
| Readiness | Is the container ready to serve traffic? | Remove from Service endpoints |
| Startup | Has the application finished starting? | Restart (disables liveness/readiness until success) |

**Probe Mechanisms:**
- `httpGet`: HTTP GET request - success is 200-399 status code
- `tcpSocket`: TCP connection attempt - success if connection established
- `exec`: Execute a command - success if exit code is 0
- `grpc`: gRPC health check - success if status is SERVING

**Probe Parameters:**
- `initialDelaySeconds`: Seconds before first probe (default 0)
- `periodSeconds`: How often to perform the probe (default 10)
- `timeoutSeconds`: Seconds after which probe times out (default 1)
- `successThreshold`: Consecutive successes needed (default 1)
- `failureThreshold`: Consecutive failures to trigger action (default 3)

### Logging and Monitoring

- **[📖 Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)** - Kubernetes logging concepts
- **[📖 Monitoring Resource Usage](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)** - Resource monitoring
- **[📖 Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)** - Metrics pipeline

**Key Commands:**
```bash
# View container logs
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>     # specific container
kubectl logs <pod-name> --previous               # previous instance
kubectl logs <pod-name> -f                       # stream logs
kubectl logs <pod-name> --tail=100               # last 100 lines
kubectl logs <pod-name> --since=1h               # last hour

# Resource usage
kubectl top pods
kubectl top pods -n <namespace>
kubectl top nodes
kubectl top pod <pod-name> --containers
```

### Debugging Applications

- **[📖 Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)** - Troubleshooting Pod issues
- **[📖 Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)** - Troubleshooting Service issues
- **[📖 Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)** - Inspecting running containers
- **[📖 Get a Shell to a Running Container](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/)** - Exec into containers
- **[📖 Troubleshooting](https://kubernetes.io/docs/tasks/debug/)** - General troubleshooting guide

**Debugging Workflow:**
1. `kubectl get pods` - Check Pod status
2. `kubectl describe pod <name>` - Check events and conditions
3. `kubectl logs <name>` - Check application logs
4. `kubectl exec -it <name> -- /bin/sh` - Interactive shell
5. `kubectl get events --sort-by=.metadata.creationTimestamp` - Cluster events

### API Deprecations

- **[📖 Kubernetes Deprecation Policy](https://kubernetes.io/docs/reference/using-api/deprecation-policy/)** - API deprecation rules
- **[📖 Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)** - Migration paths

**Key Points:**
- API versions progress: `v1alpha1` -> `v1beta1` -> `v1`
- Deprecated APIs are supported for at least the deprecation period before removal
- Use `kubectl convert` or update manifests manually when APIs change
- Check `kubectl api-resources` and `kubectl api-versions` for available APIs

---

## Domain 4: Application Environment, Configuration and Security (25%)

### ConfigMaps

- **[📖 ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)** - ConfigMap concepts
- **[📖 Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)** - Consuming ConfigMaps

**Creation Methods:**
```bash
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2
kubectl create configmap my-config --from-file=config.properties
kubectl create configmap my-config --from-env-file=config.env
```

**Consumption Methods:**
- Environment variables: `envFrom` or individual `env` with `configMapKeyRef`
- Volume mounts: Mount as files in a directory
- Command arguments: Reference in container command/args

### Secrets

- **[📖 Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Secret concepts and types
- **[📖 Managing Secrets](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)** - Creating Secrets with kubectl
- **[📖 Using Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets)** - Consuming Secrets in Pods

**Secret Types:**
- `Opaque`: Generic key-value pairs (default)
- `kubernetes.io/dockerconfigjson`: Docker registry credentials
- `kubernetes.io/tls`: TLS certificate and key
- `kubernetes.io/basic-auth`: Basic authentication credentials
- `kubernetes.io/service-account-token`: ServiceAccount token

**Creation:**
```bash
kubectl create secret generic my-secret --from-literal=username=admin --from-literal=password=secret123
kubectl create secret docker-registry my-reg-secret --docker-server=registry.example.com --docker-username=user --docker-password=pass
kubectl create secret tls my-tls --cert=cert.pem --key=key.pem
```

### SecurityContexts

- **[📖 Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - SecurityContext configuration
- **[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Privileged, Baseline, Restricted

**Common SecurityContext Settings:**
```yaml
securityContext:
  runAsUser: 1000
  runAsGroup: 3000
  runAsNonRoot: true
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
    add:
      - NET_BIND_SERVICE
```

### ServiceAccounts

- **[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - ServiceAccount concepts
- **[📖 Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)** - Using ServiceAccounts
- **[📖 Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)** - Administration

**Key Points:**
- Every namespace has a `default` ServiceAccount
- Pods use the default ServiceAccount unless specified otherwise
- Assign specific ServiceAccounts for fine-grained access control
- ServiceAccount tokens are automatically mounted (can be disabled with `automountServiceAccountToken: false`)

### ResourceQuotas and LimitRanges

- **[📖 Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)** - Namespace-level resource constraints
- **[📖 Limit Ranges](https://kubernetes.io/docs/concepts/policy/limit-range/)** - Default and max/min resource constraints
- **[📖 Manage Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** - Container resource management

**ResourceQuota**: Limits total resource consumption per namespace (CPU, memory, number of objects)
**LimitRange**: Sets default, min, and max resource constraints per Pod/container in a namespace

### Admission Controllers

- **[📖 Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - What they are and how they work
- **[📖 Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)** - Webhooks

**Key Admission Controllers:**
- `NamespaceLifecycle`: Prevents creation in non-existent namespaces
- `LimitRanger`: Enforces LimitRange constraints
- `ResourceQuota`: Enforces ResourceQuota constraints
- `ServiceAccount`: Automates ServiceAccount assignment
- `PodSecurity`: Enforces Pod Security Standards

### Custom Resources and Operators

- **[📖 Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)** - Extending the Kubernetes API
- **[📖 Custom Resource Definitions](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)** - Creating CRDs
- **[📖 Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)** - Automated application management

---

## Domain 5: Services and Networking (20%)

### Services

- **[📖 Service](https://kubernetes.io/docs/concepts/services-networking/service/)** - Service concepts and types
- **[📖 Connecting Applications with Services](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)** - Practical Service usage
- **[📖 Use a Service to Access an Application in a Cluster](https://kubernetes.io/docs/tasks/access-application-cluster/service-access-application-cluster/)** - Service tutorial

**Service Types:**
| Type | Description | Use Case |
|------|-------------|----------|
| ClusterIP | Internal cluster IP (default) | Internal communication between services |
| NodePort | Exposes on each node's IP at a static port (30000-32767) | Development and testing |
| LoadBalancer | Provisions external load balancer (cloud provider) | Production external access |
| ExternalName | Maps to a DNS name (CNAME) | Referencing external services |

**Imperative Creation:**
```bash
kubectl expose deployment myapp --port=80 --target-port=8080 --type=ClusterIP
kubectl expose deployment myapp --port=80 --target-port=8080 --type=NodePort
kubectl expose pod mypod --port=80 --target-port=8080 --name=my-service
```

### Ingress

- **[📖 Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress concepts and configuration
- **[📖 Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available controllers
- **[📖 Set up Ingress on Minikube](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)** - Practical Ingress tutorial

**Ingress Features:**
- Host-based routing (route by domain name)
- Path-based routing (route by URL path)
- TLS termination
- Default backend for unmatched requests
- Requires an Ingress controller to be installed in the cluster

**Example Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 80
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
  tls:
    - hosts:
        - myapp.example.com
      secretName: tls-secret
```

### Network Policies

- **[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - Traffic control between Pods
- **[📖 Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Creating NetworkPolicies

**Key Concepts:**
- By default, all Pods can communicate with all other Pods
- A NetworkPolicy selects Pods using `podSelector` and defines allowed `ingress` and `egress` rules
- Once a Pod is selected by any NetworkPolicy, all traffic not explicitly allowed is denied
- Rules can select by: `podSelector`, `namespaceSelector`, `ipBlock` (CIDR)
- Requires a CNI plugin that supports NetworkPolicies (Calico, Cilium, Weave Net)

**Example - Allow only specific Pods:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

### DNS for Services and Pods

- **[📖 DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)** - Kubernetes DNS

**DNS Naming:**
- Services: `<service-name>.<namespace>.svc.cluster.local`
- Pods: `<pod-ip-dashed>.<namespace>.pod.cluster.local`
- Within the same namespace, use just the service name: `my-service`
- Across namespaces, use: `my-service.other-namespace`

---

## Exam Environment Tips

### Tools Available in the Exam
- `kubectl` with bash/zsh autocompletion
- `vim` and `nano` for text editing
- `tmux` for terminal multiplexing
- `curl` and `wget` for HTTP requests
- `jq` for JSON processing
- Access to kubernetes.io/docs, kubernetes.io/blog, and github.com/kubernetes

### Time Management
- 2 hours for approximately 15-20 tasks
- Average 6-8 minutes per task
- Flag difficult tasks and come back to them
- Easy tasks first to bank points quickly
- Verify your work before moving on - points for partial completion are possible

### Critical Shortcuts
```bash
# Set up aliases at the start of the exam
alias k=kubectl
export do="--dry-run=client -o yaml"

# Quick resource creation
k run pod1 --image=nginx $do > pod1.yaml
k create deploy d1 --image=nginx --replicas=3 $do > d1.yaml

# Context switching (exam uses multiple clusters)
kubectl config use-context <context-name>
kubectl config get-contexts
```

### Common Pitfalls
- Forgetting to switch context between tasks
- Not checking the correct namespace
- YAML indentation errors
- Forgetting to verify the resource was created correctly
- Spending too long on a single question
- Not reading the full question before starting
