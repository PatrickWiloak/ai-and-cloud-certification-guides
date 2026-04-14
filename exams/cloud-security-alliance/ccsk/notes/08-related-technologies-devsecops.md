# 08 - Related Technologies, DevSecOps, and Incident Response (Guidance Domains 11 and 12)

## Domain Overview

This combined topic covers Guidance Domain 11 (Incident Response and Resilience) and Domain 12 (Related Technologies and Strategies), which address cloud IR, forensics, DR/BC, and emerging technologies including zero trust architecture, DevSecOps maturity, and AI/ML security.

## Cloud Incident Response (Domain 11)

### IR Lifecycle (NIST SP 800-61 adapted for cloud)
1. **Preparation**
   - Cloud-aware playbooks
   - Pre-approved containment automation
   - Provider contact information
   - Forensic tools ready for cloud
   - Break-glass identities for IR team
2. **Detection and Analysis**
   - Cloud SIEM correlation
   - Native detection services (GuardDuty, Defender, Security Command Center)
   - CNAPP alerts
   - Threat intelligence enrichment
3. **Containment**
   - Network isolation via API (security group modifications)
   - IAM revocation
   - Snapshot before terminate (preserve evidence)
   - Quarantine via tagging and restrictive policies
4. **Eradication**
   - Replace compromised resources from clean baseline
   - Rotate credentials, keys, tokens
   - Apply patches
5. **Recovery**
   - Restore from immutable backups
   - Validate cleanliness
   - Phased traffic restoration
6. **Post-Incident**
   - Lessons learned
   - Update playbooks and detections
   - Communicate with stakeholders

### Cloud-Specific IR Considerations

- **Elasticity**: Auto-scaled instances may have varied state
- **Ephemeral resources**: Terminate before evidence collected if not careful
- **API-driven response**: Rapid containment via automation
- **Provider coordination**: Required for hypervisor, multi-tenant correlation
- **Multi-tenancy**: Physical seizure impossible
- **Documentation**: Chain of custody across cloud API actions

### IR Team Roles
- **Incident Commander** - Overall coordination
- **Technical Lead** - Investigation direction
- **Forensic Analyst** - Evidence collection and analysis
- **Communication Lead** - Internal/external updates
- **Legal/Privacy** - Notification and liability advice
- **Executive Sponsor** - Business decisions

### Pre-Incident Preparation
- Written IR plan approved by leadership
- Playbooks for common scenarios (ransomware, data breach, credential compromise)
- Tabletop exercises annually
- Contacts: legal, insurance, provider IR, law enforcement, industry ISACs
- Forensic toolkit in cloud-ready state (pre-authorized, ready to deploy)
- Evidence storage (separate account, immutable)

## Cloud Forensics

### Acquisition in Cloud
- **Volume snapshots** via cloud API
- **Memory capture** before instance terminates (tools: LiME, Volatility Cloud, vendor agents)
- **Log export** to immutable storage
- **Metadata preservation** - Resource tags, identity that created/modified, network config at time of incident

### Chain of Custody
- Operator identity for every evidence action
- Timestamps (UTC)
- Hashes computed and recorded (SHA-256)
- Storage location
- Transfer records

### Analysis Environment
- Isolated forensic account/VPC
- Read-only mount of acquired snapshots
- Dedicated forensic tools (commercial or open-source)
- Documented procedures and findings

### Provider Cooperation
- Some evidence only accessible via provider (hypervisor, multi-tenant correlation)
- Legal process (subpoena, warrant) for provider-held evidence
- Pre-established IR contacts with cloud provider
- Paid IR support offerings from some providers

## Disaster Recovery and Business Continuity

### BC vs DR
- **BC** - Broad continuity of business operations
- **DR** - Technical recovery of IT services (subset of BC)

### Cloud DR Patterns
| Pattern | Always-On | RTO | RPO | Cost |
|---------|-----------|-----|-----|------|
| Backup-restore | Backup only | Hours-days | Hours-days | Lowest |
| Pilot light | Minimal | 10-30 min | Minutes | Low |
| Warm standby | Reduced | Minutes | Seconds-minutes | Medium |
| Hot multi-region (active-passive) | Full | Seconds-minutes | Near-zero | High |
| Hot multi-region (active-active) | Full x N | Near-zero | Near-zero | Highest |

### Backup Strategy
- 3-2-1 rule: 3 copies, 2 media, 1 off-site (different account/region)
- Immutable backups (Object Lock / WORM)
- Encryption with customer-managed keys
- Separate identity scope (backup destination not in production blast radius)
- Periodic restore tests
- Backup of cloud configuration (IaC, KMS keys, IAM policies)

### DR Test Types (least to most disruptive)
1. Read-through (paper review)
2. Walk-through (team discussion)
3. Tabletop (role-play)
4. Simulation (systems exercised without affecting prod)
5. Parallel (DR brought up while prod stays)
6. Full interruption (failover with prod offline)

### Multi-Region Considerations
- Region-specific outages possible (even major providers)
- Data replication strategy (sync for zero RPO, async otherwise)
- Failover automation vs manual
- Failback planning
- Cost of active-active vs active-passive

## Related Technologies (Domain 12)

### Zero Trust Architecture (ZTA)

#### Principles
- Never trust, always verify
- Assume breach
- Verify explicitly (identity, device, risk)
- Use least privilege
- Continuous evaluation

#### Pillars (NIST SP 800-207 and CISA ZT Maturity Model)
- Identity
- Devices
- Networks
- Applications and workloads
- Data
- (CISA adds: Visibility and Analytics, Automation and Orchestration, Governance)

#### Core Components
- Policy Engine (PE) - decision-making
- Policy Administrator (PA) - enforcement control
- Policy Enforcement Point (PEP) - gateway

#### Implementation
- Start with identity (MFA, strong IdP)
- Add device trust (compliance, managed)
- Micro-segmentation
- Application-layer access (ZTNA replacing VPN)
- Data-centric controls (classification, encryption, IRM)

### DevSecOps

#### Cultural
- Security as shared responsibility
- Breaking down silos (dev, sec, ops)
- Fast feedback and learning
- Blameless post-mortems

#### Technical
- Automation of security testing
- Policy as code
- Continuous security in CI/CD
- Immutable infrastructure
- Secrets management
- Observability and monitoring

#### Maturity Models
- OWASP SAMM (Software Assurance Maturity Model)
- BSIMM (Building Security In Maturity Model)
- Microsoft SDL
- NIST SSDF (SP 800-218)

### AI and Machine Learning Security

#### Attack Surface
- Training data (poisoning)
- Model theft
- Prompt injection (LLMs)
- Jailbreak (bypass safety controls)
- Model inversion (extract training data)
- Adversarial examples
- Sensitive data exposure in model outputs

#### Controls
- Training data governance
- Model inventory and version control
- Access control to models (IAM, API keys)
- Input filtering (prompt guards)
- Output filtering (PII, sensitive content)
- Rate limiting
- Logging of prompts and responses
- Audit and monitoring

#### Frameworks
- NIST AI Risk Management Framework (AI RMF)
- OWASP Top 10 for LLMs (2023)
- MITRE ATLAS (Adversarial Threat Landscape for AI Systems)
- CSA AI Security Working Group guidance

### Edge Computing
- Compute at the edge (closer to users)
- CDN edge functions (CloudFront Functions, Lambda@Edge, Cloudflare Workers, Fastly Compute@Edge)
- Security:
  - Same principles as cloud compute
  - Edge logging centralization
  - Identity-based access at edge
  - TLS termination at edge with care

### IoT and Edge Devices
- Resource-constrained
- Long lifecycle, limited patching
- Deployment in physically accessible locations
- Standards: NIST IR 8259, ISO/IEC 27400, IEC 62443

### 5G and Network Slicing
- Network slices with different SLAs
- Service-based architecture
- Security per slice
- Potential for cloud-edge convergence

### Quantum Computing Threat
- Shor's algorithm threatens RSA, ECC
- Grover's algorithm halves symmetric key effective strength
- "Harvest now, decrypt later" risk
- NIST Post-Quantum Cryptography standards (2024):
  - ML-KEM (formerly CRYSTALS-Kyber) for key encapsulation
  - ML-DSA (formerly CRYSTALS-Dilithium) for signatures
  - FALCON for signatures
  - SLH-DSA (formerly SPHINCS+) for hash-based signatures

#### Preparation
- Crypto inventory
- Crypto agility
- Hybrid classical + PQC during transition
- Track NIST and industry guidance
- Prioritize long-lived data

### Confidential Computing
- Data encrypted in use (not just at rest and in transit)
- Trusted Execution Environments (TEEs)
- Intel SGX, AMD SEV-SNP, ARM CCA
- Cloud: Azure Confidential Computing, AWS Nitro Enclaves, GCP Confidential VMs
- Confidential Computing Consortium (CCC)

### Multi-Party Computation (MPC)
- Joint computation without revealing inputs
- Used in key management (threshold cryptography), privacy-preserving analytics

### Homomorphic Encryption
- Computation on encrypted data
- Fully HE (FHE) performant enough for practical use emerging
- Use cases: privacy-preserving analytics, cloud computation on encrypted data

### Blockchain / Distributed Ledger (awareness)
- Immutable transaction logs
- Smart contracts with associated security risks
- Audit trails use cases
- Security considerations: key management, oracle security, smart contract vulnerabilities

## Continuous Improvement

### Metrics to Track
- MTTD (Mean Time to Detect)
- MTTR (Mean Time to Respond / Recover)
- Incidents by category over time
- False positive rate
- Patch SLA compliance
- Configuration drift
- Access review completion
- Phishing test click rate
- Training completion

### Feedback Loops
- Lessons learned from every incident
- Tabletop exercise findings
- DR test findings
- Audit findings
- Red team / pen test findings
- Bug bounty reports
- Threat intelligence insights

## Common Exam Pitfalls

- Treating cloud IR like on-prem (missing volatility, ephemeral resources)
- Forgetting to snapshot before terminating compromised instance
- Over-reliance on a single cloud region without DR
- Missing immutable backup tier
- Confusing BC (broad) with DR (technical subset)
- Picking inappropriate DR test type for the maturity level
- Not knowing zero trust is an architecture, not a product
- Overlooking AI/ML-specific threats
- Ignoring quantum threat to long-lived encrypted data

## Quick Reference

### Incident Response in Cloud Key Points
- Act fast but preserve evidence (snapshot before terminate)
- Use API-driven containment (security groups, IAM)
- Centralized logs survive workload compromise
- Provider cooperation may be needed
- Document chain of custody

### Zero Trust Mantra
Verify explicitly, use least privilege, assume breach.

### PQC Preparation
Inventory, agility, hybrid, watch, prioritize.

### DR Pattern Selection
Match cost to RTO/RPO requirements; critical workloads need hot multi-region.
