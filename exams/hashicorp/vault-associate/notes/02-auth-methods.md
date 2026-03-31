# Authentication Methods

**[📖 Auth Methods](https://developer.hashicorp.com/vault/docs/auth)** - Auth methods overview

## Overview

This document covers Vault authentication methods including token, userpass, LDAP, AppRole, AWS, and Kubernetes. Authentication methods represent 15% of the exam and are critical for understanding how entities prove their identity to Vault.

## Core Concept

- All auth methods ultimately produce a Vault token
- The token is used for all subsequent API calls
- Auth methods verify identity, then issue a token with attached policies
- Multiple auth methods can be enabled simultaneously
- Each auth method is enabled at a unique path

## Token Auth Method

### Overview
- Core authentication mechanism - always enabled, cannot be disabled
- All other auth methods produce tokens internally
- Token auth allows direct token-based authentication
- Root token created during `vault operator init`

**[📖 Token Auth](https://developer.hashicorp.com/vault/docs/auth/token)** - Token authentication

### Token Types
| Type | Stored | Renewable | Use Case |
|------|--------|-----------|----------|
| Service | Yes (in storage) | Yes | Default, full-featured |
| Batch | No (encrypted blob) | No | High-throughput, lightweight |
| Root | Yes | No TTL | Initial setup, emergency |
| Orphan | Yes | Yes | Independent lifecycle |
| Periodic | Yes | Indefinitely | Long-running services |

### Token Operations
```bash
# Create a child token
vault token create

# Create with policy and TTL
vault token create -policy="my-policy" -ttl=1h

# Create orphan token (no parent)
vault token create -orphan

# Create periodic token
vault token create -period=24h

# Lookup current token
vault token lookup

# Lookup by accessor
vault token lookup -accessor <accessor>

# Renew current token
vault token renew

# Revoke a token
vault token revoke <token>

# Revoke by accessor
vault token revoke -accessor <accessor>
```

### Token Properties
- **Token ID:** The secret string used for authentication
- **Accessor:** Non-sensitive reference to a token
- **TTL:** Time-to-live before expiration
- **Max TTL:** Maximum possible lifetime (even with renewals)
- **Num Uses:** Usage limit (0 = unlimited)
- **Policies:** List of policies attached
- **Display Name:** Human-readable label

### Token Hierarchy
- Tokens form a parent-child tree
- Revoking a parent revokes ALL children recursively
- Orphan tokens have no parent - independent lifecycle
- Root token is the top of the hierarchy

### Root Token Management
```bash
# Generate a new root token (requires unseal keys)
vault operator generate-root -init
vault operator generate-root -nonce=<nonce> <unseal_key_1>
vault operator generate-root -nonce=<nonce> <unseal_key_2>
vault operator generate-root -nonce=<nonce> <unseal_key_3>
# Decode the encoded token
vault operator generate-root -decode=<encoded_token> -otp=<otp>

# Revoke root token after use
vault token revoke <root_token>
```

- Root tokens should be revoked after initial setup
- New root tokens can be generated using unseal/recovery keys
- Root tokens have no TTL - they never expire
- Use root tokens sparingly and revoke immediately after use

## UserPass Auth

### Overview
- Simple username and password authentication
- Designed for human users
- Passwords stored internally in Vault
- Good for development and small teams

**[📖 UserPass Auth](https://developer.hashicorp.com/vault/docs/auth/userpass)** - Username/password auth

```bash
# Enable userpass auth
vault auth enable userpass

# Create user
vault write auth/userpass/users/alice \
  password="secretpassword" \
  policies="developer"

# Login
vault login -method=userpass username=alice

# Update user policies
vault write auth/userpass/users/alice \
  policies="developer,qa"

# Delete user
vault delete auth/userpass/users/alice
```

## LDAP Auth

### Overview
- Authenticates against external LDAP/Active Directory
- Maps LDAP groups to Vault policies
- Designed for enterprise human authentication
- Vault does not store passwords - delegates to LDAP server

**[📖 LDAP Auth](https://developer.hashicorp.com/vault/docs/auth/ldap)** - LDAP authentication

```bash
# Enable LDAP auth
vault auth enable ldap

# Configure LDAP connection
vault write auth/ldap/config \
  url="ldaps://ldap.example.com" \
  userdn="ou=Users,dc=example,dc=com" \
  groupdn="ou=Groups,dc=example,dc=com" \
  groupfilter="(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))" \
  groupattr="cn" \
  binddn="cn=vault-bind,ou=ServiceAccounts,dc=example,dc=com" \
  bindpass="bind-password" \
  starttls=true

# Map LDAP group to Vault policies
vault write auth/ldap/groups/engineers policies="developer,deploy"
vault write auth/ldap/groups/security policies="security-admin"

# Login with LDAP
vault login -method=ldap username=alice
```

## AppRole Auth

### Overview
- Machine-to-machine authentication
- Uses Role ID (like username) and Secret ID (like password)
- Best for CI/CD pipelines, applications, and automated systems
- Most commonly tested machine auth method on the exam

**[📖 AppRole Auth](https://developer.hashicorp.com/vault/docs/auth/approle)** - Machine authentication

### Components
- **Role ID:** Stable identifier for the application (not secret)
- **Secret ID:** Sensitive credential (can be one-time use, CIDR-restricted)
- **Token:** Issued upon successful login with Role ID + Secret ID

```bash
# Enable AppRole
vault auth enable approle

# Create a role
vault write auth/approle/role/my-app \
  token_ttl=1h \
  token_max_ttl=4h \
  token_policies="app-policy" \
  secret_id_ttl=24h \
  secret_id_num_uses=1

# Get Role ID (distribute to configuration)
vault read auth/approle/role/my-app/role-id
# role_id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Generate Secret ID (distribute securely)
vault write -f auth/approle/role/my-app/secret-id
# secret_id: yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy

# Login with AppRole
vault write auth/approle/login \
  role_id="xxxxxxxx" \
  secret_id="yyyyyyyy"
```

### Secret ID Security
- Secret IDs can be configured as one-time use (num_uses=1)
- CIDR restrictions limit which IPs can use the Secret ID
- Response wrapping delivers Secret ID securely
- Secret IDs have configurable TTL

### Delivery Pattern
1. Orchestrator fetches Role ID from Vault (not secret)
2. Orchestrator generates Secret ID (sensitive, short-lived)
3. Both delivered to the application through separate channels
4. Application combines both to authenticate and get a token

## AWS Auth

### Overview
- Authenticates AWS entities (EC2 instances, IAM roles, Lambda)
- Two methods: IAM and EC2
- No secrets need to be distributed to AWS workloads
- Vault validates identity with AWS APIs

**[📖 AWS Auth](https://developer.hashicorp.com/vault/docs/auth/aws)** - AWS workload authentication

```bash
# Enable AWS auth
vault auth enable aws

# Configure AWS auth backend
vault write auth/aws/config/client \
  access_key="AKIAIOSFODNN7EXAMPLE" \
  secret_key="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# Create IAM role mapping
vault write auth/aws/role/my-app \
  auth_type=iam \
  bound_iam_principal_arn="arn:aws:iam::123456789:role/my-app-role" \
  policies="app-policy" \
  ttl=1h

# Login from AWS instance (using IAM)
vault login -method=aws role=my-app
```

### IAM vs EC2 Auth
| Feature | IAM Auth | EC2 Auth |
|---------|---------|---------|
| Identity proof | Signed AWS API request | Instance identity document |
| Granularity | IAM role/user | Instance metadata |
| Works with | EC2, Lambda, ECS, EKS | EC2 only |
| Recommended | Yes (preferred) | Legacy use cases |

## Kubernetes Auth

### Overview
- Authenticates Kubernetes pods using service account tokens
- Vault validates service account JWT with K8s API
- Maps service accounts to Vault policies
- No secrets need to be stored in pod specs

**[📖 Kubernetes Auth](https://developer.hashicorp.com/vault/docs/auth/kubernetes)** - K8s pod authentication

```bash
# Enable Kubernetes auth
vault auth enable kubernetes

# Configure Kubernetes auth
vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc" \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_ca_cert="$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)"

# Create role mapping
vault write auth/kubernetes/role/my-app \
  bound_service_account_names="my-app-sa" \
  bound_service_account_namespaces="default" \
  policies="app-policy" \
  ttl=1h
```

## Auth Method Selection Guide

| Scenario | Auth Method | Reasoning |
|----------|------------|-----------|
| Human - small team | UserPass | Simple, internal |
| Human - enterprise | LDAP or OIDC | Existing directory |
| Human - SSO | OIDC | Browser-based SSO |
| Machine - CI/CD pipeline | AppRole | Role ID + Secret ID |
| Machine - AWS workload | AWS (IAM) | Native AWS identity |
| Machine - K8s pod | Kubernetes | Service account JWT |
| Machine - generic | AppRole | Universal machine auth |
| Emergency access | Token (root) | Direct token auth |

## Managing Auth Methods

```bash
# Enable auth method at custom path
vault auth enable -path=corp-ldap ldap

# List enabled auth methods
vault auth list

# Tune auth method
vault auth tune -default-lease-ttl=2h auth/approle/

# Disable auth method
vault auth disable userpass

# Move auth method (change path)
vault auth move auth/approle/ auth/app-auth/
```

**[📖 Auth Commands](https://developer.hashicorp.com/vault/docs/commands/auth)** - CLI reference
