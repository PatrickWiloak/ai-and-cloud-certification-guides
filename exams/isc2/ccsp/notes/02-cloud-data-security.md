# 02 - Cloud Data Security (Domain 2, 20%)

## Domain Overview

Domain 2 is the largest CCSP domain at 20%. It covers the entire data lifecycle in cloud environments: storage, classification, encryption, key management, retention, deletion, and the unique challenges of protecting data when you do not own the underlying infrastructure.

## Cloud Data Lifecycle

A central CCSP concept. Six phases (often called the "Securosis" or CSA data lifecycle):

1. **Create** - Data generated or modified
2. **Store** - Saved to persistent storage
3. **Use** - Loaded into memory and processed
4. **Share** - Made accessible to others
5. **Archive** - Long-term storage with reduced access
6. **Destroy** - Permanently removed

Each phase has different threats, controls, and audit considerations:

| Phase | Threats | Controls |
|-------|---------|----------|
| Create | Wrong classification, no labeling | Auto-classification, DLP at creation, labeling |
| Store | Unauthorized access, theft | Encryption at rest, ACLs, KMS |
| Use | Memory scraping, side-channel | Process isolation, confidential computing, runtime protection |
| Share | Wrong recipient, broad sharing | DLP, IRM, sharing policies, watermarking |
| Archive | Forgotten access controls, key loss | Archive-tier ACLs, key escrow, integrity verification |
| Destroy | Incomplete deletion, recoverability | Cryptographic erasure, verified deletion, attestation |

## Cloud Data Storage Architectures

### IaaS Storage Types
- **Volume / Block storage** - Network-attached block devices presented as disks
  - Examples: AWS EBS, Azure Managed Disks, GCP Persistent Disk
  - Use: Boot volumes, databases, file systems
  - Encryption: Often default; customer-managed keys available
- **Object storage** - Flat namespace, HTTP API, scalable to petabytes
  - Examples: AWS S3, Azure Blob Storage, GCP Cloud Storage
  - Use: Backups, media, data lake, static web content
  - Features: Versioning, lifecycle, replication, immutability (Object Lock)
- **File storage / NAS** - Shared file system over NFS/SMB
  - Examples: AWS EFS/FSx, Azure Files, GCP Filestore
  - Use: Shared application data, lift-and-shift workloads
- **Ephemeral / instance store** - Local disk on the host
  - Lost on stop/terminate
  - Use: Caches, scratch space

### PaaS Storage Types
- **Managed databases** - Relational (RDS, SQL Database, Cloud SQL) and NoSQL (DynamoDB, Cosmos DB, Firestore)
- **Caching** - Redis, Memcached as managed services
- **Message queues** - SQS, Service Bus, Pub/Sub
- **Streaming** - Kinesis, Event Hubs, Pub/Sub Lite
- **Data warehouse** - Redshift, Synapse, BigQuery
- **Search** - Elasticsearch/OpenSearch as managed services

### SaaS Storage
- Application-defined; customer accesses via app interface only
- Examples: M365 documents in OneDrive/SharePoint, Salesforce records, Workday data

### Volumes and Long-Term Storage Tiers
Most cloud storage tiers data:
- Hot / standard - frequent access, higher cost
- Cool / infrequent access - lower cost, retrieval fee
- Cold / archive - lowest cost, hours-to-restore latency
- Lifecycle policies automate tier transitions

## Data Discovery and Classification

### Discovery
Identifying where data lives. In cloud:
- Native tools: AWS Macie, Azure Purview/Defender for Storage, GCP DLP API
- Third-party: Wiz, Prisma Cloud, Big ID, Varonis
- Manual inventory and surveys

### Classification
Apply sensitivity labels:
- Automated (regex, ML classifiers, sensitive info types)
- Manual (user labeling, document metadata)
- Inheritance (folder/site/library defaults)

### Common classification schemes
| Government | Commercial |
|-----------|-----------|
| Top Secret | Highly Confidential / Restricted |
| Secret | Confidential |
| Confidential | Internal Use |
| Unclassified | Public |

## Information Rights Management (IRM) / Digital Rights Management (DRM)

Persistent encryption with policy enforcement that travels with the file:
- Read-only, no copy, no print, no screenshot
- Time-bounded access (expiration)
- Revocation after distribution

Examples: Microsoft Purview Information Protection (sensitivity labels), Adobe Experience Manager, Vera/Helpsystems, Egnyte.

Cloud considerations:
- Integration with cloud storage (M365, Google, Box)
- Federated identity for offline access
- Audit log of access attempts

## Data Protection Technologies

### Encryption
- At rest: storage encryption, TDE for databases, disk-level FDE
- In transit: TLS, mTLS, IPsec
- In use: confidential computing, secure enclaves, homomorphic encryption (emerging)

### Tokenization
- Replace sensitive value with non-sensitive token
- Token vault maps tokens to original values
- Common for PCI DSS scope reduction (token instead of PAN)
- Format-preserving tokenization possible

### Masking
- Visual obfuscation of data (XXX-XX-1234 for SSN)
- Static (data-at-rest replacement) or dynamic (at query time)
- Not a replacement for encryption when data must be cryptographically protected

### Anonymization
- Irreversible removal of identifiers
- Truly anonymized data is no longer personal data under most regulations
- Technical: k-anonymity, l-diversity, differential privacy

### Pseudonymization
- Replace identifiers with pseudonyms; re-linking possible with key
- GDPR-recognized as a privacy-enhancing technique
- Examples: hashed user IDs (with salt and key)

### Hashing
- One-way; integrity verification
- For passwords: use slow, salted hashes (bcrypt, Argon2)
- Not for encryption

## Cloud Encryption Approaches

| Approach | Key in | Customer Control |
|----------|--------|------------------|
| Provider-managed (default) | Provider KMS | Low |
| BYOK (customer-managed in provider KMS) | Provider KMS, customer-controlled | Medium |
| Customer-supplied per request (CSE-C / SSE-C) | Provider doesn't store; per-request | High |
| HYOK / external KMS | External KMS | Highest |
| Client-side encryption | Customer-controlled, before upload | Highest |
| Confidential computing | TEE | Highest (in-use too) |

### Key Management Services (KMS)
- Hierarchical: master keys (CMK / CEK) wrap data keys (DEK)
- Envelope encryption pattern
- Audit logs for every key operation
- Policy controls who can use vs administer keys
- Automatic rotation (annual default in major providers)

### Hardware Security Modules (HSM)
- FIPS 140-2/3 Level 3 (or higher) certified hardware
- Tamper-resistant, attack-detecting
- Cloud HSM offerings (AWS CloudHSM, Azure Dedicated HSM, GCP Cloud HSM)
- Single-tenant or shared-tenant
- Higher cost but stronger assurance

### Key Lifecycle
1. Key generation (use HW RNG)
2. Distribution / activation
3. Use
4. Rotation
5. Backup / escrow (for recoverability)
6. Revocation
7. Destruction (cryptographic erasure)

## Data Loss Prevention (DLP) in Cloud

### Types
- **Cloud DLP** - SaaS-native (M365 Purview, Google Cloud DLP, Macie)
- **CASB** - Cloud Access Security Broker; inline visibility
- **Network DLP** - Egress inspection (less effective with TLS everywhere)
- **Endpoint DLP** - Device-level inspection of cloud uploads

### DLP Capabilities
- Sensitive data discovery (PII, PHI, PCI patterns)
- Policy enforcement (block, alert, encrypt, redact)
- User education prompts ("This message contains a credit card number; are you sure?")
- Adaptive enforcement (more aggressive for high-risk users)

### Cloud-Specific DLP Considerations
- API-based scanning of SaaS storage
- Tenant-level vs user-level policies
- Performance impact on real-time inspection
- False positive tuning critical

## Data Sovereignty and Residency

### Definitions
- **Data residency** - Where data is stored
- **Data sovereignty** - Whose laws govern the data (often based on residency, but can include where the company is based, where data subjects reside)

### Cloud regions and jurisdictions
- Customers select primary region
- Some services replicate cross-region by default (be aware!)
- Multi-region for resiliency may conflict with residency requirements
- Sovereign clouds: AWS GovCloud, Azure Government, GCP Sovereign Cloud, China-isolated regions, EU sovereign clouds

### Cross-border transfer (recap from Domain 6)
- GDPR adequacy decision
- Standard Contractual Clauses (SCCs)
- Binding Corporate Rules (BCRs)
- EU-US Data Privacy Framework
- Specific Article 49 derogations

## Data Retention, Deletion, and Archiving

### Retention
- Driven by legal, regulatory, contractual, and business need
- Should NOT exceed requirements (privacy + cost)
- Documented retention schedule per data type
- Legal hold suspends normal deletion

### Deletion in Cloud
Challenges:
- Replication and backups (data may exist in multiple locations)
- Snapshot retention
- Provider-side caches
- Object storage versioning

Verified deletion:
- Cryptographic erasure (destroy the key, data unreadable)
- Provider attestation of deletion
- Audit trail of deletion request and completion

### Archiving
- Long-term retention at lower cost
- Lifecycle policies move data to cold tiers
- Considerations:
  - Re-encryption with new keys before archive
  - Access logging for archived data
  - Periodic restore tests
  - Format obsolescence (planning for decades)

## Data Event Auditability, Traceability, Accountability

### What to log
- Object access (read, write, delete, list)
- Permission changes
- Encryption/decryption events
- Sharing actions
- Lifecycle/retention changes

### Cloud-native logging
- AWS CloudTrail (control plane), S3 access logs (data plane)
- Azure Activity Log + Diagnostic Logs per service
- GCP Cloud Audit Logs (Admin Activity, Data Access, System Event, Policy Denied)

### Log immutability
- Object Lock or equivalent (S3 Object Lock, Azure Blob immutability, GCP Bucket Lock)
- Separate account for log destination (cross-account log delivery)
- Restricted access (write-only ingestion)

### Time synchronization
- Provider-managed NTP
- Critical for cross-source correlation in incident investigation

## Backup and Recovery for Cloud Data

### Cloud-native backup
- AWS Backup, Azure Backup, GCP Backup and DR
- Cross-region replication
- Immutable backup tier
- Point-in-time recovery for managed databases

### Best practices
- 3-2-1 rule: 3 copies, 2 media types, 1 off-site (different account or region)
- Immutable backups with WORM/Object Lock
- Periodic restore tests (untested backup is not a backup)
- Encryption with customer-managed keys
- Separate identity scope (backup destination not in production identity blast radius)
- Backup of cloud configuration (IaC, KMS keys, identity policies)

## Database Security in Cloud

### Concepts (from Domain 8 of CISSP, applicable here too)
- **Aggregation** - combining low-sens to derive high-sens
- **Inference** - deducing sensitive value from non-sens clues
- **Polyinstantiation** - different "truths" at different classification levels
- **Views** - restrict columns/rows visible
- **Stored procedures** - encapsulate logic with limited direct access

### Cloud database threats
- SQL injection (still #1)
- Misconfigured public access (publicly exposed databases)
- Weak authentication (default passwords, no MFA)
- Excessive privileges (DBA roles for app accounts)
- Backup theft (unencrypted exports)

### Cloud database controls
- Private endpoints (VPC endpoints, Private Link)
- Identity-aware access (IAM database authentication)
- Encryption at rest with CMKs
- Encryption in transit (TLS required)
- Database activity monitoring
- Always-on auditing
- Vulnerability scanning (Defender for SQL, etc.)

## Common Exam Pitfalls

- Confusing data residency (where) with data sovereignty (whose laws)
- Choosing provider-managed encryption when customer needs maximum control
- Forgetting cryptographic erasure as a deletion option
- Selecting masking when encryption is required
- Not knowing the data lifecycle phases
- Treating snapshot as a backup substitute (snapshots can be deleted by attackers)
- Forgetting that SaaS customers still own data classification responsibility

## Quick Reference: Encryption Decision

| Need | Approach |
|------|----------|
| Default encryption | Provider-managed |
| Control key rotation, revocation | BYOK (customer-managed in provider KMS) |
| Provider must not access plaintext | HYOK / external KMS |
| Encrypt before upload (zero trust) | Client-side encryption |
| Compute on encrypted data | Confidential computing or homomorphic |
| Reduce PCI scope | Tokenization |
| Audit-friendly visibility for users | Masking |
| GDPR-friendly retention with re-link | Pseudonymization |
| Truly anonymous analytics | Anonymization (k-anonymity, differential privacy) |
