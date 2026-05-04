---
last-updated: 2026-05-03
---

# Postmortem study guide - AWS S3 us-east-1 outage, 2017-02-28

> A real public postmortem repackaged as exam prep. The incident itself, what AWS published, and the lessons mapped to certs that test the relevant domains.

## What happened

On 28 February 2017, a member of the S3 team was debugging an issue that was causing the S3 billing system to progress more slowly than expected. As part of the work, a team member ran a command intended to remove a small number of servers for one of the S3 subsystems.

**A typo in the command removed a much larger set of servers than intended.** The removed servers supported two other S3 subsystems: the **index subsystem** (which manages the metadata and location information of all S3 objects in the region) and the **placement subsystem** (which manages allocation of new storage).

Because both subsystems lost capacity, S3 in us-east-1 was unable to service requests. Cascading effects took down everything in AWS that depended on S3 in us-east-1: EC2 instance launches (AMI lookup), Lambda invocations, the AWS Console itself (which used S3 for static content), CloudFormation, RDS console, and most third-party services hosted on AWS.

**Total restoration time:** ~4 hours for S3, longer for downstream services.

[**📖 Official AWS post-event summary**](https://aws.amazon.com/message/41926/) - the canonical writeup.

## Root cause analysis

1. **Single command, oversized blast radius.** The command's input had no upper bound on how many servers it could remove. A typo specified more servers than intended.
2. **Both critical S3 subsystems were impacted simultaneously** because they ran in the same affected fleet.
3. **S3 had not been fully restarted in many years** in this region; restart took longer than expected because of the volume of metadata that had to be re-validated.

## What AWS changed (their published actions)

- **Modified the tool** to require additional safety checks and to not allow capacity to be removed below a minimum required level for any subsystem.
- **Audited similar tooling** across S3 to apply the same guardrail.
- **Refined the recovery process** for the index and placement subsystems to handle larger restarts more quickly.

## What this teaches

### Blast radius reduction
- Tools and operator commands should have **input validation** and **upper bounds** on the magnitude of change they can effect.
- "Cell-based architecture" exists to limit incidents like this one - if S3's region was sharded into cells, the incident would have hit only the affected cell.
- Map to: [cell-based architecture pattern](./architecture-patterns/cell-based-architecture.md).

### Single point of failure
- Two independent S3 subsystems in the same fleet = one failure mode taking both out.
- Map to: redundant systems should be **physically and logically independent**, not just nominally separate.

### Multi-region resilience
- Customers running everything in us-east-1 had no fallback. Customers with multi-region active-active or warm standby in another region (us-west-2, eu-west-1) recovered faster.
- Map to: [DR patterns](./architecture-patterns/disaster-recovery-patterns.md), [multi-region active-active](./architecture-patterns/multi-region-active-active.md).

### Hidden dependencies
- The AWS Console used S3 for static assets. When S3 went down, the Console became hard to load - including for AWS engineers responding to the incident. Many third parties had similar hidden dependencies.
- Map to: dependency mapping is a SRE / disaster-recovery discipline.

### Change management
- A routine debugging task in production had outsized blast radius. Production tooling needs the same gates as production deploys: CI, peer review, dry-run mode.
- Map to: change management in [CISA scenarios](../exams/isaca/cisa/scenarios.md), CISM, and SRE practices.

## Cert mapping

| Cert | Domains tested by this incident |
|---|---|
| **AWS Solutions Architect Pro (SAP-C02)** | Multi-region resilience, blast radius, dependency mapping |
| **AWS DevOps Engineer Pro (DOP-C02)** | Tooling guardrails, change management, incident response |
| **AWS Security Specialty (SCS-C02)** | Privileged access controls, IR sequencing |
| **GCP Cloud DevOps Engineer (PDOE)** | SRE postmortem culture, error budgets, blast radius |
| **CISM** | Containment-first IR, lessons-learned cycle, blameless postmortems |

## Discussion questions (use as study prompts)

1. If your app ran 100% in us-east-1 in 2017, what was your fastest possible RTO?
2. What design changes would reduce your blast radius if AWS S3 us-east-1 went down for 4 hours tomorrow?
3. If you're an SRE on the response team, what's your first action when the AWS Console won't load?
4. What's the cell-based-architecture equivalent of this incident? Why did AWS's design lack it?
5. What's the right policy for "destructive operator commands" in production: peer review, dry-run, both, blocked entirely?

## Related

- [Disaster recovery patterns](./architecture-patterns/disaster-recovery-patterns.md)
- [Cell-based architecture](./architecture-patterns/cell-based-architecture.md)
- [Multi-region active-active](./architecture-patterns/multi-region-active-active.md)
- [SRE roadmap](./certification-roadmap-devops-sre.md)
