# Repository Management - GitHub Administration

## Overview

Repository management covers 15% of the exam. This domain focuses on branch protection rules, rulesets, CODEOWNERS, repository policies, template repositories, and repository visibility.

**[📖 Repository Administration](https://docs.github.com/en/repositories)** - Repository documentation

## Branch Protection Rules

**[📖 Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)** - Branch protection

### Available Protections

| Protection | Description |
|-----------|-------------|
| Require pull request reviews | Require approvals before merging |
| Require status checks | Require CI checks to pass |
| Require conversation resolution | All review comments must be resolved |
| Require signed commits | Commits must have verified signatures |
| Require linear history | No merge commits (rebase or squash only) |
| Require deployments to succeed | Deployment must complete before merge |
| Lock branch | Make branch read-only |
| Restrict who can push | Limit push access to specific people/teams |
| Restrict force pushes | Prevent history rewriting |
| Restrict deletions | Prevent branch deletion |

### Configuration

- Apply to specific branch names or patterns (`main`, `release/*`)
- Admins can optionally be exempted from rules
- Apply to repository forks (require PRs from forks)
- Status checks: Select which checks are required

**[📖 Managing Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)** - Configuration guide

## Repository Rulesets

**[📖 Repository Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)** - Scalable rule management

### Rulesets vs Branch Protection Rules

| Feature | Branch Protection | Rulesets |
|---------|-------------------|---------|
| Scope | Single repository | Organization or repository |
| Target | Branches only | Branches and tags |
| Multiple rule sets | No (one per pattern) | Yes (layered) |
| Bypass list | Admin exempt option | Granular bypass list |
| Status | Always active | Active, evaluate (dry-run), disabled |
| API | REST API | REST API with better filtering |

### Ruleset Features

- **Organization-level rulesets**: Apply across all or selected repositories
- **Repository-level rulesets**: Apply within a single repository
- **Bypass actors**: Specify who can bypass (roles, teams, apps, deploy keys)
- **Targeting**: Target by branch name, tag name, or pattern (fnmatch)
- **Layering**: Multiple rulesets can apply - most restrictive wins
- **Evaluate mode**: Test rules without enforcing (dry-run)

**[📖 Creating Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository)** - Ruleset creation

### Available Rules

- Restrict creations (branches/tags)
- Restrict updates
- Restrict deletions
- Require linear history
- Require signed commits
- Require pull request before merging
  - Required approvals count
  - Dismiss stale reviews
  - Require review from code owners
  - Required review from last pusher
- Require status checks to pass
- Block force pushes
- Require code scanning results

### Enterprise and Organization Rulesets

- Enterprise rulesets apply to all organizations
- Organization rulesets apply to all or selected repositories
- Cannot be overridden at lower levels
- Ideal for enforcing compliance across hundreds of repositories
- Use bypass lists for automation (CI bots, release automation)

## CODEOWNERS

**[📖 CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)** - Automatic review assignment

### How CODEOWNERS Works

- File specifies who is responsible for code in a repository
- Automatically requests reviews from code owners on PRs
- File locations (checked in order): root, `.github/`, `docs/`
- Uses gitignore-style patterns for path matching
- Combined with branch protection "Require review from Code Owners"

### CODEOWNERS Syntax

```
# Default owners for everything
* @org/platform-team

# Frontend code
/src/frontend/ @org/frontend-team

# Documentation
*.md @org/docs-team

# Infrastructure
/terraform/ @org/devops-team @lead-engineer

# Specific file
/config/production.yml @org/sre-team
```

### Best Practices

- Keep CODEOWNERS file in `.github/` directory
- Use team mentions (`@org/team`) rather than individual users
- Be specific - more specific patterns override less specific ones
- Review and update regularly as team responsibilities change
- Combine with required reviews from code owners in branch protection

## Repository Policies

### Repository Visibility

**[📖 Repository Visibility](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility)** - Visibility settings

| Visibility | Access | Available In |
|-----------|--------|-------------|
| Public | Anyone on internet | All plans |
| Private | Explicit collaborators only | All plans |
| Internal | All enterprise members | Enterprise plans only |

**Enterprise policies:**
- Restrict which visibility types are allowed
- Prevent creating public repositories
- Control forking of private and internal repos
- Default visibility for new repositories

### Repository Creation Policies

**[📖 Repository Creation](https://docs.github.com/en/enterprise-cloud@latest/admin/policies/enforcing-policies-for-your-enterprise/enforcing-repository-management-policies-in-your-enterprise)** - Creation policies

- Control who can create repositories (all members, admins only, specific roles)
- Set default repository visibility
- Control whether members can fork private repos
- Restrict repository transfer between organizations
- Set base permissions for all organization members (None, Read, Write, Admin)

### Repository Templates

**[📖 Template Repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)** - Standardized repos

- Mark a repository as a template
- Users create new repos from the template
- Includes: Files, directory structure, branches (optionally all branches)
- Does not include: Commit history (single initial commit), issues, PRs, settings
- Useful for standardizing project structure, CI/CD configs, compliance files

### Repository Archiving

- Archive repositories that are no longer active
- Archived repos are read-only (no pushes, issues, or PRs)
- Still visible and searchable
- Can be unarchived if needed
- Good for compliance - preserves history without allowing changes

### Repository Transfer

- Transfer repositories between organizations
- Requires admin access on source and destination
- Issues, PRs, and settings transfer with the repo
- Redirects are set up automatically for old URL
- Webhooks and deploy keys may need reconfiguration

## Merge Strategies

**[📖 Merge Methods](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges)** - PR merge options

| Method | Result | History |
|--------|--------|---------|
| Merge commit | Merge commit preserving all commits | Complete branch history |
| Squash merge | Single commit from all PR changes | Clean, linear history |
| Rebase merge | Replay commits on base branch | Linear, preserves individual commits |

- Admins can enable/disable each method per repository
- Auto-merge: Allow PRs to merge automatically when requirements are met
- Delete head branch: Automatically delete branch after merge

## Common Exam Patterns

1. **"Enforce rules across all repositories"** - Organization-level rulesets (not branch protection)
2. **"Automatic review requests"** - CODEOWNERS + required code owner review
3. **"Standardize new project setup"** - Template repositories
4. **"Test rules before enforcing"** - Ruleset evaluate (dry-run) mode
5. **"Only enterprise members can see repo"** - Internal visibility
6. **"Prevent force pushes to main"** - Branch protection or ruleset
7. **"CI bots need to bypass rules"** - Ruleset bypass list for GitHub Apps
8. **"Preserve inactive project"** - Archive the repository
