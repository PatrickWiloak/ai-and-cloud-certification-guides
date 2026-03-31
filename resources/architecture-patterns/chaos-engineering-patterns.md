# Architecture Pattern - Chaos Engineering

## Overview

Chaos engineering is the discipline of experimenting on a system to build confidence in its ability to withstand turbulent conditions in production. By deliberately injecting failures, teams discover weaknesses before they cause outages. This guide covers chaos engineering principles, patterns, and cloud-specific tooling.

---

## Core Principles

### The Chaos Engineering Manifesto

1. **Build a hypothesis around steady state** - Define what "normal" looks like using measurable metrics
2. **Vary real-world events** - Inject failures that mirror real production incidents
3. **Run experiments in production** - Test in the environment that matters most
4. **Automate experiments to run continuously** - Make chaos testing part of CI/CD
5. **Minimize blast radius** - Start small and expand as confidence grows

### Steady State Metrics

| Category | Metrics | Example Threshold |
|----------|---------|-------------------|
| Availability | Uptime percentage, success rate | > 99.95% |
| Latency | p50, p95, p99 response time | p99 < 500ms |
| Throughput | Requests per second | > 1,000 RPS |
| Error Rate | 5xx errors, failed transactions | < 0.1% |
| Saturation | CPU, memory, disk, network utilization | < 80% |
| Business Metrics | Orders per minute, sign-ups | Within 2 standard deviations |

---

## Failure Injection Patterns

### Infrastructure Failures

| Failure Type | Description | What It Tests |
|-------------|-------------|---------------|
| Instance Termination | Kill a VM/container | Auto-scaling, self-healing |
| AZ/Zone Failure | Simulate entire zone outage | Multi-AZ redundancy |
| Region Failure | Simulate entire region outage | Multi-region failover |
| Disk Failure | Corrupt or fill disk | Data durability, alerting |
| Network Partition | Block traffic between services | Timeout handling, circuit breakers |
| DNS Failure | Return errors for DNS queries | DNS failover, caching |
| Clock Skew | Offset system clock | Time-dependent logic, certificates |

### Application Failures

| Failure Type | Description | What It Tests |
|-------------|-------------|---------------|
| Latency Injection | Add artificial delay to requests | Timeout configuration, user experience |
| Error Injection | Return errors from dependencies | Error handling, fallback logic |
| Memory Leak | Gradually consume memory | OOM handling, auto-scaling |
| CPU Stress | Consume CPU resources | Performance degradation, scaling |
| Thread Pool Exhaustion | Consume all threads | Connection pooling, circuit breakers |
| Certificate Expiry | Use expired certificates | Certificate rotation, monitoring |

### Data Failures

| Failure Type | Description | What It Tests |
|-------------|-------------|---------------|
| Database Failover | Force primary to secondary switch | Failover time, connection handling |
| Replication Lag | Introduce replication delay | Read-after-write consistency |
| Data Corruption | Inject corrupt data | Validation, error handling |
| Cache Eviction | Clear cache entirely | Cache miss handling, thundering herd |
| Queue Backlog | Flood message queue | Backpressure, dead letter handling |

### Dependency Failures

| Failure Type | Description | What It Tests |
|-------------|-------------|---------------|
| Third-Party API Outage | Block external API calls | Fallback mechanisms, graceful degradation |
| Payment Gateway Failure | Simulate payment provider outage | Retry logic, user notification |
| CDN Failure | Simulate CDN outage | Origin failover, cache headers |
| Authentication Service Down | Block auth service | Session handling, cached tokens |

---

## Chaos Engineering Tools

### Cloud-Native Tools

| Tool | Cloud | Features |
|------|-------|----------|
| AWS Fault Injection Service (FIS) | AWS | Native AWS chaos - EC2, ECS, EKS, RDS, network |
| Azure Chaos Studio | Azure | Native Azure chaos - VMs, AKS, Cosmos DB, network |
| Google Cloud Fault Injection | GCP | Limited (use third-party or custom) |

### Open-Source Tools

| Tool | Type | Supported Targets |
|------|------|-------------------|
| Chaos Monkey (Netflix) | Instance termination | AWS EC2, Kubernetes |
| Litmus Chaos | Kubernetes-native | Pods, nodes, network, DNS, disk |
| Chaos Mesh | Kubernetes-native | Pods, network, I/O, time, JVM |
| Gremlin | Commercial platform | Multi-cloud, VMs, containers, serverless |
| Toxiproxy | Network proxy | TCP connections (latency, timeout, bandwidth) |
| Pumba | Container chaos | Docker containers (kill, pause, network) |
| PowerfulSeal | Kubernetes | Pods, nodes, network policies |

---

## Cloud Implementation

### AWS Fault Injection Service (FIS)

| Feature | Details |
|---------|---------|
| Experiment Templates | Pre-built and custom templates |
| Targets | EC2, ECS, EKS, RDS, Network, Systems Manager |
| Actions | Instance stop/terminate, network disruption, API throttle |
| Safety | Stop conditions (CloudWatch alarms), rollback |
| IAM | FIS execution role with targeted permissions |
| Logging | CloudWatch Logs, S3 |
| Pricing | Per action-minute |

**AWS FIS Experiment Types:**

| Action | Target | Effect |
|--------|--------|--------|
| aws:ec2:stop-instances | EC2 instances | Stop instances (test auto-scaling) |
| aws:ec2:terminate-instances | EC2 instances | Terminate instances |
| aws:ecs:drain-container-instances | ECS | Drain tasks from instances |
| aws:eks:terminate-nodegroup-instances | EKS | Terminate node group instances |
| aws:rds:failover-db-cluster | Aurora | Force cluster failover |
| aws:rds:reboot-db-instances | RDS | Reboot database instance |
| aws:network:disrupt-connectivity | VPC | Block network traffic |
| aws:ssm:send-command | SSM-managed | Run stress commands |
| aws:fis:inject-api-internal-error | AWS APIs | Simulate API errors |
| aws:fis:inject-api-throttle-error | AWS APIs | Simulate API throttling |

### Azure Chaos Studio

| Feature | Details |
|---------|---------|
| Experiment Types | Service-direct (API-based), Agent-based (VM-level) |
| Targets | VMs, VMSS, AKS, Cosmos DB, NSGs, Key Vault, App Service |
| Faults | CPU/memory pressure, process kill, network faults, DNS |
| Safety | Cancellation, duration limits |
| RBAC | Chaos Target Reader/Contributor roles |
| Logging | Azure Monitor |
| Pricing | Per action-minute |

**Azure Chaos Studio Fault Types:**

| Fault | Target | Effect |
|-------|--------|--------|
| CPU Pressure | VM (agent) | Stress CPU |
| Physical Memory Pressure | VM (agent) | Stress memory |
| Virtual Memory Pressure | VM (agent) | Stress virtual memory |
| Disk I/O Pressure | VM (agent) | Stress disk I/O |
| Kill Process | VM (agent) | Terminate specific process |
| Network Disconnect | VM (agent) | Block network traffic |
| DNS Failure | VM (agent) | Fail DNS resolution |
| AKS Chaos Mesh | AKS | Pod/network/IO faults |
| Cosmos DB Failover | Cosmos DB | Force region failover |
| NSG Security Rule | NSG | Block traffic via rules |

### Google Cloud (Custom Approach)

Google Cloud does not have a native chaos engineering service equivalent to FIS or Chaos Studio. Common approaches:

| Approach | Tools | Targets |
|----------|-------|---------|
| Kubernetes-native | Litmus Chaos, Chaos Mesh on GKE | Pods, nodes, network |
| VM-based | Custom scripts via OS Config | Compute Engine |
| Network | VPC firewall rules (programmatic) | Network connectivity |
| Database | Manual failover triggers | Cloud SQL, Spanner |
| Third-party | Gremlin, Steadybit | Multi-service |

---

## Experiment Design

### Experiment Template

| Field | Description | Example |
|-------|-------------|---------|
| Hypothesis | What you expect to happen | "When we terminate 1 of 3 web servers, response time stays under 500ms" |
| Steady State | Normal system metrics | p99 latency < 500ms, error rate < 0.1% |
| Method | How to inject the failure | Terminate EC2 instance in us-east-1a |
| Duration | How long the experiment runs | 5 minutes |
| Blast Radius | Scope of impact | 1 instance in 1 AZ |
| Abort Conditions | When to stop | Error rate > 5% or latency > 2s |
| Rollback Plan | How to restore | Auto-scaling replaces instance, or manual restart |
| Observation | What to monitor | CloudWatch metrics, X-Ray traces, user-facing errors |

### Maturity Model

| Level | Name | Practices |
|-------|------|-----------|
| 1 | Ad Hoc | Manual failure injection in staging |
| 2 | Repeatable | Documented experiments, regular execution |
| 3 | Defined | Automated experiments in CI/CD pipeline |
| 4 | Managed | Continuous chaos in production, game days |
| 5 | Optimized | AI-driven experiment selection, automated remediation |

---

## Game Day Planning

### Game Day Structure

| Phase | Duration | Activities |
|-------|----------|------------|
| Preparation | 1-2 weeks | Define scenarios, set up monitoring, brief team |
| Pre-Game | 30 minutes | Verify steady state, confirm abort conditions |
| Execution | 2-4 hours | Run experiments, observe, document findings |
| Post-Game | 1-2 hours | Review findings, prioritize fixes, retrospective |
| Follow-Up | 1-2 weeks | Implement fixes, schedule next game day |

### Common Game Day Scenarios

| Scenario | Description | Services Tested |
|----------|-------------|-----------------|
| AZ Failure | Simulate losing an entire availability zone | Multi-AZ architecture |
| Database Failover | Force primary database failover | Application retry logic, connection handling |
| DNS Outage | Simulate DNS resolution failures | DNS caching, fallback |
| Dependency Outage | Block traffic to external dependency | Circuit breakers, fallback |
| Spike Load | 10x normal traffic | Auto-scaling, rate limiting |
| Security Incident | Simulated credential compromise | Incident response, key rotation |
| Data Center Evacuation | Fail over to DR region | DR procedures, RTO/RPO validation |

---

## Integration with CI/CD

### Chaos in the Pipeline

```
Code Commit -> Build -> Unit Tests -> Integration Tests -> Deploy to Staging
                                                                  |
                                                          Chaos Experiments
                                                          (automated, 15 min)
                                                                  |
                                                          ┌── Pass -> Deploy to Production
                                                          │
                                                          └── Fail -> Block Deployment
                                                                      Alert Team
```

### Continuous Chaos

| Frequency | Scope | Automation |
|-----------|-------|------------|
| Every deployment | Basic health chaos (instance kill) | Fully automated |
| Daily | Service-level failures | Automated with alerts |
| Weekly | Cross-service failures | Semi-automated |
| Monthly | AZ/region failures (game day) | Guided, with team participation |
| Quarterly | Full DR drill | Planned, executive-sponsored |

---

## Observability for Chaos

### What to Monitor During Experiments

| Layer | Metrics | Tools |
|-------|---------|-------|
| Infrastructure | CPU, memory, disk, network | CloudWatch, Azure Monitor, Cloud Monitoring |
| Application | Latency, error rate, throughput | X-Ray, Application Insights, Cloud Trace |
| Business | Orders/minute, sign-ups, revenue | Custom dashboards, analytics |
| User Experience | Page load time, error pages, abandonment | RUM, synthetic monitoring |
| Dependencies | External API latency, circuit breaker state | Custom metrics, service mesh |

---

## Certification Exam Focus Areas

### AWS
- AWS FIS experiment templates and actions
- FIS integration with CloudWatch alarms (stop conditions)
- FIS IAM roles and permissions
- Multi-AZ and multi-Region resilience testing
- Well-Architected Framework reliability pillar

### Azure
- Azure Chaos Studio experiments and faults
- Agent-based vs service-direct faults
- Chaos Studio RBAC and permissions
- AKS Chaos Mesh integration
- Azure Well-Architected Framework reliability

### Google Cloud
- GKE chaos testing with Litmus/Chaos Mesh
- Cloud SQL and Spanner failover testing
- VPC firewall rule manipulation for network chaos
- Error budget monitoring and SLO validation
- Google SRE principles and practices

---

## Documentation Links

- AWS Fault Injection Service: https://docs.aws.amazon.com/fis/latest/userguide/
- Azure Chaos Studio: https://learn.microsoft.com/en-us/azure/chaos-studio/
- Litmus Chaos: https://litmuschaos.io/docs
- Chaos Mesh: https://chaos-mesh.org/docs/
- Gremlin: https://www.gremlin.com/docs/
- Principles of Chaos Engineering: https://principlesofchaos.org/

---

## Key Takeaways

1. Chaos engineering is about building confidence, not breaking things - always have a hypothesis and abort conditions
2. Start small in staging, then gradually move to production with increasing blast radius
3. AWS FIS and Azure Chaos Studio provide native, managed chaos tools - GCP requires third-party solutions
4. Game days are the highest-value chaos activity - they test both systems and people
5. Integrate basic chaos experiments into CI/CD for continuous resilience validation
6. Every chaos experiment should produce actionable findings - if everything passes, increase the scope
7. Observability is a prerequisite - you cannot run chaos experiments without robust monitoring
8. Chaos engineering validates your disaster recovery plans before you need them in a real incident
