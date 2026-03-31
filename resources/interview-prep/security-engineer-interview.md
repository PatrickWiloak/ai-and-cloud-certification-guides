# Security Engineer Interview Preparation Guide

## Overview

Security Engineer interviews cover cloud security fundamentals, identity and access management, incident response, encryption, compliance, and offensive security concepts. This guide covers common questions and scenarios to help you prepare for cloud-focused security engineering roles.

---

## Cloud Security Fundamentals

### Shared Responsibility Model - Security Perspective

- Cloud provider secures the infrastructure layer:
  - Physical security of data centers
  - Network infrastructure and hypervisor
  - Managed service security patching
- Customer secures everything they deploy:
  - Data classification and protection
  - Identity and access management configuration
  - Network security (security groups, firewalls, NACLs)
  - Application security and code vulnerabilities
  - Operating system patching (for IaaS workloads)
  - Encryption configuration and key management
- The most common cloud security breaches result from customer misconfiguration, not provider failures
- Documentation: https://aws.amazon.com/compliance/shared-responsibility-model/

### Defense in Depth

Layer security controls at every tier:

1. **Perimeter**: WAF, DDoS protection, API gateways
2. **Network**: VPC segmentation, security groups, NACLs, private subnets
3. **Identity**: authentication, authorization, MFA, conditional access
4. **Compute**: hardened AMIs, patch management, endpoint protection
5. **Application**: secure coding, SAST/DAST, dependency scanning
6. **Data**: encryption at rest and in transit, data classification, DLP
7. **Monitoring**: logging, anomaly detection, SIEM, automated response

### Common Cloud Misconfigurations

- S3 buckets or storage accounts open to public access
- Security groups allowing 0.0.0.0/0 on sensitive ports (SSH, RDP, database)
- IAM users with long-lived access keys and excessive permissions
- Unencrypted data at rest (EBS volumes, RDS instances, storage accounts)
- Disabled logging (CloudTrail, VPC Flow Logs, Azure Activity Log)
- Default credentials on deployed services
- Missing MFA on privileged accounts
- Overly permissive IAM policies (using wildcards for actions and resources)

---

## IAM and Zero Trust Design

### IAM Best Practices Across Clouds

**Principle of Least Privilege**
- Grant only the permissions needed for the task
- Use managed policies where possible, custom policies when needed
- Regularly review permissions with access analyzers:
  - AWS IAM Access Analyzer: https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html
  - Azure AD Access Reviews
  - GCP IAM Recommender
- Remove unused permissions and identities

**Identity Federation**
- Use a central identity provider (IdP) instead of creating local cloud accounts
- SAML 2.0 or OIDC for SSO
- AWS: IAM Identity Center (formerly AWS SSO)
- Azure: Azure AD (Entra ID) with conditional access
- GCP: Cloud Identity or Workforce Identity Federation
- Eliminate long-lived credentials wherever possible

**Service-to-Service Authentication**
- Use IAM roles (AWS), managed identities (Azure), service accounts (GCP)
- Workload Identity Federation for cross-cloud authentication
- Never embed credentials in application code or configuration files
- Rotate service account keys automatically

### Zero Trust Architecture

Core principles:
- **Never trust, always verify**: authenticate and authorize every request
- **Assume breach**: design as if the attacker is already inside the network
- **Least privilege access**: grant minimum necessary permissions
- **Verify explicitly**: use all available signals (identity, device, location, behavior)

Implementation components:
- **Identity verification**: strong authentication with MFA for all users
- **Device trust**: only allow access from managed, compliant devices
- **Micro-segmentation**: network segmentation at the workload level
- **Continuous monitoring**: real-time risk assessment and adaptive access
- **Encryption everywhere**: TLS for all communications, even internal
- **Context-aware access**: Google BeyondCorp, Azure Conditional Access, AWS Verified Access
- Documentation: https://cloud.google.com/beyondcorp

---

## Incident Response Scenarios

### Scenario: Compromised AWS Access Keys

**Detection signals:**
- CloudTrail shows API calls from unusual IP addresses or regions
- GuardDuty alerts on anomalous API activity
- Unexpected resource creation (crypto mining instances, new IAM users)

**Response steps:**
1. **Contain**: immediately disable the compromised access key (do not delete - preserve for investigation)
2. **Assess scope**: review CloudTrail logs for all actions taken with the key
   - What resources were accessed or created?
   - Were additional credentials created (new IAM users, keys)?
   - Was data exfiltrated (S3 GetObject, database exports)?
3. **Eradicate**:
   - Revoke any active sessions (invalidate temporary credentials)
   - Delete any unauthorized IAM users or roles created by the attacker
   - Terminate unauthorized resources (EC2 instances, Lambda functions)
   - Rotate all potentially compromised secrets
4. **Recover**:
   - Issue new credentials to the affected user
   - Verify all unauthorized changes are reversed
   - Restore any modified resources from backup
5. **Lessons learned**:
   - Why was the key exposed? (committed to Git, stored in plaintext, phished)
   - Implement preventive measures (secret scanning, credential rotation)
   - Update incident response runbook

### Scenario: Data Breach - S3 Bucket Exposure

**Detection signals:**
- AWS Config rule flagging public bucket
- S3 Access Logs showing external IP access
- Security Hub or third-party scanner alert

**Response steps:**
1. **Contain**: immediately block public access (S3 Block Public Access)
2. **Assess**: determine what data was exposed and for how long
   - Review S3 access logs and CloudTrail data events
   - Identify the data classification of exposed objects
   - Determine if data was actually accessed by unauthorized parties
3. **Notify**: follow your data breach notification procedures
   - Legal team, privacy officer, affected customers (if applicable)
   - Regulatory bodies if required (GDPR - 72 hours, HIPAA, PCI)
4. **Remediate**:
   - Enable S3 Block Public Access at the account level
   - Review and fix bucket policies across all buckets
   - Enable AWS Config rules to detect future misconfigurations
   - Implement SCPs to prevent public bucket creation

### Scenario: Ransomware Attack on Cloud Workloads

**Response steps:**
1. **Isolate**: disconnect affected instances from the network (modify security groups to deny all)
2. **Assess**: identify the ransomware strain and attack vector
3. **Contain**: verify the attack has not spread to other workloads
4. **Recover**: restore from clean backups (verify backups are not compromised)
5. **Investigate**: review logs for initial access vector
6. **Harden**: patch vulnerabilities, update security controls, improve backup strategy

---

## Encryption and Key Management

### Encryption Architecture

**Envelope encryption:**
- Data is encrypted with a Data Encryption Key (DEK)
- The DEK is encrypted with a Key Encryption Key (KEK)
- Only the encrypted DEK is stored alongside the data
- Benefits: faster encryption of large data, easier key rotation
- Used by: AWS KMS, Azure Key Vault, Google Cloud KMS

**Key hierarchy:**
- Root keys (managed by the cloud provider or customer)
- Customer Master Keys (CMKs) / Key Encryption Keys
- Data Encryption Keys (DEKs)

### Key Management Options

| Option | Control Level | Management Effort | Use Case |
|--------|--------------|-------------------|----------|
| Provider-managed keys | Lowest | None | Default encryption |
| Customer-managed keys (CMEK) | Medium | Moderate | Regulatory compliance |
| Customer-supplied keys (CSEK) | Highest | High | Maximum control |
| HSM-backed keys (CloudHSM) | Highest | Highest | FIPS 140-2 Level 3 |

### Key Management Best Practices

- Enable automatic key rotation (annually at minimum)
- Use separate keys for different data classifications
- Restrict key access to only the services and users that need them
- Monitor key usage through audit logs
- Plan for key revocation and re-encryption procedures
- Never store encryption keys alongside the data they protect
- AWS KMS: https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
- Azure Key Vault: https://learn.microsoft.com/en-us/azure/key-vault/general/overview
- Google Cloud KMS: https://cloud.google.com/kms/docs/concepts

### Certificate Management

- Use managed certificate services: ACM (AWS), Azure App Service Certificates, Google-managed SSL
- Automate certificate renewal to prevent expiration outages
- Implement certificate pinning for sensitive mobile applications
- Monitor certificate expiration dates with alerting
- Use short-lived certificates where possible (service mesh mTLS)

---

## Compliance Framework Questions

### Common Compliance Frameworks

| Framework | Focus | Applicability |
|-----------|-------|---------------|
| SOC 2 | Security, availability, processing, confidentiality, privacy | SaaS companies, service providers |
| PCI DSS | Payment card data protection | Any organization handling credit card data |
| HIPAA | Protected health information | Healthcare and health data processors |
| GDPR | Personal data protection | Organizations handling EU residents' data |
| FedRAMP | Federal government cloud security | Cloud services for US federal agencies |
| ISO 27001 | Information security management | Global standard for security management |

### How Do You Implement PCI DSS in the Cloud?

- Network segmentation: isolate cardholder data environment (CDE) in separate VPC/subnets
- Encryption: encrypt cardholder data at rest and in transit
- Access control: restrict access to CDE to authorized personnel only
- Logging: log all access to cardholder data, retain for 12 months
- Vulnerability management: regular scanning and penetration testing
- Use tokenization to reduce PCI scope (replace card numbers with tokens)
- Documentation: https://docs.aws.amazon.com/whitepapers/latest/pci-dss-scoping-on-aws/pci-dss-scoping-on-aws.html

### How Do You Handle GDPR in the Cloud?

- Data residency: keep EU personal data in EU regions
- Right to erasure: implement data deletion capabilities across all systems
- Data processing agreements: ensure cloud provider has appropriate DPA
- Consent management: track and honor user consent preferences
- Breach notification: 72-hour notification to supervisory authority
- Data Protection Impact Assessments for high-risk processing
- Privacy by design: build privacy controls into architecture from the start

### Compliance as Code

- Define compliance policies as code using:
  - AWS Config rules and conformance packs
  - Azure Policy and regulatory compliance blueprints
  - GCP Organization Policy constraints
  - Open Policy Agent (OPA) for Kubernetes
  - Terraform Sentinel or Checkov for IaC compliance
- Automated compliance scanning in CI/CD pipelines
- Continuous monitoring and drift detection for compliance controls

---

## Penetration Testing Concepts

### Cloud Penetration Testing Rules

- AWS: no permission required for most services (read the updated policy)
  - https://aws.amazon.com/security/penetration-testing/
- Azure: no permission required, follow rules of engagement
  - https://learn.microsoft.com/en-us/azure/security/fundamentals/pen-testing
- GCP: no permission required for your own projects
  - https://cloud.google.com/security/overview/

### Common Attack Vectors in Cloud

1. **Credential theft**: phishing, exposed keys in Git repos, metadata service (IMDS) exploitation
2. **Misconfiguration**: public storage buckets, overly permissive IAM, open security groups
3. **Privilege escalation**: chaining IAM permissions to gain higher access
   - Example: iam:PassRole + lambda:CreateFunction = arbitrary code execution with any role
4. **Server-Side Request Forgery (SSRF)**: access metadata service from vulnerable applications
   - Mitigation: IMDSv2 (AWS), metadata concealment (GCP), Instance Metadata Service restrictions
5. **Supply chain attacks**: compromised dependencies, malicious container images
6. **Lateral movement**: pivot from compromised workload to access other services

### Security Testing Tools

- **Infrastructure scanning**: Prowler (AWS), ScoutSuite (multi-cloud), CloudSploit
- **Container scanning**: Trivy, Grype, Snyk Container
- **IaC scanning**: Checkov, tfsec, KICS
- **DAST**: OWASP ZAP, Burp Suite
- **SAST**: Semgrep, SonarQube, CodeQL
- **Secret scanning**: GitLeaks, TruffleHog, GitHub secret scanning

---

## Security Monitoring and Detection

### Cloud-Native Security Services

| Service Type | AWS | Azure | GCP |
|-------------|-----|-------|-----|
| Threat detection | GuardDuty | Microsoft Defender for Cloud | Security Command Center |
| Security posture | Security Hub | Defender CSPM | Security Command Center |
| Audit logging | CloudTrail | Activity Log | Cloud Audit Logs |
| Network monitoring | VPC Flow Logs | NSG Flow Logs | VPC Flow Logs |
| WAF | AWS WAF | Azure WAF | Cloud Armor |

### SIEM and SOAR

- **SIEM** (Security Information and Event Management): aggregate and correlate security logs
  - Cloud-native: Amazon Security Lake, Azure Sentinel, Google Chronicle
  - Third-party: Splunk, Elastic Security, Datadog Security
- **SOAR** (Security Orchestration, Automation, and Response): automate incident response
  - Playbooks for common incidents (compromised credentials, malware detection)
  - Automated containment actions (isolate instance, revoke credentials)
  - Integration with ticketing systems for tracking

### What Logs Should You Always Collect?

- API activity logs (CloudTrail, Activity Log, Cloud Audit Logs)
- Network flow logs (VPC Flow Logs)
- DNS query logs
- Application access logs (load balancer, API gateway)
- Authentication logs (failed and successful logins)
- Database audit logs
- Container and Kubernetes audit logs
- Store logs centrally with immutable retention (prevent tampering)

---

## Key Documentation Links

| Resource | URL |
|----------|-----|
| AWS Security Best Practices | https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html |
| Azure Security Documentation | https://learn.microsoft.com/en-us/azure/security/ |
| GCP Security Best Practices | https://cloud.google.com/security/best-practices |
| OWASP Top 10 | https://owasp.org/www-project-top-ten/ |
| CIS Benchmarks | https://www.cisecurity.org/cis-benchmarks |
| NIST Cybersecurity Framework | https://www.nist.gov/cyberframework |

---

## Tips for Security Engineer Interviews

- Think like an attacker but communicate like a defender
- Always consider the business impact of security decisions
- Know the difference between prevention, detection, and response controls
- Be familiar with at least one cloud provider's security services in depth
- Understand that security is about risk management, not eliminating all risk
- Practice explaining security concepts to non-technical stakeholders
- Be prepared to discuss trade-offs between security and usability
- Show awareness of current threat landscape and recent breaches
- Demonstrate a systematic approach to incident response
- Know compliance frameworks relevant to the company you are interviewing with
