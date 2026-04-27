# GCP Networking - Professional Cloud Architect

## VPC (Virtual Private Cloud) Deep Dive

### What is a VPC?
A global virtual network that spans all Google Cloud regions. Unlike other clouds, GCP VPCs are global by default with regional subnets.

**Critical Exam Concept**: GCP VPCs are fundamentally different from AWS VPCs:
- **Global resource**: One VPC spans all regions (AWS VPCs are regional)
- **Regional subnets**: Subnets span zones within a region
- **No NAT Gateway construct**: Uses Cloud NAT instead
- **No Internet Gateway**: Different egress model
- **Projects as boundaries**: VPCs live in projects, not accounts

### VPC Architecture Models

#### Auto Mode VPC
```
Characteristics:
- One subnet per region created automatically
- Predictable IP ranges: 10.128.0.0/20 per region
- New regions get subnets automatically
- Can be converted to custom mode (one-way operation)
- Default firewall rules included

When to Use:
- Development/testing environments
- Quick prototypes
- Learning/training scenarios
- Simple applications without complex networking

When to Avoid:
- Production environments
- IP range conflicts with on-premises
- Multiple VPCs needing to peer
- Strict compliance requirements
```

#### Custom Mode VPC
```
Characteristics:
- Complete control over subnet creation
- Define your own IP ranges
- No automatic subnet creation
- Must explicitly create all subnets
- Production-ready from the start

When to Use:
- Production workloads (always)
- Hybrid cloud architectures
- Multiple VPCs requiring peering
- Organizations with IP allocation policies
- Compliance and security requirements

Best Practices:
- Plan IP addressing scheme upfront
- Document subnet purposes
- Use consistent naming conventions
- Leave room for growth (30-40% spare capacity)
- Consider secondary ranges for GKE/containers
```

### VPC Design Patterns

#### Single VPC Pattern
```
Use Case: Simple application, single team
Architecture:
├── VPC: production-vpc (global)
    ├── Subnet: web-tier (us-central1) - 10.1.1.0/24
    ├── Subnet: app-tier (us-central1) - 10.1.2.0/24
    ├── Subnet: db-tier (us-central1) - 10.1.3.0/24
    └── Subnet: web-tier (us-east1) - 10.2.1.0/24

Benefits:
- Simple to manage
- Low latency between regions
- No VPC peering needed
- Unified firewall rules

Limitations:
- Single blast radius
- No network isolation between teams
- Harder to enforce separation of duties
```

#### Multi-VPC Pattern
```
Use Case: Multiple environments, team isolation
Architecture:
├── VPC: prod-vpc
│   └── Subnets: production workloads
├── VPC: staging-vpc
│   └── Subnets: staging workloads
├── VPC: dev-vpc
│   └── Subnets: development workloads
└── VPC: shared-services-vpc
    └── Subnets: DNS, monitoring, logging

Benefits:
- Environment isolation
- Independent security policies
- Blast radius containment
- Team autonomy

Considerations:
- Requires VPC peering for connectivity
- More complex to manage
- Higher operational overhead
```

#### Shared VPC Pattern (Hub-and-Spoke)
```
Use Case: Enterprise with multiple projects
Architecture:
Host Project (Network Admin)
├── VPC: shared-vpc (global)
    ├── Subnet: prod-subnet (shared with project-a)
    ├── Subnet: staging-subnet (shared with project-b)
    └── Subnet: shared-services (available to all)

Service Projects (Compute Admin)
├── project-a: Uses prod-subnet
├── project-b: Uses staging-subnet
└── project-c: Uses shared-services

Benefits:
- Centralized network administration
- Unified security policies
- Cost allocation per project
- Simplified connectivity

Requirements:
- Organization-level resource
- Specific IAM roles (Shared VPC Admin)
- Network admins separate from compute admins
```

### Comprehensive VPC Comparison

| Feature | Default VPC | Auto Mode | Custom Mode | Shared VPC |
|---------|-------------|-----------|-------------|------------|
| **Subnets** | Auto (1/region) | Auto (1/region) | Manual | Manual |
| **IP Ranges** | 10.128.0.0/9 | 10.128.0.0/9 | You define | You define |
| **Conversion** | Delete only | To custom (one-way) | N/A | N/A |
| **Production Use** | No | No | Yes | Yes |
| **Multi-project** | No | No | No | Yes |
| **Firewall** | Default rules | Default rules | You configure | Centralized |
| **Expansion** | Automatic | Automatic | Manual | Manual |
| **Cost** | Free (traffic charged) | Free (traffic charged) | Free (traffic charged) | Free (traffic charged) |

## Subnets Deep Dive

### Subnet Characteristics
- **Regional**: Span all zones in a region (NOT zonal)
- **IP Ranges**: RFC 1918 private addresses recommended
- **Expandable**: Can expand IP ranges (cannot shrink) - exam favorite
- **Secondary Ranges**: Critical for GKE, Dataproc, container workloads
- **Internal routing**: Automatic between subnets in same VPC
- **No AZ mapping**: Unlike AWS, subnets are truly regional

### Subnet IP Range Planning

#### Primary IP Ranges
```
Subnet Sizing Guidelines:
/24 (254 usable IPs): Small applications, dev environments
/22 (1022 usable IPs): Medium applications, typical workloads
/20 (4094 usable IPs): Large applications, GKE clusters
/16 (65534 usable IPs): Very large deployments, future growth

Exam Tip: Always account for 4 reserved IPs per subnet
- .0: Network address
- .1: Gateway (default route)
- .2: Second-to-last (Google reserved)
- .255: Broadcast address (for /24)
```

#### Secondary IP Ranges (Critical for Containers)
```
Purpose: IP aliasing for pods and services
Primary Range: 10.0.1.0/24 (VM instances - 254 IPs)
Secondary Range 1: 10.100.0.0/16 (GKE pods - 65,534 IPs)
Secondary Range 2: 10.200.0.0/20 (GKE services - 4,094 IPs)

Exam Scenarios:
Q: GKE cluster needs 1000 pods, how to configure?
A: Primary for nodes, secondary for pods (size appropriately)

Q: Running out of pod IPs, what to do?
A: Add secondary range, cannot expand existing secondary

Calculation Example:
- 50 nodes
- 110 pods per node (GKE default max)
- Total pods: 5,500
- Need: At least /19 (8,192 IPs) for pod range
```

### Advanced Subnet Features

#### Subnet Expansion
```bash
# Check current subnet range
gcloud compute networks subnets describe web-subnet \
  --region=us-central1

# Expand subnet (can only grow, never shrink)
gcloud compute networks subnets expand-ip-range web-subnet \
  --region=us-central1 \
  --prefix-length=20

Exam Gotchas:
- Cannot shrink subnets (common wrong answer)
- Cannot overlap with other subnets in VPC
- Cannot change secondary ranges, must add new ones
- Expansion does NOT affect running instances
- No downtime during expansion
```

#### Private Google Access
```
Purpose: Access Google APIs without external IPs
Configuration: Per-subnet setting

Services Accessible:
- Cloud Storage (gs://)
- BigQuery
- Container Registry
- Artifact Registry
- Cloud Monitoring/Logging
- Pub/Sub
- Dataflow, Dataproc
- ML APIs (Vision, NLP, etc.)

Services NOT Accessible:
- Third-party APIs
- General internet access
- Other cloud providers
- Non-Google services

Exam Question Pattern:
"VM has no external IP, cannot access Cloud Storage"
Answer: Enable Private Google Access on subnet

Configuration:
gcloud compute networks subnets update SUBNET \
  --region=REGION \
  --enable-private-ip-google-access

Important: VMs need internal IP and route to 199.36.153.4/30
```

#### Private Service Connect for Google APIs
```
Evolution of Private Google Access:
PGA → PSC (more control, uses internal IPs)

Benefits vs Private Google Access:
- Uses VPC internal IPs (not 199.36.153.4/30)
- More granular access control
- Works with VPC-SC perimeters
- Supports DNS configuration
- Better for hybrid architectures

Setup:
gcloud compute addresses create psc-endpoint \
  --global \
  --purpose=PRIVATE_SERVICE_CONNECT \
  --addresses=10.0.5.5 \
  --network=my-vpc

gcloud compute forwarding-rules create psc-rule \
  --global \
  --network=my-vpc \
  --address=psc-endpoint \
  --target-google-apis-bundle=all-apis

Exam Tip: Choose PSC over PGA for scenarios requiring:
- On-premises access to Google APIs via hybrid connectivity
- VPC Service Controls integration
- Custom DNS requirements
```

### Reserved and Special IP Addresses

#### Reserved IPs per Subnet
```
Example: 10.1.1.0/24 subnet
10.1.1.0   - Network address (reserved)
10.1.1.1   - Default gateway (reserved)
10.1.1.2   - Reserved by Google for future use
10.1.1.254 - Reserved by Google for future use
10.1.1.255 - Broadcast address (reserved)

Usable range: 10.1.1.3 to 10.1.1.253 (251 IPs from /24)

Exam Calculation:
Subnet /24: 256 - 4 = 252 usable IPs (actual: 251)
Subnet /22: 1024 - 4 = 1020 usable IPs (actual: 1019)
```

#### Special Google IP Ranges
```
Metadata Server: 169.254.169.254
- Accessible from all instances
- Provides instance metadata
- Cannot be blocked by firewall

Private Google Access: 199.36.153.4/30
- Used when PGA enabled
- Routes Google API traffic internally

Default Internet Gateway: 0.0.0.0/0 → internet gateway
- Automatically created in VPC
- Used for external connectivity

Cloud DNS: 169.254.169.254
- Internal DNS resolution
- Always available to instances
```

### Subnet Configuration Examples

#### Web Application Three-Tier
```bash
# Create VPC
gcloud compute networks create webapp-vpc \
  --subnet-mode=custom \
  --bgp-routing-mode=regional

# Web tier subnet (public-facing)
gcloud compute networks subnets create web-tier \
  --network=webapp-vpc \
  --region=us-central1 \
  --range=10.1.1.0/24 \
  --enable-private-ip-google-access

# Application tier subnet
gcloud compute networks subnets create app-tier \
  --network=webapp-vpc \
  --region=us-central1 \
  --range=10.1.2.0/24 \
  --enable-private-ip-google-access

# Database tier subnet (most restricted)
gcloud compute networks subnets create db-tier \
  --network=webapp-vpc \
  --region=us-central1 \
  --range=10.1.3.0/24 \
  --enable-private-ip-google-access

# Disaster recovery region
gcloud compute networks subnets create web-tier-dr \
  --network=webapp-vpc \
  --region=us-east1 \
  --range=10.2.1.0/24
```

#### GKE Cluster with IP Aliasing
```bash
# Create subnet with secondary ranges for GKE
gcloud compute networks subnets create gke-subnet \
  --network=prod-vpc \
  --region=us-central1 \
  --range=10.0.0.0/22 \
  --secondary-range pods=10.100.0.0/16 \
  --secondary-range services=10.200.0.0/20 \
  --enable-private-ip-google-access

# Create GKE cluster using secondary ranges
gcloud container clusters create prod-cluster \
  --region=us-central1 \
  --network=prod-vpc \
  --subnetwork=gke-subnet \
  --cluster-secondary-range-name=pods \
  --services-secondary-range-name=services \
  --enable-ip-alias \
  --enable-private-nodes \
  --enable-private-endpoint \
  --master-ipv4-cidr=172.16.0.0/28

Exam Focus:
- Secondary ranges required for VPC-native GKE
- Pod IPs from secondary range (not primary)
- Service IPs from different secondary range
- Cannot overlap ranges within VPC
```

## IP Addressing & Connectivity

### Internal vs External IPs
| Type | Scope | Cost | Assignment |
|------|-------|------|------------|
| **Internal** | Within VPC | Free | Automatic |
| **External Ephemeral** | Internet | Charged | Dynamic |
| **External Static** | Internet | Charged (higher) | Reserved |

### External IP Types
- **Ephemeral**: Changes when instance stops/starts
- **Static**: Permanent assignment, survives instance lifecycle
- **Regional**: Used within a single region
- **Global**: Used for global load balancers

### Private Service Connect
- **Purpose**: Access services privately without external IPs
- **Benefits**: Security, performance, simplified networking
- **Use Cases**: Accessing Google services, third-party services
- **Types**: Google APIs, published services, custom services

## Firewall Rules

### Firewall Fundamentals
- **Stateful**: Return traffic automatically allowed
- **Applied to Instances**: Based on tags, service accounts
- **Priority**: Lower numbers = higher priority (0-65534)
- **Default Action**: Deny unless explicitly allowed

### Rule Components
| Component | Description | Example |
|-----------|-------------|---------|
| **Direction** | Ingress or Egress | Ingress |
| **Priority** | Rule precedence | 1000 |
| **Action** | Allow or Deny | Allow |
| **Targets** | What instances | web-servers tag |
| **Source/Destination** | Traffic origin/destination | 0.0.0.0/0 |
| **Protocols/Ports** | Traffic type | tcp:80,443 |

### Default Rules
```
default-allow-internal: Allow all traffic between VPC instances
default-allow-ssh: Allow SSH (tcp:22) from anywhere  
default-allow-rdp: Allow RDP (tcp:3389) from anywhere
default-allow-icmp: Allow ICMP from anywhere
```

### Best Practices
- Use specific tags for granular control
- Follow principle of least privilege
- Use service accounts instead of tags when possible
- Regular firewall rule audits
- Document rule purposes

## Load Balancing Deep Dive

### Load Balancer Types - Complete Matrix

| Type | Scope | Layer | External/Internal | Preserve Client IP | IPv6 | Use Case |
|------|-------|-------|-------------------|-------------------|------|----------|
| **Global External HTTP(S)** | Global | 7 | External | Via header | Yes | Global web apps |
| **Global External TCP Proxy** | Global | 4 | External | Via PROXY protocol | Yes | Global TCP apps |
| **Global External SSL Proxy** | Global | 4 | External | Via PROXY protocol | Yes | Global SSL apps |
| **Regional External HTTP(S)** | Regional | 7 | External | Via header | Yes | Regional web apps |
| **Regional External Network TCP/UDP** | Regional | 4 | External | Yes (passthrough) | Yes | Regional TCP/UDP |
| **Regional Internal HTTP(S)** | Regional | 7 | Internal | Via header | No | Internal microservices |
| **Regional Internal TCP/UDP** | Regional | 4 | Internal | Yes | No | Internal applications |
| **Cross-Region Internal HTTP(S)** | Multi-region | 7 | Internal | Via header | No | Global internal services |

### Load Balancer Selection Decision Tree

```
Start: What type of traffic?
│
├─ HTTP(S) Traffic
│  │
│  ├─ Internal (within GCP)?
│  │  ├─ Single region → Internal HTTP(S) LB
│  │  └─ Multiple regions → Cross-Region Internal HTTP(S) LB
│  │
│  └─ External (from internet)?
│     ├─ Single region → Regional External HTTP(S) LB
│     └─ Multiple regions → Global External HTTP(S) LB
│
├─ TCP Traffic (non-HTTP)
│  │
│  ├─ Internal?
│  │  └─ Regional Internal TCP/UDP LB
│  │
│  └─ External?
│     ├─ Need SSL termination → Global SSL Proxy LB
│     ├─ Need global distribution → Global TCP Proxy LB
│     └─ Regional, preserve IPs → Regional Network LB
│
└─ UDP Traffic
   └─ Regional Network LB (external) or Internal TCP/UDP LB (internal)

Exam Tip: Global = Anycast IP, Regional = Regional IP
```

### Global External HTTP(S) Load Balancer (Most Common)

#### Architecture
```
                    Internet
                       │
                   [Anycast IP]
                  35.244.x.x (Global)
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   [us-central1]  [europe-west1]  [asia-east1]
        │              │              │
    ┌───┴───┐      ┌───┴───┐      ┌───┴───┐
    │Backend│      │Backend│      │Backend│
    │Service│      │Service│      │Service│
    └───────┘      └───────┘      └───────┘
        │              │              │
    [Instance      [Instance      [Instance
     Groups]        Groups]        Groups]

Traffic Flow:
1. User connects to anycast IP
2. Google edge forwards to nearest healthy backend
3. Response returns through same edge
4. Cloud CDN can cache responses at edge

Key Features:
- Single global IP address (anycast)
- Automatic multi-region failover
- Cloud CDN integration
- Cloud Armor for security
- SSL termination at edge
- Content-based routing (URL maps)
- WebSocket support
- HTTP/2 and gRPC support
```

#### Configuration Components

##### Frontend Configuration
```bash
# Reserve global IP address
gcloud compute addresses create lb-ipv4 \
  --ip-version=IPV4 \
  --global

# Create SSL certificate (managed)
gcloud compute ssl-certificates create lb-cert \
  --domains=example.com,www.example.com \
  --global

# Create target HTTPS proxy
gcloud compute target-https-proxies create lb-target-proxy \
  --ssl-certificates=lb-cert \
  --url-map=lb-url-map \
  --global

# Create forwarding rule (frontend)
gcloud compute forwarding-rules create lb-forwarding-rule \
  --address=lb-ipv4 \
  --target-https-proxy=lb-target-proxy \
  --global \
  --ports=443
```

##### Backend Configuration
```bash
# Create health check
gcloud compute health-checks create http lb-health-check \
  --port=80 \
  --request-path=/health \
  --check-interval=10s \
  --timeout=5s \
  --unhealthy-threshold=3 \
  --healthy-threshold=2

# Create backend service
gcloud compute backend-services create web-backend \
  --protocol=HTTP \
  --health-checks=lb-health-check \
  --global \
  --enable-cdn \
  --cache-mode=CACHE_ALL_STATIC \
  --default-ttl=3600 \
  --session-affinity=CLIENT_IP \
  --timeout=30s

# Add backend (instance group)
gcloud compute backend-services add-backend web-backend \
  --instance-group=web-ig-us-central \
  --instance-group-zone=us-central1-a \
  --balancing-mode=UTILIZATION \
  --max-utilization=0.8 \
  --capacity-scaler=1.0 \
  --global

# Add another region
gcloud compute backend-services add-backend web-backend \
  --instance-group=web-ig-europe \
  --instance-group-region=europe-west1 \
  --balancing-mode=UTILIZATION \
  --max-utilization=0.8 \
  --global
```

##### URL Map (Content-Based Routing)
```bash
# Create backend services for different paths
gcloud compute backend-services create api-backend --global
gcloud compute backend-services create static-backend --global
gcloud compute backend-services create default-backend --global

# Create URL map
gcloud compute url-maps create lb-url-map \
  --default-service=default-backend

# Add path rules
gcloud compute url-maps add-path-matcher lb-url-map \
  --path-matcher-name=main-matcher \
  --default-service=default-backend \
  --path-rules="/api/*=api-backend,/static/*=static-backend"

# Advanced routing (via YAML export/import)
gcloud compute url-maps export lb-url-map --destination=url-map.yaml
# Edit url-map.yaml for advanced routing
gcloud compute url-maps import lb-url-map --source=url-map.yaml

Advanced Routing Example (url-map.yaml):
hostRules:
- hosts:
  - example.com
  pathMatcher: main-matcher
- hosts:
  - api.example.com
  pathMatcher: api-matcher
pathMatchers:
- name: main-matcher
  defaultService: https://www.googleapis.com/compute/v1/projects/PROJECT/global/backendServices/default-backend
  pathRules:
  - paths:
    - /api/*
    service: https://www.googleapis.com/compute/v1/projects/PROJECT/global/backendServices/api-backend
  - paths:
    - /images/*
    routeAction:
      urlRewrite:
        pathPrefixRewrite: /static/
      weightedBackendServices:
      - backendService: https://www.googleapis.com/compute/v1/projects/PROJECT/global/backendServices/cdn-backend
        weight: 100
```

### Load Balancing Algorithms

#### Available Algorithms
```
1. ROUND_ROBIN (default)
   - Distributes requests evenly
   - Good for uniform workloads
   - No session awareness

2. LEAST_REQUEST
   - Routes to backend with fewest active requests
   - Good for varying request durations
   - Better resource utilization

3. RING_HASH (with Session Affinity)
   - Consistent hashing
   - Good for caching scenarios
   - Minimizes cache misses during scaling

4. RANDOM
   - Random selection
   - Simple, low overhead
   - Good for stateless applications

5. MAGLEV (Network LB)
   - Consistent hashing for Network LB
   - Minimizes connection disruption
   - Default for passthrough LBs

Configuration:
gcloud compute backend-services update BACKEND \
  --load-balancing-scheme=EXTERNAL \
  --locality-lb-policy=ROUND_ROBIN
```

#### Session Affinity Options
```
Session Affinity Types:

1. NONE (default)
   - No affinity
   - Pure load distribution

2. CLIENT_IP
   - Hash of client IP
   - Good for stateful applications
   - Survives backend changes

3. GENERATED_COOKIE
   - LB generates cookie (GCLB)
   - Best for HTTP applications
   - Survives client IP changes

4. CLIENT_IP_PROTO
   - Client IP + protocol
   - More granular than CLIENT_IP

5. CLIENT_IP_PORT_PROTO
   - Client IP + port + protocol
   - Most granular
   - For Network LB

Configuration:
gcloud compute backend-services update web-backend \
  --session-affinity=GENERATED_COOKIE \
  --affinity-cookie-ttl=3600 \
  --global

Exam Scenario:
Q: Users losing shopping cart on load balanced site
A: Enable session affinity (GENERATED_COOKIE for HTTP)
```

### Regional vs Global Load Balancers

#### When to Use Regional External Network LB
```
Use Cases:
- Need to preserve source IP address
- UDP traffic (e.g., game servers, VoIP)
- Non-HTTP TCP traffic in single region
- Traffic doesn't need SSL termination
- Lower latency requirements (same region)

Architecture:
Regional IP (e.g., 35.1.2.3 in us-central1)
        ↓
Regional Network LB (passthrough)
        ↓
Backend instances (see actual client IP)

Configuration:
gcloud compute forwarding-rules create regional-lb \
  --region=us-central1 \
  --load-balancing-scheme=EXTERNAL \
  --network-tier=PREMIUM \
  --ip-protocol=TCP \
  --ports=80,443 \
  --backend-service=regional-backend

Benefits:
- Preserves source IP (no X-Forwarded-For needed)
- Lower latency (no proxy)
- Supports UDP
- Simpler troubleshooting

Limitations:
- Regional scope only
- No SSL termination at LB
- No content-based routing
- No Cloud CDN integration
```

### Internal Load Balancers

#### Internal HTTP(S) Load Balancer
```
Use Case: Microservices architecture, service mesh

Architecture:
    GCP VPC (10.0.0.0/8)
         │
    [Internal IP: 10.1.1.100]
         │
  Internal HTTP(S) LB (regional)
         │
    ┌────┴────┐
    │         │
[Backend1] [Backend2]
(10.1.2.x) (10.1.2.y)

Features:
- Private (RFC 1918) IP address
- Regional resource
- Proxy-based (Envoy)
- Supports all HTTP(S) LB features
- No internet exposure
- Cross-VPC support (via peering)

Configuration:
gcloud compute forwarding-rules create internal-lb \
  --load-balancing-scheme=INTERNAL_MANAGED \
  --network=my-vpc \
  --subnet=backend-subnet \
  --region=us-central1 \
  --ports=80 \
  --target-http-proxy=internal-proxy

Exam Pattern:
Q: Microservices need load balancing without internet exposure
A: Internal HTTP(S) Load Balancer
```

#### Internal TCP/UDP Load Balancer
```
Use Case: Internal databases, legacy applications

Architecture:
    GCP VPC
         │
    [Internal IP: 10.1.1.50]
         │
  Internal TCP/UDP LB (passthrough)
         │
    ┌────┴────┐
    │         │
[Database1] [Database2]

Features:
- Preserves source IP
- Passthrough (not proxy)
- TCP and UDP support
- Regional scope
- High throughput, low latency

Configuration:
gcloud compute forwarding-rules create internal-tcp-lb \
  --load-balancing-scheme=INTERNAL \
  --network=my-vpc \
  --subnet=db-subnet \
  --region=us-central1 \
  --ip-protocol=TCP \
  --ports=3306 \
  --backend-service=db-backend

Use Cases:
- Internal database clustering
- Legacy application load balancing
- Internal DNS servers
- Internal caching layers
```

### Health Checks (Critical for Exam)

#### Health Check Types
```
1. HTTP Health Check
   - Checks HTTP response code
   - Can check response body
   - Most common for web apps

2. HTTPS Health Check
   - SSL/TLS health check
   - Validates certificate (optional)
   - For secure applications

3. TCP Health Check
   - TCP connection test
   - No application-level check
   - For non-HTTP services

4. gRPC Health Check
   - Native gRPC health protocol
   - For gRPC services
   - Protocol buffer based

5. HTTP/2 Health Check
   - HTTP/2 protocol
   - For modern applications
```

#### Health Check Configuration
```bash
# Create comprehensive HTTP health check
gcloud compute health-checks create http advanced-health-check \
  --port=8080 \
  --request-path=/health \
  --check-interval=10s \
  --timeout=5s \
  --unhealthy-threshold=3 \
  --healthy-threshold=2 \
  --proxy-header=PROXY_V1 \
  --response="OK" \
  --enable-logging

Parameters Explained:
- check-interval: How often to check (default: 5s)
- timeout: How long to wait for response
- unhealthy-threshold: Consecutive failures before marking unhealthy
- healthy-threshold: Consecutive successes before marking healthy
- proxy-header: PROXY protocol version (for backend to see client IP)
- response: Expected response body content

Exam Calculations:
Time to mark unhealthy: check-interval × unhealthy-threshold
Example: 10s × 3 = 30 seconds

Time to mark healthy: check-interval × healthy-threshold
Example: 10s × 2 = 20 seconds

Common Mistake: Health check interval too low causing backend overload
Recommendation: 5-10s for most applications
```

#### Health Check Firewall Rules
```bash
# CRITICAL: Allow health checks from Google's health check ranges
# These are REQUIRED or backends will be marked unhealthy

# For Global Load Balancers
gcloud compute firewall-rules create allow-health-check-global \
  --network=my-vpc \
  --action=allow \
  --direction=ingress \
  --source-ranges=35.191.0.0/16,130.211.0.0/22 \
  --target-tags=lb-backend \
  --rules=tcp:80,tcp:443

# For Internal Load Balancers
gcloud compute firewall-rules create allow-health-check-internal \
  --network=my-vpc \
  --action=allow \
  --direction=ingress \
  --source-ranges=35.191.0.0/16,130.211.0.0/22 \
  --rules=tcp:80

Exam Trap Question:
"All backends showing unhealthy but instances are running fine"
Answer: Missing firewall rule for health check ranges
```

## Cloud CDN Deep Dive

### What is Cloud CDN?
Global content delivery network integrated with Google's edge locations (100+ worldwide).

**Critical Exam Concept**: Cloud CDN only works with:
- Global External HTTP(S) Load Balancers
- External HTTP(S) Load Balancers (regional with proxy)
- NOT with Internal Load Balancers or Network Load Balancers

### Architecture
```
User (Tokyo) → Google Edge (Tokyo) → [Cache Hit] → Return
                       │
                       └─→ [Cache Miss] → Origin (us-central1)
                                              ↓
                           Cache at edge ←──┘

Flow:
1. User requests content
2. Anycast routes to nearest Google edge
3. Edge checks cache
4. Cache hit: Return immediately (low latency)
5. Cache miss: Fetch from origin, cache, then return
6. Subsequent requests served from edge

Benefits:
- Lower latency for global users
- Reduced origin load
- Lower egress costs (cached traffic free from origin)
- DDoS protection (edge absorbs traffic)
```

### Cache Modes (Critical for Exam)

#### 1. USE_ORIGIN_HEADERS (Recommended)
```
Behavior: Respects Cache-Control headers from origin

Origin Response Headers:
Cache-Control: public, max-age=3600
  → Cached for 1 hour

Cache-Control: private, no-cache
  → Not cached

Cache-Control: public, max-age=86400, s-maxage=3600
  → Cached for 1 hour at CDN (s-maxage takes precedence)

When to Use:
- Dynamic content with proper cache headers
- Mixed cacheable/non-cacheable content
- Need fine-grained control per URL
- Best practice for most applications

Configuration:
gcloud compute backend-services update web-backend \
  --enable-cdn \
  --cache-mode=USE_ORIGIN_HEADERS \
  --global
```

#### 2. CACHE_ALL_STATIC (Legacy)
```
Behavior: Automatically caches static content regardless of headers

Cached by Default:
- Images: .jpg, .jpeg, .png, .gif, .webp, .svg
- Video: .mp4, .webm, .ogg
- Scripts: .js
- Stylesheets: .css
- Documents: .pdf
- Fonts: .woff, .woff2, .ttf, .eot

NOT Cached:
- HTML files
- Dynamic content (.php, .aspx)
- Authenticated requests
- POST/PUT/DELETE requests

When to Use:
- Legacy applications without cache headers
- Quick CDN enablement without code changes
- Static asset heavy sites

Limitations:
- Less control than USE_ORIGIN_HEADERS
- May cache too much or too little
```

#### 3. FORCE_CACHE_ALL (Advanced)
```
Behavior: Cache everything for specified TTL

Configuration:
gcloud compute backend-services update api-backend \
  --enable-cdn \
  --cache-mode=FORCE_CACHE_ALL \
  --default-ttl=3600 \
  --client-ttl=1800 \
  --max-ttl=86400 \
  --global

TTL Parameters:
- default-ttl: TTL when origin doesn't specify (default: 3600)
- client-ttl: TTL for client browsers (default: same as default-ttl)
- max-ttl: Maximum TTL allowed (default: 86400)

When to Use:
- Static sites (JAMstack)
- APIs with consistent responses
- Need to override origin headers
- Testing/development

Warnings:
- Can cache authenticated content (security risk)
- Can serve stale data
- Careful with dynamic content
```

### Cache Key Configuration
```
Control what makes content unique in cache:

Default Cache Key:
- URL (scheme://host/path?query)

Custom Cache Key Options:
1. Include/exclude query string
2. Include/exclude specific query parameters
3. Include/exclude hostname
4. Include/exclude protocol

Configuration:
gcloud compute backend-services update web-backend \
  --cache-key-include-protocol \
  --cache-key-include-host \
  --cache-key-include-query-string \
  --cache-key-query-string-whitelist=product_id,category \
  --global

Exam Scenario:
Q: Different content for /api?user_id=123 vs /api?user_id=456
A: Include query string in cache key (default behavior)

Q: Same content for /api?user_id=123&session=xyz vs /api?user_id=123&session=abc
A: Include only user_id in cache key (whitelist)
```

### Cache Invalidation
```bash
# Invalidate specific path
gcloud compute url-maps invalidate-cdn-cache lb-url-map \
  --path="/images/logo.png" \
  --host="example.com"

# Invalidate multiple paths
gcloud compute url-maps invalidate-cdn-cache lb-url-map \
  --path="/images/*" \
  --host="example.com"

# Invalidate entire cache for a host
gcloud compute url-maps invalidate-cdn-cache lb-url-map \
  --path="/*" \
  --host="example.com"

Characteristics:
- Takes 5-10 minutes to propagate globally
- Counted toward quota (1000 per day by default)
- Use versioned URLs instead when possible
- Soft invalidation (content marked stale, removed gradually)

Best Practice: Versioned URLs
Instead of: /images/logo.png
Use: /images/logo.v2.png or /images/logo.png?v=2
Benefit: No invalidation needed, instant updates
```

### Signed URLs and Cookies
```
Purpose: Restrict access to cached content

Signed URL Example:
https://example.com/video.mp4?Expires=1234567890&KeyName=my-key&Signature=abc123...

Process:
1. Generate key pair
2. Add public key to backend service
3. Application generates signed URLs
4. CDN validates signature before serving

Configuration:
# Create signing key
openssl genrsa -out private_key.pem 2048
openssl rsa -in private_key.pem -pubout -out public_key.pem

# Add key to backend service
gcloud compute backend-services add-signed-url-key web-backend \
  --key-name=my-key \
  --key-file=public_key.pem \
  --global

# Generate signed URL (in application)
import base64
import hashlib
import datetime

def sign_url(url, key_name, private_key, expiration_time):
    # Implementation details
    pass

Use Cases:
- Paid content (videos, documents)
- Time-limited access
- User-specific content
- License verification
```

### Cloud CDN Performance Optimization

#### Negative Caching
```
Configuration:
gcloud compute backend-services update web-backend \
  --negative-caching \
  --negative-caching-policy=404=60,500=10 \
  --global

Behavior:
- Cache 404 responses for 60 seconds
- Cache 500 responses for 10 seconds
- Reduces origin load for errors
- Prevents error page fetch storms

Exam Tip: Enable negative caching to protect origin from repeated failed requests
```

#### Serve While Stale
```
Configuration:
gcloud compute backend-services update web-backend \
  --serve-while-stale=86400 \
  --global

Behavior:
- Serve stale content if origin is down
- Up to specified duration (86400s = 24 hours)
- Improves availability
- Marked with Warning header

Use Cases:
- High availability requirements
- Tolerate slightly stale content
- Origin maintenance windows
```

### Cloud CDN Monitoring
```
Key Metrics:
- Cache hit ratio (target: >80%)
- Cache fill bytes (origin egress)
- Request count by cache status
- Latency by cache status

View Metrics:
gcloud monitoring time-series list \
  --filter='metric.type="loadbalancing.googleapis.com/https/request_count"'

Logging:
- Enable CDN logging in backend service
- Logs include: cache status, latency, bytes
- Export to BigQuery for analysis

Troubleshooting:
Low cache hit ratio:
1. Check cache-control headers from origin
2. Verify cache key configuration
3. Look for high variation in URLs
4. Consider cache mode settings
```

## VPC Connectivity Options

### VPC Peering
- **Purpose**: Connect two VPC networks privately
- **Scope**: Can peer across projects and organizations
- **Routing**: Automatic route exchange
- **Limitations**: Not transitive, no overlapping IPs
- **Cost**: No additional cost (just normal traffic charges)

### Shared VPC
- **Purpose**: Share VPC across multiple projects
- **Model**: Host project shares with service projects
- **Benefits**: Centralized network management
- **Use Case**: Enterprise multi-project environments
- **Permissions**: Network admin in host project

### VPC Network Peering vs Shared VPC
| Feature | VPC Peering | Shared VPC |
|---------|-------------|------------|
| **Administration** | Distributed | Centralized |
| **Projects** | Separate projects | Host + service projects |
| **IAM** | Independent | Unified network IAM |
| **Use Case** | Simple connectivity | Enterprise organization |

## Hybrid Connectivity Deep Dive

### Cloud VPN Architecture

#### Classic VPN (Legacy - being deprecated)
```
Characteristics:
- Single VPN gateway (single point of failure)
- 99.9% SLA
- Static or dynamic routing
- Up to 3 Gbps per tunnel
- Being phased out

Exam Note: Know this exists but recommend HA VPN instead
```

#### HA VPN (Highly Available VPN)
```
Architecture:
┌─────────────────────────────────────────┐
│         On-Premises Network             │
│  ┌──────────┐         ┌──────────┐     │
│  │ Device 1 │         │ Device 2 │     │
│  └────┬─────┘         └─────┬────┘     │
│       │                     │          │
└───────┼─────────────────────┼──────────┘
        │    IPsec Tunnels    │
        │   (Encrypted)       │
┌───────┼─────────────────────┼──────────┐
│  ┌────▼─────┐         ┌─────▼────┐    │
│  │Interface0│         │Interface1│    │
│  └────┬─────┘         └─────┬────┘    │
│       └────────┬─────────────┘         │
│         HA VPN Gateway                 │
│         (Regional Resource)            │
│                                        │
│            GCP VPC Network             │
└────────────────────────────────────────┘

Key Features:
- Two external IP addresses (interfaces)
- 99.99% SLA when properly configured
- Requires two tunnels minimum
- Regional resource (not zonal)
- Automatic failover
- Up to 3 Gbps per tunnel (6+ Gbps total)
- Dynamic routing (BGP) required for SLA

SLA Requirements (Critical for Exam):
- Two on-premises VPN devices
- Two tunnels to each device (4 tunnels total)
- BGP routing configured
- Both interfaces active

Configuration Patterns:
1. Two on-prem devices: 4 tunnels (99.99% SLA)
2. One on-prem device: 2 tunnels (99.9% SLA)
3. Peer to another cloud: 2+ tunnels
```

#### HA VPN Configuration
```bash
# Create HA VPN Gateway
gcloud compute vpn-gateways create ha-vpn-gw-1 \
  --network=my-vpc \
  --region=us-central1

# Create Cloud Router for dynamic routing
gcloud compute routers create vpn-router-1 \
  --region=us-central1 \
  --network=my-vpc \
  --asn=65001

# Create external VPN gateway (represents on-premises)
gcloud compute external-vpn-gateways create on-prem-gateway \
  --interfaces=0=203.0.113.1,1=203.0.113.2

# Create VPN tunnels (interface 0 → on-prem device 1)
gcloud compute vpn-tunnels create tunnel-1 \
  --peer-external-gateway=on-prem-gateway \
  --peer-external-gateway-interface=0 \
  --region=us-central1 \
  --ike-version=2 \
  --shared-secret=SECRET_1 \
  --router=vpn-router-1 \
  --vpn-gateway=ha-vpn-gw-1 \
  --interface=0

# Create VPN tunnel (interface 0 → on-prem device 2)
gcloud compute vpn-tunnels create tunnel-2 \
  --peer-external-gateway=on-prem-gateway \
  --peer-external-gateway-interface=1 \
  --region=us-central1 \
  --ike-version=2 \
  --shared-secret=SECRET_2 \
  --router=vpn-router-1 \
  --vpn-gateway=ha-vpn-gw-1 \
  --interface=0

# Repeat for interface 1 (tunnels 3 & 4)

# Configure BGP sessions
gcloud compute routers add-bgp-peer vpn-router-1 \
  --peer-name=bgp-peer-1 \
  --interface=tunnel-1-interface \
  --peer-ip-address=169.254.1.1 \
  --peer-asn=65002 \
  --region=us-central1
```

### Cloud Interconnect Deep Dive

#### Dedicated Interconnect
```
Physical Connection to Google Network

Specifications:
├── Speeds: 10 Gbps or 100 Gbps per circuit
├── Location: Google Colocation Facilities
├── Latency: 1-2ms typical (depends on proximity)
├── SLA: 99.9% or 99.99% (with redundancy)
└── Cost: Port fee + egress (no ingress charges)

Architecture:
┌──────────────────────────────────────────┐
│     Your Data Center or Colo            │
│  ┌────────────┐                          │
│  │ Your Router│◄────── You manage       │
│  └──────┬─────┘                          │
└─────────┼────────────────────────────────┘
          │ (10/100 Gbps fiber)
          │ Cross-connect
┌─────────▼────────────────────────────────┐
│  ┌────────────┐                          │
│  │ Google Edge │                         │
│  │   Router    │◄────── Google manages   │
│  └──────┬─────┘                          │
│         │                                │
│    GCP Network                           │
└──────────────────────────────────────────┘

Use Cases:
- High bandwidth requirements (>3 Gbps sustained)
- Predictable network performance
- Lower egress costs than VPN
- Private access to Google services
- Regulatory/compliance requirements

Requirements:
- Physical presence in Google colo facility
- 10GBASE-LR or 100GBASE-LR optics
- BGP configuration
- Layer 3 connectivity
- Single-mode fiber

Cost Comparison (Monthly):
Port Fee: $1,700 (10G) or $27,000 (100G)
Egress: Significantly cheaper than internet egress
Breakeven: Typically 1-5 TB/month depending on region

Exam Scenarios:
Q: Company needs consistent 5 Gbps to GCP
A: Dedicated Interconnect (VPN max 3 Gbps per tunnel)

Q: Reduce network egress costs
A: Dedicated Interconnect (if traffic volume justifies)
```

#### Partner Interconnect
```
Connection via Service Provider

Specifications:
├── Speeds: 50 Mbps to 50 Gbps (incremental)
├── Location: Service provider facilities
├── SLA: Depends on provider (typically 99.9%)
├── Setup: Faster than Dedicated (no colo needed)
└── Cost: Provider charges + GCP egress

Architecture:
┌──────────────────────────────────────────┐
│     Your Data Center                     │
│  ┌────────────┐                          │
│  │ Your Router│                          │
│  └──────┬─────┘                          │
└─────────┼────────────────────────────────┘
          │ (Connection to provider)
┌─────────▼────────────────────────────────┐
│  Service Provider Network                │
│  ┌────────────┐                          │
│  │  Provider  │                          │
│  │   Router   │                          │
│  └──────┬─────┘                          │
└─────────┼────────────────────────────────┘
          │ (Provider → Google connection)
┌─────────▼────────────────────────────────┐
│  ┌────────────┐                          │
│  │ Google Edge│                          │
│  │   Router   │                          │
│  └──────┬─────┘                          │
│         │                                │
│    GCP Network                           │
└──────────────────────────────────────────┘

Available Bandwidth Options:
50 Mbps, 100 Mbps, 200 Mbps, 300 Mbps, 400 Mbps, 500 Mbps
1 Gbps, 2 Gbps, 5 Gbps, 10 Gbps, 20 Gbps, 50 Gbps

Service Provider Selection:
- Check availability in your region
- Compare pricing and SLAs
- Verify supported locations
- Consider existing relationships

Use Cases:
- No presence in Google colo facilities
- Flexible bandwidth requirements
- Need faster deployment than Dedicated
- Testing before Dedicated Interconnect
- Multiple smaller connections

Exam Tip: Choose Partner over Dedicated when:
- Not in Google colo facility
- Need <10 Gbps bandwidth
- Want faster deployment
- Flexibility more important than cost
```

### Hybrid Connectivity Decision Matrix

| Factor | Cloud VPN | Partner Interconnect | Dedicated Interconnect |
|--------|-----------|---------------------|------------------------|
| **Bandwidth** | Up to 3 Gbps/tunnel | 50 Mbps - 50 Gbps | 10 Gbps or 100 Gbps |
| **SLA** | 99.99% (HA VPN) | Provider-dependent | 99.9% (99.99% redundant) |
| **Setup Time** | Minutes to hours | Days to weeks | Weeks to months |
| **Location** | Anywhere with internet | Provider locations | Google colo only |
| **Cost (monthly)** | ~$50 + egress | $100s-$1000s + egress | $1,700+ + egress |
| **Security** | IPsec encrypted | Private connection | Private connection |
| **Latency** | Variable (internet) | Low, consistent | Lowest, most consistent |
| **Use Internet?** | Yes (encrypted) | No | No |
| **Redundancy** | Multiple tunnels | Multiple attachments | Multiple circuits |
| **BGP Support** | Yes (required HA) | Yes | Yes |

### Advanced Hybrid Patterns

#### Multi-Region Redundancy
```
Architecture:
On-Premises Data Center
    ├── VPN/Interconnect → us-central1 (primary)
    ├── VPN/Interconnect → us-east1 (secondary)
    └── VPN/Interconnect → europe-west1 (DR)

Configuration Strategy:
1. Primary connection: Dedicated/Partner Interconnect
2. Backup: HA VPN to same region
3. DR: Interconnect or VPN to different region

BGP Configuration:
- Use AS-PATH prepending for preference
- Local preference for traffic engineering
- MED (Multi-Exit Discriminator) for return path
- BFD (Bidirectional Forwarding Detection) for fast failover

Exam Pattern:
Q: High availability hybrid connectivity
A: HA VPN (99.99%) or dual Dedicated Interconnect circuits
```

#### Hybrid DNS Architecture
```
Requirements:
- On-premises VMs resolve GCP DNS names
- GCP VMs resolve on-premises DNS names
- Private zone management

Solution: Cloud DNS with Forwarding
┌─────────────────────────────────────────┐
│  On-Premises                            │
│  ├── DNS Server (company.local)        │
│  └── Forward *.googleapis.com → GCP    │
└─────────────────────────────────────────┘
           ↕ (VPN/Interconnect)
┌─────────────────────────────────────────┐
│  GCP                                    │
│  ├── Cloud DNS Private Zone            │
│  ├── Inbound Endpoint (on-prem queries)│
│  └── Outbound Policy (forward to       │
│      on-prem DNS)                       │
└─────────────────────────────────────────┘

Configuration:
# Create private zone
gcloud dns managed-zones create gcp-private \
  --description="GCP private zone" \
  --dns-name=gcp.company.local \
  --networks=my-vpc \
  --visibility=private

# Create DNS policy for outbound forwarding
gcloud dns policies create hybrid-dns-policy \
  --description="Forward to on-prem DNS" \
  --networks=my-vpc \
  --enable-inbound-forwarding \
  --alternative-name-servers=10.0.1.5,10.0.1.6
```

#### VLAN Attachments (for Interconnect)
```
Purpose: Segment traffic over Interconnect

Topology:
Physical Connection (10/100G)
├── VLAN 100: Production (Attachment 1)
├── VLAN 200: Staging (Attachment 2)
├── VLAN 300: Development (Attachment 3)
└── VLAN 400: Management (Attachment 4)

Configuration:
gcloud compute interconnects attachments create prod-vlan \
  --region=us-central1 \
  --router=interconnect-router \
  --interconnect=my-interconnect \
  --vlan=100 \
  --candidate-subnets=169.254.100.0/29

Benefits:
- Logical separation over shared physical connection
- Different VPCs over same Interconnect
- QoS and traffic management
- Cost optimization (share port fees)

Limits:
- 8 VLAN attachments per Interconnect
- Must use /29 for BGP peering
- Cannot overlap subnets
```

## Cloud DNS

### What is Cloud DNS?
Scalable, reliable, managed authoritative DNS service running on Google's infrastructure.

### Key Features
- **100% uptime SLA**: Highly available service
- **Global network**: Anycast DNS servers
- **DNSSEC**: Domain name system security extensions
- **Private zones**: Internal DNS resolution
- **Logging**: Query logging for analysis

### Zone Types
| Type | Purpose | Visibility |
|------|---------|------------|
| **Public** | Internet-facing domains | Global |
| **Private** | Internal resolution | VPC networks |
| **Forwarding** | Forward queries | VPC networks |
| **Peering** | Cross-project resolution | VPC networks |

### DNS Policies
- **Inbound forwarding**: External DNS can query private zones
- **Outbound forwarding**: Forward specific domains to external DNS
- **Logging**: Enable query logging for monitoring

## Identity-Aware Proxy (IAP)

### What is IAP?
Central authentication and authorization service for applications accessed via HTTPS.

### Key Benefits
- **Zero-trust security**: Verify user and device
- **No VPN required**: Direct internet access with protection
- **Google integration**: Works with Google Cloud services
- **Fine-grained access**: Per-application permissions

### How IAP Works
1. User accesses application
2. IAP checks authentication
3. If authenticated, checks authorization
4. Allows or denies access based on policy

### Use Cases
- **Internal applications**: Secure employee access
- **Partner access**: Controlled external access
- **Development environments**: Secure staging/test environments

## Network Security Deep Dive

### Cloud Armor (WAF and DDoS Protection)

#### Overview
```
Cloud Armor = WAF + DDoS Protection + Bot Management

Integration: Only with External HTTP(S) Load Balancers
Scope: Global (applies at edge)
Pricing: Per policy + per request evaluated

Architecture:
Internet → Cloud Armor (edge) → Load Balancer → Backends
              │
              ├─ Allow/Deny rules
              ├─ Rate limiting
              ├─ Geo-blocking
              └─ WAF rules (OWASP)
```

#### Security Policy Configuration
```bash
# Create security policy
gcloud compute security-policies create web-security-policy \
  --description="Production web application security"

# Default rule (apply last)
gcloud compute security-policies rules create 2147483647 \
  --security-policy=web-security-policy \
  --action=deny-403 \
  --description="Default deny"

# Allow specific countries
gcloud compute security-policies rules create 1000 \
  --security-policy=web-security-policy \
  --expression="origin.region_code in ['US', 'CA', 'GB']" \
  --action=allow \
  --description="Allow US, Canada, UK"

# Block known malicious IPs
gcloud compute security-policies rules create 2000 \
  --security-policy=web-security-policy \
  --src-ip-ranges=198.51.100.0/24,203.0.113.0/24 \
  --action=deny-403 \
  --description="Block malicious IP ranges"

# Rate limiting (per client IP)
gcloud compute security-policies rules create 3000 \
  --security-policy=web-security-policy \
  --expression="true" \
  --action=rate-based-ban \
  --rate-limit-threshold-count=100 \
  --rate-limit-threshold-interval-sec=60 \
  --ban-duration-sec=600 \
  --conform-action=allow \
  --exceed-action=deny-429 \
  --enforce-on-key=IP \
  --description="Rate limit: 100 req/min per IP"

# Attach to backend service
gcloud compute backend-services update web-backend \
  --security-policy=web-security-policy \
  --global
```

#### Pre-configured WAF Rules (OWASP Top 10)
```bash
# Enable OWASP ModSecurity Core Rule Set
gcloud compute security-policies rules create 4000 \
  --security-policy=web-security-policy \
  --expression="evaluatePreconfiguredExpr('sqli-stable')" \
  --action=deny-403 \
  --description="Block SQL injection"

# Available pre-configured expressions:
- sqli-stable: SQL injection attacks
- xss-stable: Cross-site scripting
- lfi-stable: Local file inclusion
- rce-stable: Remote code execution
- rfi-stable: Remote file inclusion
- scannerdetection-stable: Security scanner detection
- protocolattack-stable: Protocol attacks
- sessionfixation-stable: Session fixation
- java-stable: Java attack detection

# Multiple rules combined
gcloud compute security-policies rules create 5000 \
  --security-policy=web-security-policy \
  --expression="evaluatePreconfiguredExpr('sqli-stable') || evaluatePreconfiguredExpr('xss-stable')" \
  --action=deny-403 \
  --description="Block SQL injection and XSS"
```

#### Advanced Cloud Armor Features

##### Custom Rules with CEL (Common Expression Language)
```bash
# Block specific user agents
--expression="has(request.headers['user-agent']) && request.headers['user-agent'].contains('BadBot')"

# Block specific paths
--expression="request.path.startsWith('/admin') && origin.region_code != 'US'"

# Block based on request method
--expression="request.method == 'POST' && !request.path.startsWith('/api')"

# Combine multiple conditions
--expression="origin.region_code in ['CN', 'RU'] && request.path.contains('/login')"

# Header-based blocking
--expression="has(request.headers['x-custom-header']) && request.headers['x-custom-header'] != 'expected-value'"
```

##### Adaptive Protection (ML-based DDoS)
```bash
# Enable adaptive protection
gcloud compute security-policies update web-security-policy \
  --enable-layer7-ddos-defense \
  --layer7-ddos-defense-rule-visibility=STANDARD

Features:
- Machine learning detects anomalous traffic
- Automatic rule generation during attacks
- Works with rate limiting
- Generates alerts in Cloud Monitoring

Alert Configuration:
- Monitors request patterns
- Detects sudden traffic spikes
- Identifies attack signatures
- Auto-generates blocking rules
```

##### Rate Limiting Strategies
```
1. Per Client IP (most common)
   --enforce-on-key=IP

2. Per HTTP Header
   --enforce-on-key=HTTP-HEADER
   --enforce-on-key-name=X-API-Key

3. Per Region Code
   --enforce-on-key=REGION-CODE

4. Per ALL (global limit)
   --enforce-on-key=ALL

5. Per XFF IP (behind proxy)
   --enforce-on-key=XFF-IP

Exam Scenario:
Q: API key abuse, multiple requests per key
A: Rate limit with --enforce-on-key=HTTP-HEADER --enforce-on-key-name=X-API-Key
```

##### Bot Management
```bash
# Challenge suspected bots with reCAPTCHA
gcloud compute security-policies rules create 6000 \
  --security-policy=web-security-policy \
  --expression="evaluatePreconfiguredExpr('bot-management')" \
  --action=redirect \
  --redirect-type=google-recaptcha \
  --description="Bot detection"

Bot Detection Features:
- Behavioral analysis
- JavaScript challenge
- reCAPTCHA integration
- Machine learning signals

Use Cases:
- Credential stuffing prevention
- Scraping protection
- Inventory hoarding (tickets, sneakers)
- Click fraud prevention
```

### VPC Firewall Rules Deep Dive

#### Hierarchical Firewall Policies
```
Organization-level vs VPC-level:

Organization Policy (Hierarchical)
├── Applied to entire organization or folders
├── Inherited by all projects/VPCs
├── Cannot be overridden by VPC rules
├── Priority: 0-2147483647
└── Use for corporate-wide rules

VPC Firewall Rules (Legacy, still common)
├── Applied to specific VPC
├── Priority: 0-65535
├── Can be overridden within VPC
└── Most granular control

Evaluation Order:
1. Hierarchical deny rules (highest priority)
2. Hierarchical allow rules
3. VPC deny rules
4. VPC allow rules (lowest priority)

Configuration (Hierarchical):
gcloud compute firewall-policies create corp-firewall-policy \
  --description="Corporate security policy"

gcloud compute firewall-policies rules create 100 \
  --firewall-policy=corp-firewall-policy \
  --action=deny \
  --direction=ingress \
  --src-ip-ranges=0.0.0.0/0 \
  --layer4-configs=tcp:22 \
  --description="Block SSH from internet"

gcloud compute firewall-policies associations create \
  --firewall-policy=corp-firewall-policy \
  --organization=ORGANIZATION_ID
```

#### Firewall Rule Best Practices
```bash
# 1. Deny-by-default, allow specific
gcloud compute firewall-rules create deny-all-ingress \
  --network=prod-vpc \
  --action=deny \
  --direction=ingress \
  --priority=65534 \
  --source-ranges=0.0.0.0/0 \
  --rules=all

# 2. Allow only necessary ports for web tier
gcloud compute firewall-rules create allow-web-tier \
  --network=prod-vpc \
  --action=allow \
  --direction=ingress \
  --priority=1000 \
  --target-tags=web-server \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:80,tcp:443

# 3. Allow internal communication between tiers
gcloud compute firewall-rules create allow-web-to-app \
  --network=prod-vpc \
  --action=allow \
  --direction=ingress \
  --priority=1000 \
  --target-tags=app-server \
  --source-tags=web-server \
  --rules=tcp:8080

# 4. Use service accounts (more secure than tags)
gcloud compute firewall-rules create allow-app-to-db \
  --network=prod-vpc \
  --action=allow \
  --direction=ingress \
  --priority=1000 \
  --target-service-accounts=db-sa@project.iam.gserviceaccount.com \
  --source-service-accounts=app-sa@project.iam.gserviceaccount.com \
  --rules=tcp:3306

# 5. Enable firewall logs for audit
gcloud compute firewall-rules update allow-web-tier \
  --enable-logging \
  --logging-metadata=include-all

Exam Tips:
- Lower priority number = higher priority (0 is highest)
- Firewall is stateful (return traffic auto-allowed)
- Implied deny-all at priority 65535
- Service accounts > tags for security
- Enable logging for compliance
```

#### Egress Firewall Rules
```bash
# Default allows all egress, lock it down:

# Deny all egress (default)
gcloud compute firewall-rules create deny-all-egress \
  --network=prod-vpc \
  --action=deny \
  --direction=egress \
  --priority=65534 \
  --destination-ranges=0.0.0.0/0 \
  --rules=all

# Allow egress to Google APIs
gcloud compute firewall-rules create allow-google-apis \
  --network=prod-vpc \
  --action=allow \
  --direction=egress \
  --priority=1000 \
  --destination-ranges=199.36.153.4/30 \
  --rules=tcp:443

# Allow egress to specific external service
gcloud compute firewall-rules create allow-external-api \
  --network=prod-vpc \
  --action=allow \
  --direction=egress \
  --priority=1100 \
  --source-tags=app-server \
  --destination-ranges=203.0.113.0/24 \
  --rules=tcp:443

Use Cases:
- Data exfiltration prevention
- Compliance requirements (PCI-DSS, HIPAA)
- Zero-trust architectures
- Prevent malware C&C communication
```

### VPC Service Controls (Advanced)

#### What are VPC Service Controls?
```
Purpose: Create security perimeters around Google Cloud resources

Protection:
- Prevents data exfiltration
- Enforces context-aware access
- Protects Google-managed services
- Works across projects

Supported Services:
- Cloud Storage
- BigQuery
- Cloud SQL
- Dataflow
- Pub/Sub
- And 40+ more

Architecture:
┌─────────────────────────────────────┐
│   VPC Service Control Perimeter     │
│                                     │
│  ┌──────────┐      ┌──────────┐   │
│  │ Project A│──────│ Project B│   │
│  │          │      │          │   │
│  │ GCS      │      │ BigQuery │   │
│  └──────────┘      └──────────┘   │
│                                     │
└─────────────────────────────────────┘
         │                   │
         ✓ Allowed           ✗ Blocked
    (within perimeter)  (outside perimeter)
```

#### VPC Service Controls Configuration
```bash
# Create access policy
gcloud access-context-manager policies create \
  --title="Production Perimeter Policy" \
  --organization=ORGANIZATION_ID

# Create service perimeter
gcloud access-context-manager perimeters create prod_perimeter \
  --title="Production Services" \
  --resources=projects/PROJECT_NUMBER_1,projects/PROJECT_NUMBER_2 \
  --restricted-services=storage.googleapis.com,bigquery.googleapis.com \
  --vpc-allowed-services=storage.googleapis.com \
  --policy=POLICY_ID

# Allow access from specific VPC
gcloud access-context-manager perimeters update prod_perimeter \
  --add-vpc-allowed-services=storage.googleapis.com \
  --policy=POLICY_ID

Exam Scenarios:
Q: Prevent accidental data copy from BigQuery to external bucket
A: VPC Service Controls with perimeter around project

Q: Allow access to Cloud Storage only from specific VPC
A: VPC Service Controls with VPC restriction
```

#### Ingress and Egress Rules
```yaml
# Advanced perimeter with ingress/egress policies

Ingress Rule Example (allow from on-premises):
ingressPolicies:
- ingressFrom:
    sources:
    - accessLevel: accessPolicies/POLICY_ID/accessLevels/onprem_network
    identities:
    - user:admin@example.com
  ingressTo:
    resources:
    - projects/PROJECT_NUMBER
    operations:
    - serviceName: storage.googleapis.com
      methodSelectors:
      - method: "*"

Egress Rule Example (allow to partner):
egressPolicies:
- egressFrom:
    identities:
    - serviceAccount:data-export@project.iam.gserviceaccount.com
  egressTo:
    resources:
    - projects/PARTNER_PROJECT_NUMBER
    operations:
    - serviceName: bigquery.googleapis.com
      methodSelectors:
      - method: "google.cloud.bigquery.v2.JobService.InsertJob"

Use Cases:
- Hybrid cloud data governance
- Partner data sharing
- Multi-project workflows
- Compliance boundaries
```

### Private Service Connect (PSC)

#### PSC for Google APIs
```
Evolution: Private Google Access → Private Service Connect

Benefits:
- Uses your VPC IP addresses
- Works with on-premises (via VPN/Interconnect)
- No internet exposure
- Supports VPC-SC perimeters
- Fine-grained DNS control

Architecture:
On-Premises ←─VPN/Interconnect─→ GCP VPC
                                    │
                              PSC Endpoint
                            (10.1.1.5 - your IP)
                                    │
                          ┌─────────┴─────────┐
                   Cloud Storage          BigQuery
                   (googleapis.com)

Configuration:
# Reserve internal IP
gcloud compute addresses create psc-google-apis \
  --global \
  --purpose=PRIVATE_SERVICE_CONNECT \
  --addresses=10.1.1.5 \
  --network=my-vpc

# Create forwarding rule
gcloud compute forwarding-rules create psc-rule \
  --global \
  --network=my-vpc \
  --address=psc-google-apis \
  --target-google-apis-bundle=all-apis \
  --service-directory-registration=projects/PROJECT/locations/us-central1

# Configure DNS
gcloud dns managed-zones create googleapis-zone \
  --description="Private zone for googleapis.com" \
  --dns-name=googleapis.com \
  --networks=my-vpc \
  --visibility=private

gcloud dns record-sets create storage.googleapis.com. \
  --zone=googleapis-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=10.1.1.5
```

#### PSC for Published Services (SaaS Connectivity)
```
Use Case: Private connection to third-party SaaS

Architecture:
Your VPC          PSC Endpoint      Service Producer VPC
  │                   │                      │
VM ─────→ 10.1.1.100 ─────────────→ SaaS Application
         (your IP)            (private connection)

Benefits:
- No public IP exposure
- Traffic stays on Google network
- Reduced attack surface
- Simplified firewall rules

Configuration:
# Create endpoint
gcloud compute forwarding-rules create saas-endpoint \
  --region=us-central1 \
  --network=my-vpc \
  --subnet=prod-subnet \
  --target-service-attachment=projects/PRODUCER_PROJECT/regions/us-central1/serviceAttachments/SERVICE_NAME

Use Cases:
- MongoDB Atlas via PSC
- Confluent Cloud via PSC
- Elastic Cloud via PSC
- Custom SaaS connections
```

### VPC Flow Logs

#### Configuration and Use
```bash
# Enable flow logs on subnet
gcloud compute networks subnets update prod-subnet \
  --region=us-central1 \
  --enable-flow-logs \
  --logging-aggregation-interval=interval-5-sec \
  --logging-flow-sampling=0.5 \
  --logging-metadata=include-all

Parameters:
- aggregation-interval: 5s, 30s, 1m, 5m, 10m, 15m
- flow-sampling: 0.0-1.0 (0.5 = 50% of flows)
- metadata: include-all or exclude-all

Flow Log Fields:
- src_ip, dest_ip
- src_port, dest_port
- protocol (TCP, UDP, ICMP)
- bytes_sent, packets_sent
- rtt_msec (round-trip time)
- connection.src_gke_details (for GKE)

Export to BigQuery:
# Create sink
gcloud logging sinks create flow-logs-sink \
  bigquery.googleapis.com/projects/PROJECT/datasets/flow_logs \
  --log-filter='resource.type="gce_subnetwork" AND logName=~"logs/compute.googleapis.com/vpc_flows"'
```

#### Flow Logs Analysis Queries
```sql
-- Top talkers (most traffic)
SELECT
  jsonPayload.connection.src_ip,
  jsonPayload.connection.dest_ip,
  SUM(CAST(jsonPayload.bytes_sent AS INT64)) as total_bytes
FROM `project.dataset.vpc_flows`
WHERE DATE(timestamp) = CURRENT_DATE()
GROUP BY 1, 2
ORDER BY total_bytes DESC
LIMIT 100

-- Detect potential DDoS (high connection rate to single IP)
SELECT
  jsonPayload.connection.dest_ip,
  COUNT(DISTINCT jsonPayload.connection.src_ip) as unique_sources,
  COUNT(*) as connection_count
FROM `project.dataset.vpc_flows`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 MINUTE)
GROUP BY 1
HAVING connection_count > 1000
ORDER BY connection_count DESC

-- Detect data exfiltration (large outbound transfers)
SELECT
  jsonPayload.connection.src_ip,
  jsonPayload.connection.dest_ip,
  SUM(CAST(jsonPayload.bytes_sent AS INT64)) / 1024 / 1024 as mb_sent
FROM `project.dataset.vpc_flows`
WHERE jsonPayload.connection.dest_ip NOT LIKE '10.%'
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY 1, 2
HAVING mb_sent > 1000
ORDER BY mb_sent DESC

Exam Use Cases:
- Security forensics
- Network troubleshooting
- Compliance auditing
- Cost attribution
- Performance analysis
```

## Network Architecture Scenarios (Exam-Focused)

### Scenario 1: Multi-Tier Web Application with Global Reach

#### Requirements
- Web application serving users globally
- Three tiers: web, application, database
- High availability (99.95%+)
- Low latency for global users
- DDoS protection
- Cost optimization

#### Architecture
```
Internet Users (Global)
        │
        ▼
┌───────────────────────────────────────┐
│   Global HTTP(S) Load Balancer       │
│   - Anycast IP: 34.149.x.x           │
│   - Cloud CDN enabled                 │
│   - Cloud Armor (WAF + DDoS)         │
└───────┬───────────────────────────────┘
        │
    ┌───┴────────────────────┐
    │                        │
┌───▼─────┐          ┌───────▼────┐
│us-central1│          │europe-west1│
│                      │            │
│ Web Tier            │ Web Tier   │
│ 10.1.1.0/24        │ 10.2.1.0/24│
│ (MIG: 3-10 VMs)    │ (MIG: 3-10)│
└───┬─────┘          └───────┬────┘
    │                        │
┌───▼─────────────────────────▼────┐
│   Internal HTTP(S) Load Balancer │
│   (Regional - per region)        │
└───┬─────────────────────────┬────┘
    │                         │
┌───▼─────┐          ┌────────▼───┐
│App Tier │          │ App Tier   │
│10.1.2.0/│          │10.2.2.0/24 │
│24 (MIG) │          │    (MIG)   │
└───┬─────┘          └────────┬───┘
    │                         │
    └──────────┬──────────────┘
               │
    ┌──────────▼──────────────┐
    │ Internal TCP/UDP LB     │
    │ (for database failover) │
    └──────────┬──────────────┘
               │
        ┌──────┴──────┐
    ┌───▼────┐    ┌───▼────┐
    │Cloud SQL│    │Read    │
    │Primary  │────│Replica │
    │us-cent1 │    │eu-west1│
    └─────────┘    └────────┘
```

#### Implementation
```bash
# 1. Create VPC
gcloud compute networks create prod-vpc \
  --subnet-mode=custom \
  --bgp-routing-mode=global

# 2. Create subnets in each region
for REGION in us-central1 europe-west1; do
  gcloud compute networks subnets create web-tier-$REGION \
    --network=prod-vpc \
    --region=$REGION \
    --range=10.$((REGION_NUM)).1.0/24 \
    --enable-private-ip-google-access

  gcloud compute networks subnets create app-tier-$REGION \
    --network=prod-vpc \
    --region=$REGION \
    --range=10.$((REGION_NUM)).2.0/24 \
    --enable-private-ip-google-access

  gcloud compute networks subnets create db-tier-$REGION \
    --network=prod-vpc \
    --region=$REGION \
    --range=10.$((REGION_NUM)).3.0/24 \
    --enable-private-ip-google-access
done

# 3. Create firewall rules
# Allow health checks
gcloud compute firewall-rules create allow-health-checks \
  --network=prod-vpc \
  --allow=tcp \
  --source-ranges=35.191.0.0/16,130.211.0.0/22

# Allow web tier from internet (via load balancer)
gcloud compute firewall-rules create allow-web-lb \
  --network=prod-vpc \
  --allow=tcp:80,tcp:443 \
  --target-tags=web-server \
  --source-ranges=130.211.0.0/22,35.191.0.0/16

# Allow app tier from web tier only
gcloud compute firewall-rules create allow-web-to-app \
  --network=prod-vpc \
  --allow=tcp:8080 \
  --target-tags=app-server \
  --source-tags=web-server

# Allow db tier from app tier only
gcloud compute firewall-rules create allow-app-to-db \
  --network=prod-vpc \
  --allow=tcp:3306 \
  --target-tags=db-server \
  --source-tags=app-server

# 4. Setup Global HTTP(S) Load Balancer with Cloud CDN
gcloud compute backend-services create web-backend \
  --global \
  --protocol=HTTPS \
  --health-checks=web-health-check \
  --enable-cdn \
  --cache-mode=USE_ORIGIN_HEADERS \
  --session-affinity=CLIENT_IP

# 5. Setup Cloud Armor
gcloud compute security-policies create prod-security \
  --description="Production WAF policy"

gcloud compute security-policies rules create 1000 \
  --security-policy=prod-security \
  --expression="evaluatePreconfiguredExpr('sqli-stable') || evaluatePreconfiguredExpr('xss-stable')" \
  --action=deny-403

gcloud compute backend-services update web-backend \
  --security-policy=prod-security \
  --global
```

#### Exam Tips for This Scenario
- Global HTTP(S) LB provides anycast IP (single IP for all regions)
- Cloud CDN reduces latency and origin load
- Cloud Armor must be attached to backend service
- Internal HTTP(S) LB for microservices (web to app)
- Firewall rules follow principle of least privilege
- Private Google Access for VMs without external IPs

### Scenario 2: Hybrid Cloud with On-Premises Integration

#### Requirements
- On-premises datacenter with 500+ VMs
- GCP workloads need access to on-prem databases
- On-prem users need access to GCP applications
- 5 Gbps bandwidth required
- 99.99% availability
- Latency <5ms
- DNS resolution both ways

#### Architecture
```
On-Premises Data Center
├── IP Range: 172.16.0.0/12
├── DNS: 172.16.1.5, 172.16.1.6
├── VPN Device 1: 203.0.113.1
└── VPN Device 2: 203.0.113.2
        │
        ├── Dedicated Interconnect (10 Gbps)
        │   ├── Primary Circuit → us-central1
        │   └── Secondary Circuit → us-east1
        │
        └── HA VPN (Backup)
            └── 4 Tunnels → us-central1
        │
        ▼
┌─────────────────────────────────────────┐
│          GCP VPC Network                │
│                                         │
│  Shared VPC (Host Project)             │
│  ├── IP Range: 10.0.0.0/8             │
│  ├── Cloud DNS Private Zone           │
│  │   ├── gcp.company.local            │
│  │   └── Inbound/Outbound Forwarding  │
│  │                                     │
│  ├── Service Project A (Production)   │
│  │   └── Subnet: 10.1.0.0/16          │
│  │                                     │
│  ├── Service Project B (Staging)      │
│  │   └── Subnet: 10.2.0.0/16          │
│  │                                     │
│  └── Service Project C (Development)  │
│      └── Subnet: 10.3.0.0/16          │
└─────────────────────────────────────────┘
```

#### Implementation
```bash
# 1. Create Shared VPC in host project
gcloud compute networks create shared-vpc \
  --subnet-mode=custom \
  --bgp-routing-mode=global \
  --project=host-project

# 2. Enable Shared VPC
gcloud compute shared-vpc enable host-project

# 3. Attach service projects
for PROJECT in service-project-a service-project-b service-project-c; do
  gcloud compute shared-vpc associated-projects add $PROJECT \
    --host-project=host-project
done

# 4. Create subnets for each service project
gcloud compute networks subnets create prod-subnet \
  --network=shared-vpc \
  --region=us-central1 \
  --range=10.1.0.0/16 \
  --enable-private-ip-google-access \
  --project=host-project

# 5. Setup Dedicated Interconnect
# Order interconnect from Google Console
# Once provisioned, create VLAN attachments

gcloud compute routers create interconnect-router \
  --asn=65001 \
  --network=shared-vpc \
  --region=us-central1 \
  --project=host-project

gcloud compute interconnects attachments dedicated create prod-vlan \
  --region=us-central1 \
  --router=interconnect-router \
  --interconnect=INTERCONNECT_NAME \
  --vlan=100 \
  --project=host-project

# 6. Setup HA VPN as backup
gcloud compute vpn-gateways create ha-vpn-backup \
  --network=shared-vpc \
  --region=us-central1 \
  --project=host-project

# Create external gateway representing on-prem
gcloud compute external-vpn-gateways create onprem-gateway \
  --interfaces=0=203.0.113.1,1=203.0.113.2 \
  --project=host-project

# Create 4 tunnels for 99.99% SLA
for INTERFACE in 0 1; do
  for PEER_INTERFACE in 0 1; do
    gcloud compute vpn-tunnels create tunnel-${INTERFACE}-${PEER_INTERFACE} \
      --peer-external-gateway=onprem-gateway \
      --peer-external-gateway-interface=$PEER_INTERFACE \
      --region=us-central1 \
      --ike-version=2 \
      --shared-secret=SECRET \
      --router=interconnect-router \
      --vpn-gateway=ha-vpn-backup \
      --interface=$INTERFACE \
      --project=host-project
  done
done

# 7. Setup hybrid DNS
# Create private zone for GCP resources
gcloud dns managed-zones create gcp-zone \
  --description="GCP private zone" \
  --dns-name=gcp.company.local \
  --networks=shared-vpc \
  --visibility=private \
  --project=host-project

# Create DNS policy for hybrid resolution
gcloud dns policies create hybrid-dns \
  --description="Hybrid DNS forwarding" \
  --networks=shared-vpc \
  --enable-inbound-forwarding \
  --alternative-name-servers=172.16.1.5,172.16.1.6 \
  --private-alternative-name-servers=172.16.1.5,172.16.1.6 \
  --project=host-project

# 8. Setup Private Service Connect for Google APIs
gcloud compute addresses create psc-apis \
  --global \
  --purpose=PRIVATE_SERVICE_CONNECT \
  --addresses=10.255.255.5 \
  --network=shared-vpc \
  --project=host-project

gcloud compute forwarding-rules create psc-rule \
  --global \
  --network=shared-vpc \
  --address=psc-apis \
  --target-google-apis-bundle=all-apis \
  --project=host-project
```

#### Exam Tips for This Scenario
- Dedicated Interconnect for high bandwidth (>3 Gbps)
- HA VPN as backup (requires 2+ tunnels for 99.99% SLA)
- Shared VPC for centralized network management
- BGP with BFD for fast failover (<1 second)
- Private Service Connect better than Private Google Access for hybrid
- Cloud DNS with inbound/outbound forwarding for hybrid DNS
- VLAN attachments for logical segmentation
- Interconnect SLA: 99.99% with redundant circuits

### Scenario 3: SaaS Application with Multi-Tenant Architecture

#### Requirements
- SaaS platform serving 1000+ customers
- Tenant isolation required
- Internal microservices architecture
- Global distribution
- API rate limiting per tenant
- Zero-trust security model

#### Architecture
```
Internet (Customers)
        │
        ▼
┌────────────────────────────────────────┐
│  Global HTTP(S) Load Balancer         │
│  - Cloud Armor (rate limiting per API)│
│  - Cloud CDN for static assets        │
└────────┬───────────────────────────────┘
         │
    ┌────┴────────┐
┌───▼────┐   ┌────▼────┐
│us-cent1│   │eu-west1 │
│        │   │         │
│API GW  │   │ API GW  │
│(IAP)   │   │ (IAP)   │
└───┬────┘   └────┬────┘
    │             │
    └──────┬──────┘
           │
┌──────────▼───────────────────────────┐
│  Internal HTTP(S) Load Balancer     │
│  (Cross-Region)                     │
└──────────┬───────────────────────────┘
           │
    ┌──────┴─────────┐
┌───▼────────┐  ┌────▼────────┐
│Auth Service│  │Tenant Service│
│(GKE)       │  │(GKE)         │
└───┬────────┘  └────┬─────────┘
    │                │
    └────────┬───────┘
             │
┌────────────▼──────────────────────┐
│  Service Mesh (Istio)             │
│  - mTLS between services          │
│  - Fine-grained access control    │
│  - Distributed tracing            │
└────────────┬──────────────────────┘
             │
    ┌────────┴────────┐
┌───▼──────┐    ┌─────▼──────┐
│Billing   │    │Analytics   │
│Service   │    │Service     │
│(Cloud Run)    │(Cloud Run) │
└───┬──────┘    └─────┬──────┘
    │                 │
    └────────┬────────┘
             │
┌────────────▼──────────────────┐
│  Data Layer                   │
│  ├── Firestore (tenant data)  │
│  ├── Cloud SQL (billing)      │
│  └── BigQuery (analytics)     │
│                               │
│  VPC Service Controls        │
│  (data exfiltration prevent) │
└───────────────────────────────┘
```

#### Implementation
```bash
# 1. Create VPC with GKE-optimized subnets
gcloud compute networks create saas-vpc \
  --subnet-mode=custom \
  --bgp-routing-mode=global

gcloud compute networks subnets create gke-subnet-us \
  --network=saas-vpc \
  --region=us-central1 \
  --range=10.1.0.0/22 \
  --secondary-range pods=10.100.0.0/14,services=10.104.0.0/16 \
  --enable-private-ip-google-access

# 2. Create GKE cluster with Workload Identity
gcloud container clusters create saas-cluster \
  --region=us-central1 \
  --network=saas-vpc \
  --subnetwork=gke-subnet-us \
  --enable-ip-alias \
  --cluster-secondary-range-name=pods \
  --services-secondary-range-name=services \
  --enable-private-nodes \
  --enable-private-endpoint \
  --master-ipv4-cidr=172.16.0.0/28 \
  --workload-pool=PROJECT_ID.svc.id.goog \
  --enable-stackdriver-kubernetes \
  --enable-network-policy

# 3. Setup Global HTTP(S) LB with Cloud Armor
gcloud compute security-policies create saas-security \
  --description="SaaS platform security policy"

# Rate limiting per API key (tenant)
gcloud compute security-policies rules create 1000 \
  --security-policy=saas-security \
  --expression="request.path.startsWith('/api/')" \
  --action=rate-based-ban \
  --rate-limit-threshold-count=1000 \
  --rate-limit-threshold-interval-sec=60 \
  --ban-duration-sec=600 \
  --enforce-on-key=HTTP-HEADER \
  --enforce-on-key-name=X-API-Key \
  --exceed-action=deny-429

# Block known malicious patterns
gcloud compute security-policies rules create 2000 \
  --security-policy=saas-security \
  --expression="evaluatePreconfiguredExpr('sqli-stable') || evaluatePreconfiguredExpr('xss-stable')" \
  --action=deny-403

# 4. Setup IAP for admin portal
gcloud compute backend-services update admin-backend \
  --iap=enabled \
  --global

# Grant IAP access to admin users
gcloud iap web add-iam-policy-binding \
  --resource-type=backend-services \
  --service=admin-backend \
  --member=group:admins@company.com \
  --role=roles/iap.httpsResourceAccessor

# 5. Setup VPC Service Controls
gcloud access-context-manager policies create \
  --title="SaaS Platform Policy" \
  --organization=ORG_ID

gcloud access-context-manager perimeters create saas-perimeter \
  --title="SaaS Platform Perimeter" \
  --resources=projects/PROJECT_NUMBER \
  --restricted-services=storage.googleapis.com,bigquery.googleapis.com,firestore.googleapis.com \
  --policy=POLICY_ID

# 6. Setup Private Service Connect for internal services
gcloud compute addresses create internal-psc \
  --global \
  --purpose=PRIVATE_SERVICE_CONNECT \
  --addresses=10.255.255.10 \
  --network=saas-vpc

# 7. Deploy Istio service mesh for mTLS
gcloud container clusters get-credentials saas-cluster --region=us-central1
kubectl create namespace istio-system
kubectl apply -f istio-install.yaml

# Enable mTLS STRICT mode
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
EOF
```

#### Exam Tips for This Scenario
- IAP for zero-trust access (no VPN needed)
- Cloud Armor rate limiting per API key (enforce-on-key)
- VPC Service Controls prevent data exfiltration
- GKE with Workload Identity (no service account keys)
- Service mesh (Istio) for mTLS and fine-grained control
- Private Service Connect for internal service communication
- Cross-Region Internal LB for global internal services
- Secondary IP ranges required for GKE (pods and services)

### Scenario 4: Disaster Recovery and Multi-Region Failover

#### Requirements
- Active-passive DR setup
- Primary: us-central1, DR: us-east1
- RTO: 15 minutes, RPO: 5 minutes
- Automatic failover for load balancers
- Database replication
- Cost optimization (DR minimal when not active)

#### Architecture
```
Primary Region (us-central1) [Active]
├── VPC: dr-vpc (global)
├── Subnet: 10.1.0.0/16
├── Compute: 10 VMs (MIG)
├── Cloud SQL: Primary instance
├── Cloud Storage: prod-bucket
└── Load Balancer: Active

DR Region (us-east1) [Standby]
├── Same VPC: dr-vpc
├── Subnet: 10.2.0.0/16
├── Compute: 2 VMs (MIG, min=0, max=10)
├── Cloud SQL: Read replica
├── Cloud Storage: replication enabled
└── Load Balancer: Same global LB

Failover Mechanism:
├── Global HTTP(S) LB health checks
├── Automatic backend selection
├── Cloud SQL failover to replica
└── Manual DNS update (optional)
```

#### Implementation
```bash
# 1. Create VPC (global, both regions)
gcloud compute networks create dr-vpc \
  --subnet-mode=custom \
  --bgp-routing-mode=global

# Primary region subnet
gcloud compute networks subnets create primary-subnet \
  --network=dr-vpc \
  --region=us-central1 \
  --range=10.1.0.0/16

# DR region subnet
gcloud compute networks subnets create dr-subnet \
  --network=dr-vpc \
  --region=us-east1 \
  --range=10.2.0.0/16

# 2. Setup Cloud SQL with read replica
# Create primary instance
gcloud sql instances create prod-db \
  --database-version=POSTGRES_14 \
  --tier=db-n1-standard-4 \
  --region=us-central1 \
  --backup-start-time=02:00 \
  --enable-bin-log \
  --backup-location=us-central1 \
  --maintenance-window-day=SUN \
  --maintenance-window-hour=2

# Create read replica in DR region
gcloud sql instances create prod-db-replica \
  --master-instance-name=prod-db \
  --tier=db-n1-standard-2 \
  --region=us-east1 \
  --replica-type=READ

# 3. Setup Cloud Storage replication
gsutil mb -l us-central1 -b on gs://prod-bucket-primary
gsutil mb -l us-east1 -b on gs://prod-bucket-dr

# Enable replication
gcloud storage buckets update gs://prod-bucket-primary \
  --recovery-point-objective=DEFAULT

# Create bucket-to-bucket replication
gsutil rsync -r -d gs://prod-bucket-primary gs://prod-bucket-dr

# 4. Create managed instance groups
# Primary MIG (active)
gcloud compute instance-groups managed create primary-mig \
  --base-instance-name=primary-vm \
  --size=10 \
  --template=app-template \
  --region=us-central1 \
  --health-check=app-health-check \
  --initial-delay=300

# DR MIG (minimal, autoscales on demand)
gcloud compute instance-groups managed create dr-mig \
  --base-instance-name=dr-vm \
  --size=0 \
  --template=app-template \
  --region=us-east1 \
  --health-check=app-health-check \
  --initial-delay=300

# Autoscaling for DR (scales up when primary fails)
gcloud compute instance-groups managed set-autoscaling dr-mig \
  --region=us-east1 \
  --min-num-replicas=0 \
  --max-num-replicas=10 \
  --target-cpu-utilization=0.6

# 5. Setup Global HTTP(S) Load Balancer
gcloud compute backend-services create app-backend \
  --global \
  --protocol=HTTP \
  --health-checks=app-health-check \
  --timeout=30s \
  --enable-logging

# Add both regions as backends (primary has higher capacity-scaler)
gcloud compute backend-services add-backend app-backend \
  --instance-group=primary-mig \
  --instance-group-region=us-central1 \
  --balancing-mode=UTILIZATION \
  --max-utilization=0.8 \
  --capacity-scaler=1.0 \
  --global

gcloud compute backend-services add-backend app-backend \
  --instance-group=dr-mig \
  --instance-group-region=us-east1 \
  --balancing-mode=UTILIZATION \
  --max-utilization=0.8 \
  --capacity-scaler=1.0 \
  --global

# 6. Setup health check with appropriate thresholds
gcloud compute health-checks update http app-health-check \
  --check-interval=10s \
  --timeout=5s \
  --unhealthy-threshold=3 \
  --healthy-threshold=2

# 7. Setup alerting for DR activation
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="DR Region Activated" \
  --condition-display-name="DR instances running" \
  --condition-threshold-value=1 \
  --condition-threshold-duration=60s

# 8. Create DR runbook (document steps)
cat > dr-failover.sh <<'EOF'
#!/bin/bash
# DR Failover Procedure

echo "=== DISASTER RECOVERY FAILOVER ==="
echo "1. Promoting read replica to standalone instance..."
gcloud sql instances promote-replica prod-db-replica

echo "2. Scaling up DR MIG..."
gcloud compute instance-groups managed resize dr-mig \
  --region=us-east1 \
  --size=10

echo "3. Verifying backend health..."
gcloud compute backend-services get-health app-backend --global

echo "4. Update DNS (if using Cloud DNS)..."
gcloud dns record-sets update app.example.com. \
  --zone=prod-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=DR_LOAD_BALANCER_IP

echo "DR failover complete!"
EOF
chmod +x dr-failover.sh
```

#### Exam Tips for This Scenario
- Global HTTP(S) LB automatically routes to healthy backends
- Cloud SQL read replicas can be promoted to standalone
- MIG with min=0 saves costs when not active
- capacity-scaler controls traffic distribution
- Cloud Storage has built-in geo-redundancy options
- health-check thresholds affect failover time
- DR runbook automation reduces RTO
- Cross-region replication increases costs

## Professional Cloud Architect Exam Tips

### Network Design Decision Framework

#### Question Pattern: "Which connectivity option?"
```
Decision Tree:
1. Bandwidth requirements?
   - < 3 Gbps → Consider VPN
   - 3-10 Gbps → Partner Interconnect or VPN
   - > 10 Gbps → Dedicated Interconnect

2. Latency requirements?
   - Variable OK → VPN (via internet)
   - Consistent required → Interconnect

3. Cost considerations?
   - Budget-conscious → VPN
   - High traffic volume → Interconnect (lower egress costs)

4. Availability requirements?
   - 99.9% → Single HA VPN or single Interconnect
   - 99.99% → HA VPN (4 tunnels) or redundant Interconnect

5. Location?
   - No Google colo presence → Partner Interconnect or VPN
   - In Google colo → Dedicated Interconnect
```

#### Question Pattern: "Which load balancer?"
```
Decision Tree:
1. Internal or External?
   - Internal → Internal HTTP(S) or TCP/UDP LB
   - External → Continue

2. Protocol?
   - HTTP(S) → HTTP(S) Load Balancer
   - TCP (non-HTTP) → TCP Proxy or Network LB
   - UDP → Network LB

3. Scope?
   - Single region → Regional LB
   - Multiple regions → Global LB

4. Need source IP preservation?
   - Yes → Network LB (passthrough)
   - No → Proxy-based LB OK

5. Need SSL termination?
   - Yes → HTTP(S) LB or SSL Proxy
   - No → TCP Proxy or Network LB

6. Need content-based routing?
   - Yes → HTTP(S) Load Balancer
   - No → Any appropriate LB
```

### Common Exam Trap Questions

#### Trap 1: Subnet Expansion
```
Question: "Running out of IPs in subnet, what to do?"

Wrong Answers:
- Delete and recreate subnet (downtime)
- Use another subnet (requires reconfiguration)
- Migrate to auto-mode VPC (not possible)

Correct Answer:
- Expand subnet IP range (no downtime)
- Cannot shrink, only expand
```

#### Trap 2: Health Check Failures
```
Question: "All backends showing unhealthy"

Most Common Cause:
- Missing firewall rule for health check ranges
- Must allow from 35.191.0.0/16 and 130.211.0.0/22
- Different ranges for internal vs external LBs

Not Usually:
- Backend service configuration
- Health check endpoint
- Instance issues
```

#### Trap 3: Private Google Access
```
Question: "VM without external IP can't access Cloud Storage"

Wrong Answers:
- Add external IP (defeats purpose)
- Use VPN (not needed)
- Create NAT gateway (AWS concept)

Correct Answer:
- Enable Private Google Access on subnet
- Works for Google APIs only
- Does NOT provide general internet access
```

#### Trap 4: VPC Peering Transitivity
```
Question: "VPC A peers with B, B peers with C. Can A reach C?"

Answer: NO
- VPC peering is NOT transitive
- Must create A ↔ C peering directly
- Common misconception from other clouds

Alternative:
- Use Shared VPC instead
- Or VPN/Interconnect with proper routing
```

#### Trap 5: Load Balancer and Cloud CDN
```
Question: "Enable Cloud CDN on Internal HTTP(S) Load Balancer"

Answer: NOT POSSIBLE
- Cloud CDN only works with:
  - Global External HTTP(S) Load Balancer
  - Regional External HTTP(S) Load Balancer
- Does NOT work with:
  - Internal Load Balancers
  - Network Load Balancers
```

### Quick Reference Tables

#### IP Address Reserved by Google
| Subnet Size | Total IPs | Reserved | Usable |
|-------------|-----------|----------|--------|
| /24 | 256 | 4 | 252 |
| /23 | 512 | 4 | 508 |
| /22 | 1024 | 4 | 1020 |
| /21 | 2048 | 4 | 2044 |
| /20 | 4096 | 4 | 4092 |

#### Health Check Timing Calculations
```
Time to mark unhealthy = check-interval × unhealthy-threshold
Time to mark healthy = check-interval × healthy-threshold

Example:
check-interval: 10s
unhealthy-threshold: 3
Unhealthy after: 10s × 3 = 30 seconds

Example:
check-interval: 5s
healthy-threshold: 2
Healthy after: 5s × 2 = 10 seconds
```

#### GKE IP Planning (Exam Favorite)
```
Formula: Total pod IPs needed = nodes × max-pods-per-node

Example:
- 50 nodes
- 110 pods per node (default max)
- Total: 50 × 110 = 5,500 pods
- Need: /19 (8,192 IPs) or larger for pod secondary range

Services:
- Typically need /20 (4,096 IPs) for services
- One IP per Kubernetes Service

Primary range:
- One IP per node
- /24 (252 IPs) sufficient for most clusters
```

### Network Security Best Practices (Exam-Relevant)

1. **Defense in Depth**
   - Cloud Armor at edge (WAF, DDoS)
   - Firewall rules (VPC level)
   - IAP for internal apps (application level)
   - VPC Service Controls (data level)

2. **Principle of Least Privilege**
   - Deny-by-default firewall rules
   - Specific source/target tags
   - Service accounts over tags
   - Enable firewall logging

3. **Data Protection**
   - VPC Service Controls for data exfiltration prevention
   - Private Service Connect for private API access
   - VPC peering instead of external IPs
   - Encryption in transit (TLS/mTLS)

4. **Monitoring and Compliance**
   - Enable VPC Flow Logs
   - Export to BigQuery for analysis
   - Cloud Armor logging
   - Regular firewall rule audits

### Cost Optimization Strategies

#### Network Tier Selection
```
Premium Tier:
- Global routing via Google network
- Best performance, lowest latency
- Higher cost
- Use for: Production, latency-sensitive apps

Standard Tier:
- Regional routing via ISP networks
- Lower cost (up to 35% savings)
- Higher latency, variable performance
- Use for: Batch processing, backups, logs
```

#### Traffic Optimization
```
Avoid Cross-Region Traffic:
- $0.01/GB between regions (within NA/EU)
- $0.05-$0.08/GB between continents
- Keep data in same region when possible

Use Cloud CDN:
- Cache at edge (free once cached)
- Reduces origin egress charges
- Typical savings: 60-90% of egress costs

Use Interconnect for High Volume:
- VPN egress: Standard internet rates
- Interconnect egress: 50-75% cheaper
- Breakeven: 1-5 TB/month depending on region
```

### Exam Day Checklist

**VPC Networking**
- [ ] VPC is global, subnets are regional
- [ ] Auto-mode can convert to custom (one-way)
- [ ] Subnets can expand, never shrink
- [ ] Secondary ranges for GKE pods/services
- [ ] Private Google Access: per-subnet, Google APIs only

**Load Balancing**
- [ ] Global LB = Anycast IP, multi-region backends
- [ ] Regional LB = Regional IP, single region
- [ ] Proxy vs Passthrough (source IP preservation)
- [ ] Health check firewall rules (35.191.0.0/16, 130.211.0.0/22)
- [ ] Cloud CDN only on external HTTP(S) LBs

**Hybrid Connectivity**
- [ ] HA VPN: 99.99% SLA needs 4 tunnels + BGP
- [ ] Dedicated Interconnect: 10/100 Gbps, Google colo
- [ ] Partner Interconnect: 50 Mbps - 50 Gbps, flexible
- [ ] VPN max bandwidth: 3 Gbps per tunnel

**Security**
- [ ] Cloud Armor: External HTTP(S) LB only
- [ ] Firewall priority: lower number = higher priority
- [ ] VPC Service Controls: data exfiltration prevention
- [ ] IAP: zero-trust access, no VPN needed

**Common Calculations**
- [ ] Usable IPs = total - 4 (reserved by Google)
- [ ] Health check timing = interval × threshold
- [ ] GKE pod IPs = nodes × max-pods-per-node
- [ ] BGP ASN: private range 64512-65534