# Domain 4: Networking and Content Delivery (16%)

## 📋 Overview

This domain covers VPC architecture, DNS management, content delivery, hybrid connectivity, and load balancing. Understanding networking fundamentals is critical for troubleshooting connectivity issues and designing resilient architectures.

## 🎯 Key Services and Concepts

### Amazon VPC (Virtual Private Cloud)

**📖 [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)** - Virtual private cloud

#### VPC Fundamentals

- **CIDR Block**: IP address range for the VPC (e.g., 10.0.0.0/16 provides 65,536 IPs)
- **Region-Scoped**: A VPC spans all Availability Zones in a region
- **Default VPC**: Automatically created in each region with public subnets
- **Tenancy**: Default (shared hardware) or dedicated (single-tenant hardware)

#### Subnets

- **Public Subnet**: Has a route to an Internet Gateway; instances get public IPs
- **Private Subnet**: No direct route to the internet; uses NAT Gateway for outbound
- **AZ-Scoped**: Each subnet exists in a single Availability Zone
- **CIDR Block**: Subset of the VPC CIDR (e.g., 10.0.1.0/24 provides 251 usable IPs)

> **Exam Tip:** AWS reserves 5 IPs per subnet (first 4 + last). A /24 subnet has 251 usable IPs, not 256.

**📖 [Subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)** - Subnet configuration

#### Route Tables

- **Main Route Table**: Default route table for all subnets without explicit association
- **Custom Route Tables**: Associate with specific subnets for custom routing
- **Route Priority**: Most specific route wins (longest prefix match)
- **Route Propagation**: Automatically add routes from VPN or Direct Connect

**📖 [Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)** - Routing

#### Gateways

| Gateway | Purpose | Direction |
|---------|---------|-----------|
| **Internet Gateway (IGW)** | Internet access for public subnets | Bidirectional |
| **NAT Gateway** | Internet access for private subnets | Outbound only |
| **NAT Instance** | Self-managed NAT (legacy) | Outbound only |
| **Egress-Only IGW** | Internet access for IPv6 | Outbound only |

- NAT Gateway: Managed, highly available within an AZ, scales automatically
- NAT Gateway: Create one per AZ for HA; each AZ's private subnet routes through its own NAT GW
- NAT Gateway does not support security groups; use NACLs at subnet level

**📖 [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)** - Outbound internet access

#### VPC Endpoints

| Type | Supported Services | How It Works |
|------|-------------------|--------------|
| **Gateway Endpoint** | S3, DynamoDB | Route table entry; free |
| **Interface Endpoint** | 100+ services | ENI with private IP; uses PrivateLink; charges apply |

- Gateway endpoints: Add prefix list to route table; no additional cost
- Interface endpoints: Create ENI in subnet; supports security groups
- Endpoint policies: Control access to the service through the endpoint

**📖 [VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)** - Private service access

#### VPC Flow Logs

- Capture IP traffic information at VPC, subnet, or ENI level
- Publish to CloudWatch Logs, S3, or Kinesis Data Firehose
- Does NOT capture: DNS to Route 53 Resolver, DHCP, instance metadata (169.254.169.254), Amazon Time Sync

**📖 [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network traffic logs

---

### Amazon Route 53

**📖 [Amazon Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)** - DNS service

#### Hosted Zones

- **Public Hosted Zone**: Resolves DNS queries from the internet
- **Private Hosted Zone**: Resolves DNS queries within associated VPCs
- **Delegation**: NS records delegate subdomain management

#### Record Types

| Record | Purpose |
|--------|---------|
| **A** | Maps domain to IPv4 address |
| **AAAA** | Maps domain to IPv6 address |
| **CNAME** | Maps domain to another domain (cannot be at zone apex) |
| **Alias** | AWS-specific; maps to AWS resources (works at zone apex, free for AWS resources) |
| **MX** | Mail server routing |
| **TXT** | Text records (domain verification, SPF) |

> **Exam Tip:** Use Alias records for AWS resources (ELB, CloudFront, S3 websites). Unlike CNAME, Alias records work at the zone apex and have no additional query charges for AWS targets.

#### Routing Policies

| Policy | Use Case |
|--------|----------|
| **Simple** | Single resource, no health checks |
| **Weighted** | Distribute traffic by percentage (A/B testing, blue/green) |
| **Latency** | Route to lowest-latency region |
| **Failover** | Active-passive with health checks |
| **Geolocation** | Route based on user location (compliance, localization) |
| **Geoproximity** | Route based on geographic distance with bias |
| **Multivalue Answer** | Return multiple healthy IPs (basic load balancing) |

#### Health Checks

- Monitor endpoint health (HTTP, HTTPS, TCP)
- Calculated health checks (combine multiple checks)
- CloudWatch alarm-based health checks
- Health checks can trigger DNS failover automatically

**📖 [Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)** - Traffic routing
**📖 [Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)** - Endpoint monitoring

---

### Amazon CloudFront

**📖 [Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)** - Content delivery network

#### Core Concepts

- **Distribution**: Configuration for content delivery (origins, behaviors, settings)
- **Origin**: Source of content (S3 bucket, ALB, EC2, custom HTTP server)
- **Edge Location**: Point of presence where content is cached
- **Regional Edge Cache**: Intermediate cache between edge locations and origin

#### Cache Configuration

- **Cache Behaviors**: Rules matching URL patterns to origin and cache settings
- **TTL**: Minimum, maximum, and default TTL values
- **Cache Policy**: Controls what values are included in the cache key
- **Origin Request Policy**: Controls what values are forwarded to the origin
- **Cache Invalidation**: Remove cached objects before TTL expires (costs per invalidation path)

#### Advanced Features

- **Origin Access Control (OAC)**: Restrict S3 bucket access to CloudFront only (replaces OAI)
- **Origin Failover**: Route to backup origin when primary returns errors
- **Lambda@Edge**: Run Lambda functions at edge locations (viewer/origin request/response)
- **CloudFront Functions**: Lightweight functions at edge for simple transformations
- **Field-Level Encryption**: Encrypt specific form fields at the edge

**📖 [Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-working-with.html)** - CDN setup
**📖 [Cache Behavior](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesCacheBehavior)** - Caching configuration
**📖 [Lambda@Edge](https://docs.aws.amazon.com/lambda/latest/dg/lambda-edge.html)** - Edge computing

---

### Hybrid Connectivity

#### AWS Site-to-Site VPN

**📖 [Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html)** - VPN connections

- Encrypted tunnel over the internet between on-premises and AWS
- **Virtual Private Gateway (VGW)**: AWS side of VPN connection
- **Customer Gateway (CGW)**: On-premises side configuration
- Two tunnels per connection for redundancy
- Supports static routing or BGP dynamic routing

#### AWS Direct Connect

**📖 [AWS Direct Connect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)** - Dedicated connections

- Dedicated network connection from on-premises to AWS
- **Connection Types**: Dedicated (1 Gbps, 10 Gbps, 100 Gbps) or Hosted (50 Mbps to 10 Gbps)
- **Virtual Interfaces (VIF)**:
  - Public VIF: Access AWS public services (S3, DynamoDB)
  - Private VIF: Access VPC resources
  - Transit VIF: Access VPCs through Transit Gateway
- **LAG (Link Aggregation Group)**: Bundle multiple connections for increased bandwidth
- **Encryption**: Not encrypted by default; use VPN over Direct Connect for encryption
- Lead time: Weeks to months for provisioning

#### AWS Transit Gateway

**📖 [AWS Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)** - Network hub

- Hub-and-spoke model connecting VPCs, VPNs, and Direct Connect
- Supports transitive routing (VPC-to-VPC through TGW)
- Inter-region peering between Transit Gateways
- Route tables for controlling traffic flow
- Scales to thousands of VPC connections

#### VPC Peering

**📖 [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html)** - Connect VPCs

- Direct connection between two VPCs (same or different accounts/regions)
- No transitive routing (A-B and B-C does NOT connect A-C)
- CIDR blocks cannot overlap
- Requires route table entries in both VPCs

---

### Elastic Load Balancing

**📖 [Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)** - Load distribution

#### Load Balancer Types

| Feature | ALB | NLB | GLB |
|---------|-----|-----|-----|
| **Layer** | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP) |
| **Routing** | Path, host, header, query string | Port, protocol | Transparent |
| **Static IP** | No (use Global Accelerator) | Yes | N/A |
| **Performance** | Good | Ultra-low latency | N/A |
| **Targets** | EC2, IP, Lambda, containers | EC2, IP, ALB | Appliances |
| **Best For** | Web applications | High performance, IoT | Security appliances |

#### ALB Key Features

- Path-based routing (`/api/*` to API target group)
- Host-based routing (`api.example.com` to API target group)
- Fixed response and redirect actions
- Authentication integration (Cognito, OIDC)
- Weighted target groups for blue/green deployments
- Sticky sessions (cookie-based)

#### NLB Key Features

- Static IP per AZ (or Elastic IP)
- Preserves source IP address
- TCP/UDP/TLS protocol support
- Millions of requests per second
- Cross-zone load balancing (disabled by default)

**📖 [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)** - HTTP/HTTPS load balancer
**📖 [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html)** - TCP/UDP load balancer

---

## 📚 Key Exam Scenarios

1. **Private subnet instances need internet access** - Deploy NAT Gateway in public subnet; add route 0.0.0.0/0 -> NAT GW in private subnet route table
2. **Access S3 from private subnet without internet** - Create S3 Gateway endpoint; add prefix list to route table
3. **DNS failover between regions** - Route 53 failover routing with health checks on both endpoints
4. **Reduce latency for global users** - CloudFront distribution with appropriate cache behaviors and TTL settings
5. **Connect 50 VPCs** - Transit Gateway (VPC peering would require 1,225 connections)
6. **Consistent low-latency connectivity to AWS** - AWS Direct Connect with VPN as backup
7. **Static IP for load balancer** - Use NLB (provides static IP per AZ) or ALB + Global Accelerator
8. **Route traffic based on user country** - Route 53 geolocation routing policy
