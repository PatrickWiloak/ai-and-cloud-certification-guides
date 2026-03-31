# Vault Associate - High-Yield Scenarios and Patterns

## Authentication Method Selection

### Application Authentication in Kubernetes
**Scenario:** Your team runs microservices on Kubernetes and needs each pod to authenticate to Vault automatically to retrieve database credentials. The solution should not require embedding tokens or passwords in the application code.

**Solution Pattern:**
- **Auth Method:** Kubernetes authentication
- **Identity:** Kubernetes service account tokens
- **Configuration:** Vault validates service account JWT with the Kubernetes API
- **Role Mapping:** Map Kubernetes service accounts to Vault policies
- **Access:** Pods authenticate automatically using their service account

**Common Distractors:**
- Hardcoding Vault tokens in environment variables (wrong - security risk, no rotation)
- Using userpass auth for pods (wrong - designed for humans, requires password management)
- Using AppRole with Secret ID baked into container images (wrong - Secret ID would be exposed)
- Using token auth with long-lived tokens (wrong - no automatic rotation, hard to manage)

### CI/CD Pipeline Authentication
**Scenario:** A Jenkins CI/CD pipeline needs to authenticate to Vault to retrieve deployment secrets. The pipeline runs on dynamically provisioned agents that are short-lived.

**Solution Pattern:**
- **Auth Method:** AppRole authentication
- **Role ID:** Configured in Jenkins as a credential (known, stable)
- **Secret ID:** Generated per build or wrapped for delivery
- **Token TTL:** Short-lived tokens matching build duration
- **Policies:** Scoped to only the secrets the pipeline needs

**Common Distractors:**
- Using a root token for the pipeline (wrong - violates least privilege)
- Using userpass with shared credentials (wrong - no accountability per build)
- Using LDAP auth for a machine (wrong - LDAP is designed for human authentication)
- Storing a long-lived Vault token in Jenkins (wrong - no rotation, blast radius)

### Enterprise SSO Integration
**Scenario:** An organization wants developers to authenticate to Vault using their existing corporate credentials managed by an identity provider (IdP) like Okta.

**Solution Pattern:**
- **Auth Method:** OIDC authentication
- **Configuration:** Configure Vault as an OIDC client with the IdP
- **Role Mapping:** Map IdP groups/claims to Vault policies
- **User Experience:** Browser-based login redirect to IdP

**Common Distractors:**
- Creating individual userpass accounts for each developer (wrong - duplicates identity management)
- Using GitHub auth when company uses Okta (wrong - wrong identity provider)
- Distributing tokens directly to developers (wrong - no SSO experience)
- Using AppRole for human developers (wrong - AppRole is designed for machines)

## Policy Design Scenarios

### Least Privilege Policy
**Scenario:** An application needs read-only access to secrets under `secret/data/my-app/` but should have no access to secrets under `secret/data/admin/`. The application also needs to encrypt and decrypt data using the Transit engine.

**Solution Pattern:**
```hcl
# Read secrets for the application
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}

# Explicitly deny admin secrets
path "secret/data/admin/*" {
  capabilities = ["deny"]
}

# Transit encryption and decryption
path "transit/encrypt/my-key" {
  capabilities = ["update"]
}

path "transit/decrypt/my-key" {
  capabilities = ["update"]
}
```

**Common Distractors:**
- Using `capabilities = ["read"]` on transit paths (wrong - encrypt/decrypt use update)
- Omitting the deny rule (wrong - without explicit deny, a broader policy could grant access)
- Using `sudo` capability for regular operations (wrong - sudo is for protected system paths)
- Granting `create` capability for read-only access (wrong - violates least privilege)

### Team-Based Access Control
**Scenario:** The DevOps team needs full CRUD access to their secrets path, the QA team needs read-only access, and no team should access the other's secrets.

**Solution Pattern:**
```hcl
# DevOps policy
path "secret/data/devops/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# QA read-only policy
path "secret/data/qa/*" {
  capabilities = ["read", "list"]
}
```

**Common Distractors:**
- Using the root policy for DevOps (wrong - root has unlimited access to everything)
- Creating a single shared policy (wrong - violates separation of concerns)
- Using `path "secret/*"` for both teams (wrong - too broad, crosses boundaries)
- Forgetting `list` capability (wrong - prevents browsing available secrets)

## Secrets Engine Scenarios

### Static vs Dynamic Secrets
**Scenario:** An application needs to connect to a PostgreSQL database. The security team requires that database credentials rotate automatically and are unique per application instance.

**Solution Pattern:**
- **Engine:** Database secrets engine
- **Dynamic Credentials:** Unique username/password generated per request
- **Lease:** Credentials automatically revoked when lease expires
- **No shared passwords:** Each application instance gets unique credentials

```bash
# Configure database connection
vault write database/config/mydb \
  plugin_name=postgresql-database-plugin \
  allowed_roles="app-role" \
  connection_url="postgresql://{{username}}:{{password}}@db:5432/mydb" \
  username="vault-admin" \
  password="admin-pass"

# Create role with TTL
vault write database/roles/app-role \
  db_name=mydb \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
  default_ttl="1h" \
  max_ttl="24h"

# Get dynamic credentials
vault read database/creds/app-role
```

**Common Distractors:**
- Using KV engine to store a shared database password (wrong - static, no rotation, shared)
- Rotating credentials manually on a schedule (wrong - Vault automates this)
- Using Transit to encrypt the database password (wrong - Transit encrypts data, does not generate credentials)
- Setting very long lease TTLs (wrong - defeats the purpose of dynamic secrets)

### Encryption Without Storage
**Scenario:** Your application processes credit card numbers and needs to encrypt them before storing in a database. The application should not manage encryption keys directly.

**Solution Pattern:**
- **Engine:** Transit secrets engine
- **Operation:** Encrypt data via Vault API, store ciphertext in application database
- **Key Management:** Vault manages encryption keys internally
- **Key Rotation:** Rotate keys without re-encrypting existing data

**Common Distractors:**
- Storing credit card numbers in KV engine (wrong - Vault becomes the database, not intended for high-volume data)
- Using PKI engine (wrong - PKI is for certificates, not data encryption)
- Managing encryption keys in the application (wrong - Transit eliminates this need)
- Using database engine (wrong - generates credentials, does not encrypt data)

### Certificate Management
**Scenario:** Your organization needs to issue TLS certificates for internal services with short lifetimes to reduce the risk of compromised certificates.

**Solution Pattern:**
- **Engine:** PKI secrets engine
- **Root CA:** Create root CA (offline, for signing intermediate)
- **Intermediate CA:** Issue certificates from intermediate CA
- **Short TTL:** Certificates with hours or days TTL
- **Automation:** Services request certificates via API/CLI

**Common Distractors:**
- Using Transit engine for certificates (wrong - Transit is for encryption, not certificate issuance)
- Using KV to store manually-generated certificates (wrong - no automation, no rotation)
- Creating long-lived certificates (wrong - increases risk window)
- Using a single root CA for all issuance (wrong - intermediate CA is best practice)

## Token and Lease Management

### Batch Token for High-Throughput
**Scenario:** A serverless function needs to authenticate to Vault thousands of times per second. Token creation and storage overhead is causing performance issues.

**Solution Pattern:**
- **Token Type:** Batch tokens
- **Properties:** Not stored in Vault storage, self-contained encrypted blob
- **Performance:** Significantly lower overhead for creation and validation
- **Tradeoff:** Cannot be renewed, no accessors, no cubbyhole

**Common Distractors:**
- Using service tokens with very short TTLs (wrong - storage overhead remains)
- Using root tokens (wrong - security risk, no scoping)
- Caching service tokens (wrong - adds complexity, batch tokens solve the root cause)
- Disabling token creation limits (wrong - does not address storage overhead)

### Root Token Management
**Scenario:** After initial Vault setup, the root token needs to be handled securely. The team also needs a process for emergency access.

**Solution Pattern:**
- **Revoke:** Revoke the root token after initial configuration
- **Generate:** Use `vault operator generate-root` for emergency access
- **Audit:** Log all root token generation and usage
- **Unseal keys:** Requires threshold of unseal keys to generate new root token

**Common Distractors:**
- Storing the root token in a password manager (wrong - should be revoked, not stored)
- Creating a long-lived admin token as backup (wrong - revoke root and generate when needed)
- Keeping the root token active "just in case" (wrong - running root token is a security risk)
- Using auto-unseal alone for emergency access (wrong - auto-unseal does not grant root access)

## Architecture Scenarios

### Vault High Availability
**Scenario:** Your organization requires zero-downtime for Vault operations. What architecture should you deploy?

**Solution Pattern:**
- **Cluster:** Multiple Vault nodes with HA-capable storage
- **Storage:** Integrated Storage (Raft) or Consul
- **Active/Standby:** One active node handles requests, standby nodes forward
- **Auto-Unseal:** Use cloud KMS to avoid manual unsealing after restarts
- **Load Balancer:** Direct traffic to active node (standby handles redirect)

**Common Distractors:**
- Using S3 storage backend (wrong - S3 does not support HA)
- Running a single Vault server with redundancy at the VM level (wrong - not HA at application level)
- Using active/active mode (wrong - Vault uses active/standby, not active/active)
- Sharing the same unseal keys across environments (wrong - each cluster should have its own)

## Key Decision Factors

### When to Use Which Approach
1. **KV vs Dynamic Secrets:** KV for static configuration, dynamic for database/cloud credentials
2. **Transit vs KV:** Transit when app stores data externally, KV when Vault stores secrets
3. **AppRole vs Kubernetes:** AppRole for generic machines, Kubernetes for K8s pods
4. **Service vs Batch tokens:** Service for renewable long-lived, batch for high-throughput short-lived
5. **Raft vs Consul storage:** Raft for simplicity (no external dependencies), Consul for existing Consul users
