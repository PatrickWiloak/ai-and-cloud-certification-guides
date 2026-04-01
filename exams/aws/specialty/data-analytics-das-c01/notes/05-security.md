# Security - AWS Data Analytics Specialty

## Overview

Security covers 18% of the DAS-C01 exam. This domain focuses on encryption, access control, network security, and data governance across AWS analytics services.

## Encryption at Rest

**[📖 AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key Management Service

### KMS Key Types

- **AWS managed keys** (`aws/service`): Automatic rotation every year, no management needed
- **Customer managed keys (CMK)**: Full control, configurable rotation, key policies
- **AWS owned keys**: Used internally by services, not visible in your account

### Service-Specific Encryption

| Service | Encryption at Rest | Key Types | Notes |
|---------|-------------------|-----------|-------|
| S3 | SSE-S3, SSE-KMS, SSE-C, CSE | All | Bucket default encryption policy |
| Redshift | AES-256 | AWS managed, CMK | Cluster-level, cannot change after creation |
| DynamoDB | AES-256 | AWS owned, AWS managed, CMK | Table-level setting |
| EMR | LUKS for EBS, SSE for EMRFS | CMK | Security configuration |
| Kinesis Data Streams | Server-side | CMK | Stream-level setting |
| OpenSearch | AES-256 | AWS managed, CMK | Domain-level setting |
| Glue Data Catalog | AES-256 | AWS managed, CMK | Catalog-level setting |
| Athena | SSE-S3, SSE-KMS, CSE-KMS | All | Query results encryption |

**[📖 S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)** - S3 server-side encryption
**[📖 Redshift Encryption](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html)** - Cluster encryption

### S3 Encryption Details

- **SSE-S3**: Amazon manages keys, AES-256, simplest option
- **SSE-KMS**: KMS managed keys, audit trail via CloudTrail, key policies
- **SSE-C**: Customer provides encryption key per request
- **CSE (Client-Side)**: Encrypt before upload, you manage keys entirely
- Bucket policies can enforce encryption: `"s3:x-amz-server-side-encryption"` condition
- S3 Bucket Keys: Reduce KMS API calls and cost for SSE-KMS

## Encryption in Transit

- **TLS/SSL**: All AWS API calls use HTTPS by default
- **Redshift**: Force SSL with `require_ssl` parameter, certificate-based
- **EMR**: In-transit encryption for EMRFS (S3), TLS for node-to-node
- **Kinesis**: HTTPS endpoints for producers and consumers
- **OpenSearch**: Node-to-node encryption, HTTPS for domain endpoints
- **RDS/Aurora**: SSL/TLS connections, enforce with `rds.force_ssl` parameter

**[📖 EMR Encryption](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-data-encryption-options.html)** - EMR encryption options

## Lake Formation Security

**[📖 Lake Formation Security](https://docs.aws.amazon.com/lake-formation/latest/dg/security-overview.html)** - Data lake access control

### Permission Model

- Centralizes access control for data lake resources
- Replaces complex S3 bucket policies and IAM policies
- Coarse-grained: Database and table level
- Fine-grained: Column-level, row-level, cell-level security

### Key Concepts

- **Data Lake Administrator**: Full permissions, can grant to others
- **Database Creator**: Can create tables in databases they own
- **Table permissions**: SELECT, INSERT, DELETE, DESCRIBE, ALTER, DROP
- **Data filters**: Named combinations of row and column restrictions
- **LF-Tags**: Tag-based access control - assign tags to resources, grant based on tags
- **Cross-account**: Share via LF-Tags or named resource grants

### Lake Formation vs IAM for Data Lake

| Feature | IAM Policies | Lake Formation |
|---------|-------------|----------------|
| Granularity | Bucket/prefix level | Column/row/cell level |
| Management | Per-resource policies | Centralized catalog |
| Cross-account | Complex IAM roles | Built-in sharing |
| Audit | CloudTrail | CloudTrail + LF audit logs |
| Scale | Hard to manage at scale | Tag-based scales well |

**Exam Tip:** When a question asks about fine-grained data lake permissions, the answer is Lake Formation, not IAM.

## VPC Security for Analytics

**[📖 VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)** - Virtual Private Cloud

### VPC Endpoints

- **Gateway endpoints**: S3, DynamoDB - free, route table entry
- **Interface endpoints (PrivateLink)**: Kinesis, Glue, KMS, STS, etc. - ENI in subnet
- Keep analytics traffic within AWS network (no internet traversal)
- VPC endpoint policies restrict which resources can be accessed

### Service-Specific VPC Configuration

- **Redshift**: Deploy in VPC, use security groups, Enhanced VPC Routing forces COPY/UNLOAD through VPC
- **EMR**: Launch in VPC subnet, security groups for master/core/task
- **Glue**: VPC connection for JDBC sources, ENI in your subnet
- **OpenSearch**: VPC deployment (recommended) or public endpoint
- **Athena**: VPC endpoint for API access, data in S3 accessed via gateway endpoint

**[📖 Redshift Enhanced VPC Routing](https://docs.aws.amazon.com/redshift/latest/mgmt/enhanced-vpc-routing.html)** - Force traffic through VPC

### Network Access Control

- **Security groups**: Stateful, instance-level firewall
- **NACLs**: Stateless, subnet-level firewall
- **S3 bucket policies**: Restrict access by VPC endpoint or source IP
- **VPC endpoint policies**: Restrict which S3 buckets or services are accessible

## IAM Policies for Analytics

**[📖 IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)** - Identity and access management

### Common Policy Patterns

**S3 Data Access:**
```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject"],
  "Resource": "arn:aws:s3:::analytics-bucket/department-a/*",
  "Condition": {
    "StringEquals": {"s3:ExistingObjectTag/classification": "public"}
  }
}
```

**Redshift Spectrum / Athena:**
- Need: `s3:GetObject` on data, `glue:GetTable/GetDatabase` on catalog
- Athena also needs `s3:PutObject` for query results bucket
- Redshift Spectrum uses IAM role attached to cluster

**EMR:**
- EC2 instance profile for cluster nodes
- Service role for EMR service actions
- EMRFS role mapping: Different IAM roles per user/group for S3 access

**Kinesis:**
- Producer: `kinesis:PutRecord`, `kinesis:PutRecords`
- Consumer: `kinesis:GetRecords`, `kinesis:GetShardIterator`, `kinesis:DescribeStream`
- Enhanced fan-out: `kinesis:SubscribeToShard`

### Service-Linked Roles

- Automatically created roles for service operations
- Cannot modify permissions - defined by the service
- Examples: `AWSServiceRoleForRedshift`, `AWSServiceRoleForAmazonElasticMapReduce`

## Data Governance and Compliance

### CloudTrail for Analytics Audit

- Logs all API calls across analytics services
- KMS key usage tracking (who decrypted what)
- S3 data access events (data event logging)
- Lake Formation permission changes

### Macie for Data Discovery

**[📖 Amazon Macie](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)** - Sensitive data discovery

- ML-powered sensitive data discovery in S3
- Identifies PII, financial data, credentials
- Automated scanning with findings in Security Hub
- Use before analytics to classify data sensitivity

### Data Retention and Compliance

- S3 Object Lock: WORM (Write Once Read Many) compliance
- S3 Glacier Vault Lock: Immutable vault policies
- Redshift: Automated snapshots with configurable retention
- CloudWatch Logs: Configurable retention periods
- Kinesis: Configurable retention (24h to 365 days)

## Common Exam Patterns

1. **"Encrypt data lake at rest"** - SSE-KMS with customer managed key
2. **"Fine-grained data lake access"** - Lake Formation (column/row level)
3. **"Keep Redshift traffic private"** - Enhanced VPC Routing
4. **"Audit who accessed data"** - CloudTrail data events + KMS audit
5. **"Cross-account data sharing"** - Lake Formation LF-Tags
6. **"Sensitive data discovery in S3"** - Amazon Macie
7. **"Enforce encryption on S3 uploads"** - Bucket policy with encryption condition
8. **"Different S3 access per EMR user"** - EMRFS IAM role mapping
