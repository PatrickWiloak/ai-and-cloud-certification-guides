# Domain 4: Data Security and Governance (18%)

## Overview
This domain covers implementing authentication and authorization for data services, configuring data encryption, managing data governance and compliance, and implementing fine-grained access control. While it is the smallest domain at 18%, security questions appear throughout all domains.

## Key AWS Services for Data Security

### AWS Lake Formation

**[📖 AWS Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)** - Build, secure, and manage data lakes

#### Core Concepts
- **Data Lake Administrator**: Manages Lake Formation settings and permissions
- **Data Catalog**: Central metadata repository (shared with Glue)
- **Permissions**: Fine-grained access control at table, column, and row level
- **LF-Tags**: Tag-based access control for scalable permissions
- **Data Filters**: Row and column-level security definitions
- **Governed Tables**: ACID transaction support for data lakes

**[📖 Lake Formation Concepts](https://docs.aws.amazon.com/lake-formation/latest/dg/how-it-works.html)** - Architecture and key concepts

#### Permission Model

##### Table-Level Permissions
```json
{
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::123456789012:role/DataAnalystRole"
    },
    "Resource": {
        "Table": {
            "DatabaseName": "analytics_db",
            "Name": "customer_orders"
        }
    },
    "Permissions": ["SELECT"],
    "PermissionsWithGrantOption": []
}
```

##### Column-Level Permissions
```json
{
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::123456789012:role/DataAnalystRole"
    },
    "Resource": {
        "TableWithColumns": {
            "DatabaseName": "analytics_db",
            "Name": "customer_orders",
            "ColumnNames": ["order_id", "product", "amount", "order_date"]
        }
    },
    "Permissions": ["SELECT"],
    "PermissionsWithGrantOption": []
}
```

**[📖 Lake Formation Permissions](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)** - Grant and revoke data permissions

##### Row-Level Security with Data Filters
```json
{
    "TableCatalogId": "123456789012",
    "DatabaseName": "analytics_db",
    "TableName": "customer_orders",
    "Name": "us_only_filter",
    "RowFilter": {
        "FilterExpression": "region = 'US'"
    },
    "ColumnWildcard": {}
}
```

**[📖 Lake Formation Data Filters](https://docs.aws.amazon.com/lake-formation/latest/dg/data-filters-about.html)** - Row and column-level security

#### LF-Tags (Tag-Based Access Control)

**[📖 Lake Formation Tag-Based Access Control](https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html)** - Scalable attribute-based permissions

```bash
# Create LF-Tag
aws lakeformation create-lf-tag \
    --tag-key "sensitivity" \
    --tag-values '["public", "internal", "confidential", "restricted"]'

# Assign LF-Tag to table
aws lakeformation add-lf-tags-to-resource \
    --resource '{"Table":{"DatabaseName":"analytics_db","Name":"customer_orders"}}' \
    --lf-tags '[{"TagKey":"sensitivity","TagValues":["confidential"]}]'

# Grant permissions based on LF-Tag
aws lakeformation grant-permissions \
    --principal '{"DataLakePrincipalIdentifier":"arn:aws:iam::123456789012:role/DataAnalystRole"}' \
    --resource '{"LFTagPolicy":{"ResourceType":"TABLE","Expression":[{"TagKey":"sensitivity","TagValues":["public","internal"]}]}}' \
    --permissions '["SELECT"]'
```

#### Cross-Account Data Sharing

**[📖 Lake Formation Cross-Account](https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account.html)** - Share data across AWS accounts

- **Named Resource Method**: Grant permissions to specific external accounts
- **LF-Tag Method**: Share based on tag policies across accounts
- **AWS RAM Integration**: Use AWS Resource Access Manager for sharing
- **Central Governance**: Maintain permissions from producer account

```bash
# Grant cross-account access
aws lakeformation grant-permissions \
    --principal '{"DataLakePrincipalIdentifier":"123456789012"}' \
    --resource '{"Table":{"DatabaseName":"shared_db","Name":"shared_table"}}' \
    --permissions '["SELECT","DESCRIBE"]'
```

#### Lake Formation vs IAM S3 Policies

| Feature | Lake Formation | IAM S3 Policies |
|---------|---------------|-----------------|
| **Granularity** | Table, column, row | Bucket, prefix, object |
| **Management** | Centralized | Distributed |
| **Column Security** | Built-in | Not available |
| **Row Security** | Data filters | Not available |
| **Tag-Based** | LF-Tags | IAM tags (limited) |
| **Cross-Account** | Built-in | Bucket policies |
| **Audit** | CloudTrail integration | CloudTrail + S3 access logs |

### AWS KMS - Encryption for Data Services

**[📖 AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Create and manage encryption keys

#### Encryption at Rest by Service

| Service | Encryption | Key Options | Default |
|---------|-----------|-------------|---------|
| **S3** | SSE-S3, SSE-KMS, SSE-C | AWS managed, customer managed | SSE-S3 |
| **Redshift** | AES-256 | AWS managed, customer managed | AWS managed |
| **DynamoDB** | AES-256 | AWS owned, AWS managed, customer managed | AWS owned |
| **Glue Data Catalog** | AES-256 | AWS managed, customer managed | Optional |
| **Kinesis Data Streams** | AES-256 | AWS managed, customer managed | Optional |
| **EMR** | EBS encryption, EMRFS encryption | AWS managed, customer managed | Optional |
| **Athena** | Query result encryption | SSE-S3, SSE-KMS, CSE-KMS | Optional |
| **RDS/Aurora** | AES-256 | AWS managed, customer managed | Optional |

**[📖 S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)** - Server-side encryption options
**[📖 Redshift Encryption](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html)** - Database encryption configuration

#### S3 Encryption Types

##### Server-Side Encryption (SSE)
```bash
# SSE-S3 (Amazon managed keys)
aws s3 cp file.parquet s3://data-lake/data/ --sse AES256

# SSE-KMS (KMS managed keys)
aws s3 cp file.parquet s3://data-lake/data/ --sse aws:kms --sse-kms-key-id arn:aws:kms:...

# SSE-C (Customer-provided keys)
aws s3 cp file.parquet s3://data-lake/data/ --sse-c --sse-c-key fileb://key.bin
```

##### S3 Bucket Default Encryption
```json
{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "aws:kms",
                "KMSMasterKeyID": "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
            },
            "BucketKeyEnabled": true
        }
    ]
}
```

**[📖 S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html)** - Reduce KMS costs with S3 Bucket Keys

#### Envelope Encryption Pattern
```
1. KMS generates data key (plaintext + encrypted)
2. Use plaintext data key to encrypt data
3. Store encrypted data + encrypted data key
4. Discard plaintext data key from memory
5. To decrypt: KMS decrypts data key, then decrypt data
```

**[📖 Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping)** - Encrypt large datasets efficiently

#### KMS Key Policies for Data Services
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGlueToUseKey",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::123456789012:role/GlueETLRole"
            },
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowRedshiftToUseKey",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::123456789012:role/RedshiftRole"
            },
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "*"
        }
    ]
}
```

**[📖 KMS Key Policies](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)** - Control access to encryption keys

### AWS IAM for Data Services

**[📖 IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)** - Identity and access management

#### IAM Roles for Data Services

| Service | IAM Role Purpose |
|---------|-----------------|
| **Glue** | Access S3, Data Catalog, JDBC sources |
| **EMR** | EC2 instance profile, service role |
| **Redshift** | COPY/UNLOAD from S3, Spectrum access |
| **Lambda** | Execution role for data processing |
| **Kinesis** | Cross-account access, enhanced fan-out |
| **Step Functions** | Invoke Glue, Lambda, Redshift actions |
| **MWAA** | Execution role for Airflow operators |
| **Athena** | Query execution and results storage |

**[📖 IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)** - Role-based access for AWS services

#### Glue IAM Policy Example
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "glue:*",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::data-lake-*",
                "arn:aws:s3:::data-lake-*/*",
                "arn:aws:glue:*:*:catalog",
                "arn:aws:glue:*:*:database/*",
                "arn:aws:glue:*:*:table/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "arn:aws:kms:us-east-1:123456789012:key/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:/aws-glue/*"
        }
    ]
}
```

**[📖 IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Policy syntax and best practices
**[📖 IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Security guidelines

#### VPC Endpoints for Private Data Access
- **S3 Gateway Endpoint**: Private access to S3 without internet
- **Glue Interface Endpoint**: Private access to Glue APIs
- **KMS Interface Endpoint**: Private access to KMS
- **Kinesis Interface Endpoint**: Private stream access
- **Redshift VPC**: Cluster runs within VPC

**[📖 VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)** - Private connectivity to AWS services

### Amazon Macie - Sensitive Data Discovery

**[📖 Amazon Macie User Guide](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)** - Automated sensitive data discovery

#### Capabilities
- **Automated discovery**: Scan S3 buckets for sensitive data
- **Data classification**: PII, PHI, financial data, credentials
- **Managed data identifiers**: Pre-built patterns for common sensitive data
- **Custom data identifiers**: Regex-based custom patterns
- **Findings**: Severity-rated findings with remediation guidance
- **S3 bucket inventory**: Security posture assessment

**[📖 Macie Findings](https://docs.aws.amazon.com/macie/latest/user/findings.html)** - Understand and manage findings

#### Macie Integration with Data Pipelines
```
S3 Data Lake → Macie Discovery Job → Findings → EventBridge → SNS/Lambda
                                                             → Security Hub
                                                             → Automated Remediation
```

```bash
# Create Macie classification job
aws macie2 create-classification-job \
    --job-type ONE_TIME \
    --name "scan-data-lake" \
    --s3-job-definition '{
        "bucketDefinitions": [{
            "accountId": "123456789012",
            "buckets": ["data-lake-raw", "data-lake-processed"]
        }]
    }'
```

**[📖 Macie Classification Jobs](https://docs.aws.amazon.com/macie/latest/user/discovery-jobs.html)** - Configure sensitive data scanning

### AWS CloudTrail - Audit and Compliance

**[📖 AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)** - API activity logging for governance

#### CloudTrail for Data Services
- **Management Events**: API calls to create, modify, delete resources
- **Data Events**: S3 object operations, Lambda invocations, DynamoDB operations
- **Insights Events**: Unusual API activity detection
- **CloudTrail Lake**: SQL-based query and analysis of events

**[📖 CloudTrail Data Events](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html)** - Log data-level operations

#### CloudTrail Lake
```sql
-- Query CloudTrail Lake for S3 data access
SELECT
    userIdentity.arn,
    eventName,
    requestParameters,
    eventTime
FROM cloudtrail_events
WHERE eventSource = 's3.amazonaws.com'
    AND eventName IN ('GetObject', 'PutObject', 'DeleteObject')
    AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC
LIMIT 100;
```

**[📖 CloudTrail Lake](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake.html)** - Query and analyze CloudTrail events

### Encryption in Transit

#### TLS/SSL Configuration
- **S3**: HTTPS enforcement via bucket policy
- **Redshift**: SSL connections enforced via parameter group
- **RDS/Aurora**: SSL/TLS connections
- **Kinesis**: HTTPS API endpoints
- **EMR**: In-transit encryption for HDFS and Spark shuffle

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EnforceHTTPS",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::data-lake",
                "arn:aws:s3:::data-lake/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
```

**[📖 S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)** - Comprehensive security guidelines

## Data Governance Patterns

### Data Classification Framework
```
Level 1: Public          → No restrictions, open datasets
Level 2: Internal        → Organization-wide access
Level 3: Confidential    → Team-specific access, encryption required
Level 4: Restricted      → Individual access, full audit trail
```

### Governance Architecture
```
                    ┌─────────────────┐
                    │  Lake Formation │ ← Centralized Permissions
                    │   (Governance)  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
        ┌─────┴─────┐ ┌─────┴─────┐ ┌─────┴─────┐
        │   Athena   │ │  Redshift │ │    EMR    │
        │  (Query)   │ │ (Spectrum)│ │  (Spark)  │
        └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
              │              │              │
              └──────────────┼──────────────┘
                             │
                    ┌────────┴────────┐
                    │   Glue Data     │ ← Metadata Catalog
                    │    Catalog      │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │    Amazon S3    │ ← Data Lake Storage
                    │  (Encrypted)   │
                    └─────────────────┘
```

### Compliance Considerations
- **Data retention**: S3 lifecycle policies and Glacier vault lock
- **Data residency**: Region-specific data storage
- **Access logging**: CloudTrail + S3 access logs
- **Encryption requirements**: KMS for regulated data
- **PII handling**: Macie for discovery, Lake Formation for access control

**[📖 AWS Compliance](https://aws.amazon.com/compliance/)** - AWS compliance programs and certifications
**[📖 S3 Object Lock](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html)** - WORM compliance for data retention

## Security Best Practices for Data Engineers

### Data at Rest
1. Enable default encryption on all S3 buckets (SSE-KMS recommended)
2. Use customer-managed KMS keys for sensitive data
3. Enable S3 Bucket Keys to reduce KMS costs
4. Encrypt Redshift clusters, DynamoDB tables, and EBS volumes
5. Encrypt Glue Data Catalog metadata

### Data in Transit
1. Enforce HTTPS on S3 bucket policies
2. Enable SSL for Redshift and RDS connections
3. Use VPC endpoints for private access to AWS services
4. Enable in-transit encryption for EMR clusters

### Access Control
1. Use Lake Formation for centralized data lake permissions
2. Implement least privilege with IAM policies
3. Use LF-Tags for scalable permission management
4. Implement column-level security for sensitive columns
5. Use row-level security for multi-tenant data

### Auditing and Monitoring
1. Enable CloudTrail for all API activity
2. Enable S3 data events for object-level logging
3. Use Macie for continuous sensitive data discovery
4. Monitor with CloudWatch alarms for security events
5. Integrate with AWS Security Hub for centralized findings

## Common Exam Scenarios

1. **"Restrict column access in data lake"** - Lake Formation column-level permissions
2. **"Encrypt data at rest in S3"** - SSE-KMS with customer-managed keys
3. **"Discover PII in S3 buckets"** - Amazon Macie classification jobs
4. **"Audit data access"** - CloudTrail data events + CloudTrail Lake
5. **"Share data across accounts"** - Lake Formation cross-account with LF-Tags
6. **"Enforce HTTPS on S3"** - Bucket policy with aws:SecureTransport condition
7. **"Fine-grained access control"** - Lake Formation data filters (row + column)
8. **"Manage encryption keys"** - KMS customer-managed keys with key rotation

## Study Tips

1. **Lake Formation mastery**: Understand permissions model, LF-Tags, data filters
2. **Encryption options**: Know SSE-S3 vs SSE-KMS vs SSE-C differences
3. **IAM for data services**: Service roles for Glue, EMR, Redshift, Lambda
4. **Macie capabilities**: Sensitive data discovery and classification
5. **CloudTrail**: Management events vs data events vs insights
6. **VPC security**: Endpoints, security groups, network ACLs

## CLI Quick Reference

```bash
# Lake Formation
aws lakeformation grant-permissions --principal '{"DataLakePrincipalIdentifier":"arn:aws:iam::123456789012:role/AnalystRole"}' --resource '{"Table":{"DatabaseName":"db","Name":"table"}}' --permissions '["SELECT"]'
aws lakeformation create-lf-tag --tag-key "classification" --tag-values '["public","confidential"]'
aws lakeformation get-data-lake-settings

# KMS
aws kms create-key --description "Data lake encryption key"
aws kms create-alias --alias-name alias/data-lake-key --target-key-id key-id
aws kms enable-key-rotation --key-id key-id

# Macie
aws macie2 enable-macie
aws macie2 create-classification-job --job-type ONE_TIME --name "scan-job" --s3-job-definition '...'
aws macie2 list-findings

# CloudTrail
aws cloudtrail create-trail --name data-audit-trail --s3-bucket-name audit-logs
aws cloudtrail put-event-selectors --trail-name data-audit-trail --event-selectors '[{"ReadWriteType":"All","IncludeManagementEvents":true,"DataResources":[{"Type":"AWS::S3::Object","Values":["arn:aws:s3:::data-lake/"]}]}]'

# IAM
aws iam create-role --role-name GlueETLRole --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name GlueETLRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
```
