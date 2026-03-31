# Domain 1: Application Design and Build (20%)

## Overview

This domain covers the fundamentals of designing and building applications for Kubernetes. You need to understand Pod design patterns, multi-container configurations, container images, batch workloads (Jobs and CronJobs), and persistent storage.

## Pods

**[📖 Pods](https://kubernetes.io/docs/concepts/workloads/pods/)** - Core Pod documentation
**[📖 Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)** - Phases, conditions, and container states

### Pod Fundamentals
- A Pod is the smallest deployable unit in Kubernetes
- Pods contain one or more containers that share network (same IP, localhost communication) and storage
- Pods are ephemeral - they are not restarted, they are replaced
- Always use a controller (Deployment, Job, etc.) to manage Pods in production

### Pod Phases
| Phase | Description |
|-------|-------------|
| Pending | Pod accepted but containers not yet running (scheduling, image pull) |
| Running | Pod bound to a node, at least one container running |
| Succeeded | All containers terminated successfully (exit code 0) |
| Failed | All containers terminated, at least one with failure |
| Unknown | Pod state cannot be determined (node communication failure) |

### Creating Pods

**Imperative:**
```bash
# Basic Pod
kubectl run nginx --image=nginx:1.25

# Pod with port and labels
kubectl run nginx --image=nginx:1.25 --port=80 --labels="app=web,tier=frontend"

# Pod with environment variables
kubectl run myapp --image=myapp:1.0 --env="DB_HOST=localhost" --env="DB_PORT=5432"

# Pod with resource requests
kubectl run nginx --image=nginx:1.25 --requests="cpu=100m,memory=64Mi" --limits="cpu=200m,memory=128Mi"

# Generate YAML without creating
kubectl run nginx --image=nginx:1.25 --dry-run=client -o yaml > pod.yaml
```

**Declarative (YAML):**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  labels:
    app: myapp
    tier: frontend
spec:
  containers:
    - name: myapp
      image: myapp:1.0
      ports:
        - containerPort: 8080
      env:
        - name: DB_HOST
          value: "localhost"
      resources:
        requests:
          cpu: 100m
          memory: 64Mi
        limits:
          cpu: 200m
          memory: 128Mi
```

---

## Multi-Container Pod Patterns

**[📖 Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)** - Initialization containers
**[📖 Sidecar Containers](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/)** - Native sidecar support
**[📖 Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)** - PostStart and PreStop

### Sidecar Pattern
A helper container that runs alongside the main application container for the entire Pod lifecycle. Common use cases:
- Log shipping (read logs from shared volume, forward to logging system)
- Configuration reloading (watch for config changes, signal the main app)
- Proxy (handle TLS termination, service mesh sidecar)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-example
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: logs
          mountPath: /var/log/app
    - name: log-shipper
      image: fluentd:latest
      volumeMounts:
        - name: logs
          mountPath: /var/log/app
          readOnly: true
  volumes:
    - name: logs
      emptyDir: {}
```

### Init Container Pattern
Containers that run to completion before any app containers start. They run sequentially - the next init container only starts after the previous one succeeds.

Common use cases:
- Wait for a dependent service to be available
- Populate a shared volume with data
- Run database migrations
- Fetch configuration from an external source

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-example
spec:
  initContainers:
    - name: wait-for-db
      image: busybox:1.36
      command: ['sh', '-c', 'until nslookup db-service.default.svc.cluster.local; do echo "Waiting for DB..."; sleep 2; done']
    - name: init-data
      image: busybox:1.36
      command: ['sh', '-c', 'wget -O /data/config.json http://config-service/config']
      volumeMounts:
        - name: config
          mountPath: /data
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: config
          mountPath: /app/config
          readOnly: true
  volumes:
    - name: config
      emptyDir: {}
```

### Ambassador Pattern
A proxy container that handles external communication. The main container connects to localhost, and the ambassador routes requests to the appropriate external service.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ambassador-example
spec:
  containers:
    - name: app
      image: myapp:1.0
      env:
        - name: DB_HOST
          value: "localhost"
        - name: DB_PORT
          value: "5432"
    - name: db-proxy
      image: ambassador-proxy:1.0
      ports:
        - containerPort: 5432
```

### Adapter Pattern
A container that transforms or standardizes the main container's output. For example, converting log formats or normalizing metrics.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: adapter-example
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: logs
          mountPath: /var/log/app
    - name: log-adapter
      image: log-transformer:1.0
      volumeMounts:
        - name: logs
          mountPath: /var/log/app
          readOnly: true
  volumes:
    - name: logs
      emptyDir: {}
```

---

## Container Images

**[📖 Images](https://kubernetes.io/docs/concepts/containers/images/)** - Image concepts and policies
**[📖 Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)** - Private registry authentication

### Image Pull Policies
| Policy | Behavior |
|--------|----------|
| `Always` | Always pull the image (default for `:latest` tag) |
| `IfNotPresent` | Pull only if not already on the node (default for specific tags) |
| `Never` | Never pull - image must exist locally |

### Dockerfile Best Practices for Kubernetes
- Use specific image tags, not `:latest`
- Use multi-stage builds to minimize image size
- Run as non-root user (`USER` instruction)
- Include health check endpoints in your application
- Minimize layers and clean up in the same layer
- Use `.dockerignore` to exclude unnecessary files

### Private Registry Authentication
```bash
# Create a docker-registry Secret
kubectl create secret docker-registry my-registry-secret \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=password \
  --docker-email=user@example.com

# Reference in Pod spec
```

```yaml
spec:
  containers:
    - name: app
      image: registry.example.com/myapp:1.0
  imagePullSecrets:
    - name: my-registry-secret
```

---

## Jobs

**[📖 Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)** - Run-to-completion workloads
**[📖 TTL Controller for Finished Resources](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/)** - Automatic cleanup

### Job Configuration

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
spec:
  completions: 5          # Total successful completions needed
  parallelism: 2          # Pods running concurrently
  backoffLimit: 3          # Retries before failing
  activeDeadlineSeconds: 300  # Max duration for the Job
  ttlSecondsAfterFinished: 60  # Auto-cleanup after completion
  template:
    spec:
      restartPolicy: Never    # Must be Never or OnFailure
      containers:
        - name: processor
          image: busybox:1.36
          command: ['sh', '-c', 'echo "Processing..." && sleep 30']
```

**Imperative Job creation:**
```bash
kubectl create job my-job --image=busybox:1.36 -- echo "Hello from Job"
kubectl create job my-job --image=busybox:1.36 --dry-run=client -o yaml > job.yaml
```

### Key Points
- `restartPolicy` must be `Never` or `OnFailure` (never `Always`)
- `completions` defaults to 1 (single-completion Job)
- `parallelism` defaults to 1 (sequential execution)
- Use `completionMode: Indexed` to give each Pod a unique index via `JOB_COMPLETION_INDEX`

---

## CronJobs

**[📖 CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)** - Scheduled Jobs

### CronJob Configuration

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup
spec:
  schedule: "0 2 * * *"        # Every day at 2 AM
  concurrencyPolicy: Forbid     # Don't run if previous is still running
  startingDeadlineSeconds: 200  # Max delay for starting a missed Job
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  suspend: false
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: backup
              image: backup-tool:1.0
              command: ['/bin/sh', '-c', 'backup.sh']
```

### Cron Schedule Syntax
```
┌───────── minute (0-59)
│ ┌─────── hour (0-23)
│ │ ┌───── day of month (1-31)
│ │ │ ┌─── month (1-12)
│ │ │ │ ┌─ day of week (0-6, Sunday=0)
│ │ │ │ │
* * * * *
```

Common examples:
- `*/5 * * * *` - Every 5 minutes
- `0 * * * *` - Every hour
- `0 0 * * *` - Every day at midnight
- `0 2 * * 0` - Every Sunday at 2 AM
- `30 8 1 * *` - 8:30 AM on the 1st of every month

### Concurrency Policies
| Policy | Behavior |
|--------|----------|
| `Allow` | Multiple Jobs can run concurrently (default) |
| `Forbid` | Skip new Job if previous is still running |
| `Replace` | Cancel the currently running Job and start a new one |

**Imperative CronJob creation:**
```bash
kubectl create cronjob my-cron --image=busybox:1.36 --schedule="*/5 * * * *" -- echo "Hello"
```

---

## Persistent and Ephemeral Volumes

**[📖 Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)** - Volume types
**[📖 Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)** - PV and PVC lifecycle
**[📖 Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)** - Dynamic provisioning

### Volume Types for CKAD

| Type | Lifetime | Use Case |
|------|----------|----------|
| `emptyDir` | Pod lifetime | Temporary storage, shared data between containers |
| `hostPath` | Node lifetime | Access node filesystem (testing only) |
| `persistentVolumeClaim` | Independent | Persistent data that survives Pod restarts |
| `configMap` | ConfigMap lifetime | Mount configuration files |
| `secret` | Secret lifetime | Mount sensitive data as files |

### PersistentVolumeClaim Example

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 5Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: app-with-storage
spec:
  containers:
    - name: app
      image: nginx:1.25
      volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: my-pvc
```

### Access Modes
| Mode | Abbreviation | Description |
|------|-------------|-------------|
| ReadWriteOnce | RWO | Read-write by a single node |
| ReadOnlyMany | ROX | Read-only by multiple nodes |
| ReadWriteMany | RWX | Read-write by multiple nodes |
| ReadWriteOncePod | RWOP | Read-write by a single Pod |

### Reclaim Policies
- **Retain**: Keep the PV and its data after PVC is deleted (manual cleanup)
- **Delete**: Delete the PV and underlying storage when PVC is deleted (default for dynamic provisioning)
- **Recycle**: Deprecated - basic scrub (`rm -rf /thevolume/*`)
