# Cloud Service Comparison: Networking Services

## Quick Reference

This guide provides a comprehensive comparison of networking services across AWS, Google Cloud Platform (GCP), and Microsoft Azure. Use this to understand equivalent services when switching cloud providers or studying multiple certifications.

## Virtual Networks (VPC/VNet)

| Feature | AWS | GCP | Azure |
|---------|-----|-----|-------|
| **Service Name** | VPC (Virtual Private Cloud) | VPC (Virtual Private Cloud) | VNet (Virtual Network) |
| **CIDR Range** | /16 to /28 | /8 to /29 (custom mode) | /8 to /29 |
| **Subnets** | Regional (per AZ) | Regional (spans all zones) | Regional (spans all zones) |
| **IP Addresses** | Private IPv4, IPv6 | Private IPv4, IPv6 | Private IPv4, IPv6 |
| **Secondary CIDR** | Up to 5 (can request increase) | Multiple via alias IP ranges | VNet peering or additional ranges |
| **Default VPC** | Yes (one per region) | Yes (auto mode) | No |
| **DNS Resolution** | Route 53 Resolver | Cloud DNS (internal) | Azure DNS (internal) |
| **VPC Peering** | VPC Peering | VPC Network Peering | VNet Peering |
| **Transitive Routing** | No (need Transit Gateway) | No (need Cloud Router) | No (need Virtual WAN) |
| **Flow Logs** | VPC Flow Logs | VPC Flow Logs | NSG Flow Logs, VNet Flow Logs |
| **Max VPCs per Region** | 5 (default, can increase to 100+) | 15 networks per project | 1000 VNets per subscription |
| **Cost** | Free (pay for traffic) | Free (pay for traffic) | Free (pay for traffic) |

**Key Differences:**
- **AWS:** Subnets are AZ-specific, must create subnet in each AZ
- **GCP:** Subnets span all zones in a region, single subnet across zones
- **Azure:** Subnets span availability zones, similar to GCP

**Documentation:**
- **[📖 AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)** - Complete VPC guide
- **[📖 GCP VPC Documentation](https://cloud.google.com/vpc/docs)** - Complete VPC guide
- **[📖 Azure VNet Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)** - Complete VNet guide

---

## Load Balancers

| Feature | AWS ALB | AWS NLB | AWS GWLB | GCP HTTP(S) LB | GCP Network LB | Azure App Gateway | Azure Load Balancer |
|---------|---------|---------|----------|----------------|----------------|-------------------|-------------------|
| **Type** | Layer 7 | Layer 4 | Layer 3 Gateway | Layer 7 | Layer 4 | Layer 7 | Layer 4 |
| **Protocol** | HTTP/HTTPS/gRPC | TCP/UDP/TLS | IP | HTTP/HTTPS/HTTP/2 | TCP/UDP | HTTP/HTTPS | TCP/UDP |
| **Global** | No (regional) | No (regional) | No (regional) | Yes (anycast) | No (regional) | No (regional) | No (regional) |
| **SSL Termination** | Yes | Yes | No | Yes | No | Yes | No |
| **WebSocket** | Yes | Yes | N/A | Yes | N/A | Yes | N/A |
| **Path-based Routing** | Yes | No | No | Yes | No | Yes | No |
| **Host-based Routing** | Yes | No | No | Yes | No | Yes | No |
| **WAF Integration** | AWS WAF | No | No | Cloud Armor | No | Azure WAF | No |
| **Auto-scaling** | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Health Checks** | HTTP/HTTPS | TCP/HTTP/HTTPS | TCP | HTTP/HTTPS/TCP | TCP/HTTP | HTTP/HTTPS | TCP/HTTP |
| **Session Affinity** | Cookie-based | Source IP | N/A | Cookie/IP-based | Source IP | Cookie-based | Source IP |
| **Cross-zone** | Yes (free) | Yes (charged) | Yes | Automatic | Regional | Regional | Regional |
| **Static IP** | No | Yes (Elastic IP) | No | Yes (anycast) | Yes | No | Yes |
| **Pricing** | Per hour + LCU | Per hour + LCU | Per hour + LCU | Tiered (rules + data) | Per hour + data | Per hour + capacity units | Per hour + rules |

**Load Balancer Types Comparison:**

### Application Load Balancers (Layer 7)
- **AWS ALB:** Best for HTTP/HTTPS, advanced routing, Lambda targets
- **GCP HTTP(S) LB:** Global distribution, Cloud CDN integration, best latency
- **Azure Application Gateway:** WAF built-in, URL-based routing, SSL offload

### Network Load Balancers (Layer 4)
- **AWS NLB:** Ultra-low latency, static IP, handles millions of requests/sec
- **GCP Network LB:** Regional TCP/UDP, pass-through, preserve source IP
- **Azure Load Balancer:** Basic and Standard tiers, HA ports, availability zones

**Documentation:**
- **[📖 AWS Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/)** - Complete ELB guide
- **[📖 AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)** - ALB guide
- **[📖 AWS Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/)** - NLB guide
- **[📖 GCP Load Balancing](https://cloud.google.com/load-balancing/docs)** - Complete load balancing guide
- **[📖 Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/)** - Load Balancer guide
- **[📖 Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/)** - Application Gateway guide

---

## Content Delivery Network (CDN)

| Feature | AWS CloudFront | GCP Cloud CDN | Azure CDN | Azure Front Door |
|---------|---------------|---------------|-----------|------------------|
| **Edge Locations** | 450+ locations | 140+ locations | 130+ (Microsoft), 1800+ (Verizon) | 118+ locations |
| **Origin Support** | S3, EC2, ALB, Custom | Cloud Storage, Compute, Custom | Storage, VMs, Custom | Any HTTP/HTTPS origin |
| **SSL/TLS** | Free (ACM), Custom | Free (managed), Custom | Free, Custom | Free (managed), Custom |
| **HTTP/2** | Yes | Yes | Yes | Yes |
| **HTTP/3 (QUIC)** | Yes | Yes | Limited | Yes |
| **WebSocket** | Yes | Yes | Yes | Yes |
| **Geo-restriction** | Yes (whitelist/blacklist) | Yes | Yes | Yes |
| **Cache Behavior** | Multiple cache behaviors | Per-path cache rules | Per-endpoint rules | Advanced routing rules |
| **Compression** | Gzip, Brotli | Gzip, Brotli | Gzip | Gzip, Brotli |
| **Real-time Logs** | Yes (to S3, Kinesis) | Yes (to Cloud Logging) | Yes (to Storage) | Yes (to Storage, Log Analytics) |
| **WAF Integration** | AWS WAF | Cloud Armor | Yes | Azure WAF (built-in) |
| **Edge Computing** | Lambda@Edge, CloudFront Functions | Cloud CDN (limited) | No | Azure Functions (limited) |
| **Failover** | Origin groups | Backend services | Multiple origins | Built-in failover |
| **Cache TTL** | 0 seconds to 1 year | 0 seconds to 1 year | 0 seconds to 366 days | Custom |
| **Pricing Model** | Per GB + requests | Per GB + requests | Per GB + requests | Per GB + rules + requests |
| **Free Tier** | 1 TB/month (12 months) | No free tier | No free tier | No free tier |

**Key Differences:**
- **CloudFront:** Most edge locations, best Lambda@Edge for serverless edge computing
- **Cloud CDN:** Tightly integrated with Google Cloud, best for YouTube-like use cases
- **Azure CDN:** Multiple CDN providers (Microsoft, Verizon, Akamai)
- **Azure Front Door:** Global load balancing + CDN, best for enterprise multi-region apps

**Documentation:**
- **[📖 AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)** - Complete CloudFront guide
- **[📖 GCP Cloud CDN Documentation](https://cloud.google.com/cdn/docs)** - Complete Cloud CDN guide
- **[📖 Azure CDN Documentation](https://learn.microsoft.com/en-us/azure/cdn/)** - Azure CDN guide
- **[📖 Azure Front Door Documentation](https://learn.microsoft.com/en-us/azure/frontdoor/)** - Front Door guide

---

## DNS Services

| Feature | AWS Route 53 | GCP Cloud DNS | Azure DNS |
|---------|-------------|---------------|-----------|
| **Hosted Zones** | Public, Private | Public, Private | Public, Private |
| **Routing Policies** | Simple, Weighted, Latency, Failover, Geolocation, Geoproximity, Multivalue | Weighted Round Robin, Geolocation | Simple, Weighted, Priority, Geographic, Multivalue, Subnet |
| **Health Checks** | Yes (HTTP, HTTPS, TCP) | No (use uptime checks) | No (use Traffic Manager) |
| **DNSSEC** | Yes | Yes | Yes |
| **Traffic Flow** | Visual policy builder | No | Traffic Manager (separate) |
| **Alias Records** | Yes (AWS resources) | No | Yes (Azure resources) |
| **SLA** | 100% availability SLA | 100% availability SLA | 100% availability SLA |
| **Query Logging** | Yes (to CloudWatch) | Yes (to Cloud Logging) | Yes (to Log Analytics) |
| **API Support** | Full REST API | Full REST API | Full REST API |
| **Domain Registration** | Yes | Yes (via Google Domains) | No (use third-party) |
| **Max TTL** | 2147483647 seconds | 2147483647 seconds | 2147483647 seconds |
| **Pricing** | $0.50/zone/month + queries | $0.20/zone/month + queries | $0.50/zone/month + queries |

**Routing Policy Comparison:**

| Use Case | AWS Route 53 | GCP Cloud DNS | Azure DNS |
|----------|-------------|---------------|-----------|
| **Load Balancing** | Weighted | Weighted Round Robin | Weighted |
| **Disaster Recovery** | Failover + Health Checks | Manual DNS changes | Traffic Manager (separate service) |
| **Latency-based** | Latency routing | Not supported | Traffic Manager Performance |
| **Geographic** | Geolocation, Geoproximity | Geolocation steering | Geographic routing |

**Documentation:**
- **[📖 AWS Route 53 Documentation](https://docs.aws.amazon.com/route53/)** - Complete Route 53 guide
- **[📖 GCP Cloud DNS Documentation](https://cloud.google.com/dns/docs)** - Complete Cloud DNS guide
- **[📖 Azure DNS Documentation](https://learn.microsoft.com/en-us/azure/dns/)** - Azure DNS guide
- **[📖 Azure Traffic Manager Documentation](https://learn.microsoft.com/en-us/azure/traffic-manager/)** - Traffic routing

---

## VPN Services

| Feature | AWS Site-to-Site VPN | AWS Client VPN | GCP Cloud VPN | Azure VPN Gateway |
|---------|---------------------|----------------|---------------|-------------------|
| **VPN Type** | Site-to-Site | Client-to-Site | Site-to-Site | Site-to-Site, Point-to-Site |
| **Protocol** | IPsec | OpenVPN, IKEv2 | IPsec (IKEv2) | IPsec (IKEv2), OpenVPN, SSTP |
| **Throughput** | Up to 1.25 Gbps/tunnel | Up to 2 Gbps | Up to 3 Gbps/tunnel (HA VPN) | 100 Mbps to 10 Gbps |
| **Redundancy** | 2 tunnels per connection | Multiple endpoints | HA VPN (2 tunnels) | Active-active, Active-passive |
| **BGP Support** | Yes (dynamic routing) | No | Yes | Yes |
| **Static Routing** | Yes | N/A | Yes | Yes |
| **Encryption** | AES-256, AES-128 | AES-256 | AES-256, AES-128 | AES-256 |
| **Authentication** | Pre-shared key, Certificate | Certificate-based, AD | Pre-shared key, Certificate | Pre-shared key, Certificate, Azure AD |
| **Gateway Types** | Virtual Private Gateway, Transit Gateway | Client VPN Endpoint | Cloud VPN Gateway | VPN Gateway (VpnGw1-5, Basic) |
| **Max Connections** | 10 per VGW | 10,000 per endpoint | No limit | 10,000+ |
| **SLA** | 99.95% | 99.95% | 99.99% (HA VPN) | 99.9% - 99.95% |
| **Pricing** | $0.05/hour + data transfer | $0.10/hour/connection + data | $0.05/hour/tunnel + data | SKU-based (VpnGw1-5) + data |

**VPN Gateway SKU Comparison (Azure):**

| SKU | Throughput | BGP | Active-Active | Point-to-Site | Price/Hour |
|-----|-----------|-----|---------------|---------------|------------|
| **Basic** | 100 Mbps | No | No | 128 connections | ~$0.04 |
| **VpnGw1** | 650 Mbps | Yes | Yes | 250 connections | ~$0.19 |
| **VpnGw2** | 1 Gbps | Yes | Yes | 500 connections | ~$0.49 |
| **VpnGw3** | 1.25 Gbps | Yes | Yes | 1000 connections | ~$1.25 |
| **VpnGw4** | 5 Gbps | Yes | Yes | 5000 connections | ~$1.60 |
| **VpnGw5** | 10 Gbps | Yes | Yes | 10000 connections | ~$3.25 |

**Documentation:**
- **[📖 AWS VPN Documentation](https://docs.aws.amazon.com/vpn/)** - Complete VPN guide
- **[📖 AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/)** - Site-to-Site VPN guide
- **[📖 AWS Client VPN](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/)** - Client VPN guide
- **[📖 GCP Cloud VPN Documentation](https://cloud.google.com/network-connectivity/docs/vpn)** - Cloud VPN guide
- **[📖 Azure VPN Gateway Documentation](https://learn.microsoft.com/en-us/azure/vpn-gateway/)** - VPN Gateway guide

---

## Dedicated Connections (Private Connectivity)

| Feature | AWS Direct Connect | GCP Cloud Interconnect | Azure ExpressRoute |
|---------|-------------------|----------------------|-------------------|
| **Connection Type** | Dedicated, Hosted | Dedicated, Partner | Dedicated, Partner (Provider) |
| **Bandwidth** | 1 Gbps, 10 Gbps, 100 Gbps | 10 Gbps, 100 Gbps (Dedicated) | 50 Mbps to 10 Gbps (Provider), 10/100 Gbps (Direct) |
| **Locations** | 100+ Direct Connect locations | 140+ colocation facilities | 200+ ExpressRoute locations |
| **SLA** | 99.9% | 99.9% - 99.99% | 99.95% |
| **Virtual Interfaces** | Private VIF, Public VIF, Transit VIF | VLAN attachments | Private peering, Microsoft peering |
| **Private Connectivity** | Yes (to VPCs) | Yes (to VPCs) | Yes (to VNets) |
| **Public Connectivity** | Yes (to AWS public services) | Limited | Yes (to Microsoft services) |
| **BGP Required** | Yes | Yes | Yes |
| **Encryption** | MACsec (100G only), IPsec VPN overlay | MACsec | MACsec, IPsec VPN overlay |
| **Redundancy** | Manual (multiple connections) | 99.99% SLA (Dedicated) | Manual (multiple circuits) |
| **Setup Time** | Days to weeks | Days to weeks | Days to weeks |
| **Multi-region** | Via Direct Connect Gateway | Via Cloud Router | Via ExpressRoute Global Reach |
| **Pricing** | Port hours + data transfer (outbound) | VLAN attachment + data | Circuit + data transfer (outbound) |

**Connection Speed Comparison:**

| Provider | Dedicated | Hosted/Partner |
|----------|----------|----------------|
| **AWS Direct Connect** | 1/10/100 Gbps | 50M, 100M, 200M, 300M, 400M, 500M, 1G, 2G, 5G, 10G |
| **GCP Cloud Interconnect** | 10/100 Gbps | 50M, 100M, 200M, 300M, 400M, 500M, 1G, 2G, 5G, 10G, 20G, 50G |
| **Azure ExpressRoute** | 10/100 Gbps (Direct) | 50M, 100M, 200M, 500M, 1G, 2G, 5G, 10G |

**Use Cases:**
- **Hybrid Cloud:** Connect on-premises data center to cloud
- **Data Migration:** Large-scale data transfer (faster than internet)
- **Latency-sensitive:** Sub-10ms latency requirements
- **Compliance:** Data cannot traverse public internet
- **Cost Savings:** Reduced data transfer costs for high-volume egress

**Documentation:**
- **[📖 AWS Direct Connect Documentation](https://docs.aws.amazon.com/directconnect/)** - Complete Direct Connect guide
- **[📖 GCP Cloud Interconnect Documentation](https://cloud.google.com/network-connectivity/docs/interconnect)** - Cloud Interconnect guide
- **[📖 Azure ExpressRoute Documentation](https://learn.microsoft.com/en-us/azure/expressroute/)** - ExpressRoute guide

---

## Firewalls and Security Groups

### Stateful Firewalls (Security Groups)

| Feature | AWS Security Groups | GCP Firewall Rules | Azure Network Security Groups (NSG) |
|---------|-------------------|-------------------|-------------------------------------|
| **Type** | Stateful | Stateful (egress), Stateless (ingress) | Stateful |
| **Scope** | Instance-level (ENI) | VPC-level (applies to instances) | Subnet or NIC level |
| **Default** | Deny all inbound, Allow all outbound | Deny all ingress, Allow all egress | Deny all inbound, Allow all outbound |
| **Rules** | Allow only | Allow or Deny | Allow or Deny |
| **Priority** | All rules evaluated | Priority-based (0-65535) | Priority-based (100-4096) |
| **IP Ranges** | CIDR blocks | CIDR blocks, service accounts, tags | CIDR blocks, service tags |
| **Service Tags** | No | Yes (target/source tags) | Yes (VirtualNetwork, Internet, etc.) |
| **Rule Limits** | 60 inbound + 60 outbound per SG | 2500 rules per project | 1000 rules per NSG |
| **Max per Resource** | 5 security groups per ENI | N/A (VPC-level) | 1 NSG per subnet, unlimited per NIC |
| **Logging** | VPC Flow Logs | Firewall Rules Logging | NSG Flow Logs |
| **Application Rules** | No | No | No (use Azure Firewall) |

### Stateless Firewalls (Network ACLs)

| Feature | AWS Network ACLs | GCP VPC Firewall | Azure - |
|---------|-----------------|-----------------|---------|
| **Type** | Stateless | Ingress rules are stateless | N/A (NSGs are stateful) |
| **Scope** | Subnet-level | VPC-level | - |
| **Default** | Allow all | Deny all (customizable) | - |
| **Rules** | Allow and Deny | Allow and Deny | - |
| **Priority** | Rule number (1-32766) | Priority (0-65535) | - |
| **Evaluation** | Ordered (lowest first) | Priority-based | - |

### Advanced Firewall Services

| Feature | AWS Network Firewall | GCP Cloud Armor | GCP Cloud NGFW | Azure Firewall | Azure WAF |
|---------|---------------------|----------------|---------------|----------------|-----------|
| **Type** | Managed stateful firewall | DDoS + WAF | Next-gen firewall | Managed firewall | Web App Firewall |
| **Layer** | Layer 3-7 | Layer 7 | Layer 3-7 | Layer 3-7 | Layer 7 |
| **IDS/IPS** | Yes (Suricata) | No | Yes | Yes (IDPS) | Limited |
| **TLS Inspection** | Yes | Yes | Yes | Yes | Yes |
| **Threat Intelligence** | AWS managed | Google Cloud Armor adaptive | Google threat intel | Microsoft threat intel | OWASP Top 10 |
| **URL Filtering** | Yes | Yes | Yes | Yes | Yes |
| **FQDN Filtering** | Yes | No | Yes | Yes | Limited |
| **Custom Rules** | Yes | Yes | Yes | Yes | Yes |
| **Pricing** | Per hour + processing | Per policy + requests | Per endpoint + data | Per hour + data | Per policy + requests |

**Documentation:**
- **[📖 AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)** - Security Groups guide
- **[📖 AWS Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Network ACLs guide
- **[📖 AWS Network Firewall](https://docs.aws.amazon.com/network-firewall/)** - Network Firewall guide
- **[📖 GCP VPC Firewall Rules](https://cloud.google.com/vpc/docs/firewalls)** - Firewall rules guide
- **[📖 GCP Cloud Armor](https://cloud.google.com/armor/docs)** - Cloud Armor guide
- **[📖 Azure NSG Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)** - NSG guide
- **[📖 Azure Firewall Documentation](https://learn.microsoft.com/en-us/azure/firewall/)** - Azure Firewall guide

---

## NAT Gateways

| Feature | AWS NAT Gateway | GCP Cloud NAT | Azure NAT Gateway |
|---------|----------------|---------------|-------------------|
| **Type** | Managed service | Fully managed | Managed service |
| **Availability** | Single AZ | Regional (auto-scaling) | Zonal or Regional |
| **Bandwidth** | Up to 100 Gbps | Auto-scaling | Up to 50 Gbps |
| **Public IPs** | 1-16 Elastic IPs | Automatic or manual | 1-16 Public IPs |
| **Port Allocation** | 55,000 per IP | 64,512 per IP | 64,000 per IP |
| **Connection Limits** | 55,000 concurrent per IP | 64,512 per VM | 64,000 per IP |
| **High Availability** | Per AZ (need multiple) | Regional (built-in) | Zone-redundant option |
| **Pricing** | Per hour + data processed | Per hour + data processed | Per hour + data processed |
| **Idle Timeout** | 350 seconds (not configurable) | Configurable (4 mins default) | 4-120 minutes (configurable) |
| **Connection Tracking** | Yes | Yes | Yes |

**NAT Instance vs NAT Gateway:**

| Feature | NAT Gateway (Managed) | NAT Instance (Self-managed) |
|---------|----------------------|---------------------------|
| **Availability** | Highly available (per AZ) | Manual HA setup required |
| **Bandwidth** | Up to 100 Gbps | Depends on instance type |
| **Maintenance** | Managed by provider | You manage |
| **Cost** | Higher (managed service) | Lower (instance cost only) |
| **Security Groups** | No (cannot assign) | Yes |
| **Port Forwarding** | No | Yes |
| **Bastion Server** | No | Yes (can dual purpose) |

**Documentation:**
- **[📖 AWS NAT Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)** - NAT Gateway guide
- **[📖 GCP Cloud NAT Documentation](https://cloud.google.com/nat/docs)** - Cloud NAT guide
- **[📖 Azure NAT Gateway Documentation](https://learn.microsoft.com/en-us/azure/nat-gateway/)** - NAT Gateway guide

---

## Private Connectivity and Service Endpoints

| Feature | AWS PrivateLink | GCP Private Service Connect | Azure Private Link |
|---------|----------------|---------------------------|-------------------|
| **Purpose** | Private access to services | Private access to services | Private access to services |
| **Traffic** | Stays on AWS network | Stays on GCP network | Stays on Azure network |
| **Endpoints** | VPC Endpoints (Interface, Gateway) | Private Service Connect endpoints | Private Endpoints |
| **Supported Services** | 100+ AWS services, SaaS | Google services, SaaS | 100+ Azure services, SaaS |
| **DNS** | Private DNS names | Private DNS zones | Private DNS zones |
| **Cross-region** | Yes | Yes | Yes |
| **Cross-account** | Yes | Yes | Yes |
| **IP Address** | Private IP from VPC | Private IP from VPC | Private IP from VNet |
| **Pricing** | Per hour + data processed | Per endpoint + data processed | Per hour + data processed |

**Endpoint Types:**

### AWS VPC Endpoints
- **Gateway Endpoints:** S3, DynamoDB (free, route table-based)
- **Interface Endpoints:** Most AWS services (powered by PrivateLink)
- **Gateway Load Balancer Endpoints:** Security appliances

### GCP Private Service Connect
- **Consumer Endpoints:** Access Google services or partner services
- **Producer Endpoints:** Expose your services privately

### Azure Private Link
- **Private Endpoints:** Access PaaS services (Storage, SQL, etc.)
- **Private Link Service:** Expose your own services

**Documentation:**
- **[📖 AWS PrivateLink Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/)** - PrivateLink guide
- **[📖 AWS VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html)** - VPC Endpoints guide
- **[📖 GCP Private Service Connect](https://cloud.google.com/vpc/docs/private-service-connect)** - Private Service Connect guide
- **[📖 Azure Private Link Documentation](https://learn.microsoft.com/en-us/azure/private-link/)** - Private Link guide

---

## Transit and Hub-Spoke Architecture

| Feature | AWS Transit Gateway | GCP Network Connectivity Center | Azure Virtual WAN |
|---------|-------------------|-------------------------------|-------------------|
| **Purpose** | Connect VPCs, VPNs, Direct Connect | Centralized connectivity management | Global transit network |
| **Topology** | Hub-and-spoke | Hub-and-spoke | Hub-and-spoke |
| **Max VPCs/VNets** | 5000 attachments | Unlimited spokes | 500 VNets per hub |
| **Transitive Routing** | Yes | Yes | Yes |
| **VPN Support** | Yes (built-in) | Yes (Cloud VPN) | Yes (built-in) |
| **BGP** | Yes | Yes | Yes |
| **Inter-region** | Transit Gateway Peering | Global routing | Virtual WAN hubs |
| **Route Tables** | Multiple (association/propagation) | Cloud Router | Effective routes |
| **Third-party NVA** | Via VPC attachments | Via NVA in VPC | Integrated (NVA in Virtual WAN) |
| **SD-WAN Integration** | Via partner solutions | Via Cloud Interconnect | Native (partner NVAs) |
| **Bandwidth** | 50 Gbps per VPC attachment | No hard limit | Up to 100 Gbps per hub |
| **Pricing** | Per attachment + data processed | VPN/Interconnect pricing | Per hub + scale unit + data |

**Use Cases:**
- **Centralized Connectivity:** Single connection point for all networks
- **Transitive Routing:** Allow VPCs to communicate through hub
- **Hybrid Cloud:** Connect on-premises to multiple cloud networks
- **Multi-region:** Connect networks across regions

**Documentation:**
- **[📖 AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)** - Transit Gateway guide
- **[📖 GCP Network Connectivity Center](https://cloud.google.com/network-connectivity/docs/network-connectivity-center)** - Connectivity Center guide
- **[📖 Azure Virtual WAN Documentation](https://learn.microsoft.com/en-us/azure/virtual-wan/)** - Virtual WAN guide

---

## Pricing Comparison

### VPN Gateway Pricing (Monthly estimates)

| Provider | Service | Connection Fee | Data Transfer (per GB) |
|----------|---------|---------------|----------------------|
| **AWS** | Site-to-Site VPN | $36/month (per connection) | Standard data transfer rates |
| **GCP** | Cloud VPN (HA) | $73/month (2 tunnels) | $0.01 - $0.12/GB egress |
| **Azure** | VPN Gateway (VpnGw1) | ~$140/month | Standard data transfer rates |

### NAT Gateway Pricing (US East/Central region)

| Provider | Hourly Rate | Data Processed (per GB) |
|----------|-------------|----------------------|
| **AWS** | $0.045/hour (~$33/month) | $0.045/GB |
| **GCP** | $0.044/hour (~$32/month) | $0.045/GB |
| **Azure** | $0.045/hour (~$33/month) | $0.045/GB |

### Load Balancer Pricing (Approximate)

| Provider | Service | Hourly Rate | Additional Costs |
|----------|---------|-------------|-----------------|
| **AWS** | Application Load Balancer | $0.0225/hour (~$16/month) | LCU: $0.008/hour |
| **AWS** | Network Load Balancer | $0.0225/hour (~$16/month) | LCU: $0.006/hour |
| **GCP** | HTTP(S) Load Balancer | Varies by rules | $0.025 per rule + $0.008-$0.012/GB |
| **GCP** | Network Load Balancer | $0.025/hour (~$18/month) | Plus data processed |
| **Azure** | Application Gateway | $0.36/hour (~$262/month) | Capacity units |
| **Azure** | Load Balancer (Standard) | $0.025/hour (~$18/month) | $0.005 per rule |

### Direct Connect / Interconnect / ExpressRoute (1 Gbps Port)

| Provider | Port Fee (Monthly) | Data Transfer Out |
|----------|-------------------|-------------------|
| **AWS Direct Connect** | $216 - $300/month | $0.02/GB (varies by region) |
| **GCP Cloud Interconnect** | ~$300/month (VLAN attachment) | $0.01 - $0.085/GB |
| **Azure ExpressRoute** | ~$318/month (1 Gbps) | Metered or unlimited plans |

*Note: Prices vary by region and are subject to change. Always use official pricing calculators.*

**Pricing Calculators:**
- **[📖 AWS Pricing Calculator](https://calculator.aws/)** - AWS cost estimates
- **[📖 GCP Pricing Calculator](https://cloud.google.com/products/calculator)** - GCP cost estimates
- **[📖 Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)** - Azure cost estimates

---

## CLI Command Comparison

### Create a VPC/VNet

**AWS:**
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=MyVPC}]'

# Create subnet
aws ec2 create-subnet --vpc-id vpc-xxxxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
```

**GCP:**
```bash
# Create VPC (custom mode)
gcloud compute networks create my-vpc --subnet-mode=custom

# Create subnet
gcloud compute networks subnets create my-subnet \
  --network=my-vpc \
  --region=us-central1 \
  --range=10.0.1.0/24
```

**Azure:**
```bash
# Create VNet with subnet
az network vnet create \
  --resource-group myResourceGroup \
  --name myVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name mySubnet \
  --subnet-prefix 10.0.1.0/24
```

### Create a Load Balancer

**AWS (Application Load Balancer):**
```bash
# Create ALB
aws elbv2 create-load-balancer \
  --name my-alb \
  --subnets subnet-xxxxx subnet-yyyyy \
  --security-groups sg-xxxxx \
  --scheme internet-facing

# Create target group
aws elbv2 create-target-group \
  --name my-targets \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-xxxxx
```

**GCP (HTTP(S) Load Balancer):**
```bash
# Create backend service
gcloud compute backend-services create my-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=my-health-check \
  --global

# Create URL map
gcloud compute url-maps create my-url-map \
  --default-service=my-backend-service

# Create HTTP proxy
gcloud compute target-http-proxies create my-http-proxy \
  --url-map=my-url-map

# Create forwarding rule
gcloud compute forwarding-rules create my-http-rule \
  --global \
  --target-http-proxy=my-http-proxy \
  --ports=80
```

**Azure (Application Gateway):**
```bash
# Create Application Gateway
az network application-gateway create \
  --name myAppGateway \
  --resource-group myResourceGroup \
  --vnet-name myVNet \
  --subnet mySubnet \
  --capacity 2 \
  --sku Standard_v2 \
  --http-settings-cookie-based-affinity Disabled \
  --frontend-port 80 \
  --http-settings-port 80 \
  --http-settings-protocol Http \
  --public-ip-address myPublicIP
```

### Create Security Group / Firewall Rule

**AWS:**
```bash
# Create security group
aws ec2 create-security-group \
  --group-name my-sg \
  --description "My security group" \
  --vpc-id vpc-xxxxx

# Add ingress rule
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxx \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0
```

**GCP:**
```bash
# Create firewall rule
gcloud compute firewall-rules create allow-http \
  --network=my-vpc \
  --allow=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=web-server
```

**Azure:**
```bash
# Create NSG
az network nsg create \
  --resource-group myResourceGroup \
  --name myNSG

# Add security rule
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --name allow-http \
  --priority 100 \
  --source-address-prefixes '*' \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp
```

### Create NAT Gateway

**AWS:**
```bash
# Allocate Elastic IP
aws ec2 allocate-address --domain vpc

# Create NAT Gateway
aws ec2 create-nat-gateway \
  --subnet-id subnet-xxxxx \
  --allocation-id eipalloc-xxxxx

# Update route table
aws ec2 create-route \
  --route-table-id rtb-xxxxx \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-xxxxx
```

**GCP:**
```bash
# Create Cloud Router
gcloud compute routers create my-router \
  --network=my-vpc \
  --region=us-central1

# Create Cloud NAT
gcloud compute routers nats create my-nat \
  --router=my-router \
  --region=us-central1 \
  --nat-all-subnet-ip-ranges \
  --auto-allocate-nat-external-ips
```

**Azure:**
```bash
# Create public IP
az network public-ip create \
  --resource-group myResourceGroup \
  --name myNatIP \
  --sku Standard \
  --allocation-method Static

# Create NAT Gateway
az network nat gateway create \
  --resource-group myResourceGroup \
  --name myNatGateway \
  --public-ip-addresses myNatIP \
  --idle-timeout 10

# Associate with subnet
az network vnet subnet update \
  --resource-group myResourceGroup \
  --vnet-name myVNet \
  --name mySubnet \
  --nat-gateway myNatGateway
```

### Create VPN Connection

**AWS:**
```bash
# Create customer gateway
aws ec2 create-customer-gateway \
  --type ipsec.1 \
  --public-ip 203.0.113.12 \
  --bgp-asn 65000

# Create VPN connection
aws ec2 create-vpn-connection \
  --type ipsec.1 \
  --customer-gateway-id cgw-xxxxx \
  --vpn-gateway-id vgw-xxxxx
```

**GCP:**
```bash
# Create VPN gateway
gcloud compute vpn-gateways create my-vpn-gateway \
  --network=my-vpc \
  --region=us-central1

# Create VPN tunnel
gcloud compute vpn-tunnels create my-tunnel \
  --peer-address=203.0.113.12 \
  --shared-secret=my-secret \
  --target-vpn-gateway=my-vpn-gateway \
  --region=us-central1
```

**Azure:**
```bash
# Create VPN Gateway
az network vnet-gateway create \
  --resource-group myResourceGroup \
  --name myVpnGateway \
  --public-ip-address myGatewayIP \
  --vnet myVNet \
  --gateway-type Vpn \
  --vpn-type RouteBased \
  --sku VpnGw1 \
  --no-wait

# Create local network gateway (on-premises)
az network local-gateway create \
  --resource-group myResourceGroup \
  --name myLocalGateway \
  --gateway-ip-address 203.0.113.12 \
  --local-address-prefixes 192.168.0.0/16

# Create VPN connection
az network vpn-connection create \
  --resource-group myResourceGroup \
  --name myConnection \
  --vnet-gateway1 myVpnGateway \
  --local-gateway2 myLocalGateway \
  --shared-key "MySharedKey123"
```

---

## Decision Tree: Which Networking Service?

### When to Use VPC Peering
- ✅ Connect two VPCs in same or different regions
- ✅ Low latency, private connectivity required
- ✅ Simple hub-spoke with few VPCs (< 10)
- ✅ No transitive routing needed
- ❌ Need to connect many VPCs (use Transit Gateway/Virtual WAN)
- ❌ Need centralized management and routing

### When to Use Transit Gateway / Virtual WAN
- ✅ Hub-and-spoke architecture with 10+ VPCs
- ✅ Need transitive routing between networks
- ✅ Centralized network management
- ✅ Complex routing requirements
- ✅ SD-WAN integration
- ❌ Only 2-3 VPCs (overhead not worth it)
- ❌ Simple point-to-point connectivity

### When to Use VPN
- ✅ Connect on-premises to cloud
- ✅ Budget-conscious (lower cost than Direct Connect)
- ✅ Setup time < 1 week
- ✅ Bandwidth < 1 Gbps
- ✅ Can tolerate internet latency and variability
- ❌ Need guaranteed latency/bandwidth
- ❌ High bandwidth requirements (> 1 Gbps)
- ❌ Compliance: data cannot traverse internet

### When to Use Direct Connect / Interconnect / ExpressRoute
- ✅ High bandwidth requirements (> 1 Gbps)
- ✅ Predictable, consistent latency needed
- ✅ Large data migrations
- ✅ Compliance requires private connectivity
- ✅ Cost savings on high egress (> 10 TB/month)
- ❌ Budget constraints (VPN is cheaper)
- ❌ Need immediate setup (takes weeks)

### When to Use Application Load Balancer
- ✅ HTTP/HTTPS traffic
- ✅ Need path-based or host-based routing
- ✅ Microservices architecture
- ✅ WebSocket support needed
- ✅ WAF integration required
- ❌ Non-HTTP protocols (use Network Load Balancer)
- ❌ Ultra-low latency required (< 1ms)

### When to Use Network Load Balancer
- ✅ TCP/UDP traffic
- ✅ Ultra-high performance (millions of requests/sec)
- ✅ Static IP required
- ✅ Preserve source IP address
- ✅ Ultra-low latency (< 1ms)
- ❌ Need Layer 7 routing (use Application LB)
- ❌ Need WAF protection

### When to Use CDN
- ✅ Static content delivery (images, videos, CSS, JS)
- ✅ Global user base
- ✅ Need to reduce origin load
- ✅ Improve page load times
- ✅ DDoS protection
- ❌ Content is dynamic and user-specific
- ❌ Users are in single region (origin might be faster)

### When to Use NAT Gateway
- ✅ Private instances need internet access
- ✅ Outbound-only internet connectivity
- ✅ Software updates from internet
- ✅ Call external APIs
- ❌ Need inbound internet access (use Load Balancer)
- ❌ Specific port forwarding required (use NAT instance)

### When to Use Private Link / VPC Endpoints
- ✅ Access AWS/GCP/Azure services without internet
- ✅ Enhanced security requirements
- ✅ Reduce data transfer costs
- ✅ Access third-party SaaS privately
- ❌ Service not supported by Private Link
- ❌ Budget constraints (adds hourly cost)

---

## Key Takeaways

### AWS Networking Strengths
- ✅ Most comprehensive and mature networking services
- ✅ Transit Gateway for complex multi-VPC architectures
- ✅ Extensive third-party integration (SD-WAN, firewalls)
- ✅ Most Direct Connect locations globally
- ✅ Best documentation and learning resources

### GCP Networking Strengths
- ✅ Simplest networking model (subnets span all zones)
- ✅ Global VPC (single VPC across all regions)
- ✅ Premium vs Standard network tier options
- ✅ Best network performance (Andromeda SDN)
- ✅ Cloud NAT is regional (auto-scaling, HA built-in)
- ✅ No cross-zone data transfer charges within region

### Azure Networking Strengths
- ✅ Best for hybrid cloud (ExpressRoute, Virtual WAN)
- ✅ Strong SD-WAN integration in Virtual WAN
- ✅ Azure Firewall with built-in threat intelligence
- ✅ Network Watcher for advanced diagnostics
- ✅ Integration with on-premises Active Directory

---

## Common Networking Patterns

### Pattern 1: Three-Tier Web Application

**Architecture:**
- Web tier: Public subnet with ALB/Load Balancer
- App tier: Private subnet with application servers
- Data tier: Private subnet with databases
- NAT Gateway for outbound internet access from private subnets

**AWS Example:**
```
Internet → ALB (Public Subnet) → EC2 (Private Subnet) → RDS (Private Subnet)
                                     ↓
                                NAT Gateway → Internet (updates)
```

**Security:**
- Web tier: Allow 80/443 from internet
- App tier: Allow app port from web tier only
- Data tier: Allow DB port from app tier only
- All private subnets: Route outbound through NAT Gateway

### Pattern 2: Hybrid Cloud Connectivity

**Architecture:**
- On-premises data center
- Direct Connect / ExpressRoute for primary connectivity
- VPN as backup for failover
- Transit Gateway / Virtual WAN for hub-and-spoke

**Redundancy:**
- Primary: Direct Connect with 2 connections (different locations)
- Backup: VPN over internet
- BGP for automatic failover

### Pattern 3: Multi-Region Global Application

**Architecture:**
- CloudFront / Cloud CDN for static content
- Global load balancing (Route 53 latency routing / Traffic Manager)
- Regional application deployments
- Cross-region VPC peering or Transit Gateway peering

**Traffic Flow:**
```
User → CDN (edge location) → Global LB → Regional LB → Application
```

### Pattern 4: Hub-and-Spoke Network

**Architecture:**
- Hub VPC/VNet with shared services (firewalls, monitoring)
- Spoke VPCs/VNets for workloads
- Transit Gateway / Virtual WAN for connectivity
- Centralized egress through NAT or firewall

**Benefits:**
- Centralized security and logging
- Shared services (DNS, Active Directory)
- Cost efficiency (single NAT/firewall)
- Simplified management

---

## Comparison Matrix: Quick Reference

| Need | AWS | GCP | Azure |
|------|-----|-----|-------|
| **Basic virtual network** | VPC | VPC | VNet |
| **HTTP(S) load balancing** | ALB | HTTP(S) Load Balancer | Application Gateway |
| **TCP/UDP load balancing** | NLB | Network Load Balancer | Load Balancer |
| **Global CDN** | CloudFront | Cloud CDN | Azure CDN / Front Door |
| **DNS hosting** | Route 53 | Cloud DNS | Azure DNS |
| **VPN connectivity** | Site-to-Site VPN | Cloud VPN | VPN Gateway |
| **Dedicated connection** | Direct Connect | Cloud Interconnect | ExpressRoute |
| **NAT for private subnets** | NAT Gateway | Cloud NAT | NAT Gateway |
| **Private service access** | PrivateLink / VPC Endpoints | Private Service Connect | Private Link |
| **Firewall** | Security Groups, NACLs | VPC Firewall Rules | NSG |
| **Advanced firewall** | Network Firewall | Cloud Armor, Cloud NGFW | Azure Firewall |
| **Multi-VPC connectivity** | Transit Gateway | Network Connectivity Center | Virtual WAN |
| **Traffic inspection** | Gateway Load Balancer | Packet Mirroring | Network Watcher |
| **DDoS protection** | Shield | Cloud Armor | DDoS Protection |

---

**Related Guides:**
- [Compute Service Comparison](./service-comparison-compute.md)
- [Storage Service Comparison](./service-comparison-storage.md)
- [Database Service Comparison](./service-comparison-databases.md)
- [Security Tools Comparison](./service-comparison-security-tools.md)
