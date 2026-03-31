# Secrets Engines

**[📖 Secrets Engines](https://developer.hashicorp.com/vault/docs/secrets)** - Secrets engines overview

## Overview

This document covers Vault secrets engines including KV (v1 and v2), Transit, PKI, Database, and AWS. Secrets engines represent 20% of the exam - the highest-weighted domain - and require understanding both configuration and use case selection.

## KV Secrets Engine

### KV v1 vs v2
| Feature | KV v1 | KV v2 |
|---------|-------|-------|
| Versioning | No | Yes (configurable max versions) |
| Soft delete | No | Yes (undelete possible) |
| Destroy | No | Yes (permanent delete) |
| Metadata | No | Yes (custom metadata per secret) |
| Check-and-set | No | Yes (CAS parameter) |
| API path | `<mount>/key` | `<mount>/data/key` |
| Metadata path | N/A | `<mount>/metadata/key` |

**[📖 KV v2](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2)** - KV version 2
**[📖 KV v1](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v1)** - KV version 1

### KV v2 Operations
```bash
# Enable KV v2
vault secrets enable -path=secret kv-v2

# Write a secret
vault kv put secret/my-app/config username="admin" password="s3cret"

# Read a secret
vault kv get secret/my-app/config

# Read specific field
vault kv get -field=password secret/my-app/config

# Read specific version
vault kv get -version=2 secret/my-app/config

# List secrets
vault kv list secret/my-app/

# Delete (soft delete - can undelete)
vault kv delete secret/my-app/config

# Undelete version
vault kv undelete -versions=1 secret/my-app/config

# Permanently destroy version
vault kv destroy -versions=1 secret/my-app/config

# Delete all versions and metadata
vault kv metadata delete secret/my-app/config

# Read metadata
vault kv metadata get secret/my-app/config

# Set custom metadata
vault kv metadata put -custom-metadata=team="platform" secret/my-app/config
```

### KV v2 Path Differences (Exam Trap)
```
CLI command:      vault kv get secret/my-app
API path:         /v1/secret/data/my-app    (note /data/ in API)
Metadata API:     /v1/secret/metadata/my-app
Delete API:       /v1/secret/data/my-app    (HTTP DELETE)
Destroy API:      /v1/secret/destroy/my-app (HTTP POST)
```

- CLI `vault kv` commands do NOT include `/data/` in the path
- API calls MUST include `/data/` in the path for KV v2
- Policy paths MUST include `/data/` for read/write operations
- This is one of the most commonly tested exam traps

### Check-and-Set (CAS)
```bash
# Write with check-and-set (prevent accidental overwrites)
vault kv put -cas=0 secret/my-app/config key=value  # Only if key doesn't exist
vault kv put -cas=3 secret/my-app/config key=newvalue  # Only if current version is 3
```

## Transit Secrets Engine

### Overview
- Encryption as a Service - encrypts/decrypts data without storing it
- Vault manages encryption keys internally
- Application sends plaintext, receives ciphertext (and vice versa)
- Supports key rotation without re-encrypting data
- Data never stored in Vault - only encrypted/decrypted

**[📖 Transit Engine](https://developer.hashicorp.com/vault/docs/secrets/transit)** - Encryption as a service

### Operations
```bash
# Enable Transit
vault secrets enable transit

# Create encryption key
vault write -f transit/keys/my-key

# Encrypt data (base64-encoded plaintext required)
vault write transit/encrypt/my-key \
  plaintext=$(echo -n "secret data" | base64)
# Returns: ciphertext = vault:v1:xxxxxxxxxxxxx

# Decrypt data
vault write transit/decrypt/my-key \
  ciphertext="vault:v1:xxxxxxxxxxxxx"
# Returns: plaintext = c2VjcmV0IGRhdGE= (base64)
# Decode: echo "c2VjcmV0IGRhdGE=" | base64 -d

# Rotate key
vault write -f transit/keys/my-key/rotate
# New data uses v2, existing v1 ciphertext still decryptable

# Rewrap (re-encrypt with latest key version)
vault write transit/rewrap/my-key \
  ciphertext="vault:v1:xxxxxxxxxxxxx"
# Returns: vault:v2:yyyyyyyyyyyyy
```

### Key Types
| Type | Algorithm | Use Case |
|------|-----------|----------|
| aes256-gcm96 | AES-256-GCM | General encryption (default) |
| chacha20-poly1305 | ChaCha20 | Performance on non-AES hardware |
| rsa-2048 | RSA-2048 | Asymmetric encryption/signing |
| rsa-4096 | RSA-4096 | Stronger asymmetric |
| ecdsa-p256 | ECDSA P-256 | Digital signatures |
| ed25519 | EdDSA | Digital signatures |

### Key Rotation
- New key version created, old versions retained
- Existing ciphertext still decryptable with old key version
- New encryptions use latest key version
- `vault:v1:xxx` = encrypted with key version 1
- `vault:v2:xxx` = encrypted with key version 2
- Rewrap operation re-encrypts with latest version

## PKI Secrets Engine

### Overview
- Certificate authority (CA) that generates X.509 certificates
- Dynamic certificate issuance with configurable TTL
- Short-lived certificates reduce compromise risk
- Supports root and intermediate CA hierarchy

**[📖 PKI Engine](https://developer.hashicorp.com/vault/docs/secrets/pki)** - PKI documentation

```bash
# Enable PKI
vault secrets enable pki

# Set max lease TTL
vault secrets tune -max-lease-ttl=87600h pki

# Generate root CA
vault write pki/root/generate/internal \
  common_name="Example Root CA" \
  ttl=87600h

# Create role for issuing certificates
vault write pki/roles/web-server \
  allowed_domains="example.com" \
  allow_subdomains=true \
  max_ttl=72h

# Issue a certificate
vault write pki/issue/web-server \
  common_name="web.example.com" \
  ttl=24h
```

### Best Practices
- Use intermediate CA for issuing certificates (not root)
- Keep root CA offline or with very restricted access
- Set short TTLs (hours to days) for issued certificates
- Use separate PKI mounts for root and intermediate CAs

## Database Secrets Engine

### Overview
- Generates dynamic database credentials on demand
- Credentials unique per request and automatically revoked
- Supports MySQL, PostgreSQL, MongoDB, MSSQL, Oracle, and more
- Credential lifecycle managed via Vault leases

**[📖 Database Engine](https://developer.hashicorp.com/vault/docs/secrets/databases)** - Dynamic database credentials

```bash
# Enable database engine
vault secrets enable database

# Configure database connection
vault write database/config/my-postgres \
  plugin_name=postgresql-database-plugin \
  allowed_roles="app-role" \
  connection_url="postgresql://{{username}}:{{password}}@db:5432/mydb?sslmode=disable" \
  username="vault-admin" \
  password="admin-password"

# Rotate root credentials (Vault manages the password)
vault write -f database/rotate-root/my-postgres

# Create role with creation statements
vault write database/roles/app-role \
  db_name=my-postgres \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl=1h \
  max_ttl=24h

# Generate dynamic credentials
vault read database/creds/app-role
# username: v-token-app-role-xxxxx
# password: A1a-yyyyyyyyy
# lease_id: database/creds/app-role/zzzzz
# lease_duration: 1h
```

### Credential Lifecycle
1. Application requests credentials from Vault
2. Vault creates unique database user with configured permissions
3. Vault returns credentials with a lease ID and TTL
4. Application uses credentials to connect to database
5. When lease expires, Vault revokes the database user
6. Application must request new credentials before lease expiry

## AWS Secrets Engine

### Overview
- Generates dynamic AWS IAM credentials
- Three credential types: IAM user, STS AssumeRole, STS Federation
- Credentials automatically revoked when lease expires

**[📖 AWS Engine](https://developer.hashicorp.com/vault/docs/secrets/aws)** - Dynamic AWS credentials

```bash
# Enable AWS secrets engine
vault secrets enable aws

# Configure root credentials
vault write aws/config/root \
  access_key="AKIAIOSFODNN7EXAMPLE" \
  secret_key="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
  region=us-east-1

# Create role for STS AssumeRole
vault write aws/roles/deploy \
  credential_type=assumed_role \
  role_arns="arn:aws:iam::123456789:role/deploy-role"

# Generate credentials
vault read aws/creds/deploy
```

## Secrets Engine Management

```bash
# Enable at custom path
vault secrets enable -path=team-kv kv-v2

# List enabled engines
vault secrets list

# Tune engine (change default TTL)
vault secrets tune -default-lease-ttl=2h database/

# Disable engine (removes all data!)
vault secrets disable team-kv/

# Move engine to new path
vault secrets move secret/ kv/
```

## Engine Selection Guide

| Need | Engine | Why |
|------|--------|-----|
| Store application config | KV (v2) | Static key-value storage |
| Encrypt data without storing | Transit | Encryption as a service |
| Generate TLS certificates | PKI | Dynamic certificate issuance |
| Database access | Database | Dynamic, short-lived credentials |
| AWS access | AWS | Dynamic IAM credentials |
| SSH access | SSH | Dynamic SSH credentials/signing |
