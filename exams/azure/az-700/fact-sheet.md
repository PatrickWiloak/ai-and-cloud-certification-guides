# AZ-700 Azure Network Engineer Associate - Fact Sheet

## Quick Reference

**Exam Code:** AZ-700
**Duration:** 100 minutes
**Cost:** $165 USD
**Passing Score:** 700/1000

**[📖 Official AZ-700 page](https://learn.microsoft.com/credentials/certifications/azure-network-engineer-associate/)**
**[📖 Skills Measured](https://learn.microsoft.com/credentials/certifications/exams/az-700/)**
**[📖 Azure Networking Documentation](https://learn.microsoft.com/azure/networking/)**

---

## Domain weights

| Domain | Weight |
|---|---|
| Design and implement private access to Azure services | 15-20% |
| Secure and monitor networks | 15-20% |
| Design and implement routing | 25-30% |
| Design and implement core networking infrastructure | 20-25% |
| Design, implement, manage hybrid networking | 10-15% |

---

## Core building blocks

### Virtual Networks (VNet)

- Region-scoped private network in Azure
- Has one or more **address spaces** (CIDR blocks)
- **Subnets** carve up the address space
- Reserved IPs in each subnet: first 4 + last 1 (5 reserved)

### Subnets

- Address range from VNet's space
- Can have **NSG** attached
- Can have **route table** attached
- Can have **service endpoints** or **private endpoints** for Azure services
- **Delegated subnets** for specific PaaS services (e.g., App Service VNet Integration, Container Apps)

### Network Security Groups (NSG)

- Stateful firewall rules
- Apply at NIC level or subnet level (or both - rules combine)
- Default rules (low priority): allow VNet, allow LB probe, deny internet inbound
- **Application Security Groups (ASG)** - tag VMs to use as a logical group in NSG rules, simpler than maintaining IP lists

### NSG flow logs

- Capture flow logs to Azure Storage
- Process with **Traffic Analytics** (NSG flow logs + ML for usage insights)

---

## VNet peering

Connect VNets at the Azure backbone (not over public internet).

### Properties

- **Non-transitive** - if A peered to B and B peered to C, A does NOT see C
- **Cross-region peering** = Global VNet Peering (extra cost)
- **Same-region peering** = VNet Peering (cheaper)
- **Allow gateway transit** - one peer can use the other's VPN/ExpressRoute gateway
- **Use remote gateway** - hub-spoke pattern

### Hub-spoke topology

- **Hub VNet** has VPN/ExpressRoute Gateway, Azure Firewall, shared services
- **Spoke VNets** peer to hub; spokes don't peer to each other
- Spoke-to-spoke traffic transits the hub firewall (if route tables are configured)
- Use **Azure Virtual WAN** for managed hub-spoke at scale

---

## Hybrid connectivity

### VPN Gateway

- Site-to-site IPsec VPN between on-prem and Azure VNet
- SKUs: VpnGw1/2/3/4/5 (with `AZ` suffix for zone-redundant)
- BGP-capable
- Gateway lives in a dedicated **GatewaySubnet** (`/27` recommended)
- Active-active configuration for HA

### ExpressRoute

- Private circuit between on-prem and Azure (no internet)
- Tiers: 50 Mbps to 100 Gbps
- Two **peerings**: Private (to VNets) and Microsoft (to Microsoft 365, public Azure services with private routing)
- Connect via **ExpressRoute Gateway** in your VNet
- **ExpressRoute Direct** - dedicated 100 Gbps capacity
- **ExpressRoute Global Reach** - connect on-prem-to-on-prem via Microsoft backbone
- Can coexist with VPN as failover

### Virtual WAN

- Microsoft-managed hub-spoke at scale
- Hubs in multiple regions, automatically meshed
- Supports VPN, ExpressRoute, point-to-site, Azure Firewall in the hub
- Best for large enterprise networks

### Point-to-site VPN

- Individual user devices VPN into Azure
- Auth: certificate, Azure AD, RADIUS
- OpenVPN or IKEv2

---

## Load balancing options

| Option | Layer | Scope | Use case |
|---|---|---|---|
| **Azure Load Balancer (Standard)** | Layer 4 (TCP/UDP) | Regional | High-perf TCP/UDP, internal or public |
| **Application Gateway** | Layer 7 (HTTP/S) | Regional | Web apps, WAF, path-based routing |
| **Azure Front Door** | Layer 7 | Global | Global HTTP/S edge, CDN, WAF, multi-region failover |
| **Traffic Manager** | DNS | Global | DNS-based routing across regions/endpoints |
| **Azure Cross-region Load Balancer** | Layer 4 | Global | Layer 4 across regions |

### Application Gateway features

- WAF (OWASP rules, custom rules)
- Path-based routing (e.g., /api/* to backend pool A, /web/* to pool B)
- Multi-site hosting (multiple domains on one App Gateway)
- SSL termination + end-to-end TLS
- **Application Gateway for Containers** (preview) - replaces Application Gateway Ingress Controller

### Front Door features

- Anycast on Microsoft's global edge network
- WAF
- CDN
- Origin failover
- Custom domains + managed certs
- URL rewrite/redirect

### Traffic Manager routing methods

- **Performance** - lowest latency from client
- **Weighted** - traffic split percentages
- **Priority** - active/passive failover
- **Geographic** - by client geo-IP
- **Multivalue** - return multiple healthy endpoints
- **Subnet** - by client IP/subnet

---

## Routing

### System routes

Built-in routes for VNet local, internet, on-prem (via gateway).

### User-defined routes (UDR)

Override system routes. Common pattern: **force-tunnel through a hub firewall or NVA**:

```
Address prefix: 0.0.0.0/0
Next hop type: Virtual Appliance
Next hop IP: 10.0.0.4 (firewall NVA)
```

Route tables apply to **subnets**.

### BGP

VPN Gateway and ExpressRoute support BGP for dynamic route exchange. ASNs for Azure VPN Gateway start at 65515 (default) or are configurable.

### Route filtering

For ExpressRoute Microsoft peering, **route filters** limit which Microsoft prefixes are advertised (e.g., only advertise Office 365 routes).

---

## Azure Firewall

- Managed L4-L7 firewall
- **Standard** (basic), **Premium** (TLS inspection, IDPS, URL filtering, web categories)
- **Firewall Policy** is the modern way to manage rules (vs classic rule collections)
- DNAT, network rules, application rules
- Threat intelligence-based filtering (block known-malicious IPs)
- Forced tunneling through Azure Firewall in hub VNet is canonical hub-spoke pattern

### Network Virtual Appliances (NVA)

Third-party firewalls / WAFs / SD-WAN appliances deployed as VMs (Palo Alto, Fortinet, Cisco). Use when:

- Specific vendor compliance / familiarity
- Features not in Azure Firewall

---

## Private connectivity

### Service Endpoints

- VNet → specific Azure service via Microsoft backbone (not internet)
- The service is still publicly reachable; service endpoint is just a fast path
- Cheaper than Private Endpoint
- Per-subnet enabled (Microsoft.Storage, Microsoft.Sql, etc.)

### Private Endpoints / Private Link

- Private IP from your VNet for an Azure PaaS service
- **Service is no longer reachable via public IP** (when you disable public access)
- Most common pattern for prod: Storage, SQL DB, Cosmos DB, Key Vault, etc.
- Requires DNS configuration: Private DNS zone for `privatelink.<service>.<region>.<azure>.com`

### Comparison

| Feature | Service Endpoint | Private Endpoint |
|---|---|---|
| Private IP for service | No (still public) | Yes |
| Service publicly reachable | Yes | Configurable (disable public) |
| Cost | No data charge | Per-PE hourly + data |
| Granularity | Service-wide | Per-instance |
| DNS | No special DNS | Requires private DNS zone |

**Default to Private Endpoint for prod**; Service Endpoint for less-sensitive cases or cost optimization.

---

## DNS

### Azure DNS

Public DNS zones (your domain) hosted in Azure.

### Private DNS Zones

Resolve internal-only names within VNets. Required for Private Endpoint name resolution:

- `privatelink.blob.core.windows.net`
- `privatelink.database.windows.net`
- etc.

Link the private DNS zone to your VNet to make those names resolvable.

### Conditional forwarding

Hybrid scenario: on-prem DNS forwards `azure.example.com` to Azure-resident DNS (often via VPN).

---

## Monitoring

### Network Watcher

- **Connection Monitor** - continuous tests between source and destination
- **Connection Troubleshoot** - one-shot connectivity test
- **NSG Flow Logs** - flow logs from NSGs
- **NSG Diagnostics** - which NSG rules apply
- **Topology** - visualize VNet relationships
- **VPN Diagnostics** - VPN Gateway logs
- **Packet Capture** - on-demand pcap

### Azure Monitor

- **Network Insights** - top-level networking dashboards
- **Diagnostic settings** on networking resources (VNet, VPN Gateway, Front Door, etc.) → Log Analytics

### Traffic Analytics

Adds context to NSG flow logs: top talkers, app patterns, security flagged events.

---

## Common patterns

### Hub-spoke

```
On-prem ──VPN/ER──┐
                  │
        ┌─────────▼──────────┐
        │   Hub VNet          │
        │   - Azure Firewall  │
        │   - Shared services │
        └────┬────────────────┘
             │ peering (allow gateway transit, force tunnel via FW)
   ┌─────────┴─────────────────┐
   │                           │
┌──▼──────┐               ┌────▼─────┐
│ Spoke A │               │ Spoke B  │
│ apps    │               │ data     │
└─────────┘               └──────────┘
```

### Multi-region active-active

- Front Door at the edge
- App Gateway in each region
- Apps in each region
- Cross-region replication for state (Cosmos DB Global Tables, geo-redundant Storage, SQL DB Active Geo-Replication)

### Private-only PaaS

- Disable public access on Storage / SQL DB / Cosmos DB
- Add Private Endpoints in each VNet
- DNS zone linked to VNets for resolution
- Inbound from on-prem via VPN/ER + Private Endpoints

---

## Highest-yield facts

1. **VNet peering is non-transitive.** A→B→C does NOT mean A can reach C.
2. **NSG = stateful, ASG = logical group of NICs/VMs.** Use ASGs to avoid IP-list management.
3. **GatewaySubnet must be `/27` or larger** for VPN Gateway / ExpressRoute Gateway.
4. **AzureFirewallSubnet must be `/26`.**
5. **Service Endpoint = service stays public, fast path.** Private Endpoint = private IP, can disable public.
6. **Hub-spoke with Azure Firewall in hub** is the canonical enterprise topology.
7. **App Gateway is regional**, **Front Door is global**.
8. **WAF available on App Gateway and Front Door**, not on Azure Load Balancer.
9. **Cross-region VNet peering = Global VNet Peering**, costs more.
10. **VPN Gateway active-active** uses two public IPs; required for HA.
11. **ExpressRoute private peering** = your VNets; **Microsoft peering** = Microsoft public services.
12. **Traffic Manager is DNS-based**, **Front Door is HTTP-proxy-based** - different OSI layers.
13. **Azure Firewall Premium** adds TLS inspection, IDPS, URL filtering vs Standard.
14. **Force tunneling**: UDR `0.0.0.0/0 → next hop firewall NVA` pulls all internet-bound traffic through the firewall.
15. **Network Watcher is regional** - enable in each region you operate.

---

## Common exam triggers

- "Many spokes need to share VPN/ER through hub" → Hub-spoke with `useRemoteGateway` on spokes, `allowGatewayTransit` on hub
- "Spoke-to-spoke traffic must be inspected" → UDR on spokes routing inter-spoke traffic via Azure Firewall in hub
- "Disable public access to Storage / SQL DB" → Private Endpoint + private DNS zone + disable public network access
- "Web app must be globally accessible with WAF" → Front Door (global)
- "Internal HTTPS app with WAF, regional" → Application Gateway
- "TCP load balancing across multi-region" → Cross-region Load Balancer or Traffic Manager (DNS)
- "On-prem DNS must resolve `privatelink.*` Azure names" → Conditional forwarder on-prem → DNS resolver in Azure
- "Bandwidth between on-prem and Azure must be private" → ExpressRoute (not VPN over internet)
- "Failover between primary and secondary region" → Traffic Manager Priority routing or Front Door with origin priorities
