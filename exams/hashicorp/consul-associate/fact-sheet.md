# HashiCorp Consul Associate (003) - Fact Sheet

## Quick Reference

**Exam Code:** Consul Associate (003)
**Duration:** 60 minutes
**Questions:** 57 questions
**Passing Score:** 70%
**Cost:** $70.50 USD
**Validity:** 2 years
**Difficulty:** ⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Consul Architecture | 18% | Agents, gossip, consensus, datacenters |
| Deploy Single Datacenter | 16% | Agent config, cluster join, ACLs |
| Service Discovery | 17% | Registration, DNS, health checks |
| Key/Value Store | 10% | Read/write, watches, consul-template |
| Backup and Restore | 5% | Snapshots, data persistence |
| Service Mesh (Connect) | 17% | Proxies, intentions, mTLS, gateways |
| Secure Communications | 12% | Gossip encryption, TLS, ACLs |
| Consul on Kubernetes | 5% | Helm install, K8s integration |

## Consul Architecture

### Agent Types
| Type | Role | Count | Consensus |
|------|------|-------|-----------|
| Server | Maintains state, participates in Raft | 3 or 5 (odd number) | Yes |
| Client | Forwards requests, runs health checks | One per node | No |

- **[📖 Agent Overview](https://developer.hashicorp.com/consul/docs/agent)** - Agent documentation

### Gossip Protocol (Serf)
- LAN gossip: within a datacenter (all agents)
- WAN gossip: between datacenters (servers only)
- Used for membership management and failure detection
- Symmetric encryption key for gossip traffic
- UDP-based protocol with configurable intervals
- **[📖 Gossip Protocol](https://developer.hashicorp.com/consul/docs/architecture/gossip)** - Gossip details

### Consensus Protocol (Raft)
- Leader election among server agents
- Log replication for state consistency
- Quorum required for writes (majority of servers)
- 3 servers: tolerates 1 failure, 5 servers: tolerates 2 failures
- Leader handles all writes, followers replicate
- **[📖 Consensus Protocol](https://developer.hashicorp.com/consul/docs/architecture/consensus)** - Raft details

### Datacenter Architecture
```
Datacenter 1 (LAN)              Datacenter 2 (LAN)
┌─────────────────┐              ┌─────────────────┐
│  Server 1 (L)   │◄── WAN ───►│  Server 1 (L)   │
│  Server 2       │   Gossip    │  Server 2       │
│  Server 3       │              │  Server 3       │
│  Client A       │              │  Client X       │
│  Client B       │              │  Client Y       │
└─────────────────┘              └─────────────────┘
```

- Each datacenter has its own Raft cluster
- WAN gossip connects servers across datacenters
- Cross-datacenter queries forwarded via WAN
- **[📖 Multi-Datacenter](https://developer.hashicorp.com/consul/docs/architecture)** - Architecture overview

## Service Discovery

### Service Registration
```json
{
  "service": {
    "name": "web",
    "port": 8080,
    "tags": ["v1", "production"],
    "meta": {
      "version": "1.0.0"
    },
    "check": {
      "http": "http://localhost:8080/health",
      "interval": "10s",
      "timeout": "5s"
    }
  }
}
```

```bash
# Register via CLI
consul services register web.json

# Deregister
consul services deregister -id=web
```

- **[📖 Service Registration](https://developer.hashicorp.com/consul/docs/discovery/services)** - Registration guide

### DNS Discovery
```bash
# Standard service lookup
dig @127.0.0.1 -p 8600 web.service.consul

# Lookup with tag
dig @127.0.0.1 -p 8600 v1.web.service.consul

# Lookup in specific datacenter
dig @127.0.0.1 -p 8600 web.service.dc2.consul

# SRV record (includes port)
dig @127.0.0.1 -p 8600 web.service.consul SRV
```

- Default DNS port: 8600
- Format: `<service>.service[.datacenter].consul`
- Tag-based: `<tag>.<service>.service.consul`
- Only returns healthy instances by default
- **[📖 DNS Interface](https://developer.hashicorp.com/consul/docs/discovery/dns)** - DNS discovery

### Health Checks
| Type | Mechanism | Configuration |
|------|-----------|---------------|
| Script | Execute command, check exit code | `args`, `interval` |
| HTTP | GET request, check status code | `http`, `interval` |
| TCP | TCP connection test | `tcp`, `interval` |
| TTL | Service reports own health | `ttl` |
| gRPC | gRPC health check protocol | `grpc`, `interval` |
| Docker | Execute in container | `docker_container_id`, `args` |

- **[📖 Health Checks](https://developer.hashicorp.com/consul/docs/discovery/checks)** - Check types

## Key/Value Store

```bash
# Write a value
consul kv put config/db/host "db.example.com"
consul kv put config/db/port "5432"

# Read a value
consul kv get config/db/host

# Read with metadata
consul kv get -detailed config/db/host

# List keys
consul kv get -recurse config/

# Delete a key
consul kv delete config/db/host

# Delete prefix
consul kv delete -recurse config/db/

# Export KV tree
consul kv export config/ > backup.json

# Import KV tree
consul kv import @backup.json
```

- **[📖 KV Store](https://developer.hashicorp.com/consul/docs/dynamic-app-config/kv)** - KV documentation

### Watches
```bash
# Watch for KV changes
consul watch -type=key -key=config/db/host ./handler.sh

# Watch for service changes
consul watch -type=service -service=web ./handler.sh

# Watch types: key, keyprefix, services, nodes, service, checks, event
```

- **[📖 Watches](https://developer.hashicorp.com/consul/docs/dynamic-app-config/watches)** - Watch documentation

## Service Mesh (Connect)

### Sidecar Proxy
- Envoy proxy deployed alongside each service
- Handles inbound and outbound traffic
- Manages mTLS certificates automatically
- Enforces intentions (authorization rules)
- **[📖 Connect](https://developer.hashicorp.com/consul/docs/connect)** - Service mesh overview

### Intentions
```bash
# Allow web to talk to api
consul intention create web api

# Deny web from talking to database
consul intention create -deny web database

# List intentions
consul intention list

# Delete intention
consul intention delete web api
```

- L4 intentions: allow/deny based on service identity
- L7 intentions: path-based, header-based routing rules
- Default: deny all (when ACLs enabled) or allow all
- **[📖 Intentions](https://developer.hashicorp.com/consul/docs/connect/intentions)** - Authorization rules

### Gateways
| Gateway | Purpose | Direction |
|---------|---------|-----------|
| Ingress | External traffic into mesh | Inbound |
| Terminating | Mesh traffic to external services | Outbound |
| Mesh | Cross-datacenter mesh traffic | Between DCs |

- **[📖 Gateways](https://developer.hashicorp.com/consul/docs/connect/gateways)** - Gateway documentation

## Security

### ACL System
```bash
# Bootstrap ACLs
consul acl bootstrap

# Create policy
consul acl policy create -name="read-kv" -rules='key_prefix "" { policy = "read" }'

# Create token with policy
consul acl token create -policy-name="read-kv" -description="KV reader"

# List tokens
consul acl token list
```

- **[📖 ACL System](https://developer.hashicorp.com/consul/docs/security/acl)** - ACL documentation

### Gossip Encryption
```bash
# Generate encryption key
consul keygen
# Output: pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s=

# Configure in agent config
# encrypt = "pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s="
```

- **[📖 Gossip Encryption](https://developer.hashicorp.com/consul/docs/security/encryption)** - Encryption setup

### TLS Configuration
- RPC encryption between agents
- Verify incoming and outgoing connections
- Certificate-based authentication
- Auto-encrypt for automatic client certificate distribution
- **[📖 TLS](https://developer.hashicorp.com/consul/docs/security/encryption#tls-encryption)** - TLS setup

## Backup and Restore

```bash
# Create snapshot
consul snapshot save backup.snap

# Restore snapshot
consul snapshot restore backup.snap

# Inspect snapshot
consul snapshot inspect backup.snap
```

- **[📖 Snapshots](https://developer.hashicorp.com/consul/commands/snapshot)** - Backup documentation

## Exam Tips

### High-Value Topics
1. **Architecture (18%):** Server/client agents, gossip, Raft consensus
2. **Service Discovery (17%):** DNS format, health checks, registration
3. **Service Mesh (17%):** Connect, intentions, sidecar proxies, mTLS
4. **Deployment (16%):** Agent configuration, cluster join, ACL bootstrap
5. **Security (12%):** ACLs, gossip encryption, TLS
6. **KV Store (10%):** CLI operations, watches
7. **Backup (5%):** Snapshot save/restore
8. **Kubernetes (5%):** Helm chart, integration basics

### Common Exam Traps
- Confusing LAN gossip (all agents) with WAN gossip (servers only)
- Not knowing the DNS format: `<service>.service[.dc].consul`
- Thinking clients participate in Raft consensus (only servers do)
- Confusing intentions (service mesh auth) with ACLs (API access control)
- Not knowing that 3 servers tolerates 1 failure, 5 servers tolerates 2
- Forgetting that DNS discovery returns only healthy instances by default
- Confusing ingress gateway (inbound) with terminating gateway (outbound)
