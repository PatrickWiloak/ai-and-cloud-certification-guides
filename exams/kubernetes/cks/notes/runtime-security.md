# Runtime Security for CKS

**[📖 Kubernetes Security Overview](https://kubernetes.io/docs/concepts/security/overview/)** - Cloud native security and the 4C's model

## Falco Runtime Security

**[📖 Falco Documentation](https://falco.org/docs/)** - Cloud-native runtime security project
**[📖 Falco Rules](https://falco.org/docs/rules/)** - Rule syntax and management

### What is Falco?
Falco is a cloud-native runtime security tool that detects unexpected application behavior and alerts on threats at runtime. It monitors system calls using eBPF or a kernel module and matches them against a set of security rules.

### Falco Architecture
- **Kernel Module or eBPF probe** - Captures system calls from the kernel
- **Libraries** - Filters and processes system call events
- **Rules Engine** - Matches events against security rules
- **Alert Outputs** - Sends alerts to stdout, files, syslog, HTTP endpoints, gRPC

### Falco Rule Structure

```yaml
- rule: Terminal Shell in Container
  desc: A shell was used as the entrypoint/exec in a container
  condition: >
    spawned_process and container and
    shell_procs and proc.tty != 0 and
    container_entrypoint
  output: >
    A shell was spawned in a container with an attached terminal
    (user=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline
    terminal=%proc.tty container_id=%container.id
    image=%container.image.repository)
  priority: NOTICE
  tags: [container, shell, mitre_execution]
```

### Rule Components
- **rule** - The name of the rule
- **desc** - Description of what the rule detects
- **condition** - The filter expression using Falco fields (system call data)
- **output** - The alert message format with field substitutions
- **priority** - Severity level (EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG)
- **tags** - Categorization tags for the rule

### Common Falco Macros and Lists

**Macros** (reusable condition snippets):
- `container` - Event is inside a container
- `spawned_process` - A new process was created
- `open_read` - A file was opened for reading
- `open_write` - A file was opened for writing
- `shell_procs` - Process is a shell (bash, sh, zsh, etc.)

**Lists** (reusable value arrays):
- `shell_binaries` - bash, sh, zsh, csh, dash
- `sensitive_file_names` - /etc/shadow, /etc/sudoers, etc.

### Custom Falco Rules for CKS

**Detect shell spawning in containers:**
```yaml
- rule: Shell in Container
  desc: Detect shell spawned inside a container
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, dash, csh)
  output: >
    Shell spawned in container (user=%user.name
    container=%container.name image=%container.image.repository
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline
    pid=%proc.pid)
  priority: WARNING
  tags: [container, shell]
```

**Detect sensitive file reads:**
```yaml
- rule: Read Sensitive File in Container
  desc: Detect reading of sensitive files inside containers
  condition: >
    open_read and container and
    fd.name in (/etc/shadow, /etc/sudoers, /etc/pam.d)
  output: >
    Sensitive file opened (user=%user.name file=%fd.name
    container=%container.name image=%container.image.repository)
  priority: WARNING
  tags: [container, filesystem, sensitive_data]
```

**Detect writing to /etc directory:**
```yaml
- rule: Write to etc in Container
  desc: Detect file writes to /etc inside containers
  condition: >
    open_write and container and
    fd.name startswith /etc
  output: >
    File written to /etc (user=%user.name file=%fd.name
    container=%container.name image=%container.image.repository)
  priority: ERROR
  tags: [container, filesystem]
```

### Falco Configuration

**[📖 Falco Configuration](https://falco.org/docs/configuration/)** - Configuration options

```yaml
# /etc/falco/falco.yaml (key settings)
rules_file:
  - /etc/falco/falco_rules.yaml
  - /etc/falco/falco_rules.local.yaml  # Custom rules go here
  - /etc/falco/rules.d                 # Additional rules directory

json_output: true                       # JSON format for log parsing
log_stderr: true
log_syslog: true
log_level: info

stdout_output:
  enabled: true

file_output:
  enabled: true
  filename: /var/log/falco/events.log
```

## Kubernetes Audit Logging

**[📖 Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Kubernetes audit logging documentation
**[📖 Audit Policy](https://kubernetes.io/docs/reference/config-api/apiserver-audit.v1/)** - Audit policy API reference

### Audit Levels
- **None** - Do not log events matching this rule
- **Metadata** - Log request metadata (user, timestamp, resource, verb) but not body
- **Request** - Log metadata and request body, but not response body
- **RequestResponse** - Log metadata, request body, and response body

### Audit Policy Structure

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # Rule order matters - first match wins

  # Don't log health checks and API discovery
  - level: None
    nonResourceURLs:
    - "/healthz*"
    - "/readyz*"
    - "/livez*"
    - "/api*"

  # Don't log watch requests (too noisy)
  - level: None
    verbs: ["watch"]

  # Log secret operations at maximum detail
  - level: RequestResponse
    resources:
    - group: ""
      resources: ["secrets"]

  # Log RBAC changes at Request level
  - level: Request
    resources:
    - group: "rbac.authorization.k8s.io"
      resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]

  # Log pod creation/deletion at Request level
  - level: Request
    verbs: ["create", "delete"]
    resources:
    - group: ""
      resources: ["pods"]

  # Log everything else at Metadata level
  - level: Metadata
```

### Enabling Audit Logging on API Server

Add to the API server manifest (`/etc/kubernetes/manifests/kube-apiserver.yaml`):
```yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
    - --audit-log-maxage=30
    - --audit-log-maxbackup=10
    - --audit-log-maxsize=100
    volumeMounts:
    - mountPath: /etc/kubernetes/audit
      name: audit-policy
      readOnly: true
    - mountPath: /var/log/kubernetes/audit
      name: audit-log
  volumes:
  - hostPath:
      path: /etc/kubernetes/audit
      type: DirectoryOrCreate
    name: audit-policy
  - hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
    name: audit-log
```

### Analyzing Audit Logs

```bash
# View recent audit events
tail -f /var/log/kubernetes/audit/audit.log | jq .

# Filter for secret access
cat /var/log/kubernetes/audit/audit.log | jq 'select(.objectRef.resource=="secrets")'

# Filter for specific user
cat /var/log/kubernetes/audit/audit.log | jq 'select(.user.username=="system:serviceaccount:default:suspicious-sa")'

# Filter for failed requests
cat /var/log/kubernetes/audit/audit.log | jq 'select(.responseStatus.code >= 400)'
```

## Container Immutability

### Read-Only Root Filesystem

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: immutable-pod
spec:
  containers:
  - name: app
    image: myapp:v1.0
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: var-run
      mountPath: /var/run
  volumes:
  - name: tmp
    emptyDir: {}
  - name: var-run
    emptyDir:
      medium: Memory  # tmpfs - stored in memory
```

### Why Immutability Matters
- Prevents attackers from modifying binaries or installing tools after compromise
- Detects unauthorized changes through filesystem errors
- Forces infrastructure-as-code practices
- Reduces the blast radius of container compromises

### Implementing Immutability
1. Set `readOnlyRootFilesystem: true` in security context
2. Mount `emptyDir` volumes for directories that need writes (tmp, cache, logs)
3. Use `emptyDir.medium: Memory` for sensitive temporary data
4. Avoid writable volumes mounted from the host
5. Use immutable ConfigMaps and Secrets when possible

## Threat Detection Patterns

### Attack Lifecycle in Kubernetes
1. **Initial Access** - Compromised container image, exposed API server, vulnerable application
2. **Execution** - Shell spawning, script execution, binary download
3. **Persistence** - New pods/deployments, modified RBAC, cronjobs
4. **Privilege Escalation** - Privileged containers, hostPID, token theft
5. **Defense Evasion** - Log deletion, pod deletion, timestamp manipulation
6. **Credential Access** - Secret reading, service account token theft
7. **Discovery** - API server enumeration, network scanning
8. **Lateral Movement** - Pod-to-pod exploitation, service account abuse
9. **Impact** - Crypto mining, data exfiltration, denial of service

### Detection Strategies
- **Falco rules** for real-time syscall monitoring
- **Audit logs** for API-level activity tracking
- **NetworkPolicies** to detect (via denied connections) lateral movement attempts
- **Resource monitoring** for unexpected CPU/memory usage (crypto mining)
- **File integrity monitoring** for unauthorized changes

## Forensic Investigation

### Investigating a Compromised Container
```bash
# Check running processes
kubectl exec suspicious-pod -- ps aux

# Check network connections
kubectl exec suspicious-pod -- netstat -tlnp

# Check file system changes
kubectl exec suspicious-pod -- find / -newer /etc/hostname -type f 2>/dev/null

# Copy files from container for analysis
kubectl cp suspicious-pod:/var/log/suspicious.log ./evidence/

# Check container events
kubectl describe pod suspicious-pod | grep -A 20 Events

# Review container logs
kubectl logs suspicious-pod --previous
```

### Containment Steps
1. Isolate the pod with a deny-all NetworkPolicy
2. Capture evidence (logs, filesystem state, network connections)
3. Do not delete the pod immediately - preserve for forensics
4. Check if the compromise has spread to other pods
5. Review audit logs for the compromised pod's service account activity
6. Rotate any credentials the compromised pod had access to

## Key Takeaways

1. **Falco** - Primary runtime detection tool; know rule syntax, macros, and common detection patterns
2. **Audit Logging** - Configure with ordered rules; first match wins; always exclude health checks
3. **Immutability** - Use readOnlyRootFilesystem and emptyDir for writable directories
4. **Defense in Depth** - Combine Falco, audit logs, NetworkPolicies, and monitoring
5. **Investigation** - Know how to examine a compromised container and preserve evidence
6. **Volume Mounts** - Remember to add both volumes and volumeMounts when configuring audit logging on the API server
