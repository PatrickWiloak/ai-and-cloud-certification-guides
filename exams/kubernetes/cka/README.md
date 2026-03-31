# Certified Kubernetes Administrator (CKA)

## Exam Overview

The Certified Kubernetes Administrator (CKA) exam validates the skills, knowledge, and competency to perform the responsibilities of a Kubernetes administrator. This is a performance-based exam where you work directly in a live terminal environment - there are no multiple choice questions. You must demonstrate your ability to solve real-world Kubernetes administration tasks under time pressure.

**Exam Details:**
- **Exam Code:** CKA
- **Duration:** 2 hours
- **Format:** Performance-based, hands-on terminal (live Kubernetes clusters)
- **Passing Score:** 66%
- **Cost:** $395 USD (includes one free retake)
- **Delivery:** PSI online proctoring
- **Validity:** 3 years
- **Prerequisites:** None (hands-on Kubernetes experience strongly recommended)
- **Kubernetes Version:** Exam environment tracks the latest stable release (typically within 1-2 minor versions)

## Exam Domains

### Domain 1: Cluster Architecture, Installation & Configuration (25%)
- Manage role-based access control (RBAC)
- Use kubeadm to install a basic cluster
- Manage a highly available Kubernetes cluster
- Provision underlying infrastructure to deploy a Kubernetes cluster
- Perform a version upgrade on a Kubernetes cluster using kubeadm
- Implement etcd backup and restore

**Key Skills:**
- Installing Kubernetes clusters with kubeadm
- Upgrading cluster components (control plane and worker nodes)
- Backing up and restoring etcd data
- Configuring RBAC roles, cluster roles, and bindings
- Managing kubeconfig files for multiple clusters
- Understanding cluster networking requirements

### Domain 2: Workloads & Scheduling (15%)
- Understand deployments and how to perform rolling update and rollbacks
- Use ConfigMaps and Secrets to configure applications
- Know how to scale applications
- Understand the primitives used to create robust, self-healing, application deployments
- Understand how resource limits can affect Pod scheduling
- Awareness of manifest management and common templating tools

**Key Skills:**
- Creating and managing Deployments, ReplicaSets, and StatefulSets
- Performing rolling updates and rollbacks
- Configuring resource requests and limits
- Using ConfigMaps and Secrets for application configuration
- Scheduling pods with node selectors, affinity, taints, and tolerations
- Working with DaemonSets and Jobs/CronJobs

### Domain 3: Services & Networking (20%)
- Understand host networking configuration on the cluster nodes
- Understand connectivity between Pods
- Understand ClusterIP, NodePort, LoadBalancer service types and endpoints
- Know how to use Ingress controllers and Ingress resources
- Know how to configure and use CoreDNS
- Choose an appropriate container network interface plugin

**Key Skills:**
- Creating and managing Service resources (ClusterIP, NodePort, LoadBalancer)
- Configuring Ingress resources and controllers
- Implementing Network Policies for pod isolation
- Understanding DNS resolution within a cluster (CoreDNS)
- Troubleshooting pod-to-pod and pod-to-service connectivity
- Understanding CNI plugin basics

### Domain 4: Storage (10%)
- Understand storage classes, persistent volumes
- Understand volume mode, access modes and reclaim policies for volumes
- Understand persistent volume claims primitive
- Know how to configure applications with persistent storage

**Key Skills:**
- Creating Persistent Volumes (PV) and Persistent Volume Claims (PVC)
- Configuring Storage Classes for dynamic provisioning
- Understanding access modes (ReadWriteOnce, ReadOnlyMany, ReadWriteMany)
- Mounting volumes in pods (emptyDir, hostPath, configMap, secret, PVC)
- Understanding reclaim policies (Retain, Delete, Recycle)

### Domain 5: Troubleshooting (30%)
- Evaluate cluster and node logging
- Understand how to monitor applications
- Manage container stdout & stderr logs
- Troubleshoot application failure
- Troubleshoot cluster component failure
- Troubleshoot networking

**Key Skills:**
- Reading and interpreting pod logs with `kubectl logs`
- Using `kubectl describe` to inspect resource events and status
- Troubleshooting pods stuck in Pending, CrashLoopBackOff, or ImagePullBackOff
- Diagnosing node issues (NotReady, disk pressure, memory pressure)
- Troubleshooting control plane components (API server, scheduler, controller manager)
- Debugging service and network connectivity issues

## Core Kubernetes Concepts

### Pods
The smallest deployable unit in Kubernetes. A pod encapsulates one or more containers that share storage, network, and a specification for how to run. Understanding pod lifecycle, multi-container patterns (sidecar, init containers), and pod troubleshooting is essential for the CKA.

### Deployments
The primary mechanism for managing stateless applications. Deployments manage ReplicaSets, which in turn manage Pods. Key operations include scaling, rolling updates, rollbacks, and pausing/resuming deployments.

### Services
Services provide stable networking endpoints for a set of pods. The four types - ClusterIP (internal), NodePort (external via node ports), LoadBalancer (cloud provider LB), and ExternalName (DNS alias) - each serve different use cases.

### ConfigMaps and Secrets
ConfigMaps store non-confidential configuration data as key-value pairs. Secrets store sensitive data (passwords, tokens, keys) with base64 encoding. Both can be consumed as environment variables or mounted as volumes.

### Persistent Volumes and Persistent Volume Claims
PVs represent storage resources in the cluster. PVCs are requests for storage by users. The PV/PVC model decouples storage provisioning from consumption, allowing administrators to manage storage independently from application developers.

### RBAC (Role-Based Access Control)
RBAC controls access to the Kubernetes API. The four key resources are Roles (namespace-scoped permissions), ClusterRoles (cluster-wide permissions), RoleBindings (bind roles to users in a namespace), and ClusterRoleBindings (bind cluster roles to users cluster-wide).

### Network Policies
Network Policies control traffic flow between pods at the IP address or port level. They are implemented by the CNI plugin (not all CNI plugins support them). By default, all pods can communicate with each other - Network Policies restrict this.

### etcd
The distributed key-value store that serves as the backing store for all Kubernetes cluster data. Understanding how to backup and restore etcd is critical for the CKA exam, as data loss in etcd means loss of all cluster state.

### kubeadm
The official tool for bootstrapping Kubernetes clusters. kubeadm handles cluster initialization, joining nodes, and performing version upgrades. It follows Kubernetes best practices and is the standard tool tested on the CKA exam.

## Study Approach - This is a HANDS-ON Exam

**CRITICAL:** The CKA is NOT a multiple-choice exam. You will be given a live terminal connected to real Kubernetes clusters and asked to complete tasks. You must be able to:

1. **Type kubectl commands from memory** - there is no auto-complete for resource names
2. **Navigate the Kubernetes documentation quickly** - you are allowed to access kubernetes.io/docs during the exam
3. **Work efficiently in a Linux terminal** - vim/nano, bash, and basic Linux commands
4. **Solve problems under time pressure** - approximately 17 tasks in 2 hours (~7 minutes per task)
5. **Switch between multiple cluster contexts** - the exam uses several clusters

### Practice Environment Recommendations
- **Minikube or kind** for local development clusters
- **kubeadm** on VMs (VirtualBox, Vagrant, or cloud VMs) for realistic cluster setup
- **killer.sh** - CKA exam simulator (included with exam purchase)
- **Kubernetes the Hard Way** by Kelsey Hightower - deep understanding of components

### Essential kubectl Skills
```bash
# Imperative commands save time on the exam
kubectl run nginx --image=nginx --port=80
kubectl create deployment nginx --image=nginx --replicas=3
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl create configmap myconfig --from-literal=key1=value1
kubectl create secret generic mysecret --from-literal=password=pass123
kubectl create serviceaccount mysa
kubectl create role myrole --verb=get,list --resource=pods
kubectl create rolebinding myrolebinding --role=myrole --serviceaccount=default:mysa

# Generate YAML for editing
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deploy.yaml

# Quick troubleshooting
kubectl get pods -A
kubectl describe pod <pod-name>
kubectl logs <pod-name> -c <container-name>
kubectl exec -it <pod-name> -- /bin/sh
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Kubestronaut Certification Path

The CKA is part of the CNCF Kubestronaut program. Earning all five Kubernetes certifications grants the Kubestronaut title:

1. **KCNA** - Kubernetes and Cloud Native Associate (entry-level, multiple choice)
2. **KCSA** - Kubernetes and Cloud Native Security Associate (security fundamentals)
3. **CKA** - Certified Kubernetes Administrator (cluster administration - this exam)
4. **CKAD** - Certified Kubernetes Application Developer (application development)
5. **CKS** - Certified Kubernetes Security Specialist (advanced security, requires CKA)

### Recommended Order
- Start with KCNA if you are new to Kubernetes
- CKA before CKAD - administration knowledge helps with development tasks
- CKS last - it requires a valid CKA certification and builds on CKA knowledge

## Study Resources

### Official Resources
- **[CKA Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)** - Registration and official details
- **[CKA Exam Curriculum](https://github.com/cncf/curriculum)** - Detailed exam objectives
- **[Kubernetes Documentation](https://kubernetes.io/docs/)** - Allowed during the exam
- **[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)** - Bookmark this
- **[Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)** - Deep understanding

### Recommended Courses
1. **Mumshad Mannambeth - CKA with Practice Tests** (Udemy/KodeKloud) - HIGHLY RECOMMENDED, includes hands-on labs
2. **Killer Shell CKA Simulator** - Included with exam purchase, closest to real exam
3. **Linux Foundation - Kubernetes Fundamentals (LFS258)** - Official training course
4. **KodeKloud CKA Learning Path** - Interactive labs and practice

### Practice Environments
- **[killer.sh](https://killer.sh/)** - Exam simulator (2 sessions included with exam purchase)
- **[KodeKloud](https://kodekloud.com/)** - Browser-based Kubernetes labs
- **[Play with Kubernetes](https://labs.play-with-k8s.com/)** - Free browser-based clusters
- **Minikube / kind / k3s** - Local cluster options for daily practice

### Community Resources
- **r/kubernetes** - Reddit community for Kubernetes discussions
- **Kubernetes Slack** - Official community Slack workspace
- **CNCF YouTube Channel** - Conference talks and tutorials

## Next Steps After CKA

### Career Benefits
- Validates practical Kubernetes administration skills
- Recognized across cloud providers (AWS EKS, GCP GKE, Azure AKS)
- Opens doors to DevOps engineer, platform engineer, and SRE roles
- Foundation for advanced Kubernetes certifications

### Continue the Kubestronaut Path
- **[CKAD](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)** - Application developer certification
- **[CKS](https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/)** - Security specialist certification (requires valid CKA)

---

**Good luck with your CKA certification!**

Remember: This is a hands-on exam. Reading documentation is not enough - you must practice in real clusters until kubectl commands become second nature. Build clusters, break things, fix them. The exam rewards speed and accuracy with real Kubernetes operations. Use `kubectl --help` and the official docs during the exam - knowing where to find information quickly is just as important as memorizing commands.
