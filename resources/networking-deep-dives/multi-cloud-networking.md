# Multi-Cloud Networking Deep Dive

Strategies and patterns for connecting workloads across multiple cloud providers.

---

## Cross-Cloud Connectivity Options

### VPN Mesh

The simplest approach - create IPsec VPN tunnels between cloud providers.

**AWS to Azure VPN**
```
AWS VPC <--IPsec VPN--> Azure VNet
  |                       |
  Virtual Private Gateway Azure VPN Gateway
  or Transit Gateway
```

**Setup Steps**
1. Create a VPN Gateway in Azure and a Virtual Private Gateway (or Transit Gateway) in AWS
2. Exchange public IP addresses between gateways
3. Configure matching IPsec/IKE parameters on both sides
4. Add routes in both clouds pointing to the VPN tunnel
5. Use BGP for dynamic route exchange (recommended)

**AWS to GCP VPN**
```
AWS VPC <--IPsec VPN--> GCP VPC
  |                       |
  Transit Gateway         HA VPN Gateway + Cloud Router
```

**Key Considerations**
- Each tunnel typically provides 1.25-3 Gbps depending on the provider
- Use multiple tunnels for higher aggregate bandwidth
- BGP is strongly recommended for failover and route management
- Encryption overhead adds 5-15% latency
- Data transfer costs apply on both sides

### GCP Cross-Cloud Interconnect

GCP offers dedicated connections to other cloud providers without going over the public internet.

- Available for connections to AWS, Azure, and Oracle Cloud
- 10 Gbps or 100 Gbps dedicated links
- Lower latency and higher throughput than VPN
- Docs: https://cloud.google.com/network-connectivity/docs/interconnect/concepts/cross-cloud-overview

### Third-Party SD-WAN

Software-defined WAN solutions provide an overlay network across clouds.

**Popular Solutions**
- Cisco SD-WAN (Viptela) - deploys virtual routers in each cloud
- VMware VeloCloud - cloud-native SD-WAN with multi-cloud gateways
- Palo Alto Prisma SD-WAN - integrates with Prisma SASE
- Aviatrix - purpose-built for multi-cloud networking

**Benefits over VPN Mesh**
- Centralized management and visibility across all clouds
- Application-aware routing and QoS
- Simplified operations - avoids O(n^2) VPN tunnel complexity
- Built-in encryption with automated key rotation
- Integrated security (firewall, IDS/IPS)

**Architecture Pattern**
```
                    SD-WAN Controller
                   /       |        \
                  /        |         \
  AWS Transit    Azure     GCP
  Gateway        VNet Hub  VPC
  + SD-WAN NVA   + SD-WAN  + SD-WAN
       |              |         |
  Spoke VPCs     Spoke VNets  Spoke VPCs
```

---

## Multi-Cloud DNS Strategies

### Split-Horizon DNS

Different DNS responses depending on where the query originates.

**Use Case**
- Internal clients resolve `api.example.com` to private IP addresses
- External clients resolve `api.example.com` to public IP addresses
- Each cloud resolves service names to local endpoints

**Implementation**
```
Cloud A (AWS):
  Route 53 Private Hosted Zone -> api.example.com -> 10.1.0.50 (local)

Cloud B (Azure):
  Azure Private DNS Zone -> api.example.com -> 10.2.0.50 (local)

Public DNS:
  Route 53 Public Zone -> api.example.com -> Load Balancer (public)
```

### DNS Forwarding

Forward DNS queries for specific domains to the appropriate cloud's DNS resolver.

**Architecture**
```
AWS VPC DNS Resolver (10.1.0.2)
  |-- Forward *.azure.internal -> Azure DNS (168.63.129.16 via VPN)
  |-- Forward *.gcp.internal -> GCP Cloud DNS (via VPN)

Azure DNS Private Resolver
  |-- Forward *.aws.internal -> AWS Route 53 Resolver (via VPN)

GCP Cloud DNS
  |-- Forwarding zone *.aws.internal -> AWS Route 53 Resolver (via VPN)
```

**AWS Route 53 Resolver**
- Inbound endpoints - allow on-premises/other clouds to query Route 53
- Outbound endpoints - forward queries from AWS to external DNS servers
- Resolver rules define which domains go where
- Docs: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html

**Azure DNS Private Resolver**
- Inbound endpoints accept queries from outside Azure
- Outbound endpoints forward queries to external DNS servers
- DNS forwarding rulesets define forwarding targets
- Docs: https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview

**GCP Cloud DNS**
- Forwarding zones send queries to external name servers
- DNS peering allows cross-project DNS resolution
- DNS policies control inbound/outbound resolution behavior
- Docs: https://cloud.google.com/dns/docs/overview

### Global DNS Load Balancing

Use a single DNS provider for global traffic distribution across clouds.

**Options**
- Route 53 with health checks routing to endpoints in any cloud
- Cloudflare or NS1 as a cloud-neutral DNS provider
- Use latency-based or geolocation routing to steer traffic

---

## Service Mesh Across Clouds

### Istio Multi-Cluster

**Architecture Options**
1. **Primary-Remote** - one cluster has the Istio control plane, others connect to it
2. **Multi-Primary** - each cluster has its own control plane, they share a trust domain

**Setup Overview**
```
Cluster A (AWS EKS)          Cluster B (GCP GKE)
  Istio Control Plane  <-->   Istio Control Plane
  (istiod)                     (istiod)
       |                           |
  App Services              App Services
```

**Key Requirements**
- Shared root CA for mTLS across clusters
- Network connectivity between clusters (VPN or interconnect)
- Pod-to-pod reachability or east-west gateway for non-flat networks
- Shared trust domain for cross-cluster authentication

**Cross-Cluster Service Discovery**
- Istio discovers services across clusters automatically
- Traffic can be routed based on locality (prefer local, failover to remote)
- Use `ServiceEntry` for external services not in the mesh

**Docs:** https://istio.io/latest/docs/setup/install/multicluster/

### HashiCorp Consul Connect

**Multi-Cloud Architecture**
```
Consul Server Cluster (primary datacenter)
       |
  +----+----+
  |         |
AWS DC    GCP DC
(Consul   (Consul
 agents)   agents)
```

**Key Features**
- Service mesh with automatic mTLS between services
- Multi-datacenter federation with WAN gossip
- Intentions control which services can communicate
- Supports Kubernetes and VM workloads in the same mesh
- Cluster peering for connecting independent Consul clusters

**Docs:** https://developer.hashicorp.com/consul/docs/connect

---

## Consistent Network Security Policies

### Challenges

- Each cloud has different security group / firewall rule syntax
- Policy drift across clouds is common
- Auditing and compliance require unified visibility

### Approaches

**Infrastructure as Code**
- Define security policies in Terraform for all clouds
- Use modules per cloud that implement the same logical policy
- Store policies in version control and enforce via CI/CD

```hcl
# Example: Terraform module structure
modules/
  security-policy/
    aws/          # Security groups + NACLs
    azure/        # NSGs + ASGs
    gcp/          # Firewall rules
    variables.tf  # Common inputs (ports, CIDRs, tags)
```

**Third-Party Policy Engines**
- Open Policy Agent (OPA) / Rego - write policies once, enforce across clouds
- HashiCorp Sentinel - policy-as-code for Terraform Enterprise
- Prisma Cloud / Wiz - cloud security posture management across providers

**Zero Trust Network Access (ZTNA)**
- Do not rely on network perimeter for security
- Authenticate and authorize every request regardless of network location
- Use identity-based access (IAM, Workload Identity, Managed Identity)
- Microsegmentation at the application layer

### Firewall Rule Comparison

| Concept | AWS | Azure | GCP |
|---|---|---|---|
| Instance firewall | Security Group | NSG | Firewall Rule |
| Stateful | Yes | Yes | Yes |
| Subnet firewall | NACL | NSG (on subnet) | Firewall Rule (network-level) |
| Centralized | AWS Firewall Manager | Azure Firewall Policy | Hierarchical Firewall Policies |
| WAF | AWS WAF | Azure WAF | Cloud Armor |

---

## IP Address Management Across Clouds

### CIDR Planning

**Avoid overlapping IP ranges** - this is the most common multi-cloud networking mistake.

**Example Allocation**
```
10.0.0.0/8 - Private address space

AWS:
  10.1.0.0/16 - Production VPC
  10.2.0.0/16 - Staging VPC
  10.3.0.0/16 - Development VPC

Azure:
  10.11.0.0/16 - Production VNet
  10.12.0.0/16 - Staging VNet
  10.13.0.0/16 - Development VNet

GCP:
  10.21.0.0/16 - Production VPC
  10.22.0.0/16 - Staging VPC
  10.23.0.0/16 - Development VPC

On-premises:
  10.100.0.0/16 - Corporate network
```

### IPAM Tools

- **Cloud-native**: AWS IPAM, Azure IPAM (preview), GCP does not have a native IPAM service
- **Third-party**: Infoblox, NetBox, phpIPAM
- **Terraform**: Use data sources and variables to enforce CIDR allocation

### IPv6 Considerations

- All three major clouds support dual-stack (IPv4 + IPv6)
- GCP VPCs support IPv6 natively
- AWS VPCs can be configured for dual-stack
- Azure VNets support dual-stack
- Consider IPv6 for new deployments to avoid address exhaustion

### NAT and Private Connectivity

- Use private IP addresses whenever possible across cloud boundaries
- NAT increases complexity and breaks some protocols
- Private endpoints/Private Link in each cloud keep traffic off the public internet
- For overlapping CIDRs (legacy), use NAT or a proxy layer

---

## Additional Resources

- [AWS Multi-Cloud Networking](https://docs.aws.amazon.com/whitepapers/latest/hybrid-connectivity/hybrid-connectivity.html)
- [Azure Multi-Cloud Design](https://learn.microsoft.com/en-us/azure/architecture/guide/multi-cloud/overview)
- [GCP Multi-Cloud Networking](https://cloud.google.com/network-connectivity/docs/how-to/choose-product)
- [Istio Multi-Cluster Installation](https://istio.io/latest/docs/setup/install/multicluster/)
- [HashiCorp Consul Multi-Datacenter](https://developer.hashicorp.com/consul/docs/architecture)
