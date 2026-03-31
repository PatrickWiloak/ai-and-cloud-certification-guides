# DevOps Engineer Interview Preparation Guide

## Overview

DevOps interviews focus on CI/CD pipeline design, infrastructure as code, container orchestration, monitoring, incident response, and SRE principles. This guide covers common questions, scenarios, and key concepts to help you prepare.

---

## CI/CD Pipeline Design Questions

### Design a CI/CD Pipeline for a Microservices Application

**Requirements**: 20+ microservices, multiple teams, frequent deployments

- Source control: monorepo vs multi-repo (trade-offs)
  - Monorepo: easier code sharing, atomic changes across services, complex CI triggers
  - Multi-repo: clearer ownership, independent versioning, simpler per-service CI
- Pipeline stages:
  1. Code commit triggers pipeline (webhook from GitHub/GitLab)
  2. Build: compile, lint, unit tests
  3. Container image build and push to registry
  4. Security scanning (SAST, container image scanning)
  5. Deploy to staging environment
  6. Integration and end-to-end tests
  7. Manual approval gate (for production)
  8. Deploy to production (canary or blue-green)
  9. Post-deployment smoke tests and monitoring
- Tools: GitHub Actions, GitLab CI, Jenkins, ArgoCD, Flux

### How Would You Implement GitOps?

- Core principles:
  - Git is the single source of truth for infrastructure and application state
  - Changes are made through pull requests, not direct cluster access
  - Automated reconciliation ensures desired state matches actual state
- Implementation:
  - Application manifests stored in a Git repository
  - ArgoCD or Flux watches the repository for changes
  - Pull-based deployment (agent pulls config, more secure than push)
  - Drift detection alerts when actual state diverges from desired state
- Benefits: audit trail, rollback via git revert, consistent environments
- Documentation: https://argo-cd.readthedocs.io/en/stable/

### What Is Your Strategy for Database Schema Changes in CI/CD?

- Use migration tools: Flyway, Liquibase, Alembic, golang-migrate
- Migrations are versioned and stored in source control
- Forward-only migrations (never edit a migration that has been applied)
- Backward-compatible changes for zero-downtime deployments:
  - Add columns as nullable first
  - Create new tables before removing old ones
  - Use expand-contract pattern for schema changes
- Run migrations as a separate step before application deployment
- Include rollback scripts for every migration

### How Do You Handle Secrets in CI/CD Pipelines?

- Never store secrets in source control
- Use secret management tools:
  - HashiCorp Vault
  - AWS Secrets Manager
  - Azure Key Vault
  - Google Secret Manager
- CI/CD platform secrets (GitHub Actions secrets, GitLab CI variables)
- For Kubernetes: External Secrets Operator to sync cloud secrets
- Rotate secrets automatically on a regular schedule
- Audit secret access and usage

---

## Infrastructure as Code Scenarios

### Terraform State Management Issues

**Scenario**: Your team accidentally deleted the Terraform state file. What do you do?

- Prevention:
  - Store state in a remote backend (S3 + DynamoDB, Azure Blob, GCS)
  - Enable state file versioning on the storage bucket
  - Enable state locking to prevent concurrent modifications
  - Restrict access to the state file (contains sensitive data)
- Recovery:
  - Restore from versioned backup in the storage backend
  - If no backup: use `terraform import` to re-associate resources
  - Never recreate resources that are already running in production
- Documentation: https://developer.hashicorp.com/terraform/language/state

**Scenario**: Two engineers are running Terraform apply simultaneously. What happens?

- Without state locking: state corruption, resource conflicts, potential outages
- With state locking (DynamoDB, Consul, Azure Blob lease): second operation fails immediately
- Best practice: always enable state locking, run Terraform in CI/CD only (not locally)

### Terraform Module Design Best Practices

- Keep modules focused on a single responsibility
- Use input variables with descriptions, types, and validation rules
- Output essential values that other modules need
- Version modules using Git tags (semantic versioning)
- Use a module registry (Terraform Cloud, private Git repos)
- Test modules with Terratest or terraform-compliance
- Example module structure:
  ```
  modules/
  ├── networking/
  │   ├── main.tf
  │   ├── variables.tf
  │   ├── outputs.tf
  │   └── README.md
  ├── compute/
  └── database/
  ```
- Documentation: https://developer.hashicorp.com/terraform/language/modules/develop

### How Do You Handle Terraform Drift?

- Drift: actual infrastructure differs from Terraform state
- Detection: run `terraform plan` regularly (scheduled in CI/CD)
- Causes: manual changes in console, other tools modifying resources
- Response options:
  - Import the manual change: `terraform import`
  - Revert the manual change: `terraform apply` to enforce desired state
  - Update Terraform config to match the manual change (if intentional)
- Prevention: restrict console access, enforce changes through IaC only
- Tools: Driftctl, Spacelift drift detection, Terraform Cloud drift detection

---

## Container Orchestration

### Kubernetes Troubleshooting

**Scenario**: Pods are stuck in CrashLoopBackOff. How do you diagnose?

1. Check pod events: `kubectl describe pod <pod-name>`
2. Check container logs: `kubectl logs <pod-name> --previous`
3. Common causes:
   - Application crash on startup (configuration error, missing env vars)
   - Failed health checks (readiness/liveness probes misconfigured)
   - OOM killed (memory limits too low)
   - Missing dependencies (database not reachable, secrets not mounted)
4. Check resource limits: `kubectl top pod`
5. Exec into the container for debugging: `kubectl exec -it <pod-name> -- /bin/sh`

**Scenario**: A service is unreachable from other pods in the cluster.

1. Verify the Service exists: `kubectl get svc`
2. Check Service selector matches pod labels: `kubectl describe svc <svc-name>`
3. Verify endpoints: `kubectl get endpoints <svc-name>` (should list pod IPs)
4. Check network policies: `kubectl get networkpolicies`
5. Test DNS resolution: `kubectl exec -it <pod> -- nslookup <svc-name>`
6. Check pod readiness: unready pods are removed from Service endpoints

### Deployment Strategies in Kubernetes

#### Rolling Update (Default)

- Gradually replaces old pods with new pods
- Configurable: maxSurge and maxUnavailable
- Automatic rollback on failure with `kubectl rollout undo`
- No additional infrastructure needed

#### Blue-Green Deployment

- Run two identical environments (blue = current, green = new)
- Switch traffic by updating the Service selector
- Instant rollback by switching selector back
- Requires double the resources during deployment

#### Canary Deployment

- Deploy new version to a small subset of pods
- Route a percentage of traffic to canary pods
- Monitor error rates and latency
- Gradually increase traffic to canary
- Tools: Flagger, Argo Rollouts, Istio traffic splitting
- Documentation: https://argoproj.github.io/argo-rollouts/

#### A/B Testing

- Route traffic based on request attributes (headers, cookies, user ID)
- Requires service mesh or advanced ingress controller
- Used for feature testing and user experience experiments

### Kubernetes Resource Management

- Always set resource requests and limits for CPU and memory
- Requests: guaranteed resources (used for scheduling)
- Limits: maximum resources (pod is throttled or killed if exceeded)
- Use Vertical Pod Autoscaler (VPA) to recommend resource values
- Use Horizontal Pod Autoscaler (HPA) to scale pod count based on metrics
- Use Pod Disruption Budgets (PDBs) to ensure availability during maintenance
- Documentation: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

---

## Monitoring and Alerting Design

### Design a Monitoring Stack for a Microservices Platform

- Four pillars of observability:
  1. **Metrics**: Prometheus + Grafana (or Datadog, CloudWatch)
  2. **Logs**: EFK stack (Elasticsearch, Fluentd, Kibana) or Loki + Grafana
  3. **Traces**: Jaeger, Zipkin, or cloud-native (X-Ray, Cloud Trace)
  4. **Events**: Kubernetes events, CloudWatch Events, custom event streams

### Key Metrics to Monitor

- **Infrastructure**: CPU, memory, disk, network utilization
- **Application**: request rate, error rate, latency (RED method)
- **Business**: sign-ups, orders, revenue, user engagement
- **Saturation**: queue depth, thread pool usage, connection pool usage

### Alerting Best Practices

- Alert on symptoms, not causes (e.g., "high error rate" not "CPU is high")
- Use severity levels: critical (page), warning (ticket), info (log)
- Avoid alert fatigue - every alert should require action
- Include runbook links in alert notifications
- Implement alerting hierarchy:
  1. Automated remediation (self-healing)
  2. Dashboard with manual intervention
  3. Notification to team channel
  4. Page on-call engineer
- Review and tune alerts regularly (suppress noisy alerts, add missing ones)

### SLI/SLO-Based Alerting

- Define SLIs: availability, latency, throughput, error rate
- Set SLOs: 99.9% availability, p99 latency under 200ms
- Alert on error budget burn rate, not individual metric thresholds
- Fast burn alert: consuming error budget at 14.4x rate (pages immediately)
- Slow burn alert: consuming error budget at 1x rate (creates ticket)
- Documentation: https://sre.google/workbook/alerting-on-slos/

---

## Incident Response Scenarios

### Scenario: Production Website Returns 500 Errors

1. Triage: check monitoring dashboards for scope and impact
2. Communicate: update status page, notify stakeholders
3. Investigate:
   - Check recent deployments (rollback if correlated)
   - Review application logs for error messages
   - Check infrastructure health (database, cache, external services)
   - Verify DNS and certificate status
4. Mitigate: apply the fastest fix first (rollback, restart, scale up)
5. Resolve: apply permanent fix after mitigation
6. Follow up: write post-mortem, create action items

### Scenario: Database CPU at 100%

1. Identify the problem queries: slow query log, Performance Insights, pg_stat_activity
2. Check for recent changes: new deployment, schema change, increased traffic
3. Immediate mitigation: kill long-running queries, add read replica, scale up
4. Root cause: missing index, N+1 query, inefficient join, table lock contention
5. Long-term fix: optimize queries, add indexes, implement caching, connection pooling

### Post-Mortem Best Practices

- Blameless culture - focus on systems and processes, not individuals
- Timeline of events with timestamps
- Root cause analysis (use 5 Whys technique)
- What went well and what could be improved
- Action items with owners and due dates
- Share findings broadly to prevent recurrence
- Template: https://sre.google/sre-book/postmortem-culture/

---

## SRE Principles

### SLIs, SLOs, and SLAs

- **SLI (Service Level Indicator)**: quantitative measure of service reliability
  - Availability: successful requests / total requests
  - Latency: proportion of requests faster than threshold
  - Throughput: requests processed per second
- **SLO (Service Level Objective)**: target value for an SLI
  - Example: 99.9% of requests should succeed (allows 8.76 hours downtime per year)
- **SLA (Service Level Agreement)**: contractual obligation with consequences
  - Typically less aggressive than SLOs (SLO of 99.95%, SLA of 99.9%)

### Error Budgets

- Error budget = 1 - SLO target
- Example: 99.9% SLO means 0.1% error budget (43.8 minutes per month)
- When error budget is healthy: push new features, experiment
- When error budget is consumed: freeze deployments, focus on reliability
- Aligns development velocity with reliability goals

### Toil and Automation

- Toil: manual, repetitive, automatable work that scales linearly with service size
- Goal: keep toil below 50% of engineering time
- Prioritize automating tasks that are:
  - Frequent (daily or weekly)
  - Time-consuming
  - Error-prone when done manually
  - Predictable and well-defined
- Automation examples: scaling, deployment, certificate renewal, log rotation

---

## Technical Questions Quick Reference

### Networking

- **How does DNS resolution work?** Recursive resolver, root servers, TLD servers, authoritative servers
- **Explain TCP three-way handshake.** SYN, SYN-ACK, ACK
- **What is a reverse proxy?** Receives client requests on behalf of backend servers (Nginx, HAProxy)
- **HTTP status codes**: 2xx success, 3xx redirect, 4xx client error, 5xx server error

### Linux

- **How do you troubleshoot high CPU?** `top`, `htop`, `strace`, `perf`
- **How do you troubleshoot disk space?** `df -h`, `du -sh *`, `find / -size +100M`
- **How do you troubleshoot network issues?** `ping`, `traceroute`, `netstat`, `ss`, `tcpdump`
- **What is the difference between a process and a thread?** Processes have separate memory spaces; threads share memory within a process

### Security

- **What is the principle of least privilege?** Grant only the minimum permissions needed
- **Explain mTLS.** Both client and server present certificates for mutual authentication
- **What is a zero-trust network?** Trust nothing, verify everything - authentication and authorization at every boundary

---

## Recommended Preparation Resources

- The Phoenix Project by Gene Kim (DevOps culture)
- Site Reliability Engineering by Google: https://sre.google/sre-book/table-of-contents/
- Kubernetes Documentation: https://kubernetes.io/docs/home/
- Terraform Documentation: https://developer.hashicorp.com/terraform/docs
- The DevOps Handbook by Gene Kim, Jez Humble, Patrick Debois, John Willis
