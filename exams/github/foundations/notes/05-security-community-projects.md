# Security, Community, and Project Management

## Privacy, Security, and Administration

### Authentication Methods

**Two-Factor Authentication (2FA)**
- Required for all GitHub.com accounts
- Methods: TOTP app, SMS, security keys, GitHub Mobile
- Recovery codes should be saved securely
- Organization owners can require 2FA for all members

**[About 2FA](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-two-factor-authentication)** - 2FA setup and configuration

**SSH Keys**
- Used for secure Git operations without entering credentials
- Generate with `ssh-keygen -t ed25519 -C "email@example.com"`
- Add public key to GitHub account settings
- Test with `ssh -T git@github.com`
- Can have multiple keys for different machines

**[Connecting with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)** - SSH setup guide

**Personal Access Tokens (PATs)**
| Type | Scope | Use Case |
|------|-------|----------|
| Classic | Broad scopes | Scripts, CI/CD, legacy tools |
| Fine-grained | Per-repository | Targeted access, newer apps |

- Fine-grained tokens are recommended over classic tokens
- Set expiration dates for security
- Use minimum required permissions

**[Managing Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)** - PAT management

**GPG/SSH Signing**
- Sign commits and tags to verify authorship
- Signed commits show "Verified" badge on GitHub
- Can require signed commits via branch protection rules

**[Signing Commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)** - Commit signing

### Security Features

**Dependabot**
- **Dependabot alerts** - Notify about known vulnerabilities in dependencies
- **Dependabot security updates** - Automatically create PRs to fix vulnerabilities
- **Dependabot version updates** - Keep dependencies up to date

**[About Dependabot](https://docs.github.com/en/code-security/dependabot)** - Dependabot documentation
**[Dependabot Alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)** - Alert configuration

**Secret Scanning**
- Detects accidentally committed secrets (API keys, tokens, passwords)
- Partners with service providers to revoke exposed tokens
- Available for public repositories (free) and private repositories (GHAS)
- Push protection prevents secrets from being pushed in the first place

**[About Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)** - Secret scanning overview

**Code Scanning**
- Finds potential security vulnerabilities and errors in code
- Powered by CodeQL analysis engine
- Can run automatically via GitHub Actions
- Results appear as alerts in the Security tab

**[About Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)** - Code scanning overview

**Security Advisories**
- Report and manage security vulnerabilities privately
- Create temporary private forks for fixes
- Request CVE identification numbers
- Publish advisories to notify users

**[About Repository Security Advisories](https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/about-repository-security-advisories)** - Advisory management

### Organization Management

**Organization Roles:**
| Role | Capabilities |
|------|-------------|
| Owner | Full access, manage settings, billing, members |
| Member | Default role, access based on team membership |
| Billing Manager | Manage billing settings only |
| Outside Collaborator | Access to specific repositories only |

**[Roles in an Organization](https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/roles-in-an-organization)** - Role reference

**Repository Permission Levels:**
| Level | Capabilities |
|-------|-------------|
| Read | View and clone repository |
| Triage | Manage issues and PRs without write access |
| Write | Push to repository |
| Maintain | Manage repository without sensitive/destructive actions |
| Admin | Full access including settings and deletion |

**[Repository Roles](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization)** - Permission levels

**Teams:**
- Group organization members with shared permissions
- Nested teams (child teams inherit parent permissions)
- Can be mentioned with @organization/team-name
- Visible or secret team visibility
- Used with CODEOWNERS for review assignment

**[About Teams](https://docs.github.com/en/organizations/organizing-members-into-teams/about-teams)** - Team management

**Enterprise Features:**
- SAML single sign-on (SSO)
- SCIM for identity provisioning
- Enterprise Managed Users (EMU)
- Centralized policies across organizations
- Advanced audit log with API access
- GitHub Connect for hybrid deployments

**[About Enterprise Accounts](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-your-enterprise-account/about-enterprise-accounts)** - Enterprise management

## Benefits of the GitHub Community

### Open Source

**What is Open Source?**
- Software with source code available for anyone to inspect, modify, and enhance
- Governed by open source licenses
- Community-driven development
- GitHub hosts the majority of open source projects

**Common Open Source Licenses:**

| License | Type | Commercial Use | Modification | Distribution | Patent Grant |
|---------|------|---------------|-------------|-------------|-------------|
| MIT | Permissive | Yes | Yes | Yes | No |
| Apache 2.0 | Permissive | Yes | Yes | Yes | Yes |
| GPL v3 | Copyleft | Yes | Yes (must share) | Yes (must share) | Yes |
| BSD 2-Clause | Permissive | Yes | Yes | Yes | No |
| LGPL v3 | Weak copyleft | Yes | Library mods shared | Yes | Yes |
| Unlicense | Public domain | Yes | Yes | Yes | No |

**[Choose a License](https://choosealicense.com/)** - License comparison
**[Open Source Guide](https://opensource.guide/)** - Best practices

### Contributing to Open Source

**Contribution Workflow:**
1. Find a project (GitHub Explore, Topics, "good first issue" label)
2. Read the README, CONTRIBUTING.md, and CODE_OF_CONDUCT.md
3. Fork the repository
4. Clone your fork locally
5. Create a feature branch
6. Make changes and commit
7. Push to your fork
8. Open a pull request to the original repository
9. Respond to review feedback

**[Contributing to Projects](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project)** - Contribution guide
**[GitHub Explore](https://github.com/explore)** - Discover projects

### InnerSource

InnerSource applies open source practices within an organization:
- Shared codebases across teams with internal visibility
- Pull request workflows for cross-team collaboration
- Reduces duplicate effort and silos
- Accelerates innovation by leveraging existing internal code
- Internal repositories on GitHub support InnerSource

**[InnerSource Fundamentals](https://resources.github.com/innersource/fundamentals/)** - InnerSource guide

### Community Features

**GitHub Sponsors**
- Fund open source developers and projects directly
- Individuals and organizations can sponsor
- Custom tiers with different benefits
- Featured sponsors on profile and repository pages

**[GitHub Sponsors](https://docs.github.com/en/sponsors)** - Sponsorship program

**GitHub Stars**
- Recognition program for community contributors
- GitHub Stars represent influential developers and educators
- Selected by GitHub based on community impact

**GitHub Discussions**
- Forum-style conversations in repositories or organizations
- Categories: Announcements, General, Ideas, Polls, Q&A, Show and tell
- Q&A format with accepted answers
- Separate from issues (not for tracking work)

**[GitHub Discussions](https://docs.github.com/en/discussions)** - Discussions documentation

**Community Health Files**
- Stored in root, `docs/`, or `.github/` directory
- Can be created at organization level (applies to all repos)
- Community profile score shown in Insights tab

| File | Purpose |
|------|---------|
| CODE_OF_CONDUCT.md | Behavior expectations |
| CONTRIBUTING.md | How to contribute |
| SECURITY.md | Vulnerability reporting |
| SUPPORT.md | Getting help |
| FUNDING.yml | Sponsorship links |

**[Community Health Files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)** - Health files guide

## Project Management

### GitHub Projects (New)

The modern project management experience on GitHub.

**[About Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)** - Projects overview
**[Quickstart for Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/quickstart-for-projects)** - Getting started

**Views:**
| View | Best For |
|------|----------|
| Table | Spreadsheet-like data management |
| Board | Kanban workflow visualization |
| Roadmap | Timeline-based planning |

**Custom Fields:**
- Text, Number, Date, Single select, Iteration
- Filter and group items by custom fields
- Use for priority, team, sprint, or any custom taxonomy

**Automation:**
- Built-in workflows (auto-add items, auto-set fields)
- Integration with GitHub Actions
- Status changes when PRs are merged or issues are closed

**Cross-repository:**
- Track issues and PRs from multiple repositories
- Organization-level projects span all repos
- Can include draft items without linked issues

### Classic Projects
- Kanban-style boards with columns
- Limited to single repository or organization
- Simpler but less flexible than new Projects
- Being gradually replaced by new Projects

### Milestones

- Group issues and PRs toward a specific goal
- Set due dates for deadline tracking
- View progress as percentage complete
- Filter issues by milestone
- One milestone per issue/PR

**[About Milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones)** - Milestone management

### Labels

- Color-coded tags for categorizing issues and PRs
- Filter and search by labels
- Organization-wide labels for consistency
- Default labels provided by GitHub
- Custom labels for project-specific needs

**[Managing Labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)** - Label guide

## Key Exam Points

### Security
- 2FA is required for all GitHub.com accounts
- SSH keys authenticate Git operations; GPG keys sign commits
- Fine-grained PATs are preferred over classic PATs
- Dependabot handles dependency vulnerabilities (alerts, security updates, version updates)
- Secret scanning detects exposed credentials; push protection prevents them
- Code scanning finds vulnerabilities in your code (powered by CodeQL)

### Organization
- Know the four organization roles and their capabilities
- Know the five repository permission levels (Read through Admin)
- Teams inherit permissions from parent teams
- Enterprise features include SAML SSO and SCIM

### Community
- Understand common license types - permissive vs copyleft
- Know the fork-and-PR contribution workflow
- InnerSource = open source practices inside an organization
- Community health files can be set at the organization level

### Project Management
- New Projects support table, board, and roadmap views
- Custom fields allow flexible tracking
- Projects can span multiple repositories
- Classic projects are simpler but more limited
- Milestones track progress toward goals with due dates
