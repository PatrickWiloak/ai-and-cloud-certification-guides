# 04 - Routing, Azure Firewall, NVAs

## System routes

Every subnet has automatic system routes for:

- VNet local (CIDR of the VNet)
- Default to internet (0.0.0.0/0)
- Default to gateway (if VNet has VPN/ExpressRoute Gateway)
- Special tags: VirtualNetworkServiceEndpoint, VirtualNetworkPeering, etc.

You see the effective routes via `Effective routes` on a NIC.

---

## User-Defined Routes (UDR)

Override system routes with custom **route tables** attached to subnets.

### Route table structure

```
Address prefix     Next hop type             Next hop
0.0.0.0/0          Virtual Appliance         10.0.0.4   (Azure Firewall)
10.20.0.0/16       Virtual Network          (system)    (peered spoke)
192.168.0.0/16     Virtual Network Gateway  (system)    (on-prem via VPN)
```

### Next-hop types

- **Virtual Appliance** - send to a VM IP (firewall NVA)
- **Virtual Network Gateway** - send to VPN/ER Gateway
- **Internet** - direct internet
- **Virtual Network** - VNet-local
- **None** - drop traffic

### Forced tunneling

Pattern: UDR `0.0.0.0/0 → next hop firewall` to send all internet traffic through your firewall (Azure Firewall or NVA). Standard hub-spoke approach.

```
On-prem ←── VPN ──→ Hub (Azure Firewall) ←── peering ──→ Spoke
                       ▲
                       │ default route in spoke UDR forces all 0.0.0.0/0 here
                       │
                    Internet
```

---

## Border Gateway Protocol (BGP)

Used by VPN Gateway and ExpressRoute for dynamic route exchange.

### Concepts

- **Autonomous System Number (ASN)** - identifier for a BGP routing domain
- Azure VPN Gateway default ASN: **65515**
- Customer ASN: typically a private ASN (64512-65534)
- BGP advertises routes between Azure and on-prem

### Advantages over static routes

- Failover automatic: if a BGP neighbor goes down, alternative routes propagate
- Adding a subnet on either side propagates without manual route table edits

### Common scenarios

- Active-active VPN Gateway with BGP for dynamic failover
- ExpressRoute private peering uses BGP
- Coexistence of ExpressRoute + VPN: BGP attributes (AS path length, MED, local pref) determine path priority

---

## Azure Route Server

A managed BGP service in your VNet. Lets NVAs and BGP-capable on-prem peers exchange routes with VNet route tables dynamically.

### Use case

Running an NVA (e.g., Cisco CSR, Palo Alto) that wants to advertise routes back into your VNet without manual UDR maintenance.

### Required subnet

`RouteServerSubnet` (`/27` or larger).

---

## Azure Firewall

Microsoft-managed L4-L7 firewall. Stateful, integrated with Azure ecosystem.

### SKUs

| SKU | Features |
|---|---|
| **Basic** | L3-L4 rules, NAT, threat intel basic; for SMB/dev |
| **Standard** | L3-L7 (FQDN-based application rules), threat intel, full DNAT/SNAT |
| **Premium** | All Standard features + TLS inspection, IDPS (intrusion detection/prevention), URL filtering, web categories |

### Rule types

- **Network rules** - L3/L4 (source, dest, port, protocol)
- **Application rules** - L7, FQDN-based (e.g., allow `*.microsoft.com`)
- **NAT rules** - DNAT for inbound (publish a port to internal IP)

### Rule processing order

Network rules → Application rules. First match wins within each. If no match, deny by default.

### Firewall Policy

Modern way to manage rules (vs classic Rule Collections). Hierarchy: parent policy → child policy with overrides. Centralize firewall config across multiple Azure Firewalls.

### Required subnet

`AzureFirewallSubnet` (`/26` or larger).

### Forced tunneling

Configure outbound traffic from Azure Firewall to go through on-prem (instead of direct internet). Requires `AzureFirewallManagementSubnet` for management plane.

### High availability

Azure Firewall is multi-AZ by default in Standard/Premium SKUs in supported regions.

### DNS Proxy

Azure Firewall can act as DNS proxy for VNet, enabling FQDN rules to work consistently.

---

## Network Virtual Appliances (NVA)

Third-party firewalls/SD-WAN/etc. as VMs. Common: Palo Alto, Fortinet, Cisco, Check Point, F5.

### Use NVA when

- Specific vendor compliance / familiarity
- Features Azure Firewall doesn't have (deep IPS signatures, advanced URL filtering, vendor-specific apps)
- Existing on-prem deployment using same vendor; consistency

### HA pattern

- Active-active or active-passive VM pair
- Standard Load Balancer in front for HA
- UDR pointing to LB frontend IP (not individual NVA IP)

### Cost

NVAs cost more (VM compute + license) and require expertise to operate. Azure Firewall is fully managed.

---

## Common topology examples

### Hub-spoke with Azure Firewall

```
Spoke VNet 10.10.0.0/16
└─ subnet 10.10.1.0/24
   ├─ NSG: granular VM rules
   └─ Route Table: 0.0.0.0/0 → 10.0.1.4 (Azure Firewall in hub)

Hub VNet 10.0.0.0/16
├─ AzureFirewallSubnet 10.0.1.0/26  (Azure Firewall: 10.0.1.4)
├─ GatewaySubnet 10.0.0.0/27         (VPN Gateway / ER Gateway)
└─ shared subnet 10.0.10.0/24

Peering:
  spoke ↔ hub (allow forwarded traffic, use remote gateway on spoke side)
```

### Multi-region with Virtual WAN

Microsoft-managed transitive routing. Less manual UDR; just connect VNets to hub.

---

## Common exam triggers

- "Force all spoke internet traffic through hub firewall" → UDR on spoke `0.0.0.0/0 → next hop firewall NVA/IP`
- "FQDN-based outbound rules (allow only `*.microsoft.com`)" → Azure Firewall application rules
- "TLS inspection on outbound HTTPS" → Azure Firewall **Premium**
- "Centralize firewall rules across multiple instances" → Firewall Policy (hierarchical)
- "BGP dynamic routing for VPN active-active" → Configure BGP on VPN Gateway + on-prem device
- "NVA active-active for HA" → Standard LB in front of NVA pair, UDR points to LB frontend
- "Inspect spoke-to-spoke traffic" → UDR on each spoke pointing to firewall in hub
- "Publish RDP port 3389 from a public IP to specific VM" → Azure Firewall DNAT rule (or LB inbound NAT rule)
- "Detect known-bad IP traffic" → Azure Firewall threat intelligence (alert mode or alert+deny)
