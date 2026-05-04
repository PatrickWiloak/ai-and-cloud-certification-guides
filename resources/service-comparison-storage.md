---
last-updated: 2026-05-03
difficulty: intermediate
---

# Cloud Service Comparison: Storage Services

## Quick Reference

This guide provides a comprehensive comparison of storage services across AWS, Google Cloud Platform (GCP), and Microsoft Azure. Use this to understand equivalent services when switching cloud providers or studying multiple certifications.

## Object Storage

| Feature | AWS S3 | GCP Cloud Storage | Azure Blob Storage |
|---------|--------|-------------------|-------------------|
| **Service Name** | S3 (Simple Storage Service) | Cloud Storage | Blob Storage |
| **Storage Classes** | Standard, Intelligent-Tiering, Standard-IA, One Zone-IA, Glacier Instant, Glacier Flexible, Glacier Deep Archive | Standard, Nearline, Coldline, Archive | Hot, Cool, Cold, Archive |
| **Max Object Size** | 5 TB | 5 TB | 4.77 TB (block blob), 190.7 TB (append blob) |
| **Durability** | 99.999999999% (11 9's) | 99.999999999% (11 9's) | 99.999999999% (11 9's) |
| **Availability** | 99.9-99.99% (varies by class) | 99.9-99.95% (varies by class) | 99-99.9% (varies by tier) |
| **Versioning** | Yes | Yes | Yes |
| **Encryption** | SSE-S3, SSE-KMS, SSE-C | Google-managed, Customer-managed (CMEK), Customer-supplied (CSEK) | Microsoft-managed, Customer-managed |
| **Access Control** | IAM, Bucket Policies, ACLs | IAM, ACLs | RBAC, Shared Access Signatures (SAS) |
| **Object Lifecycle** | Yes | Yes | Yes |
| **Event Notifications** | SNS, SQS, Lambda, EventBridge | Pub/Sub, Cloud Functions | Event Grid, Azure Functions |
| **Data Transfer** | Free inbound, charged outbound | Free inbound, charged outbound | Free inbound, charged outbound |
| **Replication** | Cross-Region (CRR), Same-Region (SRR) | Dual-region, Multi-region | GRS, RA-GRS, GZRS, RA-GZRS |
| **Object Lock** | Yes (WORM compliance) | Retention policies, holds | Immutable storage with legal hold |
| **Static Website Hosting** | Yes | Yes | Yes (via $web container) |
| **Query in Place** | S3 Select, Athena | BigQuery external tables | Azure Synapse Analytics |
| **Transfer Acceleration** | Yes (CloudFront edge locations) | Yes (global anycast) | Yes (via CDN) |

**Documentation:**
- **[📖 AWS S3 Documentation](https://docs.aws.amazon.com/s3/)** - Complete S3 guide
- **[📖 GCP Cloud Storage Documentation](https://cloud.google.com/storage/docs)** - Complete Cloud Storage guide
- **[📖 Azure Blob Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/blobs/)** - Complete Blob Storage guide
- **[📖 S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)** - AWS storage class details
- **[📖 Cloud Storage Classes](https://cloud.google.com/storage/docs/storage-classes)** - GCP storage class details
- **[📖 Azure Blob Access Tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)** - Azure tier details

---

## Storage Classes and Pricing Comparison

### AWS S3 Storage Classes

| Class | Use Case | Retrieval Time | Durability | Availability | Min Storage Duration | Retrieval Fee |
|-------|----------|----------------|------------|--------------|---------------------|---------------|
| **S3 Standard** | Frequently accessed data | Immediate | 11 9's | 99.99% | None | None |
| **S3 Intelligent-Tiering** | Unpredictable access patterns | Immediate | 11 9's | 99.9% | None | None |
| **S3 Standard-IA** | Infrequent access (monthly) | Immediate | 11 9's | 99.9% | 30 days | Per GB |
| **S3 One Zone-IA** | Infrequent, non-critical data | Immediate | 11 9's (1 AZ) | 99.5% | 30 days | Per GB |
| **S3 Glacier Instant Retrieval** | Archive, quarterly access | Milliseconds | 11 9's | 99.9% | 90 days | Per GB |
| **S3 Glacier Flexible Retrieval** | Archive, rare access | 1-5 minutes (Expedited), 3-5 hours (Standard), 5-12 hours (Bulk) | 11 9's | 99.99% | 90 days | Per GB + retrieval |
| **S3 Glacier Deep Archive** | Long-term archive, 1-2 times/year | 12 hours (Standard), 48 hours (Bulk) | 11 9's | 99.99% | 180 days | Per GB + retrieval |

### GCP Cloud Storage Classes

| Class | Use Case | Retrieval Time | Durability | Availability | Min Storage Duration | Retrieval Fee |
|-------|----------|----------------|------------|--------------|---------------------|---------------|
| **Standard** | Frequently accessed data | Immediate | 11 9's | 99.95% (multi-region), 99.9% (regional) | None | None |
| **Nearline** | Monthly access | Immediate | 11 9's | 99.95% (multi-region), 99.9% (regional) | 30 days | Per GB |
| **Coldline** | Quarterly access | Immediate | 11 9's | 99.95% (multi-region), 99.9% (regional) | 90 days | Per GB |
| **Archive** | Annual access | Immediate | 11 9's | 99.95% (multi-region), 99.9% (regional) | 365 days | Per GB |

### Azure Blob Storage Access Tiers

| Tier | Use Case | Retrieval Time | Durability | Availability | Min Storage Duration | Retrieval Fee |
|------|----------|----------------|------------|--------------|---------------------|---------------|
| **Hot** | Frequently accessed data | Immediate | 11 9's | 99.9% (LRS), 99.99% (RA-GRS) | None | None |
| **Cool** | Infrequent access (monthly) | Immediate | 11 9's | 99.9% (LRS), 99.99% (RA-GRS) | 30 days | Per GB |
| **Cold** | Infrequent access (quarterly) | Immediate | 11 9's | 99.9% (LRS), 99.99% (RA-GRS) | 90 days | Per GB |
| **Archive** | Long-term archive | Hours (requires rehydration) | 11 9's | 99.9% (LRS), 99.99% (RA-GRS) | 180 days | Per GB + rehydration |

---

## Block Storage (Attached to VMs)

| Feature | AWS EBS | GCP Persistent Disks | Azure Managed Disks |
|---------|---------|---------------------|-------------------|
| **Service Name** | EBS (Elastic Block Store) | Persistent Disks | Managed Disks |
| **Volume Types** | gp3, gp2 (SSD), io2, io1 (Provisioned IOPS SSD), st1 (HDD), sc1 (Cold HDD) | Standard (HDD), Balanced, SSD, Extreme | Standard HDD, Standard SSD, Premium SSD, Ultra Disk |
| **Max Volume Size** | 64 TB (io2), 16 TB (gp3, gp2) | 64 TB | 32 TB (Standard), 64 TB (Premium, Ultra) |
| **Max IOPS** | 256,000 (io2 Block Express) | 100,000 (Extreme) | 160,000 (Ultra), 20,000 (Premium) |
| **Max Throughput** | 4,000 MB/s | 2,400 MB/s | 2,000 MB/s (Ultra), 900 MB/s (Premium) |
| **Snapshots** | Incremental, stored in S3 | Incremental, multi-regional | Incremental, stored in Blob Storage |
| **Encryption** | Yes (KMS) | Yes (default, CMEK) | Yes (platform-managed, customer-managed) |
| **Multi-attach** | Yes (io1, io2 only, limited) | Yes (read-only mode) | Yes (Premium SSD, Ultra Disk, limited) |
| **Availability** | Single AZ | Single zone or regional (replicated) | Single zone or zone-redundant (ZRS) |
| **Backup** | EBS Snapshots, AWS Backup | Snapshots, persistent disk images | Azure Backup, snapshots |
| **Performance Scaling** | Independent IOPS/throughput (gp3, io2) | Based on disk size | Independent IOPS/throughput (Ultra) |
| **Bursting** | Yes (gp2, gp3) | No | Yes (Standard SSD, Premium SSD) |

**Documentation:**
- **[📖 AWS EBS Documentation](https://docs.aws.amazon.com/ebs/)** - Complete EBS guide
- **[📖 GCP Persistent Disks Documentation](https://cloud.google.com/compute/docs/disks)** - Persistent Disks guide
- **[📖 Azure Managed Disks Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview)** - Managed Disks guide
- **[📖 EBS Volume Types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html)** - AWS volume comparison
- **[📖 Persistent Disk Types](https://cloud.google.com/compute/docs/disks/disk-types)** - GCP disk comparison
- **[📖 Azure Disk Types](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types)** - Azure disk comparison

---

## File Storage (Network File Systems)

| Feature | AWS EFS | GCP Filestore | Azure Files |
|---------|---------|--------------|-------------|
| **Service Name** | EFS (Elastic File System) | Filestore | Azure Files |
| **Protocol** | NFSv4.1 | NFSv3 | SMB 3.0, NFS 4.1 |
| **Performance Modes** | General Purpose, Max I/O | Basic, High Scale, Enterprise | Standard, Premium |
| **Throughput Modes** | Bursting, Provisioned, Elastic | Based on capacity | Based on share size |
| **Max Size** | Unlimited (petabytes) | 100 TB (Enterprise) | 100 TB per share |
| **Max Throughput** | 10 GB/s+ (Elastic) | 10 GB/s (Enterprise) | 10 GB/s (Premium) |
| **Encryption** | Yes (at rest, in transit) | Yes (at rest, in transit) | Yes (at rest, in transit) |
| **Availability** | Multi-AZ (Regional), One Zone | Single zone, regional | LRS, ZRS, GRS |
| **Lifecycle Management** | Yes (IA storage class) | Yes (snapshots) | Yes (soft delete, snapshots) |
| **Access Control** | POSIX permissions, IAM | POSIX permissions, IAM | NTFS ACLs, RBAC |
| **Backup** | AWS Backup, snapshots | Backups (automated/on-demand) | Azure Backup, snapshots |
| **Concurrent Connections** | 1000s of clients | 1000s of clients | 2000+ SMB connections |
| **Use Cases** | Linux workloads, containers, Lambda | GKE, Compute Engine, high-performance | Windows/Linux, hybrid, containers |
| **Integration** | Direct mount on EC2, Lambda, ECS, EKS | Direct mount on GCE, GKE | Direct mount on VMs, AKS, on-premises |

**Documentation:**
- **[📖 AWS EFS Documentation](https://docs.aws.amazon.com/efs/)** - Complete EFS guide
- **[📖 GCP Filestore Documentation](https://cloud.google.com/filestore/docs)** - Filestore guide
- **[📖 Azure Files Documentation](https://learn.microsoft.com/en-us/azure/storage/files/)** - Azure Files guide
- **[📖 EFS Performance](https://docs.aws.amazon.com/efs/latest/ug/performance.html)** - EFS performance guide
- **[📖 Azure Files Premium](https://learn.microsoft.com/en-us/azure/storage/files/understanding-billing#provisioned-model)** - Premium tier details

---

## Archive Storage

| Feature | AWS S3 Glacier | GCP Archive Storage | Azure Archive Blob |
|---------|---------------|-------------------|-------------------|
| **Service Types** | Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier Deep Archive | Archive storage class | Archive access tier |
| **Retrieval Time** | Instant to 48 hours | Immediate | 1-15 hours (rehydration required) |
| **Min Storage Duration** | 90-180 days | 365 days | 180 days |
| **Durability** | 11 9's | 11 9's | 11 9's |
| **Retrieval Options** | Expedited, Standard, Bulk | Standard (immediate) | High priority, Standard |
| **Use Case** | Long-term backup, compliance archives, digital preservation | Annual access, compliance, digital assets | Long-term backup, compliance, cold data |
| **Pricing (Storage/GB/month)** | $0.0036 (Flexible) - $0.00099 (Deep Archive) | $0.0012 | $0.002 |
| **Retrieval Pricing** | Per GB + per request | Per GB | Per GB (rehydration) |
| **Vault Lock** | Yes (compliance mode) | Retention policies | Immutable storage policies |

**Documentation:**
- **[📖 AWS Glacier Documentation](https://docs.aws.amazon.com/glacier/)** - Glacier service guide
- **[📖 S3 Glacier Storage Classes](https://aws.amazon.com/s3/storage-classes/glacier/)** - Glacier class comparison
- **[📖 GCP Archive Storage](https://cloud.google.com/storage/docs/storage-classes#archive)** - Archive class details
- **[📖 Azure Archive Blob](https://learn.microsoft.com/en-us/azure/storage/blobs/archive-blob-rehydration)** - Archive tier guide

---

## Data Transfer Services

| Feature | AWS | GCP | Azure |
|---------|-----|-----|-------|
| **Online Transfer** | DataSync, Transfer Family | Storage Transfer Service | AzCopy, Storage Data Movement Library |
| **Offline Transfer (Small)** | Snowcone (8-14 TB) | Transfer Appliance (40-200 TB) | Data Box (40-80 TB) |
| **Offline Transfer (Large)** | Snowball (50-80 TB), Snowball Edge (80 TB) | Transfer Appliance TA480 (480 TB) | Data Box Heavy (800 TB) |
| **Offline Transfer (Massive)** | Snowmobile (100 PB) | N/A | Data Box (multiple shipments) |
| **Edge Computing Device** | Snowball Edge, Outposts | Distributed Cloud Edge | Azure Stack Edge |
| **Database Migration** | DMS (Database Migration Service) | Database Migration Service | Azure Database Migration Service |
| **Network Transfer** | Direct Connect, VPN | Cloud Interconnect, VPN | ExpressRoute, VPN |
| **Transfer Acceleration** | S3 Transfer Acceleration | Global load balancing | CDN, Front Door |
| **Command-Line Tools** | AWS CLI, aws s3 sync | gsutil, gcloud storage | AzCopy, az storage |

**Documentation:**
- **[📖 AWS DataSync Documentation](https://docs.aws.amazon.com/datasync/)** - DataSync service guide
- **[📖 AWS Snow Family](https://aws.amazon.com/snow/)** - Offline transfer devices
- **[📖 GCP Storage Transfer Service](https://cloud.google.com/storage-transfer-service/docs)** - Transfer service guide
- **[📖 Azure Data Transfer Options](https://learn.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution)** - Transfer solutions comparison
- **[📖 Azure Data Box](https://learn.microsoft.com/en-us/azure/databox/)** - Data Box family guide

---

## Backup Services

| Feature | AWS Backup | GCP Backup and DR | Azure Backup |
|---------|-----------|------------------|-------------|
| **Supported Services** | EC2, EBS, RDS, DynamoDB, EFS, FSx, S3, DocumentDB, Neptune, Storage Gateway | Compute Engine, GKE, Cloud SQL, Filestore, Cloud Storage | VMs, Managed Disks, Azure Files, SQL Server, SAP HANA, Blob Storage |
| **Backup Frequency** | Scheduled (hourly to yearly) | Scheduled (configurable) | Scheduled (multiple times daily) |
| **Backup Types** | Full, incremental, continuous (some services) | Full, incremental | Full, differential, incremental |
| **Retention** | Days to years, custom policies | Days to years, custom policies | Days to years (up to 10 years for VMs) |
| **Cross-Region Backup** | Yes | Yes | Yes |
| **Backup Vault** | Yes (isolated, encrypted) | Yes | Yes (Recovery Services Vault) |
| **Point-in-Time Recovery** | Yes (for supported services) | Yes (for databases) | Yes (for databases) |
| **Compliance** | HIPAA, PCI DSS, SOC | SOC 2, ISO 27001 | HIPAA, PCI DSS, SOC, ISO |
| **Encryption** | Yes (KMS) | Yes (default) | Yes (Microsoft-managed, customer-managed) |
| **Monitoring** | CloudWatch, SNS | Cloud Monitoring | Azure Monitor, alerts |
| **Cost** | Storage + restore | Storage + operations | Storage + protected instances |

**Documentation:**
- **[📖 AWS Backup Documentation](https://docs.aws.amazon.com/aws-backup/)** - AWS Backup guide
- **[📖 GCP Backup and DR Documentation](https://cloud.google.com/backup-disaster-recovery/docs)** - GCP Backup guide
- **[📖 Azure Backup Documentation](https://learn.microsoft.com/en-us/azure/backup/)** - Azure Backup guide

---

## Lifecycle Policies

### AWS S3 Lifecycle Rules

```json
{
  "Rules": [
    {
      "Id": "Archive old logs",
      "Status": "Enabled",
      "Filter": {
        "Prefix": "logs/"
      },
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER_IR"
        },
        {
          "Days": 365,
          "StorageClass": "DEEP_ARCHIVE"
        }
      ],
      "Expiration": {
        "Days": 2555
      }
    }
  ]
}
```

### GCP Cloud Storage Lifecycle Configuration

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "NEARLINE"
        },
        "condition": {
          "age": 30,
          "matchesPrefix": ["logs/"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "COLDLINE"
        },
        "condition": {
          "age": 90
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "ARCHIVE"
        },
        "condition": {
          "age": 365
        }
      },
      {
        "action": {
          "type": "Delete"
        },
        "condition": {
          "age": 2555
        }
      }
    ]
  }
}
```

### Azure Blob Lifecycle Management

```json
{
  "rules": [
    {
      "enabled": true,
      "name": "archive-old-logs",
      "type": "Lifecycle",
      "definition": {
        "filters": {
          "blobTypes": ["blockBlob"],
          "prefixMatch": ["logs/"]
        },
        "actions": {
          "baseBlob": {
            "tierToCool": {
              "daysAfterModificationGreaterThan": 30
            },
            "tierToCold": {
              "daysAfterModificationGreaterThan": 90
            },
            "tierToArchive": {
              "daysAfterModificationGreaterThan": 365
            },
            "delete": {
              "daysAfterModificationGreaterThan": 2555
            }
          }
        }
      }
    }
  ]
}
```

---

## Pricing Comparison (Approximate US Regions)

### Object Storage Pricing per GB/Month

| Storage Class | AWS S3 | GCP Cloud Storage | Azure Blob |
|--------------|--------|------------------|------------|
| **Standard/Hot** | $0.023 | $0.020 (regional), $0.026 (multi-region) | $0.018 (LRS), $0.045 (GRS) |
| **Infrequent Access** | $0.0125 (Standard-IA) | $0.010 (Nearline) | $0.01 (Cool) |
| **Cold/Coldline** | $0.004 (Glacier Instant) | $0.004 (Coldline) | $0.0036 (Cold) |
| **Archive** | $0.0036 (Glacier Flexible), $0.00099 (Deep Archive) | $0.0012 (Archive) | $0.002 (Archive) |

### Block Storage Pricing per GB/Month

| Storage Type | AWS EBS | GCP Persistent Disk | Azure Managed Disk |
|-------------|---------|-------------------|-------------------|
| **Standard HDD** | $0.045 (sc1) | $0.040 | $0.03 |
| **Standard SSD** | $0.10 (gp3) | $0.17 (Balanced) | $0.075 |
| **Premium SSD** | $0.125 (io2) | $0.35 (Extreme) | $0.135 |
| **Provisioned IOPS** | +$0.065 per IOPS/month (io2) | Included | +$0.002 per IOPS/month (Ultra) |

### File Storage Pricing per GB/Month

| Performance Tier | AWS EFS | GCP Filestore | Azure Files |
|-----------------|---------|--------------|-------------|
| **Standard** | $0.30 (Standard), $0.025 (IA) | $0.20 (Basic) | $0.06 (Transaction Optimized) |
| **Premium** | N/A | $0.30 (High Scale), $0.35 (Enterprise) | $0.20 (Premium) |

*Note: Prices vary by region and are subject to change. Always use official pricing calculators.*

**Pricing Calculators:**
- **[📖 AWS Pricing Calculator](https://calculator.aws/)** - AWS cost estimates
- **[📖 GCP Pricing Calculator](https://cloud.google.com/products/calculator)** - GCP cost estimates
- **[📖 Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)** - Azure cost estimates

---

## CLI Command Comparison

### Object Storage - Upload Files

**AWS S3:**
```bash
# Upload single file
aws s3 cp myfile.txt s3://mybucket/myfile.txt

# Upload directory recursively
aws s3 sync ./localdir s3://mybucket/remote-dir/

# Upload with storage class
aws s3 cp myfile.txt s3://mybucket/myfile.txt --storage-class GLACIER_IR

# Upload with encryption
aws s3 cp myfile.txt s3://mybucket/myfile.txt --server-side-encryption aws:kms
```

**GCP Cloud Storage:**
```bash
# Upload single file
gsutil cp myfile.txt gs://mybucket/myfile.txt

# Upload directory recursively
gsutil -m rsync -r ./localdir gs://mybucket/remote-dir/

# Upload with storage class
gsutil -h "x-goog-storage-class:NEARLINE" cp myfile.txt gs://mybucket/myfile.txt

# Upload with encryption
gsutil -o "GSUtil:encryption_key=YOUR_KEY" cp myfile.txt gs://mybucket/myfile.txt
```

**Azure Blob Storage:**
```bash
# Upload single file
az storage blob upload \
  --account-name mystorageaccount \
  --container-name mycontainer \
  --name myfile.txt \
  --file myfile.txt

# Upload directory recursively
azcopy copy './localdir/*' \
  'https://mystorageaccount.blob.core.windows.net/mycontainer' \
  --recursive

# Upload with access tier
az storage blob upload \
  --account-name mystorageaccount \
  --container-name mycontainer \
  --name myfile.txt \
  --file myfile.txt \
  --tier Cool

# Upload with encryption scope
az storage blob upload \
  --account-name mystorageaccount \
  --container-name mycontainer \
  --name myfile.txt \
  --file myfile.txt \
  --encryption-scope myencryptionscope
```

### Object Storage - List and Download

**AWS S3:**
```bash
# List buckets
aws s3 ls

# List objects in bucket
aws s3 ls s3://mybucket/prefix/

# Download file
aws s3 cp s3://mybucket/myfile.txt ./myfile.txt

# Download directory
aws s3 sync s3://mybucket/remote-dir/ ./localdir/
```

**GCP Cloud Storage:**
```bash
# List buckets
gsutil ls

# List objects in bucket
gsutil ls gs://mybucket/prefix/

# Download file
gsutil cp gs://mybucket/myfile.txt ./myfile.txt

# Download directory
gsutil -m rsync -r gs://mybucket/remote-dir/ ./localdir/
```

**Azure Blob Storage:**
```bash
# List containers
az storage container list --account-name mystorageaccount

# List blobs in container
az storage blob list \
  --account-name mystorageaccount \
  --container-name mycontainer

# Download file
az storage blob download \
  --account-name mystorageaccount \
  --container-name mycontainer \
  --name myfile.txt \
  --file ./myfile.txt

# Download directory
azcopy copy \
  'https://mystorageaccount.blob.core.windows.net/mycontainer/*' \
  './localdir/' \
  --recursive
```

### Block Storage - Create and Attach Volumes

**AWS EBS:**
```bash
# Create volume
aws ec2 create-volume \
  --availability-zone us-east-1a \
  --size 100 \
  --volume-type gp3 \
  --iops 3000 \
  --throughput 125

# Attach volume to instance
aws ec2 attach-volume \
  --volume-id vol-xxxxx \
  --instance-id i-xxxxx \
  --device /dev/sdf

# Create snapshot
aws ec2 create-snapshot \
  --volume-id vol-xxxxx \
  --description "My snapshot"
```

**GCP Persistent Disks:**
```bash
# Create disk
gcloud compute disks create mydisk \
  --size 100GB \
  --type pd-ssd \
  --zone us-central1-a

# Attach disk to instance
gcloud compute instances attach-disk myinstance \
  --disk mydisk \
  --zone us-central1-a

# Create snapshot
gcloud compute disks snapshot mydisk \
  --snapshot-names my-snapshot \
  --zone us-central1-a
```

**Azure Managed Disks:**
```bash
# Create disk
az disk create \
  --resource-group myResourceGroup \
  --name myDisk \
  --size-gb 100 \
  --sku Premium_LRS

# Attach disk to VM
az vm disk attach \
  --resource-group myResourceGroup \
  --vm-name myVM \
  --name myDisk

# Create snapshot
az snapshot create \
  --resource-group myResourceGroup \
  --name mySnapshot \
  --source myDisk
```

### File Storage - Create and Mount

**AWS EFS:**
```bash
# Create file system
aws efs create-file-system \
  --performance-mode generalPurpose \
  --throughput-mode elastic \
  --encrypted

# Create mount target
aws efs create-mount-target \
  --file-system-id fs-xxxxx \
  --subnet-id subnet-xxxxx \
  --security-groups sg-xxxxx

# Mount on Linux
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
  fs-xxxxx.efs.us-east-1.amazonaws.com:/ /mnt/efs
```

**GCP Filestore:**
```bash
# Create Filestore instance
gcloud filestore instances create myfilestore \
  --zone=us-central1-a \
  --tier=BASIC_HDD \
  --file-share=name="vol1",capacity=1TB \
  --network=name="default"

# Mount on Linux
sudo mount -t nfs -o vers=3 \
  10.x.x.x:/vol1 /mnt/filestore
```

**Azure Files:**
```bash
# Create storage account (if not exists)
az storage account create \
  --resource-group myResourceGroup \
  --name mystorageaccount \
  --sku Standard_LRS

# Create file share
az storage share create \
  --account-name mystorageaccount \
  --name myfileshare \
  --quota 100

# Mount on Linux
sudo mount -t cifs \
  //mystorageaccount.file.core.windows.net/myfileshare /mnt/azfiles \
  -o vers=3.0,username=mystorageaccount,password=STORAGE_KEY,dir_mode=0777,file_mode=0777
```

---

## Decision Tree: Which Storage Service?

### When to Use Object Storage
- ✅ Unstructured data (images, videos, logs, backups)
- ✅ Static website hosting
- ✅ Data lakes and big data analytics
- ✅ Long-term archival
- ✅ Content distribution
- ✅ Need unlimited scaling
- ❌ Frequent small updates (not block-level updates)
- ❌ Need POSIX file system semantics

**Choose:**
- **S3/Cloud Storage/Blob Storage** for general object storage
- **Glacier/Archive** for long-term, infrequent access

### When to Use Block Storage
- ✅ Database storage (MySQL, PostgreSQL, SQL Server)
- ✅ High-performance applications
- ✅ Transactional workloads
- ✅ Need low-latency, high IOPS
- ✅ Boot volumes for VMs
- ✅ Specific IOPS/throughput requirements
- ❌ Need to share storage across multiple VMs (use file storage instead)
- ❌ Massive scale-out (object storage is better)

**Choose:**
- **Premium SSD/io2/Extreme** for databases, high-performance apps
- **Standard SSD/gp3/Balanced** for general-purpose workloads
- **Standard HDD** for infrequent access, throughput-focused workloads

### When to Use File Storage
- ✅ Shared file system across multiple VMs
- ✅ Lift-and-shift applications expecting NFS/SMB
- ✅ Container persistent storage (Kubernetes)
- ✅ Content management systems
- ✅ Home directories
- ✅ Development environments
- ❌ High IOPS database workloads (use block storage)
- ❌ Object-based data lakes (use object storage)

**Choose:**
- **EFS/Filestore/Azure Files Standard** for general shared storage
- **Azure Files Premium/Filestore Enterprise** for high-performance scenarios

### Storage Class Selection Decision Flow

```
Is data accessed frequently (daily)?
├─ YES → Standard/Hot tier
└─ NO → Is it accessed monthly?
    ├─ YES → Infrequent Access tier (S3 IA / Nearline / Cool)
    └─ NO → Is it accessed quarterly?
        ├─ YES → Cold tier (Coldline / Cold / Glacier Instant)
        └─ NO → Is it accessed yearly or less?
            ├─ YES → Archive tier (Archive / Glacier Flexible)
            └─ NO → Deep Archive (Glacier Deep Archive)
```

### Replication and Redundancy Decision

```
How critical is your data?
├─ BUSINESS CRITICAL → Need multiple regions?
│   ├─ YES → Multi-region replication (S3 CRR / Multi-region / GRS)
│   └─ NO → Multi-zone within region (S3 Standard / Standard / ZRS)
└─ LESS CRITICAL → Single zone acceptable?
    ├─ YES → Single zone (S3 One Zone-IA / Regional / LRS)
    └─ NO → Use multi-zone standard options
```

### Backup Strategy Selection

```
What are you backing up?
├─ Virtual Machines → AWS Backup / GCP Backup / Azure Backup
├─ Databases → Native DB backups + service backup
├─ File Systems → EFS Backup / Filestore Backup / Azure Files Backup
├─ Application Data → Object storage with versioning + lifecycle
└─ Long-term Compliance → Archive storage with object lock/retention policies
```

---

## Advanced Features Comparison

### Data Replication Options

| Feature | AWS | GCP | Azure |
|---------|-----|-----|-------|
| **Same-Region Replication** | S3 Same-Region Replication (SRR) | Regional buckets (default) | LRS (Locally Redundant Storage) |
| **Cross-Region Replication** | S3 Cross-Region Replication (CRR) | Dual-region, Multi-region buckets | GRS (Geo-Redundant Storage) |
| **Read Access from Secondary** | N/A (automatic failover) | Multi-region (read from any) | RA-GRS (Read-Access Geo-Redundant) |
| **Multi-Region Active-Active** | S3 Multi-Region Access Points | Multi-region buckets | GZRS (Geo-Zone-Redundant Storage) |
| **Replication Time Control** | S3 Replication Time Control (RTC) | N/A | N/A |

### Object Versioning and Protection

| Feature | AWS S3 | GCP Cloud Storage | Azure Blob Storage |
|---------|--------|------------------|-------------------|
| **Versioning** | Yes | Yes | Yes |
| **Object Lock (WORM)** | Yes (Governance, Compliance modes) | Retention policies | Immutable storage (time-based, legal hold) |
| **MFA Delete** | Yes | N/A | N/A |
| **Soft Delete** | N/A | Soft delete (configurable retention) | Soft delete (configurable retention) |
| **Point-in-Time Restore** | N/A | N/A | Yes (for containers) |

### Access Control and Security

| Feature | AWS S3 | GCP Cloud Storage | Azure Blob Storage |
|---------|--------|------------------|-------------------|
| **IAM Integration** | AWS IAM | Cloud IAM | Azure RBAC |
| **Bucket/Container Policies** | Bucket policies | Bucket-level IAM | Container-level policies |
| **Access Control Lists** | ACLs (legacy) | ACLs (legacy) | N/A |
| **Temporary Access** | Presigned URLs | Signed URLs | SAS (Shared Access Signatures) |
| **Public Access Block** | Yes (account, bucket level) | Yes (bucket level) | Yes (account level) |
| **Access Analyzer** | S3 Access Analyzer (IAM Access Analyzer) | Policy Analyzer | N/A |
| **Encryption at Rest** | SSE-S3, SSE-KMS, SSE-C | Google-managed, CMEK, CSEK | Microsoft-managed, customer-managed |
| **Encryption in Transit** | TLS/SSL | TLS/SSL | TLS/SSL |

### Performance Optimization

| Feature | AWS S3 | GCP Cloud Storage | Azure Blob Storage |
|---------|--------|------------------|-------------------|
| **Transfer Acceleration** | S3 Transfer Acceleration | Global load balancing | CDN, Front Door |
| **Multipart Upload** | Yes (5 MB - 5 GB parts) | Yes (8 MB+ recommended) | Yes (4 MB blocks) |
| **Parallel Downloads** | Byte-range fetches | Byte-range fetches | Byte-range fetches |
| **Request Rate** | 3,500 PUT/COPY/POST/DELETE, 5,500 GET/HEAD per prefix/second | N/A (no documented limits) | 20,000 requests/second per blob |
| **Prefix Strategy** | Automatic partitioning | N/A | N/A |

---

## Real-World Use Cases and Recommendations

### Static Website Hosting

**AWS S3:**
```bash
# Enable static website hosting
aws s3 website s3://mybucket --index-document index.html --error-document error.html

# Set bucket policy for public read
aws s3api put-bucket-policy --bucket mybucket --policy file://policy.json
```

**GCP Cloud Storage:**
```bash
# Enable static website hosting
gsutil web set -m index.html -e 404.html gs://mybucket

# Make bucket publicly readable
gsutil iam ch allUsers:objectViewer gs://mybucket
```

**Azure Blob Storage:**
```bash
# Enable static website hosting
az storage blob service-properties update \
  --account-name mystorageaccount \
  --static-website \
  --index-document index.html \
  --404-document 404.html
```

### Data Lake Architecture

**Recommended Storage:**
- **Raw Data Layer**: S3 Standard / Cloud Storage Standard / Hot Blob Storage
- **Processed Data Layer**: S3 Intelligent-Tiering / Cloud Storage Standard / Hot/Cool Blob
- **Archived Data**: S3 Glacier / Archive Storage / Archive Blob

**Best Practices:**
1. Use lifecycle policies to automatically transition data between tiers
2. Partition data by date/time for efficient querying
3. Enable versioning for data lineage
4. Use encryption at rest and in transit
5. Implement proper IAM policies for data access

### Database Backup Strategy

**AWS:**
```bash
# Automated RDS backups (configured at creation)
# Manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier mydb \
  --db-snapshot-identifier mydb-snapshot-2024-01-15

# Copy to another region
aws rds copy-db-snapshot \
  --source-db-snapshot-identifier arn:aws:rds:us-east-1:123456789012:snapshot:mydb-snapshot \
  --target-db-snapshot-identifier mydb-snapshot-copy \
  --region us-west-2
```

**GCP:**
```bash
# Automated Cloud SQL backups (configured at creation)
# On-demand backup
gcloud sql backups create \
  --instance myinstance

# Export to Cloud Storage
gcloud sql export sql myinstance gs://mybucket/backup.sql \
  --database mydatabase
```

**Azure:**
```bash
# Automated SQL Database backups (default enabled)
# Long-term retention policy
az sql db ltr-policy set \
  --resource-group myResourceGroup \
  --server myserver \
  --database mydb \
  --weekly-retention P4W \
  --monthly-retention P12M \
  --yearly-retention P5Y \
  --week-of-year 1
```

### Video/Media Storage and Streaming

**Recommended Architecture:**
1. **Upload**: Object storage (S3/Cloud Storage/Blob) with multipart upload
2. **Processing**: Serverless functions or batch processing
3. **Transcoding**: AWS Elemental MediaConvert / GCP Transcoder API / Azure Media Services
4. **Storage**: Different quality levels in different storage classes
5. **Delivery**: CloudFront / Cloud CDN / Azure CDN
6. **Archive**: Glacier/Archive for old content

**Cost Optimization:**
- Use Intelligent-Tiering for unpredictable access patterns
- Enable lifecycle policies to archive old content
- Use CDN to reduce origin requests and egress costs

---

## Key Takeaways

### AWS Storage Strengths
- ✅ Most comprehensive storage options (10+ S3 storage classes)
- ✅ S3 Glacier Deep Archive (lowest cost archival)
- ✅ Mature ecosystem with extensive third-party integrations
- ✅ Storage Lens for usage analytics
- ✅ Best for hybrid cloud (Storage Gateway, DataSync, Snow Family)
- ✅ S3 Intelligent-Tiering for automatic cost optimization

### GCP Storage Strengths
- ✅ Simplest storage class model (4 classes)
- ✅ No retrieval delays for Archive storage (immediate access)
- ✅ Consistent pricing across regions
- ✅ Strong integration with BigQuery for analytics
- ✅ Autoclass for automatic tier management
- ✅ Best global network performance

### Azure Storage Strengths
- ✅ Best Windows/SMB integration (Azure Files)
- ✅ Flexible redundancy options (LRS, ZRS, GRS, RA-GRS, GZRS, RA-GZRS)
- ✅ Strong hybrid cloud story (Azure Stack, Azure Arc)
- ✅ Immutable storage with legal hold support
- ✅ Premium performance tiers for file storage
- ✅ Point-in-Time Restore for containers

---

## Performance Benchmarks (Approximate)

### Object Storage Latency

| Operation | AWS S3 | GCP Cloud Storage | Azure Blob Storage |
|-----------|--------|------------------|-------------------|
| **PUT (1 MB object)** | 50-100 ms | 50-100 ms | 50-100 ms |
| **GET (1 MB object)** | 10-50 ms | 10-50 ms | 10-50 ms |
| **LIST (1000 objects)** | 100-200 ms | 100-200 ms | 100-200 ms |
| **DELETE** | 10-30 ms | 10-30 ms | 10-30 ms |

### Block Storage IOPS

| Disk Type | AWS EBS | GCP Persistent Disk | Azure Managed Disk |
|-----------|---------|-------------------|-------------------|
| **Standard SSD** | 16,000 (gp3) | 15,000 (Balanced) | 6,000 (Standard SSD) |
| **Premium SSD** | 64,000 (io2) | 100,000 (Extreme) | 20,000 (Premium SSD) |
| **Ultra Performance** | 256,000 (io2 Block Express) | N/A | 160,000 (Ultra Disk) |

*Note: Performance varies based on disk size, VM type, and configuration.*

---

## Migration Strategies

### AWS to GCP Migration

```bash
# Use Storage Transfer Service
# 1. Create Cloud Storage bucket
gsutil mb gs://mybucket

# 2. Create transfer job (via console or API)
# Alternatively, use gsutil for one-time migration
gsutil -m rsync -r s3://aws-bucket gs://gcp-bucket
```

### GCP to Azure Migration

```bash
# Use AzCopy
azcopy copy \
  'https://storage.googleapis.com/gcp-bucket/*' \
  'https://mystorageaccount.blob.core.windows.net/azure-container' \
  --recursive
```

### AWS to Azure Migration

```bash
# Use AzCopy with S3-compatible source
azcopy copy \
  'https://mybucket.s3.amazonaws.com/*' \
  'https://mystorageaccount.blob.core.windows.net/azure-container' \
  --recursive \
  --s3-source-secret-key 'YOUR_AWS_SECRET_KEY'
```

### Best Practices for Migration
1. **Test first**: Migrate small dataset to validate process
2. **Use parallel transfers**: Enable multi-threading for faster transfers
3. **Monitor progress**: Set up logging and monitoring
4. **Verify data integrity**: Compare checksums after migration
5. **Plan for downtime**: Schedule during low-usage periods if applicable
6. **Update applications**: Change SDK/API endpoints
7. **Test thoroughly**: Validate application functionality post-migration

---

## Cost Optimization Tips

### Storage Cost Reduction Strategies

1. **Implement Lifecycle Policies**
   - Automatically transition data to cheaper storage classes
   - Delete temporary or expired data automatically
   - Review and optimize policies quarterly

2. **Choose Right Storage Class**
   - Don't over-provision for infrequent access patterns
   - Use Intelligent-Tiering/Autoclass for unpredictable patterns
   - Archive data that's rarely accessed

3. **Optimize Data Transfer**
   - Use CDN to reduce origin requests
   - Enable compression where possible
   - Keep data and compute in same region
   - Use VPC endpoints/Private Link to avoid internet egress charges

4. **Right-Size Block Storage**
   - Don't over-provision disk size or IOPS
   - Use gp3/Balanced disks for predictable, adjustable performance
   - Delete unused snapshots and unattached volumes
   - Use Reserved Capacity for long-term commitments

5. **Monitor and Analyze**
   - Use S3 Storage Lens / Cloud Storage Insights / Storage Analytics
   - Set up cost alerts and budgets
   - Regular storage audits to identify optimization opportunities

6. **Data Deduplication and Compression**
   - Implement deduplication at application level
   - Use compression before storing (when retrieval speed isn't critical)
   - Consider object storage for compressed archives

---

## Compliance and Security

### Compliance Certifications (All Three Providers)

- SOC 1, 2, 3
- ISO 27001, 27017, 27018
- PCI DSS Level 1
- HIPAA
- FedRAMP (various levels)
- GDPR compliant

### Security Best Practices

1. **Enable Encryption**
   - At rest: Always enable (minimal performance impact)
   - In transit: Use HTTPS/TLS for all connections
   - Consider customer-managed keys for sensitive data

2. **Implement Least Privilege Access**
   - Use IAM roles and policies
   - Regular access reviews
   - Enable MFA for sensitive operations

3. **Enable Logging and Monitoring**
   - CloudTrail / Cloud Audit Logs / Azure Monitor
   - Object access logging
   - Set up alerts for suspicious activities

4. **Use Object Locking for Compliance**
   - WORM (Write Once Read Many) for regulatory requirements
   - Retention policies for data preservation
   - Legal hold capabilities

5. **Regular Backups and Testing**
   - Automated backup schedules
   - Test restore procedures quarterly
   - Cross-region backup copies for DR

6. **Network Security**
   - Use private endpoints when possible
   - Restrict public access
   - Enable bucket/container-level firewalls

---

**Related Guides:**
- [Compute Service Comparison](./service-comparison-compute.md)
- [Database Service Comparison](./service-comparison-databases.md)
- [Networking Service Comparison](./service-comparison-networking.md)
