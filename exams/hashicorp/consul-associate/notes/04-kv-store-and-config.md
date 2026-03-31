# KV Store and Configuration

**[📖 KV Store](https://developer.hashicorp.com/consul/docs/dynamic-app-config/kv)** - KV documentation
**[📖 Watches](https://developer.hashicorp.com/consul/docs/dynamic-app-config/watches)** - Watch documentation

## Overview

This document covers the Consul Key/Value store, watches, consul-template, and transactions. The KV store is 10% of the exam and is commonly used for application configuration management and feature flags.

## KV Store Operations

### CLI Operations
```bash
# Write a value
consul kv put config/db/host "db.example.com"
consul kv put config/db/port "5432"
consul kv put config/app/feature-flag "true"

# Write from file
consul kv put config/app/settings @settings.json

# Write from stdin
echo "production" | consul kv put config/app/environment -

# Read a value
consul kv get config/db/host
# Output: db.example.com

# Read with metadata
consul kv get -detailed config/db/host
# Output includes: CreateIndex, ModifyIndex, LockIndex, Flags, Session

# List all keys under prefix
consul kv get -recurse config/
# Output:
# config/app/environment:production
# config/app/feature-flag:true
# config/db/host:db.example.com
# config/db/port:5432

# List only keys (no values)
consul kv get -keys config/

# Delete a key
consul kv delete config/db/host

# Delete all keys under prefix
consul kv delete -recurse config/db/

# Export KV tree (JSON format)
consul kv export config/ > backup.json

# Import KV tree
consul kv import @backup.json
```

### HTTP API Operations
```bash
# Write (PUT)
curl -X PUT -d 'db.example.com' \
  http://localhost:8500/v1/kv/config/db/host

# Read (GET) - returns base64-encoded value
curl http://localhost:8500/v1/kv/config/db/host
# Response: [{"Value":"ZGIuZXhhbXBsZS5jb20=", ...}]

# Read raw value
curl http://localhost:8500/v1/kv/config/db/host?raw

# List keys
curl http://localhost:8500/v1/kv/config/?keys

# Recurse (all keys and values under prefix)
curl http://localhost:8500/v1/kv/config/?recurse

# Delete
curl -X DELETE http://localhost:8500/v1/kv/config/db/host

# Check-and-Set (CAS) - atomic update
curl -X PUT -d 'newvalue' \
  http://localhost:8500/v1/kv/config/db/host?cas=42
# Only succeeds if current ModifyIndex == 42
```

**[📖 KV API](https://developer.hashicorp.com/consul/api-docs/kv)** - KV API reference

### KV Properties
- Maximum value size: 512 KB per key
- Keys are hierarchical (path-based, separated by `/`)
- Values are opaque bytes (Consul does not interpret them)
- Each key has metadata: CreateIndex, ModifyIndex, LockIndex, Flags
- Replicated across all servers via Raft consensus

## Watches

### Overview
- Mechanism to monitor Consul data for changes
- Executes a handler when data changes
- Uses blocking queries internally (efficient, no polling)
- Can be configured in agent config or via CLI

### Watch Types
| Type | Monitors | Handler Input |
|------|---------|---------------|
| key | Single KV key | Key value and metadata |
| keyprefix | All keys under prefix | List of key/value pairs |
| services | Service catalog | List of service names |
| service | Instances of a service | Service instances with health |
| nodes | Node catalog | List of nodes |
| checks | Health checks | Check results |
| event | Custom user events | Event data |

### CLI Watches
```bash
# Watch a single key
consul watch -type=key -key=config/db/host ./handle-change.sh

# Watch a key prefix
consul watch -type=keyprefix -prefix=config/ ./handle-config.sh

# Watch a service
consul watch -type=service -service=web ./handle-service.sh

# Watch for service catalog changes
consul watch -type=services ./handle-catalog.sh
```

### Agent Config Watches
```json
{
  "watches": [
    {
      "type": "key",
      "key": "config/db/host",
      "handler_type": "script",
      "args": ["/usr/local/bin/handle-db-change.sh"]
    },
    {
      "type": "service",
      "service": "web",
      "handler_type": "http",
      "http_handler_config": {
        "path": "http://localhost:9000/consul-watch",
        "method": "POST"
      }
    }
  ]
}
```

**[📖 Watch Types](https://developer.hashicorp.com/consul/docs/dynamic-app-config/watches)** - Watch reference

### Handler Behavior
- Script handlers receive changed data on stdin (JSON)
- HTTP handlers receive POST request with changed data in body
- Handler executed every time watched data changes
- Handler exit code: 0 = success, non-zero = logged as error

## consul-template

### Overview
- Standalone tool that renders templates from Consul data
- Watches Consul KV, services, and other data sources
- Automatically re-renders templates when data changes
- Can trigger commands after rendering (restart service, reload config)

**[📖 consul-template](https://github.com/hashicorp/consul-template)** - Template documentation

### Template Syntax
```hcl
# config.ctmpl template file

# KV value
database_host = {{ key "config/db/host" }}
database_port = {{ key "config/db/port" }}

# Service discovery
{{ range service "web" }}
server {{ .Address }}:{{ .Port }}
{{ end }}

# With health filtering
{{ range service "web" "passing" }}
server {{ .Address }}:{{ .Port }}
{{ end }}

# Conditional
{{ if keyExists "config/app/debug" }}
debug = {{ key "config/app/debug" }}
{{ else }}
debug = false
{{ end }}

# Secret from Vault (consul-template also supports Vault)
{{ with secret "secret/data/app/db" }}
password = {{ .Data.data.password }}
{{ end }}
```

### Running consul-template
```bash
# Render template and exit
consul-template -template "config.ctmpl:config.conf" -once

# Watch and continuously render
consul-template -template "config.ctmpl:config.conf:service nginx reload"

# Configuration file
consul-template -config consul-template.hcl
```

```hcl
# consul-template.hcl configuration
consul {
  address = "localhost:8500"
}

template {
  source      = "/etc/consul-template/config.ctmpl"
  destination = "/etc/myapp/config.conf"
  command     = "systemctl reload myapp"
}
```

### Template Functions
| Function | Purpose | Example |
|----------|---------|---------|
| `key` | Read KV value | `{{ key "config/host" }}` |
| `keyExists` | Check if key exists | `{{ if keyExists "config/host" }}` |
| `keyOrDefault` | Key with fallback | `{{ keyOrDefault "config/host" "localhost" }}` |
| `service` | List service instances | `{{ range service "web" }}` |
| `services` | List all services | `{{ range services }}` |
| `node` | Node information | `{{ with node }}` |
| `secret` | Vault secret | `{{ with secret "secret/data/app" }}` |

## Transactions

### Atomic KV Operations
```bash
# Transaction via API (atomic multi-key operation)
curl -X PUT http://localhost:8500/v1/txn \
  -d '[
    {
      "KV": {
        "Verb": "set",
        "Key": "config/db/host",
        "Value": "ZGIuZXhhbXBsZS5jb20="
      }
    },
    {
      "KV": {
        "Verb": "set",
        "Key": "config/db/port",
        "Value": "NTQzMg=="
      }
    },
    {
      "KV": {
        "Verb": "check-index",
        "Key": "config/db/version",
        "Index": 42
      }
    }
  ]'
```

**[📖 Transactions](https://developer.hashicorp.com/consul/api-docs/txn)** - Transaction API

### Transaction Verbs
| Verb | Description |
|------|-------------|
| set | Set a key's value |
| get | Read a key's value |
| delete | Delete a key |
| check-index | Verify key's ModifyIndex |
| check-session | Verify key's session holder |
| delete-tree | Delete all keys under prefix |
| check-not-exists | Verify key does not exist |

- All operations in a transaction are atomic
- If any operation fails, all are rolled back
- Maximum 64 operations per transaction
- Useful for coordinated configuration updates

## Sessions and Locks

### Session-Based Locking
```bash
# Create a session
curl -X PUT http://localhost:8500/v1/session/create \
  -d '{"Name": "my-lock", "TTL": "15s"}'
# Returns: {"ID": "session-id"}

# Acquire lock on a key
curl -X PUT -d 'lock-data' \
  http://localhost:8500/v1/kv/locks/my-resource?acquire=session-id

# Release lock
curl -X PUT \
  http://localhost:8500/v1/kv/locks/my-resource?release=session-id

# Destroy session
curl -X PUT http://localhost:8500/v1/session/destroy/session-id
```

### Lock Command (CLI)
```bash
# Acquire lock and execute command
consul lock config/deploy/lock ./deploy.sh

# Lock with session TTL
consul lock -timeout=30s config/deploy/lock ./deploy.sh
```

**[📖 Sessions](https://developer.hashicorp.com/consul/docs/dynamic-app-config/sessions)** - Session documentation

### Lock Behavior
- Session-based locking for distributed coordination
- Sessions have TTL - lock automatically released if session expires
- Only one session can hold a lock at a time
- Two behaviors: release (default) and delete
- Used for leader election and distributed mutual exclusion
