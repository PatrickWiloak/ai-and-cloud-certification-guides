# 06. Multi-Cluster and Ambient Mesh

## Why Multi-Cluster

Multi-cluster meshes solve real problems:

- High availability across regions
- Geographic latency reduction
- Tenant or environment isolation
- Migration between clusters
- Compliance boundaries

Istio supports several multi-cluster topologies. The ICA exam expects conceptual fluency, not heavy hands-on.

## Multi-Cluster Topologies

### Single network vs multi-network

- **Single network**: pods in different clusters can reach each other directly (flat network)
- **Multi-network**: clusters are isolated; communication via gateways

### Single control plane vs multi-control-plane

- **Primary-Remote**: one cluster runs istiod; others (remote) connect to it
- **Multi-Primary**: each cluster runs istiod; they share root CA and trust each other
- **External Control Plane**: istiod runs outside any data cluster (often on a management cluster)

### Common patterns

| Pattern | Networks | Control planes | Use case |
|---------|----------|----------------|----------|
| Primary-Remote, single net | 1 | 1 | Simple HA in one network |
| Multi-Primary, multi-net | many | many | Cross-region production |
| External control plane | varies | 1 (external) | Multi-tenant managed |

## Cross-Cluster Service Discovery

For services to be reachable across clusters:

1. Both control planes (or the single one) must know about Service objects in all clusters
2. Each cluster needs a way to reach the other (east-west gateway in multi-network)
3. Workloads use the standard service DNS (`reviews.bookinfo.svc.cluster.local`); the mesh resolves to local or remote endpoints

### East-west gateway

In multi-network, a special "east-west" gateway exposes mesh services to other clusters via SNI-based routing on port 15443.

## Trust Configuration

For multi-primary, all clusters must share a root CA. Pattern:

1. Generate a shared root CA offline
2. Create per-cluster intermediate CAs
3. Bootstrap each cluster's istiod with its intermediate as `cacerts` Secret
4. Workloads in different clusters get certs from different intermediates that chain to the same root, enabling mTLS across clusters

## Locality Load Balancing

DestinationRule supports locality-aware routing:

```yaml
spec:
  host: reviews
  trafficPolicy:
    loadBalancer:
      localityLbSetting:
        enabled: true
        distribute:
          - from: us-east-1/*
            to:
              "us-east-1/*": 80
              "us-west-1/*": 20
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
```

This enables priority-based routing (prefer local zone, fall over to other zones) and explicit weighted distribution.

## Failover

Locality failover is automatic when outlier detection ejects local endpoints. Endpoints in next-priority localities take over until local hosts return.

## Ambient Mesh Architecture

Ambient mesh removes per-pod sidecars. Two layers:

### ztunnel (L4)
- DaemonSet: one per node
- Handles mTLS termination and origination using HBONE (HTTP-CONNECT-based overlay)
- Provides workload identity (SPIFFE)
- Enforces L4 AuthorizationPolicies
- Cannot do L7 features (HTTP routing, JWT auth, complex AuthZ)

### Waypoint (L7)
- Deployed per service account or namespace
- Standard Envoy proxy as a Kubernetes Deployment
- Handles VirtualService routing, AuthorizationPolicy with HTTP attributes, JWT validation
- Optional; only needed when L7 features are required

### How traffic flows in ambient

1. Pod sends request to a service
2. Local ztunnel intercepts; if destination is in mesh, opens HBONE tunnel to destination's node ztunnel
3. If a waypoint is configured for the destination, ztunnel forwards via waypoint (which applies L7 policies)
4. Destination's ztunnel receives; delivers to pod

### Joining a namespace to ambient

```bash
kubectl label namespace bookinfo istio.io/dataplane-mode=ambient
```

No pod restart needed (no sidecar to inject).

### Adding a waypoint

```bash
istioctl x waypoint apply -n bookinfo --enroll-namespace
```

Or per service account:
```bash
istioctl x waypoint apply -n bookinfo --service-account reviews
```

## Sidecar vs Ambient Trade-offs

| Aspect | Sidecar | Ambient |
|--------|---------|---------|
| Per-pod overhead | High (sidecar memory/CPU) | None for pod |
| Upgrade impact | Pod restart required | DaemonSet rolling upgrade only |
| L7 features | Always available | Require waypoint deployment |
| Maturity | GA for years | GA more recently |
| Tooling support | Excellent (Kiali, others) | Improving |
| Multi-cluster | Well-trodden | Emerging |

Recommendation: new clusters can consider ambient. Existing sidecar deployments do not need to migrate immediately; both are supported.

## Migration: Sidecar to Ambient

Per namespace:

1. Remove the `istio-injection=enabled` label
2. Restart deployments (sidecars removed)
3. Add `istio.io/dataplane-mode=ambient` label
4. Optionally deploy waypoint for L7 features

Existing VirtualService, DestinationRule, AuthorizationPolicy resources continue to work.

## Multi-Cluster + Ambient

Combining ambient and multi-cluster is supported but newer territory. The ICA exam focuses on conceptual understanding rather than deep hands-on configuration here.

## Common Exam Traps

- Confusing single-network and single-control-plane (orthogonal axes)
- Forgetting east-west gateway in multi-network
- Believing ambient does not need a CA (it does; identity is still SPIFFE)
- Thinking waypoint is always required (only for L7)
- Mixing namespace-level labels: cannot have both `istio-injection=enabled` and `istio.io/dataplane-mode=ambient`
- Forgetting trust bundle setup for multi-primary mesh
