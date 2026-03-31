# Modern Development

## GitHub Actions

GitHub Actions is a CI/CD platform that allows you to automate build, test, and deployment pipelines directly from your repository.

**[Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)** - Actions overview
**[GitHub Actions Documentation](https://docs.github.com/en/actions)** - Complete reference

### Core Concepts

| Component | Description |
|-----------|-------------|
| **Workflow** | Automated process defined in YAML, stored in `.github/workflows/` |
| **Event** | Trigger that starts a workflow (push, PR, schedule, manual) |
| **Job** | Set of steps that run on a single runner |
| **Step** | Individual task within a job (run command or use action) |
| **Action** | Reusable unit of code (from Marketplace or custom) |
| **Runner** | Machine that executes workflow jobs |

### Basic Workflow Structure
```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test
```

### Common Triggers (Events)
| Trigger | Description |
|---------|-------------|
| `push` | When commits are pushed to a branch |
| `pull_request` | When a PR is opened, updated, or synchronized |
| `schedule` | Cron-based schedule (e.g., nightly builds) |
| `workflow_dispatch` | Manual trigger from the Actions tab |
| `release` | When a release is published |
| `issues` | When an issue is opened, edited, deleted |
| `repository_dispatch` | External event via API |

**[Events that Trigger Workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)** - Complete trigger reference

### Workflow Syntax Key Points
- Workflows are YAML files in `.github/workflows/` directory
- Multiple workflows can exist in a single repository
- Jobs run in parallel by default
- Steps within a job run sequentially
- Use `needs:` to create job dependencies
- Use `if:` for conditional execution

**[Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)** - YAML reference

### Runners
- **GitHub-hosted runners** - Managed by GitHub (Ubuntu, Windows, macOS)
- **Self-hosted runners** - Your own machines registered with GitHub
- GitHub-hosted runners provide clean environments for each job
- Self-hosted runners can access internal resources

**[About GitHub-Hosted Runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners)** - Runner options

### GitHub Actions Marketplace
- Thousands of pre-built actions created by the community
- Common actions: checkout, setup-node, cache, upload-artifact
- Can use specific versions: `uses: actions/checkout@v4`
- Actions can be JavaScript, Docker, or composite

**[GitHub Marketplace](https://github.com/marketplace?type=actions)** - Browse actions

### Actions Usage and Billing
| Plan | Included Minutes/Month | Storage |
|------|----------------------|---------|
| Free | 2,000 | 500 MB |
| Pro | 3,000 | 1 GB |
| Team | 3,000 | 2 GB |
| Enterprise | 50,000 | 50 GB |

- Public repositories get unlimited free minutes
- Different runner types have different minute multipliers
- Linux: 1x, Windows: 2x, macOS: 10x

**[About Billing for GitHub Actions](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions)** - Billing details

## GitHub Codespaces

GitHub Codespaces provides cloud-hosted development environments that can be accessed from a browser or VS Code.

**[GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)** - Codespaces documentation

### Key Features
- **Instant environments** - Start coding in seconds
- **Browser-based** - Full VS Code in your browser
- **VS Code integration** - Connect from local VS Code
- **Pre-configured** - Defined via devcontainer.json
- **Port forwarding** - Access running applications
- **Dotfiles support** - Personalize your environment
- **Prebuilds** - Faster start times with pre-built images

### devcontainer.json
Configuration file that defines the development environment:
```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "postCreateCommand": "npm install",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint"]
    }
  },
  "forwardPorts": [3000]
}
```

**[Setting Up Your Codespace](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration)** - Configuration guide

### Codespaces Billing
- Billed for compute (per hour) and storage (per GB/month)
- Free tier includes limited hours per month
- Compute charges only while codespace is running
- Storage charges for all codespaces (running or stopped)

**[About Billing for Codespaces](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)** - Billing details

### Codespaces vs Local Development
| Aspect | Codespaces | Local Development |
|--------|-----------|-------------------|
| Setup time | Seconds | Minutes to hours |
| Consistency | Same environment for all | Varies by machine |
| Resources | Cloud-based | Your machine |
| Access | Browser or VS Code | Requires local tools |
| Cost | Pay per use | Your hardware |
| Offline | Requires internet | Works offline |

## GitHub Copilot Overview

GitHub Copilot is an AI-powered coding assistant that helps developers write code faster.

**[About GitHub Copilot](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)** - Copilot overview

### Features (Foundations-level knowledge)
- **Code completion** - Suggests whole lines or functions as you type
- **Chat** - Ask questions about code in the IDE or on GitHub.com
- **Code explanations** - Understand unfamiliar code
- **Test generation** - Help write unit tests
- **Documentation** - Generate docstrings and comments

### Copilot Plans
| Plan | Target | Key Features |
|------|--------|-------------|
| Individual | Personal use | Code completion, chat |
| Business | Organizations | Admin controls, policy management |
| Enterprise | Large organizations | Knowledge bases, fine-tuning, advanced features |

### IDE Support
- Visual Studio Code
- Visual Studio
- JetBrains IDEs
- Neovim
- GitHub.com (Copilot Chat)

**[GitHub Copilot](https://docs.github.com/en/copilot)** - Copilot documentation

## CI/CD Concepts

### Continuous Integration (CI)
- Automatically build and test code on every push
- Catch bugs early before they reach production
- Ensure code quality through automated checks
- GitHub Actions provides built-in CI capabilities

### Continuous Deployment/Delivery (CD)
- **Continuous Delivery** - Automated testing, manual deployment
- **Continuous Deployment** - Fully automated from commit to production
- GitHub Actions supports deployment to any platform
- Environments provide protection rules for deployments

### GitHub CI/CD Best Practices
- Run tests on every pull request
- Use branch protection to require passing checks
- Cache dependencies for faster builds
- Use matrix strategies to test across versions
- Implement deployment environments with approvals

**[About Continuous Integration](https://docs.github.com/en/actions/automating-builds-and-tests/about-continuous-integration)** - CI guide

## GitHub Marketplace

The Marketplace is where you find tools to enhance your GitHub workflow.

**[GitHub Marketplace](https://github.com/marketplace)** - Browse Marketplace

### Categories
- **Actions** - Reusable workflow components
- **Apps** - OAuth or GitHub Apps that integrate with GitHub

### Popular Actions
| Action | Purpose |
|--------|---------|
| `actions/checkout` | Check out repository code |
| `actions/setup-node` | Set up Node.js environment |
| `actions/cache` | Cache dependencies |
| `actions/upload-artifact` | Save build artifacts |
| `actions/github-script` | Run JavaScript in workflows |

## Key Exam Points

- GitHub Actions workflows are YAML files in `.github/workflows/`
- Jobs run in parallel by default; use `needs:` for dependencies
- Steps run sequentially within a job
- Common triggers: push, pull_request, schedule, workflow_dispatch
- Codespaces are configured via devcontainer.json
- Codespaces charges for both compute and storage
- GitHub Copilot is AI-powered code completion (know plans, not deep features)
- CI runs tests automatically; CD deploys automatically
- GitHub-hosted runners are managed; self-hosted are your infrastructure
- Public repos get unlimited free Actions minutes
- The Marketplace provides pre-built actions and apps
