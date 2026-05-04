---
last-updated: 2026-05-03
---

# AWS Certified Advanced Networking - Specialty (ANS-C01) - Fact Sheet

## Quick Reference

### Exam Details
- **Exam Code**: ANS-C01
- **Duration**: 170 minutes (2 hours 50 minutes)
- **Number of Questions**: 65 questions
- **Passing Score**: 750/1000
- **Question Format**: Multiple choice, multiple response
- **Cost**: $300 USD
- **Validity**: 3 years
- **Prerequisites**: Recommended 5+ years hands-on experience with AWS networking

### Exam Domains
| Domain | % of Exam |
|--------|-----------|
| Domain 1: Network Design | 30% |
| Domain 2: Network Implementation | 26% |
| Domain 3: Network Management and Operation | 20% |
| Domain 4: Network Security, Compliance, and Governance | 24% |

## Domain 1: Network Design (30%)

### VPC Architecture Design

#### CIDR Block Planning
- **Primary CIDR** - 10.0.0.0/16 (65,536 IPs), 172.16.0.0/12, 192.168.0.0/16
- **[📖 VPC CIDR Blocks](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html)** - Primary and secondary CIDR
- **Secondary CIDR** - Add up to 5 secondary CIDR blocks
- **[📖 Working with Secondary CIDRs](https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html#add-cidr-block-restrictions)**
- **CIDR reservations** - Reserve IP ranges for future subnets
- **Avoid overlap** - No CIDR overlap between VPCs connected via peering/TGW

#### Subnet Design
- **Public subnets** - Route table with IGW route (0.0.0.0/0 → IGW)
- **Private subnets** - No direct internet access, use NAT Gateway
- **[📖 Subnet Routing](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)** - Route table configuration
- **Multi-AZ** - Spread subnets across AZs for high availability
- **Reserved IPs** - AWS reserves 5 IPs per subnet (.0, .1, .2, .3, .255)
- **Subnet sizing** - /24 = 251 usable IPs, /20 = 4,091 usable IPs

#### IPv6 Support
- **Dual-stack VPC** - IPv4 + IPv6 (2001:db8::/64)
- **[📖 IPv6 for VPC](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ipv6.html)** - Enable IPv6
- **Egress-only IGW** - Outbound IPv6 traffic only (like NAT for IPv6)
- **[📖 Egress-Only Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html)**

### Hybrid Connectivity

#### AWS Direct Connect
- **Dedicated connection** - 1 Gbps, 10 Gbps, 100 Gbps physical fiber
- **[📖 Direct Connect Getting Started](https://docs.aws.amazon.com/directconnect/latest/UserGuide/getting_started.html)**
- **Hosted connection** - 50 Mbps to 10 Gbps via APN partner
- **[📖 Direct Connect Connections](https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html)**
- **Virtual interfaces (VIFs)**:
  - **Private VIF** - Access VPC via VGW or DX Gateway
  - **[📖 Private Virtual Interface](https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html)**
  - **Public VIF** - Access AWS public services (S3, DynamoDB)
  - **Transit VIF** - Connect to Transit Gateway
- **LAG (Link Aggregation Group)** - Aggregate up to 4 connections
- **[📖 LAG Configuration](https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html)** - Active/active for higher bandwidth
- **SLA** - 99.99% availability SLA with redundant connections

#### Direct Connect Gateway
- **Multi-region access** - Connect on-premises to VPCs in multiple regions
- **[📖 Direct Connect Gateway](https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways.html)** - Single DX, multiple VPCs
- **Limitations** - No VPC-to-VPC communication via DX Gateway
- **Max VGW/TGW associations** - 10 per DX Gateway

#### AWS Site-to-Site VPN
- **IPSec VPN** - Encrypted tunnel over internet
- **[📖 Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/)** - Customer gateway to VGW/TGW
- **Redundancy** - 2 tunnels per VPN connection (active/passive)
- **[📖 VPN Redundancy](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNConnections.html)** - HA design
- **Throughput** - 1.25 Gbps per tunnel (up to 5 Gbps with ECMP)
- **Accelerated VPN** - Uses Global Accelerator for better performance
- **[📖 Accelerated Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/accelerated-vpn.html)**

#### VPN + Direct Connect (Hybrid)
- **VPN over DX** - Encrypted IPSec tunnel over Direct Connect
- **Use case** - Compliance requirements for encryption in transit
- **DX as backup** - Use VPN as primary, DX as failover (or vice versa)

#### AWS VPN CloudHub
- **Hub-and-spoke** - Multiple customer sites via VPN to single VGW
- **[📖 VPN CloudHub](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPN_CloudHub.html)** - Simple hub-and-spoke model
- **Use case** - Branch offices communicate via VGW hub

### Multi-VPC Connectivity

#### VPC Peering
- **1:1 connection** - Connect two VPCs
- **[📖 VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/)** - Private IP routing
- **No transitive routing** - A↔B and B↔C does NOT mean A↔C
- **Cross-region** - Peering across regions supported
- **Cross-account** - Peering across AWS accounts supported
- **Limitations** - No overlapping CIDR blocks

#### AWS Transit Gateway
- **Hub-and-spoke at scale** - Connect thousands of VPCs, on-premises
- **[📖 Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/)** - Central hub for connectivity
- **Transitive routing** - Full mesh via TGW (A↔TGW↔B↔TGW↔C means A↔C)
- **Route tables** - Multiple route tables for isolation (like VPC route tables)
- **[📖 Transit Gateway Route Tables](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html)** - Control traffic flow
- **Attachments**:
  - VPC attachments
  - VPN attachments (Site-to-Site VPN)
  - Direct Connect Gateway attachments
  - Peering attachments (TGW-to-TGW, cross-region)
  - **[📖 Transit Gateway Attachments](https://docs.aws.amazon.com/vpc/latest/tgw/working-with-transit-gateways.html)**
- **ECMP (Equal-Cost Multi-Path)** - Load balance across multiple VPN tunnels
- **[📖 Transit Gateway ECMP](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-ecmp-vpn.html)** - Increase VPN throughput
- **Bandwidth** - 50 Gbps per VPC attachment, up to 300 Gbps aggregate
- **Inter-region peering** - Connect TGWs in different regions
- **[📖 Transit Gateway Peering](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-peering.html)**

#### AWS PrivateLink
- **Service-to-service connectivity** - Access services without internet
- **[📖 AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/)** - VPC endpoint services
- **Interface endpoints** - Powered by PrivateLink (ENI in your subnet)
- **[📖 Interface VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html)** - For AWS services and SaaS
- **Gateway Load Balancer endpoint** - Insert security appliances
- **[📖 Gateway Load Balancer Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-gateway-load-balancer.html)**
- **Use cases**: Multi-tenant SaaS, shared services VPC

### Internet Connectivity

#### Internet Gateway (IGW)
- **Public internet access** - Bidirectional traffic for public subnets
- **[📖 Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)** - 1:1 NAT for public IPs
- **Horizontally scaled** - Redundant and highly available by design
- **No bandwidth limits** - AWS-managed scaling

#### NAT Gateway
- **Outbound-only internet** - Private subnets access internet
- **[📖 NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)** - Managed NAT service
- **Bandwidth** - 5 Gbps, scales to 100 Gbps
- **High availability** - Deploy one per AZ for redundancy
- **Cost** - $0.045/hour + $0.045/GB data processed (us-east-1)

#### NAT Instance
- **EC2-based NAT** - Customer-managed NAT
- **Use case** - Cost savings for low traffic, or custom requirements
- **Source/Destination Check** - Disable on NAT instance
- **[📖 NAT Instances](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html)** - Legacy option

### AWS Global Accelerator
- **Anycast IPs** - 2 static IPs, route traffic to optimal AWS edge location
- **[📖 Global Accelerator](https://docs.aws.amazon.com/global-accelerator/)** - Improve availability and performance
- **Health checks** - Automatic failover to healthy endpoints
- **Use cases**: Global applications, gaming, IoT, VoIP
- **Endpoints** - ALB, NLB, EC2, Elastic IP

### Content Delivery and Edge

#### Amazon CloudFront
- **CDN** - Cache content at 400+ edge locations worldwide
- **[📖 CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/)** - Low-latency content delivery
- **Origin types** - S3, ALB, custom HTTP/HTTPS origins
- **[📖 CloudFront Origins](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html)**
- **Origin Shield** - Additional caching layer for high-traffic origins
- **[📖 Origin Shield](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/origin-shield.html)** - Reduce origin load
- **Field-level encryption** - Encrypt sensitive data at edge
- **Geo-restriction** - Allow/block countries

#### AWS Global Accelerator vs CloudFront
| Feature | Global Accelerator | CloudFront |
|---------|-------------------|------------|
| Use case | Non-HTTP (TCP/UDP), dynamic content | HTTP/HTTPS, static/dynamic content |
| Caching | No caching | Caches content |
| IPs | 2 static Anycast IPs | Dynamic IPs per edge |
| Protocol | TCP, UDP | HTTP, HTTPS, WebSocket |

### DNS and Traffic Management

#### Amazon Route 53
- **DNS service** - Highly available and scalable
- **[📖 Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/)** - Domain registration and DNS
- **Routing policies**:
  - **Simple** - Single resource
  - **Weighted** - A/B testing, gradual migrations
  - **Latency** - Route to lowest latency region
  - **Failover** - Active-passive failover
  - **Geolocation** - Route based on user location
  - **Geoproximity** - Route based on resource and user location with bias
  - **Multivalue** - Return multiple IPs (simple load balancing)
  - **[📖 Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)**
- **Health checks** - Monitor endpoint health, trigger failover
- **[📖 Route 53 Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)**
- **Private hosted zones** - DNS for VPC resources
- **[📖 Private Hosted Zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html)**
- **DNSSEC** - Protect against DNS spoofing
- **[📖 Route 53 DNSSEC](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html)**
- **Resolver** - Conditional forwarding to on-premises DNS
- **[📖 Route 53 Resolver](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html)** - Hybrid DNS

## Domain 2: Network Implementation (26%)

### VPC Implementation

#### Route Tables
- **Main route table** - Default for all subnets without explicit association
- **Custom route tables** - Per-subnet routing
- **[📖 Route Table Configuration](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)**
- **Route priority** - Most specific route wins (longest prefix match)
- **Local route** - 10.0.0.0/16 → local (always present, cannot be deleted)
- **Propagated routes** - VGW propagates routes from on-premises (BGP)
- **[📖 Route Propagation](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html)**

#### Elastic Network Interfaces (ENI)
- **Virtual network card** - Private IP, public IP, MAC address
- **[📖 Elastic Network Interfaces](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html)** - Attach to EC2
- **Multiple ENIs** - Multi-homed instances (management + data networks)
- **ENI attributes** - Security groups, source/dest check, elastic IP
- **Hot attach/detach** - Move ENI between instances

#### Elastic IP (EIP)
- **Static public IPv4** - Fixed public IP address
- **[📖 Elastic IP Addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)**
- **Reassignable** - Move between instances, NAT Gateways
- **Charge** - Free while associated, $0.005/hour when unassociated

### Load Balancing

#### Application Load Balancer (ALB)
- **Layer 7 (HTTP/HTTPS)** - Content-based routing
- **[📖 Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)** - HTTP/2, WebSocket
- **Features**:
  - Host-based routing (api.example.com → target group A)
  - Path-based routing (/api → target group B)
  - HTTP header routing
  - **[📖 ALB Routing](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html)**
- **Target types** - EC2, IP (containers, Lambda)
- **SSL/TLS termination** - Offload SSL from backend
- **Cross-zone load balancing** - Enabled by default (no charge)

#### Network Load Balancer (NLB)
- **Layer 4 (TCP/UDP/TLS)** - Ultra-low latency, millions of requests/sec
- **[📖 Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/)** - Static IP per AZ
- **Preserve source IP** - Client IP visible to backend (no X-Forwarded-For needed)
- **PrivateLink compatible** - Use as VPC endpoint service
- **TLS termination** - Offload TLS decryption
- **Cross-zone load balancing** - Disabled by default (charges apply if enabled)
- **[📖 NLB Cross-Zone](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#cross-zone-load-balancing)**

#### Gateway Load Balancer (GWLB)
- **Layer 3 (IP packets)** - Deploy inline security appliances
- **[📖 Gateway Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/)** - Firewalls, IDS/IPS
- **GENEVE protocol** - Encapsulation for transparent inspection
- **Use case** - Third-party security appliances (Palo Alto, Fortinet)
- **Flow stickiness** - 5-tuple hash ensures same appliance for flow

### Security Implementation

#### Security Groups
- **Instance-level firewall** - Stateful (return traffic automatically allowed)
- **[📖 Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)** - Allow rules only
- **Default behavior** - Deny all inbound, allow all outbound
- **Rules** - Protocol, port, source/destination (CIDR, SG ID, prefix list)
- **Limits** - 5 SGs per ENI, 60 rules per SG (inbound + outbound)

#### Network ACLs (NACLs)
- **Subnet-level firewall** - Stateless (must allow return traffic explicitly)
- **[📖 Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Allow and deny rules
- **Rule evaluation** - Rules evaluated in order (lowest number first)
- **Default NACL** - Allows all traffic
- **Custom NACL** - Denies all traffic by default
- **Use cases** - Block specific IPs, additional layer of defense

#### AWS Network Firewall
- **Managed stateful firewall** - IDS/IPS, deep packet inspection
- **[📖 AWS Network Firewall](https://docs.aws.amazon.com/network-firewall/)** - VPC-level protection
- **Rule types**:
  - **Stateless rules** - 5-tuple filtering (like NACL)
  - **Stateful rules** - Domain filtering, Suricata-compatible
  - **[📖 Firewall Rules](https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-rules.html)**
- **Deployment** - Firewall subnet per AZ, route traffic via firewall endpoints

#### AWS WAF (Web Application Firewall)
- **Layer 7 protection** - Attach to ALB, API Gateway, CloudFront
- **[📖 AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/)** - SQL injection, XSS protection
- **Managed rules** - AWS Managed Rules, third-party rules
- **[📖 WAF Managed Rules](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups.html)**
- **Custom rules** - IP sets, geo match, rate limiting, string matching

#### AWS Shield
- **DDoS protection** - Layer 3/4 DDoS mitigation
- **[📖 AWS Shield](https://docs.aws.amazon.com/waf/latest/developerguide/shield-chapter.html)**
- **Shield Standard** - Automatic protection (free)
- **Shield Advanced** - Enhanced DDoS protection ($3,000/month)
  - Advanced DDoS metrics and detection
  - 24/7 DDoS Response Team (DRT)
  - Cost protection (absorb scaling costs during attack)
  - **[📖 Shield Advanced](https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced.html)**

### VPC Endpoints

#### Gateway Endpoints
- **S3 and DynamoDB only** - Free, route table entry
- **[📖 Gateway VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-gateway.html)** - Private access from VPC
- **No extra cost** - Standard S3/DynamoDB data transfer charges apply

#### Interface Endpoints (PrivateLink)
- **Most AWS services** - EC2, SNS, SQS, CloudWatch, etc.
- **[📖 Interface VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html)** - ENI in subnet
- **Cost** - $0.01/hour per AZ + $0.01/GB data processed
- **DNS** - Private DNS resolves service to private IP
- **Endpoint policies** - IAM-like policies to restrict access
- **[📖 Endpoint Policies](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-access.html)**

## Domain 3: Network Management and Operation (20%)

### Monitoring and Logging

#### VPC Flow Logs
- **IP traffic logs** - Capture metadata (src, dst, port, protocol, bytes, accept/reject)
- **[📖 VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network troubleshooting
- **Destinations** - CloudWatch Logs, S3, Kinesis Data Firehose
- **[📖 Flow Log Record Format](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-records-examples.html)**
- **Scope** - VPC level, subnet level, or ENI level
- **Use cases**:
  - Troubleshoot connectivity issues
  - Detect anomalous traffic
  - Security analysis and compliance

#### Amazon CloudWatch
- **Network metrics** - NLB connections, ALB requests, NAT Gateway metrics
- **[📖 CloudWatch Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/)** - Monitor network health
- **Custom metrics** - Publish custom network metrics via API/CLI
- **Alarms** - Alert on thresholds (e.g., NAT Gateway bytes > 100 GB)

#### AWS CloudTrail
- **API audit logs** - Who did what, when (CreateVpc, AuthorizeSecurityGroupIngress)
- **[📖 CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/)** - Governance and compliance
- **Network-related events** - VPC, security group, route table changes

#### Reachability Analyzer
- **Path analysis** - Verify connectivity between source and destination
- **[📖 Reachability Analyzer](https://docs.aws.amazon.com/vpc/latest/reachability/)** - No packets sent
- **Identifies blockers** - Security group, NACL, route table, IGW issues
- **Use cases** - Troubleshoot connectivity before deployment

#### VPC Traffic Mirroring
- **Copy network traffic** - Mirror ENI traffic for analysis
- **[📖 VPC Traffic Mirroring](https://docs.aws.amazon.com/vpc/latest/mirroring/)** - Deep packet inspection
- **Use cases** - IDS/IPS, security monitoring, troubleshooting
- **Supported instances** - Nitro-based instances only

### Network Performance Optimization

#### Enhanced Networking
- **SR-IOV** - Single Root I/O Virtualization for higher PPS
- **[📖 Enhanced Networking](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking.html)** - Up to 100 Gbps
- **ENA (Elastic Network Adapter)** - Most instance types, up to 100 Gbps
- **Intel 82599 VF** - Older instances, up to 10 Gbps

#### Placement Groups
- **Cluster** - Low-latency, single-AZ (HPC workloads)
- **[📖 Placement Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)** - Optimize network performance
- **Spread** - Separate hardware, reduce correlated failures (max 7 per AZ)
- **Partition** - Divide into partitions, separate hardware per partition

#### Jumbo Frames (MTU)
- **Standard MTU** - 1500 bytes
- **Jumbo frames** - 9001 bytes (within VPC)
- **[📖 Network MTU](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/network_mtu.html)** - Increase throughput
- **Path MTU Discovery** - Automatically negotiate MTU
- **Limitations** - Internet traffic limited to 1500 bytes

### Automation and Infrastructure as Code

#### AWS CloudFormation
- **IaC** - Define VPC, subnets, route tables in templates
- **[📖 VPC CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html)** - Automate network deployment
- **Stack updates** - Modify network infrastructure safely

#### AWS CDK (Cloud Development Kit)
- **IaC with code** - Define infrastructure in Python, TypeScript, Java
- **[📖 AWS CDK](https://docs.aws.amazon.com/cdk/latest/guide/)** - Synthesizes to CloudFormation

#### Terraform
- **Third-party IaC** - Multi-cloud infrastructure as code
- **AWS provider** - Manage VPC, subnets, TGW, etc.

### Cost Optimization

#### Data Transfer Costs
- **Inbound** - Free from internet to AWS
- **Outbound** - $0.09/GB (first 10 TB, us-east-1)
- **Inter-region** - $0.02/GB between regions
- **Intra-region** - Free within same AZ (private IP), $0.01/GB cross-AZ

#### VPC Endpoints Cost Savings
- **Gateway endpoints** - Free (S3, DynamoDB)
- **Interface endpoints** - $0.01/hour + $0.01/GB vs NAT Gateway $0.045/GB
- **Savings** - Use VPC endpoints to avoid NAT Gateway charges

#### NAT Gateway vs NAT Instance
- **NAT Gateway** - $0.045/hour + $0.045/GB
- **NAT Instance** - EC2 instance cost + data transfer
- **Savings** - NAT instance cheaper for low traffic (<50 GB/month)

## Domain 4: Network Security, Compliance, and Governance (24%)

### Network Segmentation

#### Multi-Account Strategy
- **AWS Organizations** - Central governance for multiple accounts
- **[📖 AWS Organizations](https://docs.aws.amazon.com/organizations/)** - OU hierarchy
- **Network account** - Centralized networking (Transit Gateway, Direct Connect)
- **Spoke accounts** - Application workloads, attach to central network

#### Transit Gateway Network Segmentation
- **Route table isolation** - Separate route tables for prod/dev/shared
- **[📖 Transit Gateway Routing](https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html)** - Control traffic flow
- **Blackhole routes** - Drop traffic to specific destinations
- **Use case** - Prevent dev VPCs from accessing prod VPCs

#### Security Zones
- **DMZ** - Public-facing services (ALB, CloudFront)
- **Application tier** - Private subnets with ALB/NLB
- **Database tier** - Isolated private subnets, no internet access
- **Management tier** - Bastion hosts, Systems Manager Session Manager

### Encryption and Data Protection

#### Encryption in Transit
- **TLS 1.2+** - All AWS API calls over HTTPS
- **[📖 Encryption in Transit](https://docs.aws.amazon.com/whitepapers/latest/introduction-aws-security/encryption-in-transit.html)**
- **VPN encryption** - IPSec encryption for Site-to-Site VPN
- **MACSec** - Layer 2 encryption for Direct Connect (10 Gbps, 100 Gbps)
- **[📖 MACSec for Direct Connect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html)**

#### AWS Certificate Manager (ACM)
- **SSL/TLS certificates** - Free certificates for AWS services
- **[📖 AWS Certificate Manager](https://docs.aws.amazon.com/acm/)** - Automatic renewal
- **Integration** - ALB, NLB, CloudFront, API Gateway
- **Private CA** - Issue internal certificates
- **[📖 ACM Private CA](https://docs.aws.amazon.com/acm-pca/)**

### Compliance and Governance

#### AWS Config
- **Configuration tracking** - Track VPC, subnet, security group changes
- **[📖 AWS Config](https://docs.aws.amazon.com/config/)** - Compliance auditing
- **Config Rules** - Automated compliance checks
  - `vpc-sg-open-only-to-authorized-ports` - Detect unrestricted SSH
  - `vpc-flow-logs-enabled` - Ensure Flow Logs enabled
  - **[📖 Config Managed Rules](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)**

#### Service Control Policies (SCPs)
- **Organization-wide guardrails** - Prevent dangerous actions
- **[📖 Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)**
- **Example** - Deny VPC deletion, deny internet gateway creation

#### AWS Firewall Manager
- **Centralized firewall management** - Manage WAF, Shield, Network Firewall across accounts
- **[📖 Firewall Manager](https://docs.aws.amazon.com/waf/latest/developerguide/fms-chapter.html)** - Organization-wide policies
- **Policies** - Enforce WAF rules, security group rules, Network Firewall rules

### Incident Response

#### VPC Flow Logs for Security
- **Detect anomalies** - Unexpected traffic patterns
- **Investigate breaches** - Identify malicious IPs
- **Athena queries** - Query Flow Logs in S3
- **[📖 Analyze Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-athena.html)** - SQL queries for security

#### GuardDuty for Network Threats
- **Threat detection** - Identify reconnaissance, backdoors, C&C
- **[📖 Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/)** - VPC Flow Logs analysis
- **Findings** - Port scanning, SSH brute force, malware

#### Network Access Control
- **Bastion hosts** - Jump box in public subnet
- **AWS Systems Manager Session Manager** - No bastion needed, access via console
- **[📖 Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)** - No SSH keys, no public IPs
- **VPN** - Require VPN for admin access

### Shared Services Architecture

#### Centralized Egress VPC
- **Single NAT Gateway VPC** - All spoke VPCs route internet traffic via central VPC
- **[📖 Centralized Egress](https://aws.amazon.com/blogs/networking-and-content-delivery/creating-a-single-internet-exit-point-from-multiple-vpcs-using-aws-transit-gateway/)** - Cost savings, centralized filtering
- **Transit Gateway** - Route 0.0.0.0/0 from spokes to egress VPC

#### Centralized Inspection VPC
- **Security appliances** - Firewall, IDS/IPS in central VPC
- **Traffic routing** - TGW routes traffic through inspection VPC
- **Use case** - Enforce security policies across all VPCs

#### Shared Services VPC
- **Active Directory** - Centralized authentication
- **DNS** - Route 53 Resolver endpoints for hybrid DNS
- **Monitoring** - Centralized logging (CloudWatch, Splunk)

## Common Exam Scenarios

### Scenario 1: Hybrid DNS Resolution
**Problem**: On-premises DNS needs to resolve AWS resources, AWS needs to resolve on-premises resources
**Solution**:
- **Route 53 Resolver** - Create inbound and outbound endpoints
- **[📖 Route 53 Resolver](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html)** - Hybrid DNS
- **Inbound endpoint** - On-premises queries AWS private hosted zones
- **Outbound endpoint** - AWS queries on-premises DNS (conditional forwarding rules)
- **Forwarding rules** - `corp.example.com` → on-premises DNS server

### Scenario 2: Multi-Region Active-Active
**Problem**: Deploy application in 2 regions, route traffic to nearest region
**Solution**:
- **Route 53 latency routing** - Route to lowest latency region
- **Health checks** - Failover if one region unhealthy
- **Global Accelerator** - Static Anycast IPs, automatic failover
- **[📖 Multi-Region Architecture](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/multi-region-architectures.html)**

### Scenario 3: Secure Multi-Account Networking
**Problem**: 50 AWS accounts, need centralized networking and security
**Solution**:
- **AWS Organizations** - OU structure (prod, dev, shared services)
- **Transit Gateway** - Centralized hub in network account
- **RAM (Resource Access Manager)** - Share TGW with all accounts
- **[📖 RAM for Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-ram.html)** - Cross-account sharing
- **Firewall Manager** - Enforce WAF, Shield, Network Firewall policies
- **VPC Flow Logs** - Centralized logging to S3 in security account

### Scenario 4: Direct Connect Redundancy
**Problem**: Mission-critical on-premises to AWS connectivity, need 99.99% SLA
**Solution**:
- **2 Direct Connect connections** - Separate DX locations
- **[📖 DX Resiliency](https://docs.aws.amazon.com/directconnect/latest/UserGuide/resiliency_toolkit.html)** - Maximum resiliency
- **2 VPN connections** - Backup over internet
- **BGP** - Active-active or active-passive routing
- **Transit Gateway** - Single attachment point, handles failover

### Scenario 5: VPC CIDR Exhaustion
**Problem**: VPC 10.0.0.0/16 is full, need more IPs
**Solution**:
- **Add secondary CIDR** - 10.1.0.0/16, 10.2.0.0/16 (up to 5 secondary)
- **[📖 Add CIDR to VPC](https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html#add-cidr-block-restrictions)** - No downtime
- **Update route tables** - Add routes for new CIDR
- **Create new subnets** - In secondary CIDR blocks
- **Note**: Cannot remove primary CIDR, can remove secondary

### Scenario 6: PrivateLink for SaaS Multi-Tenant
**Problem**: Provide SaaS to customers without exposing to internet
**Solution**:
- **Network Load Balancer** - Front-end for service
- **VPC Endpoint Service** - Powered by PrivateLink
- **[📖 VPC Endpoint Services](https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-service.html)** - Service provider
- **Customers create interface endpoints** - In their VPCs, connect to your service
- **Acceptance required** - Whitelist customer accounts/principals

### Scenario 7: Troubleshoot Connectivity Issue
**Problem**: EC2 in private subnet cannot reach S3
**Troubleshooting steps**:
1. **Route table** - Check for S3 gateway endpoint or NAT Gateway route
2. **Security group** - Outbound HTTPS (443) allowed?
3. **NACL** - Stateless, both directions allowed?
4. **S3 bucket policy** - VPC endpoint policy restricting access?
5. **VPC Flow Logs** - Check for REJECT entries
6. **Reachability Analyzer** - Run path analysis from instance to S3
7. **[📖 Troubleshooting VPC](https://docs.aws.amazon.com/vpc/latest/userguide/troubleshooting.html)**

### Scenario 8: Optimize Data Transfer Costs
**Problem**: High NAT Gateway charges for S3 uploads
**Solution**:
- **S3 Gateway Endpoint** - Free, no NAT Gateway charges
- **[📖 Gateway Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-gateway.html)** - Private S3 access
- **Interface endpoint** - For other services (SNS, SQS, etc.)
- **DynamoDB Gateway Endpoint** - Free DynamoDB access from VPC

## Exam Tips

### Key Topics to Master
1. **VPC connectivity patterns** - Peering, Transit Gateway, PrivateLink
2. **Hybrid connectivity** - Direct Connect, VPN, DX Gateway
3. **Routing** - Route tables, BGP, route propagation, longest prefix match
4. **Security** - Security groups, NACLs, WAF, Shield, Network Firewall
5. **Load balancing** - ALB vs NLB vs GWLB decision tree
6. **DNS** - Route 53 routing policies, private hosted zones, Resolver
7. **Monitoring** - VPC Flow Logs, Reachability Analyzer, Traffic Mirroring
8. **Cost optimization** - VPC endpoints, NAT Gateway vs NAT instance, data transfer

### Common Pitfalls
- **Transitive routing** - VPC peering is NOT transitive, use Transit Gateway
- **Security groups vs NACLs** - SG is stateful, NACL is stateless
- **NAT Gateway limitations** - Only IPv4, only outbound internet
- **Direct Connect latency** - Lower latency than VPN, but NOT zero latency
- **VPC endpoint** - Gateway (S3/DynamoDB) is free, interface endpoints cost money
- **CIDR overlap** - Cannot peer or connect VPCs with overlapping CIDRs

### BGP and Routing Deep Dive
- **BGP ASN** - AWS uses ASN 64512 for VGW, customer uses private ASN (64512-65534)
- **Route propagation** - VGW propagates on-premises routes to route tables
- **Longest prefix match** - More specific route wins (10.0.1.0/24 beats 10.0.0.0/16)
- **Local route priority** - Local route always wins over propagated routes
- **AS_PATH** - Prefer shorter AS path (BGP path selection)
- **MED (Multi-Exit Discriminator)** - Influence inbound traffic from AWS to on-premises

### Direct Connect vs VPN Decision Matrix
| Requirement | Direct Connect | VPN |
|-------------|---------------|-----|
| Low latency | ✅ | ❌ |
| High bandwidth (>10 Gbps) | ✅ | ❌ |
| Encrypted by default | ❌ | ✅ |
| Quick setup | ❌ (weeks) | ✅ (minutes) |
| Cost-effective for low traffic | ❌ | ✅ |
| SLA | ✅ (with redundancy) | ❌ |
| Private connectivity | ✅ | ❌ (over internet) |

### Load Balancer Selection
| Use Case | Load Balancer |
|----------|---------------|
| HTTP/HTTPS, content routing | ALB |
| Static IP required | NLB |
| Preserve source IP | NLB |
| Ultra-low latency | NLB |
| PrivateLink | NLB |
| Inline security appliances | GWLB |
| TCP/UDP (non-HTTP) | NLB |
| WebSocket | ALB or NLB |
| gRPC | ALB |

## Essential Documentation

### Core Networking Documentation
- **[📖 VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)** - Complete VPC reference
- **[📖 Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)** - Comprehensive TGW guide
- **[📖 Direct Connect User Guide](https://docs.aws.amazon.com/directconnect/latest/UserGuide/)** - DX setup and management
- **[📖 Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/)** - DNS and traffic management

### Advanced Topics
- **[📖 AWS PrivateLink Guide](https://docs.aws.amazon.com/vpc/latest/privatelink/)** - VPC endpoint services
- **[📖 Network Firewall Developer Guide](https://docs.aws.amazon.com/network-firewall/)** - Managed firewall
- **[📖 VPC Reachability Analyzer](https://docs.aws.amazon.com/vpc/latest/reachability/)** - Path analysis
- **[📖 VPC Traffic Mirroring](https://docs.aws.amazon.com/vpc/latest/mirroring/)** - Packet capture

### Best Practices Whitepapers
- **[Building a Scalable and Secure Multi-VPC AWS Network Infrastructure](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/)** - Multi-VPC patterns
- **[AWS Direct Connect Resiliency Recommendations](https://aws.amazon.com/directconnect/resiliency-recommendation/)** - HA Direct Connect
- **[Hybrid Cloud DNS Options for Amazon VPC](https://docs.aws.amazon.com/whitepapers/latest/hybrid-cloud-dns-options-for-vpc/)** - DNS architectures

### Hands-on Resources
- **[AWS Networking Workshops](https://networking.workshop.aws/)** - Interactive labs
- **[VPC Scenarios](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenarios.html)** - Common architectures
- **[AWS Network Optimization Workshop](https://catalog.workshops.aws/networking-optimization/)** - Performance tuning

## Study Strategy

### Week 1-2: VPC Fundamentals and Routing
- VPC, subnets, route tables, IGW, NAT Gateway
- Security groups, NACLs, VPC Flow Logs
- VPC peering vs Transit Gateway
- **Hands-on**: Build multi-tier VPC, configure route tables

### Week 3-4: Hybrid Connectivity
- Direct Connect (VIFs, LAG, DX Gateway)
- Site-to-Site VPN, VPN CloudHub
- BGP routing, route propagation
- **Hands-on**: Simulate hybrid connectivity with VPN

### Week 5-6: Load Balancing and DNS
- ALB, NLB, GWLB use cases
- Route 53 routing policies, health checks
- Global Accelerator vs CloudFront
- **Hands-on**: Deploy multi-region app with Route 53 latency routing

### Week 7-8: Advanced Security and Monitoring
- AWS Network Firewall, WAF, Shield
- PrivateLink, VPC endpoints
- VPC Flow Logs analysis, Reachability Analyzer
- **Hands-on**: Centralized inspection VPC with Network Firewall

### Week 9-10: Multi-Account and Governance
- Transit Gateway in multi-account
- AWS Organizations, SCPs, Firewall Manager
- Cost optimization strategies
- **Hands-on**: Multi-account networking with TGW and RAM

### Week 11-12: Practice Exams and Review
- Take 3+ full-length practice exams
- Deep dive into incorrect answers
- Review BGP, routing, troubleshooting scenarios

## Recommended Resources

### Official AWS Training
- **[Advanced Networking - Specialty Exam Prep](https://explore.skillbuilder.aws/learn/course/external/view/elearning/12381/exam-prep-standard-course-aws-certified-advanced-networking-specialty-ans-c01)** - FREE on AWS Skill Builder

### Practice Exams
- **AWS Official Practice Exam** - $40 (highly recommended)
- **Tutorials Dojo** - High-quality practice tests
- **Whizlabs** - Multiple practice exams

### Courses
- **AWS Advanced Networking Specialty** by Stephane Maarek (Udemy)
- **A Cloud Guru** - Advanced Networking course

### Hands-on Practice
- **AWS Free Tier** - VPC, NAT Gateway (750 hours/month free first year)
- **AWS Networking Workshops** - https://networking.workshop.aws/

---

**Good luck with your AWS Advanced Networking Specialty certification!** 🚀
