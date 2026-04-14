# 01. Istio Architecture and Control Plane

## What Istio Is

Istio is a service mesh: a dedicated infrastructure layer that handles service-to-service communication so application code does not. It provides traffic management, security (mTLS, authn, authz), and observability (metrics, traces, logs) by injecting Envoy proxies alongside workloads (sidecar mode) or as shared node and namespace proxies (ambient mode).

Istio runs on Kubernetes primarily. The control plane configures the data plane proxies; the data plane carries the traffic.

## Components

### Control plane: istiod

Since Istio 1.5, the control plane consolidated into a single binary called **istiod**. It contains:

- **Pilot**: configuration for proxies (Envoy xDS APIs)
- **Citadel**: certificate authority and key management
- **Galley**: configuration ingestion and validation

You typically run istiod as a single deployment in `istio-system`, often with multiple replicas for HA.

### Data plane

In **sidecar mode**:
- An Envoy proxy is injected into every workload pod
- The sidecar intercepts inbound and outbound traffic via `iptables` redirection
- Application code is unchanged; configuration drives behavior

In **ambient mode** (newer):
- **ztunnel** is a per-node proxy handling L4 (mTLS, identity, basic policy)
- **Waypoint proxies** handle L7 (advanced routing, AuthZ) at the service or namespace level
- No sidecars; lower overhead, easier upgrades

### Gateways

- **Ingress Gateway**: a dedicated Envoy that handles north-south traffic into the mesh
- **Egress Gateway**: a dedicated Envoy for traffic leaving the mesh, often for governance and monitoring
- Both are just Envoy deployments managed by Istio with Gateway CRD configuration

## How Configuration Flows

1. You apply Istio CRDs (VirtualService, DestinationRule, etc.) to Kubernetes
2. istiod watches Kubernetes API for CRD changes and Service/Endpoint changes
3. istiod translates CRDs into Envoy xDS configuration (LDS, RDS, CDS, EDS, SDS)
4. Sidecars connect to istiod over gRPC (port 15012) and pull the latest config
5. Each sidecar enforces config locally; no central data plane bottleneck

## Sidecar Injection

Two modes:

- **Automatic**: namespace labeled `istio-injection=enabled` (or `istio.io/rev=<rev>`); a mutating admission webhook adds the sidecar at pod creation
- **Manual**: `istioctl kube-inject` adds sidecar to a manifest before apply

Sidecar injection is the most common source of "it does not work" issues. Existing pods are not re-injected automatically; restart deployments.

## Revisioned Installation

Modern Istio supports **revisioned control planes** for safe upgrades:

- Install rev 1-22 alongside existing rev 1-21
- Migrate workloads namespace-by-namespace by changing the rev label
- Verify, then uninstall the old revision

This pattern is the primary upgrade strategy and is exam-relevant.

## Installation Methods

### istioctl (recommended for learning)
```bash
istioctl install --set profile=demo
istioctl install -f my-iop.yaml
istioctl install --revision 1-22
```

Profiles: default (production), demo (with Bookinfo addons), minimal (just istiod), ambient (ambient mode), empty, preview.

### Helm
```bash
helm install istio-base istio/base -n istio-system --create-namespace
helm install istiod istio/istiod -n istio-system
helm install istio-ingress istio/gateway -n istio-ingress
```

### Operator (deprecated for new installs)
The IstioOperator CR is the schema; the Operator controller pattern was deprecated in 1.23. Use `istioctl install` with an IstioOperator file instead.

## Ambient Mode Architecture

A simplified picture:

- **ztunnel**: a per-node DaemonSet proxy that handles mTLS, identity, and L4 policy. Uses HBONE (HTTP-based overlay network) for encrypted L4 transport between nodes.
- **Waypoint proxy**: optional, deployed per service account or namespace, handles L7 features like advanced routing and AuthZ rules with HTTP semantics.

Benefits:

- Workloads do not need sidecars (lower memory and CPU per pod)
- Upgrades touch only ztunnel (DaemonSet) and waypoints, not workload pods
- Can adopt incrementally per namespace

Trade-offs:

- Newer; some features still maturing
- Two-tier proxy (ztunnel + waypoint) is more conceptual overhead
- Some advanced sidecar-only features may not yet be supported

## Identity

Istio assigns each workload a SPIFFE identity:

```
spiffe://cluster.local/ns/<namespace>/sa/<service-account>
```

This identity is encoded in the workload's certificate (issued by Citadel/istiod) and is the basis of mTLS authentication and AuthorizationPolicy principals.

## Networking Model

- All traffic is intercepted by sidecars (or ztunnel in ambient)
- Inbound traffic: iptables redirects to sidecar port 15006
- Outbound traffic: iptables redirects to sidecar port 15001
- Sidecar-to-istiod: port 15012 (xDS gRPC)
- Health/metrics: 15020/15090

## istioctl: The Operator's Friend

```
istioctl install            # install / upgrade
istioctl analyze            # static analysis of config
istioctl proxy-status       # is each sidecar synced?
istioctl proxy-config       # what config does this sidecar have?
istioctl x describe pod     # what policies apply to this pod?
istioctl version            # control plane and data plane versions
```

## Common Architecture Mistakes

- Running multiple control planes without revisioning (chaos)
- Forgetting that istio-system is special (mesh-wide CRDs go here)
- Mixing label modes (`istio-injection=enabled` and `istio.io/rev=...`) in the same namespace
- Believing istio-proxy is always required for mesh participation in ambient mode (it is not)
- Treating Gateway as a Service object (it is just config; Service is separate)
