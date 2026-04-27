# 02 - Hybrid Connectivity (VPN, ExpressRoute, Virtual WAN)

## Site-to-Site VPN

IPsec/IKE tunnel between on-prem (VPN device) and Azure VPN Gateway over the public internet. Encrypted, but bandwidth limited and dependent on internet quality.

### VPN Gateway SKUs

| SKU | Throughput | S2S tunnels | P2S | BGP | Active-Active | Zone redundant |
|---|---|---|---|---|---|---|
| VpnGw1 | 650 Mbps | 30 | 250 | Yes | Yes | No |
| VpnGw2 | 1 Gbps | 30 | 500 | Yes | Yes | No |
| VpnGw3 | 1.25 Gbps | 30 | 1000 | Yes | Yes | No |
| VpnGw1AZ | 650 Mbps | 30 | 250 | Yes | Yes | Yes |
| VpnGw2AZ | 1 Gbps | 30 | 500 | Yes | Yes | Yes |

`AZ` SKUs are zone-redundant (deployed across availability zones). The non-AZ Basic SKU exists but is for dev/test only (limited throughput, no SLA).

### Required subnet

Must be named **GatewaySubnet** (case-sensitive). Recommend `/27` minimum (`/26` to allow growth, including ExpressRoute coexistence).

### Active-active configuration

Two instances of the VPN Gateway, each with its own public IP. On-prem firewall configures two tunnels (one to each Azure public IP). HA out of the box.

### BGP

Recommended over static routing for non-trivial configs. Azure VPN Gateway default ASN is 65515 (configurable). On-prem device uses your private ASN (64512-65534 or 4200000000-4294967294 for 4-byte).

---

## Point-to-Site (P2S) VPN

Individual users (laptops) connect to Azure VNet via the VPN Gateway.

### Auth methods

- **Azure certificate** (root cert + client certs)
- **Azure AD authentication** (with OpenVPN protocol; modern, recommended)
- **RADIUS** (for legacy auth servers)

### Protocols

- **OpenVPN** - cross-platform, supports Azure AD auth
- **IKEv2** - cross-platform, certificate auth
- **SSTP** - Windows-only, used for legacy

Choose OpenVPN + Azure AD for new deployments.

---

## ExpressRoute

Private circuit between on-prem and Microsoft via a connectivity provider. Doesn't traverse public internet.

### Tiers

50 Mbps to 100 Gbps. Choose based on workload size and growth plans.

### Peerings

- **Private peering** - your VNets (most common). Connect via ExpressRoute Gateway in your VNet.
- **Microsoft peering** - Microsoft public services (Office 365, Dynamics 365, public Azure endpoints) over the ER circuit instead of internet.

### Connectivity models

- **Cloud Exchange Co-location** - your circuit terminates in a colocation facility with both on-prem and ER PoP
- **Point-to-point Ethernet** - dedicated Ethernet from on-prem to ER PoP via your provider
- **Any-to-any (IPVPN)** - your provider's MPLS network includes Azure

### ExpressRoute Direct

Dedicated 100 Gbps capacity directly to Microsoft's edge. For very large deployments. Requires meeting Microsoft at a peering location.

### ExpressRoute Global Reach

Connect on-prem-to-on-prem via Microsoft's backbone using two ExpressRoute circuits. Useful for branch interconnect.

### FastPath

Bypass the ExpressRoute Gateway data path (after initial setup). Reduces latency. Required SKU and limitations apply.

### Coexistence with VPN

Common pattern: ExpressRoute primary, VPN failover. Both can connect to the same VNet. UDRs / BGP determine path priority.

---

## Virtual WAN

Microsoft-managed hub-spoke at scale. Azure manages the **virtual hubs** in regions; you peer your VNets and connect on-prem.

### Components

- **Virtual WAN** (top-level resource)
- **Virtual hubs** (one per region) - automatically meshed via Microsoft backbone
- **Hub VNet connections** - your spoke VNets connect to a hub
- **VPN sites** - on-prem locations with VPN connectivity to hubs
- **ExpressRoute connections** - circuits to hubs
- **Azure Firewall** in the hub
- **Azure Virtual WAN encrypted tunnels** between hubs

### Use cases

- Global enterprise with many branch offices
- Multi-region Azure deployments where each region needs an ER/VPN
- Replaces complex manual hub-spoke + UDR patterns

### Routing

Virtual WAN handles transitive routing automatically. Spoke-to-spoke, spoke-to-on-prem, on-prem-to-on-prem (via Microsoft backbone) all work without UDR plumbing. Optionally inject Azure Firewall into the path.

---

## Choosing between options

| Need | Choice |
|---|---|
| Small office, low bandwidth, cost-sensitive | Site-to-Site VPN |
| Predictable high bandwidth, low latency, no internet | ExpressRoute |
| HA on a budget | VPN active-active |
| HA, mission-critical | ExpressRoute + VPN failover |
| Many sites, complex topology | Virtual WAN |
| Individual users (work-from-home) | P2S VPN |
| On-prem-to-on-prem via Azure | ExpressRoute Global Reach |
| Direct 100 Gbps for hyperscale | ExpressRoute Direct |

---

## DNS in hybrid scenarios

### On-prem → Azure resource by name

- **Azure Private DNS resolver** - hosts a DNS resolver in your VNet that on-prem can query (forwarded from on-prem DNS)
- Or run DNS forwarders on VMs in Azure
- Required for resolving `privatelink.*` names from on-prem (e.g., for Private Endpoints)

### Azure → on-prem name

- Custom DNS on VNet pointing to on-prem DNS server (reachable via VPN/ER)
- Or use Azure DNS Private Resolver outbound endpoints to forward queries to on-prem

---

## Common exam triggers

- "Encrypted tunnel from on-prem to Azure over public internet" → Site-to-Site VPN
- "Private circuit, no internet, predictable bandwidth" → ExpressRoute
- "VPN Gateway active-active for HA" → 2 public IPs, 2 IKE tunnels
- "Connect 100 branch offices to Azure" → Virtual WAN
- "User VPN with Azure AD auth" → P2S OpenVPN with Azure AD
- "Resolve `privatelink.*` Azure names from on-prem" → Azure DNS Private Resolver + on-prem conditional forwarder
- "On-prem-to-on-prem via Azure" → ExpressRoute Global Reach
- "Coexist ER + VPN failover" → Both connect to same VNet; BGP / UDR for failover priority
