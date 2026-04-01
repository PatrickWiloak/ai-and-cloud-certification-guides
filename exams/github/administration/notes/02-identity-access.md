# Identity and Access Management - GitHub Administration

## Overview

Identity and access management covers 20% of the exam. This domain focuses on SAML SSO, SCIM provisioning, team synchronization, Enterprise Managed Users, 2FA enforcement, and SSH key policies.

**[📖 Authentication Documentation](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management)** - IAM overview

## SAML Single Sign-On (SSO)

**[📖 SAML SSO](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/using-saml-for-enterprise-iam/about-saml-for-enterprise-iam)** - SAML configuration

### How SAML SSO Works

1. User attempts to access GitHub organization/enterprise
2. GitHub redirects to identity provider (IdP) for authentication
3. IdP authenticates user and returns SAML assertion
4. GitHub validates assertion and grants access
5. User's GitHub account is linked to their SAML identity

### Configuration Levels

**Organization-level SAML:**
- Each organization configures its own SSO
- Users can belong to multiple orgs with different IdPs
- Users maintain personal GitHub.com account
- PATs and SSH keys must be authorized for SSO-protected orgs

**Enterprise-level SAML:**
- Single SSO configuration for all organizations
- Applies to all organizations in the enterprise
- Overrides organization-level SSO settings

### Supported Identity Providers

- Azure AD (Entra ID)
- Okta
- OneLogin
- PingOne
- ADFS
- Any SAML 2.0 compliant provider

**[📖 Configure SAML](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/using-saml-for-enterprise-iam/configuring-saml-single-sign-on-for-your-enterprise)** - Setup guide

### SAML Key Concepts

- **NameID**: Unique identifier for the user (usually email)
- **SSO URL**: IdP login endpoint
- **Certificate**: IdP signing certificate for assertion validation
- **Linked identity**: Connection between GitHub account and SAML identity
- **Recovery codes**: Backup access if SSO is unavailable (enterprise owner)

### PATs and SSH Keys with SSO

- Personal access tokens must be **authorized** for SSO-enabled organizations
- SSH keys must be **authorized** for SSO-enabled organizations
- Authorization is per-organization (token authorized for org A may not work for org B)
- Fine-grained PATs automatically inherit SSO authorization

**[📖 Authorizing PATs for SSO](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-a-personal-access-token-for-use-with-saml-single-sign-on)** - Token authorization

## SCIM Provisioning

**[📖 SCIM](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/using-saml-for-enterprise-iam/configuring-user-provisioning-with-scim-for-your-enterprise)** - Automated provisioning

### What SCIM Does

- **Create**: Automatically create GitHub accounts when users added to IdP group
- **Update**: Sync attribute changes (name, email)
- **Deactivate**: Remove access when users removed from IdP group
- **Group sync**: Map IdP groups to GitHub teams

### SCIM Requirements

- SAML SSO must be configured first (SCIM requires SAML)
- Supported IdPs: Azure AD, Okta, OneLogin (full SCIM support varies by IdP)
- IdP manages the lifecycle - changes flow from IdP to GitHub
- SCIM tokens authenticate the IdP to GitHub's SCIM API

### SCIM Best Practices

- Always configure SCIM alongside SAML (SSO alone does not manage user lifecycle)
- Map IdP groups to GitHub teams for automatic team management
- Do not manually edit SCIM-provisioned users in GitHub (changes will be overwritten)
- Monitor SCIM provisioning logs in your IdP for sync errors
- Test provisioning with a small group before rolling out enterprise-wide

## Team Synchronization

**[📖 Team Sync](https://docs.github.com/en/enterprise-cloud@latest/organizations/organizing-members-into-teams/synchronizing-a-team-with-an-identity-provider-group)** - IdP group to team mapping

### How Team Sync Works

- Maps IdP groups (Azure AD groups, Okta groups) to GitHub teams
- When users join/leave IdP group, GitHub team membership updates automatically
- Team members must already have SAML-linked accounts
- Team sync runs periodically (not real-time - can take minutes)

### Configuration

1. Enable SAML SSO for the organization
2. Enable team synchronization in organization settings
3. Connect GitHub team to an IdP group
4. GitHub periodically syncs membership

### Limitations

- Cannot manually add/remove members from synced teams
- One GitHub team maps to one IdP group
- Nested IdP groups: Behavior depends on IdP (Azure AD flattens nested groups)
- Maximum 5,000 members per synced team

## Enterprise Managed Users (EMU)

**[📖 EMU](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/understanding-iam-for-enterprises/about-enterprise-managed-users)** - Managed user accounts

### What EMU Is

- GitHub accounts fully managed by the enterprise's IdP
- Users cannot create personal content outside the enterprise
- Accounts are namespaced: `USERNAME_SHORTCODE` (e.g., `jdoe_acme`)
- All access is controlled by the enterprise - no personal forks, stars, or contributions outside

### EMU vs Standard SAML SSO

| Feature | Standard SAML SSO | EMU |
|---------|-------------------|-----|
| Account ownership | User owns account | Enterprise owns account |
| Personal repos | Yes (outside org) | No |
| Public contributions | Yes | No |
| Account creation | User creates, links via SAML | IdP provisions via SCIM |
| Username | User-chosen | IdP-assigned with suffix |
| PATs | User-managed | Enterprise-managed |
| Access outside enterprise | Yes | No |
| IdP requirement | Recommended | Required (SCIM mandatory) |

### When to Use EMU

- Strict corporate control over all user activity
- Regulatory requirement that users cannot have personal GitHub activity
- Full lifecycle management from IdP
- Prevent accidental code contribution to public repos

### When NOT to Use EMU

- Users need personal GitHub accounts for open-source contribution
- Users work across multiple enterprises
- Team uses GitHub for both work and personal projects
- Organization prefers less restrictive environment

**[📖 Getting Started with EMU](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/understanding-iam-for-enterprises/getting-started-with-enterprise-managed-users)** - EMU setup guide

## Two-Factor Authentication (2FA)

**[📖 2FA](https://docs.github.com/en/enterprise-cloud@latest/admin/enforcing-policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-security-settings-in-your-enterprise)** - Security enforcement

### Enforcement

- Require 2FA at organization level or enterprise level
- When enforced, members who do not have 2FA enabled are removed from the organization
- Grace period: Members have time to enable 2FA before removal
- Removed members can rejoin after enabling 2FA

### 2FA Methods

- TOTP authenticator app (recommended)
- Security keys (WebAuthn/FIDO2)
- GitHub Mobile (push notification)
- SMS (least secure, discouraged)
- Passkeys

### SSH Key Policies

**[📖 SSH Key Policy](https://docs.github.com/en/enterprise-cloud@latest/admin/enforcing-policies/enforcing-policies-for-your-enterprise/enforcing-policies-for-security-settings-in-your-enterprise)** - Key management

- Enterprise policy can restrict SSH key types and minimum key lengths
- Enforce SSH certificate authorities for managed SSH access
- Audit SSH keys via enterprise audit log
- Require SSH keys to be authorized for SSO

## Role-Based Access Control

### Organization Roles

| Role | Key Permissions |
|------|----------------|
| Owner | Full admin - settings, billing, members, repos |
| Member | Create repos (if allowed), view member list |
| Billing manager | Billing only |
| Outside collaborator | Access to specific repos only |
| Security manager | Security alerts and settings across all repos |

### Repository Roles

| Role | Key Permissions |
|------|----------------|
| Read | View code, issues, pull requests |
| Triage | Manage issues and PRs (no code write) |
| Write | Push code, manage issues and PRs |
| Maintain | Manage repo settings (no destructive actions) |
| Admin | Full repo control including settings and deletion |

### Custom Repository Roles

**[📖 Custom Roles](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-peoples-access-to-your-organization-with-roles/managing-custom-repository-roles-for-an-organization)** - Role customization

- Create custom roles based on inherited base role + additional permissions
- Up to 5 custom roles per organization
- Assign to teams or individuals
- Useful for specialized roles (release manager, security reviewer)

## Common Exam Patterns

1. **"Automate user provisioning"** - SCIM (requires SAML first)
2. **"SSO but users keep personal accounts"** - Standard SAML SSO (not EMU)
3. **"Complete corporate control over accounts"** - Enterprise Managed Users
4. **"Sync IdP groups to GitHub teams"** - Team synchronization
5. **"PAT not working after SSO enabled"** - Token needs SSO authorization
6. **"Enforce 2FA, user removed"** - User did not enable 2FA within grace period
7. **"Custom permissions for release team"** - Custom repository roles
