# Advanced Access Control

**[📖 Access Control Overview](https://docs.snowflake.com/en/user-guide/security-access-control-overview)** - RBAC documentation

## Overview

This document covers advanced access control in Snowflake including role hierarchy design, database roles, future grants, SCIM provisioning, and authentication methods. Security and access control is the highest-weighted domain on the Advanced Administrator exam.

## Role-Based Access Control (RBAC)

### System-Defined Roles

#### ACCOUNTADMIN
- Top-level account role - combines SECURITYADMIN and SYSADMIN privileges
- Manages account-level settings (resource monitors, account parameters)
- Should be restricted to a small number of administrators
- Best practice: do not use as a daily role, switch to it only when needed
- Can see all objects in the account

#### SECURITYADMIN
- Manages object grants across the account (GRANT, REVOKE)
- Inherits USERADMIN role
- Can grant privileges on any object to any role
- Manages network policies at account level
- Does not own databases or warehouses (that is SYSADMIN)

#### USERADMIN
- Creates and manages users and roles
- Cannot grant privileges on objects (that is SECURITYADMIN)
- Can grant roles to users
- Inherited by SECURITYADMIN

#### SYSADMIN
- Creates and manages databases, schemas, warehouses
- Should be granted all custom roles (best practice)
- Owns production data objects
- Does not manage security or users

#### PUBLIC
- Default role granted to every user
- Should have minimal privileges
- Objects granted to PUBLIC are accessible by everyone
- Cannot be dropped or renamed

### Custom Role Design Patterns

#### Functional Roles Pattern
```sql
-- Access roles (object-level permissions)
CREATE ROLE analytics_reader;
CREATE ROLE analytics_writer;
CREATE ROLE finance_reader;
CREATE ROLE finance_writer;

-- Functional roles (user-facing)
CREATE ROLE data_analyst;
CREATE ROLE data_engineer;
CREATE ROLE finance_analyst;

-- Map functional to access roles
GRANT ROLE analytics_reader TO ROLE data_analyst;
GRANT ROLE analytics_writer TO ROLE data_engineer;
GRANT ROLE finance_reader TO ROLE finance_analyst;

-- Connect to SYSADMIN
GRANT ROLE data_analyst TO ROLE SYSADMIN;
GRANT ROLE data_engineer TO ROLE SYSADMIN;
GRANT ROLE finance_analyst TO ROLE SYSADMIN;

-- Assign to users
GRANT ROLE data_analyst TO USER alice;
GRANT ROLE data_engineer TO USER bob;
```

#### Service Account Pattern
```sql
-- Service role with specific permissions
CREATE ROLE etl_service_role;
GRANT USAGE ON DATABASE raw_db TO ROLE etl_service_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE raw_db TO ROLE etl_service_role;
GRANT SELECT ON ALL TABLES IN DATABASE raw_db TO ROLE etl_service_role;
GRANT ALL ON DATABASE staging_db TO ROLE etl_service_role;
GRANT USAGE ON WAREHOUSE etl_wh TO ROLE etl_service_role;

-- Service user
CREATE USER etl_service
  DEFAULT_ROLE = etl_service_role
  DEFAULT_WAREHOUSE = etl_wh
  MUST_CHANGE_PASSWORD = FALSE
  RSA_PUBLIC_KEY = '...';

GRANT ROLE etl_service_role TO USER etl_service;
GRANT ROLE etl_service_role TO ROLE SYSADMIN;
```

## Database Roles

### Overview
- Roles scoped to a specific database
- Simplify permission management within a database
- Can be granted to account-level roles
- Replicated with the database during replication

**[📖 Database Roles](https://docs.snowflake.com/en/user-guide/security-access-control-database-roles)** - Database role documentation

### Implementation
```sql
-- Create database roles
CREATE DATABASE ROLE sales_db.reader;
CREATE DATABASE ROLE sales_db.writer;
CREATE DATABASE ROLE sales_db.admin;

-- Grant database privileges
GRANT USAGE ON ALL SCHEMAS IN DATABASE sales_db TO DATABASE ROLE sales_db.reader;
GRANT SELECT ON ALL TABLES IN DATABASE sales_db TO DATABASE ROLE sales_db.reader;

GRANT USAGE ON ALL SCHEMAS IN DATABASE sales_db TO DATABASE ROLE sales_db.writer;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN DATABASE sales_db TO DATABASE ROLE sales_db.writer;

-- Hierarchy within database roles
GRANT DATABASE ROLE sales_db.reader TO DATABASE ROLE sales_db.writer;
GRANT DATABASE ROLE sales_db.writer TO DATABASE ROLE sales_db.admin;

-- Grant database role to account role
GRANT DATABASE ROLE sales_db.reader TO ROLE data_analyst;
GRANT DATABASE ROLE sales_db.admin TO ROLE data_engineer;
```

### Benefits
- **Modularity:** Permissions travel with the database during replication
- **Simplicity:** Manage permissions within database context
- **Replication:** Database roles replicated with database (account roles are not)
- **Isolation:** Cannot be used to grant permissions outside the database

## Future Grants

### Overview
- Automatically grant privileges on objects created in the future
- Apply to tables, views, stages, pipes, tasks, streams created after the grant
- Set at schema or database level
- Eliminates manual grant management for new objects

**[📖 Future Grants](https://docs.snowflake.com/en/sql-reference/sql/grant-privilege)** - Grant syntax

### Configuration
```sql
-- Future grants on new tables in a schema
GRANT SELECT ON FUTURE TABLES IN SCHEMA my_db.public TO ROLE reader;
GRANT ALL ON FUTURE TABLES IN SCHEMA my_db.public TO ROLE writer;

-- Future grants on new schemas in a database
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE my_db TO ROLE reader;

-- Future grants on new views
GRANT SELECT ON FUTURE VIEWS IN SCHEMA my_db.public TO ROLE reader;

-- View future grants
SHOW FUTURE GRANTS IN SCHEMA my_db.public;
SHOW FUTURE GRANTS IN DATABASE my_db;

-- Revoke future grants
REVOKE SELECT ON FUTURE TABLES IN SCHEMA my_db.public FROM ROLE reader;
```

### Common Pitfall
- Future grants only apply to objects created AFTER the grant is set
- Existing objects need explicit grants
- Combine `GRANT ON ALL` (existing) with `GRANT ON FUTURE` (new)

```sql
-- Grant on existing AND future
GRANT SELECT ON ALL TABLES IN SCHEMA my_db.public TO ROLE reader;
GRANT SELECT ON FUTURE TABLES IN SCHEMA my_db.public TO ROLE reader;
```

## Authentication Methods

### MFA (Multi-Factor Authentication)
```sql
-- Enable MFA for user (user enrolls via Duo Mobile)
ALTER USER admin_user SET MINS_TO_BYPASS_MFA = 0;

-- Enforce MFA at account level for specific roles
-- (No built-in account-level MFA enforcement - must manage per user)

-- Bypass MFA temporarily (emergency)
ALTER USER admin_user SET MINS_TO_BYPASS_MFA = 60;

-- Check MFA status
SELECT name, ext_authn_duo, mins_to_bypass_mfa
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS;
```

**[📖 MFA](https://docs.snowflake.com/en/user-guide/security-mfa)** - Multi-factor authentication

### SAML SSO
- Federated authentication with identity providers (Okta, Azure AD, ADFS)
- SAML 2.0 protocol for browser-based SSO
- User logs in via IdP, IdP sends SAML assertion to Snowflake
- Snowflake creates or maps user based on SAML attributes

**[📖 SSO](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-overview)** - Federated authentication

### SCIM Provisioning
- Automated user and group provisioning from identity providers
- Supported: Okta, Azure AD, custom SCIM 2.0 clients
- Users created/updated/disabled automatically
- Groups mapped to Snowflake roles
- Reduces manual user management overhead

**[📖 SCIM](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-use-scim)** - SCIM integration

```sql
-- Create SCIM integration
CREATE SECURITY INTEGRATION okta_scim
  TYPE = SCIM
  SCIM_CLIENT = 'okta'
  RUN_AS_ROLE = 'GENERIC_SCIM_PROVISIONER';

-- View integration details
DESCRIBE SECURITY INTEGRATION okta_scim;
```

### Key Pair Authentication
```sql
-- Generate RSA key pair (client side)
-- openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt
-- openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Assign public key to user
ALTER USER service_user SET RSA_PUBLIC_KEY = 'MIIBIjANBg...';

-- Rotate keys (supports two active keys)
ALTER USER service_user SET RSA_PUBLIC_KEY_2 = 'MIIBIjANBg...new...';
-- After rotation complete:
ALTER USER service_user SET RSA_PUBLIC_KEY = 'MIIBIjANBg...new...';
ALTER USER service_user UNSET RSA_PUBLIC_KEY_2;
```

- Two key slots (RSA_PUBLIC_KEY and RSA_PUBLIC_KEY_2) for rotation
- No password needed when key pair is configured
- Best for service accounts and programmatic access
- Client signs JWT with private key, Snowflake verifies with public key

**[📖 Key Pair Auth](https://docs.snowflake.com/en/user-guide/key-pair-auth)** - Key pair authentication

## Network Security

### Network Policies
```sql
-- Create network policy
CREATE NETWORK POLICY office_only
  ALLOWED_IP_LIST = ('203.0.113.0/24', '198.51.100.0/24')
  BLOCKED_IP_LIST = ('203.0.113.99');

-- Apply at account level
ALTER ACCOUNT SET NETWORK_POLICY = office_only;

-- Apply at user level (overrides account policy)
ALTER USER remote_contractor SET NETWORK_POLICY = contractor_policy;

-- View active policies
DESCRIBE NETWORK POLICY office_only;
```

**[📖 Network Policies](https://docs.snowflake.com/en/user-guide/network-policies)** - IP-based access control

### Policy Precedence
1. User-level policy takes priority over account-level
2. Only one policy can be active per level
3. IP must match ALLOWED_IP_LIST and not be in BLOCKED_IP_LIST
4. Blocked IPs in BLOCKED_IP_LIST take precedence over ALLOWED_IP_LIST

## Grant Management

### Viewing Grants
```sql
-- Grants to a role
SHOW GRANTS TO ROLE data_analyst;

-- Grants on an object
SHOW GRANTS ON TABLE my_db.public.customers;

-- Grants of a role (who has this role)
SHOW GRANTS OF ROLE data_analyst;

-- All grants in account (ACCOUNT_USAGE)
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE deleted_on IS NULL
  AND granted_on = 'TABLE'
  AND name = 'CUSTOMERS';
```

### Privilege Types
| Object | Key Privileges |
|--------|---------------|
| Database | USAGE, CREATE SCHEMA, MONITOR |
| Schema | USAGE, CREATE TABLE, CREATE VIEW |
| Table | SELECT, INSERT, UPDATE, DELETE, TRUNCATE |
| View | SELECT |
| Warehouse | USAGE, OPERATE, MONITOR, MODIFY |
| Stage | USAGE, READ, WRITE |
| Task | OPERATE, MONITOR |
| Stream | SELECT |
