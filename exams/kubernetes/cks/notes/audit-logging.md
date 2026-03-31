# Audit Logging for CKS

**[📖 Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Kubernetes audit logging documentation

## Audit Logging Overview

Kubernetes audit logging provides a chronological record of calls made to the Kubernetes API server. It records who made the request, what they did, and whether it was allowed or denied. This is essential for security compliance, incident investigation, and threat detection.

### Audit Stages
Each API request passes through several stages:
- **RequestReceived** - Event generated as soon as the audit handler receives the request
- **ResponseStarted** - Response headers sent but body not yet sent (long-running requests only)
- **ResponseComplete** - Response body completed and no more bytes will be sent
- **Panic** - Event generated when a panic occurs

### Audit Levels
- **None** - Do not log this event
- **Metadata** - Log request metadata (user, timestamp, resource, verb) only
- **Request** - Log metadata and request body
- **RequestResponse** - Log metadata, request body, and response body

**Important:** Higher levels generate more data. Use RequestResponse selectively (e.g., for secrets only) to avoid excessive log volume.

## Audit Policy Configuration

**[📖 Audit Policy](https://kubernetes.io/docs/reference/config-api/apiserver-audit.v1/)** - Audit policy API reference

### Policy Structure
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
# omitStages prevents generating events at certain stages
omitStages:
  - "RequestReceived"
rules:
  # Rules are evaluated in order - first match wins
  # Each rule specifies a level and optional filters
```

### Rule Fields
- **level** - Audit level (None, Metadata, Request, RequestResponse)
- **users** - Users to match
- **userGroups** - User groups to match
- **verbs** - API verbs to match (get, list, create, update, delete, watch, patch)
- **resources** - API resources to match (group and resource name)
- **namespaces** - Namespaces to match
- **nonResourceURLs** - Non-resource URLs to match (e.g., /healthz)

### Comprehensive Audit Policy Example

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # ===== EXCLUSIONS (None level) =====

  # Don't log read-only health/readiness endpoints
  - level: None
    nonResourceURLs:
    - "/healthz*"
    - "/readyz*"
    - "/livez*"
    - "/version"

  # Don't log events from system:kube-controller-manager
  # (too noisy for most use cases)
  - level: None
    users:
    - "system:kube-controller-manager"
    verbs: ["get", "list", "watch"]

  # Don't log watch requests (generates massive volume)
  - level: None
    verbs: ["watch"]

  # Don't log get requests to configmaps/endpoints in kube-system
  - level: None
    verbs: ["get"]
    resources:
    - group: ""
      resources: ["configmaps", "endpoints"]
    namespaces: ["kube-system"]

  # ===== HIGH DETAIL (RequestResponse) =====

  # Log all secret operations at maximum detail
  - level: RequestResponse
    resources:
    - group: ""
      resources: ["secrets"]

  # Log all RBAC changes at maximum detail
  - level: RequestResponse
    resources:
    - group: "rbac.authorization.k8s.io"
      resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]

  # ===== MEDIUM DETAIL (Request) =====

  # Log write operations at Request level
  - level: Request
    verbs: ["create", "update", "patch", "delete", "deletecollection"]

  # ===== LOW DETAIL (Metadata) =====

  # Log everything else at Metadata level
  - level: Metadata
```

## Enabling Audit Logging

### API Server Configuration

Add to `/etc/kubernetes/manifests/kube-apiserver.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    # ... existing flags ...
    # Audit logging flags
    - --audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
    - --audit-log-maxage=30       # Days to retain old log files
    - --audit-log-maxbackup=10    # Max number of log files to retain
    - --audit-log-maxsize=100     # Max size in MB before rotation
    volumeMounts:
    # ... existing mounts ...
    - mountPath: /etc/kubernetes/audit
      name: audit-policy
      readOnly: true
    - mountPath: /var/log/kubernetes/audit
      name: audit-logs
  volumes:
  # ... existing volumes ...
  - hostPath:
      path: /etc/kubernetes/audit
      type: DirectoryOrCreate
    name: audit-policy
  - hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
    name: audit-logs
```

### Webhook Backend (Alternative)

For streaming audit events to an external system:
```yaml
# In API server flags
- --audit-webhook-config-file=/etc/kubernetes/audit/webhook-config.yaml
- --audit-webhook-initial-backoff=5s
```

```yaml
# webhook-config.yaml
apiVersion: v1
kind: Config
clusters:
- name: audit-webhook
  cluster:
    server: https://audit-collector.security.svc:443
    certificate-authority: /etc/kubernetes/audit/ca.crt
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/audit/client.crt
    client-key: /etc/kubernetes/audit/client.key
contexts:
- context:
    cluster: audit-webhook
    user: api-server
  name: default
current-context: default
```

## Analyzing Audit Logs

### Audit Log Entry Structure

```json
{
  "kind": "Event",
  "apiVersion": "audit.k8s.io/v1",
  "level": "RequestResponse",
  "auditID": "unique-id",
  "stage": "ResponseComplete",
  "requestURI": "/api/v1/namespaces/default/secrets/db-password",
  "verb": "get",
  "user": {
    "username": "system:serviceaccount:default:suspicious-sa",
    "uid": "uid-123",
    "groups": ["system:serviceaccounts", "system:authenticated"]
  },
  "sourceIPs": ["10.0.1.5"],
  "objectRef": {
    "resource": "secrets",
    "namespace": "default",
    "name": "db-password",
    "apiVersion": "v1"
  },
  "responseStatus": {
    "metadata": {},
    "code": 200
  },
  "requestReceivedTimestamp": "2024-01-15T10:30:00.000000Z",
  "stageTimestamp": "2024-01-15T10:30:00.001000Z"
}
```

### Common Analysis Queries

```bash
# All secret access events
cat audit.log | jq 'select(.objectRef.resource=="secrets")'

# Failed requests (403 Forbidden)
cat audit.log | jq 'select(.responseStatus.code==403)'

# All requests from a specific service account
cat audit.log | jq 'select(.user.username=="system:serviceaccount:default:my-sa")'

# All create/delete operations
cat audit.log | jq 'select(.verb=="create" or .verb=="delete")'

# Requests from specific source IP
cat audit.log | jq 'select(.sourceIPs[] | contains("10.0.1.5"))'

# RBAC changes
cat audit.log | jq 'select(.objectRef.resource | test("role|rolebinding|clusterrole|clusterrolebinding"))'

# Timeline of events for investigation
cat audit.log | jq '{time: .requestReceivedTimestamp, user: .user.username, verb: .verb, resource: .objectRef.resource, name: .objectRef.name, ns: .objectRef.namespace, code: .responseStatus.code}'
```

## Security Investigation with Audit Logs

### Common Investigation Scenarios

#### Scenario: Unauthorized Secret Access
1. Filter audit logs for secret access events
2. Identify which service accounts or users accessed secrets
3. Check if access was from expected source IPs
4. Correlate with RBAC bindings to verify authorization
5. Check for abnormal access patterns (unusual times, high frequency)

#### Scenario: Privilege Escalation
1. Look for RBAC creation/modification events
2. Check for ClusterRoleBinding to cluster-admin
3. Identify who made the changes and from where
4. Review the timeline of events
5. Check if the user had permissions to make those changes

#### Scenario: Resource Deletion
1. Filter for delete verbs on critical resources
2. Identify the user and source IP
3. Check if deletion was authorized
4. Review preceding events for context
5. Check for patterns suggesting automated attacks

### Compliance Requirements
- **PCI DSS** - Requires logging of all access to cardholder data
- **SOC 2** - Requires audit trails for system access
- **HIPAA** - Requires logging of access to protected health information
- **GDPR** - Requires tracking of personal data access

## Best Practices

### Policy Design
1. Start with a catch-all Metadata rule at the bottom
2. Add specific high-detail rules for sensitive resources (secrets, RBAC)
3. Exclude noisy but low-value events (health checks, watches, system components)
4. Use omitStages to skip RequestReceived (adds noise without value)
5. Test policies in audit mode before enforcing

### Log Management
1. Set appropriate rotation settings (maxage, maxbackup, maxsize)
2. Ship logs to a centralized logging system (EFK stack, Splunk, etc.)
3. Set up alerts for suspicious patterns
4. Protect audit log files from tampering
5. Retain logs according to compliance requirements

### Performance Considerations
- RequestResponse level for all resources generates massive log volume
- Watch events are very noisy - usually safe to exclude
- System component read operations add noise but little security value
- Log rotation prevents disk space exhaustion

## Key Takeaways

1. **Rule order matters** - First matching rule applies; put exclusions first
2. **Selective detail** - Use RequestResponse for secrets and RBAC; Metadata for everything else
3. **Volume mounts** - Always add both volume and volumeMount to the API server manifest
4. **Log rotation** - Configure maxage, maxbackup, and maxsize to prevent disk issues
5. **Investigation skills** - Know how to filter and analyze audit logs with jq
6. **Compliance** - Audit logging is required for most security compliance frameworks
7. **Verification** - After enabling, check that the log file is being written and contains events
