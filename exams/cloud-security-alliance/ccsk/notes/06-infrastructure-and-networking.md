# 06 - Infrastructure and Networking (Guidance Domain 7)

## Domain Overview

Guidance Domain 7 covers cloud infrastructure and network security: virtual networks, segmentation, zero trust networking, connectivity to on-premises, and DDoS mitigation. Cloud networking abstracts physical infrastructure but introduces its own security considerations.

## Cloud Virtual Networks

### VPC / VNet
Isolated virtual network in cloud:
- **AWS VPC** (Virtual Private Cloud)
- **Azure VNet** (Virtual Network)
- **GCP VPC** (Virtual Private Cloud)

Configurable:
- IP addressing (CIDR blocks, RFC 1918 private ranges typical)
- Subnets (public, private, isolated)
- Routing tables
- Internet gateways / NAT gateways
- Peering and transit

### Subnetting
- Public subnets (route to internet gateway)
- Private subnets (no direct internet; egress via NAT)
- Isolated subnets (no internet at all)
- Sized for workload growth
- Availability zone distribution for HA

### IP Addressing
- Private ranges (RFC 1918): 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
- Non-overlapping across VPCs for peering compatibility
- Plan for IPv6 from the start (avoid painful retrofit)

## Network Security Controls

### Security Groups (Stateful)
- Per-instance or per-resource firewall
- Stateful: return traffic allowed automatically
- Allow-only rules (no explicit deny)
- Example: allow port 443 from specific security group

### Network ACLs (Stateless)
- Subnet-level
- Allow and deny rules
- Stateless: return traffic must be explicitly allowed
- Broad-stroke filtering

### Firewall-as-a-Service
- AWS Network Firewall
- Azure Firewall
- GCP Cloud Firewall
- Higher-layer inspection, IDS/IPS, TLS inspection

### Next-Generation Firewalls (Third-Party)
- Palo Alto VM-Series, Fortinet FortiGate, Check Point in cloud
- Application-aware
- Threat prevention
- SSL decryption

### Web Application Firewall (WAF)
- AWS WAF
- Azure WAF
- GCP Cloud Armor
- Layer 7 protection (OWASP Top 10, custom rules)
- Integration with CDN and load balancers

### DDoS Protection
- Provider built-in (AWS Shield Standard, Azure DDoS Basic, GCP Cloud Armor)
- Premium tiers (AWS Shield Advanced, Azure DDoS Protection Standard)
- Application-layer mitigation via WAF + CDN
- Rate limiting at API Gateway

## Network Segmentation

### Macro-Segmentation
- Separate accounts/subscriptions/projects for blast radius reduction
- Separate VPCs/VNets for different environments or workloads

### Micro-Segmentation
- Workload-level isolation within a segment
- Implemented via:
  - Security groups with tight rules
  - Service mesh (Istio, Linkerd) with mTLS and policies
  - Kubernetes Network Policies
  - Identity-based segmentation (ZTNA)

### Zero Trust Segmentation
- No implicit trust based on network location
- Identity and policy drive access decisions
- Continuous verification

## Hub-and-Spoke / Transit Architecture

### Benefits
- Centralized connectivity
- Consolidated egress and inspection
- Simpler routing as network grows

### Implementations
- AWS Transit Gateway
- Azure Virtual WAN or vHub
- GCP Network Connectivity Center, Shared VPC

### Components
- **Hub** - Central transit for connectivity
- **Spokes** - Workload VPCs/VNets connect to hub
- **Firewall in hub** - Inspect east-west and north-south traffic
- **Shared services** - Central DNS, identity, logging accessible via hub

## Connectivity to On-Premises

### Site-to-Site VPN
- IPsec tunnel over internet
- Lower cost
- Variable performance (internet-dependent)

### Direct Connect / ExpressRoute / Cloud Interconnect
- Dedicated private circuit to cloud provider
- Consistent bandwidth and latency
- Higher cost
- Required for some compliance scenarios

### SD-WAN Integration
- Cloud-edge SD-WAN appliances
- Intelligent routing across transport types
- Zero-trust aware SD-WAN (converging with SASE)

## Zero Trust Network Access (ZTNA)

Replacement for traditional VPN:
- Identity-aware
- Device-aware
- Application-specific (not full network access)
- Short-lived sessions
- Continuous verification

### ZTNA Products
- Zscaler Private Access (ZPA)
- Cloudflare Access
- Microsoft Entra Private Access
- Google BeyondCorp Enterprise
- Palo Alto Prisma Access
- Cisco Duo Network Gateway

## Secure Access Service Edge (SASE)

Convergence of network and security as cloud-delivered service:
- SD-WAN (network optimization)
- Secure Web Gateway (SWG) - URL filtering, malware inspection
- Cloud Access Security Broker (CASB) - SaaS visibility and control
- Zero Trust Network Access (ZTNA)
- Firewall-as-a-Service (FWaaS)

Benefits: single vendor for multi-function, cloud-native, reduced appliance footprint.

Vendors: Zscaler, Netskope, Palo Alto, Cisco, Cloudflare.

## Service Mesh

For microservices, service mesh handles service-to-service communication:
- **Mutual TLS (mTLS)** - Both sides authenticate
- **Identity** - Service identity via certificates
- **Traffic policies** - Routing, rate limiting, retries
- **Observability** - Request-level metrics, traces

Implementations:
- Istio
- Linkerd
- Consul
- AWS App Mesh
- Azure Service Fabric Mesh
- GCP Anthos Service Mesh

## Private Connectivity to Cloud Services

### Private Endpoints / PrivateLink
- Private IP for accessing managed services (S3, databases, SaaS)
- Traffic does not traverse internet
- Reduces exposure

### VPC Endpoints (AWS)
- Gateway endpoints (S3, DynamoDB)
- Interface endpoints (most services)
- Centralized via endpoint service architecture

### Azure Private Endpoint / Private Link
- Private IP for Azure services
- Also available for third-party services

### GCP Private Service Connect
- Same concept for GCP

## DNS in Cloud

### Private DNS
- Internal resolution for VPC resources
- Examples: Route 53 Private Hosted Zones, Azure Private DNS, GCP Cloud DNS

### DNS Security
- DNSSEC for integrity (where supported)
- DNS over HTTPS (DoH) / DNS over TLS (DoT) for privacy
- DNS firewalls for egress control (block known-bad domains)

### DNS Logging
- Critical for detecting C2 and DGAs
- Route 53 Resolver Query Logs, Azure DNS, GCP Cloud DNS logs

## Load Balancers

### Types
- L4 (TCP/UDP) - Network Load Balancer
- L7 (HTTP/HTTPS) - Application Load Balancer

### Security Features
- TLS termination (certificate management)
- Mutual TLS (emerging)
- WAF integration
- Authentication integration (OIDC at load balancer)
- Rate limiting

## CDN (Content Delivery Network)

Edge caching and acceleration:
- Examples: CloudFront, Azure Front Door, Cloud CDN, Cloudflare, Fastly, Akamai
- Security benefits: DDoS absorption, TLS at edge, WAF integration, bot mitigation
- Privacy considerations: edge locations may span jurisdictions

## Container Networking

### Kubernetes Network Policies
- Declarative pod-to-pod traffic rules
- CNI implementations: Calico, Cilium, Flannel, Weave
- Default deny for sensitive namespaces

### Ingress and Egress
- Ingress controllers (NGINX, Envoy, Traefik, cloud-native)
- Egress via NAT or egress gateway
- Service mesh for advanced policy

### CNI-Specific Features
- **Cilium** - eBPF-based, identity-aware, transparent encryption
- **Calico** - Flexible policy engine, eBPF option

## Serverless Networking

### VPC Connectivity
- Serverless functions can connect to VPC (AWS Lambda VPC config, Azure Functions VNet Integration, GCP VPC Connector)
- Performance/cost considerations (cold start, NAT)

### Function-to-Function
- Via event triggers, message queues, or direct API calls
- IAM for auth

## IPv6

- Most cloud providers support dual-stack or IPv6-only
- Global routing (no NAT required)
- Built-in IPsec capability (seldom enabled in practice)
- Plan early; retrofit is painful

## Network Virtualization

### Overlay Networks
- Encapsulate L2 over L3 (VXLAN)
- Enable large-scale multi-tenant networks
- Transparent to workloads

### Software-Defined Networking (SDN)
- Separate control plane from data plane
- Programmable via API
- All major cloud providers are fundamentally SDN

## Bastion Hosts / Jump Boxes

### Traditional Approach
- Public IP instance used to SSH/RDP into private instances
- Security risks if not hardened (lateral movement, credential theft)

### Cloud-Native Alternatives
- AWS Systems Manager Session Manager
- Azure Bastion
- GCP IAP (Identity-Aware Proxy) for SSH/RDP
- Benefits: no public IP on instances, session logging, IAM-integrated auth

## Network Monitoring

### Flow Logs
- VPC Flow Logs (AWS)
- NSG Flow Logs (Azure)
- VPC Flow Logs (GCP)
- Captures metadata of every flow (who, what, where, when, bytes)

### Packet Capture
- AWS VPC Traffic Mirroring
- Azure Packet Capture
- GCP Packet Mirroring
- For deep forensic investigation

### DNS Logs
- Critical for detecting C2, DGAs, exfiltration

## Network Threats in Cloud

| Threat | Description |
|--------|-------------|
| DDoS | Volumetric, protocol, application layer |
| Exposed services | Publicly accessible databases, admin interfaces |
| Man-in-the-middle | TLS misconfigured or downgrade attacks |
| DNS hijacking | Misdirected DNS responses |
| Amplification attacks | Reflection with response larger than request (e.g., DNS, NTP, memcached) |
| Lateral movement | After compromise, move to other internal systems |
| Exfiltration over cloud | DNS tunneling, HTTPS exfil to attacker-controlled SaaS |
| VPC peering misuse | Peered network becomes attack path |
| Misconfigured NACLs / Security Groups | Overly permissive (0.0.0.0/0) |

## Best Practices

- Default-deny firewall rules; allow only necessary
- Private subnets by default; minimal public exposure
- Private endpoints for managed service access
- Egress filtering and NAT with logging
- DDoS protection enabled
- WAF on all public-facing web apps
- Zero trust for remote access (ZTNA over VPN)
- Service mesh for microservices
- Continuous monitoring of network flows
- Immutable network configuration via IaC

## Common Exam Pitfalls

- Choosing NACL when security group is appropriate (SG is stateful, easier)
- Exposing databases publicly (always private)
- Missing private endpoints for managed services (traffic via internet)
- Forgetting egress filtering (data exfiltration path)
- Using traditional bastion when Session Manager / Bastion / IAP available
- Not enabling flow logs
- Choosing site-to-site VPN when performance requires Direct Connect / ExpressRoute / Cloud Interconnect

## Quick Reference: Network Choice

| Need | Choice |
|------|--------|
| Per-instance stateful firewall | Security group |
| Per-subnet stateless firewall | Network ACL |
| L7 web filtering | WAF |
| DDoS protection | Provider DDoS service + WAF + CDN |
| Remote admin access | Bastion service (Session Manager, Bastion, IAP) |
| App-specific remote access | ZTNA |
| Private connection to SaaS | Private Endpoint / PrivateLink |
| Central egress inspection | Hub firewall + transit architecture |
| Microservices service-to-service | Service mesh (mTLS, policy) |
| Low-latency on-prem connection | Direct Connect / ExpressRoute / Cloud Interconnect |
