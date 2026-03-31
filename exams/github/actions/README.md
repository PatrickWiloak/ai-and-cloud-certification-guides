# GitHub Actions Certification

## Exam Overview

The GitHub Actions certification validates your ability to streamline workflows and automate tasks using GitHub Actions. This exam tests your knowledge of workflow authoring, custom action development, managing workflows across teams, and enterprise-level CI/CD administration. It is designed for DevOps engineers, platform engineers, and developers who use GitHub Actions for automation.

**Exam Details:**
- **Duration:** 120 minutes
- **Format:** Multiple choice (65 questions)
- **Passing Score:** 70%
- **Cost:** $99 USD
- **Delivery:** Online proctored
- **Validity:** 3 years
- **Prerequisites:** None (GitHub Foundations recommended)
- **Retake Policy:** 24-hour wait for first retake, 14 days for subsequent

**Important:** This exam focuses heavily on workflow authoring (40% of the exam). Be comfortable with YAML workflow syntax, event triggers, job dependencies, and expression syntax.

## Exam Domains

### Domain 1: Author and Maintain Workflows (40%)
The largest domain - covers creating, configuring, and managing GitHub Actions workflows.

- Workflow YAML syntax and structure
- Event triggers (push, pull_request, schedule, workflow_dispatch, repository_dispatch)
- Job configuration and runner selection
- Step-level actions and run commands
- Expression syntax and contexts (github, env, secrets, inputs)
- Conditional execution (if conditions)
- Matrix strategies for testing across versions/platforms
- Workflow artifacts and caching
- Environment variables and secrets
- Concurrency controls
- Reusable workflows (workflow_call)
- Job dependencies and outputs
- Status check functions (success, failure, always, cancelled)
- Permissions and GITHUB_TOKEN

**Key Concepts:**
- Workflow file location: `.github/workflows/`
- Events trigger workflows, workflows contain jobs, jobs contain steps
- Jobs run in parallel by default (use `needs` for dependencies)
- Runners: GitHub-hosted (ubuntu-latest, windows-latest, macos-latest) and self-hosted

### Domain 2: Consume Workflows (20%)
Using and managing existing workflows and actions from the marketplace.

- Using actions from the GitHub Marketplace
- Pinning actions to versions (SHA, tag, branch)
- Using starter workflows
- Understanding action types (JavaScript, Docker, composite)
- Action inputs, outputs, and environment files
- Workflow templates for organizations
- Triggering workflows from other workflows

**Key Concepts:**
- Pin actions to full SHA for security, tags for convenience
- Starter workflows provide templates for common CI/CD patterns
- Organization-level workflow templates in `.github` repository

### Domain 3: Author and Maintain Actions (25%)
Creating custom GitHub Actions for reuse.

- JavaScript actions (Node.js runtime)
- Docker container actions
- Composite actions (combine multiple steps)
- action.yml metadata file
- Action inputs and outputs
- Publishing actions to the Marketplace
- Testing custom actions
- Toolkit packages (@actions/core, @actions/github, @actions/exec)
- Versioning and release management for actions

**Key Concepts:**
- JavaScript actions are fastest (no container overhead)
- Docker actions support any language but are Linux-only
- Composite actions combine existing actions and run steps
- action.yml defines inputs, outputs, and the execution entry point

### Domain 4: Manage GitHub Actions for the Enterprise (15%)
Administering GitHub Actions at the organization and enterprise level.

- Self-hosted runners (setup, security, scaling)
- Runner groups and access control
- Organization and enterprise Actions policies
- Allowed actions and reusable workflows
- Secrets management at org and enterprise level
- Billing and usage management
- Audit logging for Actions
- Network configuration for runners
- OIDC for cloud deployments

**Key Concepts:**
- Self-hosted runners for custom environments, compliance, and cost control
- Runner groups control which repos/orgs can use specific runners
- Enterprise policies can restrict which actions are allowed
- OIDC enables cloud authentication without long-lived secrets

## Study Resources

### Official Resources
- **[📖 GitHub Actions Documentation](https://docs.github.com/en/actions)** - Complete Actions documentation
- **[📖 Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - YAML syntax reference
- **[📖 GitHub Actions Exam Study Guide](https://assets.ctfassets.net/wfutmusr1t3h/2mMJ6nECbUAdiQMTObbPw6/67cfbffa68fed774a1d4bfc45e1fda83/github-actions-exam-preparation-study-guide__1_.pdf)** - Official study guide
- **[📖 GitHub Skills](https://skills.github.com/)** - Interactive learning paths
- **[📖 GitHub Marketplace](https://github.com/marketplace?type=actions)** - Browse available actions

### Recommended Courses
1. **GitHub Learning Pathways** - Free official learning paths
2. **LinkedIn Learning - GitHub Actions** - Comprehensive course
3. **Udemy GitHub Actions courses** - Practice exams available

### Community Resources
- **[📖 Awesome Actions](https://github.com/sdras/awesome-actions)** - Curated list of actions
- **GitHub Community Discussions** - Q&A and tips
- **r/github** - Reddit community

---

**Good luck with your GitHub Actions certification!**

Remember: Workflow authoring is 40% of the exam. Master the YAML syntax, understand all event trigger types, and know how to use expressions, conditionals, matrix strategies, and reusable workflows. Practice building actual workflows in a test repository.
