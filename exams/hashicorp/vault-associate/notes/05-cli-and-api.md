# CLI and API Operations

**[📖 Vault CLI](https://developer.hashicorp.com/vault/docs/commands)** - CLI reference
**[📖 Vault API](https://developer.hashicorp.com/vault/api-docs)** - API reference

## Overview

This document covers Vault CLI commands, API operations, and environment variable configuration. CLI operations represent 15% of the exam and API 5%, making this a 20% combined weight. Many exam questions test exact command syntax and flags.

## Environment Variables

```bash
# Required: Vault server address
export VAULT_ADDR="https://vault.example.com:8200"

# Authentication token
export VAULT_TOKEN="hvs.xxxxxxxxxxxxx"

# Namespace (Enterprise only)
export VAULT_NAMESPACE="admin"

# Skip TLS verification (development only)
export VAULT_SKIP_VERIFY="true"

# Output format
export VAULT_FORMAT="json"   # json, table, yaml

# CA certificate for TLS
export VAULT_CACERT="/path/to/ca.pem"

# Client certificate (for TLS auth)
export VAULT_CLIENT_CERT="/path/to/client.pem"
export VAULT_CLIENT_KEY="/path/to/client-key.pem"
```

**[📖 Environment Variables](https://developer.hashicorp.com/vault/docs/commands#environment-variables)** - Variable reference

## Server Operations

```bash
# Check Vault status (sealed/unsealed, HA mode)
vault status

# Output includes:
# Seal Type: shamir
# Initialized: true
# Sealed: false
# Total Shares: 5
# Threshold: 3
# HA Enabled: true
# HA Mode: active

# Initialize Vault
vault operator init
vault operator init -key-shares=5 -key-threshold=3

# Unseal (provide one key at a time)
vault operator unseal <unseal_key>

# Seal Vault
vault operator seal

# Step down as leader (HA)
vault operator step-down

# Generate root token
vault operator generate-root -init
vault operator generate-root -nonce=<nonce> <unseal_key>
```

**[📖 Operator Commands](https://developer.hashicorp.com/vault/docs/commands/operator)** - Operator reference

## Authentication Commands

```bash
# Login with token (default method)
vault login <token>
vault login  # Prompts for token

# Login with userpass
vault login -method=userpass username=alice

# Login with LDAP
vault login -method=ldap username=alice

# Login with AppRole
vault write auth/approle/login role_id="xxx" secret_id="yyy"

# Login with AWS
vault login -method=aws role=my-app

# Login with Kubernetes
vault login -method=kubernetes role=my-app \
  jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

# Check current token
vault token lookup
```

## KV Secrets Operations

```bash
# KV v2 operations
vault kv put secret/app key1=value1 key2=value2
vault kv get secret/app
vault kv get -field=key1 secret/app
vault kv get -version=2 secret/app
vault kv get -format=json secret/app
vault kv list secret/
vault kv delete secret/app
vault kv undelete -versions=1 secret/app
vault kv destroy -versions=1 secret/app
vault kv metadata get secret/app
vault kv metadata delete secret/app

# Read from file
vault kv put secret/app @data.json

# Pipe input
echo '{"key":"value"}' | vault kv put secret/app -
```

## Auth and Secrets Engine Management

```bash
# Auth methods
vault auth enable approle
vault auth enable -path=corp-ldap ldap
vault auth list
vault auth list -detailed
vault auth tune -default-lease-ttl=2h auth/approle/
vault auth disable userpass
vault auth move auth/old-path/ auth/new-path/

# Secrets engines
vault secrets enable -path=kv kv-v2
vault secrets enable database
vault secrets enable transit
vault secrets list
vault secrets list -detailed
vault secrets tune -max-lease-ttl=24h database/
vault secrets disable kv/
vault secrets move secret/ kv/
```

## Policy Operations

```bash
# Create/update policy
vault policy write my-policy policy.hcl
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

# Format policy file
vault policy fmt policy.hcl
```

## Token Operations

```bash
# Create tokens
vault token create
vault token create -policy="my-policy" -ttl=1h
vault token create -policy="my-policy" -ttl=1h -max-ttl=24h
vault token create -orphan
vault token create -period=24h
vault token create -num-uses=5
vault token create -type=batch

# Token management
vault token lookup
vault token lookup <token>
vault token lookup -accessor <accessor>
vault token renew
vault token renew <token>
vault token renew -increment=2h
vault token revoke <token>
vault token revoke -accessor <accessor>
vault token revoke -self
```

## Lease Operations

```bash
# List leases
vault list sys/leases/lookup/database/creds/my-role

# Lookup lease
vault lease lookup <lease_id>

# Renew lease
vault lease renew <lease_id>
vault lease renew -increment=2h <lease_id>

# Revoke lease
vault lease revoke <lease_id>

# Revoke all leases under prefix
vault lease revoke -prefix database/creds/my-role
```

## Vault API

### API Structure
- Base URL: `<VAULT_ADDR>/v1/`
- Authentication: `X-Vault-Token` header
- Request body: JSON
- Response body: JSON
- System endpoints: `/v1/sys/`

**[📖 API Overview](https://developer.hashicorp.com/vault/api-docs)** - API reference

### Common API Calls

```bash
# Health check (no auth required)
curl $VAULT_ADDR/v1/sys/health

# Check seal status
curl $VAULT_ADDR/v1/sys/seal-status

# Read KV v2 secret (note /data/ in path)
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/secret/data/my-app

# Write KV v2 secret
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST \
  -d '{"data":{"key":"value"}}' \
  $VAULT_ADDR/v1/secret/data/my-app

# List secrets
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X LIST \
  $VAULT_ADDR/v1/secret/metadata/

# Delete secret (soft delete KV v2)
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X DELETE \
  $VAULT_ADDR/v1/secret/data/my-app

# Generate dynamic credentials
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/database/creds/my-role

# Encrypt with Transit
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST \
  -d '{"plaintext":"dGVzdA=="}' \
  $VAULT_ADDR/v1/transit/encrypt/my-key

# Decrypt with Transit
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  -X POST \
  -d '{"ciphertext":"vault:v1:xxx"}' \
  $VAULT_ADDR/v1/transit/decrypt/my-key

# List auth methods
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/sys/auth

# List secrets engines
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/sys/mounts

# Read policy
curl -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/sys/policies/acl/my-policy
```

### System Endpoints (sys/)
| Endpoint | Purpose |
|----------|---------|
| /v1/sys/health | Health check (no auth) |
| /v1/sys/seal-status | Seal status (no auth) |
| /v1/sys/init | Initialization status |
| /v1/sys/seal | Seal Vault |
| /v1/sys/unseal | Unseal Vault |
| /v1/sys/auth | List/manage auth methods |
| /v1/sys/mounts | List/manage secrets engines |
| /v1/sys/policies/acl | Manage ACL policies |
| /v1/sys/leases | Manage leases |
| /v1/sys/audit | Manage audit devices |

**[📖 System Backend](https://developer.hashicorp.com/vault/api-docs/system)** - sys/ API reference

## Vault UI

### Key UI Operations
- Login with any enabled auth method
- Browse and manage KV secrets
- Create, read, and delete policies
- Enable and configure auth methods
- Enable and configure secrets engines
- View and revoke leases
- Access at `<VAULT_ADDR>/ui`

**[📖 Vault UI](https://developer.hashicorp.com/vault/docs/configuration/ui)** - UI configuration

### UI Navigation
- **Secrets:** Browse secrets engines and manage data
- **Access:** Manage auth methods, policies, entities, groups
- **Policies:** Create and edit ACL policies
- **Tools:** Wrap, lookup, unwrap, rewrap operations

## Common Flag Patterns

```bash
# Output formatting
vault kv get -format=json secret/app          # JSON output
vault kv get -format=yaml secret/app          # YAML output
vault kv get -format=table secret/app         # Table output (default)

# Field extraction
vault kv get -field=password secret/app       # Single field

# Force (no confirmation)
vault write -f transit/keys/my-key            # Force write with no data

# Output only (useful in scripts)
vault kv get -field=password secret/app 2>/dev/null
```

## CLI Cheat Sheet

| Task | Command |
|------|---------|
| Check status | `vault status` |
| Login | `vault login` |
| Write secret | `vault kv put secret/path key=value` |
| Read secret | `vault kv get secret/path` |
| List secrets | `vault kv list secret/` |
| Enable auth | `vault auth enable <method>` |
| Enable engine | `vault secrets enable <engine>` |
| Write policy | `vault policy write <name> <file>` |
| Create token | `vault token create -policy=<name>` |
| Renew token | `vault token renew` |
| Renew lease | `vault lease renew <id>` |
| Revoke lease | `vault lease revoke <id>` |
