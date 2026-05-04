---
last-updated: 2026-05-03
---

# Postmortem study guide - GCP networking outage, 2019-06-02

> A real public postmortem from Google Cloud. A network configuration change interacted with software bugs to cause severe degradation in multiple US regions for ~4 hours. Lessons map to PCA, PCNE, DR patterns.

## What happened

On 2 June 2019, Google deployed a configuration change targeting a small number of servers in a single region. **Software bugs** caused that change to be applied much more broadly than intended, removing more than half of the network capacity in multiple regions in the eastern and central United States.

For ~4 hours, customers saw:
- High packet loss across affected regions
- Increased latency
- Service degradation or full outage for many GCP services (Compute Engine, App Engine, Cloud Storage, Cloud SQL)
- Knock-on effects on Google's own consumer products (YouTube, Gmail, G Suite) since they share network infrastructure
- Even Google's internal monitoring and operational tools were degraded, slowing the response

[**📖 Official Google Cloud incident retrospective**](https://status.cloud.google.com/incident/cloud-networking/19009) - the canonical postmortem.

## Root cause analysis

1. **Network configuration change** intended for a subset of servers in one region.
2. **Software bugs in the configuration system** caused the change to apply across multiple regions, withdrawing capacity from far more servers than the operator specified.
3. **Severe congestion** because the remaining network capacity couldn't handle the offered load. Latency-sensitive packets (real-time, control plane) suffered most; bulk traffic continued at lower rates.
4. **Operational tooling degraded** - the diagnostic and recovery tools used by Google's network team ran on the same network that was failing. This slowed both diagnosis and rollback.

## What Google changed (their published actions)

- **Pre-deployment validation** of network configuration changes to catch over-broad scope.
- **Canary process** for network changes (similar to software canary).
- **Independent emergency tooling** for SREs that doesn't depend on the network being repaired.
- **Improved coordination** between network and product teams during incidents to prioritize traffic types.

## What this teaches

### Configuration changes ARE production changes
- A network config change is no different from a code deploy in terms of risk. It needs the same rigor: peer review, dry-run, canary, rollback plan.
- Map to: [GCP DevOps Engineer scenarios](../exams/gcp/cloud-devops-engineer/scenarios.md), change management.

### Operational tools must be independently survivable
- If your diagnostic and rollback tools live on the same infrastructure they're supposed to fix, you can't fix it. This is why airliners have a separate hydraulic system and why SRE tooling should run in a different region or environment.
- Map to: dependency mapping, [DR patterns](./architecture-patterns/disaster-recovery-patterns.md).

### Network is the substrate
- Compute, storage, and database services all depend on network. A network incident degrades everything. SLO design for downstream services should include the network as a dependency.
- Map to: [networking topic index](../topics/networking.md), [GCP Cloud Network Engineer (PCNE)](../exams/gcp/cloud-network-engineer/).

### Multi-region resilience
- Customers running in a single GCP region had no fallback during this incident. Customers with global LB + multi-region had partial mitigation (traffic shifted to unaffected regions).
- Map to: [multi-region active-active](./architecture-patterns/multi-region-active-active.md), Spanner multi-region.

### Communication during incidents
- Customers needed status, not silence. GCP's status page is the primary channel; customers should subscribe and ingest it into their own monitoring.
- Map to: incident response in CISA / CISM, status-page management.

## Cert mapping

| Cert | Domains tested by this incident |
|---|---|
| **GCP Professional Cloud Architect (PCA)** | Multi-region resilience, dependency mapping, business continuity design |
| **GCP Professional Cloud Network Engineer (PCNE)** | Network change management, traffic prioritization (QoS), capacity planning |
| **GCP Professional Cloud DevOps Engineer (PDOE)** | Postmortem culture, error budget, blast radius reduction |
| **CISM** | Incident response, communications, blameless review |
| **AWS / Azure architect certs** | Same multi-region patterns; the principles transfer |

## Discussion questions

1. Your app is single-region in GCP. What's your fastest path to multi-region active-passive?
2. If GCP's networking degrades for 4 hours, which of your alarms fires first? Are they routed to people who can act?
3. Your operational tools run on the same network as your services. Is this acceptable? What change would you make?
4. How do you weigh the cost of always-on multi-region against the probability of a 4-hour single-region outage?
5. What's your status-page strategy for *your* customers when *you* are the dependency that's down?

## Related

- [Multi-region active-active](./architecture-patterns/multi-region-active-active.md)
- [Disaster recovery patterns](./architecture-patterns/disaster-recovery-patterns.md)
- [Hybrid connectivity](./networking-deep-dives/hybrid-connectivity.md)
- [GCP cloud-network-engineer scenarios](../exams/gcp/cloud-network-engineer/scenarios.md)
