# Workloads & Scheduling

## Overview

This domain represents 15% of the CKA exam. It covers deploying applications, managing workload resources, configuring scheduling behavior, and using ConfigMaps and Secrets.

**[Workloads](https://kubernetes.io/docs/concepts/workloads/)** - Workloads overview

## Deployments

Deployments are the primary way to manage stateless applications in Kubernetes. A Deployment manages a ReplicaSet, which in turn manages Pods.

### Creating Deployments

```bash
# Imperative creation (fast for exam)
kubectl create deployment nginx --image=nginx:1.25 --replicas=3

# Generate YAML for customization
kubectl create deployment nginx --image=nginx:1.25 --replicas=3 \
  --dry-run=client -o yaml > deployment.yaml
```

### Deployment YAML Structure

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
```

**[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** - Complete Deployment documentation

### Rolling Updates and Rollbacks

```bash
# Update the image (triggers rolling update)
kubectl set image deployment/nginx-deployment nginx=nginx:1.26

# Check rollout status
kubectl rollout status deployment/nginx-deployment

# View rollout history
kubectl rollout history deployment/nginx-deployment

# View details of a specific revision
kubectl rollout history deployment/nginx-deployment --revision=2

# Rollback to previous version
kubectl rollout undo deployment/nginx-deployment

# Rollback to a specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=1

# Pause a rollout (for making multiple changes)
kubectl rollout pause deployment/nginx-deployment

# Resume a paused rollout
kubectl rollout resume deployment/nginx-deployment
```

**Update Strategies:**
- **RollingUpdate** (default) - gradually replaces old pods with new ones
  - `maxUnavailable` - max pods that can be unavailable during update (default 25%)
  - `maxSurge` - max pods that can be created above desired count (default 25%)
- **Recreate** - terminates all existing pods before creating new ones (causes downtime)

**[Performing a Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)** - Update tutorial

### Scaling

```bash
# Scale a deployment
kubectl scale deployment/nginx-deployment --replicas=5

# Autoscale based on CPU (requires metrics-server)
kubectl autoscale deployment/nginx-deployment --min=3 --max=10 --cpu-percent=80
```

## ReplicaSets

ReplicaSets ensure a specified number of pod replicas are running at any given time. Deployments manage ReplicaSets - you rarely create them directly.

**Key Facts:**
- `selector.matchLabels` must match `template.metadata.labels`
- Scaling a ReplicaSet directly is overridden by the owning Deployment
- Old ReplicaSets are retained for rollback (controlled by `revisionHistoryLimit`)

**[ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)** - ReplicaSet documentation

## StatefulSets

StatefulSets manage stateful applications that require stable identities and persistent storage.

**Key Characteristics:**
- Pods get stable, unique hostnames: `<name>-0`, `<name>-1`, `<name>-2`
- Ordered deployment and scaling (pods created in order 0, 1, 2...)
- Ordered, graceful deletion (pods deleted in reverse order)
- Stable persistent storage via volumeClaimTemplates
- Require a headless Service for network identity

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

**Use Cases:**
- Databases (MySQL, PostgreSQL, MongoDB)
- Distributed systems (ZooKeeper, Kafka, Elasticsearch)
- Applications requiring stable network identity

**[StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)** - StatefulSet documentation
**[StatefulSet Tutorial](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)** - Hands-on tutorial

## DaemonSets

DaemonSets ensure that a copy of a Pod runs on all (or selected) nodes in the cluster.

**Key Facts:**
- One pod per node (automatically scheduled)
- New pods are created when new nodes join the cluster
- Pods are removed when nodes are removed
- Use `nodeSelector` or `affinity` to target specific nodes

**Common Use Cases:**
- Log collectors (Fluentd, Filebeat)
- Monitoring agents (Prometheus Node Exporter, Datadog agent)
- Network plugins (Calico, Cilium, Weave Net)
- Storage daemons (Ceph, GlusterFS)

```bash
# No imperative command for DaemonSets - use YAML
```

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        effect: NoSchedule
      containers:
      - name: fluentd
        image: fluentd:v1.16
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

**[DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)** - DaemonSet documentation

## Jobs and CronJobs

### Jobs

Jobs create one or more Pods and ensure that a specified number of them successfully terminate.

```bash
# Create a job imperatively
kubectl create job my-job --image=busybox -- /bin/sh -c "echo hello; sleep 30; echo done"
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-job
spec:
  completions: 3        # Number of successful completions needed
  parallelism: 2        # Number of pods running in parallel
  backoffLimit: 4        # Number of retries before marking as failed
  activeDeadlineSeconds: 300  # Timeout for the entire job
  template:
    spec:
      restartPolicy: Never  # Must be Never or OnFailure
      containers:
      - name: backup
        image: busybox
        command: ["sh", "-c", "echo backing up data"]
```

**[Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)** - Job documentation

### CronJobs

CronJobs create Jobs on a schedule using cron syntax.

```bash
# Create a cronjob imperatively
kubectl create cronjob backup --image=busybox --schedule="0 2 * * *" \
  -- /bin/sh -c "echo running backup"
```

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-backup
spec:
  schedule: "0 2 * * *"              # At 2:00 AM daily
  concurrencyPolicy: Forbid           # Don't run if previous is still running
  successfulJobsHistoryLimit: 3       # Keep last 3 successful jobs
  failedJobsHistoryLimit: 1           # Keep last 1 failed job
  startingDeadlineSeconds: 200        # Deadline to start if missed schedule
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup
            image: busybox
            command: ["sh", "-c", "echo backup completed"]
```

**Cron Schedule Format:** `minute hour day-of-month month day-of-week`
- `*/5 * * * *` - every 5 minutes
- `0 2 * * *` - daily at 2:00 AM
- `0 0 * * 0` - weekly on Sunday at midnight
- `0 0 1 * *` - monthly on the 1st at midnight

**[CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)** - CronJob documentation

## Resource Requests and Limits

### Requests vs Limits

- **Requests** - the minimum amount of resources guaranteed to the container
  - Used by the scheduler to decide which node to place the pod on
  - A pod will not be scheduled if no node has enough available resources
- **Limits** - the maximum amount of resources the container can use
  - CPU: container is throttled when it exceeds the limit
  - Memory: container is OOM-killed when it exceeds the limit

```yaml
spec:
  containers:
  - name: app
    image: myapp:1.0
    resources:
      requests:
        cpu: 250m        # 0.25 CPU cores
        memory: 64Mi     # 64 mebibytes
      limits:
        cpu: 500m        # 0.5 CPU cores
        memory: 128Mi    # 128 mebibytes
```

**CPU Units:** `1` = 1 vCPU/core, `100m` = 0.1 CPU (millicores)
**Memory Units:** `Ki`, `Mi`, `Gi` (binary), `K`, `M`, `G` (decimal)

**[Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** - Resource configuration

### LimitRange

Sets default requests/limits and min/max constraints for containers in a namespace.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: dev
spec:
  limits:
  - default:
      cpu: 500m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    max:
      cpu: "2"
      memory: 1Gi
    min:
      cpu: 50m
      memory: 32Mi
    type: Container
```

**[LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)** - LimitRange documentation

### ResourceQuota

Limits the total resource consumption in a namespace.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 4Gi
    limits.cpu: "8"
    limits.memory: 8Gi
    pods: "20"
    persistentvolumeclaims: "10"
```

**[ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)** - ResourceQuota documentation

## Scheduling

### Node Selectors

The simplest way to constrain pod scheduling to specific nodes.

```yaml
spec:
  nodeSelector:
    disktype: ssd
    region: us-east
```

```bash
# Label a node
kubectl label nodes worker-1 disktype=ssd
```

### Node Affinity

More expressive node selection rules than nodeSelector.

```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
            - nvme
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: zone
            operator: In
            values:
            - us-east-1a
```

**Operators:** `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt`, `Lt`

**[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)** - Scheduling reference

### Pod Affinity and Anti-Affinity

Schedule pods relative to other pods.

```yaml
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - cache
        topologyKey: kubernetes.io/hostname
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: app
              operator: In
              values:
              - web
          topologyKey: kubernetes.io/hostname
```

### Taints and Tolerations

Taints are applied to nodes to repel pods. Tolerations are applied to pods to allow scheduling on tainted nodes.

```bash
# Apply a taint to a node
kubectl taint nodes worker-1 key=value:NoSchedule

# Remove a taint
kubectl taint nodes worker-1 key=value:NoSchedule-
```

**Taint Effects:**
- `NoSchedule` - pods without matching toleration will not be scheduled
- `PreferNoSchedule` - scheduler tries to avoid, but not guaranteed
- `NoExecute` - existing pods without matching toleration are evicted

```yaml
# Pod toleration
spec:
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"
  - key: "special"
    operator: "Exists"
    effect: "NoExecute"
    tolerationSeconds: 3600  # Evict after 1 hour if taint is added
```

**[Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)** - Reference documentation

### Static Pods

Pods managed directly by the kubelet on a specific node (not through the API server).

**Key Facts:**
- Defined as YAML files in `/etc/kubernetes/manifests/` (default path)
- kubelet watches this directory and manages the pods
- Control plane components (API server, etcd, scheduler, controller manager) are static pods
- Mirror pods appear in the API server but cannot be controlled from there
- Useful for running essential node-level services

**[Static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)** - Static pod documentation

## ConfigMaps and Secrets

### ConfigMaps

Store non-confidential configuration data as key-value pairs.

```bash
# Create from literal values
kubectl create configmap app-config \
  --from-literal=DB_HOST=mysql \
  --from-literal=DB_PORT=3306

# Create from a file
kubectl create configmap app-config --from-file=config.properties

# Create from an env file
kubectl create configmap app-config --from-env-file=app.env
```

**Using ConfigMaps in Pods:**

```yaml
# As environment variables
spec:
  containers:
  - name: app
    envFrom:
    - configMapRef:
        name: app-config
    env:
    - name: DATABASE_HOST
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: DB_HOST

# As a volume mount
spec:
  containers:
  - name: app
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

**[ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)** - ConfigMap documentation

### Secrets

Store sensitive data with base64 encoding.

```bash
# Create from literal values
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=s3cret

# Create TLS secret
kubectl create secret tls tls-secret \
  --cert=tls.crt \
  --key=tls.key

# Create docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=user \
  --docker-password=pass
```

**Using Secrets in Pods:**

```yaml
# As environment variables
spec:
  containers:
  - name: app
    envFrom:
    - secretRef:
        name: db-secret
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password

# As a volume mount
spec:
  containers:
  - name: app
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-secret
```

**[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Secret documentation

## Key Exam Tips for This Domain

1. **Use imperative commands** to create Deployments, Jobs, and CronJobs quickly
2. **Know rolling update parameters** - `maxUnavailable` and `maxSurge`
3. **Practice rollback commands** - `kubectl rollout undo`
4. **Understand the difference** between nodeSelector, nodeAffinity, and taints/tolerations
5. **Remember ConfigMap/Secret consumption methods** - env vars vs volume mounts
6. **Know Job restartPolicy** must be `Never` or `OnFailure` (not `Always`)
7. **Practice CronJob schedule syntax** - the five-field cron format
