# GitHub Administration High-Yield Scenarios

## Scenario 1: Enterprise Identity Setup

**Scenario**: A company with 500 developers is migrating to GitHub Enterprise Cloud. They use Okta as their identity provider and want centralized authentication, automated user provisioning, and team synchronization. What should be configured?

**Solution Pattern**:
- **SAML SSO**: Configure at the organization level with Okta as the IdP
- **SCIM**: Enable automated provisioning so users are created/deactivated based on Okta
- **Team Sync**: Map Okta groups to GitHub teams for automatic team membership
- **2FA**: Require 2FA for all organization members as an additional security layer

**Common Distractors**:
- Configuring SCIM without SAML (SCIM requires SAML as a prerequisite)
- Using EMU when standard SAML/SCIM is sufficient (EMU restricts users from personal activity)
- Setting up SSO at the repo level (SSO is org or enterprise level)

---

## Scenario 2: Actions Policy Design

**Scenario**: A security team requires that only approved GitHub Actions can be used across the organization. Internal actions and select verified creators should be allowed, but arbitrary third-party actions should be blocked.

**Solution Pattern**:
- Set Actions policy to "Allow select actions"
- Allow actions by GitHub (actions/*)
- Allow actions by verified creators (optional)
- Allow specific third-party actions by owner/repo
- Set GITHUB_TOKEN default to read-only
- Require approval for first-time contributors on fork PRs

**Common Distractors**:
- Setting "Allow all actions" (does not restrict third-party actions)
- Setting "Local actions only" (too restrictive, blocks GitHub's own actions)

---

## Scenario 3: Repository Governance

**Scenario**: An enterprise needs to enforce consistent branch protection across all 200 repositories. The main branch should require PR reviews, status checks, and signed commits. How should this be implemented?

**Solution Pattern**:
- Use **organization-level rulesets** (not individual branch protection rules)
- Create a ruleset targeting the `main` branch across all repositories
- Configure: require PR reviews (2 reviewers), require status checks, require signed commits
- Use bypass list for release automation service accounts
- Enterprise-level rulesets for policies that span multiple organizations

**Common Distractors**:
- Configuring branch protection rules on each repo individually (does not scale)
- Using branch protection instead of rulesets (rulesets support org-level application)

---

## Scenario 4: GHAS Rollout

**Scenario**: An enterprise wants to enable GitHub Advanced Security across 50 private repositories. They need code scanning, secret scanning, and dependency management. Budget constraints limit GHAS licensing.

**Solution Pattern**:
- GHAS is licensed per committer for private repos (not per repo)
- Enable GHAS at the organization level
- Start with default CodeQL setup for code scanning (simpler)
- Enable secret scanning with push protection
- Dependabot alerts and security updates (included free)
- Use security overview to prioritize remediation
- Roll out in phases to manage committer count

**Common Distractors**:
- Thinking GHAS is free for private repos (it is only free for public repos)
- Confusing Dependabot (free) with GHAS code/secret scanning (paid for private)

---

## Scenario 5: Audit and Compliance

**Scenario**: An auditor asks for evidence of all repository creation, permission changes, and secret access over the last 90 days. How do you provide this?

**Solution Pattern**:
- Use the **audit log** with filters for relevant actions
- Filter by action categories: `repo.create`, `org.update_member`, `org_secret.*`
- Export via API for the 90-day period
- Set up **audit log streaming** to external SIEM for ongoing compliance
- IP allow lists can provide additional access control evidence

---

## Scenario 6: Enterprise Managed Users

**Scenario**: A regulated financial company needs complete control over developer accounts - no personal repos, no contributions to public projects, all activity auditable. Which approach should they use?

**Solution Pattern**:
- **Enterprise Managed Users (EMU)** - enterprise controls all user accounts
- Users are provisioned via SCIM from the corporate IdP
- Accounts are namespaced (username_company)
- Users cannot create personal repos or interact with public repos
- Full audit trail of all user activity

**When EMU is NOT the right choice**:
- Company wants developers to contribute to open source
- Developers need personal GitHub accounts
- Less strict compliance requirements

## Key Decision Factors

### Domain Priority for Study
1. **Manage User Identities (20%)** - SAML, SCIM, EMU, roles
2. **Manage Actions (20%)** - Policies, runners, secrets
3. **Support Enterprise (15%)** - Plans, support, migration
4. **Manage Repositories (15%)** - Branch protection, rulesets, policies
5. **Manage GHAS (15%)** - Licensing, enablement, features
6. **Enterprise Administration (15%)** - Audit logs, policies, governance
