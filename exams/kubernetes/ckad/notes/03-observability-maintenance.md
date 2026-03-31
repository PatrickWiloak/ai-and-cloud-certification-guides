# Domain 3: Application Observability and Maintenance (15%)

## Overview

This domain covers monitoring, debugging, and maintaining applications running on Kubernetes. You need to understand health checks (probes), logging, monitoring resource usage, debugging failing applications, and API deprecation handling.

## Probes and Health Checks

**[📖 Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)** - Detailed probe configuration
**[📖 Pod Lifecycle - Container Probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)** - Probe concepts

### Probe Types

| Probe | Question It Answers | Failure Action |
|-------|---------------------|---------------|
| **Liveness** | Is the container still running correctly? | Restart the container |
| **Readiness** | Is the container ready to accept requests? | Remove Pod from Service endpoints |
| **Startup** | Has the application finished starting up? | Restart the container (liveness/readiness disabled until success) |

### Probe Mechanisms

**HTTP GET Probe:**
```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
    httpHeaders:
      - name: Custom-Header
        value: "probe-check"
  initialDelaySeconds: 15
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
  successThreshold: 1
```
Success: HTTP status code 200-399.

**TCP Socket Probe:**
```yaml
readinessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 5
  periodSeconds: 10
```
Success: TCP connection established.

**Exec Probe:**
```yaml
livenessProbe:
  exec:
    command:
      - cat
      - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5
```
Success: Command exits with code 0.

**gRPC Probe:**
```yaml
livenessProbe:
  grpc:
    port: 50051
    service: my-service
  initialDelaySeconds: 10
  periodSeconds: 10
```
Success: gRPC health check returns SERVING.

### Probe Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `initialDelaySeconds` | 0 | Seconds to wait before first probe |
| `periodSeconds` | 10 | How often to probe |
| `timeoutSeconds` | 1 | Seconds before probe times out |
| `successThreshold` | 1 | Consecutive successes to be considered healthy |
| `failureThreshold` | 3 | Consecutive failures to trigger action |

### Complete Probe Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probed-app
spec:
  containers:
    - name: app
      image: myapp:1.0
      ports:
        - containerPort: 8080
      startupProbe:
        httpGet:
          path: /healthz
          port: 8080
        failureThreshold: 30
        periodSeconds: 10
        # Allows up to 300 seconds (30 * 10) for startup
      livenessProbe:
        httpGet:
          path: /healthz
          port: 8080
        periodSeconds: 10
        failureThreshold: 3
      readinessProbe:
        httpGet:
          path: /ready
          port: 8080
        periodSeconds: 5
        failureThreshold: 3
```

### When to Use Each Probe

**Liveness Probe:**
- Application can get into a broken state that only a restart can fix
- Deadlocked processes
- Internal corruption
- Caution: Overly aggressive liveness probes can cause restart loops

**Readiness Probe:**
- Application needs time to load data or warm up
- Application depends on external services
- Application should temporarily stop receiving traffic during maintenance
- Connection pool exhaustion

**Startup Probe:**
- Application has a slow or variable startup time
- Prevents liveness probe from killing the container during startup
- Legacy applications with long initialization

---

## Container Logging

**[📖 Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)** - Kubernetes logging concepts

### kubectl logs Commands

```bash
# Basic log viewing
kubectl logs <pod-name>

# Specific container in a multi-container Pod
kubectl logs <pod-name> -c <container-name>

# Stream logs in real time
kubectl logs <pod-name> -f

# Previous container instance (after a restart)
kubectl logs <pod-name> --previous

# Last N lines
kubectl logs <pod-name> --tail=50

# Logs since a duration
kubectl logs <pod-name> --since=1h
kubectl logs <pod-name> --since=30m

# Logs since a specific time
kubectl logs <pod-name> --since-time="2024-01-15T10:00:00Z"

# All containers in the Pod
kubectl logs <pod-name> --all-containers=true

# Logs from all Pods matching a label
kubectl logs -l app=myapp

# Logs from all Pods matching a label with follow
kubectl logs -l app=myapp -f --max-log-requests=10

# Combine flags
kubectl logs <pod-name> -c sidecar --tail=100 --since=30m
```

### Logging Best Practices for CKAD
- Applications should log to stdout/stderr, not to files
- Use structured logging (JSON) when possible
- Include timestamps, log levels, and context in log messages
- For file-based logs, use a sidecar container pattern to ship logs

---

## Monitoring and Resource Usage

**[📖 Resource Metrics Pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)** - Metrics pipeline
**[📖 Monitoring Resource Usage](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)** - Resource monitoring

### kubectl top Commands

```bash
# Node resource usage
kubectl top nodes

# Pod resource usage
kubectl top pods
kubectl top pods -n <namespace>
kubectl top pods --all-namespaces
kubectl top pods -l app=myapp

# Per-container resource usage
kubectl top pod <pod-name> --containers

# Sort by CPU or memory
kubectl top pods --sort-by=cpu
kubectl top pods --sort-by=memory
```

**Note:** `kubectl top` requires the Metrics Server to be installed in the cluster.

### Understanding Resource Units
- **CPU:** Measured in millicores (m). 1 CPU = 1000m. `100m` = 0.1 CPU.
- **Memory:** Measured in bytes. Common units: Ki (kibibytes), Mi (mebibytes), Gi (gibibytes).

---

## Debugging Applications

**[📖 Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)** - Pod troubleshooting
**[📖 Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)** - Service troubleshooting
**[📖 Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)** - Inspecting running containers
**[📖 Get a Shell to a Running Container](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/)** - Exec into containers

### Debugging Workflow

**Step 1: Check Pod Status**
```bash
kubectl get pods -n <namespace>
kubectl get pods -o wide    # Shows node and IP
```

Common Pod statuses:
| Status | Meaning |
|--------|---------|
| Pending | Cannot be scheduled (insufficient resources, node affinity) |
| ContainerCreating | Image being pulled or volume being mounted |
| Running | All containers started |
| CrashLoopBackOff | Container keeps crashing and being restarted |
| ImagePullBackOff | Cannot pull the container image |
| ErrImagePull | Failed to pull the container image |
| OOMKilled | Container exceeded its memory limit |
| Completed | Container finished successfully (for Jobs) |

**Step 2: Describe the Pod**
```bash
kubectl describe pod <pod-name> -n <namespace>
```
Look at:
- **Events** section (bottom): Shows scheduling, pulling, starting, and error events
- **Conditions**: Shows PodScheduled, Initialized, ContainersReady, Ready
- **Container state**: Waiting, Running, or Terminated with reason
- **Last State**: Previous container state (useful for CrashLoopBackOff)

**Step 3: Check Logs**
```bash
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -c <container> --previous    # After crash
```

**Step 4: Exec Into the Container**
```bash
kubectl exec -it <pod-name> -- /bin/sh
kubectl exec -it <pod-name> -c <container> -- /bin/bash

# Run a specific command
kubectl exec <pod-name> -- env
kubectl exec <pod-name> -- cat /etc/config/app.conf
kubectl exec <pod-name> -- wget -qO- http://localhost:8080/healthz
```

**Step 5: Check Events**
```bash
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get events --field-selector reason=Failed
```

### Common Issues and Fixes

**CrashLoopBackOff:**
- Check logs for application errors
- Verify the command/args in the container spec
- Check if the application needs environment variables or config
- Verify resource limits are sufficient

**ImagePullBackOff:**
- Check the image name and tag
- Verify the image exists in the registry
- Check imagePullSecrets for private registries
- Verify network connectivity to the registry

**Pending:**
- Check node resources (`kubectl describe node`)
- Verify node selectors and tolerations
- Check PVC binding (if using persistent volumes)
- Check ResourceQuotas in the namespace

**Service not routing traffic:**
- Verify Service selector matches Pod labels
- Check endpoints: `kubectl get endpoints <service-name>`
- Verify target port matches the container port
- Check NetworkPolicies

---

## API Deprecations

**[📖 Kubernetes Deprecation Policy](https://kubernetes.io/docs/reference/using-api/deprecation-policy/)** - Deprecation rules
**[📖 Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)** - API migration paths

### API Version Lifecycle
1. **Alpha** (`v1alpha1`): Experimental, may change or be removed without notice
2. **Beta** (`v1beta1`): Feature is well-tested, enabled by default, may have minor changes
3. **Stable** (`v1`): Feature is stable, API will not change in backward-incompatible ways

### Checking Available APIs
```bash
# List all API resources
kubectl api-resources

# List API versions
kubectl api-versions

# Check if a specific resource is available
kubectl api-resources | grep networkpolicies

# Explain a resource (shows API version and fields)
kubectl explain deployment
kubectl explain deployment.spec.strategy
```

### Notable API Changes
- **Ingress**: Moved from `extensions/v1beta1` and `networking.k8s.io/v1beta1` to `networking.k8s.io/v1`
- **NetworkPolicy**: Moved from `extensions/v1beta1` to `networking.k8s.io/v1`
- **CronJob**: Moved from `batch/v1beta1` to `batch/v1`

### Best Practice
Always use the latest stable API version. Check `kubectl explain <resource>` to see the current API version for any resource.
