# Network Security for CKS

**[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy specification and behavior

## NetworkPolicy Fundamentals

### How NetworkPolicies Work
- NetworkPolicies are namespace-scoped resources
- They select pods using label selectors
- They define allowed ingress and/or egress rules
- If no NetworkPolicy selects a pod, all traffic is allowed (default allow)
- Once any NetworkPolicy selects a pod, only explicitly allowed traffic is permitted
- A CNI plugin that supports NetworkPolicy is required (Calico, Cilium, Weave Net)

**[📖 Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Tutorial for creating NetworkPolicies

### NetworkPolicy Specification

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: example-policy
  namespace: production
spec:
  podSelector:           # Which pods this policy applies to
    matchLabels:
      app: web
  policyTypes:           # Which traffic directions are controlled
  - Ingress
  - Egress
  ingress:               # Allowed inbound traffic
  - from:
    - podSelector:       # Pods in same namespace
        matchLabels:
          role: frontend
    - namespaceSelector: # Pods in specific namespaces
        matchLabels:
          env: production
    ports:
    - protocol: TCP
      port: 80
  egress:                # Allowed outbound traffic
  - to:
    - podSelector:
        matchLabels:
          role: database
    ports:
    - protocol: TCP
      port: 5432
```

### Selector Types

**podSelector** - Select pods by labels within the same namespace:
```yaml
from:
- podSelector:
    matchLabels:
      app: frontend
```

**namespaceSelector** - Select all pods in namespaces matching labels:
```yaml
from:
- namespaceSelector:
    matchLabels:
      env: production
```

**Combined (AND logic)** - Pods matching labels IN namespaces matching labels:
```yaml
from:
- namespaceSelector:
    matchLabels:
      env: production
  podSelector:
    matchLabels:
      app: frontend
```

**Separate entries (OR logic)** - Pods matching labels OR namespaces matching labels:
```yaml
from:
- namespaceSelector:
    matchLabels:
      env: production
- podSelector:
    matchLabels:
      app: frontend
```

**Important:** The difference between AND and OR is a single dash (`-`). AND has one dash before the first selector; OR has a dash before each selector. This is a common exam trap.

### ipBlock Selector
```yaml
from:
- ipBlock:
    cidr: 10.0.0.0/8
    except:
    - 10.0.1.0/24
```

## Common NetworkPolicy Patterns

### Default Deny All Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### Default Deny All Egress
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
```

### Default Deny All Traffic (Ingress + Egress)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### Allow DNS Egress (Critical for most policies)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
```

### Allow Intra-Namespace Communication
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector: {}
```

### Allow Monitoring Namespace Access
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-monitoring
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: monitoring
    ports:
    - port: 9090
      protocol: TCP
```

## Blocking Cloud Metadata Access

Cloud provider metadata endpoints (169.254.169.254) can expose sensitive information including IAM credentials. Block access with a NetworkPolicy:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-metadata
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
        - 169.254.169.254/32
```

## Ingress Security

**[📖 Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress resource documentation
**[📖 Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available Ingress controller implementations

### TLS Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  namespace: production
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - app.example.com
    secretName: tls-secret
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### Creating TLS Secrets
```bash
# Create TLS secret from certificate and key files
kubectl create secret tls tls-secret \
  --cert=tls.crt \
  --key=tls.key \
  -n production

# Generate self-signed certificate for testing
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=app.example.com"
```

## Network Segmentation Best Practices

### Multi-Tier Application Isolation
1. **Default deny** all traffic in the namespace
2. **Allow DNS** egress for name resolution
3. **Frontend pods** - Allow ingress from Ingress controller, egress to backend
4. **Backend pods** - Allow ingress from frontend, egress to database
5. **Database pods** - Allow ingress from backend only, deny all egress

### Namespace Isolation Strategy
1. Label namespaces consistently (environment, team, tier)
2. Use namespace selectors for cross-namespace policies
3. Create default-deny policies in every namespace
4. Allow only required cross-namespace communication
5. Block metadata endpoint access in all namespaces

## Testing NetworkPolicies

### Verification Commands
```bash
# List NetworkPolicies in a namespace
kubectl get networkpolicy -n production

# Describe policy details
kubectl describe networkpolicy default-deny-all -n production

# Test connectivity from a debug pod
kubectl run test-pod --image=busybox --rm -it --restart=Never -n production -- wget -qO- --timeout=2 http://web-service.production.svc:80

# Test cross-namespace connectivity
kubectl run test-pod --image=busybox --rm -it --restart=Never -n staging -- wget -qO- --timeout=2 http://web-service.production.svc:80

# Test DNS resolution
kubectl run test-pod --image=busybox --rm -it --restart=Never -n production -- nslookup kubernetes.default.svc
```

## Key Takeaways

1. **Default Deny** - Always start with default-deny policies in production namespaces
2. **DNS Egress** - Always allow DNS (port 53 UDP/TCP) when using egress policies
3. **AND vs OR** - Understand the YAML structure difference between combined selectors (AND) and separate selectors (OR)
4. **CNI Support** - NetworkPolicies require a CNI that supports them (Calico, Cilium)
5. **Metadata Blocking** - Block cloud metadata endpoint (169.254.169.254) access
6. **Testing** - Always verify policies work by testing connectivity from relevant pods
7. **policyTypes** - Only listed policy types are enforced; if you omit Egress from policyTypes, egress is not affected
