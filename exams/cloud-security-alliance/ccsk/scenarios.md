# CCSK v5 Real-World Scenarios

These scenarios test CSA Guidance v5 concepts applied to realistic cloud security situations. Each aligns with one or more of the 12 Guidance domains.

## Scenario 1: Designing a Cloud Landing Zone

**Context:** Your organization is beginning cloud adoption and must design a cloud account structure (landing zone) to support multiple business units across development, staging, and production environments.

**Q1:** What CSA Guidance principles apply?

**A1:** Domain 4 (Organization Management) provides the foundation:
- Separate accounts/projects/subscriptions for security isolation
- Hierarchical organization (management group > org > accounts)
- Centralized guardrails (policy, logging, identity) with delegated operational control to BU
- Network hub-and-spoke or transit architecture for connectivity
- Centralized logging to a dedicated security account
- Break-glass identities separated from normal operations

**Q2:** What CCM controls apply to this design?

**A2:**
- GRC-01 through GRC-09 (Governance, Risk, Compliance)
- IAM (Identity and Access Management) controls for centralized identity
- LOG (Logging and Monitoring) controls for centralized log collection
- STA (Supply Chain, Transparency, Accountability) for third-party integrations

**Q3:** What anti-patterns should be avoided?

**A3:**
- Single account/subscription for everything (no blast radius isolation)
- Flat structure without hierarchy (limits policy inheritance)
- BUs managing their own identity (inconsistent MFA and access control)
- Logs stored in same account as production (attackers can delete)
- No break-glass account plan (lockout risk)

## Scenario 2: Vendor Assessment for a New SaaS

**Context:** A business unit wants to adopt a SaaS HR analytics platform processing sensitive employee data (SSN, salary, performance). You must assess the vendor.

**Q1:** What CSA resources support the assessment?

**A1:**
- CAIQ (Consensus Assessments Initiative Questionnaire) - request or download from STAR Registry
- CCM v4 as control catalog
- STAR Registry listing (Level 1 self-assessment or Level 2 third-party attestation)

**Q2:** What should you look for in vendor assurance?

**A2:**
- STAR Level 2 Attestation or Certification preferred
- SOC 2 Type 2 report (full, not SOC 3 summary)
- ISO 27001 certificate
- Any additional: ISO 27017, ISO 27018, FedRAMP authorization if applicable
- Penetration test summary
- Data residency capabilities
- Subprocessor disclosure

**Q3:** What contractual elements are mandatory for this data type?

**A3:**
- Data Processing Agreement (DPA) for GDPR (employee data)
- Specified data residency (matching employee jurisdictions)
- Data return/destruction at termination with attestation
- Right to receive audit reports
- Defined breach notification SLA
- Sub-processor approval rights
- Insurance requirements
- Reversibility provisions

## Scenario 3: Identity Architecture for Multi-Cloud

**Context:** Your organization operates in AWS, Azure, and GCP. Engineers have separate identities in each cloud, causing access review burden and slow offboarding.

**Q1:** What does CSA Guidance Domain 5 recommend?

**A1:** Federated identity with a single Identity Provider:
- Central IdP (e.g., Entra ID, Okta) integrated with all cloud providers
- SAML/OIDC federation to AWS, Azure, GCP
- Workload identity federation for service-to-service auth (no long-lived cloud secrets)
- MFA enforced at IdP (phishing-resistant: FIDO2/WebAuthn)
- Conditional access based on device posture, geo, risk
- Periodic access reviews (UARs) with closed-loop revocation
- Just-in-time elevation via PAM

**Q2:** What CIEM purpose does this architecture support?

**A2:** Cloud Infrastructure Entitlement Management (CIEM) analyzes actual permissions vs used permissions. In a federated architecture, CIEM can:
- Identify excessive permissions across clouds
- Detect toxic combinations (e.g., access to both prod and backup)
- Track privilege creep over time
- Recommend least-privilege policies
- Support continuous access review

**Q3:** What single point of failure must be mitigated?

**A3:** IdP outage. Mitigations:
- IdP high availability and DR
- Break-glass accounts in each cloud (vaulted, monitored, MFA-enforced, periodically tested)
- Documented IR procedures for IdP compromise
- Ensure conditional access policies do not lock out emergency accounts

## Scenario 4: Misconfigured Storage Bucket Exposure

**Context:** A cloud storage bucket containing customer financial records was misconfigured to allow public read for 21 days. Disclosure came via a security researcher.

**Q1:** What preventive controls (CCM) should have caught this?

**A1:**
- **CCC (Change Control and Configuration Management)** - IaC review should have flagged public ACL
- **DCS (Datacenter Security) / AIS** - Misconfigured storage is a data-center-relevant control
- **IAM** - Overly permissive bucket policies
- **LOG** - Configuration change logging and alerting

**Q2:** What detective controls could have shortened exposure?

**A2:**
- **CSPM (Cloud Security Posture Management)** - Continuous detection of public bucket
- **DSPM (Data Security Posture Management)** - Data-aware scanning detecting sensitive content in exposed location
- **LOG** - Access pattern alerting for unusual public access
- Automated remediation (e.g., auto-remediate by setting private)

**Q3:** What systemic improvements should follow?

**A3:**
- Block Public Access at account level (AWS-style)
- Service Control Policies preventing public bucket creation
- Mandatory IaC with peer review and policy-as-code scanning (Checkov, OPA)
- CSPM with alerts to SOC for public exposure
- Quarterly access review of all storage with sensitive data labels
- Security champions in development teams

## Scenario 5: Container Escape Vulnerability Disclosure

**Context:** A critical container runtime CVE is disclosed allowing container escape to host. You run Kubernetes across managed (EKS, AKS, GKE) and self-managed clusters.

**Q1:** What CSA Guidance domain covers this?

**A1:** Domain 8 (Cloud Workload Security) covers container and serverless workload security.

**Q2:** What compensating controls reduce risk during patch window?

**A2:**
- Pod Security Standards: restricted level (no privileged, drop capabilities, read-only root, non-root user)
- Network policies isolating workloads
- Admission controllers (OPA Gatekeeper, Kyverno) blocking risky configurations
- Runtime threat detection (Falco, Defender for Containers, Sysdig)
- Egress controls limiting blast radius

**Q3:** Which CCM domain is most relevant?

**A3:** IVS (Infrastructure and Virtualization Security) addresses virtualization including containers, with related controls in CCC (change control) and TVM (threat and vulnerability management).

## Scenario 6: Cross-Border Data Transfer for a SaaS

**Context:** Your SaaS company is based in the US. An EU customer requires their personal data remain in the EU.

**Q1:** What legal mechanisms apply?

**A1:**
- EU-US Data Privacy Framework (if company certified)
- Standard Contractual Clauses (SCCs) with Transfer Impact Assessment
- Binding Corporate Rules (BCRs) if applicable
- Specific Article 49 derogations (limited use cases)

**Q2:** What architectural approaches support EU residency?

**A2:**
- Multi-region deployment with EU-specific shard for EU tenants
- Tenant-aware data partitioning
- Separate EU instance of application
- Provider's EU region with region-locked services (avoid services that replicate globally)

**Q3:** What CSA Guidance domain covers this?

**A3:** Domain 9 (Data Security) covers data residency and lifecycle. Domain 3 (Risk, Audit, Compliance) covers the legal and regulatory context.

## Scenario 7: Incident in the Cloud - Suspected VM Compromise

**Context:** Monitoring detects suspicious outbound traffic from a Linux VM running a customer-facing web application. You suspect compromise.

**Q1:** What sequence of actions follows CSA Guidance Domain 11?

**A1:**
1. **Isolate** via network security group change (block outbound) without terminating
2. **Snapshot** the disk volumes (preserve evidence with hash)
3. **Capture memory** if feasible (volatile evidence)
4. **Preserve logs** centralized copy before any auto-rotation
5. **Document** timestamps, operator, and rationale (chain of custody)
6. **Investigate** in a forensic environment (mount snapshots, analyze)
7. **Eradicate** by replacing with clean baseline (immutable infrastructure)
8. **Recover** with enhanced monitoring
9. **Post-incident** review: update detections, playbooks, controls

**Q2:** What cloud-specific forensic adaptations apply?

**A2:**
- Evidence acquisition via API (snapshots)
- Ephemeral resources: act before auto-terminate
- Some logs only via provider (hypervisor-level)
- Chain of custody documented across cloud API actions
- Multi-tenancy means physical seizure impossible
- Provider coordination for some evidence

**Q3:** Which CCM domain is most relevant?

**A3:** SEF (Security Incident Management, E-Discovery, and Cloud Forensics) directly addresses cloud IR and forensics.

## Scenario 8: Encryption Key Strategy for Sensitive Data

**Context:** Highly sensitive financial records will be stored in a public cloud. Auditors require that the cloud provider cannot access plaintext even with valid legal process from the provider's jurisdiction.

**Q1:** Which encryption approach meets this requirement?

**A1:** HYOK (Hold Your Own Key) using an external KMS not under the cloud provider's control. Provider cannot decrypt without the external system.

Alternatives:
- Customer-supplied key per request (SSE-C style) where provider doesn't store key
- Client-side encryption before upload (most control but limits cloud-native features)

BYOK with customer-managed key in provider's KMS does NOT meet the requirement - the provider technically has access to the key material.

**Q2:** What operational trade-offs of HYOK should be documented?

**A2:**
- External KMS is a new dependency and SPoF
- Latency added to every operation
- Many cloud-native services (analytics, search, ML) cannot operate on HYOK-encrypted data
- Key rotation complexity
- Backup and DR for the KMS itself become critical
- Availability impact if external KMS is unavailable

**Q3:** Which CCM domain addresses this?

**A3:** CEK (Cryptography, Encryption, and Key Management).

## Scenario 9: DevSecOps Pipeline Security

**Context:** Your engineering organization is implementing CI/CD pipelines for the first time. Security wants integrated guardrails without slowing delivery.

**Q1:** What security gates align with CSA Guidance Domain 10 (Application Security)?

**A1:**
- Secret scanning (pre-commit + pipeline)
- SAST (static code analysis)
- SCA (dependency analysis) with license compliance
- IaC scanning (policy as code)
- Container image scanning
- Image signing (Cosign, Notation)
- Manual approval gate for production deployments
- DAST against staging environment

**Q2:** What identity principles apply to pipelines?

**A2:**
- Workload identity federation (no static cloud credentials in pipelines)
- Pipeline-specific service accounts with least privilege
- Secrets vaulted (not in pipeline variables beyond necessary)
- Audit logging of pipeline actions
- OIDC trust between CI/CD and cloud for short-lived credentials

**Q3:** What CCM domain covers this?

**A3:** AIS (Application and Interface Security) with related controls in CCC (Change Control), IAM, and CEK.

## Scenario 10: Ransomware Resilience Architecture

**Context:** Your organization suffered a ransomware attack last year that also encrypted cloud backups stored in the same cloud account. You are redesigning for resilience.

**Q1:** What architectural changes are needed?

**A1:**
- Backups in a separate cloud account / project / subscription (different identity scope)
- Immutable backups: object lock with Compliance mode
- Air-gapped backup copies (outside primary cloud account)
- MFA-protected backup deletion
- Multi-person authorization for backup destruction
- Periodic restore tests to validate
- Integrity verification via hashing

**Q2:** What CSA Guidance domain applies?

**A2:** Domain 11 (Incident Response and Resilience) covers DR/BC and ransomware resilience. Domain 9 (Data Security) covers backup as data lifecycle.

**Q3:** What CCM domain addresses this?

**A3:** BCR (Business Continuity Management and Operational Resilience).

## Scenario 11: Logging Strategy for Compliance

**Context:** A new regulation requires 7-year retention of auth logs and 1-year online retention of all security logs.

**Q1:** What logging architecture satisfies this (Domain 6)?

**A1:**
- Centralized cloud-native logging (CloudWatch, Azure Monitor, Cloud Logging) + export to immutable long-term storage (Object Lock with Compliance mode)
- Separate account/project for log destination (separation from production identity)
- SIEM ingestion of security-relevant logs (hot tier for searchable, 1 year)
- Cold/archive tier for 7-year retention at low cost
- Cryptographic integrity verification
- Audit trail of log access (who queried what)

**Q2:** What must NOT be logged?

**A2:**
- Passwords, even hashed
- Secrets, API keys, OAuth tokens
- Full PAN (payment card numbers) per PCI DSS
- SSN, government IDs in plain
- Session tokens
- PHI under HIPAA (except where specifically authorized)
- Personal data beyond necessity (GDPR data minimization)

**Q3:** What CCM domain covers this?

**A3:** LOG (Logging and Monitoring).

## Scenario 12: Cloud Audit Readiness

**Context:** Your SaaS company is preparing for its first SOC 2 Type 2 audit. Customers are asking about STAR Registry listing.

**Q1:** What artifacts should be prepared?

**A1:**
- Documented policies and procedures (ISMS)
- Risk register and treatment plans
- Asset inventory
- Access control records (access reviews, provisioning/deprovisioning)
- Change management records
- Incident response records (if any)
- Backup and DR test records
- Vendor assessments and contracts
- Training records
- Logs and monitoring evidence
- Penetration test reports
- Vulnerability scan results with remediation
- Mapped control evidence against SOC 2 Trust Services Criteria and CCM

**Q2:** What STAR level aligns with SOC 2 Type 2?

**A2:** STAR Level 2 Attestation = SOC 2 Type 2 + CCM alignment. This is often a natural combination:
- SOC 2 provides the audit opinion
- CCM mapping shows cloud-specific control coverage
- Combined report can be submitted to STAR Registry

**Q3:** What is the relationship between CCM and SOC 2?

**A3:** CCM is a control catalog; SOC 2 is an audit framework. CCM controls map to multiple frameworks including SOC 2 TSC. Using CCM internally provides comprehensive cloud-specific coverage that satisfies SOC 2 and other framework audits with common evidence.

## Scenario 13: Zero Trust for a Cloud Application

**Context:** Your organization is adopting zero trust for its flagship cloud application. What principles apply?

**Q1:** What are the foundational zero trust principles per Guidance Domain 12?

**A1:**
- Never trust, always verify
- Verify every connection (identity, device, risk)
- Least privilege with just-in-time access
- Assume breach
- Continuous evaluation (not one-time auth)
- Micro-segmentation
- Explicit authentication and authorization decisions
- Data-centric security

**Q2:** What technologies support this?

**A2:**
- Identity-aware proxies and ZTNA (replaces VPN for application access)
- Service mesh for service-to-service (mTLS, identity)
- Workload identity federation
- Conditional access policies with device compliance and risk
- Continuous access evaluation (CAE)
- Micro-segmentation via SDN or service mesh
- Zero trust data access with classification and fine-grained controls

**Q3:** What CCM domains are most relevant?

**A3:** IAM (identity and access), IVS (infrastructure segmentation), AIS (application-level policies), LOG (continuous monitoring), and TVM (continuous vulnerability awareness).
