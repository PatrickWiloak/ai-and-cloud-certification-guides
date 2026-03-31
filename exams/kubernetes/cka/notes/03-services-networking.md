# Services & Networking

## Overview

This domain represents 20% of the CKA exam. It covers Kubernetes networking fundamentals, Service types, Ingress, Network Policies, DNS, and CNI plugins.

**[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)** - Kubernetes networking model

## Kubernetes Networking Model

Kubernetes imposes three fundamental networking requirements:
1. Every Pod gets its own IP address
2. Pods on any node can communicate with all Pods on any other node without NAT
3. Agents on a node (kubelet, system daemons) can communicate with all Pods on that node

This flat network model is implemented by CNI plugins.

## Service Types

Services provide stable networking endpoints for a dynamic set of Pods. Pods are selected by label selectors.

### ClusterIP (Default)

Creates an internal-only virtual IP address accessible within the cluster.

```bash
# Create a ClusterIP service
kubectl expose deployment nginx --port=80 --target-port=80 --type=ClusterIP

# Or imperatively
kubectl create service clusterip nginx-svc --tcp=80:80
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
  - port: 80          # Port the service listens on
    targetPort: 80     # Port on the pod containers
    protocol: TCP
```

**Use Cases:**
- Internal microservice communication
- Database access within the cluster
- Backend services not exposed externally

**Headless Service (ClusterIP: None):**
- No virtual IP allocated
- DNS returns individual Pod IPs
- Used with StatefulSets for direct pod addressing

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
  - port: 3306
```

**[Services](https://kubernetes.io/docs/concepts/services-networking/service/)** - Service documentation

### NodePort

Exposes the service on a static port on each node's IP address.

```bash
kubectl expose deployment nginx --port=80 --type=NodePort
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80           # ClusterIP port
    targetPort: 80      # Pod port
    nodePort: 30080     # Node port (30000-32767, auto-assigned if omitted)
    protocol: TCP
```

**Key Facts:**
- Port range: 30000-32767 (configurable via API server flag)
- Automatically creates a ClusterIP
- Accessible via `<any-node-ip>:<nodePort>`
- Not recommended for production external access (use LoadBalancer or Ingress)

### LoadBalancer

Exposes the service externally using a cloud provider's load balancer.

```bash
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
```

**Key Facts:**
- Automatically creates ClusterIP and NodePort
- Provisions an external load balancer (cloud provider dependent)
- External IP shown in `kubectl get svc` (may take time to provision)
- Each LoadBalancer service gets its own external IP and load balancer

### ExternalName

Maps a service to an external DNS name. No proxying occurs.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: database.example.com
```

**Key Facts:**
- Returns a CNAME record for the specified external name
- No selector, no endpoints, no proxying
- Use case: accessing external services through Kubernetes DNS

**[Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)** - Type reference

### Service Discovery

Kubernetes provides two ways to discover services:

1. **DNS (recommended)** - CoreDNS resolves service names
   - `<service>.<namespace>.svc.cluster.local`
   - Same namespace: just use `<service-name>`

2. **Environment Variables** - injected into pods at creation
   - `<SERVICE_NAME>_SERVICE_HOST`
   - `<SERVICE_NAME>_SERVICE_PORT`
   - Only available if the service was created before the pod

### Endpoints

Endpoints track the IP addresses of pods that match a Service's selector.

```bash
# View endpoints for a service
kubectl get endpoints nginx-svc

# Verify pods are matched
kubectl describe endpoints nginx-svc
```

**Common Issue:** If a service has no endpoints, check that:
- The selector labels match the pod labels
- The pods are running and ready
- The target port matches the container port

**[Connecting Applications with Services](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)** - Service connectivity tutorial

## Ingress

Ingress manages external access to services, typically HTTP/HTTPS. It provides load balancing, SSL termination, and name-based virtual hosting.

### Ingress Controller

An Ingress resource requires an Ingress controller to function. The controller is not installed by default.

**Common Controllers:**
- NGINX Ingress Controller (most widely used)
- Traefik
- HAProxy
- Contour
- AWS ALB Ingress Controller

**[Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available controllers

### Ingress Resources

```yaml
# Simple fanout - route by path
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-ingress
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
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

```yaml
# Name-based virtual hosting
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: virtual-host-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: app1.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
  - host: app2.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

```yaml
# Ingress with TLS
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myapp.example.com
    secretName: tls-secret
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp-service
            port:
              number: 80
```

**Path Types:**
- `Exact` - matches the URL path exactly
- `Prefix` - matches based on a URL path prefix split by `/`
- `ImplementationSpecific` - matching depends on the IngressClass

**[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress documentation

## Network Policies

Network Policies control traffic flow at the IP address or port level for pods. They act like firewall rules for pod-to-pod communication.

### Key Concepts

- Implemented by the CNI plugin (not all plugins support them)
- Supported by: Calico, Cilium, Weave Net, Antrea
- NOT supported by: Flannel (alone)
- Default behavior: all pods can communicate with all other pods
- Once a Network Policy selects a pod, all traffic not explicitly allowed is denied
- Policies are additive - you cannot create a policy that denies traffic (you deny by not allowing)

### Default Deny All Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
  namespace: production
spec:
  podSelector: {}      # Selects ALL pods in the namespace
  policyTypes:
  - Ingress            # Block all incoming traffic
```

### Default Deny All Egress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-egress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
```

### Allow Specific Traffic

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### Combined Ingress and Egress Policy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      role: database
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: backend
    - namespaceSelector:
        matchLabels:
          name: monitoring
    ports:
    - protocol: TCP
      port: 5432
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/8
    ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
```

### Selector Types in Network Policies

```yaml
ingress:
- from:
  # Pod selector - pods in the same namespace
  - podSelector:
      matchLabels:
        role: frontend

  # Namespace selector - all pods in matching namespaces
  - namespaceSelector:
      matchLabels:
        project: myproject

  # IP block - CIDR range
  - ipBlock:
      cidr: 172.17.0.0/16
      except:
      - 172.17.1.0/24

  # Combined (AND logic) - pods in specific namespaces
  - namespaceSelector:
      matchLabels:
        project: myproject
    podSelector:
      matchLabels:
        role: frontend
```

**Important:** When selectors are separate list items (separate `-` entries), they use OR logic. When combined under a single list item, they use AND logic.

**[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - Network Policy documentation
**[Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Walkthrough

## DNS in Kubernetes (CoreDNS)

### Service DNS

Every Service gets a DNS record:
- **A/AAAA record:** `<service>.<namespace>.svc.cluster.local`
- **SRV record:** `_<port>._<protocol>.<service>.<namespace>.svc.cluster.local`

**Examples:**
- `nginx-svc.default.svc.cluster.local` - full FQDN
- `nginx-svc.default` - works from any namespace
- `nginx-svc` - works from the same namespace

### Pod DNS

Pods get DNS records based on their IP address:
- `10-244-1-5.default.pod.cluster.local` (IP with dashes)

### Headless Service DNS

For headless services (ClusterIP: None), DNS returns the individual pod IPs:
- `<pod-name>.<service-name>.<namespace>.svc.cluster.local`

### CoreDNS Configuration

CoreDNS runs as a Deployment in kube-system namespace. Its configuration is stored in a ConfigMap.

```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# View CoreDNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# Test DNS resolution from a pod
kubectl run dnstest --image=busybox:1.28 --rm -it --restart=Never \
  -- nslookup nginx-svc.default.svc.cluster.local
```

**[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)** - DNS documentation
**[Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)** - DNS troubleshooting

## CNI Plugins

Container Network Interface (CNI) plugins implement the Kubernetes networking model.

### Common CNI Plugins

| Plugin | Features | Network Policy Support |
|--------|----------|----------------------|
| Calico | BGP routing, IP-in-IP, VXLAN | Yes |
| Flannel | Simple VXLAN overlay | No (alone) |
| Cilium | eBPF-based, L7 policies | Yes (advanced) |
| Weave Net | Mesh network, encryption | Yes |
| Canal | Flannel networking + Calico policies | Yes |

### Installing a CNI Plugin

CNI plugins are installed after `kubeadm init` and before joining worker nodes.

```bash
# Calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Weave Net
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

**[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)** - Networking concepts
**[Install a Network Policy Provider](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/)** - CNI installation

## Key Exam Tips for This Domain

1. **Know all four Service types** and when to use each one
2. **Practice creating Ingress resources** with both path-based and host-based routing
3. **Network Policy AND/OR logic** is a common trap - separate list items = OR, same item = AND
4. **Default deny policies** are the starting point for Network Policy questions
5. **DNS names** follow the pattern `<svc>.<ns>.svc.cluster.local`
6. **Test connectivity** with `kubectl run test --image=busybox --rm -it -- wget -O- <svc>:<port>`
7. **Check endpoints** when services are not routing traffic - `kubectl get endpoints <svc>`
8. **Remember that Flannel alone does not support Network Policies** - you need Calico or Cilium
