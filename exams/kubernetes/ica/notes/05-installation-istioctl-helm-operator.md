# 05. Installation: istioctl, Helm, and IstioOperator

## Choosing an Installation Method

Three primary methods today (the Operator controller pattern is deprecated for new installs):

1. **istioctl install**: recommended for most cases; uses IstioOperator schema as input
2. **Helm**: best for GitOps/CI workflows, fully declarative
3. **IstioOperator file** with `istioctl install -f`: same as #1 but customized

The exam expects fluency with at least istioctl and Helm.

## Profiles

Built-in profiles trade off features and footprint:

- **default**: production-ready baseline
- **demo**: includes addons (Bookinfo, Prometheus, Grafana, Jaeger, Kiali); for learning
- **minimal**: just istiod, no gateways, no addons
- **ambient**: ambient mode (ztunnel + waypoint architecture)
- **empty**: starting point for fully custom configs
- **preview**: latest experimental features
- **remote**: for multi-cluster remote configurations

```bash
istioctl profile list
istioctl profile dump demo
istioctl profile diff default demo
```

## istioctl Install Patterns

### Basic
```bash
istioctl install --set profile=demo -y
```

### With overrides
```bash
istioctl install --set profile=default \
  --set values.global.proxy.resources.requests.cpu=200m \
  --set components.ingressGateways[0].enabled=true \
  -y
```

### From a file
```yaml
# my-iop.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: control-plane
spec:
  profile: default
  meshConfig:
    accessLogFile: /dev/stdout
  components:
    pilot:
      k8s:
        resources:
          requests: { cpu: 1000m, memory: 4Gi }
    ingressGateways:
      - name: istio-ingressgateway
        enabled: true
```

```bash
istioctl install -f my-iop.yaml -y
```

### Revisioned install
```bash
istioctl install --set revision=1-22 -y
```

This installs istiod-1-22 alongside any existing revisions. Workloads opt in via namespace label `istio.io/rev=1-22`.

## Helm Install Patterns

```bash
# Add the Istio Helm repo
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# 1. Base CRDs
helm install istio-base istio/base -n istio-system --create-namespace

# 2. Control plane (istiod)
helm install istiod istio/istiod -n istio-system

# 3. Ingress gateway in its own namespace
kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled
helm install istio-ingress istio/gateway -n istio-ingress
```

Helm supports revisioned upgrades:

```bash
helm install istiod-1-22 istio/istiod -n istio-system --set revision=1-22
```

## Sidecar Injection

### Automatic (recommended)

Label the namespace:

```bash
kubectl label namespace bookinfo istio-injection=enabled
```

Or, with revisions:

```bash
kubectl label namespace bookinfo istio.io/rev=1-22
```

### Manual

```bash
istioctl kube-inject -f deploy.yaml | kubectl apply -f -
```

### Per-pod opt-out

```yaml
metadata:
  labels:
    sidecar.istio.io/inject: "false"
```

### Re-inject existing pods

Sidecar injection happens at pod creation. Restart deployments to re-inject:

```bash
kubectl rollout restart deploy -n bookinfo
```

## Upgrades

### In-place upgrade
```bash
istioctl upgrade -f my-iop.yaml
```

Risk: brief disruption; not recommended for production.

### Revisioned (canary) upgrade
```bash
# Install new revision alongside old
istioctl install --revision 1-23 -y

# Move workloads
kubectl label namespace bookinfo istio.io/rev=1-23 --overwrite
kubectl label namespace bookinfo istio-injection-

# Restart pods
kubectl rollout restart deploy -n bookinfo

# Once verified, uninstall old revision
istioctl uninstall --revision 1-22 -y
```

This is the production-recommended upgrade pattern.

## Verifying an Install

```bash
istioctl version            # control plane and CLI versions
istioctl x precheck         # pre-install validation
kubectl get pods -n istio-system
istioctl analyze            # config validation
istioctl proxy-status       # are all sidecars synced?
```

## Ambient Install

```bash
istioctl install --set profile=ambient --skip-confirmation
```

Components installed:
- istiod
- ztunnel (DaemonSet)
- istio-cni
- istio-ingressgateway

No automatic sidecar injection. Workloads join the mesh via namespace label:

```bash
kubectl label namespace bookinfo istio.io/dataplane-mode=ambient
```

For L7 features, deploy a waypoint:

```bash
istioctl x waypoint apply -n bookinfo
```

## Common Install Issues

### Webhook race condition
If you apply workloads before istiod is ready, sidecars are not injected. Wait for istiod to be ready.

### CRD version conflicts
Mixing chart versions and CRD versions causes mysterious validation errors. Use one source.

### Gateway not picking up traffic
Gateway selector (`istio: ingressgateway`) must match the Service label. If you renamed the gateway deployment, update the selector.

### Resource limits
Default profiles work for small clusters. Production needs memory and CPU tuning for istiod (proportional to mesh size, services, configs).

### Custom CA
Provide `cacerts` Secret in `istio-system` BEFORE installing istiod for the cert chain to be trusted.

## Useful Commands

```bash
istioctl install --dry-run -f config.yaml      # see what would be applied
istioctl manifest generate -f config.yaml      # output raw manifests
istioctl manifest diff old.yaml new.yaml       # see what would change
istioctl uninstall --purge -y                  # full removal
istioctl x precheck                            # readiness check
istioctl x precheck --revision 1-23           # readiness for upgrade
```

## Common Exam Traps

- Forgetting `--create-namespace` on first Helm install
- Mixing label modes (revision vs istio-injection)
- Not restarting pods after enabling injection
- Installing addons separately (they are in samples/addons/, not in default install)
- Operator CR confusion: IstioOperator file is the input format; the controller pattern is deprecated
