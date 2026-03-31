# Domain 5: Services and Networking (20%)

## Overview

This domain covers how to expose applications running in Kubernetes, manage network traffic between Pods, and implement access control at the network level. You need to understand Service types, Ingress resources, Network Policies, and Kubernetes DNS.

## Services

**[📖 Service](https://kubernetes.io/docs/concepts/services-networking/service/)** - Service concepts and types
**[📖 Connecting Applications with Services](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)** - Practical Service tutorial
**[📖 Use a Service to Access an Application](https://kubernetes.io/docs/tasks/access-application-cluster/service-access-application-cluster/)** - Service access tutorial

### What is a Service?
A Service is a stable network abstraction that provides a consistent IP address and DNS name for a set of Pods. Pods are ephemeral and their IPs change - Services solve this problem by providing a permanent endpoint.

### Service Types

| Type | Description | Access Scope | Use Case |
|------|-------------|-------------|----------|
| **ClusterIP** | Internal cluster IP address (default) | Within the cluster | Internal communication between services |
| **NodePort** | Exposes on each node's IP at a static port | External via `<NodeIP>:<NodePort>` | Development, testing, direct access |
| **LoadBalancer** | Provisions an external load balancer | External via cloud LB IP | Production external access on cloud providers |
| **ExternalName** | Maps to a DNS CNAME record | DNS resolution | Referencing external services by DNS name |

### ClusterIP Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
spec:
  type: ClusterIP        # Default - can be omitted
  selector:
    app: backend
  ports:
    - name: http
      port: 80            # Service port (what clients connect to)
      targetPort: 8080     # Container port (where traffic is forwarded)
      protocol: TCP
```

```bash
# Imperative
kubectl expose deployment backend --port=80 --target-port=8080 --type=ClusterIP --name=backend-svc
```

### NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080      # Optional: auto-assigned from 30000-32767 if omitted
```

```bash
# Imperative
kubectl expose deployment frontend --port=80 --target-port=8080 --type=NodePort --name=frontend-svc
```

**NodePort range:** 30000-32767 by default. If you do not specify `nodePort`, Kubernetes assigns one automatically.

### LoadBalancer Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 8080
```

On cloud providers, this creates an external load balancer. On local clusters, it typically stays in `Pending` state unless a load balancer implementation is installed (e.g., MetalLB).

### ExternalName Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: db.example.com
```

No selector or ports needed. DNS lookups for `external-db` return a CNAME record pointing to `db.example.com`.

### Multi-Port Services

```yaml
apiVersion: v1
kind: Service
metadata:
  name: multi-port-svc
spec:
  selector:
    app: myapp
  ports:
    - name: http
      port: 80
      targetPort: 8080
    - name: https
      port: 443
      targetPort: 8443
    - name: metrics
      port: 9090
      targetPort: 9090
```

When a Service has multiple ports, each port must have a `name`.

### Headless Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: headless-svc
spec:
  clusterIP: None           # Makes it headless
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 8080
```

A headless Service (clusterIP: None) does not get a cluster IP. DNS returns the individual Pod IPs directly. Useful for StatefulSets and when you need direct Pod access.

### Verifying Services

```bash
# List services
kubectl get svc
kubectl get svc -n <namespace>

# Check endpoints (which Pods the Service routes to)
kubectl get endpoints <service-name>
kubectl get ep <service-name>

# Describe service
kubectl describe svc <service-name>

# Test from within the cluster
kubectl run test --image=busybox:1.36 --rm -it -- wget -qO- http://backend-svc:80
kubectl run test --image=busybox:1.36 --rm -it -- nslookup backend-svc
```

---

## Ingress

**[📖 Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress concepts
**[📖 Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available controllers
**[📖 Set up Ingress on Minikube](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)** - Practical Ingress tutorial

### What is Ingress?
Ingress manages external HTTP/HTTPS access to Services in the cluster. It provides:
- Host-based routing (route by domain name)
- Path-based routing (route by URL path)
- TLS/SSL termination
- Load balancing

**Important:** An Ingress resource does nothing without an Ingress controller installed in the cluster. Common controllers include nginx-ingress, Traefik, HAProxy, and cloud provider controllers.

### Creating Ingress Resources

**Imperative:**
```bash
# Simple Ingress
kubectl create ingress myingress \
  --class=nginx \
  --rule="myapp.example.com/=frontend-svc:80"

# With path-based routing
kubectl create ingress myingress \
  --class=nginx \
  --rule="myapp.example.com/api*=api-svc:8080" \
  --rule="myapp.example.com/*=frontend-svc:80"

# Generate YAML
kubectl create ingress myingress \
  --class=nginx \
  --rule="myapp.example.com/*=frontend-svc:80" \
  --dry-run=client -o yaml > ingress.yaml
```

### Host-Based Routing

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: host-routing
spec:
  ingressClassName: nginx
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 8080
```

### Path-Based Routing

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-routing
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
                  number: 8080
          - path: /admin
            pathType: Prefix
            backend:
              service:
                name: admin-service
                port:
                  number: 8080
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
```

### Path Types

| PathType | Behavior |
|----------|----------|
| `Prefix` | Matches based on URL path prefix split by `/` |
| `Exact` | Matches the exact URL path (case-sensitive) |
| `ImplementationSpecific` | Matching depends on the Ingress controller |

### TLS Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - myapp.example.com
      secretName: myapp-tls-secret      # Must be a kubernetes.io/tls Secret
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

**Create the TLS Secret:**
```bash
kubectl create secret tls myapp-tls-secret --cert=tls.crt --key=tls.key
```

### Default Backend

```yaml
spec:
  defaultBackend:
    service:
      name: default-service
      port:
        number: 80
```

The default backend handles requests that do not match any rule.

### Common Ingress Annotations (nginx)
```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
```

---

## Network Policies

**[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy concepts
**[📖 Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Creating NetworkPolicies

### How Network Policies Work
- By default, all Pods can communicate with all other Pods (no restrictions)
- A NetworkPolicy selects Pods using `podSelector` and defines allowed traffic
- Once a Pod is selected by ANY NetworkPolicy, all traffic not explicitly allowed is DENIED
- NetworkPolicies are additive - multiple policies selecting the same Pod combine their allow rules
- Requires a CNI plugin that supports NetworkPolicies (Calico, Cilium, Weave Net)

### NetworkPolicy Structure

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-policy
  namespace: default
spec:
  podSelector:              # Which Pods this policy applies to
    matchLabels:
      app: backend
  policyTypes:              # Which directions to enforce
    - Ingress
    - Egress
  ingress:                  # Allowed incoming traffic
    - from:
        - podSelector:      # Allow from specific Pods
            matchLabels:
              app: frontend
        - namespaceSelector: # Allow from specific namespaces
            matchLabels:
              env: production
      ports:
        - protocol: TCP
          port: 8080
  egress:                   # Allowed outgoing traffic
    - to:
        - podSelector:
            matchLabels:
              app: database
      ports:
        - protocol: TCP
          port: 5432
```

### Selector Types

**Pod Selector:**
```yaml
- podSelector:
    matchLabels:
      app: frontend
```
Selects Pods in the same namespace.

**Namespace Selector:**
```yaml
- namespaceSelector:
    matchLabels:
      env: production
```
Selects all Pods in namespaces matching the labels.

**Combined (AND logic - both must match):**
```yaml
- podSelector:
    matchLabels:
      app: frontend
  namespaceSelector:
    matchLabels:
      env: production
```
Selects Pods labeled `app: frontend` in namespaces labeled `env: production`.

**IP Block:**
```yaml
- ipBlock:
    cidr: 10.0.0.0/8
    except:
      - 10.0.1.0/24
```

### Important: AND vs OR Logic
```yaml
# OR logic: either podSelector OR namespaceSelector (separate list items)
ingress:
  - from:
      - podSelector:
          matchLabels:
            app: frontend
      - namespaceSelector:
          matchLabels:
            env: production

# AND logic: both must match (single list item with both selectors)
ingress:
  - from:
      - podSelector:
          matchLabels:
            app: frontend
        namespaceSelector:
          matchLabels:
            env: production
```

### Common NetworkPolicy Patterns

**Default Deny All Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}           # Selects ALL Pods in the namespace
  policyTypes:
    - Ingress
  # No ingress rules = deny all ingress
```

**Default Deny All Egress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
spec:
  podSelector: {}
  policyTypes:
    - Egress
```

**Default Deny All Traffic:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

**Allow All Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - {}                     # Empty rule = allow all
```

**Allow DNS Egress (commonly needed with deny-all egress):**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - to: []
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
```

---

## DNS for Services and Pods

**[📖 DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)** - Kubernetes DNS
**[📖 Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)** - DNS troubleshooting

### Service DNS Records

Every Service gets a DNS record in the form:
```
<service-name>.<namespace>.svc.cluster.local
```

**Resolution within the same namespace:**
```bash
# Just the service name works
curl http://backend-svc

# Or with namespace
curl http://backend-svc.default

# Or fully qualified
curl http://backend-svc.default.svc.cluster.local
```

**Resolution across namespaces:**
```bash
# Must include at least the namespace
curl http://backend-svc.other-namespace
curl http://backend-svc.other-namespace.svc.cluster.local
```

### Pod DNS Records
Pods get DNS records with their IP address dashed:
```
<pod-ip-dashed>.<namespace>.pod.cluster.local
```
Example: Pod with IP 10.244.1.5 in namespace `default`:
```
10-244-1-5.default.pod.cluster.local
```

### Headless Service DNS
For headless Services (`clusterIP: None`), DNS returns the individual Pod IPs instead of the cluster IP. Each Pod also gets a DNS record:
```
<pod-name>.<service-name>.<namespace>.svc.cluster.local
```

### Testing DNS Resolution

```bash
# Deploy a DNS testing Pod
kubectl run dnstest --image=busybox:1.36 --rm -it -- nslookup backend-svc

# More detailed test
kubectl run dnstest --image=busybox:1.36 --rm -it -- nslookup backend-svc.default.svc.cluster.local

# Test from a specific namespace
kubectl run dnstest -n my-namespace --image=busybox:1.36 --rm -it -- nslookup backend-svc.other-namespace

# Check DNS configuration inside a Pod
kubectl exec <pod-name> -- cat /etc/resolv.conf
```

### DNS Troubleshooting Checklist
1. Is the Service created? `kubectl get svc`
2. Does the Service have endpoints? `kubectl get endpoints <svc-name>`
3. Are the Pod labels matching the Service selector?
4. Is CoreDNS running? `kubectl get pods -n kube-system -l k8s-app=kube-dns`
5. Can you resolve from within a Pod? Run `nslookup` from a test Pod
6. Check `/etc/resolv.conf` inside the Pod for correct nameserver
