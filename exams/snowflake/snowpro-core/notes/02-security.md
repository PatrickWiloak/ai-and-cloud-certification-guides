# Account Access and Security

**[📖 Security Overview](https://docs.snowflake.com/en/user-guide/security)** - Comprehensive security reference

## Role-Based Access Control (RBAC)

Snowflake uses RBAC as its primary access control model. All privileges are granted to roles, and roles are granted to users.

**[📖 Access Control Overview](https://docs.snowflake.com/en/user-guide/security-access-control-overview)** - RBAC fundamentals

### System-Defined Roles

#### ACCOUNTADMIN
- Top-level role in the system
- Combines SYSADMIN and SECURITYADMIN capabilities
- Can manage billing and resource monitors
- Should be used sparingly and with MFA enabled
- Best practice: only 2-3 users should have this role
- Should NOT own database objects directly

#### SECURITYADMIN
- Manages object grants (MANAGE GRANTS privilege)
- Can create, modify, and drop users and roles
- Owns the USERADMIN role
- Can grant privileges on any object in the account
- Use for: security configuration, role management

#### SYSADMIN
- Creates and manages databases and warehouses
- Recommended owner for all database objects
- Custom roles should be granted to SYSADMIN
- Use for: day-to-day object administration

#### USERADMIN
- Creates and manages users and roles
- Cannot grant privileges on objects (use SECURITYADMIN)
- Owned by SECURITYADMIN
- Use for: user provisioning

#### PUBLIC
- Automatically granted to every user
- Lowest privilege role
- Owns objects created without specifying a role
- Cannot be dropped or modified

#### ORGADMIN
- Organization-level management
- Can create and manage accounts within an organization
- Can view organization usage and billing
- Separate from account-level roles

**[📖 System-Defined Roles](https://docs.snowflake.com/en/user-guide/security-access-control-overview#system-defined-roles)** - Role details

### Role Hierarchy Best Practices

```
ACCOUNTADMIN
├── SECURITYADMIN
│    └── USERADMIN
└── SYSADMIN
     ├── CUSTOM_ADMIN_ROLE
     ├── DATA_ENGINEER_ROLE
     ├── DATA_ANALYST_ROLE
     └── PUBLIC (all users)
```

- Create custom roles for specific team functions
- Grant custom roles to SYSADMIN (not directly to ACCOUNTADMIN)
- Follow least privilege principle
- Use role hierarchy for privilege inheritance
- Regularly review and audit role assignments

**[📖 Access Control Configuration](https://docs.snowflake.com/en/user-guide/security-access-control-configure)** - Setup guide

### Privileges

**Object Privileges:**
- USAGE - use a database, schema, warehouse, or integration
- SELECT - query a table or view
- INSERT, UPDATE, DELETE, TRUNCATE - modify table data
- CREATE - create objects within a database or schema
- OWNERSHIP - full control over an object (transfer with GRANT OWNERSHIP)
- OPERATE - start, stop, suspend, resume a warehouse or task
- MONITOR - view usage and performance information

**Global Privileges:**
- CREATE DATABASE, CREATE WAREHOUSE, CREATE ROLE, CREATE USER
- MANAGE GRANTS - grant/revoke privileges on any object
- MONITOR USAGE - view account-level usage statistics
- EXECUTE TASK - run tasks

**[📖 Privileges](https://docs.snowflake.com/en/user-guide/security-access-control-privileges)** - Complete privilege reference

### Managed Access Schemas

- Created with `CREATE SCHEMA ... WITH MANAGED ACCESS`
- Object owners cannot grant privileges - only schema owner or SECURITYADMIN can
- Provides centralized privilege management
- Useful for regulated environments

**[📖 Managed Access](https://docs.snowflake.com/en/user-guide/security-access-control-configure#managed-access-schemas)** - Schema access control

## Authentication Methods

### Username/Password
- Default authentication method
- Password complexity requirements configurable
- Password rotation policies available
- MIN_LENGTH, MAX_LENGTH, MAX_AGE_DAYS parameters

### Multi-Factor Authentication (MFA)
- Powered by Duo Security
- User self-enrolls through Snowsight or SnowSQL
- Not enabled by default - per-user enrollment
- Recommended for ACCOUNTADMIN users
- Can enforce minimum MFA enrollment via authentication policies

**[📖 MFA](https://docs.snowflake.com/en/user-guide/security-mfa)** - MFA configuration

### Key Pair Authentication
- RSA key pairs (2048-bit minimum)
- Used for service accounts and programmatic access
- Public key stored in Snowflake, private key kept by user
- Supports key rotation (two active keys simultaneously)
- No password needed when using key pair

**[📖 Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth)** - Setup instructions

### Federated Authentication (SSO)
- SAML 2.0 protocol
- Supports IdPs: Okta, Azure AD, ADFS, PingFederate
- Snowflake acts as the Service Provider (SP)
- Can be configured as default authentication method
- Supports JIT (Just-In-Time) user provisioning

**[📖 Federated Authentication](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-overview)** - SSO setup

### OAuth
- Snowflake OAuth (built-in)
- External OAuth (custom authorization server)
- Used for programmatic access and partner integrations
- Token-based authentication

**[📖 OAuth](https://docs.snowflake.com/en/user-guide/oauth)** - OAuth configuration

### SCIM Provisioning
- System for Cross-domain Identity Management
- Automates user and group management
- Supports Okta, Azure AD, and custom SCIM clients
- Maps identity provider groups to Snowflake roles

**[📖 SCIM](https://docs.snowflake.com/en/user-guide/scim)** - Automated provisioning

## Network Security

### Network Policies
- IP allowlist and blocklist (ALLOWED_IP_LIST, BLOCKED_IP_LIST)
- Applied at account level or per user
- Only one network policy can be active at account level
- User-level policies override account-level policies
- CIDR notation for IP ranges

```sql
CREATE NETWORK POLICY corp_policy
  ALLOWED_IP_LIST = ('203.0.113.0/24', '198.51.100.0/24')
  BLOCKED_IP_LIST = ('203.0.113.99');

ALTER ACCOUNT SET NETWORK_POLICY = corp_policy;
```

**[📖 Network Policies](https://docs.snowflake.com/en/user-guide/network-policies)** - IP restriction setup

### Private Connectivity
- AWS PrivateLink - connect without traversing public internet
- Azure Private Link - same concept for Azure
- GCP Private Service Connect - same for GCP
- Requires Business Critical edition or higher
- Eliminates data exposure to public internet

**[📖 Private Connectivity](https://docs.snowflake.com/en/user-guide/admin-security-privatelink)** - PrivateLink setup

## Data Security

### Encryption
- All data encrypted at rest using AES-256
- All data encrypted in transit using TLS 1.2+
- Automatic key management with annual rotation
- Hierarchical key model (root key, account key, table key, file key)

### Tri-Secret Secure (Business Critical+)
- Customer provides their own encryption key via cloud KMS
- Combined with Snowflake-managed key for composite key
- Customer can revoke access by disabling their key
- Available on AWS KMS, Azure Key Vault, GCP Cloud KMS

**[📖 Encryption](https://docs.snowflake.com/en/user-guide/security-encryption)** - Encryption architecture
**[📖 Tri-Secret Secure](https://docs.snowflake.com/en/user-guide/security-encryption-manage)** - Customer-managed keys

### Column-Level Security (Enterprise+)

**Dynamic Data Masking:**
```sql
CREATE MASKING POLICY mask_ssn AS (val STRING)
  RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('HR_ROLE') THEN val
    ELSE 'XXX-XX-' || RIGHT(val, 4)
  END;

ALTER TABLE employees MODIFY COLUMN ssn SET MASKING POLICY mask_ssn;
```

**[📖 Dynamic Data Masking](https://docs.snowflake.com/en/user-guide/security-column-ddm-intro)** - Masking policies

### Row Access Policies (Enterprise+)

```sql
CREATE ROW ACCESS POLICY region_policy AS (region_col VARCHAR)
  RETURNS BOOLEAN ->
  CURRENT_ROLE() IN ('ADMIN_ROLE')
  OR region_col = CURRENT_REGION();

ALTER TABLE sales ADD ROW ACCESS POLICY region_policy ON (region);
```

**[📖 Row Access Policies](https://docs.snowflake.com/en/user-guide/security-row-intro)** - Row-level security

## Session Management

- Sessions have an active role (USE ROLE to switch)
- Session variables can be set with ALTER SESSION
- STATEMENT_TIMEOUT_IN_SECONDS controls max query runtime
- STATEMENT_QUEUED_TIMEOUT_IN_SECONDS controls max queue wait
- Session policies control idle timeout and other behaviors

**[📖 Session Parameters](https://docs.snowflake.com/en/sql-reference/parameters)** - All session settings
