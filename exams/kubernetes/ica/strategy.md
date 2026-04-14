# Istio Certified Associate - Exam Strategy

## Format Reality

ICA is performance-based. You sit at a real terminal, attached to a real Kubernetes cluster with Istio installed. Each task asks you to configure resources to meet a stated outcome. The system grades the resulting cluster state, not your typing path.

Key implications:

- Speed matters; 90 minutes for 15-20 tasks is tight
- Partial credit exists; do not skip easy parts of hard tasks
- The grader checks state, so any path that produces correct state passes
- istio.io docs are open; learn the layout

## Time Management

- Average budget: 4-6 minutes per task
- Read all tasks first; flag the easy ones to do first
- Hard tasks: do the easy sub-parts first, return for the rest
- Reserve 10 minutes at the end for review and verification

## Setup Tactics

- Set context aliases: `alias k=kubectl`, `alias ki=istioctl`
- Set namespace per task: `kubectl config set-context --current --namespace=<ns>`
- Confirm the right cluster/context for each task; the exam may switch
- Always verify state after applying: `kubectl get`, `istioctl analyze`, `istioctl proxy-config`

## Common Task Patterns

### Install / Configure
- `istioctl install` with a specific profile or set of values
- Enable injection on a namespace: `kubectl label namespace x istio-injection=enabled`
- Restart pods to pick up sidecars: `kubectl rollout restart deploy ...`

### Traffic Management
- Define DestinationRule with subsets first, then VirtualService that uses them
- For canary, both subsets must exist or routes will fail
- For host-based Gateway, hosts in Gateway and VirtualService must align

### Security
- PeerAuthentication mode STRICT; place in `istio-system` for mesh-wide, in workload namespace for narrower scope
- AuthorizationPolicy: empty selector targets all in namespace; specify selector to narrow
- Action ALLOW with no rules permits nothing (deny-all); use ALLOW with rules

### Observability
- Telemetry API for custom sampling, access logs, metrics overrides
- Always enable the addon (Prometheus, Jaeger) before checking output

### Troubleshooting
- Start with `istioctl analyze`; it catches most config errors fast
- Then `istioctl proxy-status` for sync state
- Then `istioctl proxy-config` for the deep dive

## Common Traps

### Trap 1: Sidecar not injected
A pod existed before you enabled injection, or the namespace label is missing. Solution: label namespace, restart deployment.

### Trap 2: Subset does not exist
VirtualService routes to subset `v2` but DestinationRule only defines `v1` and `v3`. Routes silently fail (503 NR). Always create DR before VS.

### Trap 3: Gateway hosts mismatch
Gateway listens on `*` or specific hosts; VirtualService binds to a Gateway and lists hosts. Mismatch causes the route to be ignored.

### Trap 4: STRICT mTLS breaks unmeshed callers
Enabling STRICT in a namespace breaks calls from pods without sidecars. Use PERMISSIVE first or scope STRICT carefully.

### Trap 5: AuthorizationPolicy ALLOW with no rules
That is deny-all. To allow everything, use no AuthorizationPolicy or use ALLOW with `{}` rules.

### Trap 6: Wrong namespace placement
PeerAuthentication in `istio-system` is mesh-wide. In an app namespace, it is namespace-wide. In a workload namespace with a selector, it is workload-wide.

### Trap 7: Egress traffic blocked
Default Istio allows egress (ALLOW_ANY mode). If REGISTRY_ONLY mode is set, ServiceEntry is required for external hosts.

### Trap 8: Revision mismatch
Revisioned installs (1-22, 1-23) require namespace label `istio.io/rev=1-23` instead of `istio-injection=enabled`. Mixing breaks injection.

## Diagnostic Sequence

When a configuration is not behaving:

1. `istioctl analyze` (catches config errors)
2. `kubectl describe vs/dr/gateway/peerauth/authzpolicy` (look for warnings)
3. `istioctl proxy-status` (are sidecars synced?)
4. `istioctl proxy-config routes <pod>` (does the route exist on the pod?)
5. `istioctl proxy-config clusters <pod>` (does the upstream cluster exist?)
6. `istioctl proxy-config endpoints <pod>` (does it have endpoints?)
7. Access logs: `kubectl logs <pod> -c istio-proxy`
8. Envoy flag codes (NR, UH, UF, etc.) tell you the failure type

## Anti-Patterns

- Re-typing complex YAML when you can copy from istio.io tasks
- Forgetting to apply (saving file but not applying)
- Forgetting `-n <namespace>` and applying to the wrong namespace
- Using `vi` when `nano` would be faster (or vice versa, use what you know)

## Pre-Exam Checklist

- Practiced all CRD skeletons from memory
- Comfortable with `istioctl proxy-config` subcommands
- Bookmarked istio.io tasks pages for quick copy
- Timed yourself on at least 15 tasks at 4 minutes each
- Test webcam, mic, ID, clean desk

## Day Of

- Use the practice exam access if provided
- Log in 20 minutes early
- Stay calm on long tasks; partial credit beats panic
