# Domain 4: Data Security and Governance (18%)

## Overview

Domain 4 covers implementing authentication and authorization for data services, configuring encryption at rest and in transit, managing data governance and compliance, and implementing fine-grained access control. While the smallest domain at 18%, security concepts appear throughout all exam domains.

This document covers Lake Formation permissions, column-level and row-level security, encryption with KMS, IAM policies for data services, Glue Data Catalog security, and data quality and validation.

---

## AWS Lake Formation Permissions

Lake Formation provides centralized, fine-grained access control for data lakes, replacing the need to manage complex combinations of S3 bucket policies and IAM policies.

**📖 [AWS Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**

### How Lake Formation Permissions Work

Lake Formation sits between analytics services (Athena, Redshift Spectrum, EMR, Glue) and the underlying data in S3:

```
┌─────────┐  ┌──────────┐  ┌─────────┐  ┌─────────┐
│ Athena  │  │ Redshift │  │  EMR    │  │  Glue   │
│         │  │ Spectrum │  │ (Spark) │  │  ETL    │
└────┬────┘  └────┬─────┘  └────┬────┘  └────┬────┘
     │            │             │             │
     └────────────┴──────┬──────┴─────────────┘
                         │
              ┌──────────▼──────────┐
              │   Lake Formation    │  <-- Permission checks
              │   (GRANT/REVOKE)    │
              └──────────┬──────────┘
                         │
              ┌──────────▼──────────┐
              │   Glue Data Catalog │  <-- Metadata
              └──────────┬──────────┘
                         │
              ┌──────────▼──────────┐
              │     Amazon S3       │  <-- Data storage
              │   (Encrypted)       │
              └─────────────────────┘
```

When a user runs an Athena query, Lake Formation checks whether the user's IAM role has been granted permission on the specific database, table, columns, and rows being accessed.

**📖 [Lake Formation Permissions Model](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)**

### Permission Types

| Permission | Applies To | Description |
|------------|-----------|-------------|
| **CREATE_DATABASE** | Catalog | Create new databases |
| **CREATE_TABLE** | Database | Create new tables in a database |
| **ALTER** | Database, Table | Modify properties |
| **DROP** | Database, Table | Delete resources |
| **SELECT** | Table, Columns | Read data (query access) |
| **INSERT** | Table | Write new data |
| **DELETE** | Table | Remove data |
| **DESCRIBE** | Database, Table | View metadata |
| **SUPER** | All | Full administrative access |

### Granting Table-Level Permissions

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
    "Permissions": ["SELECT", "DESCRIBE"],
    "PermissionsWithGrantOption": []
}
```

### Granting Column-Level Permissions

Restrict access to specific columns, hiding sensitive data from unauthorized users:

```json
{
    "Principal": {
        "DataLakePrincipalIdentifier": "arn:aws:iam::123456789012:role/LimitedAnalystRole"
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

In this example, the `LimitedAnalystRole` can query only the four listed columns. Columns like `customer_ssn`, `email`, or `address` are not accessible.

**📖 [Lake Formation Column-Level Security](https://docs.aws.amazon.com/lake-formation/latest/dg/lake-formation-permissions.html)**

### Lake Formation vs IAM S3 Policies

| Feature | Lake Formation | IAM + S3 Policies |
|---------|---------------|-------------------|
| **Granularity** | Table, column, row, cell-level | Bucket, prefix, object-level |
| **Management** | Centralized GRANT/REVOKE model | Distributed across multiple policies |
| **Column security** | Native support | Not possible with IAM/S3 alone |
| **Row security** | Data filters | Not possible with IAM/S3 alone |
| **Cross-account** | Built-in with RAM integration | Complex bucket policies + IAM roles |
| **Audit** | Integrated with CloudTrail | CloudTrail + S3 access logs |
| **Compatibility** | Works with Athena, Spectrum, EMR, Glue | Works with all S3 access methods |

**Exam tip**: Lake Formation is the recommended approach for data lake access control. However, you may need to transition from IAM/S3 policies to Lake Formation. During transition, both models coexist, and permissions from both are evaluated.

---

## Column-Level and Row-Level Security

### Column-Level Security

Column-level security restricts which columns a principal can access. This is critical for protecting PII (names, SSNs, emails) while allowing access to non-sensitive analytical columns.

**Implementation options**:

1. **Lake Formation column permissions**: Grant SELECT on specific columns only
2. **Redshift column-level GRANT**: Native SQL GRANT on specific columns
3. **Views**: Create views that expose only allowed columns

**Redshift column-level example**:
```sql
-- Grant access to specific columns only
GRANT SELECT (order_id, product_id, amount, order_date)
ON TABLE analytics.customer_orders
TO analyst_group;

-- Revoke access to sensitive columns
REVOKE SELECT (customer_ssn, customer_email)
ON TABLE analytics.customer_orders
FROM analyst_group;
```

### Row-Level Security

Row-level security restricts which rows a principal can access based on filter conditions. This is essential for multi-tenant data lakes where different teams should only see their own data.

**Implementation options**:

1. **Lake Formation data filters**: Named filters with row conditions and column lists
2. **Redshift RLS policies**: Native row-level security policies
3. **Views with WHERE clauses**: Simple but less flexible

### Lake Formation Data Filters

Data filters combine row-level and column-level security into named, reusable definitions:

```json
{
    "TableCatalogId": "123456789012",
    "DatabaseName": "analytics_db",
    "TableName": "sales_data",
    "Name": "us_region_limited_columns",
    "RowFilter": {
        "FilterExpression": "region = 'US'"
    },
    "ColumnNames": ["order_id", "amount", "product", "order_date", "region"]
}
```

After creating the filter, grant it to a principal:

```bash
aws lakeformation grant-permissions \
    --principal '{"DataLakePrincipalIdentifier":"arn:aws:iam::123456789012:role/USAnalystRole"}' \
    --resource '{"DataCellsFilter":{
        "DatabaseName":"analytics_db",
        "TableName":"sales_data",
        "Name":"us_region_limited_columns"
    }}' \
    --permissions '["SELECT"]'
```

The `USAnalystRole` can only see the five listed columns, and only for rows where `region = 'US'`.

**📖 [Lake Formation Data Filters](https://docs.aws.amazon.com/lake-formation/latest/dg/data-filters-about.html)**

### LF-Tags (Tag-Based Access Control)

LF-Tags provide scalable, attribute-based permissions that automatically apply to new resources when tagged:

#### Step 1: Define Tags
```bash
aws lakeformation create-lf-tag \
    --tag-key "sensitivity" \
    --tag-values '["public", "internal", "confidential", "restricted"]'

aws lakeformation create-lf-tag \
    --tag-key "department" \
    --tag-values '["finance", "marketing", "engineering", "hr"]'
```

#### Step 2: Assign Tags to Resources
```bash
# Tag a table
aws lakeformation add-lf-tags-to-resource \
    --resource '{"Table":{"DatabaseName":"hr_db","Name":"employee_salary"}}' \
    --lf-tags '[
        {"TagKey":"sensitivity","TagValues":["restricted"]},
        {"TagKey":"department","TagValues":["hr"]}
    ]'

# Tag specific columns
aws lakeformation add-lf-tags-to-resource \
    --resource '{"TableWithColumns":{
        "DatabaseName":"hr_db",
        "Name":"employee_salary",
        "ColumnNames":["ssn","salary"]
    }}' \
    --lf-tags '[{"TagKey":"sensitivity","TagValues":["restricted"]}]'
```

#### Step 3: Grant Permissions on Tags
```bash
aws lakeformation grant-permissions \
    --principal '{"DataLakePrincipalIdentifier":"arn:aws:iam::123456789012:role/HRAnalystRole"}' \
    --resource '{"LFTagPolicy":{
        "ResourceType":"TABLE",
        "Expression":[
            {"TagKey":"department","TagValues":["hr"]},
            {"TagKey":"sensitivity","TagValues":["internal","confidential"]}
        ]
    }}' \
    --permissions '["SELECT"]'
```

Now any current or future table tagged with `department=hr` AND `sensitivity=internal` or `sensitivity=confidential` is automatically accessible to `HRAnalystRole`. No individual grants needed per table.

**📖 [Lake Formation Tag-Based Access Control](https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html)**

### Cross-Account Data Sharing

Lake Formation supports sharing data across AWS accounts:

1. **Named Resource Method**: Grant permissions directly to an external account ID
2. **LF-Tag Method**: Share based on tag-based policies across accounts
3. **AWS RAM Integration**: Use Resource Access Manager to manage shares

```bash
# Grant cross-account access
aws lakeformation grant-permissions \
    --principal '{"DataLakePrincipalIdentifier":"987654321098"}' \
    --resource '{"Table":{"DatabaseName":"shared_db","Name":"shared_table"}}' \
    --permissions '["SELECT","DESCRIBE"]'
```

The consumer account creates a resource link in their Glue Data Catalog pointing to the shared database/table.

**📖 [Lake Formation Cross-Account Sharing](https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account.html)**

---

## Encryption (KMS, S3, Redshift)

### AWS KMS (Key Management Service)

KMS is the central encryption key management service used by all AWS data services.

**📖 [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)**

#### Key Types

| Key Type | Management | Rotation | Cost | Use Case |
|----------|-----------|----------|------|----------|
| **AWS Owned Keys** | AWS manages entirely | Automatic | Free | Default encryption (DynamoDB default) |
| **AWS Managed Keys** | AWS manages, you see in console | Automatic (yearly) | Per API call | S3 (aws/s3), Redshift (aws/redshift) |
| **Customer Managed Keys (CMK)** | You create, manage, control policies | Optional (configurable) | Monthly + per API call | Full control, audit, cross-account |

**Exam tip**: Use customer managed keys when you need key rotation control, cross-account access via key policies, or detailed CloudTrail audit of key usage.

#### Envelope Encryption

Envelope encryption is the pattern used by most AWS services to encrypt large datasets efficiently:

```
1. Application requests a data key from KMS
2. KMS returns:
   - Plaintext data key (used immediately to encrypt data)
   - Encrypted data key (stored alongside the encrypted data)
3. Application encrypts data with plaintext data key
4. Application discards plaintext data key from memory
5. Stores: encrypted data + encrypted data key

To decrypt:
1. Send encrypted data key to KMS
2. KMS decrypts it using the CMK, returns plaintext data key
3. Use plaintext data key to decrypt the data
```

This avoids sending large data volumes to KMS (which has a 4 KB limit per Encrypt/Decrypt call).

**📖 [Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping)**

### S3 Encryption Options

| Method | Key Management | Key Storage | Use Case |
|--------|---------------|-------------|----------|
| **SSE-S3** | AWS manages entirely | S3 internal | Default encryption, simplest setup |
| **SSE-KMS** | KMS manages (AWS or customer key) | KMS | Audit trail, key rotation, cross-account |
| **SSE-C** | Customer provides key per request | Customer | Full key control outside AWS |
| **Client-Side** | Client encrypts before upload | Customer | End-to-end encryption, AWS never sees plaintext |

**S3 Bucket Keys**: Reduce KMS API costs by caching a bucket-level data key. Instead of calling KMS for every object, S3 uses a bucket key to generate per-object keys locally. Can reduce KMS costs by up to 99%.

```json
{
    "Rules": [{
        "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "aws:kms",
            "KMSMasterKeyID": "arn:aws:kms:us-east-1:123456789012:key/key-id"
        },
        "BucketKeyEnabled": true
    }]
}
```

**📖 [S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)**
**📖 [S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html)**

### Redshift Encryption

| Encryption Type | Description |
|----------------|-------------|
| **At rest (KMS)** | AES-256 encryption of data blocks, system metadata, and backups. Uses KMS customer or AWS managed keys. |
| **At rest (HSM)** | Hardware Security Module for key management (on-premises HSM via CloudHSM) |
| **In transit** | SSL/TLS connections between clients and Redshift. Enforced via parameter group `require_ssl = true`. |
| **Cluster encryption** | Enabled at cluster creation (cannot be changed after). Encrypts all data, temp files, and snapshots. |

```sql
-- Force SSL connections to Redshift
-- Set in cluster parameter group:
-- require_ssl = true
```

**📖 [Redshift Encryption](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html)**

### Encryption Across All Data Services

| Service | Encryption at Rest | Encryption in Transit | Key Options |
|---------|-------------------|----------------------|-------------|
| **Amazon S3** | SSE-S3, SSE-KMS, SSE-C, client-side | HTTPS (enforce via bucket policy) | AWS managed, customer managed |
| **Amazon Redshift** | AES-256 (KMS or HSM) | SSL/TLS | AWS managed, customer managed |
| **Amazon DynamoDB** | AES-256 | HTTPS (always) | AWS owned, AWS managed, customer managed |
| **Amazon Athena** | Query results encryption | HTTPS | SSE-S3, SSE-KMS, CSE-KMS |
| **Amazon Kinesis** | Server-side encryption | TLS 1.2 | AWS managed, customer managed |
| **AWS Glue** | Data Catalog encryption, job bookmark encryption | HTTPS | AWS managed, customer managed |
| **Amazon EMR** | EBS encryption, EMRFS S3 encryption, local disk encryption | TLS for in-transit (HDFS, Spark shuffle) | AWS managed, customer managed |
| **Amazon RDS/Aurora** | AES-256 (storage, backups, snapshots, replicas) | SSL/TLS | AWS managed, customer managed |

**Exam tip**: Encryption at rest should be enabled for all data stores. For S3 data lakes, SSE-KMS with customer managed keys is the recommended approach for compliance workloads.

---

## IAM Policies for Data Access

### IAM Roles for Data Services

Each AWS data service requires specific IAM roles to function:

| Service | Role Type | What It Needs Access To |
|---------|-----------|------------------------|
| **AWS Glue** | Service role | S3 (read/write), Glue Data Catalog, KMS (decrypt/encrypt), CloudWatch Logs |
| **Amazon EMR** | EC2 instance profile + service role | S3, Glue Data Catalog, KMS, CloudWatch |
| **Amazon Redshift** | Cluster IAM role | S3 (COPY/UNLOAD), Glue Data Catalog (Spectrum), KMS |
| **AWS Lambda** | Execution role | S3, Kinesis, DynamoDB, SQS, CloudWatch Logs, KMS |
| **Step Functions** | Execution role | Glue, Lambda, Athena, Redshift Data API, S3, SNS, SQS |
| **Amazon MWAA** | Execution role | S3 (DAGs, logs), Glue, EMR, Athena, Redshift, KMS |
| **Amazon Athena** | (uses caller's role) | S3 (data + results), Glue Data Catalog, KMS |

### Glue IAM Policy Example

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GlueAndCatalogAccess",
            "Effect": "Allow",
            "Action": [
                "glue:GetDatabase", "glue:GetTable", "glue:GetPartitions",
                "glue:CreateTable", "glue:UpdateTable",
                "glue:BatchCreatePartition"
            ],
            "Resource": [
                "arn:aws:glue:us-east-1:123456789012:catalog",
                "arn:aws:glue:us-east-1:123456789012:database/analytics_db",
                "arn:aws:glue:us-east-1:123456789012:table/analytics_db/*"
            ]
        },
        {
            "Sid": "S3DataAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject", "s3:PutObject", "s3:DeleteObject",
                "s3:ListBucket", "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::data-lake-bucket",
                "arn:aws:s3:::data-lake-bucket/*"
            ]
        },
        {
            "Sid": "KMSAccess",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey"
            ],
            "Resource": "arn:aws:kms:us-east-1:123456789012:key/key-id"
        },
        {
            "Sid": "CloudWatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:/aws-glue/*"
        }
    ]
}
```

**📖 [IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)**
**📖 [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)**

### Resource-Based Policies

Some data services support resource-based policies in addition to identity-based IAM policies:

| Resource | Policy Type | Common Use |
|----------|------------|------------|
| **S3 Bucket** | Bucket policy | Cross-account access, enforce encryption, require HTTPS |
| **KMS Key** | Key policy | Grant specific roles access to encrypt/decrypt |
| **Lambda Function** | Function policy | Allow S3, Kinesis, or other services to invoke |
| **Glue Data Catalog** | Resource policy | Cross-account catalog access |
| **SQS Queue** | Queue policy | Allow services to send/receive messages |

### Enforcing HTTPS on S3

```json
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "DenyUnencryptedTransport",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::data-lake-bucket",
            "arn:aws:s3:::data-lake-bucket/*"
        ],
        "Condition": {
            "Bool": {"aws:SecureTransport": "false"}
        }
    }]
}
```

**📖 [S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)**

### VPC Endpoints for Private Data Access

VPC endpoints enable private connectivity to AWS services without traversing the public internet:

| Endpoint Type | Services | Cost |
|--------------|----------|------|
| **Gateway Endpoint** | S3, DynamoDB | Free |
| **Interface Endpoint** | Glue, KMS, Kinesis, Redshift, Athena, Step Functions, CloudWatch | Per hour + per GB |

**Exam tip**: Use gateway endpoints for S3 and DynamoDB (free). Use interface endpoints for other data services when security requirements prohibit internet access.

**📖 [VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)**

---

## AWS Glue Data Catalog Security

The Glue Data Catalog stores metadata about your data lake. Securing it is critical because catalog access determines what data users can discover and query.

**📖 [Glue Data Catalog Security](https://docs.aws.amazon.com/glue/latest/dg/glue-security.html)**

### Catalog Encryption

| Setting | Description |
|---------|-------------|
| **Metadata encryption** | Encrypt all objects in the Data Catalog with KMS |
| **Connection password encryption** | Encrypt passwords stored in JDBC connections |
| **Encryption settings** | Configured at the catalog level, applies to all databases/tables |

```bash
aws glue put-data-catalog-encryption-settings \
    --data-catalog-encryption-settings '{
        "EncryptionAtRest": {
            "CatalogEncryptionMode": "SSE-KMS",
            "SseAwsKmsKeyId": "arn:aws:kms:us-east-1:123456789012:key/key-id"
        },
        "ConnectionPasswordEncryption": {
            "ReturnConnectionPasswordEncrypted": true,
            "AwsKmsKeyId": "arn:aws:kms:us-east-1:123456789012:key/key-id"
        }
    }'
```

### Catalog Resource Policy

The Data Catalog resource policy controls cross-account access to the catalog:

```json
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::987654321098:root"
        },
        "Action": [
            "glue:GetDatabase", "glue:GetTable",
            "glue:GetPartitions", "glue:GetTableVersions"
        ],
        "Resource": [
            "arn:aws:glue:us-east-1:123456789012:catalog",
            "arn:aws:glue:us-east-1:123456789012:database/shared_db",
            "arn:aws:glue:us-east-1:123456789012:table/shared_db/*"
        ]
    }]
}
```

### Lake Formation Integration

When Lake Formation is enabled, it adds a permissions layer on top of the Data Catalog:
- Users need both IAM permissions AND Lake Formation grants to access data
- Lake Formation can override IAM-only access (hybrid mode vs Lake Formation-only mode)
- During migration, you can run both permission models simultaneously

**📖 [Lake Formation and IAM Integration](https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html)**

---

## Data Quality and Validation

Data quality is tested across multiple exam domains, particularly in the context of data pipelines and governance.

### AWS Glue Data Quality

Glue Data Quality lets you define, measure, and enforce quality rules using DQDL (Data Quality Definition Language).

**📖 [AWS Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)**

#### DQDL Rule Categories

| Category | Rule Examples | What It Checks |
|----------|--------------|----------------|
| **Completeness** | `IsComplete "column"`, `Completeness "col" > 0.95` | Missing values, null percentage |
| **Uniqueness** | `IsUnique "column"`, `Uniqueness "col" > 0.99` | Duplicate values |
| **Accuracy** | `ColumnValues "col" between 0 and 1000` | Value within expected range |
| **Consistency** | `ColumnValues "status" in ["A","B","C"]` | Values match expected set |
| **Freshness** | `DataFreshness "updated_at" <= 24 hours` | Data recency |
| **Volume** | `RowCount between 1000 and 1000000` | Expected row count range |
| **Schema** | `ColumnExists "column_name"` | Expected columns present |

#### DQDL Rule Examples

```
Rules = [
    -- Schema checks
    ColumnExists "user_id",
    ColumnExists "email",
    ColumnExists "created_at",

    -- Completeness checks
    IsComplete "user_id",
    Completeness "email" > 0.95,

    -- Uniqueness checks
    IsUnique "user_id",

    -- Value range checks
    ColumnValues "amount" > 0,
    ColumnValues "age" between 0 and 150,
    ColumnValues "status" in ["active", "inactive", "pending"],

    -- Freshness check
    DataFreshness "updated_at" <= 24 hours,

    -- Volume check
    RowCount between 10000 and 5000000
]
```

#### Data Quality in Pipelines

| Integration Point | How | Action on Failure |
|-------------------|-----|-------------------|
| **Glue ETL job** | Embed quality evaluation in ETL script | Fail job, quarantine bad records, or continue with warning |
| **Step Functions** | Run quality check as a Task state, branch on results | Route to error handling or retry |
| **MWAA** | Quality check as a DAG task with downstream dependencies | Block downstream tasks, send alerts |
| **CloudWatch** | Publish quality metrics to CloudWatch | Trigger alarms and notifications |

#### Data Quality Recommendations

Glue Data Quality can automatically suggest rules based on data profiling:
1. Run a profiling job on your dataset
2. Glue analyzes statistical properties of each column
3. Glue recommends DQDL rules (e.g., "Completeness > 0.98" based on observed completeness)
4. Review, customize, and save the recommended rules

**📖 [Glue Data Quality Recommendations](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)**

### Additional Data Validation Approaches

| Approach | Tool | Use Case |
|----------|------|----------|
| **SQL-based checks** | Athena or Redshift | Row counts, null checks, range validation after loading |
| **Lambda validation** | Lambda + S3 trigger | Validate file format and schema before processing |
| **Schema Registry** | Glue Schema Registry | Validate Avro/JSON schemas in streaming pipelines |
| **Great Expectations** | Open-source on EMR/MWAA | Comprehensive data validation framework |
| **DataBrew profiling** | Glue DataBrew | Visual data quality assessment and statistics |

---

## Auditing and Compliance

### AWS CloudTrail

CloudTrail logs API activity across all AWS services, providing an audit trail for data access and modifications.

**📖 [AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)**

#### Event Types

| Event Type | What It Logs | Examples |
|------------|-------------|---------|
| **Management Events** | Control plane API calls | CreateBucket, CreateTable, CreateCluster |
| **Data Events** | Data plane API calls | S3 GetObject/PutObject, Lambda Invoke, DynamoDB GetItem |
| **Insights Events** | Unusual API activity patterns | Spike in S3 deletions, unusual Glue API calls |

**Exam tip**: Management events are logged by default. Data events must be explicitly enabled and incur additional cost. Enable S3 data events for audit trails of who accessed what data.

**📖 [CloudTrail Data Events](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html)**

#### CloudTrail Lake

CloudTrail Lake enables SQL-based querying of audit events:

```sql
SELECT
    userIdentity.arn AS principal,
    eventName,
    requestParameters,
    eventTime
FROM cloudtrail_events
WHERE eventSource = 's3.amazonaws.com'
    AND eventName IN ('GetObject', 'PutObject', 'DeleteObject')
    AND eventTime > '2024-01-01'
ORDER BY eventTime DESC
LIMIT 100;
```

**📖 [CloudTrail Lake](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake.html)**

### Amazon Macie

Macie uses machine learning to automatically discover and classify sensitive data in S3:

- **Managed data identifiers**: Pre-built patterns for PII (SSN, credit cards, emails, addresses), PHI, financial data, and credentials
- **Custom data identifiers**: Regex-based patterns for organization-specific sensitive data
- **Classification jobs**: One-time or scheduled scans of S3 buckets
- **Findings**: Severity-rated results with remediation guidance
- **Integration**: Findings sent to EventBridge for automated remediation

```
S3 Data Lake --> Macie Discovery Job --> Findings --> EventBridge --> Lambda (remediate)
                                                                  --> SNS (alert team)
                                                                  --> Security Hub (centralize)
```

**📖 [Amazon Macie User Guide](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)**
**📖 [Macie Classification Jobs](https://docs.aws.amazon.com/macie/latest/user/discovery-jobs.html)**

---

## Security Best Practices Summary

### Data at Rest

1. Enable default encryption on all S3 buckets (SSE-KMS recommended for compliance)
2. Use customer managed KMS keys for sensitive data (audit trail, rotation control)
3. Enable S3 Bucket Keys to reduce KMS API costs
4. Encrypt Redshift clusters (enabled at creation, encrypts data + backups + snapshots)
5. Encrypt DynamoDB tables with customer managed keys for sensitive data
6. Encrypt Glue Data Catalog metadata and connection passwords

### Data in Transit

1. Enforce HTTPS on S3 bucket policies (`aws:SecureTransport` condition)
2. Enable SSL for Redshift connections (`require_ssl = true`)
3. Enable SSL/TLS for RDS/Aurora connections
4. Use VPC endpoints for private access (gateway for S3/DynamoDB, interface for others)
5. Enable in-transit encryption for EMR clusters (HDFS, Spark shuffle, Tez)

### Access Control

1. Use Lake Formation for centralized data lake permissions (prefer over S3/IAM policies)
2. Implement least privilege: grant minimum permissions needed
3. Use LF-Tags for scalable, automatic permission management
4. Implement column-level security for PII and sensitive columns
5. Use data filters for row-level security in multi-tenant environments
6. Use IAM roles (not users) for service-to-service access
7. Avoid long-lived access keys; use IAM roles with temporary credentials

### Auditing and Monitoring

1. Enable CloudTrail in all regions with S3 data events enabled
2. Use CloudTrail Lake for SQL-based audit queries
3. Run Macie classification jobs on S3 data lake buckets regularly
4. Set up CloudWatch alarms for security-relevant metrics
5. Integrate with AWS Security Hub for centralized security findings
6. Enable S3 access logging for detailed object-level access records

---

## Common Exam Scenarios

1. **"Restrict column access in data lake"** --> Lake Formation column-level permissions or TableWithColumns grant
2. **"Encrypt data at rest in S3 with audit trail"** --> SSE-KMS with customer managed key
3. **"Discover PII in S3 data lake"** --> Amazon Macie classification jobs
4. **"Audit who accessed what data in S3"** --> CloudTrail with S3 data events enabled
5. **"Share data lake across accounts with governance"** --> Lake Formation cross-account sharing with LF-Tags
6. **"Enforce HTTPS for all S3 access"** --> S3 bucket policy with `aws:SecureTransport` = false deny
7. **"Fine-grained row + column access control"** --> Lake Formation data filters
8. **"Manage encryption keys with rotation"** --> KMS customer managed keys with automatic rotation enabled
9. **"Scalable permissions for growing data lake"** --> LF-Tags (permissions apply automatically when resources are tagged)
10. **"Validate data quality before loading to warehouse"** --> Glue Data Quality DQDL rules in ETL pipeline
11. **"Private S3 access from VPC"** --> S3 gateway VPC endpoint (free)
12. **"Encrypt Redshift cluster and connections"** --> KMS encryption at rest + `require_ssl` for in transit
