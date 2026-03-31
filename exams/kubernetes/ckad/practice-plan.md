# CKAD Study Plan - 5-Week Hands-On Schedule

## Prerequisites

Before starting this plan, ensure you have:
- [ ] A Kubernetes cluster for practice (minikube, kind, or cloud-based)
- [ ] `kubectl` installed and configured
- [ ] `helm` installed
- [ ] Basic familiarity with containers and Docker
- [ ] Terminal/command-line comfort

## Week 1: Application Design and Build

### Day 1-2: Pods and Multi-Container Patterns
- [ ] Create Pods using imperative commands (`kubectl run`)
- [ ] Write Pod YAML manifests from scratch
- [ ] Create a Pod with a sidecar container (main app + log shipper)
- [ ] Create a Pod with an init container (wait for service, then start app)
- [ ] Create a Pod with an ambassador container (proxy pattern)
- [ ] Practice `--dry-run=client -o yaml` to generate YAML templates
- [ ] Lab: Deploy a multi-container Pod where the sidecar reads logs from a shared emptyDir volume
- [ ] Review Notes: `notes/01-application-design-build.md`

### Day 3-4: Jobs, CronJobs, and Container Images
- [ ] Create Jobs with `kubectl create job`
- [ ] Configure Job completions and parallelism
- [ ] Create CronJobs with different schedules
- [ ] Test CronJob concurrency policies (Allow, Forbid, Replace)
- [ ] Practice setting `activeDeadlineSeconds` and `backoffLimit`
- [ ] Lab: Create a Job that processes data in parallel with 3 completions and 2 parallelism
- [ ] Lab: Create a CronJob that runs every minute and verify execution history

### Day 5: Persistent Storage
- [ ] Create PersistentVolumes and PersistentVolumeClaims
- [ ] Mount PVCs in Pods
- [ ] Understand access modes (RWO, ROX, RWX)
- [ ] Work with emptyDir and hostPath volumes
- [ ] Lab: Create a PVC, mount it in a Pod, write data, delete the Pod, and verify data persists in a new Pod
- [ ] Lab: Mount a ConfigMap and Secret as volumes

### Day 6-7: Week 1 Review and Practice
- [ ] Recreate all labs from memory without referencing notes
- [ ] Time yourself creating Pods, Jobs, and CronJobs
- [ ] Practice switching between imperative and declarative approaches
- [ ] Complete 5 practice scenarios from `scenarios.md`

---

## Week 2: Application Deployment

### Day 8-9: Deployments and Rolling Updates
- [ ] Create Deployments with `kubectl create deployment`
- [ ] Scale Deployments up and down
- [ ] Perform rolling updates by changing the image
- [ ] Configure `maxUnavailable` and `maxSurge`
- [ ] Rollback to previous revisions with `kubectl rollout undo`
- [ ] View rollout history and status
- [ ] Lab: Deploy nginx:1.23, update to nginx:1.25, then rollback to 1.23
- [ ] Lab: Perform a rolling update with maxUnavailable=0 and maxSurge=1
- [ ] Review Notes: `notes/02-application-deployment.md`

### Day 10-11: Deployment Strategies and Helm
- [ ] Implement a blue-green deployment using label selectors
- [ ] Implement a canary deployment with two Deployments behind one Service
- [ ] Install Helm and add chart repositories
- [ ] Install a chart with custom values
- [ ] Upgrade and rollback Helm releases
- [ ] Lab: Deploy v1 (blue) and v2 (green) of an app, switch traffic by updating the Service selector
- [ ] Lab: Install and customize an nginx chart with Helm, then upgrade it

### Day 12-13: Kustomize
- [ ] Create a basic kustomization.yaml with resources
- [ ] Use `commonLabels` and `namespace` overlays
- [ ] Generate ConfigMaps with `configMapGenerator`
- [ ] Apply patches to modify base resources
- [ ] Use `kubectl apply -k` to deploy
- [ ] Lab: Create a base deployment and service, then create overlays for dev and production environments

### Day 14: Week 2 Review
- [ ] Practice Deployment operations under time pressure
- [ ] Helm install, upgrade, rollback cycle from memory
- [ ] Kustomize build and apply for multiple environments
- [ ] Complete 3 deployment-focused practice scenarios

---

## Week 3: Observability, Configuration, and Security

### Day 15-16: Probes, Logging, and Debugging
- [ ] Configure liveness probes (httpGet, exec, tcpSocket)
- [ ] Configure readiness probes
- [ ] Configure startup probes for slow-starting applications
- [ ] Use `kubectl logs` with various flags (-c, -f, --previous, --tail, --since)
- [ ] Debug failing Pods with `kubectl describe` and `kubectl events`
- [ ] Use `kubectl exec` to inspect running containers
- [ ] Use `kubectl top` to monitor resource usage
- [ ] Lab: Create a Pod with a liveness probe that fails after 30 seconds and observe the restart
- [ ] Lab: Debug a Pod that is in CrashLoopBackOff
- [ ] Review Notes: `notes/03-observability-maintenance.md`

### Day 17-18: ConfigMaps and Secrets
- [ ] Create ConfigMaps from literals, files, and directories
- [ ] Consume ConfigMaps as environment variables
- [ ] Mount ConfigMaps as volumes
- [ ] Create Secrets (generic, docker-registry, tls)
- [ ] Consume Secrets as environment variables and volume mounts
- [ ] Understand base64 encoding for Secrets
- [ ] Lab: Create an app that reads database configuration from a ConfigMap and credentials from a Secret
- [ ] Lab: Update a ConfigMap and verify the mounted volume reflects the change
- [ ] Review Notes: `notes/04-environment-configuration-security.md`

### Day 19-20: SecurityContexts, ServiceAccounts, and RBAC
- [ ] Set `runAsUser`, `runAsGroup`, `runAsNonRoot` on Pods
- [ ] Configure `readOnlyRootFilesystem`
- [ ] Drop and add Linux capabilities
- [ ] Create and assign custom ServiceAccounts
- [ ] Disable automatic token mounting
- [ ] Create ResourceQuotas for a namespace
- [ ] Create LimitRanges with default values
- [ ] Lab: Create a Pod that runs as non-root with a read-only root filesystem
- [ ] Lab: Create a namespace with a ResourceQuota limiting to 2 CPU and 4Gi memory

### Day 21: Week 3 Review
- [ ] Create Pods with all three probe types from memory
- [ ] ConfigMap and Secret creation and consumption speed drill
- [ ] SecurityContext configurations without referencing docs
- [ ] Complete 3 security and observability practice scenarios

---

## Week 4: Services, Networking, and Integration

### Day 22-23: Services
- [ ] Create ClusterIP, NodePort, and LoadBalancer Services
- [ ] Use `kubectl expose` for quick Service creation
- [ ] Understand Service DNS naming (`<svc>.<ns>.svc.cluster.local`)
- [ ] Test service discovery from within Pods
- [ ] Troubleshoot Service connectivity issues
- [ ] Lab: Deploy two apps and have one communicate with the other via Service DNS
- [ ] Lab: Create a NodePort Service and access it from outside the cluster
- [ ] Review Notes: `notes/05-services-networking.md`

### Day 24-25: Ingress and Network Policies
- [ ] Install an Ingress controller (nginx)
- [ ] Create Ingress resources with host-based routing
- [ ] Create Ingress resources with path-based routing
- [ ] Configure TLS termination on Ingress
- [ ] Create NetworkPolicies to restrict Pod-to-Pod traffic
- [ ] Test NetworkPolicy behavior with ingress and egress rules
- [ ] Lab: Create an Ingress that routes `/api` to one service and `/` to another
- [ ] Lab: Create a NetworkPolicy that only allows frontend Pods to access backend Pods on port 8080
- [ ] Lab: Create a default-deny NetworkPolicy and selectively allow traffic

### Day 26-27: Integration Exercises
- [ ] Build a complete application stack: Deployment + ConfigMap + Secret + Service + Ingress
- [ ] Add probes, resource limits, and SecurityContexts to the stack
- [ ] Apply NetworkPolicies to restrict traffic between components
- [ ] Practice creating the entire stack under time constraints
- [ ] Lab: Deploy a 3-tier application (frontend, backend, database) with full configuration

### Day 28: Week 4 Review
- [ ] End-to-end application deployment from scratch (timed)
- [ ] NetworkPolicy creation from requirements
- [ ] Ingress routing configuration
- [ ] Complete all remaining practice scenarios

---

## Week 5: Exam Preparation and Mock Exams

### Day 29-30: Speed Drills
- [ ] Set up aliases and environment (`alias k=kubectl`, `export do="--dry-run=client -o yaml"`)
- [ ] Practice imperative commands for every resource type
- [ ] YAML generation and editing speed drills
- [ ] Context switching between clusters
- [ ] Review Notes: `notes/06-exam-tips.md`
- [ ] Review all common kubectl commands from `strategy.md`

### Day 31-32: Timed Mock Exam 1
- [ ] Complete killer.sh simulator (included with exam purchase)
- [ ] Take the full 2-hour mock exam
- [ ] Review every question you got wrong or took too long on
- [ ] Identify weak areas and create targeted practice exercises
- [ ] Re-do failed scenarios until you can complete them quickly

### Day 33-34: Targeted Review and Timed Mock Exam 2
- [ ] Focus practice on weak areas identified from Mock Exam 1
- [ ] Take a second timed mock exam
- [ ] Target completing 80%+ of tasks within the 2-hour limit
- [ ] Practice navigating kubernetes.io/docs to find YAML examples quickly
- [ ] Bookmark key documentation pages you use frequently

### Day 35: Final Review
- [ ] Light review of all domain notes
- [ ] Quick drill of imperative commands
- [ ] Review exam tips and common gotchas
- [ ] Verify exam scheduling and system requirements
- [ ] Rest and prepare mentally - do not cram

---

## Daily Practice Habits

Throughout the entire 5-week plan, incorporate these daily habits:

- [ ] Spend 15 minutes practicing imperative `kubectl` commands
- [ ] Create at least one resource from scratch using YAML (no copy-paste)
- [ ] Read one page from the official Kubernetes documentation
- [ ] Practice in a real cluster, not just reading

## Key Resources

| Resource | Purpose |
|----------|---------|
| [kubernetes.io/docs](https://kubernetes.io/docs/home/) | Primary reference during study and exam |
| [killer.sh](https://killer.sh/) | CKAD exam simulator (one session included with exam) |
| [Play with Kubernetes](https://labs.play-with-k8s.com/) | Free browser-based Kubernetes cluster |
| [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) | Quick reference for kubectl commands |
