# Domain 3: Security and Compliance (18%)

## 📋 Overview

This domain covers identity and access management, multi-account governance, data protection, threat detection, and compliance monitoring. The SOA-C03 exam places increased emphasis on AWS Organizations, Control Tower, and centralized security services compared to its predecessor.

## 🎯 Key Services

### AWS IAM (Identity and Access Management)

**📖 [AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)** - Identity and access management
**📖 [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Security recommendations

#### IAM Policy Types

| Policy Type | Attached To | Purpose |
|------------|-------------|---------|
| Identity-Based | Users, groups, roles | Grant permissions to principals |
| Resource-Based | Resources (S3, KMS, SQS) | Grant cross-account access |
| Permission Boundaries | Users, roles | Maximum permissions ceiling |
| Service Control Policies | OUs, accounts | Organization-wide guardrails |
| Session Policies | STS sessions | Limit session permissions |

**📖 [IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Policy types and evaluation
**📖 [Policy Evaluation Logic](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)** - How policies are evaluated

#### Policy Evaluation Order

1. **Explicit Deny** - Always wins, stops evaluation
2. **SCP** - Must allow (if Organizations is enabled)
3. **Resource-Based Policy** - Can grant cross-account access
4. **Permission Boundary** - Must allow (if set)
5. **Identity-Based Policy** - Must allow
6. **Default** - Implicit deny

#### IAM Roles

- **Service Roles**: Allow AWS services to act on your behalf (EC2, Lambda, ECS)
- **Cross-Account Roles**: Enable access between AWS accounts
- **Federation Roles**: For SAML 2.0 or web identity federation
- **Instance Profiles**: Attach roles to EC2 instances
- **Best Practice**: Always prefer roles over long-term access keys

**📖 [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)** - Roles overview
**📖 [Cross-Account Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html)** - Cross-account roles

#### IAM Security Features

- **MFA**: Virtual MFA, hardware token, FIDO security key
- **Password Policy**: Length, complexity, rotation requirements
- **Access Keys**: Rotate regularly, use IAM Credentials Report to audit
- **Access Analyzer**: Identify resources shared externally
- **Credential Report**: Account-level report of all IAM users and credentials

**📖 [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)** - External access analysis

---

### AWS Organizations

**📖 [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)** - Multi-account management

#### Key Concepts

- **Management Account**: Root account that creates the organization (formerly master)
- **Organizational Units (OUs)**: Hierarchical grouping of accounts
- **Service Control Policies (SCPs)**: Permission guardrails applied to OUs or accounts
- **Consolidated Billing**: Single payment for all accounts, volume discounts

#### Service Control Policies (SCPs)

- Apply to all IAM entities in target accounts (except management account)
- Do **not** grant permissions -- only restrict them
- Follow inheritance hierarchy: Root -> OU -> Account
- Use deny lists (allow all, deny specific) or allow lists (deny all, allow specific)
- Do not affect service-linked roles

**📖 [Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)** - SCP reference
**📖 [SCP Examples](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html)** - Policy examples

#### Common SCP Patterns

- Prevent users from leaving the organization
- Restrict regions where resources can be created
- Require encryption on S3 buckets
- Prevent disabling CloudTrail or GuardDuty
- Restrict root user actions

---

### AWS Control Tower

**📖 [AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html)** - Multi-account landing zone

#### Key Features

- **Landing Zone**: Pre-configured multi-account environment with best practices
- **Account Factory**: Automated account provisioning with guardrails
- **Guardrails**: Pre-packaged governance rules
  - **Preventive**: Implemented via SCPs (deny actions)
  - **Detective**: Implemented via AWS Config rules (detect violations)
  - **Proactive**: Implemented via CloudFormation hooks (prevent non-compliant provisioning)
- **Dashboard**: Centralized view of compliance across accounts

**📖 [Control Tower Guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/guardrails.html)** - Governance rules
**📖 [Account Factory](https://docs.aws.amazon.com/controltower/latest/userguide/account-factory.html)** - Account provisioning

---

### Data Protection and Encryption

#### AWS KMS (Key Management Service)

**📖 [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key management

- **Key Types:**
  - **AWS Managed Keys**: Created and managed by AWS for specific services (aws/s3, aws/ebs)
  - **Customer Managed Keys (CMKs)**: You create and manage, full control over key policy
  - **AWS Owned Keys**: Used by AWS internally, not visible in your account
- **Key Policies**: Resource-based policies controlling key access
- **Grants**: Temporary, fine-grained permissions for specific operations
- **Key Rotation**: Automatic annual rotation for customer managed keys
- **Envelope Encryption**: Data key encrypts data, KMS key encrypts data key

**📖 [Key Policies](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)** - Key access control
**📖 [Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping)** - Encryption pattern

#### Encryption at Rest

| Service | Encryption Method | Notes |
|---------|-------------------|-------|
| S3 | SSE-S3, SSE-KMS, SSE-C, client-side | Default encryption available |
| EBS | KMS encryption | Enable by default per region |
| RDS | KMS encryption | Must enable at creation time |
| DynamoDB | AWS owned key or CMK | Enabled by default |
| EFS | KMS encryption | Enable at creation time |

**📖 [S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)** - Object encryption
**📖 [EBS Encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html)** - Volume encryption

#### Encryption in Transit

- **TLS/SSL**: Required for API calls, configurable for service endpoints
- **AWS Certificate Manager (ACM)**: Free public and private SSL/TLS certificates
- **VPN and Direct Connect**: Encrypted connectivity options

**📖 [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)** - Certificate management

---

### Threat Detection and Security Monitoring

#### Amazon GuardDuty

**📖 [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)** - Intelligent threat detection

- Analyzes CloudTrail, VPC Flow Logs, and DNS logs
- Detects account compromise, instance compromise, and reconnaissance
- Finding types: Backdoor, CryptoCurrency, Trojan, UnauthorizedAccess
- Multi-account support via Organizations integration
- Findings can trigger automated remediation via EventBridge

#### AWS Security Hub

**📖 [AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)** - Centralized security findings

- Aggregates findings from GuardDuty, Inspector, Macie, Config, and third-party tools
- Security standards: AWS Foundational Security Best Practices, CIS AWS Foundations, PCI DSS
- Automated compliance checks across accounts
- Custom actions for automated response

#### Amazon Inspector

**📖 [Amazon Inspector](https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html)** - Vulnerability scanning

- Automated vulnerability scanning for EC2, Lambda, and ECR images
- Network reachability analysis
- CVE-based findings with severity ratings

---

### Network Security

#### Security Groups vs Network ACLs

| Feature | Security Groups | Network ACLs |
|---------|----------------|--------------|
| Scope | Instance (ENI) level | Subnet level |
| State | Stateful | Stateless |
| Rules | Allow only | Allow and Deny |
| Evaluation | All rules evaluated | Rules evaluated in order |
| Default | Deny all inbound, allow all outbound | Allow all inbound and outbound |

**📖 [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)** - Instance-level firewall
**📖 [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Subnet-level firewall

#### AWS WAF (Web Application Firewall)

**📖 [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)** - Web application firewall

- Protects ALB, API Gateway, CloudFront, and AppSync
- Web ACL rules: IP match, geo match, rate limiting, SQL injection, XSS
- Managed rule groups: AWS managed, marketplace rules
- Logging to S3, CloudWatch, or Kinesis Firehose

#### AWS Shield

**📖 [AWS Shield](https://docs.aws.amazon.com/waf/latest/developerguide/shield-chapter.html)** - DDoS protection

- **Shield Standard**: Free, automatic protection against common DDoS attacks
- **Shield Advanced**: Enhanced protection with 24/7 DDoS response team, cost protection

---

## 📚 AWS Config for Compliance

### Common Config Rules for Operations

| Rule | Purpose |
|------|---------|
| `s3-bucket-versioning-enabled` | Ensure S3 versioning |
| `ec2-instance-no-public-ip` | No public IPs on instances |
| `rds-instance-public-access-check` | No public RDS instances |
| `encrypted-volumes` | EBS encryption required |
| `cloudtrail-enabled` | CloudTrail is active |
| `iam-root-access-key-check` | No root access keys |
| `mfa-enabled-for-iam-console-access` | MFA required |

**📖 [Managed Rules List](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)** - All managed rules

---

## 🎯 Exam Tips for Domain 3

1. **SCPs do not grant permissions** - they only restrict what identity-based policies can do
2. **SCPs do not affect the management account** - only member accounts
3. **Permission boundaries** - set maximum permissions for IAM users/roles
4. **Policy evaluation**: Explicit deny always wins over any allow
5. **Control Tower guardrails**: Know preventive (SCP) vs detective (Config) vs proactive (CFN hooks)
6. **KMS key rotation**: Automatic rotation only for symmetric CMKs, annual cycle
7. **GuardDuty vs Config**: GuardDuty detects threats; Config checks resource compliance
8. **Security groups are stateful**: Return traffic is automatically allowed
9. **NACLs are stateless**: Must explicitly allow return traffic with ephemeral port rules
