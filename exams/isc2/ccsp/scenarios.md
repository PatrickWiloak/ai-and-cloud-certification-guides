# CCSP Real-World Scenarios

These scenarios mimic the cloud-aware judgment style of CCSP exam questions. Each tests both technical knowledge and CCSP mindset (shared responsibility, jurisdictional awareness, vendor-neutrality, architect-perspective).

## Scenario 1: Choosing a Cloud Service Model for a New Application

**Context:** Your organization is building a new customer portal. The development team wants to focus on application code without managing infrastructure or runtime patching, but security requires customer-managed encryption keys for stored data.

**Q1:** Which service model best fits these requirements?

**A1:** PaaS (Platform as a Service). PaaS removes runtime and OS management for the developer, while still allowing customer-managed keys for application data via the provider's KMS. SaaS would limit customization further; IaaS would force the team to manage OS and runtime which they want to avoid.

**Q2:** Under PaaS, who is responsible for the following?
- Operating system patching
- Application code security
- Identity and access management
- Network firewall at the platform edge
- Customer data classification

**A2:**
- OS patching: Provider
- Application code security: Customer
- Identity and access management: Customer (configuration), Provider (underlying service)
- Network firewall at platform edge: Provider; customer configures app-level
- Customer data classification: Customer

**Q3:** What contractual elements should the customer ensure are in place before signing?

**A3:**
- Data Processing Agreement (DPA) per GDPR if EU data
- BAA if PHI under HIPAA
- Right to receive SOC 2 Type 2 reports
- Defined SLA with measurable availability and credits
- Exit clauses with data return/destruction guarantees in defined formats
- Sub-processor disclosure and approval rights
- Breach notification SLAs

## Scenario 2: Data Residency Conflict

**Context:** Your SaaS application stores customer data globally. A new EU customer requires that their personal data and backups remain within the EU. The SaaS application currently uses a single global database in the US.

**Q1:** What is the FIRST step?

**A1:** Conduct a data flow analysis to map all locations where the customer's personal data would be processed, stored, or transmitted. You cannot solve a residency requirement without understanding current data flows.

**Q2:** What architectural options support EU residency?

**A2:**
- Multi-region database with EU-specific shard for EU customers
- Tenant-aware data partitioning (per-tenant region assignment)
- Separate EU instance of the SaaS application with EU-only data
- Provider's EU region with appropriate region-locked services

**Q3:** What legal mechanisms apply if any data still leaves the EU?

**A3:**
- EU-US Data Privacy Framework (if US destination, certified company)
- Standard Contractual Clauses (SCCs) with appropriate safeguards
- Binding Corporate Rules (BCRs) for intra-group transfers
- Specific derogations under GDPR Article 49 (limited use cases)
- Adequacy decision (e.g., UK, Switzerland, Japan)
- Schrems II transfer impact assessment for any non-adequate destination

## Scenario 3: Encryption Key Management Strategy

**Context:** Your organization stores highly sensitive financial records in a public cloud object storage service. Auditors require that the cloud provider cannot access plaintext data even with valid legal process from their jurisdiction.

**Q1:** Which encryption approach satisfies the requirement?

**A1:** HYOK (Hold Your Own Key) using an external KMS or HSM not under the cloud provider's control. The provider cannot decrypt without the external key, even under legal compulsion.

Alternatively, customer-supplied keys (CSE/SSE-C in AWS terms) where the key is provided per request and not stored by the provider. However, this is operationally complex.

BYOK with provider-hosted KMS does not satisfy the requirement: the provider technically can access the key in their KMS.

**Q2:** What are the operational trade-offs of HYOK?

**A2:**
- External KMS becomes a new dependency and SPoF
- Latency added to every read/write
- Many cloud-native services (analytics, search, ML) cannot operate on HYOK-encrypted data
- Key rotation complexity increases
- Backup and DR plans for the KMS itself become critical

**Q3:** What attestation can demonstrate the KMS provider's trustworthiness?

**A3:**
- FIPS 140-2 / 140-3 Level 3 (or higher) for the underlying HSM
- SOC 2 Type 2 covering key management operations
- Common Criteria EAL certification of the HSM
- Independent code/cryptographic review

## Scenario 4: Cloud Incident Response - Suspected EC2 Compromise

**Context:** Your monitoring detects suspicious outbound traffic from a Linux EC2 instance running a customer-facing web application. You suspect compromise.

**Q1:** What is the immediate sequence of actions for cloud forensics?

**A1:**
1. Isolate the instance (modify security group to allow only forensic IP, or detach from network)
2. Snapshot the EBS volumes (preserve disk evidence with hash verification)
3. Capture memory if possible (live response tooling, e.g., LiME or vendor agent)
4. Preserve all relevant logs: VPC Flow, CloudTrail, ALB/NLB access, application logs
5. Document timestamps, action operator, and rationale (chain of custody)
6. Do NOT terminate the instance until evidence is preserved (volatile state will be lost)
7. Once evidence preserved, terminate and replace with clean baseline

**Q2:** What logs may only be available through the cloud provider?

**A2:**
- Underlying hypervisor events (typically not accessible)
- Cross-tenant correlation (provider-only)
- Hardware-level diagnostics
- Some control-plane logs require subpoena to provider

This is a key cloud forensics adaptation: customer cannot independently access all evidence layers and may need provider cooperation.

**Q3:** What evidence considerations apply uniquely to cloud?

**A3:**
- Ephemeral resources (terminated instances lose state)
- Multi-tenancy means physical seizure of disks generally impossible
- Snapshot-based imaging replaces traditional dd
- API logs replace some traditional system audit trails
- Provider coordination for legal process and out-of-band evidence

## Scenario 5: SaaS Vendor Risk Assessment

**Context:** A business unit requests adoption of a new SaaS HR analytics platform that will receive employee data including SSN, salary, and performance reviews.

**Q1:** What due diligence is required before approval?

**A1:**
- Data classification: confirm sensitivity level
- Vendor security questionnaire (CAIQ recommended)
- SOC 2 Type 2 report review (not just SOC 3 summary)
- ISO 27001 certificate (or equivalent)
- Penetration test report or summary
- Privacy notice and DPA review
- Sub-processor list and locations
- Data residency capabilities
- Data return/destruction commitments at termination
- Right to audit (or right to receive audit reports)
- Breach notification SLA
- Insurance coverage (cyber liability)
- Financial stability (operational risk if vendor fails)

**Q2:** What contractual safeguards are needed?

**A2:**
- Master Service Agreement (MSA) with clear liability limits
- Data Processing Agreement (DPA) per GDPR
- Specified data residency (EU if EU employees)
- BAA if any PHI (likely not for HR, but worth confirming)
- SLA with credits for downtime and breach
- Data deletion within X days of termination, with attestation
- Source code escrow if vendor failure would cripple operations
- Liability and indemnification for vendor-caused breach

**Q3:** What ongoing controls govern the relationship?

**A3:**
- Annual reassessment (re-collect SOC 2, security questionnaire)
- Continuous third-party risk monitoring (BitSight, SecurityScorecard)
- Quarterly business review with vendor's security team
- Monitoring of vendor's breach disclosures (news, SEC filings, industry reports)
- Periodic access review of vendor employees with access to your tenant
- Sub-processor change notification review

## Scenario 6: Container Escape Vulnerability Disclosed

**Context:** A critical container runtime CVE is disclosed allowing container escape to host. Your organization runs Kubernetes clusters across multiple cloud providers using a mix of managed (EKS, AKS, GKE) and self-managed clusters.

**Q1:** What is the prioritization for patching?

**A1:**
- Self-managed clusters first (you own the runtime; patching window is yours)
- Multi-tenant clusters (escape impact would expose other workloads)
- Internet-facing workloads in any cluster
- Clusters with privileged or high-sensitivity workloads

For managed clusters, depend on the provider's patching SLA but track and verify.

**Q2:** What compensating controls reduce risk during the patch window?

**A2:**
- Pod Security Standards: restricted level (no privileged, drop capabilities, read-only root, non-root user)
- Namespace and network policies isolating workloads
- Admission controllers (OPA Gatekeeper, Kyverno) blocking risky configurations
- Runtime threat detection (Falco, Defender for Containers, Sysdig)
- Egress controls limiting blast radius if compromised
- Increased logging and monitoring on affected clusters

**Q3:** What systemic controls should follow this incident?

**A3:**
- Mandatory image scanning in CI/CD with policy gates
- Signed images from trusted registries only (Cosign / Notation)
- Immutable infrastructure: rebuild rather than patch when possible
- Runtime protection in production clusters
- Regular CVE scanning of all running container images
- Continuous compliance with Pod Security Standards
- Incident response runbook for container escape including snapshot of affected nodes

## Scenario 7: Multi-Cloud Identity Architecture

**Context:** Your organization runs workloads across AWS, Azure, and GCP. Engineers have separate identities in each provider. Identity sprawl is causing access review burden, inconsistent MFA, and slow offboarding.

**Q1:** What is the target architecture?

**A1:** Federated identity with a single Identity Provider (IdP) - Microsoft Entra ID, Okta, or similar - integrated with each cloud:
- AWS via SAML and IAM Identity Center (formerly SSO) and OIDC for workload identity
- Azure as Entra ID native (if Entra is the IdP) or federated
- GCP via Workforce Identity Federation and OIDC

Service-to-service auth via workload identity federation (no long-lived secrets).

**Q2:** What controls strengthen this architecture?

**A2:**
- MFA enforced at the IdP (phishing-resistant, FIDO2/WebAuthn preferred)
- Conditional access (device posture, geo, sign-in risk)
- Just-in-time elevation via PAM tooling
- Periodic access reviews with closed-loop revocation
- Centralized audit logging from IdP and each cloud
- Workload identity for app-to-cloud auth (no static secrets)

**Q3:** What CCSP-relevant risk does federation introduce?

**A3:** SPoF concerns: IdP outage affects all cloud access. Mitigations:
- IdP high availability and DR
- Break-glass accounts at each cloud (vaulted, monitored, MFA-enforced, periodically tested)
- Documented IR procedures for IdP compromise
- Conditional access policies do not lock out emergency accounts inappropriately

## Scenario 8: Cloud-Native Application Logging Strategy

**Context:** A new microservices-based application will be deployed across 50 services on Kubernetes. Compliance requires retaining auth logs for 7 years, all logs for 1 year online searchable.

**Q1:** What logging architecture meets these requirements?

**A1:**
- Application logs to stdout/stderr (12-factor app principle)
- Cluster log forwarder (Fluentd, Fluent Bit, Vector) sends to centralized log platform
- Cloud-native log aggregation: CloudWatch Logs, Azure Monitor Logs, GCP Cloud Logging
- For long-term retention: tier to object storage (S3 Glacier, Azure Archive, GCP Coldline) at lower cost
- Enable native cloud audit logs (CloudTrail, Activity Log, Cloud Audit Logs)
- SIEM ingestion of high-value logs (SecOps focus)
- Indexing strategy: hot tier for searchable, cold tier for retention

**Q2:** What logging integrity controls are required?

**A2:**
- Append-only / write-once destinations
- Cryptographic hashing or chained hashes for tamper evidence
- Restricted access (separation of duties: log readers vs admins)
- Centralized collection (off-source storage)
- Time synchronization (NTP, cloud-managed time sources)
- Monitoring for log tampering, gaps, or volume drops

**Q3:** What sensitive data must NOT be logged?

**A3:**
- Passwords and secrets (even hashed for tracking purposes)
- Full credit card numbers (PCI DSS prohibits)
- SSN, government IDs in plain
- Session tokens, API keys, OAuth tokens
- PHI (HIPAA-restricted)
- Personal data beyond what is necessary (GDPR data minimization)

Implement structured logging with field-level redaction; security review of log content during design.

## Scenario 9: Ransomware Affecting Cloud Backups

**Context:** A ransomware attack encrypted production VMs. The team attempts to restore from backups stored in the same cloud account; the backups are also encrypted by the attackers, who had compromised the cloud account.

**Q1:** What architectural failure caused backup loss?

**A1:** Backups were not isolated from the production identity scope. Attacker access to production cloud account included backup access, allowing destruction.

**Q2:** What architecture would have prevented this?

**A2:**
- Backups in a separate cloud account / project / subscription with separate identities
- Immutable backups: object lock (S3 Object Lock with Compliance mode), Azure Blob immutability, or GCP Bucket Lock
- Air-gapped or third-region copies (backup replication outside primary cloud account)
- MFA-protected backup deletion
- Multi-person authorization for backup destruction
- Integrity verification (periodic restore tests)

**Q3:** What recovery approach if no backups available?

**A3:**
- Engage cloud provider for any provider-side backups (limited scope)
- Engage incident response retainer
- Determine if ransom payment is legally permissible (sanctions concerns, OFAC) and operationally necessary
- Forensic investigation to understand initial access and prevent reinfection during recovery
- Rebuild from clean baseline IaC if available (gold environments stored elsewhere)
- Communicate with stakeholders (customers, regulators per breach notification timelines)

## Scenario 10: Compliance Audit of Multi-Tenant SaaS

**Context:** Your SaaS company is preparing for a SOC 2 Type 2 audit. The auditor is uncomfortable with multi-tenancy, asking how customer data isolation is verified.

**Q1:** What technical evidence demonstrates customer data isolation?

**A1:**
- Logical isolation: tenant-aware data layer with tenant_id filters enforced at multiple layers
- Database isolation: row-level security, separate schemas, or separate databases per tenant tier
- Identity isolation: tenant-scoped tokens, no cross-tenant token validity
- Encryption: tenant-specific encryption keys (envelope encryption per tenant)
- Network isolation: VPC/VNet per high-tier customer if offered
- Periodic isolation testing: pen tests with cross-tenant attack scenarios
- Code review processes for any cross-tenant data access paths

**Q2:** What audit evidence supports the controls?

**A2:**
- Architecture diagrams with isolation boundaries
- Code review records for tenant-aware data access
- Pen test reports with isolation testing
- Sample queries showing row-level enforcement
- Key management evidence (tenant-specific keys)
- Incident records (or absence thereof) related to cross-tenant exposure
- Personnel access review (production access logs, JIT records)

**Q3:** What is the relationship between SOC 2 and the CSA Cloud Controls Matrix?

**A3:** SOC 2 is criteria-based (Trust Services Criteria) and audit-friendly. CCM is a more granular cloud-specific control set that maps to multiple frameworks (SOC 2, ISO 27001, PCI DSS, NIST). Many auditors accept CCM-aligned evidence for SOC 2; CSA STAR Attestation explicitly combines SOC 2 with CCM. CCM is often used internally to drive controls; SOC 2 is the externally-recognized attestation.

## Scenario 11: Insider Threat in Cloud Operations

**Context:** A cloud operations engineer with admin access has accepted a job at a competitor, giving 2 weeks notice. They retain admin access to the production cloud account during the notice period.

**Q1:** What is the immediate concern and action?

**A1:** Standing privileged access during a notice period is a high-risk insider threat scenario. Actions:
- Engage HR and legal first to confirm offboarding procedure
- Reduce standing access; transition to monitored just-in-time access
- Rotate any shared credentials, SSH keys, API keys the engineer has knowledge of
- Increase monitoring on cloud control plane events tied to this user
- Document a complete inventory of access (cloud accounts, identity providers, secret vaults, source repos)
- Consider transitioning the role to other team members during notice period

**Q2:** What controls should be permanent?

**A2:**
- No standing admin access; all admin via PAM with JIT elevation
- Session recording on all privileged access
- Periodic UARs on cloud admins
- Mandatory vacation for high-privilege roles
- Two-person integrity for highest-impact actions (e.g., production destruction, key destruction)
- Separation of duties between development and operations (DevOps tooling enforces approval)

**Q3:** What evidence is collected for potential investigation?

**A3:**
- All cloud control plane logs (CloudTrail, Activity Log, etc.) for the period
- Source code repository activity
- Identity provider sign-in history
- Secret access logs from vaults
- Email and chat archives
- USB and removable media access (if endpoint controls in place)
- Print and download logs
- VPN access logs

Maintain chain of custody for any evidence collected; engage legal counsel for use in potential litigation.

## Scenario 12: Quantum Computing Threat to Cloud Cryptography

**Context:** A board member asks: "What is the quantum computing threat to our cloud-stored data, and what should we be doing now?"

**Q1:** What is the quantum risk to current cryptography?

**A1:**
- Shor's algorithm threatens RSA, DSA, ECC, ECDH (factoring and discrete log problems)
- Grover's algorithm halves effective symmetric key strength (AES-128 -> ~64-bit equivalent; AES-256 still strong)
- Hash functions are largely safe (collision resistance halved by Grover)
- "Harvest now, decrypt later" is a current threat: adversaries collect encrypted data today to decrypt when quantum is available

**Q2:** What is the timeline?

**A2:** Cryptographically relevant quantum computing (CRQC) timeline is uncertain but estimates range from 5 to 15+ years. NIST released initial post-quantum cryptography (PQC) standards in 2024:
- CRYSTALS-Kyber (now ML-KEM) for key encapsulation
- CRYSTALS-Dilithium (now ML-DSA) for signatures
- FALCON for signatures (smaller signatures, complex implementation)
- SPHINCS+ (now SLH-DSA) for hash-based signatures (fallback)

**Q3:** What should the organization be doing now?

**A3:**
- Crypto inventory: identify all cryptographic uses, key types, algorithms, key lifetimes
- Crypto agility: design systems to swap algorithms without major rewrites
- Hybrid approaches: pair classical with PQC during transition
- Engage cloud providers on PQC roadmaps (most are publishing)
- Prioritize long-lived data (financial records, IP, classified) for early migration
- Track NIST and industry guidance
- Update procurement: require crypto agility and PQC-readiness in new systems
- Awareness/training for engineering teams
