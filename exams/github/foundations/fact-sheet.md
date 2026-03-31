# GitHub Foundations Certification Fact Sheet

## Exam Overview

**Exam Name:** GitHub Foundations
**Duration:** 120 minutes
**Questions:** 75 multiple choice questions
**Passing Score:** 70%
**Cost:** $99 USD
**Delivery:** Online proctored
**Prerequisites:** None
**Validity:** 3 years

**[Official Exam Page](https://resources.github.com/learn/certifications/)** - Registration and details
**[GitHub Foundations Study Guide](https://assets.ctfassets.net/wfutmusr1t3h/1kmMx7AwI4qH8yIZgOmQlP/4e60030cc6c76688698652e830ea2a48/github-foundations-exam-study-guide.pdf)** - Official study guide
**[GitHub Skills](https://skills.github.com/)** - Interactive learning paths

## Target Audience

This certification is designed for:
- Developers new to GitHub and version control
- Students and early-career professionals
- Project managers and team leads using GitHub
- Anyone seeking to validate GitHub platform knowledge
- Professionals transitioning to collaborative development

## Domain 1: Introduction to Git and GitHub (22%)

### Git Basics

**Core Concepts:**
- **Repository** - A directory tracked by Git containing project files and history
- **Commit** - A snapshot of changes with a message, author, and timestamp
- **Branch** - A lightweight movable pointer to a commit
- **HEAD** - A pointer to the current branch/commit you are working on
- **Remote** - A version of the repository hosted on a server (e.g., GitHub)
- **Working directory** - The files you see and edit on your local machine
- **Staging area (index)** - A holding area for changes to be included in the next commit

**[Git Handbook](https://docs.github.com/en/get-started/using-git/about-git)** - Git fundamentals
**[Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)** - Quick reference for commands

**Essential Git Commands:**
| Command | Purpose |
|---------|---------|
| `git init` | Initialize a new repository |
| `git clone <url>` | Copy a remote repository locally |
| `git add <file>` | Stage changes for commit |
| `git commit -m "message"` | Create a commit with staged changes |
| `git push` | Upload local commits to remote |
| `git pull` | Fetch and merge remote changes |
| `git fetch` | Download remote changes without merging |
| `git branch` | List, create, or delete branches |
| `git checkout` / `git switch` | Switch between branches |
| `git merge` | Combine branch histories |
| `git rebase` | Reapply commits on top of another base |
| `git status` | Show working directory status |
| `git log` | View commit history |
| `git diff` | Show changes between commits/working directory |
| `git stash` | Temporarily save uncommitted changes |
| `git reset` | Unstage or undo commits |

**[Using Git](https://docs.github.com/en/get-started/using-git)** - Comprehensive Git guide
**[About Git](https://docs.github.com/en/get-started/using-git/about-git)** - Git overview

### Git vs GitHub

| Feature | Git | GitHub |
|---------|-----|--------|
| Type | Version control system | Cloud platform |
| Hosting | Local | Cloud-hosted |
| Collaboration | Basic (patches, email) | Rich (PRs, issues, reviews) |
| UI | Command line | Web interface + CLI |
| Extras | None | Actions, Projects, Security |

**[About GitHub](https://docs.github.com/en/get-started/start-your-journey/about-github-and-git)** - GitHub and Git relationship

### GitHub Account Types and Plans

| Feature | Free | Pro | Team | Enterprise |
|---------|------|-----|------|------------|
| Public repos | Unlimited | Unlimited | Unlimited | Unlimited |
| Private repos | Unlimited | Unlimited | Unlimited | Unlimited |
| Collaborators | Unlimited | Unlimited | Unlimited | Unlimited |
| Actions minutes | 2,000/mo | 3,000/mo | 3,000/mo | 50,000/mo |
| Packages storage | 500 MB | 2 GB | 2 GB | 50 GB |
| Code review tools | Basic | Advanced | Advanced | Advanced |
| SAML SSO | No | No | No | Yes |
| Advanced audit | No | No | No | Yes |

**[GitHub Plans](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)** - Plan comparison
**[Account Types](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts)** - Personal, Organization, Enterprise

### GitHub Mobile and Desktop

- **GitHub Mobile** - iOS and Android app for managing notifications, issues, PRs on the go
- **GitHub Desktop** - GUI application for Git operations without command line
- **GitHub CLI (gh)** - Command-line tool for GitHub operations

**[GitHub Mobile](https://docs.github.com/en/get-started/using-github/github-mobile)** - Mobile app features
**[GitHub Desktop](https://docs.github.com/en/desktop)** - Desktop application guide
**[GitHub CLI](https://docs.github.com/en/github-cli)** - CLI tool documentation

## Domain 2: Working with GitHub Repositories (8%)

### Repository Management

**Creating Repositories:**
- New repositories can be created via web, CLI, API, or Desktop
- Choose visibility: public, private, or internal (organizations only)
- Initialize with README, .gitignore, and license

**Key Repository Files:**
| File | Purpose |
|------|---------|
| `README.md` | Project description and documentation |
| `.gitignore` | Files/directories to exclude from tracking |
| `LICENSE` | Open source license terms |
| `CODEOWNERS` | Automatic review assignment rules |
| `CONTRIBUTING.md` | Contribution guidelines |
| `CODE_OF_CONDUCT.md` | Community behavior standards |
| `SECURITY.md` | Security vulnerability reporting |
| `FUNDING.yml` | Sponsorship configuration |

**[Creating a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)** - Step-by-step guide
**[About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)** - README best practices
**[Licensing a Repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)** - License guide

### Clone vs Fork

| Aspect | Clone | Fork |
|--------|-------|------|
| Creates | Local copy | Server-side copy under your account |
| Link to original | Direct remote | Upstream relationship |
| Use case | Direct collaboration | Contributing to others' repos |
| Push access | Requires permissions | Always (to your fork) |
| Stays synced | Via pull/fetch | Manual sync required |

**[Cloning a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)** - Clone guide
**[Fork a Repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)** - Fork guide

### GitHub Pages

- Free static site hosting directly from a repository
- Supports custom domains and HTTPS
- Can use Jekyll or custom static site generators
- Source can be from root, /docs folder, or gh-pages branch

**[GitHub Pages](https://docs.github.com/en/pages)** - Pages documentation

## Domain 3: Collaboration Features (30%)

### Issues

- Track bugs, feature requests, tasks, and discussions
- Support labels, assignees, milestones, and projects
- Can be linked to pull requests using keywords (fixes, closes, resolves)
- Templates can be created for consistent issue reporting
- Support task lists with checkboxes

**[About Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues)** - Issues overview
**[Creating an Issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue)** - Issue creation
**[Linking a PR to an Issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)** - Auto-closing issues

### Pull Requests

**Lifecycle:**
1. Create a branch from the base branch
2. Make commits with changes
3. Open a pull request
4. Request reviewers and address feedback
5. Pass required checks (CI, code review)
6. Merge the pull request
7. Delete the feature branch (optional)

**PR Features:**
- Draft pull requests - signal work in progress
- Review requests - assign specific reviewers
- Code review comments - inline suggestions
- Suggested changes - propose specific code changes
- Status checks - automated CI/CD validation
- Auto-merge - merge when all conditions are met

**[About Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)** - PR overview
**[Creating a Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)** - PR creation
**[Reviewing Changes](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests)** - Code review guide

### Merge Strategies

| Strategy | Result | History | Use Case |
|----------|--------|---------|----------|
| Merge commit | Creates merge commit | Preserves all commits | Default, preserves context |
| Squash and merge | Single commit | Clean linear history | Feature branches with many small commits |
| Rebase and merge | Replays commits | Linear history | Clean history without merge commits |

**[About Merge Methods](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github)** - Merge strategies

### Branch Protection Rules

- Require pull request reviews before merging
- Require status checks to pass before merging
- Require signed commits
- Require linear history
- Restrict who can push to matching branches
- Require conversation resolution before merging
- Lock branch (read-only)

**[Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)** - Protection settings
**[CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)** - Automatic review assignment

### GitHub Markdown

Essential syntax for communication on GitHub:
- Headers, bold, italic, strikethrough
- Lists (ordered, unordered, task lists)
- Links and images
- Code blocks and syntax highlighting
- Tables
- Alerts/admonitions (Note, Warning, Important)
- Mermaid diagrams
- Mathematical expressions (LaTeX)
- Emoji shortcodes

**[Basic Formatting Syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)** - Markdown reference
**[GitHub Flavored Markdown](https://github.github.com/gfm/)** - GFM specification

## Domain 4: Modern Development (13%)

### GitHub Actions Basics

- **Workflow** - Automated process defined in YAML, stored in `.github/workflows/`
- **Event/Trigger** - What starts the workflow (push, pull_request, schedule, etc.)
- **Job** - A set of steps that run on a single runner
- **Step** - An individual task (runs a command or an action)
- **Action** - A reusable unit of code from the Marketplace or custom
- **Runner** - The machine that executes the workflow (GitHub-hosted or self-hosted)

**[Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)** - Actions overview
**[Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)** - YAML reference
**[GitHub Marketplace](https://github.com/marketplace?type=actions)** - Actions marketplace

### GitHub Codespaces

- Cloud-hosted development environment
- Accessible via browser or VS Code
- Pre-configured with devcontainer.json
- Includes default tools, SDKs, and extensions
- Billed per compute and storage usage
- Supports port forwarding and dotfiles

**[GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)** - Codespaces documentation

### GitHub Copilot Basics

- AI-powered code completion tool
- Integrates with VS Code, JetBrains, Neovim, and more
- Provides code suggestions, chat, and explanations
- Available in Individual, Business, and Enterprise plans

**[GitHub Copilot](https://docs.github.com/en/copilot)** - Copilot documentation

## Domain 5: Project Management (7%)

### GitHub Projects

**New Projects (recommended):**
- Flexible table, board, and roadmap views
- Custom fields (text, number, date, single select, iteration)
- Built-in workflows for automation
- Supports cross-repository tracking
- Insights and charts

**Classic Projects:**
- Kanban-style boards
- Limited to a single repository or organization
- Being superseded by new Projects

**[About Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)** - Projects overview
**[Quickstart for Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/quickstart-for-projects)** - Getting started

### Milestones

- Group issues and PRs into milestones with due dates
- Track progress as percentage complete
- Useful for release planning and sprint tracking

**[About Milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones)** - Milestones guide

## Domain 6: Privacy, Security, and Administration (10%)

### Authentication

- **Two-factor authentication (2FA)** - Required for all GitHub.com accounts
- **SSH Keys** - Secure authentication for Git operations
- **Personal Access Tokens (PATs)** - Token-based API/CLI authentication
- **GPG/SSH Signing** - Verify commit authorship
- **SAML SSO** - Enterprise single sign-on (Enterprise plan)

**[About 2FA](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-two-factor-authentication)** - 2FA setup
**[SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)** - SSH configuration
**[Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)** - PAT management

### Security Features

- **Dependabot alerts** - Notify about vulnerable dependencies
- **Secret scanning** - Detect exposed secrets in repositories
- **Code scanning** - Find potential security vulnerabilities in code
- **Security advisories** - Report and manage security vulnerabilities
- **Security policy** - SECURITY.md file for vulnerability reporting

**[Dependabot Alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)** - Dependency vulnerability alerts
**[Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)** - Secret detection
**[Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)** - Code analysis

### Organization Management

- **Roles:** Owner, Member, Billing Manager, Outside Collaborator
- **Teams:** Group members with cascading access permissions
- **Repository permissions:** Read, Triage, Write, Maintain, Admin
- **Audit log:** Track organization activity

**[Organization Roles](https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/roles-in-an-organization)** - Role permissions
**[Managing Teams](https://docs.github.com/en/organizations/organizing-members-into-teams/about-teams)** - Team management

## Domain 7: Benefits of the GitHub Community (10%)

### Open Source

**Common Licenses:**
| License | Type | Key Feature |
|---------|------|-------------|
| MIT | Permissive | Simple, minimal restrictions |
| Apache 2.0 | Permissive | Patent protection included |
| GPL v3 | Copyleft | Derivative work must be GPL |
| BSD 2/3 | Permissive | Similar to MIT |
| LGPL | Weak copyleft | Libraries can be linked freely |
| Unlicense | Public domain | No restrictions whatsoever |

**[Choose a License](https://choosealicense.com/)** - License comparison tool
**[Open Source Guide](https://opensource.guide/)** - GitHub's open source guide

### Contributing to Open Source

1. Find a project (GitHub Explore, Topics, Good First Issues)
2. Read CONTRIBUTING.md and CODE_OF_CONDUCT.md
3. Fork the repository
4. Create a feature branch
5. Make changes and commit
6. Open a pull request
7. Address review feedback

**[Contributing to Projects](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project)** - Contribution guide
**[GitHub Explore](https://github.com/explore)** - Discover projects

### InnerSource

- Applying open source practices within an organization
- Internal collaboration across teams and departments
- Shared codebases with internal visibility
- Benefits: reduced duplication, faster development, knowledge sharing

**[InnerSource Introduction](https://resources.github.com/innersource/fundamentals/)** - InnerSource fundamentals

### Community Features

- **GitHub Sponsors** - Fund open source maintainers
- **GitHub Stars** - Recognize community contributors
- **GitHub Discussions** - Forum-style conversations in repositories
- **Community profiles** - Health score for repositories

**[GitHub Sponsors](https://docs.github.com/en/sponsors)** - Sponsorship program
**[GitHub Discussions](https://docs.github.com/en/discussions)** - Discussions feature

## Exam Tips

### High-Priority Topics (by weight)
1. **Collaboration Features (30%)** - Master issues, PRs, code review
2. **Git and GitHub (22%)** - Know all Git commands and concepts
3. **Modern Development (13%)** - Understand Actions, Codespaces, Copilot basics
4. **Security (10%)** - Know 2FA, SSH, basic security features
5. **Community (10%)** - Understand open source, licenses, InnerSource
6. **Repositories (8%)** - Repository management essentials
7. **Project Management (7%)** - Projects, milestones, labels

### Key Differentiators to Remember
- `git fetch` downloads but does NOT merge; `git pull` does both
- Fork creates a server-side copy; clone creates a local copy
- Squash merge creates one commit; merge commit preserves all
- Issues track work; Discussions are for conversations
- Classic Projects are per-repo; new Projects are cross-repo
- Personal Access Tokens (classic) vs fine-grained tokens
- GitHub-hosted runners vs self-hosted runners
