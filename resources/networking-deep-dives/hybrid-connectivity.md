# Hybrid Connectivity Deep Dive

Connecting on-premises networks to cloud environments.

---

## VPN Types

### Site-to-Site VPN

A persistent, encrypted tunnel between your on-premises network and a cloud VPC/VNet.

**How It Works**
- Uses IPsec (Internet Protocol Security) to encrypt traffic over the public internet
- Requires a customer gateway device (router or firewall) on-premises
- Creates two tunnels per connection for redundancy (AWS), or a configurable number of tunnels (Azure, GCP)

**AWS Site-to-Site VPN**
```
On-premises <--IPsec--> Virtual Private Gateway (or Transit Gateway) <--> VPC
```
- Supports BGP for dynamic routing or static routes
- Each tunnel provides up to 1.25 Gbps throughput
- Accelerated VPN option uses AWS Global Accelerator for improved performance
- Docs: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html

**Azure VPN Gateway**
```
On-premises <--IPsec--> Azure VPN Gateway <--> VNet
```
- SKUs determine throughput: Basic (100 Mbps) to VpnGw5AZ (10 Gbps)
- Supports active-active configuration with two public IPs
- Policy-based (static) or route-based (dynamic with BGP) modes
- Docs: https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways

**GCP Cloud VPN**
```
On-premises <--IPsec--> Cloud VPN Gateway <--> VPC
```
- HA VPN provides 99.99% SLA with two interfaces and four tunnels
- Classic VPN provides a single interface (deprecated for new deployments)
- Each tunnel supports up to 3 Gbps
- Docs: https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview

### Client VPN (Remote Access)

Allows individual users or devices to connect to cloud resources.

**AWS Client VPN**
- OpenVPN-based managed service
- Supports Active Directory and SAML-based authentication
- Split tunnel or full tunnel routing
- Docs: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html

**Azure Point-to-Site VPN**
- Supports OpenVPN, SSTP, and IKEv2 protocols
- Certificate-based or Entra ID authentication
- Integrated with Azure VPN Gateway
- Docs: https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-about

**GCP Identity-Aware Proxy (IAP)**
- No VPN required - tunnels SSH and TCP traffic through Google's network
- Uses identity-based access instead of network-level access
- Alternative to traditional client VPN for many use cases
- Docs: https://cloud.google.com/iap/docs/concepts-overview

---

## Dedicated Interconnects

### AWS Direct Connect

**Overview**
- Dedicated 1 Gbps, 10 Gbps, or 100 Gbps connections at Direct Connect locations
- Hosted connections available from 50 Mbps to 10 Gbps through partners
- Lower latency and more consistent performance than VPN

**Architecture**
```
On-premises <--> Colocation facility (Direct Connect location) <--> AWS Region
```

**Key Concepts**
- Virtual Interfaces (VIFs):
  - Private VIF - connects to a VPC via Virtual Private Gateway
  - Public VIF - connects to AWS public services (S3, DynamoDB, etc.)
  - Transit VIF - connects to a Transit Gateway for multi-VPC access
- LAG (Link Aggregation Group) - bundle multiple connections for increased bandwidth
- Direct Connect Gateway - connect to VPCs in multiple regions from a single connection

**Docs:** https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html

### Azure ExpressRoute

**Overview**
- Dedicated connections via connectivity providers (50 Mbps to 10 Gbps standard, 100 Gbps Direct)
- ExpressRoute Direct provides dedicated port pairs (10 Gbps or 100 Gbps)
- Private peering for VNet access, Microsoft peering for Microsoft 365 and Azure public services

**Key Concepts**
- Peering types:
  - Private peering - connects to VNets
  - Microsoft peering - connects to Microsoft 365 and Azure PaaS services
- ExpressRoute Global Reach - connect on-premises sites through Microsoft backbone
- ExpressRoute FastPath - bypasses the gateway for improved data path performance
- Redundancy - two circuits per peering location by default

**Docs:** https://learn.microsoft.com/en-us/azure/expressroute/expressroute-introduction

### GCP Cloud Interconnect

**Overview**
- Dedicated Interconnect: 10 Gbps or 100 Gbps connections at Google peering edges
- Partner Interconnect: 50 Mbps to 50 Gbps through service providers
- No encryption by default (traffic stays on private network)

**Key Concepts**
- VLAN attachments connect the interconnect to VPC networks
- Up to 16 VLAN attachments per interconnect
- Can use Cloud Router for dynamic routing with BGP
- Cross-Cloud Interconnect connects directly to other cloud providers

**Docs:** https://cloud.google.com/network-connectivity/docs/interconnect/concepts/overview

---

## Transit Architectures

### AWS Transit Gateway

**Architecture**
```
VPC-A --|
VPC-B --|-- Transit Gateway --|--> VPN to on-premises
VPC-C --|                     |--> Direct Connect
```

**Key Features**
- Hub-and-spoke connectivity for multiple VPCs and on-premises networks
- Supports up to 5,000 attachments
- Route tables for network segmentation
- Inter-region peering between Transit Gateways
- Multicast support
- 50 Gbps bandwidth per VPC attachment

**Docs:** https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html

### Azure Virtual WAN

**Architecture**
```
VNet-A --|
VNet-B --|-- Virtual WAN Hub --|--> VPN to on-premises
VNet-C --|                     |--> ExpressRoute
```

**Key Features**
- Managed hub-and-spoke with automatic routing
- Supports VPN, ExpressRoute, and point-to-site in the same hub
- Hub-to-hub connectivity across regions
- Integrated with Azure Firewall and third-party NVAs
- Routing intent for simplified security policies

**Docs:** https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about

### GCP Cloud Router

**Key Features**
- Provides dynamic BGP routing for VPN and Interconnect
- Advertises VPC subnet routes to on-premises automatically
- Custom route advertisements for specific prefixes
- Works with HA VPN and Cloud Interconnect

**Network Connectivity Center**
- Hub-and-spoke topology for hybrid connectivity
- Supports multiple spokes (VPN, Interconnect, Router Appliance)
- Cross-cloud and multi-cloud networking

**Docs:** https://cloud.google.com/network-connectivity/docs/router/concepts/overview

---

## Redundancy Patterns

### Dual Tunnel VPN

- Every VPN connection should use at least two tunnels
- Tunnels should terminate on different devices or availability zones
- Use BGP for automatic failover when a tunnel goes down
- Monitor tunnel status and alert on failures

### Diverse Provider Redundancy

**For Direct Connect / ExpressRoute / Interconnect**
1. Single connection - no redundancy (not recommended for production)
2. Two connections at the same location - protects against device failure
3. Two connections at different locations - protects against facility failure
4. Two connections from different providers - protects against provider failure

**Recommended Production Setup**
```
On-premises --> Provider A (Location 1) --> Cloud
On-premises --> Provider B (Location 2) --> Cloud
On-premises --> VPN (backup) -----------> Cloud
```

### VPN as Backup for Dedicated Connections

- Configure VPN with lower BGP priority than the dedicated connection
- Traffic automatically fails over to VPN if the dedicated link goes down
- VPN provides lower bandwidth but is quick to provision
- Test failover regularly

---

## Bandwidth and Latency Considerations

### Bandwidth Comparison

| Method | Bandwidth | Typical Latency | Cost Model |
|---|---|---|---|
| Site-to-Site VPN | 1.25-3 Gbps per tunnel | Variable (internet) | Per hour + data transfer |
| Direct Connect / ExpressRoute / Interconnect | 1-100 Gbps | Low, consistent | Port hour + data transfer |
| Hosted / Partner connections | 50 Mbps - 50 Gbps | Low, consistent | Provider pricing |

### Latency Factors

- Geographic distance between on-premises and cloud region
- Number of network hops
- VPN encryption/decryption overhead (5-15% CPU overhead)
- Dedicated connections eliminate internet routing variability
- Use cloud backbone for inter-region traffic when possible

### Data Transfer Costs

- VPN: standard data transfer out charges apply
- Direct Connect / ExpressRoute: reduced data transfer rates
- Ingress is generally free, egress is charged
- Consider data transfer costs when choosing regions and connectivity methods

### Right-Sizing Guidance

- Start with VPN for proof of concept and low-bandwidth workloads
- Move to dedicated connections when you need consistent latency or bandwidth above 1 Gbps
- Use multiple connections for high-availability production workloads
- Consider SD-WAN overlay for application-level traffic steering

---

## Additional Resources

- [AWS Hybrid Networking](https://docs.aws.amazon.com/whitepapers/latest/hybrid-connectivity/hybrid-connectivity.html)
- [Azure Hybrid Networking](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/)
- [GCP Hybrid Connectivity](https://cloud.google.com/network-connectivity/docs/how-to/choose-product)
