# HashiCorp Vault Associate (003) - Fact Sheet

## Quick Reference

**Exam Code:** Vault Associate (003)
**Duration:** 60 minutes
**Questions:** 57 questions
**Passing Score:** 70%
**Cost:** $70.50 USD
**Validity:** 2 years
**Difficulty:** ⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Compare authentication methods | 15% | Auth methods, human vs machine |
| Create Vault policies | 15% | Policy syntax, capabilities, path-based access |
| Assess Vault tokens | 10% | Token types, TTL, renewal, accessors |
| Manage Vault leases | 5% | Lease lifecycle, renewal, revocation |
| Compare and configure secrets engines | 20% | KV, Transit, PKI, Database, dynamic secrets |
| Utilize Vault CLI | 15% | Commands, flags, operations |
| Utilize Vault UI | 5% | Navigation and management |
| Be aware of the Vault API | 5% | API structure, authentication, sys/ endpoints |
| Explain Vault architecture | 10% | Seal/unseal, storage, HA, Shamir |

## Vault Architecture

### Core Components
- **Storage Backend:** Persistent storage for encrypted data (Consul, Raft, S3)
- **Barrier:** Cryptographic barrier protecting all data at rest
- **Secrets Engines:** Pluggable components that store, generate, or encrypt data
- **Auth Methods:** Pluggable components that verify user/machine identity
- **Audit Devices:** Pluggable logging for all Vault requests and responses
- **System Backend:** Internal API for Vault configuration (sys/)
- **[📖 Vault Architecture](https://developer.hashicorp.com/vault/docs/internals/architecture)** - Architecture overview
- **[📖 Vault Internals](https://developer.hashicorp.com/vault/docs/internals)** - Internal mechanics

### Seal/Unseal Process
1. Vault starts in a **sealed** state - cannot read/write data
2. Unsealing requires a threshold of **unseal keys** (Shamir's Secret Sharing)
3. Default: 5 key shares, 3 key threshold (3 of 5 needed to unseal)
4. Unseal keys reconstruct the **root key** which decrypts the **encryption key**
5. Encryption key is used to decrypt/encrypt all data through the barrier
6. `vault operator unseal` provides one key share at a time
7. Once threshold is met, Vault transitions to **unsealed** state

- **[📖 Seal/Unseal](https://developer.hashicorp.com/vault/docs/concepts/seal)** - Seal concepts and process
- **[📖 Shamir Secret Sharing](https://developer.hashicorp.com/vault/docs/concepts/seal#shamir-seals)** - Key sharing algorithm

### Auto Unseal
- Uses cloud KMS to automatically unseal Vault
- Supported providers: AWS KMS, Azure Key Vault, GCP Cloud KMS, HSM (PKCS#11)
- Eliminates need for manual unseal key entry
- Recovery keys replace unseal keys (for root token generation, not unsealing)
- **[📖 Auto Unseal](https://developer.hashicorp.com/vault/docs/concepts/seal#auto-unseal)** - Automatic unseal configuration

### Storage Backends
| Backend | HA Support | Description |
|---------|-----------|-------------|
| Integrated Storage (Raft) | Yes | Built-in, recommended for production |
| Consul | Yes | External HashiCorp Consul cluster |
| S3 | No | AWS S3 bucket (no HA) |
| DynamoDB | Yes | AWS DynamoDB table |
| GCS | No | Google Cloud Storage bucket |
| Azure | No | Azure Blob Storage |

- Storage backends only store encrypted data - they never see plaintext
- Integrated Storage (Raft) is the recommended default
- **[📖 Storage Backends](https://developer.hashicorp.com/vault/docs/configuration/storage)** - Storage configuration

### High Availability
- Active/standby architecture
- Only one active node handles requests
- Standby nodes forward requests to the active node
- Requires HA-capable storage backend
- Leader election via storage backend
- **[📖 High Availability](https://developer.hashicorp.com/vault/docs/concepts/ha)** - HA architecture

## Authentication Methods

### Token Auth (Default)
- Always enabled, cannot be disabled
- Core authentication mechanism in Vault
- All other auth methods ultimately produce a token
- Root token has unlimited privileges
- **[📖 Token Auth](https://developer.hashicorp.com/vault/docs/auth/token)** - Token authentication

### Auth Method Comparison
| Method | Use Case | Human/Machine | Configuration |
|--------|----------|---------------|---------------|
| Token | Direct token auth | Both | Always enabled |
| UserPass | Simple username/password | Human | Internal user store |
| LDAP | Enterprise directory | Human | External LDAP server |
| AppRole | Application authentication | Machine | Role ID + Secret ID |
| AWS | AWS workloads | Machine | IAM or EC2 metadata |
| Kubernetes | K8s pods | Machine | Service account tokens |
| GitHub | Developer access | Human | GitHub org/team membership |
| OIDC/JWT | SSO integration | Human | External OIDC provider |
| TLS Certificates | Certificate-based auth | Both | X.509 certificates |

- **[📖 Auth Methods](https://developer.hashicorp.com/vault/docs/auth)** - All auth methods overview
- **[📖 AppRole](https://developer.hashicorp.com/vault/docs/auth/approle)** - Machine authentication
- **[📖 LDAP](https://developer.hashicorp.com/vault/docs/auth/ldap)** - Directory authentication
- **[📖 Kubernetes Auth](https://developer.hashicorp.com/vault/docs/auth/kubernetes)** - K8s pod authentication
- **[📖 AWS Auth](https://developer.hashicorp.com/vault/docs/auth/aws)** - AWS workload authentication
- **[📖 UserPass](https://developer.hashicorp.com/vault/docs/auth/userpass)** - Username/password auth
- **[📖 GitHub Auth](https://developer.hashicorp.com/vault/docs/auth/github)** - GitHub-based authentication

### AppRole (Most Tested Machine Auth)
```bash
# Enable AppRole
vault auth enable approle

# Create role
vault write auth/approle/role/my-app \
  secret_id_ttl=24h \
  token_ttl=1h \
  token_max_ttl=4h \
  policies="my-policy"

# Get Role ID (stable identifier)
vault read auth/approle/role/my-app/role-id

# Generate Secret ID (sensitive, one-time-use optional)
vault write -f auth/approle/role/my-app/secret-id

# Login with AppRole
vault write auth/approle/login \
  role_id="<role_id>" \
  secret_id="<secret_id>"
```

- **Role ID:** Similar to a username - stable, not secret
- **Secret ID:** Similar to a password - sensitive, can be restricted
- Best for CI/CD pipelines and automated systems

## Vault Policies

### Policy Syntax
```hcl
# Allow read and list on KV secrets
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}

# Allow create and update on specific path
path "secret/data/my-app/config" {
  capabilities = ["create", "update"]
}

# Deny access to admin secrets
path "secret/data/admin/*" {
  capabilities = ["deny"]
}

# Allow all operations on a path
path "secret/data/dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

### Policy Capabilities
| Capability | HTTP Verb | Description |
|------------|-----------|-------------|
| create | POST/PUT | Create new data |
| read | GET | Read data |
| update | POST/PUT | Modify existing data |
| delete | DELETE | Delete data |
| list | LIST | List keys at a path |
| sudo | - | Access sudo-protected paths |
| deny | - | Explicitly deny access (overrides all) |

- **[📖 Policies](https://developer.hashicorp.com/vault/docs/concepts/policies)** - Policy concepts
- **[📖 Policy Syntax](https://developer.hashicorp.com/vault/docs/concepts/policies#policy-syntax)** - Policy language reference

### Built-in Policies
- **default:** Attached to all tokens, allows basic self-management
- **root:** Superuser policy with all capabilities on all paths
- Neither can be deleted
- Default policy can be modified

### Policy Path Patterns
- `secret/data/my-app` - Exact path match
- `secret/data/my-app/*` - Glob match (one level)
- `secret/data/+/config` - Single-segment wildcard
- `secret/data/my-app/{{identity.entity.name}}` - Templated policy

## Tokens

### Token Types
| Type | Properties | Use Case |
|------|------------|----------|
| Service Token | Full-featured, stored in storage backend | Default, long-lived operations |
| Batch Token | Lightweight, not persisted, encrypted blob | High-performance, short-lived |
| Root Token | Superuser, no TTL, unlimited access | Initial setup and emergency |
| Orphan Token | No parent, independent lifecycle | Long-running processes |
| Periodic Token | Renewable indefinitely within period | Ongoing services |

- **[📖 Tokens](https://developer.hashicorp.com/vault/docs/concepts/tokens)** - Token concepts and types

### Token Properties
- **Token ID:** The actual token string used for authentication
- **Accessor:** Non-sensitive reference to a token (for lookup/revoke without the token itself)
- **TTL:** Time-to-live before automatic expiration
- **Max TTL:** Maximum duration a token can exist (even with renewals)
- **Policies:** List of policies attached to the token
- **Num Uses:** Number of uses before the token expires (0 = unlimited)

### Token Hierarchy
- Tokens form a parent-child tree
- Revoking a parent revokes all children (unless orphan)
- Root token has no parent
- Orphan tokens break the hierarchy chain

### Token CLI Commands
```bash
vault token create                    # Create child token
vault token create -policy="my-policy" -ttl=1h  # With policy and TTL
vault token create -orphan            # Create orphan token
vault token lookup                    # Look up current token
vault token lookup -accessor <accessor>  # Look up by accessor
vault token renew                     # Renew current token
vault token revoke <token>            # Revoke a token
vault token revoke -accessor <accessor>  # Revoke by accessor
```

## Leases

### Lease Concepts
- Every dynamic secret has a lease
- Lease defines the duration the secret is valid
- Lease ID uniquely identifies the lease
- Credentials are automatically revoked when lease expires
- Leases can be renewed to extend validity

### Lease Operations
```bash
# List leases
vault list sys/leases/lookup/database/creds/my-role

# Renew a lease
vault lease renew <lease_id>
vault lease renew -increment=1h <lease_id>

# Revoke a lease
vault lease revoke <lease_id>

# Revoke all leases under a prefix
vault lease revoke -prefix database/creds/my-role
```

- **[📖 Leases](https://developer.hashicorp.com/vault/docs/concepts/lease)** - Lease concepts and management

### Lease vs Token TTL
- Tokens have TTL (time-to-live)
- Dynamic secrets have leases
- Both can be renewed up to max TTL
- Both are automatically revoked when expired

## Secrets Engines

### KV Secrets Engine
```bash
# Enable KV v2
vault secrets enable -path=secret kv-v2

# Write a secret
vault kv put secret/my-app/config username="admin" password="s3cret"

# Read a secret
vault kv get secret/my-app/config

# Read specific version
vault kv get -version=2 secret/my-app/config

# Delete (soft delete in v2)
vault kv delete secret/my-app/config

# Undelete
vault kv undelete -versions=1 secret/my-app/config

# Permanently destroy
vault kv destroy -versions=1 secret/my-app/config
```

**KV v1 vs v2:**
| Feature | KV v1 | KV v2 |
|---------|-------|-------|
| Versioning | No | Yes |
| Soft delete | No | Yes (undelete possible) |
| Path prefix | `<mount>/` | `<mount>/data/` |
| Metadata | No | Yes (`<mount>/metadata/`) |
| Check-and-set | No | Yes (cas parameter) |
| Destroy | No | Yes (permanent delete) |

- **[📖 KV Secrets Engine v2](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2)** - KV v2 documentation
- **[📖 KV Secrets Engine v1](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v1)** - KV v1 documentation

### Transit Secrets Engine (Encryption as a Service)
```bash
# Enable Transit
vault secrets enable transit

# Create encryption key
vault write -f transit/keys/my-key

# Encrypt data
vault write transit/encrypt/my-key plaintext=$(echo "secret" | base64)

# Decrypt data
vault write transit/decrypt/my-key ciphertext="vault:v1:..."

# Rotate key
vault write -f transit/keys/my-key/rotate
```

- Data is never stored in Vault - only encrypted/decrypted
- Supports key rotation without re-encrypting data
- Key types: aes256-gcm96, chacha20-poly1305, rsa-2048, etc.
- **[📖 Transit Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/transit)** - Encryption as a service

### PKI Secrets Engine
- Generates X.509 certificates dynamically
- Acts as a certificate authority (CA)
- Short-lived certificates eliminate CRL management
- Supports root and intermediate CAs
- **[📖 PKI Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/pki)** - PKI documentation

### Database Secrets Engine
```bash
# Enable database engine
vault secrets enable database

# Configure database connection
vault write database/config/my-db \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(db:3306)/" \
  allowed_roles="my-role" \
  username="vault-admin" \
  password="admin-password"

# Create role
vault write database/roles/my-role \
  db_name=my-db \
  creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';" \
  default_ttl="1h" \
  max_ttl="24h"

# Generate dynamic credentials
vault read database/creds/my-role
```

- Creates database credentials on demand
- Credentials automatically revoked when lease expires
- Supports MySQL, PostgreSQL, MongoDB, MSSQL, Oracle, and more
- **[📖 Database Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/databases)** - Dynamic database credentials

### AWS Secrets Engine
- Generates dynamic AWS IAM credentials
- Supports IAM users, STS AssumeRole, and STS Federation tokens
- Credentials automatically revoked when lease expires
- **[📖 AWS Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/aws)** - Dynamic AWS credentials

### Secrets Engine Comparison
| Engine | Type | Data Storage | Use Case |
|--------|------|-------------|----------|
| KV | Static | Stores secrets | Application configuration |
| Transit | Encryption | No storage (encrypt/decrypt) | Data encryption without storing |
| PKI | Dynamic | Generates certificates | TLS certificate management |
| Database | Dynamic | Generates credentials | Database access |
| AWS | Dynamic | Generates credentials | AWS access |

## Vault CLI Reference

### Essential Commands
```bash
# Server operations
vault status                          # Check Vault status (sealed/unsealed)
vault operator init                   # Initialize Vault
vault operator unseal                 # Provide unseal key
vault operator seal                   # Seal Vault

# Authentication
vault login                           # Login with token
vault login -method=userpass username=admin  # Login with userpass
vault login -method=ldap username=admin     # Login with LDAP

# Secrets operations
vault kv put secret/app key=value     # Write KV secret
vault kv get secret/app               # Read KV secret
vault kv list secret/                 # List secrets

# Auth and secrets engine management
vault auth enable approle             # Enable auth method
vault auth list                       # List auth methods
vault secrets enable -path=kv kv-v2   # Enable secrets engine
vault secrets list                    # List secrets engines

# Policy management
vault policy write my-policy policy.hcl  # Create policy
vault policy read my-policy              # Read policy
vault policy list                        # List policies
vault policy delete my-policy            # Delete policy
```

- **[📖 Vault CLI](https://developer.hashicorp.com/vault/docs/commands)** - Complete CLI reference

### Environment Variables
```bash
export VAULT_ADDR="https://vault.example.com:8200"  # Vault server address
export VAULT_TOKEN="hvs.xxxxx"                       # Authentication token
export VAULT_NAMESPACE="admin"                        # Namespace (Enterprise)
export VAULT_SKIP_VERIFY="true"                      # Skip TLS verification
export VAULT_FORMAT="json"                           # Output format
```

- **[📖 Environment Variables](https://developer.hashicorp.com/vault/docs/commands#environment-variables)** - CLI environment configuration

## Vault API

### API Structure
- RESTful API at `<VAULT_ADDR>/v1/`
- Authentication via `X-Vault-Token` header
- System endpoints under `/v1/sys/`
- Secrets engines at their mount paths

### Common API Calls
```bash
# Check health
curl $VAULT_ADDR/v1/sys/health

# Read a KV secret
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/secret/data/my-app

# Write a KV secret
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST -d '{"data":{"key":"value"}}' \
  $VAULT_ADDR/v1/secret/data/my-app

# List auth methods
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/sys/auth
```

- **[📖 Vault API](https://developer.hashicorp.com/vault/api-docs)** - Complete API reference
- **[📖 System Backend API](https://developer.hashicorp.com/vault/api-docs/system)** - sys/ endpoints

## Exam Tips

### High-Value Topics (by weight)
1. **Secrets engines (20%):** KV v1 vs v2, Transit, PKI, Database, dynamic secrets
2. **Auth methods (15%):** AppRole, human vs machine, choosing the right method
3. **Policies (15%):** Syntax, capabilities, deny overrides, path patterns
4. **CLI (15%):** Command syntax, flags, operations
5. **Architecture (10%):** Seal/unseal, storage backends, HA
6. **Tokens (10%):** Service vs batch, root, orphan, TTL, accessors
7. **Leases (5%):** Renewal, revocation, TTL
8. **UI (5%):** Basic navigation
9. **API (5%):** Structure, auth header, sys/ endpoints

### Common Exam Traps
- KV v2 paths include `/data/` in the API path but not in CLI `vault kv` commands
- Deny capability overrides all other capabilities on the same path
- Root tokens have no TTL and should be revoked after initial setup
- Batch tokens are not stored and cannot be renewed
- Transit engine does not store data - only encrypts/decrypts
- AppRole uses Role ID (like username) and Secret ID (like password)
- `vault operator init` generates both unseal keys and a root token
- Storage backends only see encrypted data - never plaintext
- The default policy is attached to every token and cannot be deleted
