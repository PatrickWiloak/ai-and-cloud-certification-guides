# Service Discovery and Health Checks

**[📖 Service Discovery](https://developer.hashicorp.com/consul/docs/discovery/services)** - Service registration
**[📖 Health Checks](https://developer.hashicorp.com/consul/docs/discovery/checks)** - Check types

## Overview

This document covers service registration, DNS and HTTP discovery, health check types, and prepared queries. Service discovery is 17% of the exam and is one of Consul's core features.

## Service Registration

### Registration Methods
| Method | Use Case | Persistence |
|--------|----------|-------------|
| Config file | Static services | Survives agent restart |
| HTTP API | Dynamic registration | Lost on agent restart |
| CLI | Quick registration | Lost on agent restart |

### Config File Registration
```json
{
  "service": {
    "name": "web",
    "id": "web-1",
    "port": 8080,
    "address": "10.0.1.20",
    "tags": ["v2", "production", "primary"],
    "meta": {
      "version": "2.0.0",
      "environment": "production"
    },
    "check": {
      "http": "http://localhost:8080/health",
      "interval": "10s",
      "timeout": "3s"
    }
  }
}
```

- Place in agent config directory (`-config-dir`)
- Loaded on agent startup or `consul reload`
- Service ID must be unique within the agent
- Service name used for discovery (can have duplicates across agents)

### HTTP API Registration
```bash
# Register via API
curl -X PUT http://localhost:8500/v1/agent/service/register \
  -d '{
    "Name": "api",
    "Port": 9090,
    "Tags": ["v1"],
    "Check": {
      "HTTP": "http://localhost:9090/health",
      "Interval": "10s"
    }
  }'

# Deregister via API
curl -X PUT http://localhost:8500/v1/agent/service/deregister/api
```

**[📖 Agent Service API](https://developer.hashicorp.com/consul/api-docs/agent/service)** - Service API

### CLI Registration
```bash
# Register from file
consul services register web.json

# Deregister
consul services deregister -id=web-1
```

## DNS Discovery

### Query Format
```
<service>.service[.<datacenter>].consul
<tag>.<service>.service[.<datacenter>].consul
```

### Standard Queries
```bash
# Basic service lookup (returns A records)
dig @127.0.0.1 -p 8600 web.service.consul

# SRV record (includes port number)
dig @127.0.0.1 -p 8600 web.service.consul SRV

# Tag-based query
dig @127.0.0.1 -p 8600 v2.web.service.consul

# Cross-datacenter query
dig @127.0.0.1 -p 8600 web.service.dc2.consul

# Node lookup
dig @127.0.0.1 -p 8600 node-1.node.consul
```

**[📖 DNS Interface](https://developer.hashicorp.com/consul/docs/discovery/dns)** - DNS documentation

### DNS Behavior
- Default port: 8600 (configurable)
- Only returns healthy service instances
- Round-robin load balancing for multiple instances
- TTL configurable per service or globally
- Supports A, AAAA, SRV, and TXT record types
- Can forward to upstream DNS via recursors

### DNS Forwarding
```bash
# Configure system DNS to forward .consul queries to Consul
# In /etc/resolv.conf or systemd-resolved or dnsmasq:
# server=/consul/127.0.0.1#8600
```

## HTTP API Discovery

### Catalog API
```bash
# List all services
curl http://localhost:8500/v1/catalog/services

# List service instances
curl http://localhost:8500/v1/catalog/service/web

# List nodes
curl http://localhost:8500/v1/catalog/nodes
```

**[📖 Catalog API](https://developer.hashicorp.com/consul/api-docs/catalog)** - Catalog endpoints

### Health API
```bash
# Healthy service instances only
curl http://localhost:8500/v1/health/service/web?passing=true

# All service instances with health status
curl http://localhost:8500/v1/health/service/web

# Health checks for a service
curl http://localhost:8500/v1/health/checks/web

# Health checks on a node
curl http://localhost:8500/v1/health/node/node-1
```

**[📖 Health API](https://developer.hashicorp.com/consul/api-docs/health)** - Health endpoints

### Blocking Queries (Long Polling)
```bash
# Initial query returns X-Consul-Index header
curl -v http://localhost:8500/v1/health/service/web?passing=true
# Response header: X-Consul-Index: 42

# Blocking query waits for changes
curl http://localhost:8500/v1/health/service/web?passing=true&index=42&wait=5m
# Returns immediately when data changes, or after 5 minutes timeout
```

- Efficient change detection without polling
- Client provides last index, server blocks until data changes
- Used by consul-template and watches internally

## Health Checks

### Check Types
| Type | How It Works | Configuration |
|------|-------------|---------------|
| Script | Executes command, checks exit code | `args`, `interval` |
| HTTP | Sends GET request, checks status code (2xx = pass) | `http`, `interval` |
| TCP | Opens TCP connection | `tcp`, `interval` |
| TTL | Service must actively report health | `ttl` |
| gRPC | Uses gRPC health check protocol | `grpc`, `interval` |
| Docker | Executes command in Docker container | `docker_container_id`, `args` |
| Alias | Mirrors another check's status | `alias_service` |

### Health Check Examples
```json
{
  "service": {
    "name": "web",
    "port": 8080,
    "checks": [
      {
        "id": "http-check",
        "name": "HTTP Health",
        "http": "http://localhost:8080/health",
        "interval": "10s",
        "timeout": "3s"
      },
      {
        "id": "tcp-check",
        "name": "TCP Port",
        "tcp": "localhost:8080",
        "interval": "15s"
      }
    ]
  }
}
```

### Script Check
```json
{
  "check": {
    "id": "disk-check",
    "name": "Disk Usage",
    "args": ["/usr/local/bin/check-disk.sh"],
    "interval": "30s"
  }
}
```

- Exit code 0 = passing
- Exit code 1 = warning
- Any other exit code = critical

### TTL Check
```json
{
  "check": {
    "id": "app-ttl",
    "name": "Application TTL",
    "ttl": "30s"
  }
}
```

```bash
# Service reports health via API
curl -X PUT http://localhost:8500/v1/agent/check/pass/app-ttl
curl -X PUT http://localhost:8500/v1/agent/check/warn/app-ttl
curl -X PUT http://localhost:8500/v1/agent/check/fail/app-ttl
```

- Service must actively report health within TTL
- If TTL expires without update, check becomes critical
- Useful when external checks are not feasible

### Health Status Values
| Status | Meaning | Discovery Impact |
|--------|---------|-----------------|
| passing | Service is healthy | Included in results |
| warning | Service has issues | Included in results |
| critical | Service is unhealthy | Excluded from results |

### Deregister After Critical
```json
{
  "check": {
    "http": "http://localhost:8080/health",
    "interval": "10s",
    "deregister_critical_service_after": "90s"
  }
}
```

- Automatically deregisters service after sustained critical status
- Useful for ephemeral services (containers, serverless)
- Prevents stale service entries in the catalog

## Prepared Queries

### Overview
- Pre-defined service queries with advanced options
- Support failover to other datacenters
- Can filter by tags, node metadata, and service metadata
- Executed via DNS or HTTP API

**[📖 Prepared Queries](https://developer.hashicorp.com/consul/api-docs/query)** - Query documentation

```bash
# Create prepared query
curl -X POST http://localhost:8500/v1/query \
  -d '{
    "Name": "web-production",
    "Service": {
      "Service": "web",
      "Tags": ["production"],
      "Failover": {
        "Datacenters": ["dc2", "dc3"]
      }
    }
  }'

# Execute via HTTP
curl http://localhost:8500/v1/query/<query-id>/execute

# Execute via DNS
dig @127.0.0.1 -p 8600 web-production.query.consul
```

### Failover Behavior
- Try local datacenter first
- If no healthy instances locally, try failover datacenters in order
- Transparent to the querying application
- Configurable nearest-datacenter sorting

## Service Tags and Metadata

### Tags
- Simple string labels attached to services
- Used for filtering in DNS and API queries
- Common uses: version, environment, region
- Multiple tags per service supported
- Tag-based DNS: `<tag>.<service>.service.consul`

### Metadata
- Key-value pairs with richer structure than tags
- Not queryable via DNS (API only)
- Used for additional service information
- Displayed in UI and API responses

```json
{
  "service": {
    "name": "api",
    "tags": ["v2", "production"],
    "meta": {
      "version": "2.3.1",
      "team": "backend",
      "git_sha": "abc123"
    }
  }
}
```
