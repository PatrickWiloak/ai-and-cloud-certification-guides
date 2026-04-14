# Session Recording, Audit, and Operations

This note covers the observability, compliance, and operational aspects of Boundary. Session recording is an Enterprise/HCP-Plus feature; audit logging is available across editions.

## Session Recording

Session recording captures the full I/O of SSH sessions for later replay. Used for compliance (SOX, HIPAA, PCI), forensics, and training review.

**Availability:** Enterprise and HCP Plus only.

**Supported protocols:** SSH only at present. TCP target recording is on the roadmap but not generally available.

### Components

- **Storage Bucket (`sb_`):** points Boundary at an S3 (or compatible) bucket to store recordings
- **BSR format:** Boundary Session Recording file format; bundles session metadata and the I/O stream
- **Recording-capable Worker:** workers serving recorded sessions stream to the storage bucket
- **Target with recording enabled:** turns it on per-target

### Setup

1. Create the S3 bucket (ideally versioned, server-side encrypted, with lifecycle policy)
2. Grant IAM access to the worker (or use key credentials)
3. Create the storage bucket in Boundary:

```
boundary storage-buckets create aws \
  -scope-id=global \
  -plugin-name=aws \
  -bucket-name=boundary-sessions-prod \
  -attr region=us-east-1 \
  -worker-filter='"true" in "/tags/recording"' \
  -secret access_key_id=... \
  -secret secret_access_key=...
```

4. Enable on the target:

```
boundary targets update ssh \
  -id=tssh_... \
  -enable-session-recording=true \
  -storage-bucket-id=sb_...
```

### Recording Lifecycle

1. User initiates `boundary connect ssh -target-id=tssh_...`
2. Worker establishes SSH, begins recording I/O to local staging dir
3. On session end, worker uploads BSR file to the storage bucket
4. Controller tracks the recording metadata
5. Admins replay via Boundary Desktop or CLI

### Replaying

CLI:

```
boundary session-recordings list
boundary session-recordings read -id=sr_...
boundary session-recordings download -id=sr_...
```

Desktop: navigate to Recordings, pick one, replay with typing animation.

### Retention

Set lifecycle on the S3 bucket or use `delete_after_duration` on the storage bucket resource. Typical retention: 90 days to 7 years depending on compliance.

### Security of Recordings

- S3 bucket encrypted with KMS (separate key from Boundary root)
- Access restricted via IAM; Boundary workers write, humans read rarely
- Audit every replay (CloudTrail on the bucket)

## Audit Logs

Boundary emits structured event logs. Three event types:

### Audit Events

Record authentication, authorization, and resource lifecycle events.

```json
{
  "event_type": "audit",
  "request": { "method": "POST", "endpoint": "/v1/auth-methods" },
  "auth_token": { "user_id": "u_..." },
  "response": { "status_code": 200 }
}
```

### Observation Events

Session lifecycle, worker connections, etc.

### Error Events

Failures with stack traces.

## Configuring Event Sinks

```hcl
events {
  audit_enabled       = true
  sysevents_enabled   = true
  observations_enabled = true

  sink "stderr" {
    name = "all-events"
    description = "All events to stderr"
    event_types = ["*"]
    format = "cloudevents-json"
  }

  sink "file" {
    type = "file"
    name = "audit-file"
    description = "Audit events"
    event_types = ["audit"]
    format = "cloudevents-json"
    file {
      path = "/var/log/boundary"
      file_name = "audit.log"
      rotate_duration = "24h"
    }
  }

  sink "syslog" {
    type = "syslog"
    name = "syslog-all"
    event_types = ["*"]
    format = "cloudevents-json"
    syslog {
      facility = "AUTH"
    }
  }
}
```

Forward to SIEM (Splunk, Elastic, Datadog, CloudWatch) via filebeat, fluentd, or syslog collectors.

## CloudEvents Format

Boundary events follow the CNCF CloudEvents spec:

```json
{
  "specversion": "1.0",
  "type": "audit",
  "source": "https://hashicorp.com/boundary/controller-1",
  "id": "uuid",
  "time": "2026-04-14T12:00:00Z",
  "datacontenttype": "application/json",
  "data": { /* event body */ }
}
```

Standardizes parsing for downstream tools.

## Metrics

The `ops` listener exposes Prometheus metrics at `/metrics`:

- `boundary_controller_api_http_request_duration_seconds`
- `boundary_controller_cluster_grpc_request_duration_seconds`
- `boundary_worker_proxy_http_request_duration_seconds`
- `boundary_controller_db_queries_total`
- Session-related counters

Scrape every 15 seconds. Build dashboards showing:

- Auth success vs failure rate
- Session count over time
- Session duration distribution
- Worker connectivity

Alert on:

- Auth failure spikes (brute-force attempt)
- Sudden drops in worker count (network or crash)
- DB query latency p99 > threshold

## Health Endpoint

`GET /health` on the ops listener returns 200 when healthy. Use for load balancer health checks and liveness probes.

```
curl -k https://boundary.example.com:9203/health
```

Returns:
- 200 OK when fully operational
- 503 Service Unavailable during startup or shutdown

## Common Operational Tasks

### Upgrading

1. Back up Postgres
2. Check release notes for migrations
3. Upgrade one controller, run `boundary database migrate` if required
4. Verify with one controller running; rotate the rest
5. Upgrade workers last; they are backward-compatible

### Rotating KMS Keys

1. Add a new KMS key with a new purpose alias
2. Run `boundary database rotate-root-key` (where applicable)
3. Decommission old key after verification

Worker-auth keys rotate by issuing new PKI certs.

### Scaling Workers

Workers are stateless. Scale by:

- Adding more VMs
- Autoscaling group based on session count
- Deploying per-region to minimize latency

### Database Maintenance

- Vacuum regularly (auto-vacuum usually sufficient)
- Monitor connection pool utilization
- Backup hourly or daily

### Forgotten Admin Password

Use recovery KMS to reset:

```
export BOUNDARY_RECOVERY_CONFIG=/path/recovery.hcl
boundary users list -scope-id=global
# find admin user, reset password via account update
```

### Session Stuck in Canceling

If a worker crashes mid-session, sessions may get stuck. Force-cancel:

```
boundary sessions cancel -id=s_...
```

If the worker doesn't recover, admin can force-terminate via controller API.

## Compliance Features

- **Session recording:** for regulated access audit
- **Audit logs:** for compliance reporting (SOX, PCI, HIPAA)
- **Immutable logs:** forward to WORM storage (S3 Object Lock) if required
- **Separation of duties:** distinct roles for admin, auditor, user
- **Break-glass access logging:** recovery KMS usage logged in cloud audit (CloudTrail)

## Desktop App for Operations

Boundary Desktop shows:

- Sessions list with filters
- Target browser
- Credentials inspector (for brokered)
- Replay view for recorded sessions

Good for operators without CLI comfort.

## Cost Controls

- Set short session TTLs to limit compute on long-running workers
- Monitor storage-bucket size (recordings can grow large)
- Use S3 intelligent tiering or lifecycle to move old recordings to Glacier
- Scale down workers during off-hours if session load is time-bound

## Troubleshooting Cheatsheet

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Clients can't auth | DB or KMS issue | Check controller logs, Postgres connectivity |
| Workers disconnected | Network ACL or certs expired | Check worker logs, regenerate PKI |
| Sessions fail to start | No eligible worker matches filter | Relax worker-filter or add matching worker tags |
| Credentials missing | Vault token expired | Rotate Vault token, recheck policy |
| Recordings not appearing | Storage bucket misconfigured | Check IAM, worker `recording` tag |

## Exam-Ready Checklist

- [ ] Know session recording is Enterprise/HCP-Plus only
- [ ] Can describe BSR and storage bucket flow
- [ ] Understand event types: audit, observation, error, system
- [ ] Can configure event sinks in HCL
- [ ] Know the Prometheus metrics endpoint
- [ ] Understand recovery KMS use cases
- [ ] Know key ops tasks: upgrade, scale, troubleshoot stuck sessions
