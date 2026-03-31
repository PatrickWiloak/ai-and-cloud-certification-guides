# DevOps Fundamentals

**[📖 DevOps Roadmap](https://roadmap.sh/devops)** - DevOps learning path
**[📖 Git Documentation](https://git-scm.com/doc)** - Official Git reference

## DevOps Overview

### What is DevOps?
- Cultural and technical approach combining Development and Operations
- Goals: faster delivery, improved reliability, better collaboration
- Key principles: automation, CI/CD, monitoring, collaboration, IaC
- Not a role or tool - it is a practice and culture

### DevOps Lifecycle

```
Plan -> Code -> Build -> Test -> Release -> Deploy -> Operate -> Monitor
  ^                                                                  |
  |__________________________________________________________________|
```

### Key DevOps Practices

| Practice | Description |
|----------|-------------|
| **CI/CD** | Automated build, test, and deployment |
| **IaC** | Infrastructure defined as code |
| **Configuration Management** | Automated system configuration |
| **Monitoring** | Observe system health and performance |
| **Microservices** | Small, independent, deployable services |
| **Containerization** | Package applications with dependencies |

## Version Control with Git

### Git Basics

**[📖 Pro Git Book (Free)](https://git-scm.com/book/en/v2)** - Comprehensive Git book

**Configuration:**
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

**Repository Operations:**
```bash
git init                    # initialize new repository
git clone url               # clone remote repository
```

**Daily Workflow:**
```bash
git status                  # check changed files
git add file                # stage specific file
git add .                   # stage all changes
git commit -m "message"     # commit staged changes
git push                    # push to remote
git pull                    # pull from remote (fetch + merge)
```

**Branching:**
```bash
git branch                  # list branches
git branch feature-x        # create branch
git checkout feature-x      # switch to branch
git checkout -b feature-x   # create and switch
git merge feature-x         # merge branch into current
git branch -d feature-x     # delete branch (after merge)
```

**Viewing History:**
```bash
git log                     # commit history
git log --oneline           # condensed history
git diff                    # unstaged changes
git diff --staged           # staged changes
```

### Git Workflow

**Feature Branch Workflow:**
1. Create feature branch from main: `git checkout -b feature/login`
2. Make changes and commit: `git add . && git commit -m "Add login"`
3. Push branch: `git push origin feature/login`
4. Create pull request for code review
5. Merge to main after approval
6. Delete feature branch

**Key Concepts:**
| Concept | Description |
|---------|-------------|
| **Repository** | Project with complete history |
| **Branch** | Independent line of development |
| **Commit** | Snapshot of changes with message |
| **Pull Request** | Request to merge changes (review) |
| **Merge** | Combine branches together |
| **Remote** | Server-hosted repository (GitHub, GitLab) |
| **Clone** | Local copy of a remote repository |

### Git Hosting Platforms

| Platform | Description |
|----------|-------------|
| **GitHub** | Microsoft-owned, largest open source community |
| **GitLab** | Self-hosted option, built-in CI/CD |
| **Bitbucket** | Atlassian-owned, Jira integration |

## CI/CD (Continuous Integration / Continuous Delivery)

### Pipeline Stages

```
Source -> Build -> Test -> Deploy (Staging) -> Deploy (Production)
```

| Stage | Description | Tools |
|-------|-------------|-------|
| **Source** | Code commit triggers pipeline | Git, GitHub, GitLab |
| **Build** | Compile code, create artifacts | Maven, Gradle, Docker |
| **Test** | Run automated tests | JUnit, pytest, Selenium |
| **Deploy** | Deploy to environments | Kubernetes, Terraform |

### CI vs CD

| Term | Full Name | Description |
|------|-----------|-------------|
| **CI** | Continuous Integration | Automatically build and test on every commit |
| **CD** | Continuous Delivery | Automate to staging, manual approval for production |
| **CD** | Continuous Deployment | Fully automated including production deployment |

### CI/CD Tools

| Tool | Type | Description |
|------|------|-------------|
| **Jenkins** | Self-hosted | Open source automation server |
| **GitHub Actions** | Cloud | Integrated with GitHub repositories |
| **GitLab CI** | Self-hosted/Cloud | Built into GitLab |
| **CircleCI** | Cloud | Cloud-based CI/CD |
| **Travis CI** | Cloud | Popular for open source |
| **ArgoCD** | Kubernetes | GitOps-based CD for Kubernetes |

## Infrastructure as Code (IaC)

### What is IaC?
- Define infrastructure using code files instead of manual setup
- Version controlled, reviewable, repeatable
- Eliminates manual configuration errors
- Enables rapid provisioning and scaling

### IaC Tools

| Tool | Type | Language | Cloud Support |
|------|------|----------|---------------|
| **Terraform** | Provisioning | HCL | Multi-cloud |
| **CloudFormation** | Provisioning | YAML/JSON | AWS only |
| **ARM/Bicep** | Provisioning | JSON/Bicep | Azure only |
| **Pulumi** | Provisioning | Python/TS/Go | Multi-cloud |

**Terraform Example:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "web-server"
  }
}
```

### IaC Benefits
- **Reproducibility** - Same code creates same infrastructure
- **Version control** - Track changes over time
- **Automation** - No manual steps
- **Documentation** - Code is the documentation
- **Testing** - Can validate before applying

## Configuration Management

### What is Configuration Management?
- Automate the installation and configuration of software on servers
- Ensure all servers are in a desired state
- Detect and correct configuration drift

### Configuration Management Tools

| Tool | Language | Agent | Push/Pull | Key Feature |
|------|----------|-------|-----------|-------------|
| **Ansible** | YAML | Agentless (SSH) | Push | Simple, no agent needed |
| **Puppet** | Ruby/DSL | Agent | Pull | Mature, enterprise-focused |
| **Chef** | Ruby | Agent | Pull | Powerful, code-centric |
| **Salt** | YAML | Agent or agentless | Both | Fast, scalable |

**Ansible Example (Playbook):**
```yaml
---
- hosts: webservers
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

**Key Differences:**
- **Ansible** is agentless (uses SSH) - simplest to get started
- **Puppet/Chef** require agents installed on target servers
- **Ansible** uses YAML (human-readable), Puppet uses its own DSL

## Monitoring and Observability

### Three Pillars of Observability

| Pillar | Description | Examples |
|--------|-------------|---------|
| **Metrics** | Numeric measurements over time | CPU %, memory, request count |
| **Logs** | Detailed event records | Application errors, access logs |
| **Traces** | Request flow through systems | Distributed tracing |

### Monitoring Tools

| Tool | Type | Description |
|------|------|-------------|
| **Prometheus** | Metrics | Open source metrics collection and alerting |
| **Grafana** | Visualization | Dashboard and visualization platform |
| **ELK Stack** | Logging | Elasticsearch + Logstash + Kibana |
| **Datadog** | Full-stack | Commercial monitoring platform |
| **Nagios** | Infrastructure | Traditional infrastructure monitoring |
| **Splunk** | Logging | Enterprise log analysis |

## Site Reliability Engineering (SRE)

### Key SRE Concepts

| Concept | Description |
|---------|-------------|
| **SLA** | Service Level Agreement (customer-facing promise) |
| **SLO** | Service Level Objective (internal target) |
| **SLI** | Service Level Indicator (metric measuring reliability) |
| **Error Budget** | Acceptable amount of unreliability |
| **Toil** | Repetitive manual work that should be automated |
| **Postmortem** | Blameless analysis after an incident |

**Example:**
- SLI: "99.95% of HTTP requests return successfully"
- SLO: "Maintain 99.9% availability per month"
- SLA: "If below 99.9%, customer receives service credit"

## Key Facts for the Exam

1. Git workflow: clone -> branch -> commit -> push -> pull request -> merge
2. CI builds and tests on every commit, CD automates deployment
3. Terraform is multi-cloud IaC, CloudFormation is AWS-only
4. Ansible is agentless (SSH), Puppet and Chef require agents
5. Three pillars of observability: metrics, logs, traces
6. SLA is customer-facing, SLO is internal target
7. IaC enables version-controlled, repeatable infrastructure
8. Feature branches isolate work and enable code review via pull requests
