# Policies and Tokens

**[📖 Policies](https://developer.hashicorp.com/vault/docs/concepts/policies)** - Policy documentation
**[📖 Tokens](https://developer.hashicorp.com/vault/docs/concepts/tokens)** - Token documentation

## Overview

This document covers Vault policies, tokens, and leases - together worth 30% of the exam (15% policies, 10% tokens, 5% leases). Understanding policy syntax, token types, and lease management is essential for the Vault Associate certification.

## Policies

### Policy Basics
- Written in HCL (HashiCorp Configuration Language)
- Path-based permissions with capabilities
- Policies are deny-by-default - only explicitly granted access is allowed
- Multiple policies can be attached to a token (union of permissions)
- `deny` capability overrides ALL other capabilities on the same path

### Built-in Policies
| Policy | Description | Modifiable | Deletable |
|--------|------------|------------|-----------|
| root | Superuser - all capabilities on all paths | No | No |
| default | Basic self-management (attached to all tokens) | Yes | No |

### Capabilities
| Capability | HTTP Verb | Description |
|------------|-----------|-------------|
| create | POST/PUT | Create new data at a path |
| read | GET | Read data at a path |
| update | POST/PUT | Update existing data at a path |
| delete | DELETE | Delete data at a path |
| list | LIST | List keys at a path |
| sudo | N/A | Access sudo-protected paths (sys/) |
| deny | N/A | Explicitly deny access (overrides all) |

### Policy Syntax
```hcl
# Read and list KV secrets
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}

# Full access to a specific path
path "secret/data/my-app/config" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Deny access (overrides any other policy)
path "secret/data/admin/*" {
  capabilities = ["deny"]
}

# Transit encrypt/decrypt (uses update, not read/create)
path "transit/encrypt/my-key" {
  capabilities = ["update"]
}
path "transit/decrypt/my-key" {
  capabilities = ["update"]
}

# Generate database credentials
path "database/creds/app-role" {
  capabilities = ["read"]
}

# Manage auth methods (sudo required for sys/ paths)
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}
```

### Path Patterns
| Pattern | Matches | Example |
|---------|---------|---------|
| `secret/data/app` | Exact path only | secret/data/app |
| `secret/data/app/*` | Any one segment after | secret/data/app/config |
| `secret/data/+/config` | Single wildcard segment | secret/data/myapp/config |
| `secret/data/app/{{identity.entity.name}}` | Templated with entity | secret/data/app/alice |

### Policy Management
```bash
# Write policy from file
vault policy write my-policy policy.hcl

# Write policy inline
vault policy write my-policy - <<EOF
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}
EOF

# Read policy
vault policy read my-policy

# List policies
vault policy list

# Delete policy
vault policy delete my-policy

# Format/validate policy
vault policy fmt policy.hcl
```

### Policy Gotchas
- KV v2: policy paths must include `/data/` for read/write operations
- Transit: encrypt and decrypt use `update` capability, not `read`
- `deny` on a path overrides ALL other policies granting access to that path
- `list` capability is separate from `read` - both may be needed
- Default policy is attached to every token - review its permissions
- Policies are additive across multiple policies (except deny)

## Tokens Deep Dive

### Token Types Comparison
| Property | Service Token | Batch Token |
|----------|--------------|-------------|
| Stored in backend | Yes | No (encrypted blob) |
| Renewable | Yes | No |
| Has accessor | Yes | No |
| Has cubbyhole | Yes | No |
| Performance | Standard | Higher (no storage I/O) |
| Revocable | Yes (explicit) | Only with parent |
| Use case | General purpose | High-throughput, short-lived |

### Token TTL and Renewal
```bash
# Create token with TTL
vault token create -ttl=1h -policy=my-policy

# Renew token (extends TTL up to max_ttl)
vault token renew
vault token renew -increment=2h

# Token TTL lifecycle:
# 1. Token created with TTL=1h, max_ttl=24h
# 2. After 45 min, renewed: TTL resets to 1h
# 3. Can keep renewing until max_ttl (24h total lifetime)
# 4. After 24h from creation, token expires regardless of renewal
```

### TTL Hierarchy
```
System max TTL (768h = 32 days)
  └── Auth method max TTL
        └── Role max TTL
              └── Token max TTL
                    └── Token TTL (renewable up to max TTL)
```

### Token Accessors
- Non-sensitive reference to a token
- Can look up token properties without the token itself
- Can revoke a token using only its accessor
- Used for audit logging (token ID is never logged)
- Batch tokens do not have accessors

```bash
# List token accessors
vault list auth/token/accessors

# Lookup by accessor
vault token lookup -accessor <accessor>

# Revoke by accessor
vault token revoke -accessor <accessor>
```

### Orphan Tokens
```bash
# Create orphan token
vault token create -orphan -policy=my-policy

# Orphan properties:
# - No parent token
# - Not revoked when creator's token is revoked
# - Independent lifecycle
# - Useful for long-running processes
```

### Periodic Tokens
```bash
# Create periodic token (renewable indefinitely)
vault token create -period=24h -policy=my-policy

# Properties:
# - Has a period instead of max TTL
# - Can be renewed indefinitely as long as renewed within period
# - Each renewal resets the TTL to the period value
# - If not renewed within period, token expires
```

## Leases

### Lease Concepts
- Every dynamic secret has a lease
- Lease ID uniquely identifies the secret and its lifecycle
- Lease duration = how long the secret is valid
- When lease expires, secret is automatically revoked
- Leases can be renewed (up to max TTL)

**[📖 Leases](https://developer.hashicorp.com/vault/docs/concepts/lease)** - Lease documentation

### Lease Operations
```bash
# List leases (by prefix)
vault list sys/leases/lookup/database/creds/app-role

# Lookup lease details
vault lease lookup <lease_id>

# Renew a lease
vault lease renew <lease_id>
vault lease renew -increment=2h <lease_id>

# Revoke a specific lease
vault lease revoke <lease_id>

# Revoke all leases under a prefix
vault lease revoke -prefix database/creds/app-role

# Force revoke (no cleanup, last resort)
vault lease revoke -force <lease_id>
```

### Lease vs Token TTL
| Property | Token TTL | Lease |
|----------|----------|-------|
| Applies to | Authentication tokens | Dynamic secrets |
| Renewal | `vault token renew` | `vault lease renew` |
| Revocation | `vault token revoke` | `vault lease revoke` |
| Max lifetime | Max TTL | Max TTL |
| Auto-expiry | Token becomes invalid | Credentials revoked |
| Prefix revoke | By accessor | By path prefix |

### Dynamic Secret Lifecycle
```
1. Client requests credentials:     vault read database/creds/app-role
2. Vault creates credentials:       username=v-token-xxx, password=yyy
3. Vault returns with lease:         lease_id=database/creds/app-role/zzz, lease_duration=1h
4. Client uses credentials
5. Before expiry, client renews:     vault lease renew database/creds/app-role/zzz
6. When lease expires:               Vault revokes database user automatically
```

## Identity System

### Entities
- Represent a single person or machine across auth methods
- One entity can have multiple aliases (one per auth method)
- Policies can be attached to entities
- Entity ID can be used in templated policies

### Aliases
- Map an auth method identity to a Vault entity
- Example: LDAP username "alice" maps to entity "alice-entity"
- Example: AppRole role "my-app" maps to entity "my-app-entity"
- Automatically created or manually managed

### Groups
- Collection of entities or other groups
- Internal groups: manually managed membership
- External groups: membership from auth method (LDAP groups, etc.)
- Policies attached to groups apply to all members

**[📖 Identity](https://developer.hashicorp.com/vault/docs/concepts/identity)** - Identity system
