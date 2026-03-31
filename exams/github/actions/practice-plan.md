# GitHub Actions Study Plan

## 4-Week Study Schedule

### Week 1: Workflow Fundamentals

#### Day 1-2: YAML Syntax and Triggers
- [ ] Study workflow file structure (name, on, jobs, steps)
- [ ] Learn all event triggers (push, pull_request, schedule, workflow_dispatch)
- [ ] Understand trigger filters (branches, paths, tags)
- [ ] Practice creating basic workflows
- [ ] Review Notes: `notes/01-workflow-authoring.md`

#### Day 3-4: Expressions and Conditionals
- [ ] Study expression syntax and all contexts (github, env, secrets, etc.)
- [ ] Learn status functions (success, failure, always, cancelled)
- [ ] Practice conditional execution with `if`
- [ ] Understand GITHUB_TOKEN and permissions
- [ ] Review Notes: `notes/02-expressions-contexts.md`

#### Day 5-6: Advanced Workflow Features
- [ ] Study matrix strategies (combinations, include, exclude, fail-fast)
- [ ] Learn artifacts (upload/download between jobs)
- [ ] Understand caching for dependencies
- [ ] Practice concurrency controls
- [ ] Study job dependencies and outputs (needs)

#### Day 7: Week 1 Review
- [ ] Build a complete CI workflow from scratch
- [ ] Quiz yourself on trigger types and filter syntax
- [ ] Review any weak areas

### Week 2: Reusable Workflows and Actions

#### Day 8-9: Reusable Workflows and Templates
- [ ] Study workflow_call trigger and reusable workflows
- [ ] Learn inputs, secrets, and outputs for reusable workflows
- [ ] Understand secrets: inherit
- [ ] Study starter workflows and organization templates
- [ ] Review Notes: `notes/03-consuming-workflows.md`

#### Day 10-11: Custom Action Development
- [ ] Study JavaScript actions (Node.js, @actions/core toolkit)
- [ ] Learn Docker container actions
- [ ] Understand composite actions
- [ ] Study action.yml metadata syntax
- [ ] Review Notes: `notes/04-custom-actions.md`

#### Day 12-13: Action Publishing and Marketplace
- [ ] Learn action versioning and release management
- [ ] Study publishing to the GitHub Marketplace
- [ ] Understand action pinning (SHA, tag, branch)
- [ ] Practice creating a simple composite action

#### Day 14: Week 2 Review
- [ ] Create a reusable workflow and call it from another workflow
- [ ] Build a simple custom action
- [ ] Quiz on action types and their differences

### Week 3: Enterprise Management and Security

#### Day 15-16: Self-Hosted Runners
- [ ] Study self-hosted runner setup and configuration
- [ ] Learn runner groups and access control
- [ ] Understand runner labels and targeting
- [ ] Study auto-scaling options (ARC)
- [ ] Review Notes: `notes/05-enterprise-management.md`

#### Day 17-18: Enterprise Policies and Security
- [ ] Study organization and enterprise Actions policies
- [ ] Learn allowed actions configuration
- [ ] Understand OIDC for cloud deployments
- [ ] Study secrets management at org and enterprise level
- [ ] Learn audit logging for Actions

#### Day 19-20: Security Best Practices
- [ ] Study action pinning and supply chain security
- [ ] Learn GITHUB_TOKEN permission hardening
- [ ] Understand pull_request vs pull_request_target security
- [ ] Study secrets best practices
- [ ] Review billing and usage management

#### Day 21: Week 3 Review
- [ ] Configure a mock enterprise Actions policy
- [ ] Write an OIDC deployment workflow
- [ ] Quiz on enterprise features and security

### Week 4: Comprehensive Review and Exam Prep

#### Day 22-23: Full Review - High-Weight Domains
- [ ] Deep review of Workflow Authoring (40%)
- [ ] Review Custom Actions (25%)
- [ ] Practice writing workflows and action.yml from memory

#### Day 24-25: Full Review - Remaining Domains
- [ ] Review Consuming Workflows (20%)
- [ ] Review Enterprise Management (15%)
- [ ] Create flashcards for key concepts

#### Day 26-27: Practice Exams
- [ ] Take a full-length practice exam (timed, 120 minutes)
- [ ] Review all incorrect answers
- [ ] Take a second practice exam focusing on improvement

#### Day 28: Pre-Exam Preparation
- [ ] Light review of YAML syntax and key features
- [ ] Verify exam environment
- [ ] Rest and mental preparation

## Study Resources

### Quick Links
- **[GitHub Actions Docs](https://docs.github.com/en/actions)** - Documentation
- **[Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)** - YAML reference
- **[GitHub Skills](https://skills.github.com/)** - Interactive courses
- **[GitHub Certifications](https://resources.github.com/learn/certifications/)** - Registration

---

## Final Exam Checklist

### One Week Before
- [ ] Scoring 75%+ consistently on practice exams
- [ ] Comfortable with workflow YAML syntax
- [ ] All domains reviewed
- [ ] Enterprise features understood

### Exam Day
- [ ] Read each question carefully
- [ ] Pay attention to YAML syntax details in answers
- [ ] Flag uncertain questions and return later
- [ ] Use the full 120 minutes
