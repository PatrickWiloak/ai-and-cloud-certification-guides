---
last-updated: 2026-05-03
---

# Playlist - Cloud security, 1 hour

Eight reads in order, ~60 minutes total. By the end you have working mental models for the four pillars of cloud security: shared responsibility, identity, network isolation, and data protection. You'll know enough to read an architecture diagram and identify the biggest security risks.

## The reads, in order

1. **[Shared responsibility model](../learn/concepts/shared-responsibility-model.md)** (~4 min)
   Where the cloud provider's job ends and yours begins. Foundational; every other security decision depends on this.

2. **[IAM explained](../learn/concepts/iam-explained.md)** (~8 min)
   Authentication vs authorization. Identities, roles, policies. RBAC vs ABAC. Why IAM is the source of most cloud breaches.

3. **[VPC explained](../learn/concepts/vpc-explained.md)** (~6 min)
   Private network isolation. Subnets, security groups, NACLs, NAT, IGW. The network layer of defense.

4. **[TLS and HTTPS](../learn/concepts/tls-and-https.md)** (~6 min)
   Encryption in transit, certificate authorities, the TLS handshake. The "lock icon" demystified.

5. **[Identity and IAM topic index](../topics/iam.md)** (~5 min)
   Cross-pillar IAM coverage: concepts, comparisons, deep-dives, hands-on, certs. Use as a jumping-off point if you want to drill in.

6. **[Architecture pattern: zero-trust architecture](./architecture-patterns/zero-trust-architecture.md)** (~12 min)
   The "never trust, always verify" model. Identity provider + policy engine + per-call authorization.

7. **[Service comparison: security tools](./service-comparison-security-tools.md)** (~10 min)
   AWS vs Azure vs GCP security service mapping (GuardDuty / Defender / Security Command Center, etc.). Recognize the tools in each cloud.

8. **[AWS Security Specialty (SCS-C02) fact sheet](../exams/aws/specialty/security-scs-c02/fact-sheet.md)** (~10 min)
   The cert that goes deepest on cloud security. Even if you don't take it, the fact-sheet is the densest reference for AWS-specific security mechanisms.

## What you can do after this playlist

- Read a cloud architecture diagram and identify the security perimeter, where IAM applies, and what's encrypted at rest vs in transit.
- Articulate the difference between identity-based and network-based access controls (and why modern designs use both).
- Recognize the security service in each of the three major clouds and what it does.
- Discuss zero-trust beyond the buzzword: identity-aware, policy-driven, continuous re-evaluation.
- Find the right deep-dive for any specific cloud-security question.

## Next steps

**If you want to build:**
- [Implement zero-trust security](./hands-on-projects/implement-zero-trust.md) - hands-on lab
- [Set up a monitoring stack](./hands-on-projects/setup-monitoring-stack.md) - includes security observability

**If you want to go deeper:**
- [Security topic index](../topics/security.md) - everything in one place
- [Architecture pattern: data-pipeline-etl](./architecture-patterns/data-pipeline-etl.md) - data security in motion
- [Compliance guides](./compliance-guides/) - SOC 2, HIPAA, PCI DSS, GDPR, FedRAMP

**If you want a cert:**
- [AWS SCS-C02](../exams/aws/specialty/security-scs-c02/)
- [Azure AZ-500](../exams/azure/az-500/)
- [GCP Cloud Security Engineer](../exams/gcp/cloud-security-engineer/)
- [Security Engineer roadmap](./certification-roadmap-security-engineer.md)
- [CISSP](../exams/isc2/cissp/) for the broader / managerial security cert

## Related playlists

- [AI engineer in 30 min](./playlist-ai-engineer-30min.md)
- [Data engineer in 1 hour](./playlist-data-engineer-1hour.md)
- [SRE in 1 hour](./playlist-sre-1hour.md)
