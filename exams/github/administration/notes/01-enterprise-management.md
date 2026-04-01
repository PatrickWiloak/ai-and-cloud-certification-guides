# Enterprise Management - GitHub Administration

## Overview

Enterprise management covers 15% of the exam. This domain focuses on GitHub Enterprise setup, billing, support tiers, GitHub Connect, and the differences between Server and Cloud.

**[📖 GitHub Enterprise Documentation](https://docs.github.com/en/enterprise-cloud@latest/admin)** - Enterprise admin guide

## GitHub Enterprise Products

### GitHub Enterprise Cloud (GHEC) vs GitHub Enterprise Server (GHES)

**[📖 About GitHub Enterprise](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)** - Plan comparison

| Feature | GHEC | GHES |
|---------|------|------|
| Hosting | GitHub.com (SaaS) | Self-hosted (on-premises or cloud VM) |
| Maintenance | GitHub manages | Customer manages (upgrades, backups) |
| Authentication | SAML SSO, EMU | SAML, LDAP, CAS, built-in |
| IP allow lists | Yes | Firewall-based |
| Data residency | GitHub data centers | Customer controls |
| GHAS | Add-on license | Add-on license |
| Audit log streaming | Yes | Syslog or file-based |
| GitHub Connect | Optional | Optional |
| GitHub Actions | GitHub-hosted or self-hosted runners | Self-hosted runners only |
| GitHub Packages | Hosted | Self-hosted registry |

### GitHub Enterprise Cloud Features

**[📖 Enterprise Cloud](https://docs.github.com/en/enterprise-cloud@latest)** - GHEC documentation

- Enterprise account manages multiple organizations
- Centralized billing across all organizations
- Enterprise-level policies override organization settings
- Audit log with API access and streaming
- SAML SSO at organization or enterprise level
- Enterprise Managed Users (EMU) option
- IP allow lists for network restrictions

### GitHub Enterprise Server Features

**[📖 Enterprise Server](https://docs.github.com/en/enterprise-server/admin)** - GHES documentation

- Installed on customer infrastructure (AWS, Azure, GCP, VMware, Hyper-V)
- Full control over data location and network access
- LDAP or SAML authentication
- Management console for server administration
- High availability: Primary-replica configuration
- Backup utilities: `backup-utils` for automated backups
- Upgrade path: Feature releases every ~3 months, patch releases as needed

## Enterprise Account Structure

**[📖 Enterprise Accounts](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-your-enterprise-account/about-enterprise-accounts)** - Account hierarchy

### Hierarchy

```
Enterprise Account
├── Organization 1
│   ├── Team A
│   │   └── Repository 1, Repository 2
│   └── Team B
│       └── Repository 3
├── Organization 2
│   └── Team C
│       └── Repository 4
└── Enterprise Policies (override org settings)
```

### Enterprise Roles

| Role | Capabilities |
|------|-------------|
| Enterprise owner | Full control - billing, policies, orgs, users |
| Billing manager | View and manage billing only |
| Member | Default access based on org membership |
| Guest collaborator | External contributor (GHEC with EMU) |

### Enterprise Policies

**[📖 Enterprise Policies](https://docs.github.com/en/enterprise-cloud@latest/admin/policies)** - Policy management

Policies set at enterprise level can:
- **Enforce**: All organizations must follow this setting
- **Allow**: Organizations can configure their own setting
- Key policy areas:
  - Repository creation permissions
  - Repository visibility (public/private/internal)
  - Repository forking
  - Base permissions for organization members
  - GitHub Actions allowed actions
  - GitHub Copilot access
  - GitHub Pages visibility

## Billing and Licensing

**[📖 Billing](https://docs.github.com/en/billing)** - Billing documentation

### License Types

- **Per-seat licensing**: Each user consumes one seat
- **Metered billing**: Actions minutes, Packages storage, Copilot, LFS
- Seats are consumed when user is a member of any organization in the enterprise

### Key Billing Concepts

- **GitHub Actions**: Free minutes per plan, then per-minute billing (varies by runner OS)
- **GitHub Packages**: Storage and data transfer costs
- **GHAS**: Per active committer license for private repos
- **Copilot**: Per-seat monthly billing
- **LFS**: Storage and bandwidth overage charges

### Cost Management

- Set spending limits for Actions and Packages
- Monitor usage via enterprise billing page
- Use GitHub-hosted larger runners for faster builds (metered)
- Self-hosted runners: No per-minute cost (you provide infrastructure)

## GitHub Support

**[📖 GitHub Support](https://docs.github.com/en/support)** - Support documentation

### Support Tiers

| Feature | GitHub Support | GitHub Premium Support |
|---------|---------------|----------------------|
| Channels | Web, email | Web, email, phone, Slack |
| Response time | 8 hours (critical) | 30 min (urgent), 4 hours (high) |
| Availability | 24/5 | 24/7 |
| Named contacts | No | Yes (dedicated support manager) |
| Training credits | No | Yes |
| Health checks | No | Yes |

### Support Tickets

- Submit via GitHub Support Portal
- Include: Account name, affected users, steps to reproduce
- Priority levels: Urgent, High, Normal, Low
- Escalation path available for critical issues

## GitHub Connect

**[📖 GitHub Connect](https://docs.github.com/en/enterprise-server/admin/configuration/configuring-github-connect/about-github-connect)** - Bridge GHES and GHEC

### Purpose

- Connect GitHub Enterprise Server to GitHub.com
- Enable select features that require GitHub.com connectivity

### Features Enabled

- **Unified search**: Search GitHub.com repos from GHES
- **Unified contributions**: Show GHES contributions on GitHub.com profile
- **GitHub.com Actions**: Use actions from GitHub.com Marketplace on GHES
- **Dependabot alerts**: Receive vulnerability alerts from GitHub Advisory Database
- **Server statistics**: Share anonymized usage data with GitHub
- **Automatic user license sync**: Sync license usage between GHES and GHEC

### Configuration

- Requires outbound HTTPS from GHES to GitHub.com
- Enterprise owner enables in Management Console
- Select which features to enable individually
- Does not expose GHES code or data to GitHub.com

## Common Exam Patterns

1. **"Self-hosted, full data control"** - GitHub Enterprise Server
2. **"SaaS, no infrastructure management"** - GitHub Enterprise Cloud
3. **"Centralized policy across organizations"** - Enterprise-level policies
4. **"GHES needs GitHub.com Actions"** - GitHub Connect
5. **"License cost for GHAS"** - Per active committer on private repos
6. **"30-minute response time"** - Premium Support
7. **"GHES backup strategy"** - backup-utils for automated backups
8. **"Enterprise owner vs billing manager"** - Owner has full control; billing manager is billing only
