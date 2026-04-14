# Istio Certified Associate - Fact Sheet

## Exam Identity

| Attribute | Value |
|-----------|-------|
| Certification body | CNCF + Solo.io (Linux Foundation training) |
| Exam code | ICA |
| Level | Associate |
| Delivery | Online proctored, browser-based terminal |
| Duration | 90 minutes (some sources cite 120) |
| Format | Performance-based, hands-on tasks in live Kubernetes cluster |
| Tasks | 15-20 weighted tasks |
| Passing score | 75 percent |
| Cost | 395 USD (often bundled with training discount) |
| Validity | 2 years |
| Languages | English |
| Open resources during exam | istio.io documentation |

## Domain Blueprint (approximate weights)

| Domain | Weight |
|--------|-------:|
| 1. Installation, Upgrade, and Configuration | 15% |
| 2. Traffic Management | 25% |
| 3. Security (mTLS, AuthN, AuthZ) | 20% |
| 4. Observability and Telemetry | 15% |
| 5. Resilience and Fault Tolerance | 10% |
| 6. Troubleshooting | 10% |
| 7. Multi-Cluster, Ambient, and Advanced | 5% |

## Key Concepts by Domain

### Domain 1: Installation
- istioctl install profiles (default, demo, minimal, ambient)
- IstioOperator CR
- Helm chart installation (base, istiod, gateway charts)
- Revisioned upgrades and canary control plane upgrades
- Sidecar injection (automatic via namespace label, manual)
- Ambient mode (ztunnel, waypoint proxies)

### Domain 2: Traffic Management
- Gateway, VirtualService, DestinationRule, ServiceEntry, Sidecar, WorkloadEntry
- Routing: host, path, header, weight (canary), mirror
- Subsets and load balancing policies
- Locality-based routing
- Egress control via ServiceEntry and Egress Gateway

### Domain 3: Security
- PeerAuthentication: mesh, namespace, workload scope; STRICT, PERMISSIVE, DISABLE
- RequestAuthentication: JWT validation
- AuthorizationPolicy: ALLOW, DENY, AUDIT, CUSTOM
- Certificate management: Citadel/istiod, SDS, root and intermediate CA
- mTLS modes and migration patterns

### Domain 4: Observability
- Built-in Prometheus metrics (request_count, request_duration, request_bytes, response_bytes)
- Distributed tracing (Zipkin, Jaeger, Tempo) and propagation headers
- Access logs (Envoy access log format)
- Telemetry API (replaces older annotations)
- Kiali for topology visualization

### Domain 5: Resilience
- Timeouts (per route)
- Retries (attempts, perTryTimeout, retryOn)
- Circuit breakers via DestinationRule connectionPool and outlierDetection
- Fault injection: delay and abort
- Traffic mirroring for safe testing

### Domain 6: Troubleshooting
- istioctl analyze
- istioctl proxy-status
- istioctl proxy-config (clusters, listeners, routes, endpoints, secrets)
- istioctl experimental describe
- Common failures: missing sidecar injection, mTLS mismatch, AuthZ denials, 503 NR/UH/UF, certificate rotation issues

### Domain 7: Multi-Cluster and Ambient
- Primary-remote, multi-primary, external control plane topologies
- Cross-cluster service discovery
- Ambient mode architecture: ztunnel (L4), waypoint proxy (L7)
- Migration paths from sidecar to ambient

## Critical Commands to Master

```
istioctl install --set profile=demo
istioctl install -f my-config.yaml
istioctl analyze
istioctl proxy-status
istioctl proxy-config clusters <pod>
istioctl proxy-config listeners <pod>
istioctl proxy-config routes <pod>
istioctl proxy-config endpoints <pod>
istioctl proxy-config secret <pod>
istioctl x describe pod <pod>
istioctl x precheck
istioctl x wait
kubectl label namespace foo istio-injection=enabled
kubectl label namespace foo istio.io/rev=1-22
istioctl version
istioctl upgrade
```

## CRDs You Must Know Cold

- networking.istio.io: Gateway, VirtualService, DestinationRule, ServiceEntry, Sidecar, WorkloadEntry, EnvoyFilter
- security.istio.io: PeerAuthentication, RequestAuthentication, AuthorizationPolicy
- telemetry.istio.io: Telemetry
- install.istio.io: IstioOperator
- extensions.istio.io: WasmPlugin

## Official Resources

- Istio docs: https://istio.io/latest/docs/
- Tasks (hands-on tutorials): https://istio.io/latest/docs/tasks/
- Reference: https://istio.io/latest/docs/reference/
- istioctl reference: https://istio.io/latest/docs/reference/commands/istioctl/
- Istio examples (Bookinfo, httpbin): https://istio.io/latest/docs/examples/
- Ambient mesh: https://istio.io/latest/docs/ambient/

## Recommended Materials

- Solo.io Istio fundamentals course
- Istio in Action by Christian Posta and Rinor Maloku
- Tetrate Academy free Istio courses
- KubeCon recorded Istio sessions
- Hands-on: deploy bookinfo, httpbin, sleep apps; do every task on istio.io
