# Database Security - AWS Database Specialty

## Overview

Database security covers 18% of the DBS-C01 exam. This domain focuses on encryption, authentication, network security, and audit logging for AWS database services.

## Encryption at Rest

**[📖 RDS Encryption](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html)** - Database encryption

### RDS and Aurora Encryption

- AES-256 encryption using AWS KMS
- Encrypts: Storage, automated backups, snapshots, read replicas, logs
- Must be enabled at creation time - cannot encrypt an existing unencrypted instance
- **Workaround**: Take snapshot - copy snapshot with encryption - restore from encrypted snapshot
- Read replicas must use same KMS key as primary (same region) or different key (cross-region)
- Performance impact: Minimal (< 5%)

### Transparent Data Encryption (TDE)

- **Oracle TDE**: Encrypts data at tablespace level, managed by Oracle
- **SQL Server TDE**: Encrypts database files at rest
- TDE is engine-native encryption, separate from RDS encryption
- Can use TDE and RDS encryption together (double encryption)
- TDE keys managed via option groups

### DynamoDB Encryption

**[📖 DynamoDB Encryption](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html)** - Table encryption

- All tables encrypted at rest by default (cannot disable)
- Three key options:
  - **AWS owned key**: Default, no cost, no CloudTrail visibility
  - **AWS managed key** (`aws/dynamodb`): CloudTrail visible, no extra cost
  - **Customer managed key**: Full control, rotation, key policies, extra cost
- Client-side encryption: DynamoDB Encryption Client for end-to-end encryption

### ElastiCache Encryption

- **At-rest encryption**: AES-256, must be enabled at cluster creation
- **In-transit encryption**: TLS for connections between nodes and clients
- Redis AUTH: Password-based authentication
- Redis RBAC: Role-based access control with users and ACLs

## Encryption in Transit

### SSL/TLS Connections

| Service | How to Enable | Enforcement |
|---------|---------------|-------------|
| RDS MySQL | `--ssl-mode=REQUIRED` on client | `require_secure_transport` parameter |
| RDS PostgreSQL | `sslmode=require` on client | `rds.force_ssl=1` parameter |
| Aurora MySQL | Same as RDS MySQL | Same as RDS MySQL |
| Aurora PostgreSQL | Same as RDS PostgreSQL | Same as RDS PostgreSQL |
| RDS Oracle | Oracle Native Network Encryption (NNE) | SQLNET.ENCRYPTION_SERVER=REQUIRED |
| RDS SQL Server | Force encryption | `rds.force_ssl=1` |
| DynamoDB | HTTPS by default | Always encrypted in transit |
| ElastiCache Redis | In-transit encryption option | Enable at cluster creation |

**[📖 Using SSL with RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)** - SSL configuration

### Certificate Management

- AWS provides SSL certificates for RDS instances
- Certificates rotate periodically - update client trust stores
- Download RDS root certificate bundle from AWS
- `rds-ca-2019` and newer certificate authorities

## IAM Database Authentication

**[📖 IAM DB Authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html)** - Token-based auth

### How It Works

1. Create database user mapped to IAM: `CREATE USER 'iam_user' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS'`
2. IAM policy grants `rds-db:connect` with resource ARN
3. Application calls `generate-db-auth-token` (valid for 15 minutes)
4. Connect using token as password over SSL

### Supported Engines

- MySQL (RDS and Aurora)
- PostgreSQL (RDS and Aurora)
- Not supported: Oracle, SQL Server, MariaDB (RDS only supports MySQL/PostgreSQL for IAM auth)

### Benefits and Limitations

**Benefits:**
- No password management - tokens are temporary
- Centralized access control via IAM
- CloudTrail audit of authentication
- Works with IAM roles (EC2 instance profiles, Lambda execution roles)

**Limitations:**
- Max 256 new connections per second per instance with IAM auth
- Cannot use with RDS custom endpoints
- SSL/TLS required
- Token valid for 15 minutes only

### RDS Proxy and IAM Auth

- RDS Proxy supports IAM authentication from client to proxy
- Proxy handles connection pooling to database
- Reduces connection overhead for Lambda functions
- Supports Secrets Manager for proxy-to-database authentication

## VPC Security

**[📖 RDS in VPC](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.html)** - Network isolation

### DB Subnet Groups

- Collection of subnets (at least 2 AZs) for RDS instances
- Private subnets recommended for database instances
- DB instance placed in one subnet, standby in another AZ subnet

### Security Groups

- Control inbound and outbound traffic to DB instances
- Allow only specific application security groups or CIDR ranges
- Best practice: Reference application security group as source (not IP)
- Separate security groups for different database tiers

### Public Accessibility

- `PubliclyAccessible = No` (recommended): No public IP, accessible only within VPC
- `PubliclyAccessible = Yes`: Assigns public IP, controlled by security groups
- Production databases should never be publicly accessible

### VPC Endpoints

- Interface endpoint for RDS API calls (management, not data)
- DynamoDB: Gateway endpoint for data plane access
- ElastiCache: Must be in same VPC as application (no cross-VPC without VPC peering)

## Secrets Management

**[📖 Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)** - Credential management

### RDS Integration

- Store database credentials in Secrets Manager
- Automatic rotation with Lambda functions
- Built-in rotation templates for RDS engines
- Multi-user rotation: Alternate between two users for zero-downtime rotation
- Single-user rotation: Simpler but brief connection disruption during rotation

### Best Practices

- Never hardcode credentials in application code
- Use Secrets Manager references in CloudFormation
- Enable automatic rotation (30, 60, or 90 day intervals)
- Use VPC endpoint for Secrets Manager to keep traffic private
- Grant least-privilege IAM access to secrets

## Audit Logging

### RDS Audit Logging

**MySQL/Aurora MySQL:**
- General log: All SQL statements (performance impact)
- Slow query log: Queries exceeding threshold
- Audit log: Advanced Auditing (Aurora), MariaDB Audit Plugin (RDS)
- Error log: Startup, shutdown, and error information
- Publish all logs to CloudWatch Logs

**PostgreSQL/Aurora PostgreSQL:**
- `pgAudit` extension: Detailed audit logging
- `log_statement`: Controls which statements are logged
- `log_connections` / `log_disconnections`: Track sessions
- Publish to CloudWatch Logs

**[📖 Publishing Logs to CloudWatch](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html)** - Log integration

### DynamoDB Audit

- CloudTrail logs all DynamoDB API calls (control plane and data plane)
- Data plane logging includes GetItem, PutItem, Query, Scan
- Enable data plane events in CloudTrail (higher volume)

### CloudTrail Integration

- All database management API calls logged by default
- RDS: CreateDBInstance, ModifyDBInstance, DeleteDBInstance
- DynamoDB: CreateTable, UpdateTable, PutItem (if data events enabled)
- KMS: Decrypt, GenerateDataKey (tracks encryption key usage)

## Database Activity Streams

**[📖 Database Activity Streams](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html)** - Compliance monitoring

- Real-time stream of database activity for Aurora
- Pushed to Kinesis Data Stream
- Encryped with KMS - even DBAs cannot tamper with the stream
- **Asynchronous mode**: Minimal performance impact, possible data loss
- **Synchronous mode**: Guaranteed delivery, slight performance impact
- Supported: Aurora MySQL, Aurora PostgreSQL

### Use Cases

- Compliance and regulatory audit requirements
- Security monitoring and alerting
- Separation of duties (DBA cannot modify audit records)
- Integration with third-party compliance tools

## Common Exam Patterns

1. **"Encrypt existing unencrypted database"** - Snapshot, copy with encryption, restore
2. **"Temporary credentials for database"** - IAM database authentication
3. **"Lambda connection pooling"** - RDS Proxy
4. **"Rotate database credentials"** - Secrets Manager with automatic rotation
5. **"Audit database activity tamper-proof"** - Database Activity Streams
6. **"Enforce SSL connections"** - rds.force_ssl or require_secure_transport parameter
7. **"Database not accessible from internet"** - PubliclyAccessible = No, private subnets
8. **"DynamoDB encryption audit trail"** - Customer managed KMS key (not AWS owned)
