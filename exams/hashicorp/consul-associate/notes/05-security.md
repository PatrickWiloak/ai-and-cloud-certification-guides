# Security (ACLs, TLS, Gossip Encryption)

**[📖 Security Overview](https://developer.hashicorp.com/consul/docs/security)** - Security documentation
**[📖 ACL System](https://developer.hashicorp.com/consul/docs/security/acl)** - ACL documentation

## Overview

This document covers Consul security including the ACL system, gossip encryption, and TLS configuration. Security is 12% of the exam, and understanding the full security model - especially ACLs - is critical for the certification.

## ACL System

### Architecture
- Token-based access control for API operations
- Policies define permissions, tokens carry policies
- Default behavior: allow all (unless explicitly configured to deny)
- Bootstrap token created during ACL initialization
- Primary datacenter authorizes tokens for all datacenters

**[📖 ACL Overview](https://developer.hashicorp.com/consul/docs/security/acl)** - ACL architecture

### Enabling ACLs
```hcl
# Server agent configuration
acl {
  enabled        = true
  default_policy = "deny"
  enable_token_persistence = true
  
  tokens {
    initial_management = "my-bootstrap-token"  # Optional: set bootstrap token
  }
}
```

### Bootstrap Process
```bash
# Step 1: Enable ACLs in all agent configurations
# Step 2: Restart agents with ACL configuration
# Step 3: Bootstrap the ACL system (creates initial management token)
consul acl bootstrap

# Output:
# AccessorID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# SecretID:   yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
# Description: Bootstrap Token (Global Management)
# Policies:
#   00000000-0000-0000-0000-000000000001 - global-management

# Step 4: Use bootstrap token to create additional tokens
export CONSUL_HTTP_TOKEN="yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"

# Step 5: Create agent token for each agent
consul acl token create -description="Agent token" -policy-name="agent-policy"
```

### ACL Components
| Component | Purpose | Example |
|-----------|---------|---------|
| Token | Authentication credential (carries policies) | Agent token, service token |
| Policy | Named set of permission rules | node-read, service-write |
| Role | Group of policies (optional) | admin-role, developer-role |
| Auth Method | External authentication integration | Kubernetes, JWT |
| Binding Rule | Maps auth method identities to tokens | K8s service account to token |

### Policy Rules
```hcl
# Node policy (agent registration and catalog)
node_prefix "" {
  policy = "read"
}
node "web-server-1" {
  policy = "write"
}

# Service policy (registration and discovery)
service_prefix "" {
  policy = "read"
}
service "web" {
  policy = "write"
}

# KV policy
key_prefix "" {
  policy = "read"
}
key_prefix "config/web/" {
  policy = "write"
}

# Agent policy
agent_prefix "" {
  policy = "read"
}
agent "web-server-1" {
  policy = "write"
}

# Session policy
session_prefix "" {
  policy = "write"
}

# Intention policy (service mesh authorization)
service_prefix "" {
  policy = "read"
  intentions = "read"
}
service "web" {
  policy = "write"
  intentions = "write"
}
```

### Policy Levels
| Level | Permissions |
|-------|------------|
| read | Read operations only |
| write | Read and write operations |
| deny | Explicitly deny access |
| list | List operations (keys, nodes) |

### Creating Policies and Tokens
```bash
# Create policy from file
consul acl policy create \
  -name="web-service" \
  -description="Web service policy" \
  -rules=@web-policy.hcl

# Create policy inline
consul acl policy create \
  -name="kv-reader" \
  -rules='key_prefix "" { policy = "read" }'

# Create token with policy
consul acl token create \
  -description="Web service token" \
  -policy-name="web-service"

# Create token with multiple policies
consul acl token create \
  -description="Developer token" \
  -policy-name="kv-reader" \
  -policy-name="service-reader"

# List policies
consul acl policy list

# List tokens
consul acl token list

# Read policy
consul acl policy read -name="web-service"

# Update policy
consul acl policy update -name="web-service" -rules=@updated-policy.hcl

# Delete policy
consul acl policy delete -name="web-service"

# Delete token
consul acl token delete -id=<accessor-id>
```

### Special Tokens
| Token | Purpose | Created By |
|-------|---------|-----------|
| Bootstrap/Management | Full access, initial setup | `consul acl bootstrap` |
| Agent | Agent operations (node registration, anti-entropy) | Administrator |
| Anonymous | Unauthenticated requests | Default (empty policy) |
| Default | Fallback for missing tokens | Configuration |

### Agent Token Types
```hcl
# Agent token configuration
acl {
  tokens {
    agent = "agent-token-secret"      # Used for internal agent operations
    default = "default-token-secret"  # Used when no token provided
  }
}
```

## Gossip Encryption

### Overview
- Symmetric key encryption for gossip protocol traffic
- Protects LAN and WAN gossip communication
- All agents in a cluster must share the same key
- Key rotation supported without cluster downtime

**[📖 Gossip Encryption](https://developer.hashicorp.com/consul/docs/security/encryption)** - Encryption setup

### Configuration
```bash
# Generate encryption key
consul keygen
# Output: pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s=

# Add to agent configuration
# encrypt = "pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s="
```

```hcl
# Agent configuration
encrypt = "pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s="
encrypt_verify_incoming = true
encrypt_verify_outgoing = true
```

### Key Rotation
```bash
# Step 1: Install new key on all agents
consul keyring -install="new-key-base64"

# Step 2: Change primary key to new key
consul keyring -use="new-key-base64"

# Step 3: Remove old key
consul keyring -remove="old-key-base64"

# List keys
consul keyring -list
```

- Supports multiple keys simultaneously during rotation
- New key installed on all agents first
- Primary key changed atomically
- Old key removed after all agents are updated

## TLS Encryption

### Overview
- Certificate-based encryption for RPC communication
- Protects server-to-server and client-to-server traffic
- Separate from gossip encryption (both needed for full security)
- Mutual TLS verifies both client and server identity

**[📖 TLS Configuration](https://developer.hashicorp.com/consul/docs/security/encryption)** - TLS setup

### Server Configuration
```hcl
tls {
  defaults {
    ca_file   = "/etc/consul.d/consul-agent-ca.pem"
    cert_file = "/etc/consul.d/dc1-server-consul-0.pem"
    key_file  = "/etc/consul.d/dc1-server-consul-0-key.pem"
    verify_incoming = true
    verify_outgoing = true
  }
  internal_rpc {
    verify_server_hostname = true
  }
}
```

### TLS Settings
| Setting | Purpose | Recommended |
|---------|---------|-------------|
| verify_incoming | Verify client certificates | true (production) |
| verify_outgoing | Verify server certificates | true (always) |
| verify_server_hostname | Check server certificate hostname | true (always) |

### Auto-Encrypt
```hcl
# Server configuration
auto_encrypt {
  allow_tls = true
}

# Client configuration
auto_encrypt {
  tls = true
}
```

- Automatically distributes TLS certificates to client agents
- Clients request certificates from servers
- Eliminates manual certificate distribution
- Servers must be configured with `allow_tls = true`
- Clients configured with `tls = true`

**[📖 Auto-Encrypt](https://developer.hashicorp.com/consul/docs/security/encryption#auto-encrypt)** - Automatic TLS

### Certificate Generation
```bash
# Using consul tls CLI
consul tls ca create               # Create CA
consul tls cert create -server     # Create server certificate
consul tls cert create -client     # Create client certificate
```

## Security Checklist

### Production Security
- [ ] Enable ACLs with default deny policy
- [ ] Bootstrap ACL system and secure management token
- [ ] Create agent tokens for all agents
- [ ] Enable gossip encryption on all agents
- [ ] Configure TLS for RPC communication
- [ ] Enable verify_incoming and verify_outgoing
- [ ] Enable verify_server_hostname
- [ ] Configure auto-encrypt for client certificate distribution
- [ ] Define intentions for service mesh authorization
- [ ] Restrict network access to Consul ports

### Security Layers
| Layer | Mechanism | Protects |
|-------|-----------|---------|
| API access | ACL tokens and policies | Who can call the API |
| Service authorization | Intentions | Which services can communicate |
| Gossip traffic | Symmetric key encryption | Agent-to-agent gossip |
| RPC traffic | TLS certificates | Client-to-server RPC |
| Service traffic | mTLS (Connect) | Service-to-service data |
