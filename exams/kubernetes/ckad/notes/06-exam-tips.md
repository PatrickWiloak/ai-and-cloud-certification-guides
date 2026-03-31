# CKAD Exam Tips and kubectl Speed Tricks

## Exam Environment Setup

### First Thing: Set Up Your Shell

Run these commands at the very start of your exam:

```bash
# Essential aliases
alias k=kubectl
alias kn='kubectl config set-context --current --namespace'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'

# Shorthand for dry-run YAML generation
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Verify
k version --client
```

### Configure vim for YAML editing

```bash
cat >> ~/.vimrc << 'EOF'
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set number
EOF
```

### Enable kubectl autocompletion (usually already enabled)

```bash
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
```

---

## Imperative Command Reference

### Pods

```bash
# Create a Pod
k run nginx --image=nginx:1.25
k run nginx --image=nginx:1.25 --port=80
k run nginx --image=nginx:1.25 --labels="app=web,tier=frontend"
k run nginx --image=nginx:1.25 --env="DB_HOST=db" --env="DB_PORT=5432"
k run nginx --image=nginx:1.25 --requests="cpu=100m,memory=64Mi" --limits="cpu=200m,memory=128Mi"

# Generate YAML
k run nginx --image=nginx:1.25 $do > pod.yaml

# Run a temporary Pod for testing
k run test --image=busybox:1.36 --rm -it -- /bin/sh
k run test --image=busybox:1.36 --rm -it -- wget -qO- http://my-svc:80
k run test --image=busybox:1.36 --rm -it -- nslookup my-svc

# Delete a Pod quickly
k delete pod nginx $now
```

### Deployments

```bash
# Create
k create deploy nginx --image=nginx:1.25 --replicas=3
k create deploy nginx --image=nginx:1.25 --port=80

# Generate YAML
k create deploy nginx --image=nginx:1.25 --replicas=3 $do > deploy.yaml

# Scale
k scale deploy nginx --replicas=5

# Update image
k set image deploy/nginx nginx=nginx:1.26

# Rollout management
k rollout status deploy/nginx
k rollout history deploy/nginx
k rollout undo deploy/nginx
k rollout undo deploy/nginx --to-revision=2
k rollout restart deploy/nginx
```

### Services

```bash
# Expose a Deployment
k expose deploy nginx --port=80 --target-port=8080 --type=ClusterIP
k expose deploy nginx --port=80 --target-port=8080 --type=NodePort
k expose deploy nginx --port=80 --target-port=8080 --type=NodePort --name=nginx-svc

# Expose a Pod
k expose pod nginx --port=80 --target-port=80 --name=nginx-svc

# Generate YAML
k expose deploy nginx --port=80 --target-port=8080 $do > svc.yaml
```

### ConfigMaps

```bash
# From literals
k create cm my-config --from-literal=key1=value1 --from-literal=key2=value2

# From file
k create cm my-config --from-file=config.txt
k create cm my-config --from-file=mykey=config.txt    # Custom key name

# From env file
k create cm my-config --from-env-file=config.env

# Generate YAML
k create cm my-config --from-literal=key=value $do > cm.yaml
```

### Secrets

```bash
# Generic
k create secret generic my-secret --from-literal=user=admin --from-literal=pass=secret

# Docker registry
k create secret docker-registry my-reg --docker-server=reg.io --docker-username=user --docker-password=pass

# TLS
k create secret tls my-tls --cert=cert.pem --key=key.pem

# Generate YAML
k create secret generic my-secret --from-literal=key=value $do > secret.yaml
```

### Jobs and CronJobs

```bash
# Job
k create job my-job --image=busybox:1.36 -- echo "Hello"
k create job my-job --image=busybox:1.36 $do > job.yaml -- echo "Hello"

# CronJob
k create cj my-cron --image=busybox:1.36 --schedule="*/5 * * * *" -- echo "Hello"
k create cj my-cron --image=busybox:1.36 --schedule="*/5 * * * *" $do > cron.yaml -- echo "Hello"
```

### Ingress

```bash
# Create Ingress
k create ingress myingress --class=nginx --rule="host.com/path*=svc:80"

# Multiple rules
k create ingress myingress --class=nginx \
  --rule="host.com/api*=api-svc:8080" \
  --rule="host.com/*=web-svc:80"

# Generate YAML
k create ingress myingress --class=nginx --rule="host.com/*=svc:80" $do > ingress.yaml
```

### Other Resources

```bash
# Namespace
k create ns my-namespace

# ServiceAccount
k create sa my-sa -n my-namespace

# Role
k create role pod-reader --verb=get,list,watch --resource=pods -n my-namespace

# RoleBinding
k create rolebinding pod-reader-binding --role=pod-reader --serviceaccount=my-namespace:my-sa -n my-namespace

# ResourceQuota
k create quota my-quota --hard=pods=10,requests.cpu=4,requests.memory=8Gi -n my-namespace
```

---

## YAML Generation and Editing Tricks

### Generate, Edit, Apply Workflow

This is the fastest approach for creating resources that need customization:

```bash
# 1. Generate the base YAML
k run myapp --image=nginx:1.25 $do > myapp.yaml

# 2. Edit to add what you need (probes, volumes, etc.)
vim myapp.yaml

# 3. Apply
k apply -f myapp.yaml

# 4. Verify
k get pod myapp
k describe pod myapp
```

### Quick YAML Snippets to Memorize

**Resource requests and limits:**
```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 200m
    memory: 256Mi
```

**Liveness probe (HTTP):**
```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```

**Readiness probe (TCP):**
```yaml
readinessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 5
  periodSeconds: 10
```

**Volume mount (emptyDir):**
```yaml
# In containers:
volumeMounts:
  - name: data
    mountPath: /data
# In spec:
volumes:
  - name: data
    emptyDir: {}
```

**ConfigMap as env:**
```yaml
envFrom:
  - configMapRef:
      name: my-config
```

**Secret as env:**
```yaml
envFrom:
  - secretRef:
      name: my-secret
```

**SecurityContext (container):**
```yaml
securityContext:
  runAsUser: 1000
  runAsNonRoot: true
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

---

## vim Tips for the Exam

### Essential vim Commands

```
i           Enter insert mode
Esc         Exit insert mode
:w          Save
:q          Quit
:wq         Save and quit
:q!         Quit without saving

dd          Delete current line
5dd         Delete 5 lines
yy          Copy current line
5yy         Copy 5 lines
p           Paste below
P           Paste above

gg          Go to top of file
G           Go to bottom of file
:10         Go to line 10

/pattern    Search forward
?pattern    Search backward
n           Next match
N           Previous match

u           Undo
Ctrl+r      Redo

v           Visual mode (select text)
V           Visual line mode
d           Delete selection (in visual mode)
y           Copy selection (in visual mode)

>>          Indent line
<<          Unindent line
5>>         Indent 5 lines

:%s/old/new/g    Replace all occurrences in file
```

### YAML-Specific vim Tricks

```
# Select and indent a block
V           (visual line mode)
j/k         (select lines)
>           (indent) or < (unindent)

# Duplicate a section
V           (visual line mode)
j/k         (select the block)
y           (yank/copy)
p           (paste below cursor)
```

---

## Time Management

### Strategy
1. **Read the task completely** before starting (30 seconds)
2. **Check context and namespace** - run the provided context command
3. **Start with imperative commands** - fastest approach
4. **Use `$do` to generate YAML** when you need to add custom fields
5. **Verify your work** - `kubectl get`, `kubectl describe`
6. **Move on** if a task takes more than 8 minutes

### Task Priority
- **Do first:** Tasks you know well (quick wins, bank points)
- **Do second:** Tasks that need some YAML editing but are straightforward
- **Do last:** Complex tasks or topics you are less confident in
- **Always attempt:** Even partial solutions may earn points

### Time Allocation (2 hours, ~15-20 tasks)
- First 80 minutes: Work through all tasks in order, skip hard ones
- Next 30 minutes: Return to skipped tasks
- Final 10 minutes: Verify completed work, attempt remaining tasks

---

## Common Gotchas

### Context and Namespace
- **Every task may use a different cluster context** - always run the provided `kubectl config use-context` command
- **Always check the namespace** - use `-n <namespace>` or set it with `kn <namespace>`
- **Forgetting the namespace** is the most common mistake on the exam

### YAML Issues
- **Indentation matters** - use 2 spaces, never tabs
- **Labels must match** - `spec.selector.matchLabels` must match `spec.template.metadata.labels` in Deployments
- **Name conflicts** - check if a resource with the same name already exists: `k get <resource> <name> -n <namespace>`

### Resource-Specific Gotchas
- **Jobs:** `restartPolicy` must be `Never` or `OnFailure`, not `Always`
- **CronJobs:** The `concurrencyPolicy` goes in `spec`, not in `spec.jobTemplate.spec`
- **NetworkPolicies:** Once any policy selects a Pod, all unmatched traffic is denied
- **Secrets:** `kubectl create secret` handles base64 encoding for you; in YAML manifests, `data` must be base64-encoded (use `stringData` for plain text)
- **Probes:** Without a `startupProbe`, the `livenessProbe` can kill slow-starting containers
- **Services:** `targetPort` is the container port, `port` is the Service port - do not confuse them
- **Ingress:** Requires an Ingress controller - the Ingress resource alone does nothing

### Exam Environment Gotchas
- Copy-paste may work differently in the PSI browser (right-click menu)
- The terminal may have limited screen real estate - use short aliases
- File paths in tasks are usually absolute - pay attention to where files should be created
- Some clusters may have different configurations - do not assume anything carries over between tasks
