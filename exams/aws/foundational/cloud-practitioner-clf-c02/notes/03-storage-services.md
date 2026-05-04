# AWS Storage Services

## Amazon S3 (Simple Storage Service)

### Overview
Amazon S3 is object storage built to store and retrieve any amount of data from anywhere on the web. It's designed for 99.999999999% (11 9's) durability.

### Key Features
- **Object Storage**: Store data as objects within buckets
- **Scalability**: Virtually unlimited storage capacity
- **Durability**: 99.999999999% (11 9's) durability
- **Availability**: Designed for 99.99% availability
- **Security**: Encryption, access control, versioning

### Core Concepts

#### Buckets
- **Definition**: Containers for storing objects
- **Global Namespace**: Bucket names must be globally unique
- **Regional**: Buckets are created in specific AWS Regions
- **Naming**: Must be DNS-compliant (lowercase, no spaces)

#### Objects
- **Components**: Key (name), value (data), metadata, version ID
- **Size**: From 0 bytes to 5 TB
- **Key**: Unique identifier within a bucket
- **Metadata**: Key-value pairs describing the object

### Storage Classes

#### S3 Standard
- **Use Case**: Frequently accessed data
- **Performance**: Low latency, high throughput
- **Durability**: 11 9's durability
- **Availability**: 99.99% availability
- **Cost**: Higher storage cost, no retrieval fees

#### S3 Intelligent-Tiering
- **Use Case**: Unknown or changing access patterns
- **Automatic**: Moves data between access tiers
- **Cost Optimization**: Optimizes storage costs automatically
- **Tiers**: Frequent, Infrequent, Archive, Deep Archive
- **Monitoring**: Small monthly monitoring fee

#### S3 Standard-IA (Infrequent Access)
- **Use Case**: Long-lived, infrequently accessed data
- **Cost**: Lower storage cost than Standard
- **Retrieval**: Per-GB retrieval fee
- **Minimum**: 30-day minimum storage duration
- **Use Cases**: Backups, disaster recovery, long-term storage

#### S3 One Zone-IA
- **Use Case**: Infrequently accessed, recreatable data
- **Storage**: Single Availability Zone (lower cost)
- **Durability**: 99.999999999% within the AZ
- **Availability**: 99.5% availability
- **Cost**: 20% less than Standard-IA

#### S3 Glacier Instant Retrieval
- **Use Case**: Archive data requiring instant access
- **Retrieval**: Millisecond retrieval
- **Cost**: Lower storage cost than Standard-IA
- **Minimum**: 90-day minimum storage duration
- **Use Cases**: Medical images, news media assets

#### S3 Glacier Flexible Retrieval (Formerly Glacier)
- **Use Case**: Archive data not requiring instant access
- **Retrieval Options**:
  - Expedited: 1-5 minutes
  - Standard: 3-5 hours
  - Bulk: 5-12 hours
- **Cost**: Very low storage cost
- **Minimum**: 90-day minimum storage duration

#### S3 Glacier Deep Archive
- **Use Case**: Long-term archive, rarely accessed
- **Retrieval**: 12-48 hours
- **Cost**: Lowest storage cost
- **Minimum**: 180-day minimum storage duration
- **Use Cases**: Compliance archives, digital preservation

### Advanced Features

#### Versioning
- **Definition**: Keep multiple versions of an object
- **Benefits**: Protect against accidental deletion, retrieve previous versions
- **States**: Unversioned (default), Versioning-enabled, Versioning-suspended
- **Version ID**: Unique identifier for each version
- **Cost**: Charged for all versions stored

#### Lifecycle Policies
- **Definition**: Automate transitioning objects between storage classes
- **Actions**:
  - **Transition**: Move to another storage class
  - **Expiration**: Delete objects after specified time
- **Use Cases**: Cost optimization, compliance, data management
- **Rules**: Based on object age, prefixes, tags

#### Replication
- **Cross-Region Replication (CRR)**:
  - Replicate objects across AWS Regions
  - Compliance, lower latency, disaster recovery
  - Asynchronous replication

- **Same-Region Replication (SRR)**:
  - Replicate within same Region
  - Log aggregation, production/test account replication
  - Compliance requirements

#### Server-Side Encryption
- **SSE-S3**: Managed by AWS, AES-256 encryption
- **SSE-KMS**: AWS Key Management Service keys
- **SSE-C**: Customer-provided encryption keys
- **Client-Side Encryption**: Encrypt before uploading

### Access Management

#### Bucket Policies
- **Definition**: JSON-based access policies
- **Resource-based**: Attached to buckets
- **Cross-Account**: Grant access to other accounts
- **Public Access**: Control public accessibility

#### Access Control Lists (ACLs)
- **Legacy**: Older access control mechanism
- **Granular**: Control at bucket and object level
- **Permissions**: Read, Write, Read ACL, Write ACL
- **Best Practice**: Use bucket policies and IAM instead

#### Presigned URLs
- **Definition**: Temporary URLs for object access
- **Use Case**: Grant temporary access without AWS credentials
- **Expiration**: Time-limited access
- **Security**: Secure sharing of private objects

### Data Transfer and Migration

#### Transfer Acceleration
- **Definition**: Fast, secure transfer over AWS edge locations
- **Use Case**: Long-distance transfers
- **Performance**: Uses CloudFront edge network
- **Cost**: Additional fee for acceleration

#### Multipart Upload
- **Definition**: Upload large objects in parts
- **Benefits**: Improved throughput, quick recovery from failures
- **Recommended**: Objects over 100 MB
- **Required**: Objects over 5 GB

#### S3 Select
- **Definition**: Retrieve subset of data using SQL
- **Benefits**: Reduce data transfer, improve performance
- **Use Case**: Query JSON, CSV, Parquet files
- **Cost**: Pay for data scanned and returned

### Use Cases
- **Backup and Archive**: Durable, scalable backup storage
- **Data Lakes**: Central repository for analytics
- **Static Website Hosting**: Host static websites
- **Content Distribution**: Origin for CloudFront CDN
- **Application Data**: Storage for application files
- **Disaster Recovery**: Off-site backup and recovery

### Best Practices
- Enable versioning for critical data
- Use lifecycle policies for cost optimization
- Implement least privilege access
- Enable encryption at rest
- Monitor with CloudWatch and CloudTrail
- Use appropriate storage class for access patterns

## Amazon EBS (Elastic Block Store)

### Overview
Amazon EBS provides persistent block storage volumes for use with EC2 instances. EBS volumes behave like raw, unformatted block devices that can be mounted as devices on EC2 instances.

### Key Characteristics
- **Persistent**: Data persists independently from EC2 instance
- **Network-Attached**: Connected via network, not physically attached
- **Availability Zone**: Volumes exist in specific AZ
- **Snapshots**: Point-in-time backups to S3
- **Encryption**: At-rest and in-transit encryption available

### Volume Types

#### General Purpose SSD (gp3, gp2)
- **Use Case**: General purpose workloads
- **Performance**: Baseline 3,000 IOPS (gp3), 3 IOPS/GB (gp2)
- **Size**: 1 GB to 16 TB
- **Cost**: Cost-effective for most workloads
- **Throughput**: 125-1000 MB/s (gp3)

#### Provisioned IOPS SSD (io2, io1)
- **Use Case**: I/O-intensive workloads, databases
- **Performance**: Up to 64,000 IOPS (io2 Block Express: 256,000)
- **Size**: 4 GB to 16 TB (io2 BE: 64 TB)
- **Durability**: 99.999% (io2), 99.8-99.9% (io1)
- **Use Cases**: Critical databases, high-performance applications

#### Throughput Optimized HDD (st1)
- **Use Case**: Big data, data warehouses, log processing
- **Performance**: Up to 500 IOPS
- **Throughput**: Up to 500 MB/s
- **Size**: 125 GB to 16 TB
- **Cost**: Lower cost than SSD
- **Cannot**: Be boot volume

#### Cold HDD (sc1)
- **Use Case**: Infrequently accessed data
- **Performance**: Up to 250 IOPS
- **Throughput**: Up to 250 MB/s
- **Size**: 125 GB to 16 TB
- **Cost**: Lowest cost HDD option
- **Cannot**: Be boot volume

### Key Features

#### Snapshots
- **Definition**: Point-in-time backups stored in S3
- **Incremental**: Only changed blocks saved after first snapshot
- **Cross-Region**: Copy snapshots to other Regions
- **AMI Creation**: Create AMIs from snapshots
- **Encryption**: Encrypted snapshots from encrypted volumes

#### Encryption
- **At-Rest**: AES-256 encryption
- **In-Transit**: Encryption between instance and volume
- **Keys**: AWS managed or customer managed (KMS)
- **Snapshots**: Automatically encrypted
- **Performance**: Minimal impact on performance

#### Multi-Attach (io1/io2 only)
- **Definition**: Attach volume to multiple EC2 instances
- **Availability**: Same Availability Zone only
- **Use Case**: Clustered applications
- **Instances**: Up to 16 Nitro-based instances
- **File System**: Requires cluster-aware file system

### Best Practices
- Take regular snapshots for backup
- Use appropriate volume type for workload
- Enable encryption for sensitive data
- Monitor performance with CloudWatch
- Use EBS-optimized instances
- Delete unused volumes and snapshots

## Amazon EFS (Elastic File System)

### Overview
Amazon EFS provides scalable, elastic file storage for use with AWS Cloud services and on-premises resources. It's a fully managed NFS (Network File System) that can be used with EC2 instances.

### Key Features
- **Fully Managed**: No infrastructure to manage
- **Scalable**: Automatically grows and shrinks
- **Concurrent Access**: Multiple EC2 instances simultaneously
- **Regional**: Accessible across multiple AZs
- **POSIX-compliant**: Standard file system interface

### Storage Classes

#### EFS Standard
- **Use Case**: Frequently accessed files
- **Performance**: Low-latency file operations
- **Availability**: Multi-AZ storage
- **Cost**: Higher storage cost
- **Access**: Instant access to files

#### EFS Infrequent Access (IA)
- **Use Case**: Files not accessed regularly
- **Cost**: Lower storage cost
- **Transition**: Automatic lifecycle management
- **Retrieval**: Per-GB retrieval fee
- **Savings**: Up to 92% cost reduction

### Performance Modes

#### General Purpose (Default)
- **Latency**: Lowest latency
- **Use Case**: Web serving, content management, home directories
- **IOPS**: Up to 7,000 file operations per second
- **Throughput**: Baseline throughput based on file system size

#### Max I/O
- **Latency**: Slightly higher latency
- **Use Case**: Big data, media processing, genomics
- **IOPS**: Higher aggregate throughput and IOPS
- **Scale**: Support hundreds/thousands of EC2 instances

### Throughput Modes

#### Bursting (Default)
- **Throughput**: Scales with file system size
- **Baseline**: 50 MB/s per TB stored
- **Burst**: Up to 100 MB/s
- **Use Case**: Variable workloads

#### Provisioned
- **Throughput**: Set throughput independent of size
- **Configuration**: Specify required throughput
- **Use Case**: Known, consistent throughput requirements
- **Cost**: Pay for provisioned throughput

#### Elastic (Recommended)
- **Throughput**: Automatically scales up/down
- **Performance**: Up to 3 GB/s reads, 1 GB/s writes
- **Billing**: Pay only for throughput used
- **Use Case**: Unpredictable workloads

### Use Cases
- **Web Serving**: Content management systems
- **Home Directories**: User home directories
- **Application Hosting**: Shared application files
- **Big Data Analytics**: Shared data for analytics
- **Container Storage**: Persistent storage for containers
- **Backup**: Shared backup location

### EFS vs EBS vs S3

| Feature | EFS | EBS | S3 |
|---------|-----|-----|-----|
| Storage Type | File | Block | Object |
| Access | Multiple instances | Single instance* | Internet/API |
| Scope | Regional | Availability Zone | Regional (global namespace) |
| Scalability | Automatic | Manual | Automatic |
| Use Case | Shared files | Instance storage | Static content, backup |

*Except io1/io2 Multi-Attach

## Amazon FSx

### Overview
AWS FSx provides fully managed third-party file systems optimized for various workloads.

### FSx for Windows File Server
- **Protocol**: SMB (Server Message Block)
- **Integration**: Active Directory integration
- **Features**: DFS, data deduplication, encryption
- **Use Cases**: Windows applications, SQL Server, SharePoint
- **Performance**: Up to 2 GB/s throughput, millions of IOPS

### FSx for Lustre
- **Use Case**: High-performance computing, machine learning
- **Performance**: Sub-millisecond latencies, 100s GB/s throughput
- **Integration**: S3 integration for data lakes
- **File System**: POSIX-compliant
- **Types**: Scratch (temporary), Persistent (long-term)

### FSx for NetApp ONTAP
- **Protocol**: NFS, SMB, iSCSI
- **Features**: Snapshots, replication, deduplication
- **Compatibility**: NetApp features on AWS
- **Use Cases**: Enterprise applications, databases

### FSx for OpenZFS
- **Use Case**: ZFS file system workloads
- **Performance**: Up to 1 million IOPS
- **Features**: Snapshots, compression, data cloning
- **Migration**: Move from on-premises ZFS

## AWS Storage Gateway

### Overview
AWS Storage Gateway is a hybrid cloud storage service that provides on-premises access to virtually unlimited cloud storage.

### Types

#### File Gateway
- **Protocol**: NFS, SMB
- **Use Case**: File shares backed by S3
- **Caching**: Local cache for frequently accessed files
- **Storage**: Objects stored in S3

#### Volume Gateway
- **Types**: Cached volumes, Stored volumes
- **Protocol**: iSCSI
- **Backup**: EBS snapshots in AWS
- **Use Case**: Block storage backup to cloud

#### Tape Gateway
- **Protocol**: iSCSI VTL (Virtual Tape Library)
- **Use Case**: Replace physical tape infrastructure
- **Storage**: Glacier and Glacier Deep Archive
- **Compatibility**: Existing backup applications

### Use Cases
- **Hybrid Cloud**: Bridge on-premises and cloud
- **Backup and Archive**: Cloud-based backup
- **Disaster Recovery**: Replicate data to AWS
- **Tiering**: Move cold data to cloud

## AWS DataSync

### Overview
AWS DataSync is an online data transfer service that simplifies, automates, and accelerates moving data between on-premises storage and AWS storage services.

### Key Features
- **Fast Transfer**: Up to 10x faster than open-source tools
- **Automated**: Schedule and automate data transfers
- **Secure**: Encryption in transit and at rest
- **Monitoring**: CloudWatch integration
- **Validation**: Data integrity verification

### Supported Destinations
- Amazon S3 (all storage classes)
- Amazon EFS
- Amazon FSx for Windows File Server
- Amazon FSx for Lustre
- Amazon FSx for NetApp ONTAP
- Amazon FSx for OpenZFS

### Use Cases
- **Data Migration**: Move large datasets to AWS
- **Data Replication**: Ongoing replication for DR
- **Data Archiving**: Move cold data to Glacier
- **Data Processing**: Transfer for analytics workloads

## AWS Backup

### Overview
AWS Backup is a fully managed backup service that centralizes and automates data protection across AWS services.

### Supported Services
- EC2, EBS, EFS, FSx
- RDS, Aurora, DynamoDB
- DocumentDB, Neptune
- Storage Gateway, S3

### Key Features
- **Centralized**: Single console for all backups
- **Automated**: Policy-based backup schedules
- **Cross-Region**: Copy backups across Regions
- **Cross-Account**: Backup across AWS accounts
- **Compliance**: Backup compliance monitoring

### Backup Plans
- **Schedule**: When to take backups
- **Retention**: How long to keep backups
- **Lifecycle**: Transition to cold storage
- **Tags**: Tag-based resource selection

## Key Takeaways

1. **S3**: Object storage, 11 9's durability, multiple storage classes for cost optimization
2. **EBS**: Block storage for EC2, persistent, AZ-specific, multiple volume types
3. **EFS**: Managed NFS file system, multi-AZ, elastic scaling, concurrent access
4. **FSx**: Managed third-party file systems (Windows, Lustre, NetApp, OpenZFS)
5. **Storage Gateway**: Hybrid cloud storage, bridge on-premises to AWS
6. **DataSync**: Fast, automated data transfer to AWS
7. **AWS Backup**: Centralized backup management across AWS services
8. **Choose Right Storage**: Based on access pattern, performance, durability, and cost requirements
