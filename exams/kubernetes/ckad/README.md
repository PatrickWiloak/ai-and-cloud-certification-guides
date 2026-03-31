# Certified Kubernetes Application Developer (CKAD)

## Exam Overview

The Certified Kubernetes Application Developer (CKAD) exam certifies that candidates can design, build, configure, and expose cloud-native applications for Kubernetes. This is a performance-based exam where you work directly in a live Kubernetes environment through a command-line terminal - there are no multiple-choice questions.

**Exam Details:**
- **Exam Code:** CKAD
- **Duration:** 2 hours
- **Format:** Performance-based, hands-on terminal environment
- **Passing Score:** 66%
- **Cost:** $395 USD (includes one free retake)
- **Delivery:** PSI online proctoring
- **Validity:** 3 years
- **Prerequisites:** None (hands-on Kubernetes application development experience recommended)
- **Kubernetes Version:** Exam environment runs a recent stable version (check CNCF for current version)
- **Allowed Resources:** Access to kubernetes.io/docs, kubernetes.io/blog, and github.com/kubernetes during the exam

## Exam Domains

### Domain 1: Application Design and Build (20%)
- Define, build, and modify container images
- Choose and use the right workload resource (Deployment, DaemonSet, CronJob, etc.)
- Understand multi-container Pod design patterns
- Utilize persistent and ephemeral volumes

**Key Skills:**
- Building and managing container images
- Creating Pods with multiple containers (sidecar, init, ambassador patterns)
- Working with Jobs and CronJobs
- Configuring persistent storage with PersistentVolumes and PersistentVolumeClaims
- Understanding container lifecycle hooks

### Domain 2: Application Deployment (20%)
- Use Kubernetes primitives to implement common deployment strategies
- Understand Deployments and how to perform rolling updates
- Use the Helm package manager to deploy existing packages
- Kustomize for configuration management

**Key Skills:**
- Creating and managing Deployments
- Performing rolling updates and rollbacks
- Implementing blue-green and canary deployment strategies
- Using Helm to install, upgrade, and manage charts
- Using Kustomize to customize application configuration

### Domain 3: Application Observability and Maintenance (15%)
- Understand API deprecations
- Implement probes and health checks
- Use built-in CLI tools to monitor Kubernetes applications
- Utilize container logs
- Debugging in Kubernetes

**Key Skills:**
- Configuring liveness, readiness, and startup probes
- Viewing and interpreting container logs with kubectl logs
- Monitoring resource usage with kubectl top
- Debugging Pods, containers, and services
- Understanding API version deprecations and migrations

### Domain 4: Application Environment, Configuration and Security (25%)
- Discover and use resources that extend Kubernetes (CRDs, Operators)
- Understand authentication, authorization, and admission control
- Understand requests, limits, and quotas
- Understand ConfigMaps and Secrets
- Understand SecurityContexts and ServiceAccounts

**Key Skills:**
- Creating and consuming ConfigMaps and Secrets
- Configuring SecurityContexts for Pods and containers
- Managing ServiceAccounts and RBAC
- Setting resource requests and limits
- Working with ResourceQuotas and LimitRanges
- Understanding admission controllers

### Domain 5: Services and Networking (20%)
- Demonstrate basic understanding of NetworkPolicies
- Provide and troubleshoot access to applications via services
- Use Ingress rules to expose applications

**Key Skills:**
- Creating and configuring Services (ClusterIP, NodePort, LoadBalancer, ExternalName)
- Configuring Ingress resources and controllers
- Implementing NetworkPolicies for traffic control
- Understanding Kubernetes DNS for service discovery
- Troubleshooting service connectivity

## Core Kubernetes Concepts

### Workload Resources

#### Pods
- Smallest deployable unit in Kubernetes
- Can contain one or more containers sharing network and storage
- Defined with a Pod spec that includes containers, volumes, and metadata
- Managed through higher-level controllers (Deployments, Jobs, etc.)

#### Multi-Container Pod Patterns
- **Sidecar**: Helper container that enhances the main container (logging agent, proxy, sync)
- **Init Container**: Runs to completion before app containers start (setup, migrations, config)
- **Ambassador**: Proxy container that handles external communication on behalf of the main container
- **Adapter**: Container that transforms or standardizes output from the main container

#### Deployments
- Declarative updates for Pods and ReplicaSets
- Supports rolling updates with configurable strategy
- Enables rollback to previous revisions
- Manages scaling and self-healing

#### Services
- Stable network endpoint for accessing a set of Pods
- Types: ClusterIP (internal), NodePort (external port), LoadBalancer (cloud LB), ExternalName (DNS alias)
- Label selectors determine which Pods receive traffic

### Configuration

#### ConfigMaps
- Store non-confidential configuration data as key-value pairs
- Can be consumed as environment variables, command-line arguments, or mounted as files
- Decouples configuration from container images

#### Secrets
- Store sensitive data (passwords, tokens, keys) with base64 encoding
- Similar consumption methods as ConfigMaps
- Should be used with RBAC and encryption at rest for production

### Storage

#### PersistentVolumes (PVs) and PersistentVolumeClaims (PVCs)
- PVs represent a piece of storage provisioned in the cluster
- PVCs are requests for storage by users
- Access modes: ReadWriteOnce, ReadOnlyMany, ReadWriteMany
- Storage classes enable dynamic provisioning

### Batch Workloads

#### Jobs
- Run-to-completion workloads
- Configurable parallelism and completion count
- Restart policy must be Never or OnFailure

#### CronJobs
- Schedule Jobs on a recurring basis using cron syntax
- Configure concurrency policy, starting deadline, and history limits

### Observability

#### Probes
- **Liveness Probe**: Detects if a container is stuck and needs restart
- **Readiness Probe**: Determines if a container is ready to accept traffic
- **Startup Probe**: Checks if an application has started (disables liveness/readiness until success)
- Probe types: HTTP GET, TCP Socket, Exec command, gRPC

#### Resource Management
- **Requests**: Minimum resources guaranteed to a container
- **Limits**: Maximum resources a container can consume
- Used by the scheduler for Pod placement decisions

### Security

#### Network Policies
- Control traffic flow between Pods at the IP/port level
- Default: all traffic allowed (no NetworkPolicy means open communication)
- Specify ingress and/or egress rules with pod/namespace/CIDR selectors

## Important Exam Notes

### This is a HANDS-ON Terminal Exam
- You will work in a real Kubernetes cluster through a browser-based terminal
- No multiple-choice questions - every task requires you to execute commands and create/modify resources
- Speed with kubectl is critical - practice imperative commands extensively
- You can access kubernetes.io documentation during the exam
- Learn to navigate the docs quickly to find YAML examples

### Imperative Commands are Your Best Friend
```bash
# Create a Pod quickly
kubectl run nginx --image=nginx --port=80

# Create a Deployment
kubectl create deployment myapp --image=nginx --replicas=3

# Expose a Deployment as a Service
kubectl expose deployment myapp --port=80 --target-port=80 --type=NodePort

# Generate YAML without creating the resource
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Create a Job
kubectl create job my-job --image=busybox -- echo "Hello"

# Create a CronJob
kubectl create cronjob my-cron --image=busybox --schedule="*/5 * * * *" -- echo "Hello"

# Create a ConfigMap
kubectl create configmap my-config --from-literal=key1=value1

# Create a Secret
kubectl create secret generic my-secret --from-literal=password=mysecret
```

### Key kubectl Commands to Master
```bash
# Debugging
kubectl describe pod <pod-name>
kubectl logs <pod-name> -c <container-name>
kubectl exec -it <pod-name> -- /bin/sh
kubectl get events --sort-by=.metadata.creationTimestamp

# Resource management
kubectl top pods
kubectl top nodes
kubectl get all -n <namespace>

# Quick edits
kubectl edit deployment <name>
kubectl set image deployment/<name> container=image:tag
kubectl scale deployment <name> --replicas=5
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>
```

## Kubestronaut Certification Path

The CKAD is one of five certifications in the CNCF Kubestronaut program:

1. **KCNA** - Kubernetes and Cloud Native Associate (entry-level knowledge)
2. **KCSA** - Kubernetes and Cloud Native Security Associate (security fundamentals)
3. **CKA** - Certified Kubernetes Administrator (cluster administration)
4. **CKAD** - Certified Kubernetes Application Developer (application development)
5. **CKS** - Certified Kubernetes Security Specialist (advanced security)

Earning all five grants the **Kubestronaut** title from CNCF.

## Study Resources

| Resource | Type | Link |
|----------|------|------|
| Kubernetes Official Documentation | Docs | [kubernetes.io/docs](https://kubernetes.io/docs/home/) |
| CKAD Exam Curriculum | Curriculum | [CNCF CKAD](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/) |
| Kubernetes the Hard Way | Lab | [GitHub](https://github.com/kelseyhightower/kubernetes-the-hard-way) |
| killer.sh CKAD Simulator | Practice | [killer.sh](https://killer.sh/) |
| Kubernetes Playground | Lab | [Play with Kubernetes](https://labs.play-with-k8s.com/) |

## Study Guide Contents

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Quick reference with official documentation links |
| [practice-plan.md](practice-plan.md) | 5-week hands-on study schedule |
| [scenarios.md](scenarios.md) | Exam-style hands-on task scenarios |
| [strategy.md](strategy.md) | Study strategy and exam tips |
| [notes/01-application-design-build.md](notes/01-application-design-build.md) | Application Design and Build domain notes |
| [notes/02-application-deployment.md](notes/02-application-deployment.md) | Application Deployment domain notes |
| [notes/03-observability-maintenance.md](notes/03-observability-maintenance.md) | Observability and Maintenance domain notes |
| [notes/04-environment-configuration-security.md](notes/04-environment-configuration-security.md) | Environment, Configuration and Security domain notes |
| [notes/05-services-networking.md](notes/05-services-networking.md) | Services and Networking domain notes |
| [notes/06-exam-tips.md](notes/06-exam-tips.md) | Exam tips and kubectl speed tricks |
