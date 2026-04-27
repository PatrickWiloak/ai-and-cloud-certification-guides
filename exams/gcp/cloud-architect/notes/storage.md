# GCP Storage Fundamentals - Professional Cloud Architect

## Cloud Storage - Deep Dive

### What is Cloud Storage?
Google Cloud's object storage service for storing and retrieving any amount of data from anywhere. It's a RESTful online file storage service with unlimited capacity, designed for 11 nines (99.999999999%) durability.

### Core Concepts
- **Bucket**: Container for objects (globally unique name, immutable location)
- **Object**: Individual files stored in Cloud Storage (max 5 TB per object)
- **Project**: Billing and organization boundary
- **Location**: Geographic placement of your data (immutable after creation)
- **Storage Class**: Performance and cost optimization tier (can be changed)
- **Object Metadata**: Key-value pairs stored with objects
- **Namespace**: Global bucket namespace across all GCP

### Storage Classes - Comprehensive Comparison

| Storage Class | Use Case | Availability SLA | Minimum Storage Duration | Retrieval Cost | Monthly Storage Cost (per GB) | Early Deletion Fee |
|---------------|----------|------------------|-------------------------|----------------|-------------------------------|-------------------|
| **Standard** | Frequently accessed data | 99.95% (multi-region) 99.9% (region) | None | None | $0.020 (region) $0.026 (multi-region) | None |
| **Nearline** | Once per month access | 99.95% (multi-region) 99.9% (region) | 30 days | $0.01/GB | $0.010 (region) $0.013 (multi-region) | Yes (if <30 days) |
| **Coldline** | Once per quarter access | 99.95% (multi-region) 99.9% (region) | 90 days | $0.02/GB | $0.004 (region) $0.005 (multi-region) | Yes (if <90 days) |
| **Archive** | Long-term archival | 99.95% (multi-region) 99.9% (region) | 365 days | $0.05/GB | $0.0012 (region) $0.0015 (multi-region) | Yes (if <365 days) |

### Storage Class Selection Matrix

```
Decision Flow:
┌─────────────────────────────────────┐
│ How often do you access the data?   │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │  Daily/Weekly  │────→ STANDARD
       └────────────────┘
               │
       ┌───────┴────────┐
       │    Monthly     │────→ NEARLINE (30-day minimum)
       └────────────────┘
               │
       ┌───────┴────────┐
       │   Quarterly    │────→ COLDLINE (90-day minimum)
       └────────────────┘
               │
       ┌───────┴────────┐
       │ Yearly/Archive │────→ ARCHIVE (365-day minimum)
       └────────────────┘

Cost Break-Even Analysis:
- Standard vs Nearline: If accessed <1x/month → Nearline
- Nearline vs Coldline: If accessed <1x/quarter → Coldline
- Coldline vs Archive: If accessed <1x/year → Archive
```

### Storage Class Cost Analysis Example

**Scenario**: 100 TB of data stored for 1 year

| Storage Class | Storage Cost | Access (4x/year) | Total Annual Cost |
|---------------|--------------|------------------|-------------------|
| **Standard** | $24,000 | $0 | **$24,000** |
| **Nearline** | $12,000 | $4,000 | **$16,000** (33% savings) |
| **Coldline** | $4,800 | $8,000 | **$12,800** (47% savings) |
| **Archive** | $1,440 | $20,000 | **$21,440** (only if <4 accesses) |

**EXAM TIP**: Archive is only cost-effective if data is accessed less than once per year. For quarterly access, Coldline is more economical despite higher storage cost.

### Location Types - Detailed Analysis

| Type | Description | Examples | Availability SLA | Use Case | RPO | RTO |
|------|-------------|----------|-----------------|----------|-----|-----|
| **Multi-region** | Continent-wide (>= 100 miles apart) | us, eu, asia | 99.95% | Global apps, CDN content | 0 (sync replication) | Minutes |
| **Dual-region** | Two specific regions (>= 100 miles) | nam4 (Iowa + SC), eur4 (Netherlands + Finland) | 99.95% | DR with geo-redundancy | 0 (sync replication) | Minutes |
| **Region** | Single geographic location | us-central1, europe-west1, asia-southeast1 | 99.9% | Regional apps, compliance | N/A | N/A |

**Location Selection Architecture**:
```
┌──────────────────────────────────────────────────┐
│          Application Scope Decision              │
└────────────────┬─────────────────────────────────┘
                 │
        ┌────────┴─────────┐
        │    Multi-Region   │
        └────────┬──────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
┌───▼──────┐          ┌──────▼───┐
│  Global  │          │ Regional │
│  Users   │          │   Users  │
└───┬──────┘          └──────┬───┘
    │                        │
    │                        │
┌───▼──────────────┐  ┌─────▼────────────┐
│ Multi-Region:    │  │  Dual-Region:    │
│ - Max resilience │  │  - Balanced cost │
│ - Higher cost    │  │  - Specific DCs  │
│ - Auto-failover  │  │  - Compliance    │
└──────────────────┘  └──────────────────┘
                             │
                      ┌──────▼───────┐
                      │   Region:    │
                      │ - Lower cost │
                      │ - Single DC  │
                      │ - Low latency│
                      └──────────────┘
```

### Lifecycle Management - Advanced Configuration

#### Lifecycle Policy Actions

| Action | Description | Use Case | Works With |
|--------|-------------|----------|------------|
| **Delete** | Remove objects | Clean up old data | All storage classes |
| **SetStorageClass** | Transition to cheaper class | Cost optimization | Standard → Nearline → Coldline → Archive |
| **AbortIncompleteMultipartUpload** | Clean incomplete uploads | Cost control | All classes (after N days) |

#### Lifecycle Policy Conditions

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {
          "age": 30,
          "matchesPrefix": ["logs/"],
          "matchesSuffix": [".log"],
          "numNewerVersions": 3,
          "daysSinceCustomTime": 90,
          "daysSinceNoncurrentTime": 30,
          "createdBefore": "2024-01-01",
          "isLive": true
        }
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {
          "age": 90,
          "matchesPrefix": ["logs/"]
        }
      },
      {
        "action": {"type": "Delete"},
        "condition": {
          "age": 365,
          "matchesPrefix": ["temp/"]
        }
      },
      {
        "action": {"type": "Delete"},
        "condition": {
          "numNewerVersions": 5
        }
      }
    ]
  }
}
```

#### Common Lifecycle Patterns

**Pattern 1: Log Archival**
```
Day 0-30:   Standard (frequent analysis)
Day 31-90:  Nearline (occasional queries)
Day 91-365: Coldline (compliance review)
Day 366+:   Archive or Delete (retention policy)
```

**Pattern 2: Backup Strategy**
```
Day 0-7:    Standard (quick recovery)
Day 8-30:   Nearline (recent backup recovery)
Day 31-90:  Coldline (monthly recovery point)
Day 91-365: Archive (annual compliance)
Day 366+:   Delete (beyond retention)
```

**Pattern 3: Media Assets**
```
Recent:     Standard (active campaigns)
30+ days:   Nearline (reuse scenarios)
90+ days:   Coldline (archived campaigns)
365+ days:  Archive (legal hold)
```

**EXAM TIP**: Lifecycle policies execute ONCE per day. An object transitioned from Standard to Nearline will still incur the 30-day minimum storage charge, even if lifecycle policy deletes it after 35 days.

### Object Versioning

#### Versioning Mechanics
- **Enabled per bucket**: Cannot be enabled per object
- **Live version**: Current version of the object
- **Noncurrent versions**: Previous versions (archived)
- **Generation number**: Unique identifier for each version
- **Metageneration**: Metadata version counter

#### Versioning Use Cases

```
Scenario 1: Accidental Deletion Protection
┌──────────┐    ┌──────────┐    ┌──────────┐
│ Version  │    │ Version  │    │ Version  │
│    1     │───→│    2     │───→│    3     │
│ (stored) │    │ (stored) │    │  (live)  │
└──────────┘    └──────────┘    └──────────┘
     │               │               │
     │               │               │ DELETE
     │               │               ▼
     │               │          ┌──────────┐
     │               │          │ Delete   │
     │               │          │ Marker   │
     │               ▼          │  (live)  │
     │          Still Accessible└──────────┘
     ▼
Still Accessible
```

#### Versioning Cost Implications
- **Each version is billed separately**: 3 versions = 3x storage cost
- **Noncurrent versions can use lifecycle**: Transition to Nearline/Coldline
- **Delete markers are free**: But prevent data access

**Cost Optimization with Versioning**:
```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {
          "daysSinceNoncurrentTime": 30
        }
      },
      {
        "action": {"type": "Delete"},
        "condition": {
          "numNewerVersions": 10,
          "daysSinceNoncurrentTime": 90
        }
      }
    ]
  }
}
```

### Retention Policies and Object Holds

#### Retention Policy Types

| Feature | Retention Policy | Default Event-Based Hold | Event-Based Hold | Temp Hold |
|---------|------------------|--------------------------|------------------|-----------|
| **Scope** | Bucket-wide | Bucket-wide | Per-object | Per-object |
| **Duration** | Fixed time period | Until hold released | Until hold released | Until removed |
| **Locked** | Yes (after locking) | No | No | No |
| **Deletable** | No (during retention) | No | No | No |
| **Modifiable** | No (during retention) | No | No | No |
| **Use Case** | Compliance (WORM) | Regulatory compliance | Legal holds | Temporary prevention |

#### Retention Policy Example

```bash
# Set retention policy (90 days)
gsutil retention set 90d gs://my-compliance-bucket

# Lock retention policy (IRREVERSIBLE!)
gsutil retention lock gs://my-compliance-bucket

# View retention policy
gsutil retention get gs://my-compliance-bucket
```

**WORM (Write-Once-Read-Many) Compliance**:
```
┌─────────────────────────────────────┐
│     Retention Policy Lifecycle      │
└─────────────────────────────────────┘

Upload → Locked → Retention Period → Deletable
  │        │              │              │
  Day 0    Day 0      Day 1-90        Day 91+
  │        │              │              │
  OK to    Cannot         Cannot         Can delete
  modify   modify         delete         or modify
```

### Signed URLs and Access Control

#### Signed URL Mechanics

**Signed URL = URL + Signature (cryptographic)**
- **Use Case**: Temporary access without authentication
- **Expiration**: Time-limited access (seconds to weeks)
- **Permissions**: Read, write, delete, or resumable upload
- **Generation**: Using service account key or user credentials

#### Creating Signed URLs

```bash
# Generate signed URL (valid for 1 hour)
gsutil signurl -d 1h service-account-key.json gs://bucket/object.pdf

# Generate signed URL for upload
gsutil signurl -m PUT -d 10m -c application/pdf \
  service-account-key.json gs://bucket/upload.pdf

# Using gcloud (user credentials)
gcloud storage sign-url gs://bucket/object.jpg --duration=2h

# Generate with specific permissions
gsutil signurl -m GET -d 30m \
  -r us-central1 \
  service-account-key.json \
  gs://bucket/video.mp4
```

#### Signed URL Python Example

```python
from google.cloud import storage
from datetime import timedelta

def generate_signed_url(bucket_name, blob_name, expiration_minutes=60):
    """Generate a signed URL for accessing a GCS object."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)

    # Generate signed URL valid for specified duration
    url = blob.generate_signed_url(
        version="v4",
        expiration=timedelta(minutes=expiration_minutes),
        method="GET"
    )

    return url

# Upload signed URL
def generate_upload_signed_url(bucket_name, blob_name, content_type):
    """Generate a signed URL for uploading to GCS."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)

    url = blob.generate_signed_url(
        version="v4",
        expiration=timedelta(minutes=15),
        method="PUT",
        content_type=content_type
    )

    return url
```

#### Signed URL vs Signed Policy Document

| Feature | Signed URL | Signed Policy Document |
|---------|------------|------------------------|
| **Method** | Single operation | Form-based upload |
| **Complexity** | Simple | More complex |
| **Use Case** | Direct download/upload | Web form uploads |
| **File Size Limit** | 5 TB | 5 TB |
| **Upload Control** | Limited | Detailed (size, content-type) |

### Advanced Access Control

#### IAM Roles for Cloud Storage

| Role | Permissions | Use Case |
|------|-------------|----------|
| **roles/storage.objectViewer** | List and read objects | Read-only access |
| **roles/storage.objectCreator** | Create objects | Upload only (no read) |
| **roles/storage.objectAdmin** | Full object control | Object management |
| **roles/storage.admin** | Full bucket control | Bucket administration |
| **roles/storage.legacyBucketReader** | List objects (legacy ACL) | Migration scenarios |
| **roles/storage.legacyBucketWriter** | Create/overwrite objects | Upload access |

#### Uniform Bucket-Level Access vs Fine-Grained ACLs

```
┌────────────────────────────────────────────┐
│    Access Control Architecture Choice     │
└────────────────────────────────────────────┘

Uniform Bucket-Level Access (Recommended):
┌─────────────────────────────────────┐
│         Bucket (IAM Only)           │
│  ┌───────┐  ┌───────┐  ┌───────┐  │
│  │Object │  │Object │  │Object │  │
│  │   1   │  │   2   │  │   3   │  │
│  └───────┘  └───────┘  └───────┘  │
└─────────────────────────────────────┘
- Consistent IAM across all objects
- Easier management
- Required for org policies
- Cannot set per-object ACLs

Fine-Grained ACLs (Legacy):
┌─────────────────────────────────────┐
│         Bucket (IAM + ACL)          │
│  ┌───────┐  ┌───────┐  ┌───────┐  │
│  │Object │  │Object │  │Object │  │
│  │(ACL-1)│  │(ACL-2)│  │(ACL-3)│  │
│  └───────┘  └───────┘  └───────┘  │
└─────────────────────────────────────┘
- Per-object ACLs possible
- Complex to manage
- Legacy compatibility
- Mix of IAM and ACLs
```

**EXAM TIP**: Google recommends Uniform Bucket-Level Access for new buckets. It's required for organization policies and simplifies auditing.

## Persistent Disks (Block Storage) - Deep Dive

### What are Persistent Disks?
Network-attached block storage for Compute Engine instances. Durable, high-performance block storage that persists independently of VM instances. Automatically replicated within a zone or across zones (regional PD).

### Disk Types - Performance Characteristics

| Type | Max IOPS (Read/Write) | Max Throughput | Cost/GB/Month | Performance Scaling | Use Case |
|------|----------------------|----------------|---------------|---------------------|----------|
| **Standard (pd-standard)** | 7,500 / 15,000 | 1,200 MB/s (read) 400 MB/s (write) | $0.040 | With size | Cost-sensitive workloads |
| **Balanced (pd-balanced)** | 80,000 / 30,000 | 1,200 MB/s (read) 400 MB/s (write) | $0.100 | With size | Balanced price/performance |
| **SSD (pd-ssd)** | 100,000 / 30,000 | 1,200 MB/s (read) 400 MB/s (write) | $0.170 | With size | High-performance databases |
| **Extreme (pd-extreme)** | 120,000 / 120,000 | 2,400 MB/s (read) 1,200 MB/s (write) | $0.125 + IOPS cost | Provisioned | Ultra-high performance |

### Performance Scaling Details

**pd-standard, pd-balanced, pd-ssd**: Performance scales linearly with disk size
```
IOPS Calculation Example (pd-ssd):
┌──────────────────────────────────────┐
│   Disk Size → IOPS Relationship      │
└──────────────────────────────────────┘

100 GB  → 3,000 read IOPS (30 per GB)
500 GB  → 15,000 read IOPS
1 TB    → 30,000 read IOPS
3.34 TB → 100,000 read IOPS (maximum)

Write IOPS: 30 per GB up to 30,000 max
```

**pd-extreme**: Fixed provisioned IOPS (no scaling with size)
```
Size Range: 500 GB - 64 TB
IOPS Range: 10,000 - 120,000 (provisioned)
Throughput: Up to 2,400 MB/s read, 1,200 MB/s write

Cost = Capacity Cost + IOPS Cost
Example: 1 TB @ 50,000 IOPS
- Capacity: 1024 GB × $0.125 = $128/month
- IOPS: 50,000 × $0.00006 = $3/month
- Total: $131/month
```

### Disk Type Selection Matrix

```
Decision Tree:
┌─────────────────────────────────────┐
│  What are your performance needs?   │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │ Cost-Optimized │────→ pd-standard
       │   (<1000 IOPS) │      ($0.040/GB)
       └────────────────┘
               │
       ┌───────┴────────┐
       │ Balanced IOPS  │────→ pd-balanced
       │ (1K-15K IOPS)  │      ($0.100/GB)
       └────────────────┘      "Best default choice"
               │
       ┌───────┴────────┐
       │  High IOPS     │────→ pd-ssd
       │ (15K-100K)     │      ($0.170/GB)
       └────────────────┘
               │
       ┌───────┴────────┐
       │ Consistent     │────→ pd-extreme
       │ Ultra-High     │      (Provisioned)
       │ (>100K IOPS)   │      "Predictable latency"
       └────────────────┘
```

### Regional vs Zonal Persistent Disks

| Feature | Zonal PD | Regional PD |
|---------|----------|-------------|
| **Availability** | Single zone | Replicated across 2 zones (synchronous) |
| **Durability** | 99.9999999% (9 nines) | 99.99999999999% (13 nines) |
| **Cost** | Base cost | 2x zonal cost |
| **Performance** | Full performance | Same as zonal |
| **Latency** | Lowest | Slightly higher (replication) |
| **RTO** | VM restart | Automatic failover (<5 min) |
| **RPO** | Snapshot-based | 0 (synchronous replication) |
| **Use Case** | Cost-sensitive, stateless | HA databases, critical data |
| **Disk Types** | All types | pd-standard, pd-balanced, pd-ssd |

**Regional PD Architecture**:
```
┌────────────────────────────────────────┐
│         Regional Persistent Disk       │
└────────────────────────────────────────┘

      Zone A                Zone B
┌───────────────┐    ┌───────────────┐
│               │    │               │
│  ┌─────────┐  │    │  ┌─────────┐  │
│  │ Primary │  │◄──►│  │ Replica │  │
│  │  Disk   │  │    │  │  Disk   │  │
│  └────┬────┘  │    │  └─────────┘  │
│       │       │    │                │
│  ┌────▼────┐  │    │   (Standby)   │
│  │   VM    │  │    │                │
│  └─────────┘  │    │                │
└───────────────┘    └───────────────┘

Synchronous Replication:
- Write acknowledged after both replicas written
- Automatic failover to Zone B if Zone A fails
- No data loss (RPO = 0)
```

**Cost Comparison Example**:
```
Scenario: 1 TB SSD disk in us-central1

Zonal PD:
1024 GB × $0.170 = $174/month

Regional PD:
1024 GB × $0.170 × 2 = $348/month

Regional PD provides:
- Zero RPO (no data loss)
- Automatic failover
- 13 nines durability vs 9 nines
- Worth 2x cost for critical workloads
```

### Persistent Disk Snapshots

#### Snapshot Characteristics
- **Incremental**: Only changed blocks after first snapshot
- **Global**: Stored in Cloud Storage (multi-regional)
- **Automatic compression**: Reduces storage costs
- **Point-in-time**: Consistent snapshot of disk state
- **VSS support**: Windows Volume Shadow Copy integration

#### Snapshot Strategy

**Incremental Chain**:
```
Day 0: Full Snapshot (100 GB)
       ┌──────────────┐
       │   Snapshot 1 │  ← 100 GB stored
       │  (Full: 100) │
       └──────────────┘

Day 1: Incremental (10 GB changed)
       ┌──────────────┐
       │   Snapshot 2 │  ← 10 GB stored
       │  (Δ: 10 GB)  │  ← References Snapshot 1
       └──────────────┘

Day 2: Incremental (15 GB changed)
       ┌──────────────┐
       │   Snapshot 3 │  ← 15 GB stored
       │  (Δ: 15 GB)  │  ← References Snapshot 2
       └──────────────┘

Total stored: 125 GB (not 325 GB)
```

#### Snapshot Commands

```bash
# Create snapshot from disk
gcloud compute disks snapshot my-disk \
  --zone=us-central1-a \
  --snapshot-names=my-snapshot-$(date +%Y%m%d)

# Create snapshot with VSS (Windows)
gcloud compute disks snapshot my-windows-disk \
  --zone=us-central1-a \
  --guest-flush

# Create disk from snapshot
gcloud compute disks create new-disk \
  --source-snapshot=my-snapshot \
  --zone=us-central1-b \
  --type=pd-ssd

# Scheduled snapshots (recommended)
gcloud compute resource-policies create snapshot-schedule daily-backup \
  --region=us-central1 \
  --max-retention-days=14 \
  --on-source-disk-delete=keep-auto-snapshots \
  --daily-schedule \
  --start-time=02:00

# Attach schedule to disk
gcloud compute disks add-resource-policies my-disk \
  --zone=us-central1-a \
  --resource-policies=daily-backup
```

#### Snapshot Pricing
```
Snapshot Storage Cost:
- Multi-regional: $0.026/GB/month
- Regional: $0.020/GB/month

Example: 1 TB disk with daily snapshots (10% daily change)
Day 1:  100 GB (full) = $2.60/month
Day 2:  +10 GB (incr) = +$0.26/month
Day 30: +290 GB total = $10.14/month

Much cheaper than maintaining 30 full copies (30 × $26 = $780)
```

### Disk Resizing and Management

#### Online Disk Resizing
```bash
# Resize disk (can only increase, never decrease)
gcloud compute disks resize my-disk \
  --size=500GB \
  --zone=us-central1-a

# Resize partition (inside VM)
# Linux
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1

# Or for XFS
sudo xfs_growfs /mount/point

# Windows
# Use Disk Management or diskpart
# Extends automatically in most cases
```

#### Disk Cloning

```bash
# Method 1: Clone via snapshot
gcloud compute disks snapshot source-disk \
  --snapshot-names=temp-snapshot \
  --zone=us-central1-a

gcloud compute disks create cloned-disk \
  --source-snapshot=temp-snapshot \
  --zone=us-central1-a

# Method 2: Instant clone (faster, same zone)
gcloud compute disks create instant-clone \
  --source-disk=source-disk \
  --zone=us-central1-a

# Method 3: Regional disk from zonal
gcloud compute disks create regional-clone \
  --source-disk=zones/us-central1-a/disks/source-disk \
  --region=us-central1 \
  --replica-zones=us-central1-a,us-central1-b \
  --type=pd-ssd
```

### Advanced Features

#### Multi-Attach Mode (Read-Only)
```
Use Case: Shared read-only data across multiple VMs

┌──────────┐     ┌──────────┐     ┌──────────┐
│   VM 1   │     │   VM 2   │     │   VM 3   │
│          │     │          │     │          │
└────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │
     └────────┬───────┴────────┬───────┘
              │                │
         ┌────▼────────────────▼────┐
         │  Persistent Disk (RO)    │
         │  Multi-Attach Enabled    │
         └──────────────────────────┘

Limitations:
- Read-only access only
- Max 10 VMs per disk
- All VMs must be in same zone
- Use case: Shared datasets, ML models
```

#### Disk Encryption Options

| Type | Key Management | Use Case | Performance Impact |
|------|----------------|----------|-------------------|
| **Google-managed** | Automatic (default) | Standard protection | None |
| **Customer-managed (CMEK)** | Cloud KMS | Compliance, key rotation | Negligible |
| **Customer-supplied (CSEK)** | You manage keys | Full control | Negligible |

```bash
# Create disk with CMEK
gcloud compute disks create cmek-disk \
  --size=100GB \
  --zone=us-central1-a \
  --kms-key=projects/PROJECT/locations/us-central1/keyRings/RING/cryptoKeys/KEY

# Create disk with CSEK
gcloud compute disks create csek-disk \
  --size=100GB \
  --zone=us-central1-a \
  --csek-key-file=key.json
```

**EXAM TIP**: Regional persistent disks provide automatic failover with zero RPO but cost 2x. They're ideal for HA databases. For cost optimization, use zonal disks with snapshot-based DR (higher RPO/RTO but lower cost).

## Filestore (Managed NFS) - Deep Dive

### What is Filestore?
Fully managed Network File System (NFSv3) service providing high-performance file storage for applications requiring shared file access. Built on Google's infrastructure with enterprise-grade reliability.

### Service Tiers - Comprehensive Comparison

| Tier | Performance (IOPS) | Throughput | Capacity | Availability | Cost/GB/Month | Use Case |
|------|-------------------|------------|----------|--------------|---------------|----------|
| **Basic HDD** | Baseline: 1,000<br>Burst: 5,000 | 100-180 MB/s per TB | 1-63.9 TB | Zonal (single zone) | $0.20 | General file sharing, dev/test |
| **Basic SSD** | Baseline: 60,000<br>Burst: 100,000 | 600-1,200 MB/s per TB | 2.5-63.9 TB | Zonal (single zone) | $0.60 | Performance workloads, databases |
| **High Scale SSD** | 100,000+ | 1,200-6,000 MB/s per TB | 10-100+ TB | Regional (multi-zone) | $0.35 | HPC, media rendering, analytics |
| **Enterprise** | Guaranteed: 100,000 | 1,000 MB/s per TB (guaranteed) | 1-10 TB | Regional (multi-zone) | $0.80 | Mission-critical, compliance |
| **Zonal** | 20,000-100,000 | 450-1,200 MB/s per TB | 1-100 TB | Zonal (single zone) | $0.24 | Cost-effective regional alternative |

### Performance Characteristics

**Basic HDD Performance Scaling**:
```
Capacity → Performance Relationship

1 TB:
- Baseline: 1,000 IOPS, 100 MB/s
- Burst: 5,000 IOPS, 100 MB/s

5 TB:
- Baseline: 1,000 IOPS, 500 MB/s
- Burst: 5,000 IOPS, 500 MB/s

10 TB:
- Baseline: 1,000 IOPS, 1,000 MB/s
- Burst: 5,000 IOPS, 1,000 MB/s
```

**Basic SSD Performance Scaling**:
```
2.5 TB:
- Read: 60,000 IOPS, 1,500 MB/s
- Write: 40,000 IOPS, 1,000 MB/s

10 TB:
- Read: 60,000 IOPS, 12,000 MB/s
- Write: 40,000 IOPS, 8,000 MB/s

Note: Performance scales linearly with capacity
```

### Architecture and Availability

**Zonal vs Regional Filestore**:
```
Zonal (Basic HDD/SSD, Zonal):
┌────────────────────────────┐
│      Zone us-central1-a    │
│  ┌──────────────────────┐  │
│  │   Filestore Instance │  │
│  │     (Single Zone)    │  │
│  └──────────┬───────────┘  │
│             │              │
│    ┌────────┴────────┐     │
│    │ VM 1 │ VM 2     │     │
│    └──────────────────┘     │
└────────────────────────────┘

- Lower cost
- Single zone failure = outage
- 99.9% SLA

Regional (High Scale, Enterprise):
┌─────────────────────────────────┐
│      Region us-central1         │
│  ┌─────────┐    ┌─────────┐    │
│  │ Zone A  │    │ Zone B  │    │
│  │┌───────┐│    │┌───────┐│    │
│  ││Primary││◄──►││Replica││    │
│  │└───┬───┘│    │└───────┘│    │
│  │    │    │    │         │    │
│  │  ┌─▼─┐  │    │  ┌───┐  │    │
│  │  │VM │  │    │  │VM │  │    │
│  │  └───┘  │    │  └───┘  │    │
│  └─────────┘    └─────────┘    │
└─────────────────────────────────┘

- Higher cost
- Automatic failover
- 99.99% SLA
```

### Creating and Managing Filestore

#### Create Filestore Instance

```bash
# Basic HDD instance
gcloud filestore instances create nfs-server \
  --project=my-project \
  --location=us-central1-a \
  --tier=BASIC_HDD \
  --file-share=name="vol1",capacity=1TB \
  --network=name="default"

# Basic SSD instance
gcloud filestore instances create nfs-ssd \
  --location=us-central1-a \
  --tier=BASIC_SSD \
  --file-share=name="vol1",capacity=2.5TB \
  --network=name="vpc-network"

# Regional High Scale SSD
gcloud filestore instances create nfs-regional \
  --location=us-central1 \
  --tier=HIGH_SCALE_SSD \
  --file-share=name="vol1",capacity=10TB \
  --network=name="vpc-network"

# Enterprise tier with backup
gcloud filestore instances create nfs-enterprise \
  --location=us-central1 \
  --tier=ENTERPRISE \
  --file-share=name="vol1",capacity=5TB \
  --network=name="vpc-network"
```

#### Mount Filestore on Compute Engine

```bash
# On the VM instance
# Install NFS client
sudo apt-get update
sudo apt-get install nfs-common

# Create mount point
sudo mkdir -p /mnt/filestore

# Mount the file share
sudo mount FILESTORE_IP:/FILESHARE_NAME /mnt/filestore

# Verify mount
df -h | grep filestore

# Add to /etc/fstab for persistent mount
echo "FILESTORE_IP:/FILESHARE_NAME /mnt/filestore nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# Example with actual values
sudo mount 10.0.0.2:/vol1 /mnt/filestore
```

#### Mounting from GKE

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: filestore-pv
spec:
  capacity:
    storage: 1Ti
  accessModes:
    - ReadWriteMany
  nfs:
    path: /vol1
    server: 10.0.0.2
  mountOptions:
    - hard
    - nfsvers=3
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: filestore-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 1Ti
  volumeName: filestore-pv
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:latest
        volumeMounts:
        - name: shared-data
          mountPath: /usr/share/nginx/html
      volumes:
      - name: shared-data
        persistentVolumeClaim:
          claimName: filestore-pvc
```

### Backup and Restore

#### Backup Configuration

```bash
# Create backup
gcloud filestore backups create backup-001 \
  --instance=nfs-server \
  --instance-location=us-central1-a \
  --file-share=vol1 \
  --region=us-central1

# List backups
gcloud filestore backups list \
  --region=us-central1

# Describe backup
gcloud filestore backups describe backup-001 \
  --region=us-central1

# Restore from backup to new instance
gcloud filestore instances create nfs-restored \
  --location=us-central1-a \
  --tier=BASIC_HDD \
  --file-share=name="vol1",capacity=1TB \
  --source-backup=backup-001 \
  --source-backup-region=us-central1 \
  --network=name="default"

# Restore to existing instance (overwrites)
gcloud filestore instances restore nfs-server \
  --location=us-central1-a \
  --source-backup=backup-001 \
  --source-backup-region=us-central1
```

#### Snapshot and Backup Strategy

```
Backup Recommendations:
┌─────────────────────────────────────┐
│      Filestore Backup Strategy      │
└─────────────────────────────────────┘

Production Data:
- Hourly backups (keep 24)
- Daily backups (keep 7)
- Weekly backups (keep 4)
- Monthly backups (keep 12)

Development Data:
- Daily backups (keep 7)
- Weekly backups (keep 4)

Backup Location:
- Same region for fast restore
- Cross-region for DR (manual copy)
```

### Performance Optimization

#### NFS Mount Options

```bash
# Recommended mount options for performance
sudo mount -o rw,hard,timeo=600,retrans=2,_netdev,nfsvers=3 \
  FILESTORE_IP:/FILESHARE /mnt/filestore

# High-performance options
sudo mount -o rw,hard,noac,noatime,nodiratime,_netdev,nfsvers=3 \
  FILESTORE_IP:/FILESHARE /mnt/filestore

# Explanation of options:
# - rw: Read-write access
# - hard: Hard mount (retries on failure)
# - noac: No attribute caching (for strict consistency)
# - noatime: Don't update access times (performance)
# - nodiratime: Don't update directory access times
# - timeo=600: Timeout value (60 seconds)
# - retrans=2: Number of retransmissions
# - _netdev: Mount after network is available
# - nfsvers=3: Use NFSv3 protocol
```

#### Performance Tuning Tips

```
1. Right-size capacity for performance:
   - Basic SSD: 2.5 TB minimum for 60K IOPS
   - Scale up capacity if hitting performance limits

2. Use appropriate mount options:
   - noac for strict consistency
   - Keep defaults for most workloads

3. Network optimization:
   - Use VMs in same region/zone
   - Enable jumbo frames if supported

4. Application-level optimization:
   - Batch small operations
   - Use async I/O where possible
   - Cache frequently accessed data

5. Monitor performance metrics:
   - IOPS utilization
   - Throughput utilization
   - Network bandwidth
```

### Cost Optimization Strategies

**Capacity Planning**:
```
Example Cost Analysis:

Scenario: 5 TB of shared data

Option 1: Basic SSD (5 TB)
- Cost: 5,120 GB × $0.60 = $3,072/month
- Performance: 60,000 IOPS, 3,000 MB/s
- Good for: Active workloads

Option 2: Basic HDD (5 TB)
- Cost: 5,120 GB × $0.20 = $1,024/month
- Performance: 1,000 IOPS, 500 MB/s
- Good for: Infrequent access, archives

Option 3: Zonal (5 TB)
- Cost: 5,120 GB × $0.24 = $1,229/month
- Performance: 40,000 IOPS, 1,500 MB/s
- Good for: Balanced price/performance

Recommendation: Start with Zonal or Basic HDD
Upgrade to Basic SSD only if performance needed
```

**EXAM TIP**: Filestore requires minimum 1 TB for Basic HDD and 2.5 TB for Basic SSD. For small file shares (<1 TB), consider using Persistent Disk with NFS server or Cloud Storage with FUSE.

## Data Transfer Services

### Storage Transfer Service

#### What is Storage Transfer Service?
Managed service for transferring data from online sources (S3, Azure, HTTP/HTTPS) or on-premises to Cloud Storage. Handles large-scale transfers with built-in retry and validation.

#### Transfer Sources

| Source | Use Case | Performance | Cost |
|--------|----------|-------------|------|
| **AWS S3** | Cloud migration | Up to 10 Gbps per agent | Egress from AWS (AWS charges) |
| **Azure Blob** | Multi-cloud | Up to 10 Gbps per agent | Egress from Azure (Azure charges) |
| **HTTP/HTTPS** | Public data | Varies | Bandwidth costs |
| **Cloud Storage** | Inter-bucket | Up to 10 Gbps | No transfer cost (same location) |
| **On-Premises** | Data center migration | Limited by bandwidth | Bandwidth + agent compute |

#### Creating Transfer Jobs

```bash
# Transfer from AWS S3 to Cloud Storage
gcloud transfer jobs create s3://my-aws-bucket gs://my-gcs-bucket \
  --source-creds-file=aws-creds.json \
  --schedule-repeats-every=1d \
  --schedule-starts=2024-01-01T00:00:00Z \
  --do-not-run-until=2024-01-01T00:00:00Z \
  --overwrite-when=different \
  --delete-from=destination-if-unique

# Transfer from on-premises
gcloud transfer jobs create file:///data/exports gs://my-gcs-bucket \
  --source-agent-pool=my-agent-pool \
  --manifest-file=gs://my-bucket/manifest.csv

# Transfer between GCS buckets
gcloud transfer jobs create gs://source-bucket gs://dest-bucket \
  --schedule-repeats-every=6h \
  --include-prefixes=logs/,backups/

# One-time HTTP URL list transfer
gcloud transfer jobs create \
  --source-list=urls.txt \
  --destination=gs://my-bucket
```

#### Transfer Job Configuration (JSON)

```json
{
  "description": "Daily S3 to GCS sync",
  "status": "ENABLED",
  "projectId": "my-project",
  "schedule": {
    "scheduleStartDate": {
      "year": 2024,
      "month": 1,
      "day": 1
    },
    "scheduleEndDate": {
      "year": 2024,
      "month": 12,
      "day": 31
    },
    "startTimeOfDay": {
      "hours": 2,
      "minutes": 0
    },
    "repeatInterval": "86400s"
  },
  "transferSpec": {
    "awsS3DataSource": {
      "bucketName": "my-aws-bucket",
      "awsAccessKey": {
        "accessKeyId": "ACCESS_KEY",
        "secretAccessKey": "SECRET_KEY"
      }
    },
    "gcsDataSink": {
      "bucketName": "my-gcs-bucket"
    },
    "objectConditions": {
      "minTimeElapsedSinceLastModification": "2592000s",
      "includePrefixes": ["logs/", "backups/"],
      "excludePrefixes": ["temp/"]
    },
    "transferOptions": {
      "overwriteObjectsAlreadyExistingInSink": true,
      "deleteObjectsUniqueInSink": false,
      "deleteObjectsFromSourceAfterTransfer": false
    }
  },
  "notificationConfig": {
    "pubsubTopic": "projects/my-project/topics/transfer-notifications",
    "eventTypes": ["TRANSFER_OPERATION_SUCCESS", "TRANSFER_OPERATION_FAILED"],
    "payloadFormat": "JSON"
  }
}
```

### Transfer Appliance

#### What is Transfer Appliance?
Physical device (rackable storage server) shipped to your data center for offline data transfer. Ideal for large datasets (>20 TB) or limited bandwidth scenarios.

#### Transfer Appliance Specifications

| Model | Capacity | Use Case | Transfer Time (upload) |
|-------|----------|----------|----------------------|
| **TA40** | 40 TB usable | Small migrations | ~1 week |
| **TA300** | 300 TB usable | Medium migrations | ~2 weeks |
| **TA480** | 480 TB usable | Large migrations | ~3 weeks |

#### Transfer Appliance Process

```
Step-by-Step Process:
┌─────────────────────────────────────┐
│   Transfer Appliance Workflow       │
└─────────────────────────────────────┘

1. Order Appliance
   │
   ├─→ Request via Console
   ├─→ Specify capacity and destination
   └─→ Google ships appliance

2. Receive & Connect (Your Data Center)
   │
   ├─→ Rack mount or standalone
   ├─→ Connect to network (10/40 GbE)
   └─→ Power on and configure

3. Copy Data (1-2 weeks)
   │
   ├─→ rsync, robocopy, or custom scripts
   ├─→ Monitor via web UI
   └─→ Validate data integrity

4. Ship Back to Google
   │
   ├─→ Request pickup
   ├─→ Google provides shipping label
   └─→ Secure erase after successful upload

5. Google Uploads Data (1-2 weeks)
   │
   ├─→ High-speed upload to Cloud Storage
   ├─→ Notification on completion
   └─→ Verify data in GCS

Total Time: 4-8 weeks (vs months over network)
```

#### Cost Comparison: Transfer Appliance vs Online Transfer

```
Scenario: 100 TB migration

Online Transfer (1 Gbps):
- Time: 100 TB / 1 Gbps = ~9 days continuous
- Cost: Internet bandwidth (varies by ISP)
- Realistic: 2-3 weeks with retry/throttling

Transfer Appliance:
- Time: 4-6 weeks (includes shipping)
- Cost: ~$300/TB (one-time fee)
- Total: ~$30,000

Break-even:
- If bandwidth cost > $30,000, use appliance
- If timeline < 2 weeks required, use online
- If bandwidth limited (<100 Mbps), use appliance
```

### gsutil - Advanced Usage

#### Parallel Composite Uploads

```bash
# Enable parallel composite uploads (objects > 150 MB)
gsutil -o GSUtil:parallel_composite_upload_threshold=150M \
  cp large-file.zip gs://my-bucket/

# Disable parallel uploads (for compatibility)
gsutil -o GSUtil:parallel_composite_upload_threshold=0 \
  cp file.zip gs://my-bucket/

# Configure in .boto config
[GSUtil]
parallel_composite_upload_threshold = 150M
parallel_composite_upload_component_size = 50M
```

#### Parallel Transfer Optimization

```bash
# Parallel (-m) transfer multiple files
gsutil -m cp -r local-dir/* gs://my-bucket/folder/

# Optimize for large files
gsutil -o GSUtil:parallel_thread_count=24 \
       -o GSUtil:sliced_object_download_threshold=150M \
       -o GSUtil:sliced_object_download_max_components=8 \
  cp gs://my-bucket/large-file.dat ./

# Rsync with parallel and checksum
gsutil -m rsync -r -c -d local-dir gs://my-bucket/backup/

# Performance tuning parameters
gsutil -o GSUtil:parallel_process_count=12 \
       -o GSUtil:parallel_thread_count=24 \
  -m cp -r large-dataset/* gs://my-bucket/
```

#### Data Integrity and Resumable Uploads

```bash
# Resumable uploads (automatic for files > 8 MB)
gsutil cp large-file.zip gs://my-bucket/
# Automatically resumes if interrupted

# Verify checksums
gsutil hash file.dat
gsutil hash gs://my-bucket/file.dat

# Compare local and remote
gsutil rsync -c -n local-dir gs://my-bucket/dir/
# -c: Compare checksums
# -n: Dry run (don't actually transfer)

# Copy with verification
gsutil cp -v file.dat gs://my-bucket/

# Check object integrity
gsutil stat gs://my-bucket/file.dat
```

#### Performance Optimization Commands

```bash
# Enable faster crcmod (C extension)
pip uninstall crcmod
pip install --no-cache-dir -U crcmod

# Perfdiag to test performance
gsutil perfdiag gs://my-bucket

# Network diagnostic
gsutil perfdiag -n 5 -c 10 -k 1M gs://my-bucket

# Output example analysis:
# - Throughput: 800 Mbps
# - Latency: 15ms
# - Recommended: parallel_process_count=8
```

### Cloud Storage FUSE

#### What is Cloud Storage FUSE?
Open-source FUSE adapter that allows mounting Cloud Storage buckets as local file systems on Linux/macOS.

#### Installation and Usage

```bash
# Install on Ubuntu/Debian
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | \
  sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse

# Mount bucket
gcsfuse my-bucket /mnt/gcs

# Mount with options
gcsfuse -o allow_other -o ro --implicit-dirs my-bucket /mnt/gcs

# Mount at boot (/etc/fstab)
my-bucket /mnt/gcs gcsfuse rw,noauto,user,implicit_dirs

# Unmount
fusermount -u /mnt/gcs
```

#### Performance Considerations

```
Cloud Storage FUSE Limitations:
┌─────────────────────────────────────┐
│    Not a Full Filesystem            │
└─────────────────────────────────────┘

Limitations:
- Sequential read/write only
- No random writes (requires rewrite)
- No file locking support
- No atime/mtime updates
- Slower than native filesystem
- Not suitable for databases

Good Use Cases:
✓ Read-mostly workloads
✓ Large file streaming
✓ ML model serving
✓ Log aggregation
✓ Content serving

Bad Use Cases:
✗ Databases
✗ Random I/O workloads
✗ File locking requirements
✗ Low-latency applications
```

## Storage Architecture Patterns

### Data Lake Architecture

```
Modern Data Lake on GCP:
┌─────────────────────────────────────────────────────────┐
│                  Ingestion Layer                        │
├─────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │ Pub/Sub  │  │ Transfer │  │ Dataflow │            │
│  │ Messages │  │ Service  │  │ Streaming│            │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘            │
└───────┼─────────────┼─────────────┼───────────────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│              Raw Data Zone (Cloud Storage)               │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Landing Zone: Standard Storage Class              │  │
│  │ - Raw, unprocessed data                          │  │
│  │ - Partitioned by date: /raw/YYYY/MM/DD/         │  │
│  │ - Lifecycle: → Nearline after 30 days           │  │
│  └───────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼ (Dataflow/Dataproc)
┌─────────────────────────────────────────────────────────┐
│           Processed Data Zone (Cloud Storage)            │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Curated Zone: Standard/Nearline                   │  │
│  │ - Cleaned, validated data                        │  │
│  │ - Parquet/Avro format                           │  │
│  │ - Partitioned for BigQuery                      │  │
│  └───────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼ (BigQuery External Tables)
┌─────────────────────────────────────────────────────────┐
│              Analytics Layer (BigQuery)                  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ - SQL queries on data lake                       │  │
│  │ - Partitioned tables                             │  │
│  │ - Materialized views                             │  │
│  └───────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            Archive Zone (Cloud Storage)                  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Archive Storage Class                             │  │
│  │ - Historical data (>1 year)                      │  │
│  │ - Compliance/regulatory                          │  │
│  │ - Rare access                                    │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

#### Data Lake Best Practices

**Folder Structure**:
```
gs://data-lake/
├── raw/
│   ├── source=app-logs/
│   │   └── year=2024/month=01/day=15/
│   ├── source=iot-sensors/
│   │   └── year=2024/month=01/day=15/
│   └── source=crm-exports/
│       └── year=2024/month=01/day=15/
├── processed/
│   ├── dataset=user-events/
│   │   └── year=2024/month=01/
│   └── dataset=iot-aggregates/
│       └── year=2024/month=01/
├── curated/
│   └── dataset=analytics-ready/
│       └── year=2024/month=01/
└── archive/
    └── year=2023/
```

**Lifecycle Policy for Data Lake**:
```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {
          "age": 30,
          "matchesPrefix": ["raw/", "processed/"]
        }
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {
          "age": 90,
          "matchesPrefix": ["raw/", "processed/"]
        }
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "ARCHIVE"},
        "condition": {
          "age": 365,
          "matchesPrefix": ["raw/", "processed/", "curated/"]
        }
      },
      {
        "action": {"type": "Delete"},
        "condition": {
          "age": 2555,
          "matchesPrefix": ["raw/"]
        }
      }
    ]
  }
}
```

### Backup and Disaster Recovery Architecture

```
Multi-Region DR Strategy:
┌─────────────────────────────────────────────────────────┐
│                Primary Region (us-central1)              │
├─────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────┐  │
│  │ Production Workloads                             │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐      │  │
│  │  │Cloud SQL │  │Persistent│  │Filestore │      │  │
│  │  │ Regional │  │   Disk   │  │Enterprise│      │  │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘      │  │
│  └───────┼─────────────┼─────────────┼─────────────┘  │
└──────────┼─────────────┼─────────────┼────────────────┘
           │             │             │
           │ Continuous  │ Scheduled   │ Daily
           │ Replication │ Snapshots   │ Backups
           │             │             │
           ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│            Backup Storage (Multi-Region)                 │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Cloud Storage Multi-Region (us)                  │  │
│  │  ┌─────────────────────────────────────────────┐ │  │
│  │  │ - SQL backups (automated + on-demand)       │ │  │
│  │  │ - Disk snapshots (daily + retention)        │ │  │
│  │  │ - Filestore backups (hourly + retention)    │ │  │
│  │  │ - Application data exports                   │ │  │
│  │  └─────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       │ DR Failover
                       ▼
┌─────────────────────────────────────────────────────────┐
│              DR Region (us-east1)                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Standby/Recovery Workloads                       │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐      │  │
│  │  │Cloud SQL │  │Persistent│  │Filestore │      │  │
│  │  │ Replica  │  │from Snap │  │from Bkup │      │  │
│  │  │ (Standby)│  │ (Cold)   │  │ (Cold)   │      │  │
│  │  └──────────┘  └──────────┘  └──────────┘      │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

#### RPO/RTO Targets by Storage Type

| Storage Type | RPO | RTO | DR Strategy | Cost Impact |
|--------------|-----|-----|-------------|-------------|
| **Cloud SQL Regional** | 0 (synchronous) | <5 min (auto-failover) | Regional PD + read replicas | 2x storage |
| **Persistent Disk Regional** | 0 (synchronous) | <5 min (auto-failover) | Regional PD | 2x storage |
| **Persistent Disk Zonal** | 5-60 min | 15-30 min | Scheduled snapshots | +10-20% |
| **Filestore Enterprise** | 1 hour | 2-4 hours | Hourly backups | +30-50% |
| **Filestore Basic** | 24 hours | 4-8 hours | Daily backups | +20-30% |
| **Cloud Storage** | 0 | Minutes | Multi-region or dual-region | +30% (multi-region) |

### High-Availability Storage Patterns

**Pattern 1: Stateless Application with Cloud Storage**
```
┌─────────────────────────────────────┐
│      Global Load Balancer           │
└──────────┬────────────┬─────────────┘
           │            │
    ┌──────▼───┐   ┌───▼──────┐
    │ Region 1 │   │ Region 2 │
    │  ┌────┐  │   │  ┌────┐  │
    │  │ GKE│  │   │  │ GKE│  │
    │  └──┬─┘  │   │  └──┬─┘  │
    └─────┼────┘   └─────┼─────┘
          │              │
          └──────┬───────┘
                 │
          ┌──────▼─────────┐
          │ Cloud Storage  │
          │  Multi-Region  │
          │  (Standard)    │
          └────────────────┘

Benefits:
- Zero RPO/RTO for storage
- Active-active architecture
- Auto-scaling
- Global distribution
```

**Pattern 2: Stateful Application with Regional PD**
```
Primary Zone         Standby Zone
┌──────────┐       ┌──────────┐
│ VM-1     │       │ (Standby)│
│ Active   │       │          │
└────┬─────┘       └──────────┘
     │
┌────▼─────────────────────────┐
│  Regional Persistent Disk    │
│  Synchronous Replication     │
└──────────────────────────────┘

Failover:
1. VM-1 fails (zone outage)
2. Regional PD auto-fails to standby zone
3. Start new VM in standby zone
4. Attach regional PD
5. Resume operations

RTO: 5-10 minutes
RPO: 0 (zero data loss)
```

**EXAM TIP**: For HA requirements, always consider the SLA implications: Multi-region Cloud Storage (99.95%), Regional PD (99.99% with auto-failover), Cloud SQL regional (99.95%). Choose based on RTO/RPO requirements and budget.
- **MySQL**: Popular open-source database
- **PostgreSQL**: Advanced open-source database
- **SQL Server**: Microsoft's relational database

### Instance Types
| Type | vCPUs | Memory | Use Case |
|------|-------|--------|----------|
| **Shared-core** | Shared | 0.6-3.75 GB | Development, testing |
| **Standard** | 1-96 | 3.75-624 GB | Production workloads |
| **High-memory** | 2-96 | 13-624 GB | Memory-intensive applications |

### High Availability & Disaster Recovery
- **Regional Persistent Disks**: Automatic failover within region
- **Cross-Region Replicas**: Read replicas in different regions
- **Point-in-Time Recovery**: Restore to specific timestamp
- **Automated Backups**: Daily backups with transaction logs

### Key Features
- **Automatic Updates**: OS and database patches
- **Scaling**: Vertical scaling with minimal downtime
- **Security**: Encryption at rest and in transit
- **Monitoring**: Integration with Cloud Monitoring
- **Private IP**: VPC-native connectivity

## Firestore (NoSQL Document Database)

### What is Firestore?
Fully managed NoSQL document database designed for mobile and web applications.

### Firestore vs Datastore
| Feature | Firestore (Native) | Datastore |
|---------|-------------------|-----------|
| **Real-time**: Yes | No |
| **Mobile SDKs**: Yes | No |
| **ACID Transactions**: Yes | Limited |
| **Queries**: More flexible | Basic |
| **Status**: Current | Legacy |

### Data Model
- **Documents**: JSON-like records
- **Collections**: Groups of documents
- **Subcollections**: Collections within documents
- **Fields**: Key-value pairs in documents

### Key Features
- **Real-time Listeners**: Live synchronization
- **Offline Support**: Local caching and sync
- **ACID Transactions**: Multi-document transactions
- **Security Rules**: Client-side security
- **Auto-scaling**: Handles traffic spikes automatically

## BigQuery (Data Warehouse)

### What is BigQuery?
Fully managed, serverless data warehouse for analytics using standard SQL.

### Key Characteristics
- **Serverless**: No infrastructure to manage
- **Petabyte Scale**: Handle massive datasets
- **Standard SQL**: ANSI SQL 2011 compliance
- **Streaming Inserts**: Real-time data ingestion
- **Machine Learning**: Built-in ML capabilities

### Storage & Compute Separation
- **Storage**: Pay for data stored
- **Compute**: Pay for queries processed
- **Slots**: Units of computational capacity
- **On-demand**: Pay per query
- **Flat-rate**: Reserved slots for predictable pricing

### Data Organization
- **Datasets**: Top-level container for tables
- **Tables**: Structured data with schema
- **Partitioning**: Divide tables by date/time
- **Clustering**: Organize data within partitions

## Bigtable (NoSQL Wide-Column)

### What is Bigtable?
High-performance NoSQL database service for large analytical and operational workloads.

### Key Characteristics
- **Low Latency**: Single-digit millisecond latency
- **High Throughput**: Millions of operations per second
- **Scalable**: Petabyte+ scale
- **Wide-Column**: Non-relational, wide-column format
- **HBase Compatible**: Standard HBase API

### Use Cases
- **Time Series**: IoT data, financial data
- **Real-time Analytics**: Personalization, fraud detection
- **Machine Learning**: Feature storage, model serving
- **Gaming**: Leaderboards, player data

### Performance Considerations
- **Node Count**: More nodes = higher performance
- **Key Design**: Avoid hotspotting
- **Column Families**: Group related columns
- **Garbage Collection**: Clean up old data

## Storage Decision Framework

### Choosing Storage Type
```
Object storage for files/backups? → Cloud Storage
Block storage for VMs? → Persistent Disks
Shared file system? → Filestore
Relational database? → Cloud SQL
Document database for mobile/web? → Firestore
Data warehouse/analytics? → BigQuery
High-performance NoSQL? → Bigtable
```

### Cloud Storage Class Selection
```
Frequent access? → Standard
Monthly access? → Nearline
Quarterly access? → Coldline
Yearly access or archive? → Archive
Unknown pattern? → Start with Standard, use lifecycle
```

### Persistent Disk Type Selection
```
General purpose? → Balanced (pd-balanced)
High IOPS database? → SSD (pd-ssd)
Consistent high performance? → Extreme (pd-extreme)
Cost-sensitive backup? → Standard (pd-standard)
```

## Practical Examples

### Web Application Storage
- **Static Assets**: Cloud Storage + Cloud CDN
- **Application Data**: Persistent Disks for VMs
- **User Data**: Firestore for real-time features
- **Analytics**: Stream to BigQuery
- **File Uploads**: Cloud Storage with signed URLs

### Data Analytics Pipeline
- **Raw Data**: Cloud Storage data lake
- **Processing**: Dataflow with Persistent Disks
- **Data Warehouse**: BigQuery for analytics
- **Results**: Cloud Storage or Firestore
- **Monitoring**: Cloud Monitoring for pipeline health

### Gaming Backend
- **Player Data**: Firestore for real-time sync
- **Leaderboards**: Bigtable for high performance
- **Game Assets**: Cloud Storage + CDN
- **Analytics**: BigQuery for player behavior
- **Backups**: Cloud Storage Archive class

## Best Practices

### Cloud Storage
- Choose appropriate storage class for access patterns
- Use lifecycle policies for cost optimization
- Implement proper access controls (IAM)
- Enable versioning for important data
- Use regional/multi-regional based on availability needs
- Monitor storage costs and usage

### Persistent Disks
- Choose appropriate disk type for workload
- Use regional disks for high availability
- Regular snapshots for backup/disaster recovery
- Monitor disk performance metrics
- Size disks appropriately for performance needs
- Use encryption for sensitive data

### Database Services
- Choose right database type for use case
- Implement proper indexing strategies
- Monitor performance and optimize queries
- Use read replicas for read-heavy workloads
- Regular backups and test recovery procedures
- Implement proper security measures

## Cost Optimization Strategies

### Cloud Storage
- Use appropriate storage classes
- Implement lifecycle policies
- Delete unnecessary object versions
- Use regional storage for regional access
- Monitor and alert on unexpected usage
- Compress data when possible

### Persistent Disks
- Right-size disks for actual usage
- Use snapshots efficiently (incremental)
- Consider zonal vs regional based on needs
- Monitor unused/unattached disks
- Use appropriate disk types for workload

### Database Optimization
- **Cloud SQL**: Right-size instances, use read replicas
- **BigQuery**: Partition tables, avoid SELECT *
- **Firestore**: Design efficient data structure
- **Bigtable**: Optimize node count for workload

## Common Pitfalls

### Cloud Storage Issues
- Not understanding storage class minimum durations
- Incorrect lifecycle policy configurations
- Bucket naming conflicts (global namespace)
- Not optimizing for access patterns
- Unexpected egress costs

### Persistent Disk Issues
- Over-provisioning disk size for performance
- Not taking regular snapshots
- Incorrect disk type for workload
- Not monitoring disk utilization
- Forgetting about snapshot costs

### Database Common Issues
- **Cloud SQL**: Not using connection pooling
- **BigQuery**: Querying without LIMIT or WHERE clauses
- **Firestore**: Poor data structure design
- **Bigtable**: Hotspotting due to poor key design