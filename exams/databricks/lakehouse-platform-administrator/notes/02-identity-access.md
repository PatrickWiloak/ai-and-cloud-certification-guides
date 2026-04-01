# Identity and Access Management - Databricks Lakehouse Platform Administrator

## Overview

Identity and access covers 25% of the exam. This domain focuses on Unity Catalog principals, groups, SCIM provisioning, identity federation, and access control.

**[📖 Identity and Access Management](https://docs.databricks.com/en/admin/users-groups/index.html)** - User management

## Unity Catalog Principals

### User Types

**[📖 Manage Users](https://docs.databricks.com/en/admin/users-groups/users.html)** - User administration

| Principal | Description | Authentication |
|-----------|-------------|---------------|
| User | Human identity (email-based) | SSO, PAT, OAuth |
| Service principal | Non-human identity for automation | OAuth, PAT |
| Group | Collection of users, service principals, or other groups | N/A |

### Account-Level vs Workspace-Level

- **Account-level users**: Created in account console, can be assigned to workspaces
- **Workspace-level users**: Legacy - only exist in a single workspace
- **Best practice**: Create users at account level, assign to workspaces as needed
- Account-level groups can be assigned to multiple workspaces

**[📖 Account-Level Identity](https://docs.databricks.com/en/admin/users-groups/best-practices.html)** - Best practices

## Groups and Permissions

### Group Hierarchy

**[📖 Manage Groups](https://docs.databricks.com/en/admin/users-groups/groups.html)** - Group management

- Groups can contain: users, service principals, and other groups (nesting)
- Account-level groups: Managed in account console, available across workspaces
- Workspace-local groups: Legacy, exist in single workspace only
- Built-in groups:
  - `account users` - All users in the account
  - `admins` - Workspace administrators (per workspace)

### Permission Levels

**Workspace objects (notebooks, folders, repos):**
- No Permissions, Can Read, Can Run, Can Edit, Can Manage

**Compute (clusters):**
- No Permissions, Can Attach To, Can Restart, Can Manage

**Jobs:**
- No Permissions, Can View, Can Manage Run, Can Manage, Is Owner

**SQL Warehouses:**
- No Permissions, Can Use, Can Monitor, Can Manage

**Unity Catalog:**
- Privileges on catalogs, schemas, tables, volumes, functions
- USE CATALOG, USE SCHEMA, SELECT, MODIFY, CREATE TABLE, etc.
- ALL PRIVILEGES grants all applicable permissions

**[📖 Access Control Lists](https://docs.databricks.com/en/security/auth/access-control/index.html)** - ACL configuration

## SCIM Provisioning

**[📖 SCIM Provisioning](https://docs.databricks.com/en/admin/users-groups/scim/index.html)** - Automated user management

### How SCIM Works

- System for Cross-domain Identity Management
- Automates user and group synchronization from identity provider
- Create, update, deactivate users based on IdP changes
- Sync group memberships automatically
- Supported providers: Okta, Azure AD (Entra ID), OneLogin, PingFederate, generic SCIM

### SCIM Configuration

**Account-level SCIM (recommended):**
- Provision users and groups to the account
- Assign users to workspaces separately
- Single source of truth for all workspaces
- `/api/2.0/accounts/{account_id}/scim/v2/`

**Workspace-level SCIM (legacy):**
- Provision directly to a specific workspace
- Must configure separately for each workspace
- `/api/2.0/preview/scim/v2/`

**[📖 Account-Level SCIM](https://docs.databricks.com/en/admin/users-groups/scim/aad.html)** - Azure AD SCIM setup

### SCIM Best Practices

- Use account-level SCIM for centralized management
- Sync groups (not just users) for permission management
- Deactivate users in IdP to deactivate in Databricks (do not delete)
- Test SCIM sync in non-production first
- Monitor SCIM sync logs for errors

## Identity Federation

### Single Sign-On (SSO)

**[📖 SSO Configuration](https://docs.databricks.com/en/admin/account-settings/single-sign-on/index.html)** - SSO setup

- SAML 2.0 or OIDC-based SSO
- Configure at account level (applies to all workspaces)
- Supported identity providers: Okta, Azure AD, Google Workspace, OneLogin, PingOne, custom SAML
- SSO does not provision users - combine with SCIM for full lifecycle
- Emergency access: Account owner can bypass SSO

### OAuth for Service Principals

**[📖 OAuth M2M](https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html)** - Machine-to-machine auth

- Service principals authenticate using OAuth client credentials
- Create OAuth secret for service principal
- Token exchange: Client ID + Client Secret -> Access Token
- Short-lived tokens (1 hour default)
- Preferred over PATs for automation

### Personal Access Tokens (PATs)

**[📖 Personal Access Tokens](https://docs.databricks.com/en/dev-tools/auth/pat.html)** - Token management

- Long-lived tokens for API access
- Admin controls:
  - Enable/disable PAT generation per workspace
  - Set maximum token lifetime
  - Set maximum number of tokens per user
  - Control which users can create tokens via permissions
- Best practice: Use OAuth for service principals; PATs for human development use only

## Access Control Patterns

### Principle of Least Privilege

1. Create groups based on team or role
2. Assign permissions to groups (not individual users)
3. Use Unity Catalog for data permissions
4. Use workspace ACLs for compute and notebook permissions
5. Regularly audit and review permissions

### Common Access Patterns

**Data Engineer Team:**
- Unity Catalog: SELECT, MODIFY, CREATE TABLE on development catalog
- Compute: Can Manage on engineering cluster policies
- Jobs: Can Manage on engineering job folders

**Data Analyst Team:**
- Unity Catalog: SELECT on curated/production schemas
- Compute: Can Use on SQL warehouses
- Notebooks: Can Run on shared dashboards

**Platform Admin Team:**
- Workspace admin role
- Unity Catalog: ALL PRIVILEGES on metastore
- Full compute management

### Entitlements

**[📖 Manage Entitlements](https://docs.databricks.com/en/admin/users-groups/manage-users.html)** - Feature access

- **Workspace access**: Allow user to log into workspace
- **Databricks SQL access**: Allow access to SQL features and warehouses
- **Allow cluster creation**: Allow user to create clusters (restrict for cost control)
- **Allow instance pool creation**: Allow user to create instance pools
- Entitlements can be granted to users or groups

## Service Principals

**[📖 Service Principals](https://docs.databricks.com/en/admin/users-groups/service-principals.html)** - Automation identities

### Best Practices

- Use for CI/CD pipelines, scheduled jobs, and API automation
- Create at account level, assign to workspaces
- Use OAuth (not PATs) for authentication
- Grant minimum necessary permissions
- One service principal per application or pipeline
- Monitor service principal activity in audit logs

### Creating and Managing

1. Create in account console (account-level)
2. Add to workspace(s)
3. Generate OAuth secret
4. Assign to groups for permission management
5. Set as job owner for production pipelines

## Common Exam Patterns

1. **"Automate user lifecycle"** - SCIM provisioning from identity provider
2. **"Centralized user management"** - Account-level SCIM (not workspace-level)
3. **"Non-human identity for CI/CD"** - Service principal with OAuth
4. **"Restrict cluster creation"** - Remove "Allow cluster creation" entitlement
5. **"Team-based data access"** - Unity Catalog grants to groups
6. **"SSO setup"** - Account-level SAML/OIDC configuration
7. **"Emergency access when SSO is down"** - Account owner bypass
