# 03 - Networking, Services, Routes, NetworkPolicy

## Cluster networking model

OpenShift 4 default SDN is **OVN-Kubernetes**. Older clusters may run **OpenShift SDN**.

Three networks:

- **Cluster network** (pods): default `10.128.0.0/14`
- **Service network** (cluster IPs): default `172.30.0.0/16`
- **Machine network** (nodes): cluster-specific

Each pod gets a unique IP. Pods can talk to all other pods (modulo NetworkPolicy).

---

## Services

A Service is a stable virtual IP (and DNS name) for a set of pods.

### Service types

| Type | Use case |
|---|---|
| **ClusterIP** | Default. Reachable inside cluster only. |
| **NodePort** | Exposed on every node's IP at a high port (30000-32767). |
| **LoadBalancer** | Cloud LB (in cloud-managed clusters). |
| **ExternalName** | DNS CNAME to external host. |
| **Headless** (`clusterIP: None`) | No virtual IP; DNS returns pod IPs directly. |

### Create

```bash
oc expose deploy/web --port=80                        # creates ClusterIP Service
oc expose deploy/web --port=80 --type=NodePort
oc expose deploy/web --port=80 --type=LoadBalancer
```

YAML:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector: { app: web }
  ports:
  - port: 80
    targetPort: 8080                # container port
    name: http
```

### DNS for services

In-cluster DNS: `<service>.<namespace>.svc.cluster.local`. Short forms work within the same namespace.

---

## Routes (OpenShift's external ingress)

Routes are OpenShift-specific; they sit on top of Services and expose them via the cluster's HAProxy ingress router.

### Create routes

```bash
# Plain HTTP
oc expose svc/web --hostname=app.example.com

# TLS edge (router terminates TLS, plaintext to backend pod)
oc create route edge --service=web --hostname=app.example.com

# TLS passthrough (router passes through to backend; backend must serve TLS)
oc create route passthrough --service=web --hostname=app.example.com

# TLS reencrypt (router terminates TLS, re-encrypts to backend)
oc create route reencrypt --service=web --hostname=app.example.com \
    --dest-ca-cert=ca.pem
```

### Route YAML

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: web
spec:
  host: app.example.com
  to: { kind: Service, name: web }
  port: { targetPort: http }
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect    # Redirect | Allow | None
```

### TLS certificates

For edge / reencrypt routes, you can supply cert and key:

```bash
oc create route edge --service=web \
    --hostname=app.example.com \
    --cert=fullchain.pem \
    --key=privkey.pem \
    --ca-cert=ca.pem
```

If omitted, the cluster wildcard cert is used.

### Path-based routing

```yaml
spec:
  host: app.example.com
  path: /api
  to: { kind: Service, name: api }
```

Multiple Routes with the same host but different paths route to different services.

### Route weighting (canary / blue-green)

```yaml
spec:
  to:
    kind: Service
    name: web-v1
    weight: 90
  alternateBackends:
  - kind: Service
    name: web-v2
    weight: 10
```

10% of traffic goes to v2. Adjust weights to roll forward.

---

## Ingress (Kubernetes-native)

OpenShift supports Ingress resources, which the Ingress Operator translates into Routes under the hood. Use Routes when in doubt - they're more idiomatic for OpenShift.

---

## NetworkPolicy

NetworkPolicy controls pod-to-pod traffic. Default: all pods can talk to all pods. Once a NetworkPolicy selects a pod, only explicitly-allowed traffic is permitted.

### Default deny

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: myapp
spec:
  podSelector: {}                   # all pods in namespace
  policyTypes: [Ingress, Egress]
  # No ingress / egress rules = deny all
```

### Allow from a specific pod

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend
  namespace: myapp
spec:
  podSelector:
    matchLabels: { app: backend }
  policyTypes: [Ingress]
  ingress:
  - from:
    - podSelector:
        matchLabels: { app: frontend }
    ports:
    - protocol: TCP
      port: 8080
```

### Allow from another namespace

```yaml
spec:
  podSelector: { matchLabels: { app: api } }
  policyTypes: [Ingress]
  ingress:
  - from:
    - namespaceSelector:
        matchLabels: { team: frontend }
    ports:
    - port: 80
```

### Allow from outside cluster (router)

In OpenShift, ingress traffic from Routes comes through `network.openshift.io/policy-group=ingress` namespace label. To allow:

```yaml
spec:
  podSelector: { matchLabels: { app: web } }
  policyTypes: [Ingress]
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          policy-group.network.openshift.io/ingress: ''
```

---

## Common networking exam tasks

### Expose a deployment to the cluster

```bash
oc expose deploy/web --port=80                # creates ClusterIP Service
```

### Expose a service to public DNS

```bash
oc expose svc/web --hostname=app.example.com    # plain HTTP route
oc create route edge --service=web --hostname=app.example.com   # HTTPS edge
```

### Force HTTPS on a route

Add `insecureEdgeTerminationPolicy: Redirect` to an edge route, OR:

```bash
oc patch route web -p '{"spec":{"tls":{"insecureEdgeTerminationPolicy":"Redirect"}}}'
```

### Restrict app to only receive traffic from frontend

Apply the `allow-frontend` NetworkPolicy above.

### Block all traffic to namespace except from one team

```yaml
# 1. Default deny
spec:
  podSelector: {}
  policyTypes: [Ingress]

# 2. Allow team
spec:
  podSelector: {}
  policyTypes: [Ingress]
  ingress:
  - from:
    - namespaceSelector:
        matchLabels: { team: trusted }
```

### Path-based routing on same host

Create two Routes with the same `host` but different `path` and different `to` services.

### Canary 10% to v2

Use the route weighting YAML above.

---

## Verification

After networking changes:

- `oc get svc` shows expected services
- `oc get routes` shows expected routes with status `Admitted`
- `curl https://<route-host>/` returns expected content
- `oc -n <ns> get networkpolicy` shows expected policies
- `oc exec <client-pod> -- curl <target-svc>` for in-cluster tests
- For NetworkPolicy: test BOTH allowed AND denied paths to confirm policy works as intended
