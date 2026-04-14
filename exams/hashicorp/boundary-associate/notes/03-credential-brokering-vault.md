# Credential Brokering and Vault Integration

One of Boundary's killer features is dynamic credential management during sessions. Instead of giving users long-lived SSH keys or database passwords, Boundary can fetch short-lived credentials from Vault at session time, pass them to the user (brokering) or use them on the user's behalf without exposing them (injection), and revoke them when the session ends.

## Concepts

- **Credential Store:** the source of credentials (static or Vault)
- **Credential Library (Vault only):** a specific query against the credential store (e.g., a Vault path to read)
- **Credential:** the actual value; static or produced by a library
- **Attachment:** credentials or libraries are attached to targets as brokered or injected

## Static Credential Store (`csst_`)

Credentials are stored directly in Boundary (encrypted at rest via KMS).

```
boundary credential-stores create static \
  -scope-id=p_... \
  -name=local-creds
```

Create credentials:

```
boundary credentials create username-password \
  -credential-store-id=csst_... \
  -username=admin \
  -password=s3cret \
  -name=admin-creds

boundary credentials create ssh-private-key \
  -credential-store-id=csst_... \
  -username=ubuntu \
  -private-key=file:///path/to/key \
  -name=ssh-key

boundary credentials create json \
  -credential-store-id=csst_... \
  -object file://./creds.json
```

Static stores are appropriate for:

- Credentials that don't change often
- Bootstrap scenarios (before Vault integration)
- Small deployments

For real secret management, prefer Vault.

## Vault Credential Store (`csvlt_`)

Boundary integrates with Vault to fetch credentials dynamically.

### Setup

1. In Vault, configure the secrets engines Boundary will read from (database, ssh, kv, etc.).
2. Create a Vault policy granting read access to those paths.
3. Create a Vault token tied to that policy (ideally a periodic token or use AppRole/JWT).
4. In Boundary, create the credential store:

```
boundary credential-stores create vault \
  -scope-id=p_... \
  -vault-address=https://vault.example.com:8200 \
  -vault-token=s.abc123 \
  -name=vault-store \
  -vault-namespace=platform
```

### Credential Libraries

A library defines a specific credential type and path:

```
boundary credential-libraries create vault-generic \
  -credential-store-id=csvlt_... \
  -vault-path="database/creds/readonly" \
  -name=db-readonly
```

Library types:

- `vault-generic`: any Vault read returns a credential
- `vault-ssh-certificate`: use Vault's SSH CA to sign a cert for the session

For SSH cert libraries:

```
boundary credential-libraries create vault-ssh-certificate \
  -credential-store-id=csvlt_... \
  -vault-path="ssh/sign/admin" \
  -username=admin \
  -name=ssh-signed \
  -additional-valid-principals=ubuntu
```

### Attaching to Targets

Brokered (client sees credentials):

```
boundary targets add-credential-sources \
  -id=ttcp_... \
  -brokered-credential-source=clvlt_...
```

Injected (client does not see credentials, SSH targets only):

```
boundary targets add-credential-sources \
  -id=tssh_... \
  -injected-application-credential-source=clvlt_...
```

## Brokering vs Injection

### Brokering

1. User requests session
2. Boundary fetches credential from Vault
3. Boundary passes credential to the client via session response
4. Client uses credential to auth to the target
5. Session ends; Boundary revokes the Vault lease

The user sees the credential. Suitable when the client tool needs the credential to function (database CLI, custom app).

### Injection

1. User requests session
2. Boundary fetches credential from Vault
3. Worker uses credential during the SSH handshake with the target
4. Client proxy transparently passes through
5. User never sees the credential
6. Session ends; Vault lease revoked

The user cannot exfiltrate the credential. Suitable for SSH where admin ops are the goal but the user doesn't need the key.

**Injection is SSH-only.** TCP targets cannot inject because the protocol is opaque to the worker.

## Vault Policy Example for Boundary

```hcl
# Read database dynamic creds
path "database/creds/readonly" {
  capabilities = ["read"]
}

# Sign SSH certs
path "ssh/sign/admin" {
  capabilities = ["create", "update"]
}

# Read static KV
path "kv/data/apps/myapp" {
  capabilities = ["read"]
}

# Revoke leases Boundary owns
path "sys/leases/revoke" {
  capabilities = ["update"]
}
```

Attach to a token or AppRole used by Boundary's credential store.

## Lease Management

When Boundary uses Vault credentials, Vault creates a lease. Boundary records the lease ID. On session termination, Boundary calls Vault's revoke endpoint, invalidating the credential immediately.

If the lease expires before session termination (TTL shorter than session), the credential stops working mid-session. Configure TTLs to be at least as long as session max duration.

## Common Credential Flows

### Dynamic PostgreSQL Password (Brokered)

1. Vault's database secrets engine creates a user in PostgreSQL with TTL 1h
2. Boundary brokers username/password to client
3. Client uses psql with those credentials
4. Session ends, Boundary revokes, PostgreSQL user is dropped

### Signed SSH Certificate (Injected)

1. User has an SSH public key (or Boundary generates one)
2. Vault's SSH CA signs a cert with TTL 1h, principals constrained to `admin`
3. Worker uses signed cert to SSH into target
4. User sees only the resulting shell, not the cert or private key
5. Session ends, lease revoked

### Static KV Password (Brokered)

1. Vault stores a service account password at `kv/data/apps/myapp`
2. Boundary reads on session request, brokers to client
3. Client uses credentials

Useful when true dynamic creds aren't possible (shared service account).

## Credential Types

Boundary recognizes several credential subtypes:

- **username-password:** two-field structure
- **ssh-private-key:** username + private key + optional passphrase
- **json:** arbitrary JSON blob; client parses

Vault libraries return any of these based on the response shape or configuration.

## Error Handling

Common failures:

- **Vault token expired:** credential store can't fetch; sessions fail to authorize with credentials. Use periodic tokens or auto-rotation.
- **Policy missing:** Boundary gets 403 from Vault; session fails.
- **Lease revoke fails:** rare; verify Boundary's token has `sys/leases/revoke`.
- **Target rejects credential:** fresh credential is valid but target not configured (e.g., CA trust not established).

Inspect via `boundary sessions read -id=s_...` and Vault's audit log.

## Credential Rotation for Boundary's Own Token

Boundary's token into Vault is itself a credential. Best practices:

- Use Vault AppRole or JWT auth so Boundary gets short-lived tokens
- Rotate periodically via automation
- Tie the token's TTL to rotation cadence
- Audit Vault access per Boundary credential store

If a token expires mid-flight, Boundary will fail to fetch credentials until renewed.

## HCP Boundary and HCP Vault

HCP Boundary integrates seamlessly with HCP Vault. Use HCP Vault's AppRole auth with Boundary; configure through the HCP UI. Eliminates token-management overhead.

## Terraform Example

```hcl
resource "boundary_credential_store_vault" "main" {
  name      = "prod-vault"
  scope_id  = boundary_scope.project.id
  address   = "https://vault.example.com:8200"
  token     = var.vault_boundary_token
  namespace = "platform"
}

resource "boundary_credential_library_vault" "db_readonly" {
  name                = "db-readonly"
  credential_store_id = boundary_credential_store_vault.main.id
  path                = "database/creds/readonly"
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_target" "postgres" {
  type                      = "tcp"
  name                      = "postgres-prod"
  scope_id                  = boundary_scope.project.id
  default_port              = 5432
  brokered_credential_source_ids = [
    boundary_credential_library_vault.db_readonly.id,
  ]
}
```

## Security Considerations

- Always use sensitive-variable handling for the Vault token
- Scope Vault policies tightly (no wildcards unless needed)
- Prefer injection over brokering when possible
- Set short Vault TTLs; let leases naturally limit exposure
- Log and monitor credential-store creation and rotation

## Exam-Ready Checklist

- [ ] Can explain brokering vs injection and which target types support each
- [ ] Can create a Vault credential store and library via CLI
- [ ] Know credential types (username-password, ssh-private-key, json)
- [ ] Understand Vault lease lifecycle with sessions
- [ ] Can write a minimal Vault policy for Boundary
- [ ] Know SSH-certificate library vs generic library use cases
