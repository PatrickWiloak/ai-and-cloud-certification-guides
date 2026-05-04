---
last-updated: 2026-05-03
---

# Three-Tier Web Application Architecture

A comprehensive guide to implementing scalable, highly available three-tier web applications across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Security Considerations](#security-considerations)
8. [High Availability and Disaster Recovery](#high-availability-and-disaster-recovery)
9. [Performance Optimization](#performance-optimization)
10. [Cost Estimates](#cost-estimates)
11. [Deployment Strategies](#deployment-strategies)
12. [Monitoring and Logging](#monitoring-and-logging)
13. [Best Practices](#best-practices)
14. [Common Pitfalls](#common-pitfalls)

---

## Architecture Overview

### What is Three-Tier Architecture?

Three-tier architecture is a client-server software architecture pattern that separates applications into three logical and physical computing tiers:

1. **Presentation Tier (Web Tier)**: User interface and client-side logic
2. **Application Tier (Logic Tier)**: Business logic and application processing
3. **Data Tier (Database Tier)**: Data storage and management

### Benefits

- **Separation of Concerns**: Each tier has a specific role and responsibility
- **Scalability**: Scale tiers independently based on demand
- **Maintainability**: Update one tier without affecting others
- **Security**: Apply security controls at each tier
- **Reusability**: Application tier can serve multiple presentation interfaces
- **Development Efficiency**: Teams can work on different tiers simultaneously

### Use Cases

- E-commerce websites
- Content management systems
- Customer relationship management (CRM) applications
- Enterprise resource planning (ERP) systems
- Social media platforms
- SaaS applications
- Banking and financial services applications

---

## Architecture Diagram Description

### Architecture (Mermaid - renders inline on GitHub)

```mermaid
flowchart TB
  Users((Users)) --> DNS[DNS / CDN]
  DNS --> ELB[External Load Balancer]
  subgraph Web[Presentation Tier]
    W1[Web Server 1]
    W2[Web Server 2]
    W3[Web Server N]
  end
  ELB --> W1
  ELB --> W2
  ELB --> W3
  Web --> ILB[Internal Load Balancer]
  subgraph App[Application Tier]
    A1[App Server 1]
    A2[App Server 2]
    A3[App Server N]
  end
  ILB --> A1
  ILB --> A2
  ILB --> A3
  App --> Cache[(Redis / Memcached)]
  App --> DB[(Primary Database)]
  DB -.replication.-> RR[(Read Replicas)]
  App --> RR
  DB --> Backup[(Backup / Archive)]
```

### High-Level Architecture (ASCII reference)

```
                         [Users/Internet]
                                |
                                |
                         [DNS/CDN Layer]
                                |
                                |
        +-------------------[Load Balancer]-------------------+
        |                                                     |
        |                                                     |
  [Web Server 1]  [Web Server 2]  [Web Server 3]  [Web Server N]
        |                                                     |
        |              PRESENTATION TIER                     |
        +-----------------------------------------------------+
                                |
                                |
        +-------------------[Load Balancer]-------------------+
        |                                                     |
        |                                                     |
  [App Server 1]  [App Server 2]  [App Server 3]  [App Server N]
        |                                                     |
        |              APPLICATION TIER                      |
        +-----------------------------------------------------+
                                |
                                |
        +-------------------[Database Cluster]---------------+
        |                                                     |
        |                                                     |
  [Primary DB]                                      [Read Replica(s)]
        |                                                     |
        |                  DATA TIER                         |
        +-----------------------------------------------------+
                                |
                                |
                         [Storage Layer]
```

### Network Segmentation

```
[Internet Gateway / External Access]
            |
    +-------+-------+
    |               |
[Public Subnet]  [Public Subnet]
    |               |
[Web Tier]      [Web Tier]
    |               |
    +-------+-------+
            |
    [Internal Load Balancer]
            |
    +-------+-------+
    |               |
[Private Subnet] [Private Subnet]
    |               |
[App Tier]      [App Tier]
    |               |
    +-------+-------+
            |
    +-------+-------+
    |               |
[Private Subnet] [Private Subnet]
    |               |
[DB Tier]       [DB Tier]
```

### Data Flow

1. User request arrives at DNS/CDN
2. Request routed to load balancer
3. Load balancer distributes to web servers
4. Web server processes static content, forwards dynamic requests
5. Application server executes business logic
6. Application server queries database
7. Database returns data
8. Application server processes and formats response
9. Web server renders response
10. Response sent back through load balancer to user

---

## Component Breakdown

### Presentation Tier Components

#### Web Servers
- **Purpose**: Serve static content, route dynamic requests
- **Technologies**: Nginx, Apache, IIS
- **Responsibilities**:
  - SSL/TLS termination
  - Static content delivery (HTML, CSS, JavaScript, images)
  - Request routing
  - Session management
  - Caching static assets

#### Content Delivery Network (CDN)
- **Purpose**: Accelerate content delivery globally
- **Responsibilities**:
  - Cache static assets at edge locations
  - Reduce latency for global users
  - Offload traffic from origin servers
  - DDoS protection

#### Load Balancer (External)
- **Purpose**: Distribute incoming traffic across web servers
- **Types**: Application Load Balancer (Layer 7)
- **Features**:
  - Health checks
  - SSL offloading
  - Path-based routing
  - Host-based routing
  - Sticky sessions

### Application Tier Components

#### Application Servers
- **Purpose**: Execute business logic
- **Technologies**: Node.js, Java (Tomcat), Python (Django/Flask), .NET, Go
- **Responsibilities**:
  - Business logic execution
  - Data validation
  - API endpoint handling
  - Third-party service integration
  - Background job processing

#### Load Balancer (Internal)
- **Purpose**: Distribute traffic from web tier to application servers
- **Types**: Network Load Balancer (Layer 4) or Application Load Balancer (Layer 7)
- **Features**:
  - Health monitoring
  - Connection pooling
  - Request distribution

#### Caching Layer
- **Purpose**: Reduce database load, improve response times
- **Technologies**: Redis, Memcached
- **Use Cases**:
  - Session storage
  - Query result caching
  - Object caching
  - Rate limiting data

### Data Tier Components

#### Primary Database
- **Purpose**: Store and manage application data
- **Types**:
  - Relational: PostgreSQL, MySQL, SQL Server, Oracle
  - NoSQL: MongoDB, Cassandra, DynamoDB
- **Responsibilities**:
  - Handle write operations
  - Maintain data integrity
  - Execute complex queries
  - Enforce constraints

#### Read Replicas
- **Purpose**: Scale read operations, improve performance
- **Features**:
  - Asynchronous replication from primary
  - Handle read-only queries
  - Reduce primary database load
  - Geographic distribution for global apps

#### Backup and Archive Storage
- **Purpose**: Data durability and recovery
- **Types**:
  - Automated backups
  - Point-in-time recovery
  - Long-term archive storage

---

## AWS Implementation

### Architecture Components

#### Network Layer
- **VPC**: Isolated network with CIDR block (e.g., 10.0.0.0/16)
- **Subnets**:
  - Public subnets (2+ AZs): 10.0.1.0/24, 10.0.2.0/24
  - Private app subnets (2+ AZs): 10.0.11.0/24, 10.0.12.0/24
  - Private DB subnets (2+ AZs): 10.0.21.0/24, 10.0.22.0/24
- **Internet Gateway**: Public internet access
- **NAT Gateway**: Outbound internet for private subnets (one per AZ)
- **Route Tables**: Separate for public and private subnets

#### Presentation Tier
- **CloudFront**: CDN for global content delivery
- **Route 53**: DNS management and routing
- **Application Load Balancer (ALB)**:
  - Internet-facing
  - Target groups for web instances
  - SSL/TLS termination
  - WAF integration
- **EC2 Auto Scaling Group**:
  - Instance type: t3.medium or larger
  - AMI: Amazon Linux 2 or Ubuntu with web server
  - User data script for configuration
  - Scaling policies based on CPU/memory
- **Alternative**: ECS Fargate for containerized web tier

#### Application Tier
- **Internal Application Load Balancer**:
  - Routes traffic from web to app tier
  - Health checks on application endpoints
- **EC2 Auto Scaling Group**:
  - Instance type: c5.large or larger (compute-optimized)
  - Security group: only allow traffic from web tier
  - IAM role for AWS service access
- **ElastiCache for Redis**:
  - Cluster mode enabled for scaling
  - Multi-AZ for high availability
  - Session storage and caching
- **Alternative**: ECS/EKS for containerized applications
- **Lambda**: For specific microservices or async processing

#### Data Tier
- **Amazon RDS**:
  - Engine: PostgreSQL, MySQL, or SQL Server
  - Multi-AZ deployment for HA
  - Instance class: db.r5.xlarge or appropriate size
  - Automated backups (7-35 day retention)
  - Encrypted at rest (KMS)
  - Read replicas (1-5 replicas)
  - Enhanced monitoring enabled
- **Amazon S3**:
  - User-generated content storage
  - Static assets backup
  - Database backup storage
  - Lifecycle policies for cost optimization
- **Amazon Aurora** (Alternative):
  - MySQL or PostgreSQL compatible
  - Superior performance and availability
  - Auto-scaling read replicas (up to 15)
  - Global database for multi-region

### Infrastructure as Code (AWS)

#### Terraform Example Structure

```hcl
# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "three-tier-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Application Load Balancer
resource "aws_lb" "web" {
  name               = "web-tier-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = true

  tags = {
    Name = "web-tier-alb"
  }
}

# Auto Scaling Group - Web Tier
resource "aws_autoscaling_group" "web" {
  name                = "web-tier-asg"
  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  min_size            = 2
  max_size            = 10
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

# RDS Database
resource "aws_db_instance" "main" {
  identifier              = "app-database"
  engine                  = "postgres"
  engine_version          = "14.7"
  instance_class          = "db.r5.xlarge"
  allocated_storage       = 100
  storage_encrypted       = true
  kms_key_id             = aws_kms_key.rds.arn
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true
  backup_retention_period = 7
  skip_final_snapshot    = false
  final_snapshot_identifier = "app-database-final-snapshot"

  tags = {
    Name = "main-database"
  }
}
```

### AWS Cost Breakdown

#### Compute (Web Tier)
- **EC2 Instances**: 4 x t3.medium (on-demand)
  - 4 vCPU, 4 GB RAM each
  - $0.0416/hour x 4 x 730 hours = $121.47/month
- **ALB**: $0.0225/hour + $0.008/LCU
  - ~$16.43 + ~$45/month (estimate) = $61.43/month
- **Data Transfer**: $0.09/GB out (estimate: 500GB) = $45/month

#### Compute (Application Tier)
- **EC2 Instances**: 4 x c5.large (compute-optimized)
  - 2 vCPU, 4 GB RAM each
  - $0.085/hour x 4 x 730 hours = $248.20/month
- **Internal ALB**: $0.0225/hour + LCU costs = ~$60/month
- **ElastiCache Redis**: cache.r5.large (2 nodes Multi-AZ)
  - $0.188/hour x 2 x 730 hours = $274.48/month

#### Database Tier
- **RDS PostgreSQL**: db.r5.xlarge Multi-AZ
  - $0.48/hour x 2 (Multi-AZ) x 730 hours = $700.80/month
- **Storage**: 100 GB SSD
  - $0.23/GB x 100 = $23/month
- **Backup Storage**: 100 GB (beyond free tier)
  - $0.095/GB x 100 = $9.50/month
- **Read Replica**: db.r5.large
  - $0.24/hour x 730 hours = $175.20/month

#### Storage and CDN
- **S3**: 1 TB storage + requests
  - $0.023/GB x 1024 = $23.55/month
- **CloudFront**: 1 TB data transfer out
  - $0.085/GB x 1024 = $87.04/month

#### Networking
- **NAT Gateway**: 2 gateways (Multi-AZ)
  - $0.045/hour x 2 x 730 hours = $65.70/month
  - Data processing: $0.045/GB x 500 GB = $22.50/month

#### Monitoring and Security
- **CloudWatch**: Logs + metrics
  - $10-20/month
- **AWS WAF**: Web ACL + rules
  - $5 + $1/rule x 5 = $10/month
- **Certificate Manager**: Free

**Total Estimated Monthly Cost (AWS): $1,943.87**

---

## Azure Implementation

### Architecture Components

#### Network Layer
- **Virtual Network (VNet)**: 10.0.0.0/16
- **Subnets**:
  - Web subnet: 10.0.1.0/24, 10.0.2.0/24 (two AZs)
  - App subnet: 10.0.11.0/24, 10.0.12.0/24
  - Database subnet: 10.0.21.0/24, 10.0.22.0/24
- **Network Security Groups (NSGs)**: Firewall rules per subnet
- **NAT Gateway**: Outbound internet for private subnets
- **Azure Bastion**: Secure RDP/SSH access

#### Presentation Tier
- **Azure Front Door**: Global CDN and load balancing
- **Azure DNS**: Domain management
- **Application Gateway**:
  - WAF enabled
  - SSL termination
  - Path-based routing
  - Autoscaling
- **Virtual Machine Scale Set (VMSS)**:
  - VM size: Standard_D2s_v3 or larger
  - Image: Ubuntu 20.04 or Windows Server
  - Autoscaling rules (CPU, memory, custom metrics)
  - Zones: Deployed across availability zones
- **Alternative**: Azure App Service (PaaS) for simplified management

#### Application Tier
- **Internal Load Balancer**: Routes traffic from web to app tier
- **Virtual Machine Scale Set**:
  - VM size: Standard_F4s_v2 (compute-optimized)
  - Managed identity for Azure service access
  - Custom script extension for app deployment
- **Azure Cache for Redis**:
  - Premium tier for VNet integration
  - Clustering enabled
  - Zone redundancy
- **Alternative**: Azure Kubernetes Service (AKS) for containerized apps
- **Azure Functions**: For serverless components

#### Data Tier
- **Azure Database for PostgreSQL/MySQL**:
  - Flexible Server tier
  - Zone-redundant HA
  - Compute: 4-8 vCores
  - Storage: 128 GB - 1 TB
  - Automated backups (7-35 days)
  - Read replicas for scaling
  - Encryption at rest and in transit
- **Azure SQL Database** (Alternative):
  - Business Critical tier for HA
  - Active geo-replication
  - Auto-tuning enabled
- **Azure Blob Storage**:
  - Hot tier for active data
  - Cool/Archive tiers for backups
  - Lifecycle management policies
  - Private endpoints for security

### Infrastructure as Code (Azure)

#### Terraform Example Structure

```hcl
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "three-tier-rg"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "three-tier-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Web Subnet
resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = "three-tier-appgw"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.web.id
  }

  # Additional configuration...
}

# Virtual Machine Scale Set - Web Tier
resource "azurerm_linux_virtual_machine_scale_set" "web" {
  name                = "web-vmss"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard_D2s_v3"
  instances           = 2
  admin_username      = "adminuser"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "web-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.web.id
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.main.backend_address_pool[0].id]
    }
  }

  zones = ["1", "2", "3"]
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "three-tier-postgres"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  version             = "14"

  administrator_login    = "psqladmin"
  administrator_password = random_password.db_password.result

  storage_mb   = 131072
  sku_name     = "GP_Standard_D4s_v3"
  zone         = "1"

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  backup_retention_days = 7
  geo_redundant_backup_enabled = true
}
```

### Azure Cost Breakdown

#### Compute (Web Tier)
- **VM Scale Set**: 4 x Standard_D2s_v3 (2 vCPU, 8 GB RAM)
  - $0.096/hour x 4 x 730 hours = $280.32/month
- **Application Gateway**: WAF_v2 tier
  - $0.443/hour x 730 hours = $323.39/month
  - Processing: $0.008/GB (estimate 500 GB) = $4/month
- **Data Transfer**: $0.087/GB out (estimate 500 GB) = $43.50/month

#### Compute (Application Tier)
- **VM Scale Set**: 4 x Standard_F4s_v2 (4 vCPU, 8 GB RAM)
  - $0.169/hour x 4 x 730 hours = $493.16/month
- **Internal Load Balancer**: Standard tier
  - $0.025/hour x 730 hours = $18.25/month
- **Azure Cache for Redis**: Premium P1 (6 GB)
  - $0.315/hour x 730 hours = $229.95/month

#### Database Tier
- **PostgreSQL Flexible Server**: GP_Standard_D4s_v3 (4 vCores)
  - $0.199/hour x 730 hours = $145.27/month
  - HA replica (zone redundant): +$145.27/month
- **Storage**: 128 GB
  - $0.115/GB x 128 = $14.72/month
- **Backup Storage**: 128 GB beyond free tier
  - $0.10/GB x 128 = $12.80/month
- **Read Replica**: GP_Standard_D2s_v3
  - $0.10/hour x 730 hours = $73/month

#### Storage and CDN
- **Blob Storage**: 1 TB Hot tier
  - $0.0184/GB x 1024 = $18.84/month
- **Azure Front Door**: Standard tier
  - $35/month base + $0.03/GB x 1024 = $65.72/month

#### Networking
- **NAT Gateway**: $0.045/hour x 730 hours = $32.85/month
  - Data processing: $0.045/GB x 500 GB = $22.50/month
- **VNet**: No charge for VNet itself

#### Monitoring and Security
- **Azure Monitor**: Logs + metrics
  - $15-25/month
- **Azure Bastion**: Standard tier
  - $0.19/hour x 730 hours = $138.70/month (optional)

**Total Estimated Monthly Cost (Azure): $2,067.24**
**(Without Bastion: $1,928.54)**

---

## GCP Implementation

### Architecture Components

#### Network Layer
- **VPC Network**: Custom mode VPC
- **Subnets**:
  - Web subnet: 10.0.1.0/24 (us-central1)
  - App subnet: 10.0.11.0/24 (us-central1)
  - Database subnet: 10.0.21.0/24 (us-central1)
- **Cloud NAT**: Outbound internet for private instances
- **Cloud Router**: BGP routing for Cloud NAT
- **Firewall Rules**: VPC firewall rules per tier

#### Presentation Tier
- **Cloud CDN**: Global content delivery
- **Cloud DNS**: Domain management
- **Cloud Load Balancing**:
  - External HTTP(S) Load Balancer
  - SSL certificates
  - Backend services with health checks
  - Cloud Armor for DDoS/WAF
- **Managed Instance Group (MIG)**:
  - Machine type: e2-medium or n2-standard-2
  - Base image: Ubuntu or Debian with web server
  - Autoscaling based on CPU, load balancer utilization
  - Multi-zone deployment
- **Alternative**: Cloud Run for containerized web tier (fully managed)

#### Application Tier
- **Internal HTTP(S) Load Balancer**: Routes from web to app tier
- **Managed Instance Group**:
  - Machine type: c2-standard-4 (compute-optimized)
  - Service account for GCP API access
  - Startup scripts for configuration
  - Health checks
- **Memorystore for Redis**:
  - Standard tier with HA
  - 5 GB memory
  - VPC peering for secure access
- **Alternative**: Google Kubernetes Engine (GKE) for containers
- **Cloud Functions**: For event-driven, serverless components

#### Data Tier
- **Cloud SQL**:
  - Engine: PostgreSQL or MySQL
  - High availability configuration
  - Machine type: db-n1-standard-4
  - Storage: 256 GB SSD
  - Automated backups (7-365 days)
  - Read replicas for scaling
  - Encryption at rest (default)
  - Private IP for VPC access
- **Cloud Spanner** (Alternative):
  - Globally distributed database
  - Horizontal scaling
  - 99.999% availability SLA
- **Cloud Storage**:
  - Standard storage class for active data
  - Nearline/Coldline/Archive for backups
  - Object lifecycle management
  - VPC Service Controls for security

### Infrastructure as Code (GCP)

#### Terraform Example Structure

```hcl
# VPC Network
resource "google_compute_network" "main" {
  name                    = "three-tier-vpc"
  auto_create_subnetworks = false
}

# Web Subnet
resource "google_compute_subnetwork" "web" {
  name          = "web-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.main.id
}

# Instance Template - Web Tier
resource "google_compute_instance_template" "web" {
  name_prefix  = "web-tier-"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.web.id
  }

  metadata_startup_script = file("scripts/web-startup.sh")

  service_account {
    email  = google_service_account.web.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Managed Instance Group - Web Tier
resource "google_compute_region_instance_group_manager" "web" {
  name               = "web-mig"
  base_instance_name = "web"
  region             = "us-central1"

  version {
    instance_template = google_compute_instance_template.web.id
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web.id
    initial_delay_sec = 300
  }
}

# Autoscaler
resource "google_compute_region_autoscaler" "web" {
  name   = "web-autoscaler"
  region = "us-central1"
  target = google_compute_region_instance_group_manager.web.id

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}

# Cloud SQL Instance
resource "google_sql_database_instance" "main" {
  name             = "three-tier-db"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    tier              = "db-n1-standard-4"
    availability_type = "REGIONAL"
    disk_size         = 256
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "03:00"
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
    }

    database_flags {
      name  = "max_connections"
      value = "200"
    }
  }

  deletion_protection = true
}

# Load Balancer
resource "google_compute_url_map" "main" {
  name            = "three-tier-lb"
  default_service = google_compute_backend_service.web.id
}

resource "google_compute_backend_service" "web" {
  name                  = "web-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL"

  backend {
    group           = google_compute_region_instance_group_manager.web.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.web.id]

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = 3600
    client_ttl        = 3600
    max_ttl           = 86400
  }
}
```

### GCP Cost Breakdown

#### Compute (Web Tier)
- **Compute Engine Instances**: 4 x e2-medium (1 vCPU, 4 GB RAM)
  - $0.0335/hour x 4 x 730 hours = $97.82/month
- **Cloud Load Balancing**:
  - Forwarding rules: $0.025/hour x 730 hours = $18.25/month
  - Processing: $0.008/GB (500 GB) = $4/month
- **Cloud CDN**: 1 TB cache egress
  - $0.08/GB x 1024 = $81.92/month

#### Compute (Application Tier)
- **Compute Engine Instances**: 4 x c2-standard-4 (4 vCPU, 16 GB RAM)
  - $0.2088/hour x 4 x 730 hours = $609.67/month
- **Internal Load Balancer**:
  - $0.025/hour x 730 hours = $18.25/month
- **Memorystore for Redis**: 5 GB Standard tier
  - $0.054/GB/hour x 5 GB x 730 hours = $197.10/month

#### Database Tier
- **Cloud SQL PostgreSQL**: db-n1-standard-4 (4 vCPU, 15 GB RAM)
  - $0.3760/hour x 730 hours = $274.48/month
  - HA configuration: +$274.48/month
- **Storage**: 256 GB SSD
  - $0.17/GB x 256 = $43.52/month
- **Backup Storage**: 256 GB
  - $0.08/GB x 256 = $20.48/month
- **Read Replica**: db-n1-standard-2
  - $0.1880/hour x 730 hours = $137.24/month

#### Storage and Networking
- **Cloud Storage**: 1 TB Standard class
  - $0.020/GB x 1024 = $20.48/month
- **Cloud NAT**: $0.044/hour x 730 hours = $32.12/month
  - Data processing: $0.045/GB x 500 GB = $22.50/month
- **Egress**: $0.12/GB x 500 GB = $60/month

#### Monitoring and Security
- **Cloud Monitoring**: Logs + metrics
  - $10-20/month
- **Cloud Armor**: Security policies
  - $5/policy + $0.75/million requests = ~$10/month

**Total Estimated Monthly Cost (GCP): $1,922.31**

---

## Security Considerations

### Network Security

#### Segmentation
- **Separate Subnets**: Isolate each tier in dedicated subnets
- **Private Subnets**: Application and database tiers in private subnets (no direct internet access)
- **Security Groups/Firewall Rules**:
  - Web tier: Allow 80/443 from internet, SSH/RDP from bastion only
  - App tier: Allow application ports from web tier only
  - Database tier: Allow database port from app tier only
- **Network ACLs**: Additional subnet-level filtering

#### Access Control
- **Bastion Hosts/Jump Boxes**: Secure administrative access
- **VPN/Direct Connect**: For on-premises connectivity
- **PrivateLink/Private Endpoints**: Secure access to PaaS services
- **Service Mesh**: For inter-service authentication (e.g., Istio on Kubernetes)

### Application Security

#### Authentication and Authorization
- **OAuth 2.0/OpenID Connect**: Modern authentication protocols
- **Identity Provider Integration**: Azure AD, AWS Cognito, Google Identity Platform
- **Multi-Factor Authentication (MFA)**: Enforce for all users
- **Role-Based Access Control (RBAC)**: Least privilege principle
- **API Gateways**: Centralized authentication and rate limiting

#### Input Validation
- **Sanitize All Inputs**: Prevent injection attacks
- **Parameter Validation**: Type checking and boundary validation
- **Content Security Policy (CSP)**: Mitigate XSS attacks
- **CORS Configuration**: Restrict cross-origin requests

#### Session Management
- **Secure Session Storage**: Redis with encryption
- **Session Timeout**: Automatic expiration of idle sessions
- **Token-Based Auth**: JWT with short expiration
- **Secure Cookies**: HttpOnly, Secure, SameSite attributes

### Data Security

#### Encryption
- **At Rest**:
  - Database encryption (KMS/Customer-managed keys)
  - Storage encryption (S3/Blob/Cloud Storage)
  - Encrypted EBS/Disk volumes
- **In Transit**:
  - TLS 1.2+ for all connections
  - SSL/TLS termination at load balancer
  - Internal traffic encryption (optional but recommended)
- **Application-Level**: Encrypt sensitive data fields (PII, credit cards)

#### Data Protection
- **Backup Encryption**: Encrypt all backups
- **Access Logging**: Log all data access
- **Data Masking**: Mask sensitive data in non-production
- **Data Retention Policies**: Automatic deletion of old data

### Identity and Access Management

#### Cloud IAM
- **Least Privilege**: Grant minimum necessary permissions
- **Service Accounts**: Application-specific identities
- **Instance Profiles/Managed Identities**: Avoid hardcoded credentials
- **Temporary Credentials**: Use STS/temporary tokens
- **Regular Audits**: Review permissions quarterly

#### Secrets Management
- **Secret Stores**: AWS Secrets Manager, Azure Key Vault, GCP Secret Manager
- **Rotation**: Automatic secret rotation
- **No Hardcoding**: Never commit secrets to code
- **Environment Variables**: Store secrets as environment variables

### Monitoring and Compliance

#### Security Monitoring
- **SIEM Integration**: Centralize security logs
- **Intrusion Detection**: Network and host-based IDS
- **Anomaly Detection**: ML-based threat detection
- **Regular Scans**: Vulnerability scanning and penetration testing
- **Compliance Scanning**: CIS benchmarks, PCI-DSS, etc.

#### Audit Logging
- **CloudTrail/Activity Log/Cloud Audit Logs**: Log all API calls
- **Database Audit Logs**: Track data access
- **Application Logs**: Log authentication events
- **Log Retention**: Store logs for compliance period (typically 1-7 years)

### DDoS and WAF Protection
- **AWS Shield/Azure DDoS/Cloud Armor**: DDoS protection
- **Web Application Firewall**:
  - OWASP Top 10 protection
  - SQL injection prevention
  - XSS protection
  - Rate limiting
  - Geo-blocking

---

## High Availability and Disaster Recovery

### High Availability Design

#### Multi-AZ Deployment
- **Compute**: Distribute instances across 2-3 availability zones
- **Database**: Multi-AZ deployment with automatic failover
- **Load Balancers**: Zone-redundant by default
- **Storage**: Replicated across zones automatically

#### Auto Scaling
- **Horizontal Scaling**: Add/remove instances based on demand
- **Metrics**: CPU, memory, request count, custom metrics
- **Predictive Scaling**: Use ML to predict demand
- **Scheduled Scaling**: Pre-scale for known traffic patterns

#### Health Checks
- **Application Health**: HTTP/HTTPS health endpoints
- **Database Health**: Connection tests and query execution
- **Automated Recovery**: Replace unhealthy instances automatically
- **Grace Period**: Allow warm-up time before health checks

### Disaster Recovery

#### Backup Strategy
- **Automated Backups**: Daily automated database backups
- **Backup Retention**: 7-35 days (or longer for compliance)
- **Point-in-Time Recovery**: Restore to any second within retention period
- **Backup Testing**: Regular restore drills
- **Cross-Region Backups**: Replicate backups to different region

#### RTO and RPO Targets
- **Recovery Time Objective (RTO)**: 1-4 hours
- **Recovery Point Objective (RPO)**: 5-15 minutes
- **Strategies**:
  - Backup and Restore: Cheapest, RTO hours, RPO hours
  - Pilot Light: Core systems ready, RTO 10s of minutes, RPO minutes
  - Warm Standby: Scaled-down replica, RTO minutes, RPO minutes
  - Multi-Region Active-Active: Highest cost, RTO seconds, RPO near-zero

#### Failover Procedures
1. **Automated Failover**:
   - Database automatic failover (1-3 minutes)
   - DNS failover to backup region (1-5 minutes)
   - Traffic routing to healthy instances
2. **Manual Failover**:
   - Documented runbooks
   - Trained on-call team
   - Regular DR drills (quarterly recommended)

### Business Continuity

#### Documentation
- **Runbooks**: Step-by-step recovery procedures
- **Architecture Diagrams**: Current state documentation
- **Dependency Mapping**: Identify critical dependencies
- **Contact Lists**: Updated escalation procedures

#### Testing
- **Monthly**: DR documentation review
- **Quarterly**: Simulated failover drill
- **Annually**: Full DR exercise with all stakeholders
- **Chaos Engineering**: Intentional failure injection (advanced)

---

## Performance Optimization

### Application Performance

#### Caching Strategies
- **Browser Caching**: Set appropriate cache headers (Cache-Control, ETag)
- **CDN Caching**: Cache static assets at edge locations
- **Application Caching**: Redis/Memcached for database query results
- **Object Caching**: Cache frequently accessed objects
- **Cache Invalidation**: Implement cache invalidation strategies

#### Database Optimization
- **Query Optimization**: Use EXPLAIN to analyze queries
- **Indexing**: Create indexes on frequently queried columns
- **Connection Pooling**: Reuse database connections
- **Read Replicas**: Offload read queries to replicas
- **Database Partitioning**: Horizontal/vertical partitioning for large tables
- **Materialized Views**: Pre-compute complex aggregations

#### Code Optimization
- **Asynchronous Processing**: Use queues for long-running tasks
- **Microservices**: Break monolith into smaller services
- **API Optimization**: Reduce payload size, use pagination
- **Lazy Loading**: Load resources only when needed
- **Code Profiling**: Identify and optimize bottlenecks

### Infrastructure Performance

#### Compute Optimization
- **Right-Sizing**: Match instance types to workload
- **Burstable Instances**: Use T-series/B-series for variable workloads
- **Spot/Preemptible Instances**: Use for fault-tolerant workloads
- **Dedicated Hosts**: For consistent performance (licensed software)

#### Network Optimization
- **Content Compression**: Enable gzip/brotli compression
- **HTTP/2 or HTTP/3**: Use modern protocols
- **KeepAlive**: Reuse connections
- **Regional Deployment**: Deploy close to users
- **VPC Peering**: Low-latency inter-VPC communication

#### Monitoring and Alerting
- **Application Performance Monitoring (APM)**: New Relic, Datadog, Dynatrace
- **Real User Monitoring (RUM)**: Track actual user experience
- **Synthetic Monitoring**: Proactive monitoring from multiple locations
- **Alerting Thresholds**: Set alerts for degraded performance

---

## Cost Estimates

### Cost Optimization Strategies

#### Compute Savings
1. **Reserved Instances/Savings Plans**: 30-70% savings for steady-state workloads
2. **Spot/Preemptible Instances**: 60-90% savings for interruptible workloads
3. **Auto Scaling**: Scale down during off-peak hours
4. **Right-Sizing**: Regularly review and adjust instance sizes
5. **Scheduled Shutdowns**: Shut down dev/test environments after hours

#### Database Savings
1. **Reserved Capacity**: Commit to 1-3 years for discounts
2. **Read Replicas**: Use smaller instances for read replicas
3. **Storage Optimization**: Use appropriate storage tiers
4. **Backup Lifecycle**: Move old backups to archive storage
5. **Connection Pooling**: Reduce number of database instances needed

#### Networking Savings
1. **VPC Endpoints/PrivateLink**: Avoid data transfer charges
2. **CloudFront/CDN**: Reduce origin data transfer costs
3. **Data Transfer Optimization**: Transfer during off-peak times
4. **Cross-AZ Traffic**: Minimize when possible

#### Monitoring Cost Management
1. **Log Sampling**: Sample non-critical logs
2. **Metric Aggregation**: Aggregate metrics before sending
3. **Retention Policies**: Shorter retention for non-compliance logs
4. **Custom Metrics**: Use sparingly, focus on business metrics

### Total Cost of Ownership (TCO)

**3-Year TCO Comparison** (estimated)

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| Compute | $7,000 | $7,500 | $6,700 |
| Database | $32,400 | $28,800 | $30,600 |
| Storage | $4,000 | $3,800 | $3,600 |
| Networking | $3,200 | $3,000 | $2,900 |
| Monitoring | $600 | $550 | $500 |
| **Monthly Avg** | **$1,944** | **$2,067** | **$1,922** |
| **3-Year Total** | **$69,984** | **$74,412** | **$69,192** |

*Note: Prices vary by region, actual usage, and discount programs. These are estimates for comparison purposes.*

---

## Deployment Strategies

### Blue-Green Deployment

#### Process
1. **Blue Environment**: Current production (e.g., v1.0)
2. **Green Environment**: New version deployed in parallel (v1.1)
3. **Testing**: Full testing on green environment
4. **Cutover**: Switch load balancer to green environment
5. **Rollback**: If issues, instantly switch back to blue
6. **Cleanup**: After validation, decommission blue environment

#### Implementation
- **AWS**: Route 53 weighted routing, ALB target groups
- **Azure**: Traffic Manager, Application Gateway backends
- **GCP**: Cloud Load Balancing with backend services

### Canary Deployment

#### Process
1. Deploy new version to small subset of servers (5-10%)
2. Monitor metrics and error rates
3. Gradually increase traffic to new version (25%, 50%, 75%)
4. If metrics are good, complete rollout to 100%
5. If issues detected, rollback immediately

#### Implementation
- **AWS**: ALB weighted target groups, CodeDeploy
- **Azure**: Traffic Manager weighted routing
- **GCP**: Cloud Load Balancing traffic splitting

### Rolling Deployment

#### Process
1. Deploy to one availability zone at a time
2. Deploy to one instance/batch at a time
3. Wait for health checks to pass
4. Continue to next batch
5. Maintain minimum capacity during deployment

#### Benefits
- No additional infrastructure required
- Gradual rollout reduces risk
- Automatic rollback on failure

### Infrastructure as Code Deployment

#### Tools
- **Terraform**: Multi-cloud IaC
- **CloudFormation**: AWS native
- **ARM Templates**: Azure native
- **Deployment Manager**: GCP native
- **Pulumi**: Programming language-based IaC
- **Ansible**: Configuration management

#### CI/CD Pipeline
1. Code commit triggers pipeline
2. Automated testing (unit, integration)
3. Build artifacts (Docker images, packages)
4. Deploy to staging environment
5. Automated smoke tests
6. Manual approval gate (optional)
7. Deploy to production
8. Post-deployment validation

---

## Monitoring and Logging

### Application Monitoring

#### Metrics to Track
- **Request Rate**: Requests per second
- **Error Rate**: 4xx and 5xx errors
- **Latency**: Response time (p50, p95, p99)
- **Saturation**: Resource utilization (CPU, memory, disk)
- **Throughput**: Data processed
- **Active Connections**: Concurrent connections

#### Tools
- **AWS**: CloudWatch, X-Ray, Application Insights
- **Azure**: Azure Monitor, Application Insights
- **GCP**: Cloud Monitoring, Cloud Trace
- **Third-Party**: Datadog, New Relic, Dynatrace, Splunk

### Infrastructure Monitoring

#### Metrics to Track
- **CPU Utilization**: Per instance and aggregate
- **Memory Usage**: Available and used memory
- **Disk I/O**: Read/write operations, latency
- **Network**: Bytes in/out, packet loss
- **Load Balancer**: Request count, healthy hosts
- **Auto Scaling Events**: Scale up/down activities

### Database Monitoring

#### Metrics to Track
- **Connection Count**: Active and idle connections
- **Query Performance**: Slow query log
- **Replication Lag**: Delay between primary and replicas
- **Storage Used**: Database size growth
- **IOPS**: Input/output operations
- **Cache Hit Ratio**: Efficiency of query cache

### Centralized Logging

#### Log Types
- **Application Logs**: Application events, errors, debug
- **Access Logs**: HTTP requests (load balancer, web server)
- **System Logs**: OS events, security events
- **Audit Logs**: Compliance and security auditing

#### Log Management
- **AWS**: CloudWatch Logs, OpenSearch Service
- **Azure**: Azure Monitor Logs, Log Analytics
- **GCP**: Cloud Logging, BigQuery
- **Third-Party**: Elasticsearch, Splunk, Sumo Logic

#### Log Retention
- **Hot Storage**: Last 7-30 days (fast access)
- **Warm Storage**: 30-90 days (moderate access)
- **Cold Storage**: 90+ days (compliance, archive)

### Alerting

#### Alert Types
- **Threshold Alerts**: Metric exceeds threshold
- **Anomaly Detection**: ML-based unusual patterns
- **Composite Alerts**: Multiple conditions
- **Absence Alerts**: Expected data missing

#### Alert Channels
- **Email**: Low-priority alerts
- **SMS**: Medium-priority
- **Phone Call**: Critical alerts
- **Slack/Teams**: Team collaboration
- **PagerDuty/Opsgenie**: On-call management

---

## Best Practices

### Design Principles

1. **Design for Failure**: Assume everything fails, build resilience
2. **Loose Coupling**: Minimize dependencies between tiers
3. **Horizontal Scaling**: Scale out, not just up
4. **Automate Everything**: Infrastructure, deployment, recovery
5. **Immutable Infrastructure**: Replace, don't modify
6. **Secure by Default**: Security in every layer
7. **Monitor and Measure**: Observability from day one
8. **Cost Awareness**: Track and optimize continuously

### Operational Excellence

1. **Documentation**: Keep architecture and runbooks current
2. **Code Review**: All infrastructure code reviewed
3. **Testing**: Automated testing at all levels
4. **Change Management**: Controlled, documented changes
5. **Incident Management**: Defined incident response procedures
6. **Post-Mortems**: Blameless reviews after incidents
7. **Continuous Improvement**: Regular retrospectives

### Security Best Practices

1. **Defense in Depth**: Multiple layers of security
2. **Principle of Least Privilege**: Minimum necessary access
3. **Regular Updates**: Patch systems promptly
4. **Encryption Everywhere**: Data at rest and in transit
5. **Security Scanning**: Automated vulnerability scanning
6. **Compliance**: Meet industry standards (PCI-DSS, HIPAA, GDPR)

---

## Common Pitfalls

### Architecture Pitfalls

1. **Single Point of Failure**: Not deploying Multi-AZ
2. **Tight Coupling**: Direct dependencies between tiers
3. **Under-Provisioning**: Insufficient capacity for peak loads
4. **No Caching Strategy**: Overloading database with reads
5. **Ignoring Latency**: Not considering network latency
6. **Monolithic Design**: Not breaking into services when appropriate

### Security Pitfalls

1. **Open Security Groups**: Allowing 0.0.0.0/0 unnecessarily
2. **Hardcoded Credentials**: Secrets in code
3. **No Encryption**: Unencrypted data stores
4. **Missing Logs**: Insufficient audit trails
5. **Default Configurations**: Using default passwords/settings
6. **No Principle of Least Privilege**: Over-permissioned IAM

### Operational Pitfalls

1. **No Monitoring**: Flying blind without metrics
2. **Manual Processes**: Not automating deployments
3. **No DR Plan**: Unprepared for disasters
4. **Inadequate Testing**: Skipping load/stress testing
5. **Poor Documentation**: Undocumented architecture
6. **Ignoring Costs**: Runaway cloud spending

### Performance Pitfalls

1. **No CDN**: Serving static content from origin
2. **Missing Indexes**: Slow database queries
3. **N+1 Queries**: Inefficient data fetching
4. **Synchronous Processing**: Blocking long-running tasks
5. **No Connection Pooling**: Exhausting database connections
6. **Large Payloads**: Transferring unnecessary data

---

## Conclusion

Three-tier architecture remains a proven pattern for building scalable, maintainable web applications. By following the guidelines and best practices outlined in this document, you can implement a robust three-tier application on AWS, Azure, or GCP that is:

- **Highly Available**: Multi-AZ deployment with automatic failover
- **Scalable**: Horizontal scaling in all tiers
- **Secure**: Defense-in-depth security posture
- **Cost-Effective**: Optimized resource utilization
- **Maintainable**: Clear separation of concerns
- **Observable**: Comprehensive monitoring and logging

Remember to continuously iterate on your architecture based on actual usage patterns, performance metrics, and evolving business requirements.

---

**Document Version**: 1.0
**Last Updated**: 2024-10-13
**Author**: Cloud Architecture Team
