# Vault Architecture

**[📖 Architecture Overview](https://developer.hashicorp.com/vault/docs/internals/architecture)** - Vault architecture documentation

## Overview

This document covers Vault's internal architecture including the barrier, storage backends, seal/unseal process, Shamir's Secret Sharing, and high availability. Understanding Vault architecture is worth 10% of the exam and underpins all other Vault concepts.

## Core Architecture

### Component Overview
```
┌─────────────────────────────────────────────┐
│                  Vault Server                │
│  ┌─────────────────────────────────────────┐ │
│  │           HTTP API / CLI / UI            │ │
│  ├─────────────────────────────────────────┤ │
│  │         Auth Methods (Pluggable)         │ │
│  │  Token | AppRole | LDAP | K8s | AWS     │ │
│  ├─────────────────────────────────────────┤ │
│  │        Secrets Engines (Pluggable)       │ │
│  │   KV | Transit | PKI | Database | AWS   │ │
│  ├─────────────────────────────────────────┤ │
│  │         Audit Devices (Pluggable)        │ │
│  │         File | Syslog | Socket           │ │
│  ├─────────────────────────────────────────┤ │
│  │              System Backend              │ │
│  │           (sys/ API endpoints)           │ │
│  ├─────────────────────────────────────────┤ │
│  │    ┌──────────────────────────────┐     │ │
│  │    │     Cryptographic Barrier     │     │ │
│  │    └──────────────────────────────┘     │ │
│  ├─────────────────────────────────────────┤ │
│  │         Storage Backend (Encrypted)      │ │
│  │      Raft | Consul | S3 | DynamoDB      │ │
│  └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

**[📖 Vault Internals](https://developer.hashicorp.com/vault/docs/internals)** - Internal mechanics

### Cryptographic Barrier
- All data passing in and out of Vault goes through the barrier
- Data encrypted before writing to storage backend
- Data decrypted after reading from storage backend
- Storage backend never sees plaintext data
- Uses AES-256-GCM encryption
- Barrier is the core security mechanism

### Storage Backends
| Backend | HA Support | Recommended | Notes |
|---------|-----------|-------------|-------|
| Integrated Storage (Raft) | Yes | Yes (default) | Built-in, no external dependencies |
| Consul | Yes | Yes (legacy) | Requires external Consul cluster |
| S3 | No | No (dev only) | No HA support |
| DynamoDB | Yes | Sometimes | AWS-specific workloads |
| GCS | No | No | Google Cloud Storage |
| Azure | No | No | Azure Blob Storage |

- Storage backend only stores encrypted data
- Raft (Integrated Storage) is recommended for new deployments
- HA requires an HA-capable storage backend
- Storage selection impacts HA and operational complexity

**[📖 Storage Backends](https://developer.hashicorp.com/vault/docs/configuration/storage)** - Storage configuration
**[📖 Integrated Storage](https://developer.hashicorp.com/vault/docs/configuration/storage/raft)** - Raft storage

### System Backend (sys/)
- Internal API endpoints for Vault management
- Accessible at `/v1/sys/` path
- Includes: health, init, seal, unseal, mounts, auth, policies
- Some endpoints require sudo capability
- Not a secrets engine - part of Vault core

## Seal and Unseal Process

### Seal States
| State | Description | Operations Available |
|-------|-------------|---------------------|
| Sealed | Vault knows where data is but cannot decrypt | Health check only |
| Unsealed | Vault can read/write encrypted data | All operations |

### Seal Process
1. Vault starts in a sealed state
2. Vault knows the physical storage location but cannot decrypt anything
3. Unsealing provides the encryption key to decrypt data through the barrier
4. Once unsealed, Vault operates normally until resealed or restarted

**[📖 Seal/Unseal](https://developer.hashicorp.com/vault/docs/concepts/seal)** - Seal concepts

### Shamir's Secret Sharing
- Master key is split into N shares (default: 5)
- Threshold of K shares required to reconstruct (default: 3)
- Any K of N shares can unseal Vault
- Individual shares are useless on their own
- Shares should be distributed to different people/locations

```bash
# Initialize Vault (generates unseal keys and root token)
vault operator init

# Output:
# Unseal Key 1: xxxxxx
# Unseal Key 2: xxxxxx
# Unseal Key 3: xxxxxx
# Unseal Key 4: xxxxxx
# Unseal Key 5: xxxxxx
# Initial Root Token: hvs.xxxxxx

# Unseal with 3 of 5 keys
vault operator unseal <key_1>
vault operator unseal <key_2>
vault operator unseal <key_3>
# Vault is now unsealed
```

### Custom Key Shares
```bash
# Initialize with custom shares
vault operator init -key-shares=7 -key-threshold=4
# Requires 4 of 7 keys to unseal
```

**[📖 Shamir's Secret Sharing](https://developer.hashicorp.com/vault/docs/concepts/seal#shamir-seals)** - Key splitting

### Key Hierarchy
```
Unseal Keys (Shamir shares)
  └── Root Key (reconstructed from shares)
        └── Encryption Key (decrypted by root key)
              └── Data (encrypted/decrypted by encryption key through barrier)
```

- Unseal keys reconstruct the root key
- Root key decrypts the encryption key
- Encryption key encrypts/decrypts all data through the barrier
- Root key is never stored - only exists in memory when Vault is unsealed

### Auto Unseal
- Uses cloud KMS to automatically unseal Vault
- Eliminates need for manual unseal key entry
- Supported: AWS KMS, Azure Key Vault, GCP Cloud KMS, HSM (PKCS#11)
- Recovery keys replace unseal keys (for root token generation)
- Recovery keys cannot unseal - only KMS can

**[📖 Auto Unseal](https://developer.hashicorp.com/vault/docs/concepts/seal#auto-unseal)** - Auto unseal configuration

```hcl
# Vault configuration for AWS KMS auto-unseal
seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "alias/vault-unseal-key"
}
```

### Seal vs Auto-Unseal Comparison
| Feature | Shamir Seal | Auto Unseal |
|---------|------------|-------------|
| Unseal mechanism | Manual key entry | Cloud KMS |
| Key storage | Distributed to operators | Cloud KMS |
| Recovery keys | Unseal keys | Recovery keys |
| Root token generation | Unseal keys | Recovery keys |
| Restart behavior | Requires manual unseal | Automatic unseal |
| Operational overhead | Higher | Lower |

## High Availability

### Architecture
- Active/standby cluster model
- One active node handles all requests
- Standby nodes forward requests to active node
- Leader election via storage backend
- Requires HA-capable storage backend (Raft or Consul)

**[📖 High Availability](https://developer.hashicorp.com/vault/docs/concepts/ha)** - HA architecture

### Raft HA (Integrated Storage)
```hcl
# Vault server configuration with Raft
storage "raft" {
  path    = "/opt/vault/data"
  node_id = "vault-node-1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 0
  tls_cert_file = "/opt/vault/tls/vault.crt"
  tls_key_file  = "/opt/vault/tls/vault.key"
}

api_addr     = "https://vault-1.example.com:8200"
cluster_addr = "https://vault-1.example.com:8201"
```

### Cluster Operations
```bash
# Join new node to Raft cluster
vault operator raft join https://vault-1.example.com:8200

# List Raft peers
vault operator raft list-peers

# Check Vault HA status
vault status
# HA Enabled: true
# HA Cluster: https://vault-1.example.com:8201
# HA Mode: active (or standby)
```

### Performance Replication (Enterprise)
- Primary cluster handles reads and writes
- Performance replicas handle read requests
- Reduces load on primary cluster
- Available in Vault Enterprise only

### Disaster Recovery Replication (Enterprise)
- Secondary cluster receives replicated data
- Promoted to primary during disaster
- Available in Vault Enterprise only

## Server Configuration

### Listener Configuration
```hcl
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 0
  tls_cert_file = "/opt/vault/tls/vault.crt"
  tls_key_file  = "/opt/vault/tls/vault.key"
}
```

### Audit Devices
```bash
# Enable file audit device
vault audit enable file file_path=/var/log/vault/audit.log

# Enable syslog audit device
vault audit enable syslog

# List audit devices
vault audit list
```

- At least one audit device should be enabled in production
- All requests and responses are logged
- Sensitive data is HMAC'd in audit logs (not plaintext)
- If all audit devices fail, Vault refuses to process requests (security guarantee)

**[📖 Audit Devices](https://developer.hashicorp.com/vault/docs/audit)** - Audit logging

## Dev Server

### Quick Start
```bash
# Start dev server (in-memory, auto-unsealed, root token provided)
vault server -dev

# Dev server properties:
# - Runs in-memory (no persistent storage)
# - Automatically initialized and unsealed
# - Root token printed to stdout
# - Listens on http://127.0.0.1:8200
# - TLS disabled
# - KV v2 enabled at secret/
# - NEVER use in production
```

**[📖 Dev Server](https://developer.hashicorp.com/vault/docs/concepts/dev-server)** - Development server
