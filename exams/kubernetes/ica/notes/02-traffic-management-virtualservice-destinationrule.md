# 02. Traffic Management: VirtualService and DestinationRule

## The Traffic Management CRDs

Istio's traffic management is built from a small set of CRDs:

- **VirtualService**: defines routing rules (where requests for a host go)
- **DestinationRule**: defines policies for traffic to a destination (subsets, load balancing, TLS, connection pool, outlier detection)
- **Gateway**: configures an ingress or egress proxy (ports, hosts, TLS)
- **ServiceEntry**: registers external services in the mesh
- **Sidecar**: scopes a workload's view of the mesh (limit egress hosts, narrow ports)
- **WorkloadEntry**: registers non-Kubernetes workloads (VMs)

Master VirtualService and DestinationRule first; everything else builds on them.

## VirtualService

A VirtualService binds a set of host names to a set of routing rules.

Skeleton:
```yaml
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: reviews
  namespace: bookinfo
spec:
  hosts:
    - reviews
  http:
    - match:
        - headers:
            end-user:
              exact: jason
      route:
        - destination:
            host: reviews
            subset: v2
    - route:
        - destination:
            host: reviews
            subset: v1
```

Key behaviors:

- Multiple `match` blocks per route; first match wins
- Without `match`, the route is the default
- `weight` distributes across multiple destinations
- Bound to Gateways via `gateways:` (default is mesh-internal)

Match conditions: `uri` (prefix, exact, regex), `headers`, `method`, `queryParams`, `port`, `sourceLabels`.

Route attributes:
- `destination`: where to send (host + optional subset)
- `weight`: percent split
- `timeout`: per-route
- `retries`: attempts and conditions
- `fault`: delay or abort injection
- `mirror`: copy traffic to another destination
- `corsPolicy`, `headers` (rewrite/add/remove)
- `redirect`, `rewrite`

## DestinationRule

A DestinationRule defines client-side policies for traffic to a service.

Skeleton:
```yaml
apiVersion: networking.istio.io/v1
kind: DestinationRule
metadata:
  name: reviews
  namespace: bookinfo
spec:
  host: reviews
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http2MaxRequests: 1000
        maxRequestsPerConnection: 10
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
  subsets:
    - name: v1
      labels: { version: v1 }
    - name: v2
      labels: { version: v2 }
```

Key features:

- **Subsets**: named groups of endpoints by label, used by VirtualService
- **Load balancer**: ROUND_ROBIN, LEAST_REQUEST, RANDOM, PASSTHROUGH, consistent hash
- **Connection pool**: limits to prevent overload
- **Outlier detection**: client-side circuit breaking based on consecutive errors
- **TLS**: client TLS settings per destination (DISABLE, SIMPLE, MUTUAL, ISTIO_MUTUAL)

## The Subset Trap

Subsets must exist in the DestinationRule before VirtualService references them. Otherwise routes return 503 with NR (No Route).

Always apply DR first, then VS.

## Gateway

A Gateway configures an ingress (or egress) Envoy proxy.

Skeleton:
```yaml
apiVersion: networking.istio.io/v1
kind: Gateway
metadata:
  name: ext-gw
  namespace: bookinfo
spec:
  selector:
    istio: ingressgateway
  servers:
    - port: { number: 80, name: http, protocol: HTTP }
      hosts: ["app.example.com"]
    - port: { number: 443, name: https, protocol: HTTPS }
      hosts: ["app.example.com"]
      tls:
        mode: SIMPLE
        credentialName: app-tls-cert
```

The Gateway alone does nothing; bind a VirtualService to it:

```yaml
spec:
  hosts: ["app.example.com"]
  gateways: [ext-gw]
  http:
    - route: [...]
```

## ServiceEntry

Registers an external service in Istio's service registry.

```yaml
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: httpbin-ext
spec:
  hosts: [httpbin.org]
  ports:
    - number: 443
      name: https
      protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
```

Use cases:
- Govern egress with VirtualService and AuthorizationPolicy on external hosts
- Add monitoring on external dependencies
- Required when `outboundTrafficPolicy.mode = REGISTRY_ONLY`

## Sidecar (CRD)

The Sidecar CRD limits which services a workload can reach. Useful for performance (smaller config) and security.

```yaml
apiVersion: networking.istio.io/v1
kind: Sidecar
metadata: { name: default, namespace: bookinfo }
spec:
  egress:
    - hosts:
        - "./*"                   # same namespace
        - "istio-system/*"        # plus istio-system
```

## Common Patterns

### Canary
DestinationRule with subsets v1, v2; VirtualService with weighted routes (90/10, 50/50, 0/100).

### Header-based testing
First match block matches a header; second is the default.

### Mirroring
```yaml
http:
  - route: [{ destination: { host: reviews, subset: v1 } }]
    mirror: { host: reviews, subset: v2 }
    mirrorPercentage: { value: 10 }
```

### URL rewriting
```yaml
http:
  - match: [{ uri: { prefix: "/api" } }]
    rewrite: { uri: "/" }
    route: [{ destination: { host: api } }]
```

### Cross-namespace destinations
Use FQDN: `host: reviews.bookinfo.svc.cluster.local`

## Common Exam Traps

- VS without DR (subset references fail)
- Gateway without binding VS (no traffic flows)
- Mismatched hosts between Gateway and VirtualService
- Forgetting `gateways:` in VS for ingress (defaults to mesh)
- Wrong namespace for `istio-system` gateway selector (it is mesh-wide)
- Using Service name across namespaces without FQDN
