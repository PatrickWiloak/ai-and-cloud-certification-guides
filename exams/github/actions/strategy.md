# GitHub Actions Study Strategy

## Study Approach

### Phase 1: Workflow Authoring (Weeks 1-2)
1. **Workflow Fundamentals**
   - YAML syntax and workflow file structure
   - Event triggers (push, pull_request, schedule, workflow_dispatch)
   - Trigger filters (branches, paths, tags)
   - Jobs, steps, and runner selection
   - GITHUB_TOKEN and permissions

2. **Expressions and Conditionals**
   - Expression syntax `${{ }}`
   - Contexts: github, env, secrets, inputs, steps, needs, matrix
   - Status functions: success(), failure(), always(), cancelled()
   - Conditional execution with `if` on jobs and steps

3. **Advanced Workflow Features**
   - Matrix strategies (combinations, include/exclude, fail-fast)
   - Artifacts (upload/download between jobs)
   - Caching dependencies
   - Concurrency controls
   - Reusable workflows (workflow_call)
   - Job outputs and dependencies (needs)
   - Environment variables and secrets

### Phase 2: Actions Development (Weeks 2-3)
1. **Consuming Actions**
   - Finding actions on the Marketplace
   - Pinning actions (SHA vs tag vs branch)
   - Understanding action inputs and outputs
   - Starter workflows and templates

2. **Creating Custom Actions**
   - JavaScript actions (Node.js, @actions/core toolkit)
   - Docker container actions
   - Composite actions (combining steps)
   - action.yml metadata file
   - Inputs, outputs, and environment files
   - Publishing to the Marketplace
   - Versioning with tags and releases

### Phase 3: Enterprise and Exam Prep (Weeks 3-4)
1. **Enterprise Administration**
   - Self-hosted runners (setup, security, scaling)
   - Runner groups and access control
   - Organization and enterprise policies
   - Allowed actions configuration
   - Secrets at org and enterprise level
   - OIDC for cloud deployments
   - Audit logging and billing

2. **Practice Exams**
   - Take practice tests and review wrong answers
   - Focus on workflow YAML syntax (40%)
   - Review all event trigger types and filters

## Study Resources

### Primary Resources
- **[GitHub Actions Documentation](https://docs.github.com/en/actions)** - Complete documentation
- **[Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - YAML reference
- **[GitHub Skills](https://skills.github.com/)** - Interactive courses
- **[GitHub Actions Study Guide](https://assets.ctfassets.net/wfutmusr1t3h/2mMJ6nECbUAdiQMTObbPw6/67cfbffa68fed774a1d4bfc45e1fda83/github-actions-exam-preparation-study-guide__1_.pdf)** - Official prep guide

### Supplementary Resources
- **[Events Reference](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)** - All trigger events
- **[Expressions](https://docs.github.com/en/actions/reference/expressions)** - Expression syntax
- **[Creating Actions](https://docs.github.com/en/actions/creating-actions)** - Custom action development
- **[Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)** - Runner documentation
- **[OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments)** - Security hardening

### Community
- **GitHub Community Discussions** - Q&A and tips
- **r/github** - Reddit community
- **GitHub Blog** - New features and announcements

## Exam Tactics

### Time Management (120 minutes, 65 questions)
- Average ~1.8 minutes per question
- Answer confident questions first
- Flag uncertain questions for review
- Reserve 15-20 minutes for flagged questions

### Domain Prioritization
- **Author and Maintain Workflows (40%)** - Primary focus
- **Author and Maintain Actions (25%)** - Second priority
- **Consume Workflows (20%)** - Know marketplace, pinning, templates
- **Manage for Enterprise (15%)** - Self-hosted runners, policies, OIDC

## Common Pitfalls

### Study Mistakes
- **Not building real workflows** - Theory alone is insufficient. Create workflows in a test repo
- **Ignoring enterprise features** - 15% of the exam covers enterprise management
- **Not reading the docs** - GitHub docs are excellent and exam questions reference them

### Content Mistakes
- Confusing `pull_request` vs `pull_request_target` security context
- Not knowing that `workflow_dispatch` supports typed inputs
- Confusing composite actions with reusable workflows
- Not understanding job dependencies and data passing
- Forgetting that Docker actions are Linux-only

## Progress Tracking

### Readiness Indicators
- [ ] You can write workflow YAML from memory (triggers, jobs, steps, expressions)
- [ ] You understand all event trigger types and their filter options
- [ ] You can create all three action types (JS, Docker, composite)
- [ ] You understand self-hosted runners and enterprise policies
- [ ] You score 75%+ consistently on practice exams
