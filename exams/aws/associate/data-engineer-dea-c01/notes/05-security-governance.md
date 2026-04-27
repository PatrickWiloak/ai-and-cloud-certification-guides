# 05 - Data Security and Governance (Domain 4, ~18% of exam)

## IAM for data engineering

### Core principles

- **Least privilege** - grant only the actions required.
- **Identity-based policies** attached to users/roles.
- **Resource-based policies** attached to S3 buckets, KMS keys, Glue catalogs, Lambda functions, etc.
- **Service-linked roles** for AWS services (Glue, EMR, Lambda).
- **Cross-account access** via assumed roles + resource policies.

### Pipeline IAM patterns

- **Glue ETL job** uses an IAM role with:
  - S3 read on source buckets, write on target
  - Glue Data Catalog access
  - KMS Decrypt/Encrypt for any encrypted resource
  - CloudWatch Logs write
- **EMR cluster** uses two roles:
  - **Service role** - manages cluster lifecycle (EC2, EBS, etc.)
  - **EC2 instance profile** - what runs on the cluster nodes (S3 read/write, Glue Catalog access)
- **Step Functions execution role** - permissions for each task it invokes (Glue:StartJobRun, EMR:RunJobFlow, Lambda:InvokeFunction).
- **Lambda execution role** - service permissions plus VPC ENI permissions if attached to a VPC.

### Common IAM exam triggers

- "Glue job fails to read encrypted S3" → role missing `kms:Decrypt`
- "Cross-account S3 write from Glue" → S3 bucket policy on target + IAM role policy on source account
- "Restrict Glue to one database" → Glue resource policy + IAM Condition on `glue:GetDatabase`

---

## Encryption

### At-rest encryption

- **S3:**
  - **SSE-S3** (AES-256, S3-managed keys) - default
  - **SSE-KMS** - customer-managed via KMS, audit log via CloudTrail
  - **DSSE-KMS** (dual-layer) - for stricter compliance
  - **SSE-C** - customer-provided keys
  - Bucket-default encryption applies to all new objects unless overridden.
- **Redshift:** KMS-encrypted at rest. Snapshot encryption inherits the cluster's setting.
- **RDS / Aurora:** KMS-encrypted at rest. Snapshots encrypted automatically.
- **DynamoDB:** AWS-managed or customer-managed KMS keys.
- **EBS / EFS / FSx:** all KMS-encryption-capable.
- **Glue Data Catalog:** can encrypt metadata at rest with KMS.

### In-transit encryption

- TLS to all AWS endpoints by default.
- Force HTTPS on S3 with bucket policy condition `aws:SecureTransport = false → Deny`.
- Redshift / RDS support SSL connections; can require via parameter group.
- Glue connections support SSL.
- Kafka in MSK supports TLS (mutual TLS or SASL/SCRAM auth).

### KMS

- **AWS-managed keys** - free, AWS controls rotation, less audit detail.
- **Customer-managed keys (CMKs)** - you control rotation, key policy, full CloudTrail visibility.
- **Imported keys** - bring your own key material.
- **Multi-Region keys** - replicated keys for cross-region encrypted resources.
- Key rotation: annual for symmetric CMKs (one-click).
- Cross-account key sharing: allow other accounts in key policy.

**[📖 KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)**

### Encryption exam triggers

- "Encrypt S3 with our keys, with audit log" → SSE-KMS with customer-managed key, CloudTrail data events on KMS
- "Cross-account encrypted S3 access" → grant `kms:Decrypt` to the consumer principal in the key policy
- "Force TLS on all S3 reads" → bucket policy denying `aws:SecureTransport = false`
- "Compliance requires dual-layer at rest" → DSSE-KMS

---

## Network controls

### VPC endpoints

- **Gateway endpoints** - free, route-table-based, only for **S3** and **DynamoDB**.
- **Interface endpoints (PrivateLink)** - hourly + per-GB charge, ENI in your subnet, used for almost everything else (Glue, KMS, Athena, Redshift Data API, Step Functions, ECR, Secrets Manager, etc.).

### Common pipeline pattern

- Glue ETL in private subnet → Gateway endpoint to S3 (free) + Interface endpoints to KMS, Glue, CloudWatch.
- EMR in private subnet → S3 Gateway endpoint, optional NAT Gateway only for outbound internet (e.g., Maven dependencies).

### Security groups / NACLs

- Glue connections, EMR clusters, RDS, Redshift all use security groups.
- Self-referencing security group for cluster-internal communication.
- Stateful (security groups) vs stateless (NACLs).

### PrivateLink for cross-account services

- Expose a service via NLB → endpoint service → consumers create interface endpoints. Common for fronting on-prem-style data services.

### Network exam triggers

- "Glue can't reach S3 from VPC" → Add S3 Gateway endpoint
- "Cross-account access without traversing internet" → PrivateLink endpoint service
- "Block public S3 buckets account-wide" → S3 Block Public Access at the account level

---

## Lake Formation governance

### Permission model

- Grants are layered above IAM. IAM allow + Lake Formation allow are both required.
- **Granularity:** database, table, column, row, and cell-level.
- **LF-Tags** - assign tags to databases / tables / columns. Grant access by tag (e.g., `confidentiality=public,internal`). Recommended at scale - replaces hundreds of explicit grants.
- **Data filter expressions** for row-level security.

### Cross-account sharing

- Use LF-Tags or named-resource grants.
- Recipient account creates a resource link to the shared database / table.
- No data copy.
- Underlying primitive: AWS Resource Access Manager (RAM).

### Governed tables (Lake Formation)

- ACID transactions on S3 lake tables.
- Less common on the exam vs Iceberg these days, but still in scope.

**[📖 Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**

### Lake Formation exam triggers

- "Restrict analysts to only their region's rows" → Row-level security with LF-Tags + data filter
- "Mask SSN column for analyst role" → Column-level grant excluding `ssn`
- "Share lake table with sister account" → LF cross-account share via LF-Tags
- "Centralize access policies across hundreds of tables" → LF-Tags

---

## Sensitive-data discovery and DLP

### Amazon Macie

- ML-based PII / credentials / secrets discovery in S3.
- Scheduled or on-demand jobs.
- **Findings** types: SensitiveData (PII, financial, credentials) and Policy (e.g., bucket made public).
- Send findings to Security Hub, EventBridge.

**[📖 Macie User Guide](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)**

### Patterns

- Run Macie before opening a lake to broader access to find unexpected PII.
- Auto-route Macie findings to a remediation Lambda (e.g., quarantine the object).

---

## Audit and compliance

### AWS CloudTrail

- API call audit log.
- **Management events** (control plane) on by default.
- **Data events** (S3 object reads/writes, Lambda invokes, KMS Decrypt, DynamoDB item reads) - opt-in, per-resource.
- **CloudTrail Lake** - SQL on event history.

### AWS Config

- Resource configuration history + compliance rules.
- **Conformance packs** - pre-built rule sets for HIPAA, PCI-DSS, NIST, FedRAMP, etc.
- **Remediation actions** can auto-fix non-compliant resources.

### Amazon GuardDuty

- ML-based threat detection on CloudTrail, VPC Flow Logs, DNS, S3, EKS audit logs, RDS login events.

### AWS Audit Manager

- Pre-built control frameworks (SOC 2, PCI, HIPAA) with automated evidence collection.

### Audit exam triggers

- "Who queried this Athena table?" → CloudTrail data events on Lake Formation + Athena query log
- "Detect S3 bucket made public" → Config rule or Macie policy finding
- "Compliance evidence for SOC 2" → AWS Audit Manager + Config conformance pack
- "Suspicious behavior on Aurora cluster" → GuardDuty RDS Protection

---

## Secrets and credentials management

- **AWS Secrets Manager** - rotate secrets (DB credentials, API keys). Native rotation Lambdas for RDS / Redshift / DocumentDB.
- **AWS Systems Manager Parameter Store** - simpler config + secret store. Free tier (Standard) up to 10K parameters. Advanced for larger / more parameters.
- Glue and Lambda can fetch secrets via service integrations.

### Patterns

- Glue ETL connecting to RDS → Secrets Manager secret with rotation enabled.
- Step Functions referring to KMS-encrypted parameters via Parameter Store.

---

## Putting it all together: secure lake reference architecture

```
S3 (encrypted SSE-KMS, CMK)
  └─ Bucket policy: deny non-TLS, deny non-VPC-endpoint, only via VPC endpoint
  └─ Object Lock for retention (compliance)

Glue Data Catalog (encrypted)
  └─ Lake Formation permissions on top
      └─ LF-Tags for confidentiality + region
      └─ Row-level filters per analyst persona

Pipelines
  └─ Glue jobs / EMR clusters in private subnets
      └─ Gateway endpoints: S3, DynamoDB
      └─ Interface endpoints: KMS, Glue, CloudWatch, STS
      └─ Secrets Manager for DB creds (rotated)

Audit
  └─ CloudTrail (all events incl data events on sensitive tables)
  └─ Config conformance pack for compliance baseline
  └─ Macie scheduled discovery
  └─ GuardDuty for threats
```

This stack is the canonical answer for "design a secure data lake on AWS."
