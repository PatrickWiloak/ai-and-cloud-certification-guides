# Site Reliability Engineer (SRE) Interview Preparation Guide

## Overview

SRE interviews focus on reliability engineering principles, incident management, observability, capacity planning, automation, and system design for resilient systems. This guide covers core SRE concepts, common interview scenarios, and key topics to prepare for.

---

## SRE Principles

### What Is SRE?

- Coined by Google - "what happens when you ask a software engineer to design an operations function"
- Applies software engineering principles to infrastructure and operations
- Balances reliability with feature development velocity
- Key difference from traditional ops: SREs write code to automate operational work
- Documentation: https://sre.google/sre-book/table-of-contents/

### SLIs, SLOs, and SLAs

**Service Level Indicators (SLIs)**
- Quantitative measure of a specific aspect of service reliability
- Common SLIs:
  - **Availability**: proportion of successful requests (successful requests / total requests)
  - **Latency**: proportion of requests served faster than a threshold (e.g., p99 < 200ms)
  - **Throughput**: rate of requests processed per second
  - **Error rate**: proportion of requests that result in errors
  - **Freshness**: how recently data was updated (for data pipelines)
  - **Durability**: proportion of data retained over time (for storage systems)
- Choose SLIs that reflect the user experience, not internal system metrics

**Service Level Objectives (SLOs)**
- Target value for an SLI over a time window
- Examples:
  - 99.9% of requests succeed over a 30-day rolling window
  - 99% of requests complete in under 200ms
  - 99.99% of stored objects are retained over a year
- SLOs should be set based on user expectations and business needs
- Not every service needs 99.99% - choose the right level for the use case

**Service Level Agreements (SLAs)**
- External contractual commitment with financial consequences
- SLAs should be less aggressive than internal SLOs
- Example: internal SLO of 99.95%, external SLA of 99.9%
- Breach of SLA triggers contractual remedies (credits, refunds)

### Error Budgets

**What is an error budget?**
- The acceptable amount of unreliability within an SLO
- Error budget = 1 - SLO target
- Example: 99.9% SLO = 0.1% error budget

**Error budget in practice:**

| SLO | Error Budget (30 days) | Error Budget (per year) |
|-----|----------------------|------------------------|
| 99% | 7.3 hours | 3.65 days |
| 99.9% | 43.8 minutes | 8.76 hours |
| 99.95% | 21.9 minutes | 4.38 hours |
| 99.99% | 4.38 minutes | 52.6 minutes |

**Error budget policies:**
- When budget is healthy: ship features, deploy frequently, run experiments
- When budget is depleting fast: slow down deployments, focus on reliability work
- When budget is exhausted: freeze feature releases, all hands on reliability
- Error budgets align incentives between development and reliability teams
- Documentation: https://sre.google/workbook/error-budget-policy/

---

## Incident Management

### Incident Response Process

**1. Detection**
- Automated monitoring alerts (SLO-based, threshold-based)
- Customer reports or support tickets
- Synthetic monitoring and health checks

**2. Triage**
- Assess severity based on impact:
  - Sev 1: service down for all users, data loss
  - Sev 2: service degraded for many users, major feature broken
  - Sev 3: service partially degraded, workaround available
  - Sev 4: minor issue, no significant user impact
- Assign incident commander

**3. Communication**
- Update status page (internal and external)
- Notify stakeholders based on severity
- Regular updates at defined intervals (every 15 minutes for Sev 1)

**4. Mitigation**
- Prioritize restoring service over finding root cause
- Common mitigation actions:
  - Rollback recent deployment
  - Scale up resources
  - Redirect traffic (failover to another region)
  - Disable problematic feature (feature flag)
  - Restart services
  - Apply hotfix

**5. Resolution**
- Root cause identified and permanent fix applied
- Verify service is fully restored
- Close the incident

**6. Follow-up**
- Write post-mortem within 48 hours
- Create and track action items
- Share learnings with broader organization

### Incident Commander Role

- Single point of authority during an incident
- Responsibilities:
  - Coordinate response across teams
  - Make decisions when there is disagreement
  - Manage communication to stakeholders
  - Delegate tasks to technical leads and communicators
  - Decide when to escalate
- Does not need to be the most technical person - needs to be organized and calm
- Rotate the IC role to build organizational capability

---

## Post-Mortems

### Writing Effective Post-Mortems

**Structure:**
1. **Summary**: one-paragraph description of the incident
2. **Impact**: duration, affected users, business impact, data loss
3. **Timeline**: detailed chronological events with timestamps
4. **Root cause**: technical explanation of what went wrong
5. **Contributing factors**: what made the incident worse or delayed resolution
6. **What went well**: things that helped during response
7. **What could be improved**: gaps in tooling, processes, or knowledge
8. **Action items**: specific, assigned, and time-bound improvements

### Blameless Post-Mortem Culture

- Focus on systemic issues, not individual blame
- Assume people made the best decisions with the information they had
- Ask "what made this failure possible?" not "who caused this failure?"
- Create psychological safety so people report issues honestly
- Share post-mortems widely to maximize organizational learning
- Track action item completion - post-mortems without follow-through lose credibility
- Documentation: https://sre.google/sre-book/postmortem-culture/

### 5 Whys Technique

- Repeatedly ask "why?" to drill down to the root cause
- Example:
  1. Why did the service go down? The database ran out of connections.
  2. Why did it run out of connections? A code change introduced a connection leak.
  3. Why was the leak not caught? There were no integration tests for connection handling.
  4. Why were there no tests? The testing framework does not support connection pool testing.
  5. Why not? We have not invested in testing infrastructure for database components.
- Root cause: insufficient testing infrastructure for database components
- Action: build connection pool testing capability and add tests for all database interactions

---

## On-Call Practices and Escalation

### Designing an On-Call Rotation

- **Rotation schedule**: weekly or bi-weekly rotations (avoid daily handoffs)
- **Coverage**: primary and secondary on-call for redundancy
- **Handoff process**: documented handoff with known issues and pending action items
- **Compensation**: on-call pay, time off in lieu, or other compensation
- **Load balance**: distribute pages evenly, track and adjust
- **Follow-the-sun**: multiple time zone rotations to avoid night pages

### On-Call Health Metrics

- **Page frequency**: target fewer than 2 pages per on-call shift
- **Time to acknowledge**: measure and target under 5 minutes
- **Time to mitigate**: measure and track trends
- **False positive rate**: alert noise erodes trust and response quality
- **After-hours pages**: minimize through reliability improvements
- If on-call burden is too high, it indicates reliability problems that need investment

### Escalation Policies

- Define clear escalation paths for each service
- Time-based escalation: if no acknowledgment in 5 minutes, page the next person
- Severity-based escalation: Sev 1 pages engineering manager and VP immediately
- Cross-team escalation: documented process for engaging other teams
- Management escalation: when to involve leadership (customer impact, data breach)

### Runbooks

- Every alert should link to a runbook
- Runbook contents:
  - What does this alert mean?
  - What is the impact if not addressed?
  - Step-by-step diagnostic procedures
  - Mitigation steps
  - Escalation contacts
  - Historical context (previous incidents)
- Keep runbooks up to date (review after each incident)
- Automate runbook steps where possible (reduce mean time to mitigate)

---

## Capacity Planning

### Capacity Planning Process

1. **Measure current usage**: collect metrics on CPU, memory, disk, network, request rate
2. **Forecast growth**: project usage based on historical trends and business plans
3. **Model capacity**: determine when current resources will be exhausted
4. **Plan procurement**: order capacity before it is needed (lead time varies)
5. **Validate**: load test to verify capacity meets projected demand

### Key Capacity Metrics

- **Utilization**: current usage as a percentage of capacity
- **Saturation**: how much additional load the system can handle before degradation
- **Headroom**: capacity buffer for unexpected spikes (typically 30-50%)
- **Time to exhaustion**: when current capacity will be fully consumed at projected growth

### Load Testing

- **Types**:
  - Stress test: push beyond normal load to find breaking points
  - Soak test: sustained load over hours to find slow leaks (memory, connections)
  - Spike test: sudden traffic bursts to test auto-scaling response
  - Breakpoint test: incrementally increase load to find exact failure point
- **Tools**: k6, Locust, Gatling, Apache JMeter, wrk
- **Best practices**:
  - Test in a production-like environment
  - Gradually ramp up load
  - Monitor all system components during tests
  - Test regularly (not just before launches)
  - Include dependent services in tests

### Auto-Scaling Strategies

- **Reactive scaling**: scale based on current metrics (CPU, memory, request count)
  - Pro: simple to implement
  - Con: lag between demand increase and capacity addition
- **Predictive scaling**: scale based on forecasted demand
  - Pro: resources ready before demand arrives
  - Con: requires predictable traffic patterns
- **Scheduled scaling**: scale based on known events (time of day, marketing campaigns)
  - Pro: precise and cost-effective
  - Con: only works for predictable events
- Always set minimum capacity to handle baseline traffic plus unexpected spikes

---

## Automation and Toil Reduction

### What Is Toil?

- Work that is:
  - **Manual**: requires a human to perform
  - **Repetitive**: done over and over
  - **Automatable**: could be handled by software
  - **Tactical**: reactive, interrupt-driven
  - **No enduring value**: does not improve the service permanently
  - **Scales linearly**: grows with service size or traffic
- Examples: manual deployments, certificate renewals, log rotation, user provisioning
- Goal: keep toil below 50% of an SRE team's time

### Measuring Toil

- Track time spent on toil vs engineering work
- Categorize tasks: automated, semi-automated, manual
- Survey the team regularly on toil burden
- Use ticket systems to measure frequency and duration of repetitive tasks

### Automation Priority Framework

Prioritize automating tasks based on:
1. **Frequency**: how often is this done? (daily > weekly > monthly)
2. **Time per occurrence**: how long does it take each time?
3. **Error impact**: what happens if a human makes a mistake?
4. **Growth rate**: will this task increase with service growth?

**Automation ROI calculation:**
- Time saved = frequency x time per occurrence x automation rate
- Breakeven = automation development time / time saved per month
- If breakeven is under 6 months, automate it

### Common Automation Targets

- **Deployment**: fully automated CI/CD with rollback capability
- **Scaling**: auto-scaling based on metrics and predictions
- **Incident response**: automated mitigation for known failure modes
- **Certificate management**: automatic renewal and rotation
- **Access provisioning**: self-service with approval workflows
- **Backup and recovery**: automated backup schedules and tested restore procedures
- **Compliance checks**: continuous scanning and automated remediation

---

## Chaos Engineering

### What Is Chaos Engineering?

- The discipline of experimenting on distributed systems to build confidence in reliability
- Proactively inject failures to discover weaknesses before they cause outages
- Pioneered by Netflix with Chaos Monkey
- Documentation: https://principlesofchaos.org/

### Chaos Engineering Principles

1. **Start with a hypothesis**: define what you expect to happen
2. **Vary real-world events**: simulate realistic failures (server crash, network partition)
3. **Run experiments in production**: only production reveals real behavior (start small)
4. **Automate experiments**: run regularly, not just once
5. **Minimize blast radius**: start with small scope, expand gradually

### Common Chaos Experiments

| Experiment | What It Tests | Tools |
|-----------|--------------|-------|
| Kill a random pod/instance | Service redundancy, auto-scaling | Chaos Monkey, Litmus |
| Inject network latency | Timeout handling, circuit breakers | Toxiproxy, tc (traffic control) |
| Network partition | Split-brain handling, quorum behavior | iptables, Chaos Mesh |
| Disk fill | Disk space alerting, log rotation | stress-ng, custom scripts |
| DNS failure | DNS caching, fallback behavior | Custom DNS manipulation |
| Dependency failure | Circuit breaker, graceful degradation | Gremlin, Chaos Mesh |
| Region failover | Multi-region resilience, DNS failover | Manual or automated |

### Implementing Chaos Engineering

1. **Start small**: kill a single non-critical pod in staging
2. **Build confidence**: demonstrate that experiments find real issues
3. **Expand scope**: move to production with small blast radius
4. **Game days**: scheduled chaos experiments with the team present
5. **Continuous chaos**: automated experiments running regularly
6. **Track findings**: document and fix all weaknesses discovered

---

## System Design for Reliability

### Design a Highly Available Web Application

- Multi-AZ deployment with load balancer
- Stateless application servers behind auto-scaling group
- Database: multi-AZ RDS with read replicas, or Aurora with global database
- Caching: Redis/ElastiCache cluster with replication
- Session storage: external store (Redis, DynamoDB) not in-memory
- Static content: CDN for global distribution
- Health checks: load balancer, application, dependency health checks
- Monitoring: request rate, error rate, latency (RED metrics)
- Runbooks: documented procedures for common failure scenarios

### Design for Graceful Degradation

- Identify critical vs non-critical features
- Circuit breakers for external dependencies (fail fast, avoid cascading failures)
- Fallback behavior when dependencies are unavailable:
  - Serve cached data when database is down
  - Show static content when recommendation service fails
  - Queue requests when processing service is overloaded
- Load shedding: reject lowest-priority requests under extreme load
- Feature flags: disable non-essential features during incidents

### Reliability Patterns

- **Circuit breaker**: stop calling a failing service, allow recovery
- **Retry with exponential backoff**: handle transient failures without overwhelming the target
- **Bulkhead**: isolate failures to prevent cascade (separate thread pools, separate services)
- **Timeout**: always set timeouts on external calls (prevent resource exhaustion)
- **Rate limiting**: protect services from being overwhelmed
- **Health checks**: detect unhealthy instances and remove from rotation
- **Idempotency**: design operations to be safely retried

---

## Interview Questions Quick Reference

### Behavioral Questions for SRE

- **Tell me about a major incident you handled.** Use the timeline approach: detection, triage, mitigation, resolution, follow-up
- **How do you balance reliability with feature velocity?** Discuss error budgets and how they create a shared framework
- **Describe a time you automated away significant toil.** Quantify the impact (hours saved, errors prevented)
- **How do you handle disagreements about SLO targets?** Show data-driven approach and stakeholder alignment

### Technical Questions

- **Why is 100% reliability the wrong target?** Diminishing returns, user cannot tell the difference, blocks all change
- **How would you detect a slow memory leak?** Monitor RSS over time, heap profiling, soak testing
- **What is the difference between latency and throughput?** Latency is time per request, throughput is requests per time
- **How do you handle a cascading failure?** Circuit breakers, load shedding, bulkheads, graceful degradation

---

## Key Documentation Links

| Resource | URL |
|----------|-----|
| Google SRE Book | https://sre.google/sre-book/table-of-contents/ |
| Google SRE Workbook | https://sre.google/workbook/table-of-contents/ |
| Principles of Chaos Engineering | https://principlesofchaos.org/ |
| Alerting on SLOs | https://sre.google/workbook/alerting-on-slos/ |
| Post-Mortem Culture | https://sre.google/sre-book/postmortem-culture/ |
| AWS Reliability Pillar | https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html |

---

## Recommended Preparation Resources

- Site Reliability Engineering (The SRE Book) by Google: https://sre.google/sre-book/table-of-contents/
- The Site Reliability Workbook by Google: https://sre.google/workbook/table-of-contents/
- Implementing Service Level Objectives by Alex Hidalgo
- Release It! by Michael Nygard (resilience patterns)
- The Art of Capacity Planning by John Allspaw
- Chaos Engineering by Casey Rosenthal and Nora Jones
