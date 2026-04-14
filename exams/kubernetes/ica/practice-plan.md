# Istio Certified Associate - 6 Week Practice Plan

This plan assumes 10 hours per week and access to a Kubernetes cluster (kind, k3d, minikube, or cloud).

## Week 1: Install and Sidecar Injection

Goals: get fluent installing and uninstalling Istio.

- Install kind or k3d locally; create a 3-node cluster
- Install Istio using `istioctl install --set profile=demo`
- Install Istio using Helm (base, istiod, gateway charts)
- Install Istio using IstioOperator CR
- Practice revisioned install: install rev 1-22, then 1-23, migrate workloads
- Enable sidecar injection on a namespace; deploy bookinfo
- Verify sidecars: `kubectl get pods -o wide`, `istioctl proxy-status`
- Uninstall and reinstall multiple times

Deliverable: install Istio four different ways from scratch in under 15 minutes each.

## Week 2: Traffic Management

Goals: master VirtualService and DestinationRule.

- Deploy bookinfo with reviews v1, v2, v3
- Route 100 percent to v1 (DestinationRule subsets + VirtualService)
- Canary 90/10 split between v1 and v3
- Header-based routing (only `end-user: jason` sees v2)
- Path-based routing for httpbin
- Configure a Gateway and expose bookinfo externally
- Add a ServiceEntry for an external service (httpbin.org)
- Practice mirroring and weight shifts
- Configure locality-based routing across multiple zones (in cloud cluster)

Deliverable: write each routing pattern from memory in under 5 minutes.

## Week 3: Security

Goals: configure mesh-wide and workload-level security.

- Enable mesh-wide STRICT mTLS via PeerAuthentication
- Migrate gradually: PERMISSIVE namespace then STRICT
- Configure RequestAuthentication for a JWT issuer
- Write AuthorizationPolicy: ALLOW only specific service accounts to call reviews
- Write DENY policies for specific paths
- Use ALLOW with rules combining principals, namespaces, methods, paths
- Test deny: confirm 403 from unauthorized callers
- Inspect certs: `istioctl proxy-config secret <pod>`

Deliverable: write all three security CRD types fluently from memory.

## Week 4: Observability and Resilience

Goals: instrument and harden services.

- Install Prometheus, Grafana, Jaeger, Kiali addons
- Generate traffic with `siege` or `hey`
- Find request_count, request_duration metrics in Prometheus
- View distributed traces in Jaeger; understand B3/W3C propagation headers
- Use Telemetry API to customize access logs and trace sampling
- Configure timeouts: 5s on reviews
- Configure retries: 3 attempts, retry on 5xx
- Configure circuit breaker via DestinationRule connectionPool + outlierDetection
- Inject faults: 7s delay 50 percent, 503 abort 10 percent
- Verify behavior under load

Deliverable: configure each resilience pattern within 3 minutes.

## Week 5: Troubleshooting and Ambient

Goals: diagnose like an SRE.

- Break things deliberately: bad VirtualService host, missing DestinationRule subset, mTLS mismatch
- Use `istioctl analyze` to detect issues
- Use `istioctl proxy-config` for clusters, listeners, routes, endpoints, secrets
- Use `istioctl x describe pod` to understand routing applied to a pod
- Diagnose 503 NR, UH, UF, RH, UC errors via access logs
- Diagnose AuthZ denials via Envoy logs (RBAC: access denied)
- Try Ambient mode: install with `--set profile=ambient`
- Deploy a workload, observe ztunnel handling L4
- Add a waypoint proxy for L7 policies

Deliverable: diagnose 5 broken-mesh scenarios in under 10 minutes each.

## Week 6: Mock Exams and Speed

Goals: pass under time pressure.

- Run two full mock exams (90 minutes, 15-20 tasks each)
- Time yourself on every task: target half the budget per task
- Re-do anything you did slowly
- Bookmark the istio.io pages you reach for most
- Light review the day before; sleep early

## Daily Cadence

- 30 minutes reading docs / blog / book
- 60 minutes hands-on cluster work
- 30 minutes timed task drills (single CRD configuration under 3 minutes)

## Cluster Options

- kind or k3d (free, local)
- Civo, DigitalOcean for cheap managed K8s
- AWS/Azure/GCP free tier or learner accounts
- Killercoda or Killer.sh playgrounds (paid, exam-like)

## Cheat Sheet to Build

A personal one-page reference with:

- All CRD skeletons (Gateway, VirtualService, DestinationRule, PeerAuth, AuthZ)
- istioctl commands you use most
- Common Envoy flag codes (NR, UH, UF, RH, UC, DC, LH, FI)
- Bookmark URLs for every Istio task page

## Red Flags You Are Not Ready

- Cannot write a VirtualService from memory
- Cannot diagnose a missing-sidecar problem
- Cannot configure STRICT mTLS in under 3 minutes
- Mock score below 70 percent under time pressure
