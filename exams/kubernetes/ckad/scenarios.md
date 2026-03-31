# CKAD Exam-Style Hands-On Scenarios

These scenarios simulate the style and difficulty of CKAD exam tasks. Each scenario includes the task description, solution approach, and common mistakes to avoid.

**Practice Tips:**
- Time yourself - aim for 6-8 minutes per scenario
- Use imperative commands wherever possible
- Verify your work after each task
- Practice in a real cluster, not just on paper

---

## Scenario 1: Multi-Container Pod with Shared Volume

### Context
You are working in the `logging` namespace.

### Task
Create a Pod named `log-collector` in the `logging` namespace with two containers:

1. **app** container:
   - Image: `busybox:1.36`
   - Command: `sh -c 'while true; do echo "$(date) - Application log entry" >> /var/log/app.log; sleep 5; done'`
   - Mount a shared volume at `/var/log`

2. **sidecar** container:
   - Image: `busybox:1.36`
   - Command: `sh -c 'tail -f /var/log/app.log'`
   - Mount the same shared volume at `/var/log`

The shared volume should be an `emptyDir` volume named `log-volume`.

### Solution Approach
1. Create the namespace if it does not exist: `kubectl create namespace logging`
2. Generate a base Pod YAML: `kubectl run log-collector --image=busybox:1.36 --dry-run=client -o yaml > log-collector.yaml`
3. Edit the YAML to add the second container and the shared `emptyDir` volume
4. Apply the manifest: `kubectl apply -f log-collector.yaml -n logging`
5. Verify: `kubectl logs log-collector -c sidecar -n logging`

### Common Mistakes
- Forgetting to create the namespace first
- Incorrect volume mount paths (must match between containers)
- Missing the `command` field syntax (must be a list or use `sh -c`)
- Not specifying the namespace when applying

---

## Scenario 2: Liveness and Readiness Probes

### Context
You are working in the `default` namespace.

### Task
Create a Deployment named `web-probe` with the following specifications:
- Image: `nginx:1.25`
- Replicas: 2
- Add a **liveness probe** that performs an HTTP GET request to path `/` on port 80, with an initial delay of 10 seconds and a period of 5 seconds
- Add a **readiness probe** that performs a TCP socket check on port 80, with an initial delay of 5 seconds and a period of 10 seconds
- Set container resource requests to 64Mi memory and 100m CPU
- Set container resource limits to 128Mi memory and 200m CPU

### Solution Approach
1. Generate Deployment YAML: `kubectl create deployment web-probe --image=nginx:1.25 --replicas=2 --dry-run=client -o yaml > web-probe.yaml`
2. Edit the YAML to add probes and resource specifications
3. Apply: `kubectl apply -f web-probe.yaml`
4. Verify probes: `kubectl describe deployment web-probe`
5. Check Pod status: `kubectl get pods -l app=web-probe`

### Common Mistakes
- Incorrect probe indentation in YAML (probes go under `containers[].` not under `spec.`)
- Confusing `httpGet` and `tcpSocket` probe configurations
- Forgetting the `port` field in probes
- Mixing up `requests` and `limits` in resource specifications

---

## Scenario 3: Rolling Update and Rollback

### Context
You are working in the `production` namespace.

### Task
1. Create a Deployment named `webapp` in the `production` namespace with:
   - Image: `nginx:1.23`
   - Replicas: 4
   - Rolling update strategy with `maxUnavailable: 1` and `maxSurge: 2`

2. Update the Deployment image to `nginx:1.25` and record the change

3. Verify the rollout completes successfully

4. Roll back the Deployment to the previous revision

### Solution Approach
```bash
# Create namespace
kubectl create namespace production

# Create deployment
kubectl create deployment webapp --image=nginx:1.23 --replicas=4 -n production --dry-run=client -o yaml > webapp.yaml
# Edit to add strategy, then apply
kubectl apply -f webapp.yaml

# Or set strategy after creation
kubectl patch deployment webapp -n production -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":1,"maxSurge":2}}}}'

# Update image
kubectl set image deployment/webapp nginx=nginx:1.25 -n production

# Check rollout
kubectl rollout status deployment/webapp -n production

# View history
kubectl rollout history deployment/webapp -n production

# Rollback
kubectl rollout undo deployment/webapp -n production

# Verify
kubectl describe deployment webapp -n production | grep Image
```

### Common Mistakes
- Forgetting the namespace flag on every command
- Not knowing the container name for `kubectl set image` (check with `kubectl get deployment -o yaml`)
- Not waiting for rollout to complete before verifying
- Using `kubectl edit` when imperative commands are faster

---

## Scenario 4: Job with Completions and Parallelism

### Context
You are working in the `batch` namespace.

### Task
Create a Job named `data-processor` in the `batch` namespace with:
- Image: `busybox:1.36`
- Command: `sh -c 'echo "Processing batch $JOB_COMPLETION_INDEX" && sleep 10'`
- Completions: 5
- Parallelism: 2
- Backoff limit: 3
- Active deadline: 120 seconds
- Restart policy: Never

### Solution Approach
```bash
kubectl create namespace batch
kubectl create job data-processor --image=busybox:1.36 -n batch --dry-run=client -o yaml > job.yaml
# Edit job.yaml to add completions, parallelism, backoffLimit, activeDeadlineSeconds
# Set the command and restartPolicy
kubectl apply -f job.yaml
kubectl get jobs -n batch -w
kubectl get pods -n batch
```

### Common Mistakes
- Setting `restartPolicy: Always` (Jobs require `Never` or `OnFailure`)
- Putting `completions` and `parallelism` under `template.spec` instead of `spec`
- Forgetting that `activeDeadlineSeconds` goes in the Job spec, not the Pod spec
- Not using `completionMode: Indexed` when referencing `JOB_COMPLETION_INDEX`

---

## Scenario 5: ConfigMap and Secret Consumption

### Context
You are working in the `app-config` namespace.

### Task
1. Create a ConfigMap named `app-settings` with:
   - `DATABASE_HOST=db.app-config.svc.cluster.local`
   - `DATABASE_PORT=5432`
   - `LOG_LEVEL=info`

2. Create a Secret named `app-credentials` with:
   - `DATABASE_USER=appuser`
   - `DATABASE_PASSWORD=s3cur3P@ss`

3. Create a Pod named `config-app` with:
   - Image: `nginx:1.25`
   - All ConfigMap keys loaded as environment variables using `envFrom`
   - All Secret keys loaded as environment variables using `envFrom`
   - The ConfigMap also mounted as a volume at `/etc/config`

### Solution Approach
```bash
kubectl create namespace app-config

# Create ConfigMap
kubectl create configmap app-settings -n app-config \
  --from-literal=DATABASE_HOST=db.app-config.svc.cluster.local \
  --from-literal=DATABASE_PORT=5432 \
  --from-literal=LOG_LEVEL=info

# Create Secret
kubectl create secret generic app-credentials -n app-config \
  --from-literal=DATABASE_USER=appuser \
  --from-literal=DATABASE_PASSWORD='s3cur3P@ss'

# Generate Pod YAML and edit
kubectl run config-app --image=nginx:1.25 -n app-config --dry-run=client -o yaml > config-app.yaml
# Edit to add envFrom (configMapRef and secretRef) and volume mount
kubectl apply -f config-app.yaml

# Verify
kubectl exec config-app -n app-config -- env | grep DATABASE
kubectl exec config-app -n app-config -- ls /etc/config
```

### Common Mistakes
- Confusing `envFrom` with `env` and `valueFrom`
- Forgetting to specify the volume name in both `volumes` and `volumeMounts`
- Not quoting special characters in `--from-literal` values
- Incorrect `configMapRef` vs `configMapKeyRef` syntax

---

## Scenario 6: Network Policy

### Context
You are working in the `secure-app` namespace. There are already Pods running with labels `app: frontend`, `app: backend`, and `app: database`.

### Task
Create a NetworkPolicy named `backend-policy` in the `secure-app` namespace that:
1. Applies to Pods with label `app: backend`
2. Allows **ingress** traffic only from Pods with label `app: frontend` on port 8080
3. Allows **egress** traffic only to Pods with label `app: database` on port 5432
4. Denies all other ingress and egress traffic to/from backend Pods

### Solution Approach
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: database
      ports:
        - protocol: TCP
          port: 5432
```

### Common Mistakes
- Forgetting `policyTypes` - without specifying both Ingress and Egress, only the defined rules apply
- Incorrect indentation of `from`/`to` items (list items under `ingress`/`egress` represent OR logic; items within a single list entry represent AND logic)
- Not including DNS egress (port 53) if the backend needs to resolve service names - this is a real-world concern but may or may not apply in exam tasks
- Confusing `podSelector` at the policy level (which Pods the policy applies to) with `podSelector` in rules (which Pods are allowed)

---

## Scenario 7: Ingress with Path-Based Routing

### Context
You are working in the `web` namespace. Two Services already exist:
- `frontend-svc` on port 80
- `api-svc` on port 8080

An nginx Ingress controller is already installed in the cluster.

### Task
Create an Ingress resource named `web-ingress` in the `web` namespace that:
1. Uses the `nginx` Ingress class
2. Routes traffic for host `myapp.example.com`:
   - Path `/api` (Prefix) routes to `api-svc` on port 8080
   - Path `/` (Prefix) routes to `frontend-svc` on port 80

### Solution Approach
```bash
# Generate a base Ingress or write from scratch
kubectl create ingress web-ingress -n web \
  --class=nginx \
  --rule="myapp.example.com/api*=api-svc:8080" \
  --rule="myapp.example.com/*=frontend-svc:80" \
  --dry-run=client -o yaml > ingress.yaml

# Review and apply
kubectl apply -f ingress.yaml

# Verify
kubectl describe ingress web-ingress -n web
```

### Common Mistakes
- Forgetting `ingressClassName` (or using the annotation instead of the field)
- Wrong `pathType` - `Prefix` vs `Exact` vs `ImplementationSpecific`
- Incorrect port number in `backend.service.port.number`
- Not matching the service name and port to what actually exists

---

## Scenario 8: PersistentVolumeClaim with Pod

### Context
You are working in the `storage` namespace. A StorageClass named `standard` is available.

### Task
1. Create a PersistentVolumeClaim named `data-pvc` in the `storage` namespace:
   - Storage request: 1Gi
   - Access mode: ReadWriteOnce
   - Storage class: standard

2. Create a Pod named `data-pod` that:
   - Image: `nginx:1.25`
   - Mounts the PVC at `/usr/share/nginx/html`
   - Runs as user 1000 and group 1000

### Solution Approach
```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: storage
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 1Gi
---
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
  namespace: storage
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
  containers:
    - name: nginx
      image: nginx:1.25
      volumeMounts:
        - name: data-volume
          mountPath: /usr/share/nginx/html
  volumes:
    - name: data-volume
      persistentVolumeClaim:
        claimName: data-pvc
```

```bash
kubectl apply -f pvc.yaml
kubectl apply -f pod.yaml
kubectl get pvc -n storage
kubectl get pod data-pod -n storage
```

### Common Mistakes
- Forgetting `storageClassName` in the PVC spec
- Mismatching the PVC `claimName` in the Pod volume definition
- Putting `securityContext` inside the container spec instead of the Pod spec (or vice versa - Pod-level for `runAsUser`/`runAsGroup`, container-level for capabilities)
- Using `ReadWriteMany` when the StorageClass only supports `ReadWriteOnce`

---

## Scenario 9: CronJob with History Limits

### Context
You are working in the `monitoring` namespace.

### Task
Create a CronJob named `health-check` in the `monitoring` namespace that:
- Runs every 10 minutes
- Image: `curlimages/curl:8.4.0`
- Command: `curl -s -o /dev/null -w "%{http_code}" http://webapp-svc.monitoring.svc.cluster.local/health`
- Successful Jobs history limit: 3
- Failed Jobs history limit: 1
- Concurrency policy: Forbid
- Restart policy: OnFailure

### Solution Approach
```bash
kubectl create namespace monitoring

kubectl create cronjob health-check -n monitoring \
  --image=curlimages/curl:8.4.0 \
  --schedule="*/10 * * * *" \
  --dry-run=client -o yaml > cronjob.yaml

# Edit cronjob.yaml to add:
# - command
# - successfulJobsHistoryLimit: 3
# - failedJobsHistoryLimit: 1
# - concurrencyPolicy: Forbid
# - restartPolicy: OnFailure (under template.spec.template.spec)

kubectl apply -f cronjob.yaml
kubectl get cronjob -n monitoring
```

### Common Mistakes
- Wrong cron expression syntax (`*/10 * * * *` not `0/10 * * * *`)
- Putting `concurrencyPolicy` in the wrong location (it belongs in `spec`, not `spec.jobTemplate.spec`)
- Forgetting to change `restartPolicy` from `Never` to `OnFailure`
- Incorrect nesting depth for CronJob YAML (spec -> jobTemplate -> spec -> template -> spec -> containers)

---

## Scenario 10: Deployment with SecurityContext and ServiceAccount

### Context
You are working in the `secure` namespace.

### Task
1. Create a ServiceAccount named `app-sa` in the `secure` namespace

2. Create a Deployment named `secure-app` in the `secure` namespace with:
   - Image: `nginx:1.25`
   - Replicas: 2
   - ServiceAccount: `app-sa`
   - Pod-level SecurityContext: `runAsNonRoot: true`, `runAsUser: 1000`, `fsGroup: 2000`
   - Container-level SecurityContext: `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`
   - Resource requests: 64Mi memory, 100m CPU
   - Resource limits: 128Mi memory, 200m CPU
   - Mount an `emptyDir` volume at `/tmp` (since root filesystem is read-only)
   - Mount an `emptyDir` volume at `/var/cache/nginx` (nginx needs this writable)
   - Mount an `emptyDir` volume at `/var/run` (nginx needs this for PID file)

### Solution Approach
```bash
kubectl create namespace secure
kubectl create serviceaccount app-sa -n secure

kubectl create deployment secure-app --image=nginx:1.25 --replicas=2 -n secure --dry-run=client -o yaml > secure-app.yaml

# Edit to add ServiceAccount, SecurityContexts, resources, and volume mounts
kubectl apply -f secure-app.yaml

# Verify
kubectl get deployment secure-app -n secure
kubectl get pods -n secure -l app=secure-app
kubectl describe pod -n secure -l app=secure-app
```

### Common Mistakes
- Forgetting that nginx needs writable directories for cache and PID files when using `readOnlyRootFilesystem`
- Putting `serviceAccountName` in the container spec instead of the Pod spec
- Confusing Pod-level and container-level SecurityContext fields
- Not providing `emptyDir` volumes for directories the application needs to write to
