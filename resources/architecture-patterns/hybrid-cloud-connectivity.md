# Architecture Pattern - Hybrid Cloud Connectivity

## Overview

Hybrid cloud connectivity patterns enable organizations to extend their on-premises data centers into one or more cloud providers, creating a unified network that supports workload portability, data residency, and gradual migration. This guide covers connectivity options, security models, and architectural patterns across AWS, Azure, and Google Cloud.

---

## Pattern Description

### Problem
- Workloads need to span on-premises and cloud environments
- Sensitive data must remain on-premises while leveraging cloud services
- Applications require low-latency communication between on-prem and cloud
- Compliance requirements mandate specific data residency controls
- Migration to cloud needs to be gradual without disrupting existing operations

### Solution
Establish secure, reliable network connectivity between on-premises infrastructure and cloud environments using:
- Dedicated private connections (Direct Connect, ExpressRoute, Cloud Interconnect)
- VPN tunnels (IPSec, site-to-site, client VPN)
- DNS integration across environments
- Identity federation for seamless authentication
- Consistent network addressing and routing

---

## Connectivity Options

### Dedicated Private Connections

| Feature | AWS Direct Connect | Azure ExpressRoute | Google Cloud Interconnect |
|---------|-------------------|--------------------|---------------------------|
| Type | Dedicated / Hosted | Private / Microsoft peering | Dedicated / Partner |
| Bandwidth | 1 Gbps, 10 Gbps, 100 Gbps (dedicated) | 50 Mbps - 10 Gbps (per circuit) | 10 Gbps, 100 Gbps (dedicated) |
| Hosted/Partner | 50 Mbps - 10 Gbps | Partner (varies) | 50 Mbps - 50 Gbps (partner) |
| Redundancy | Dual connections recommended | Active-active circuits | 99.9% (1 metro), 99.99% (2 metros) |
| SLA | 99.9% (single), 99.99% (resiliency) | 99.95% (per circuit) | 99.9% (single), 99.99% (redundant) |
| Encryption | MACsec (100 Gbps), VPN over DX | MACsec, VPN over ER | MACsec, HA VPN over Interconnect |
| Locations | 130+ DX locations globally | 90+ peering locations globally | 150+ locations globally |
| Setup Time | 1-4 weeks (hosted), 4-12 weeks (dedicated) | 2-8 weeks | 1-4 weeks (partner), 4-12 weeks (dedicated) |
| Pricing | Per port-hour + per GB (data transfer out) | Per circuit + per GB (data transfer) | Per port + per VLAN + per GB |
| BGP Required | Yes | Yes | Yes |
| Jumbo Frames | Yes (9001 MTU) | Yes (varies by SKU) | Yes (1500 or 8896 MTU) |

### VPN Connections

| Feature | AWS Site-to-Site VPN | Azure VPN Gateway | Google Cloud VPN |
|---------|---------------------|-------------------|-------------------|
| Protocol | IPSec (IKEv1, IKEv2) | IPSec (IKEv2) | IPSec (IKEv2) |
| Throughput | Up to 1.25 Gbps per tunnel | Up to 10 Gbps (VpnGw5) | 3 Gbps per tunnel (HA VPN) |
| Tunnels | 2 per VPN connection | 2 per gateway | 4 per HA VPN gateway |
| High Availability | 2 tunnels across 2 AZs | Active-active mode | 99.99% SLA (HA VPN) |
| BGP Support | Yes | Yes | Yes (HA VPN) |
| Accelerated | Global Accelerator integration | N/A | N/A |
| Client VPN | AWS Client VPN (OpenVPN) | Azure VPN Client (point-to-site) | N/A (use third-party) |
| Pricing | Per VPN connection-hour + data transfer | Per gateway-hour + per tunnel | Per tunnel-hour + data transfer |
| Setup Time | Minutes to hours | Minutes to hours | Minutes to hours |

### Comparison - When to Use What

| Criterion | Dedicated Connection | VPN |
|-----------|---------------------|-----|
| Bandwidth Need | > 1 Gbps sustained | < 1 Gbps |
| Latency Sensitivity | Consistent low latency | Variable acceptable |
| Cost | High (monthly commit) | Low (pay per use) |
| Setup Time | Weeks to months | Minutes to hours |
| Encryption | Optional (MACsec or VPN overlay) | Always (IPSec) |
| Reliability | 99.99% (with redundancy) | 99.95% (HA VPN) |
| Use Case | Production workloads, data replication | Dev/test, backup, burst |

---

## Network Architecture Patterns

### Hub-and-Spoke

```
                    ┌──────────────┐
                    │  Transit Hub  │
                    │  (TGW/vWAN/  │
                    │   NCC)        │
                    └──────┬───────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
   ┌──────▼──────┐  ┌─────▼───────┐  ┌────▼────────┐
   │ Spoke VPC-1  │  │ Spoke VPC-2  │  │ On-Premises  │
   │ (Production) │  │ (Staging)    │  │ Data Center  │
   └─────────────┘  └──────────────┘  └─────────────┘
```

| Cloud | Hub Service | Spoke Connection |
|-------|-------------|------------------|
| AWS | Transit Gateway | TGW attachments (VPC, VPN, DX) |
| Azure | Virtual WAN / Hub VNet | VNet peering, VPN, ER |
| GCP | Network Connectivity Center | VPC peering, Interconnect, VPN |

### Multi-Cloud Transit

```
   On-Prem ─── DX ──── AWS Transit Gateway
      │                        │
      │── ExpressRoute ── Azure vWAN Hub
      │                        │
      └── Interconnect ── GCP NCC Hub
```

| Connection | Implementation |
|------------|----------------|
| On-prem to AWS | Direct Connect + Transit Gateway |
| On-prem to Azure | ExpressRoute + Virtual WAN |
| On-prem to GCP | Cloud Interconnect + NCC |
| AWS to Azure | VPN over internet / Megaport/Equinix |
| AWS to GCP | VPN over internet / Megaport/Equinix |
| Azure to GCP | VPN over internet / Megaport/Equinix |

---

## DNS in Hybrid Environments

### DNS Resolution Patterns

| Pattern | Description | Implementation |
|---------|-------------|----------------|
| Split-Horizon DNS | Same domain resolves differently on-prem vs cloud | Conditional forwarding |
| DNS Forwarding | Cloud DNS forwards to on-prem for private domains | Route 53 Resolver, Azure DNS Private Resolver, Cloud DNS forwarding |
| Centralized DNS | Single DNS authority for all environments | On-prem DNS with cloud forwarders |

### Cloud DNS Integration

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Private DNS | Route 53 Private Hosted Zones | Azure Private DNS Zones | Cloud DNS Private Zones |
| Hybrid Resolver | Route 53 Resolver (inbound/outbound endpoints) | Azure DNS Private Resolver | Cloud DNS forwarding zones |
| Conditional Forwarding | Route 53 Resolver rules | DNS Private Resolver (forwarding rulesets) | Cloud DNS forwarding zones |
| On-Prem Resolution | Outbound endpoint -> on-prem DNS | Forwarding ruleset -> on-prem DNS | Forwarding zone -> on-prem DNS |
| Cloud Resolution | Inbound endpoint (on-prem -> cloud) | Inbound endpoint (on-prem -> cloud) | DNS Server Policy (inbound) |

---

## Security in Hybrid Networks

### Network Security Layers

| Layer | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Edge Firewall | Network Firewall | Azure Firewall | Cloud Firewall |
| Network Segmentation | Security groups + NACLs | NSGs + ASGs | VPC firewall rules |
| Private Connectivity | PrivateLink | Private Link | Private Service Connect |
| Traffic Inspection | Network Firewall, Gateway LB | Azure Firewall, NVA | Cloud IDS, NVA |
| DDoS Protection | Shield Advanced | DDoS Protection | Cloud Armor |
| Encryption in Transit | VPN (IPSec), TLS, MACsec | VPN (IPSec), TLS, MACsec | VPN (IPSec), TLS, MACsec |

### Zero Trust in Hybrid

| Principle | Implementation |
|-----------|----------------|
| Never trust, always verify | mTLS between all services, identity-aware proxy |
| Least privilege access | Service accounts with minimal permissions |
| Micro-segmentation | Per-service firewall rules, service mesh |
| Continuous monitoring | Network flow logs, SIEM integration |
| Identity-based access | BeyondCorp (GCP), Azure AD Conditional Access, AWS Verified Access |

---

## Identity Federation

### Hybrid Identity Models

| Model | Description | Best For |
|-------|-------------|----------|
| Cloud-only | Identities managed entirely in cloud | Cloud-native organizations |
| Synced | On-prem directory synced to cloud | Extending existing AD |
| Federated | On-prem IdP authenticates, cloud trusts | Keeping auth on-prem |
| Hybrid | Combination of synced and federated | Large enterprises |

| Cloud | Sync Tool | Federation Protocol |
|-------|-----------|---------------------|
| AWS | IAM Identity Center + SCIM | SAML 2.0, OIDC |
| Azure | Entra Connect (hash sync, pass-through, federation) | SAML 2.0, WS-Fed, OIDC |
| GCP | Google Cloud Directory Sync (GCDS) | SAML 2.0, OIDC |

---

## Data Replication and Sync

### Hybrid Data Patterns

| Pattern | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Database Replication | RDS/Aurora with on-prem replica | Azure SQL with linked server | Cloud SQL with external replica |
| File Sync | Storage Gateway, DataSync | Azure File Sync, Data Box | Transfer Service |
| Object Storage | S3 Transfer Acceleration, DataSync | AzCopy, Data Box | gsutil, Transfer Service |
| Real-Time Streaming | Kinesis Agent -> Kinesis | IoT Hub / Event Hubs | Pub/Sub |
| Backup | Backup (to S3/Glacier) | Backup (to Recovery Vault) | Backup and DR |
| CDC | DMS (continuous replication) | Data Factory CDC | Datastream |

---

## Monitoring Hybrid Environments

### Unified Observability

| Aspect | AWS | Azure | GCP |
|--------|-----|-------|-----|
| Hybrid Monitoring | CloudWatch Agent (on-prem) | Azure Monitor Agent (Arc-enabled) | Ops Agent (on-prem) |
| Network Monitoring | CloudWatch Network Monitor | Network Watcher Connection Monitor | Network Intelligence Center |
| VPN Monitoring | VPN CloudWatch metrics | VPN Gateway diagnostics | VPN tunnel metrics |
| Flow Logs | VPC Flow Logs | NSG Flow Logs | VPC Flow Logs |
| Centralized Logging | CloudWatch Logs | Log Analytics workspace | Cloud Logging |

---

## Cost Optimization

### Hybrid Connectivity Costs

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| Private Connection Port | $0.30/hr (1 Gbps) | ~$290/month (1 Gbps) | $0.0014/hr/10 Gbps |
| Data Transfer Out (private) | $0.02/GB | $0.025/GB (metered) | $0.02/GB |
| Data Transfer Out (VPN) | $0.09/GB | $0.087/GB | $0.08/GB |
| VPN Gateway | $0.05/hr | $0.19/hr (VpnGw1) | $0.075/hr (HA VPN) |
| NAT Gateway | $0.045/hr + $0.045/GB | $0.045/hr + $0.045/GB | $0.044/hr + $0.045/GB |

### Cost Reduction Strategies

| Strategy | Description |
|----------|-------------|
| Compress data | Reduce data transfer volume |
| Cache at edge | CDN for frequently accessed content |
| Use private connections | Lower per-GB cost vs internet |
| Optimize routing | Minimize cross-region traffic |
| Data processing at source | Process data before transferring |
| Reserved capacity | Commit to bandwidth for discounts |

---

## Certification Exam Focus Areas

### AWS
- Direct Connect LAG, virtual interfaces (private, public, transit)
- Transit Gateway route tables and multi-account connectivity
- Route 53 Resolver for hybrid DNS
- AWS Storage Gateway modes (file, volume, tape)
- VPN over Direct Connect for encryption

### Azure
- ExpressRoute Global Reach for site-to-site via Microsoft backbone
- Virtual WAN architecture and hub routing
- Azure Arc for hybrid management (servers, Kubernetes, data)
- Azure DNS Private Resolver architecture
- ExpressRoute FastPath for high-performance scenarios

### Google Cloud
- Cloud Interconnect VLAN attachments and partner provisioning
- Network Connectivity Center for multi-cloud hub
- Cloud Router and BGP best practices
- Cloud VPN HA for 99.99% availability
- Hybrid DNS with Cloud DNS forwarding zones

---

## Documentation Links

- AWS Direct Connect: https://docs.aws.amazon.com/directconnect/latest/UserGuide/
- AWS Transit Gateway: https://docs.aws.amazon.com/vpc/latest/tgw/
- AWS Site-to-Site VPN: https://docs.aws.amazon.com/vpn/latest/s2svpn/
- Azure ExpressRoute: https://learn.microsoft.com/en-us/azure/expressroute/
- Azure Virtual WAN: https://learn.microsoft.com/en-us/azure/virtual-wan/
- Azure VPN Gateway: https://learn.microsoft.com/en-us/azure/vpn-gateway/
- Google Cloud Interconnect: https://cloud.google.com/network-connectivity/docs/interconnect
- Google Cloud VPN: https://cloud.google.com/network-connectivity/docs/vpn
- Google Network Connectivity Center: https://cloud.google.com/network-connectivity/docs/network-connectivity-center

---

## Key Takeaways

1. Dedicated connections (Direct Connect, ExpressRoute, Interconnect) are essential for production hybrid workloads
2. Always design for redundancy - dual connections across diverse paths
3. VPN provides a quick, encrypted fallback - use it alongside dedicated connections
4. Hybrid DNS is often the most complex part - plan it early in the architecture
5. Data transfer costs can be significant - optimize egress and use private connections
6. Identity federation is critical - avoid separate credentials for on-prem and cloud
7. Monitoring must span both environments with a unified view
8. Consider third-party SD-WAN solutions (Megaport, Equinix Fabric) for multi-cloud connectivity
