---
last-updated: 2026-05-03
---

# AWS Security Specialty (SCS-C02) - Fact Sheet

## Quick Reference

**Exam Code:** SCS-C02
**Duration:** 170 minutes
**Questions:** 65 questions
**Passing Score:** 750/1000
**Cost:** $300 USD
**Validity:** 3 years
**Delivery:** Pearson VUE
**Difficulty:** ⭐⭐⭐⭐ (Advanced specialty)

## Exam Domain Breakdown

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Threat Detection & Incident Response | 14% | GuardDuty, Detective, Security Hub, incident response |
| Security Logging & Monitoring | 18% | CloudTrail, CloudWatch, VPC Flow Logs, Config |
| Infrastructure Security | 20% | Network security, encryption, endpoint security |
| Identity & Access Management | 16% | IAM, STS, Cognito, federation, policies |
| Data Protection | 18% | Encryption (KMS, CloudHSM), S3 security, DLP |
| Management & Security Governance | 14% | Organizations, Config, Control Tower, compliance |

## Core Security Services

### Threat Detection & Incident Response (14%)

**GuardDuty** - Intelligent threat detection
- ML-powered analysis of VPC Flow Logs, CloudTrail, DNS logs
- Detects: Unusual API calls, compromised instances, reconnaissance, cryptocurrency mining
- Findings: Low, Medium, High severity
- Integration: EventBridge for automated response
- Multi-account: Delegated administrator model
- 30-day free trial
- [📖 GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)

**Security Hub** - Centralized security findings
- Aggregates findings from GuardDuty, Inspector, Macie, IAM Access Analyzer, Firewall Manager
- Security standards: AWS Foundational Security Best Practices, CIS AWS Foundations, PCI DSS
- Automated and custom actions for remediation
- Cross-region aggregation
- [📖 Security Hub Documentation](https://docs.aws.amazon.com/securityhub/)

**Detective** - Security investigation
- Graph-based analysis of VPC Flow Logs, CloudTrail, GuardDuty findings
- Visualize security events and relationships
- Root cause analysis
- 50 GB free per account/month for 30 days
- [📖 Detective Documentation](https://docs.aws.amazon.com/detective/)

**Incident Response**
- EventBridge rules for automated response
- **[📖 EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/)** - Event-driven automation
- Lambda for custom remediation
- **[📖 Lambda](https://docs.aws.amazon.com/lambda/latest/dg/)** - Serverless remediation
- Step Functions for complex workflows
- **[📖 Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/)** - Workflow orchestration
- Systems Manager for automated runbooks
- **[📖 Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)** - Runbooks
- Incident Manager for coordination
- **[📖 Incident Manager](https://docs.aws.amazon.com/incident-manager/)** - Incident response

### Security Logging & Monitoring (18%)

**CloudTrail** - API audit logging
- Records ALL API calls (read/write operations)
- Management events (control plane) and data events (data plane)
- Organizational trails for multi-account logging
- Log file integrity validation with digest files
- Insights for anomaly detection (additional cost)
- Storage: S3 with SSE-S3 or SSE-KMS
- [📖 CloudTrail Documentation](https://docs.aws.amazon.com/cloudtrail/)
- [📖 CloudTrail Best Practices](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/best-practices-security.html)

**VPC Flow Logs** - Network traffic monitoring
- Capture ACCEPT/REJECT decisions for traffic
- Logged to CloudWatch Logs or S3
- Identifies: Port scanning, unusual traffic patterns, rejected connections
- Custom format for specific fields
- Can enable at VPC, subnet, or ENI level
- **[📖 VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network monitoring

**CloudWatch Logs** - Application and system logs
- Log aggregation with retention policies
- Metric filters to extract metrics from logs
- Log Insights for querying with SQL-like language
- Subscription filters: Stream to Lambda, Kinesis, Firehose, OpenSearch
- Encryption with KMS
- Cross-account log sharing
- **[📖 CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/)** - Log management
- **[📖 CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)** - Log analytics

**AWS Config** - Resource configuration history
- Tracks configuration changes over time
- Compliance rules (AWS managed + custom Lambda)
- Remediation actions (SSM Automation)
- Configuration recorder stores config in S3
- Multi-account aggregation
- [📖 Config Documentation](https://docs.aws.amazon.com/config/)

**CloudWatch Alarms** - Proactive monitoring
- Metric-based alarms with SNS notifications
- Composite alarms for complex conditions
- Actions: SNS, Auto Scaling, EC2, SSM
- **[📖 CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Metric monitoring

### Infrastructure Security (20%)

**Network Security**

**VPC Security**
- Security Groups: Stateful, instance-level firewall
- **[📖 Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)** - Instance firewalls
- NACLs: Stateless, subnet-level firewall
- **[📖 Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Subnet firewalls
- Private subnets with NAT Gateway for outbound-only
- **[📖 NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)** - Outbound internet access
- VPC endpoints (Gateway for S3/DynamoDB, Interface for others)
- **[📖 VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html)** - Private AWS connectivity
- PrivateLink for private service connectivity
- **[📖 AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/)** - Private connectivity
- [📖 VPC Security Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)

**Network Firewall** - Managed stateful firewall
- Layer 3-7 filtering
- Intrusion prevention system (IPS)
- Web filtering with domain lists
- Rule groups: Stateful (5-tuple, domain, Suricata rules), Stateless
- Centralized deployment with Firewall Manager
- [📖 Network Firewall Documentation](https://docs.aws.amazon.com/network-firewall/)

**WAF (Web Application Firewall)** - Layer 7 protection
- Protects CloudFront, ALB, API Gateway, AppSync
- Managed rules: Core Rule Set, Known Bad Inputs, SQL injection, XSS
- Custom rules: IP sets, geo-blocking, rate limiting, string matching
- Logging to S3, CloudWatch Logs, Kinesis Firehose
- [📖 WAF Documentation](https://docs.aws.amazon.com/waf/)

**Shield** - DDoS protection
- Standard: Free, automatic protection for all AWS customers
- Advanced: $3,000/month, enhanced protection + 24/7 DRT (DDoS Response Team)
- Advanced features: Cost protection, advanced metrics, DRT support
- [📖 Shield Documentation](https://docs.aws.amazon.com/shield/)

**Endpoint Security**

**Systems Manager** - Instance management
- Session Manager: Shell access without SSH/RDP, no bastion hosts
- **[📖 Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)** - Secure shell access
- Patch Manager: Automated OS patching
- **[📖 Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html)** - OS patching
- State Manager: Enforce desired state
- **[📖 State Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state.html)** - Configuration management
- Run Command: Execute commands at scale
- **[📖 Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html)** - Remote execution
- All without opening inbound ports
- [📖 Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/)

**Inspector** - Vulnerability scanning
- EC2: Network and host assessments, CVE detection
- ECR: Container image vulnerability scanning
- Lambda: Code and package vulnerabilities
- Continuous scanning with findings in Security Hub
- [📖 Inspector Documentation](https://docs.aws.amazon.com/inspector/)

**Secrets Access**
- IMDSv2 (Instance Metadata Service v2): Session-based, prevents SSRF
- **[📖 IMDSv2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html)** - Secure metadata
- VPC endpoints for accessing services privately
- No internet gateway needed for AWS service access

### Identity & Access Management (16%)

**IAM Best Practices**
- Root account: MFA, no access keys, minimal use
- Users: Individual IAM users with MFA
- Groups: Assign permissions to groups, not users
- Roles: For applications, cross-account, federation
- Policies: Least privilege, explicit deny, conditions
- [📖 IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

**IAM Policies**
- Identity-based: Attached to users, groups, roles
- Resource-based: Attached to resources (S3, SQS, Lambda, KMS)
- Permission boundaries: Max permissions for entity
- Service Control Policies (SCPs): Organization-level guardrails
- Session policies: Temporary restrictions during AssumeRole
- **[📖 IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Policy types

**Policy Evaluation Logic**
1. Explicit DENY always wins
2. Explicit ALLOW overrides implicit deny
3. Evaluate all applicable policies (identity, resource, SCPs, boundaries)
4. Default: Implicit deny
- **[📖 Policy Evaluation Logic](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)** - How AWS evaluates permissions

**IAM Conditions** - Fine-grained access control
- aws:SourceIp - Restrict by IP address
- aws:SecureTransport - Enforce HTTPS
- aws:MultiFactorAuthPresent - Require MFA
- aws:RequestedRegion - Restrict regions
- aws:PrincipalOrgID - Restrict to organization
- s3:x-amz-server-side-encryption - Enforce encryption
- **[📖 IAM Policy Conditions](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html)** - Condition keys reference

**Cross-Account Access**
- IAM roles with trust policy (preferred)
- Resource-based policies (S3, SQS, SNS, Lambda, KMS)
- External ID for third-party access (prevents confused deputy)
- **[📖 Cross-Account Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_common-scenarios_aws-accounts.html)** - Cross-account patterns

**Federation**
- SAML 2.0 for enterprise SSO (Active Directory, Okta, etc.)
- **[📖 SAML Federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html)** - SAML 2.0 setup
- IAM Identity Center (AWS SSO) for centralized access
- **[📖 IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/)** - AWS SSO
- Cognito for mobile/web applications
- Web Identity Federation (Google, Facebook, Amazon)
- **[📖 Web Identity Federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)** - OIDC federation

**STS (Security Token Service)**
- AssumeRole: Cross-account or same-account role assumption
- AssumeRoleWithSAML: SAML-based federation
- AssumeRoleWithWebIdentity: Mobile/web identity federation
- GetSessionToken: MFA-protected operations
- GetFederationToken: Proxy applications (legacy)
- Temporary credentials: 15 min to 12 hours (roles), 36 hours (federation)
- **[📖 AWS STS](https://docs.aws.amazon.com/STS/latest/APIReference/)** - Temporary credentials

**Cognito**
- User Pools: User directory, sign-up/sign-in, MFA
- Identity Pools: Temporary AWS credentials for users
- Advanced security: Adaptive authentication, compromised credentials check
- [📖 Cognito Documentation](https://docs.aws.amazon.com/cognito/)

### Data Protection (18%)

**Encryption at Rest**

**KMS (Key Management Service)** - Managed encryption keys
- Customer Managed Keys (CMKs): Full control, $1/month/key
- AWS Managed Keys: AWS-created, free, limited control
- Key policies: Resource-based policies for key access
- Grants: Temporary, programmatic access delegation
- Automatic key rotation: Once per year (CMK only)
- Multi-region keys: Same key ID across regions
- Envelope encryption: Data keys encrypt data, KMS encrypts data keys
- CloudHSM integration for FIPS 140-2 Level 3
- [📖 KMS Documentation](https://docs.aws.amazon.com/kms/)
- [📖 KMS Best Practices](https://docs.aws.amazon.com/kms/latest/developerguide/best-practices.html)

**CloudHSM** - Hardware Security Module
- FIPS 140-2 Level 3 validated
- Single-tenant hardware
- Customer manages keys, AWS manages hardware
- Use cases: Regulatory compliance, cryptographic operations, SSL/TLS offload
- Integration: KMS custom key store, Oracle TDE, Microsoft SQL Server TDE
- [📖 CloudHSM Documentation](https://docs.aws.amazon.com/cloudhsm/)

**S3 Encryption**
- SSE-S3: S3-managed keys (AES-256), free
- SSE-KMS: KMS-managed keys, audit trail, key policies
- SSE-C: Customer-provided keys (customer manages)
- Client-side encryption: Encrypt before upload
- Bucket default encryption (SSE-S3 or SSE-KMS)
- Enforce encryption: Bucket policy with aws:SecureTransport and s3:x-amz-server-side-encryption
- **[📖 S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)** - Encryption options
- [📖 S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)

**EBS Encryption**
- Transparent: Encrypt volumes, snapshots
- KMS keys (default or custom CMK)
- Encryption by default per region
- Snapshots inherit encryption from volume
- Cannot remove encryption once enabled
- **[📖 EBS Encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html)** - Volume encryption

**RDS/Aurora Encryption**
- Encrypt at creation (cannot encrypt existing)
- KMS-based encryption
- Snapshots and read replicas inherit encryption
- Transparent Data Encryption (TDE) for Oracle and SQL Server
- **[📖 RDS Encryption](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html)** - Database encryption

**DynamoDB Encryption**
- Always encrypted at rest (default)
- AWS owned key (free, default) or KMS CMK
- Encryption in transit via HTTPS
- **[📖 DynamoDB Encryption](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html)** - Table encryption

**Encryption in Transit**
- TLS/SSL for all AWS API calls
- VPN for on-premises connectivity
- **[📖 Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/)** - IPSec VPN
- Certificate Manager (ACM) for certificate management
- **[📖 AWS Certificate Manager](https://docs.aws.amazon.com/acm/)** - SSL/TLS certificates
- API Gateway with custom domain + ACM certificate
- CloudFront with ACM certificate

**Data Loss Prevention**

**Macie** - Sensitive data discovery
- ML-powered detection of PII, PHI, credentials in S3
- Automated sensitive data discovery jobs
- Findings: Sensitive data types, locations, access control
- Integration with Security Hub and EventBridge
- [📖 Macie Documentation](https://docs.aws.amazon.com/macie/)

**S3 Security Features**
- Block Public Access: Account and bucket-level
- **[📖 S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)** - Prevent public access
- Access Points: Simplified access control for shared datasets
- **[📖 S3 Access Points](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points.html)** - Manage data access
- Object Lock: WORM (Write Once Read Many), compliance, governance mode
- **[📖 S3 Object Lock](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html)** - Immutable storage
- Versioning: Protect against accidental deletion
- MFA Delete: Require MFA to delete objects
- **[📖 S3 MFA Delete](https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiFactorAuthenticationDelete.html)** - MFA for deletions
- Access Analyzer for S3: Detect buckets accessible outside account
- **[📖 IAM Access Analyzer for S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-analyzer.html)** - External access detection
- [📖 S3 Access Control](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-best-practices.html)

**Secrets Management**
- Secrets Manager: Automatic rotation, versioning, $0.40/secret/month
- Parameter Store: Secure strings with KMS, standard tier free
- Never hardcode credentials in code
- IAM roles for applications to retrieve secrets
- [📖 Secrets Manager Documentation](https://docs.aws.amazon.com/secretsmanager/)
- **[📖 Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)** - SSM parameters

### Management & Security Governance (14%)

**AWS Organizations** - Multi-account management
- Consolidated billing across accounts
- Service Control Policies (SCPs) for guardrails
- Organizational Units (OUs) for grouping
- Account creation automation
- StackSets for cross-account deployments
- [📖 Organizations Documentation](https://docs.aws.amazon.com/organizations/)

**Service Control Policies (SCPs)**
- Permission boundaries at organization/OU/account level
- Deny list (default) or allow list strategy
- Do NOT grant permissions, only restrict
- Affect all principals except root user of member account
- Common uses: Deny region, deny root user actions, enforce MFA, enforce encryption
- **[📖 Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)** - Permission guardrails
- **[📖 SCP Examples](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html)** - Common SCPs

**Control Tower** - Landing zone automation
- Automated account provisioning
- Guardrails (preventive via SCPs, detective via Config rules)
- Account Factory for standardized account creation
- Dashboard for compliance visibility
- [📖 Control Tower Documentation](https://docs.aws.amazon.com/controltower/)

**AWS Config** - Compliance monitoring
- Continuous compliance assessment
- Managed rules: 200+ AWS best practices
- Custom rules: Lambda-based
- Conformance packs: Pre-built compliance frameworks (CIS, NIST, PCI-DSS)
- Automatic remediation via SSM Automation
- [📖 Config Managed Rules](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)

**IAM Access Analyzer** - Permission analysis
- Analyzes resource policies to find external access
- Detects overly permissive policies
- Validates policies against grammar and best practices
- Generates least-privilege policies based on access logs
- [📖 Access Analyzer Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

**Audit Manager** - Compliance evidence collection
- Automates evidence collection for audits
- Pre-built frameworks: HIPAA, GDPR, SOC 2, PCI DSS
- Custom frameworks
- Evidence collection from AWS services
- [📖 Audit Manager Documentation](https://docs.aws.amazon.com/audit-manager/)

**Firewall Manager** - Centralized security policy
- Manage WAF, Shield Advanced, Security Groups, Network Firewall, Route 53 Resolver DNS Firewall
- Organization-wide policies
- Automatic application to new accounts/resources
- Requires AWS Organizations and Config
- [📖 Firewall Manager Documentation](https://docs.aws.amazon.com/firewall-manager/)

## Security Architecture Patterns

### Defense in Depth
```
Layer 1: AWS Account Security (Root account MFA, Organizations SCPs)
Layer 2: Network Security (VPC, Security Groups, NACLs, Network Firewall)
Layer 3: Application Security (WAF, API Gateway, CloudFront)
Layer 4: Data Security (Encryption at rest and in transit, KMS)
Layer 5: Identity Security (IAM, MFA, least privilege, federation)
Layer 6: Detection (GuardDuty, Config, CloudTrail, Security Hub)
Layer 7: Response (Automated remediation, Incident Manager, runbooks)
```

### Zero Trust Architecture
- No implicit trust, verify everything
- Least privilege access (IAM policies, SCPs)
- Micro-segmentation (Security Groups per resource)
- Continuous monitoring (CloudTrail, Config, GuardDuty)
- Assume breach mentality (Detective for investigation)

### Incident Response Workflow
```
1. Detection → GuardDuty finding
2. Alert → EventBridge rule → SNS → Security team
3. Containment → Lambda function → Isolate instance (modify SG, attach forensic SG)
4. Investigation → Detective, CloudTrail, VPC Flow Logs
5. Eradication → Terminate compromised resources, patch vulnerabilities
6. Recovery → Restore from clean backups
7. Lessons Learned → Update runbooks, improve detections
```

## Common Security Scenarios

### Scenario 1: Detect and Remediate Exposed S3 Buckets
**Solution:**
- Config rule: `s3-bucket-public-read-prohibited`
- Config remediation action: SSM Automation runbook
- Lambda function: Remove public access policies
- Security Hub: Aggregate findings
- EventBridge: Trigger on Config non-compliance
- SNS: Notify security team

### Scenario 2: Encrypt All EBS Volumes
**Solution:**
- Enable EBS encryption by default (per region)
- Config rule: `ec2-ebs-encryption-by-default`
- Existing unencrypted volumes: Snapshot → Copy with encryption → Create new volume
- AWS Backup: Enforce encryption in backup vault
- SCP: Deny ec2:RunInstances without encrypted volumes

### Scenario 3: Centralized Logging for 100+ Accounts
**Solution:**
- Organizations: Central security account
- CloudTrail: Organization trail → S3 in security account
- Config: Aggregator in security account
- GuardDuty: Delegated administrator in security account
- Security Hub: Delegated administrator with cross-region aggregation
- S3 bucket: Server-side encryption with KMS, versioning, MFA delete, lifecycle policy

### Scenario 4: Prevent Data Exfiltration
**Solution:**
- VPC endpoints for S3, DynamoDB (no internet gateway)
- S3 bucket policies: Enforce aws:SourceVpc or aws:SourceVpce
- SCPs: Deny s3:PutObject without encryption
- GuardDuty: Detect unusual data transfer patterns
- Macie: Identify sensitive data in S3
- VPC Flow Logs: Monitor network traffic
- CloudTrail: Audit all S3 API calls

### Scenario 5: Compromised IAM Credentials
**Response:**
1. Immediately disable credentials (make inactive or delete)
2. Review CloudTrail for unauthorized actions
3. Revoke active sessions (AWS STS)
4. Rotate all other credentials
5. Review and remove unauthorized resources
6. Enable GuardDuty if not already enabled
7. Implement stricter IAM policies and MFA

## Key Security Limits & Numbers

**IAM:**
- 5,000 users per account (soft limit)
- 300 groups per account (soft limit)
- 1,500 roles per account (soft limit)
- 10 managed policies per user/group/role
- 2,048 characters max policy size (identity-based)
- 10,240 characters max policy size (resource-based)

**KMS:**
- 100,000 CMKs per region (soft limit)
- 10,000 grants per CMK (soft limit)
- 10 KB max encrypted data via KMS API directly
- Automatic key rotation: Once per year

**GuardDuty:**
- 10,000 trusted IP lists per account
- 1,000 threat lists per account
- 6 MB max threat list file size

**Security Hub:**
- 100 finding aggregators per region
- 3,000 insights per account per region
- 100,000 findings per account per region

**CloudTrail:**
- 5 trails per region (organizational trail counts as 1)
- 90 days event history (free, no S3)
- Unlimited retention with S3 storage

## Exam Strategy

### Time Management
- 170 minutes ÷ 65 questions = 2.6 minutes per question
- Security scenarios can be complex
- Flag difficult questions, return later

### Question Keywords
- **"Most secure"** → Defense in depth, least privilege, MFA, encryption
- **"Detect"** → GuardDuty, Config, CloudTrail, VPC Flow Logs
- **"Prevent"** → SCPs, IAM policies, Security Groups, WAF
- **"Audit"** → CloudTrail, Config, Access Analyzer, Security Hub
- **"Encrypt"** → KMS, CloudHSM, SSL/TLS, enforce via policies
- **"Compliance"** → Config rules, Audit Manager, Security Hub standards
- **"Least privilege"** → IAM policies, SCPs, permission boundaries

### Common Traps
- ❌ Root account usage (almost never correct)
- ❌ Security through obscurity
- ❌ Overly permissive policies (should be least privilege)
- ❌ Not enabling encryption by default
- ❌ Ignoring logging and monitoring

## Essential Documentation

### AWS Official Resources
- [📖 AWS Security Best Practices Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/aws-security-best-practices/welcome.html)
- [📖 AWS Security Incident Response Guide](https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html)
- [📖 Well-Architected Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [📖 AWS Compliance Programs](https://aws.amazon.com/compliance/programs/)
- [📖 Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)

### Service Documentation
- [📖 Security, Identity & Compliance Services](https://docs.aws.amazon.com/security/)
- [📖 AWS Security Blog](https://aws.amazon.com/blogs/security/) - Latest updates and best practices

### Hands-on Resources
- [🧪 AWS Security Workshops](https://workshops.aws/categories/Security) - Free hands-on labs
- [🧪 Well-Architected Labs - Security](https://wellarchitectedlabs.com/security/)

## Final Exam Checklist

### Knowledge
- [ ] Design secure multi-layer architectures
- [ ] Implement least privilege IAM policies
- [ ] Configure encryption at rest and in transit
- [ ] Set up centralized logging and monitoring
- [ ] Detect and respond to security incidents
- [ ] Implement data loss prevention controls
- [ ] Design secure network architectures
- [ ] Implement compliance controls with Config
- [ ] Secure S3 buckets and prevent data exfiltration
- [ ] Federate identities and implement MFA

### Experience
- [ ] 2+ years AWS security experience
- [ ] Implemented security controls in production
- [ ] Responded to security incidents
- [ ] Configured IAM policies and SCPs
- [ ] Encrypted data and managed keys
- [ ] Set up security monitoring and alerting
- [ ] Conducted security audits

### Preparation
- [ ] Completed Associate-level certification
- [ ] Read AWS security whitepapers
- [ ] Hands-on with GuardDuty, Config, KMS
- [ ] Practiced IAM policy creation
- [ ] Configured WAF and Network Firewall
- [ ] Set up CloudTrail and Security Hub
- [ ] Practice exams scoring 80%+

---

**Pro Tip:** SCS-C02 focuses heavily on defense in depth, least privilege, and automated detection/response. Always choose the most secure option that meets requirements. Remember: Security is a shared responsibility - know what AWS manages vs what you manage!

**Good luck!** This certification validates expert-level AWS security skills. 🔒
