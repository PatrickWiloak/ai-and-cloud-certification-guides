# 01 - VNets, Subnets, NSGs, ASGs, Peering

## Virtual Network (VNet)

A VNet is a region-scoped private network. Properties:

- One or more **address spaces** (CIDR ranges, e.g., 10.0.0.0/16 + 10.1.0.0/16)
- Address spaces don't overlap with on-prem or other VNets you'll peer with
- DNS configuration (Azure default or custom)
- Subnets within

Plan address spaces carefully: changes are disruptive. Reserve large blocks for future VNets and on-prem.

---

## Subnets

A subnet is an address range within a VNet. Properties:

- Must be `>=/29` (8 addresses, 3 reserved)
- Can have an attached NSG
- Can have an attached route table
- Can have **service endpoints** for Azure services
- Can be **delegated** to a specific PaaS service (App Service VNet Integration, Container Apps, ADO Self-Hosted Agents, etc.)

### Reserved IPs in a subnet

Azure reserves 5 addresses per subnet:

- `.0` - network address
- `.1` - default gateway (Azure managed)
- `.2`, `.3` - Azure DNS mapping
- `.255` - broadcast (or last in range for non-/24)

So a /24 has 251 usable addresses, /29 has 3, etc.

### Required subnet names for special services

- **GatewaySubnet** (`/27` or larger) - for VPN Gateway / ExpressRoute Gateway
- **AzureFirewallSubnet** (`/26`) - for Azure Firewall
- **AzureFirewallManagementSubnet** (`/26`) - for Azure Firewall management when forced tunneling
- **AzureBastionSubnet** (`/26`) - for Azure Bastion
- **RouteServerSubnet** (`/27`) - for Azure Route Server

These names are mandatory; misname them and the service won't deploy.

---

## Network Security Groups (NSG)

Stateful firewall. Apply at:

- **NIC level** - per VM, granular
- **Subnet level** - across all NICs in subnet

### Rule processing

- Numbered priorities (100-4096), lower = higher priority
- First match wins
- Default rules at bottom (priority 65000+):
  - Allow VNet-internal traffic
  - Allow Azure load balancer probes
  - Deny all internet inbound
  - Allow all outbound

### Rule fields

| Field | Examples |
|---|---|
| Source | IP CIDR, ServiceTag (e.g., `Internet`, `VirtualNetwork`, `AzureLoadBalancer`), ASG |
| Source port | Specific or `*` |
| Destination | IP CIDR, ServiceTag, ASG |
| Destination port | Specific or `*` |
| Protocol | TCP, UDP, ICMP, * |
| Action | Allow, Deny |

### NSG flow logs

- Capture logs to Storage Account
- Process via **Traffic Analytics** for top-talkers / patterns / threats
- Critical for forensics and least-privilege tuning

---

## Application Security Groups (ASG)

A logical tag for VMs/NICs. Use in NSG rules instead of IP lists.

```
ASG: web-tier
ASG: app-tier
ASG: db-tier

NSG rule: allow TCP 1433 from app-tier ASG to db-tier ASG
```

When you add a new app server, just tag it with `app-tier` ASG; no NSG rule changes needed. Critical for managing rules at scale.

---

## VNet peering

Connect two VNets at the Azure backbone. Low-latency, encrypted automatically.

### Settings

- **Allow virtual network access** - default yes; lets resources in peered VNet reach each other
- **Allow forwarded traffic** - permit traffic that didn't originate in the peered VNet (e.g., transiting through it)
- **Allow gateway transit** - share VPN/ExpressRoute gateway with the peer
- **Use remote gateway** - the peer is using your gateway

### Hub-spoke pattern

Hub VNet has the gateway. Spokes:

- Peer to hub
- `Use remote gateway` = true (use hub's gateway for on-prem)

Hub:

- `Allow gateway transit` = true (let spokes use my gateway)
- `Allow forwarded traffic` = true (so spoke-to-spoke traffic transits)

### Non-transitivity

Peering is **not transitive**. A peered to B and B peered to C does NOT mean A reaches C. Workarounds:

- **Route table** on A pointing to a firewall in B that forwards to C
- **Mesh peering** (peer A↔C directly) - doesn't scale
- **Azure Virtual WAN** (Microsoft-managed transitive hub-spoke)
- **Network Virtual Appliance** in B doing routing

### Cross-region

**Global VNet Peering** - same as VNet peering but across regions. Higher cost.

---

## Service tags

Symbolic names for Azure service IP ranges. Use in NSG rules instead of IP lists:

- `Internet` - all public IPs
- `VirtualNetwork` - all addresses in VNet + connected on-prem (via gateway)
- `AzureLoadBalancer` - LB probe source
- `AzureCloud` - all Azure datacenter ranges
- `Storage`, `Sql`, `KeyVault`, `AzureMonitor` - specific services
- Regional variants: `Storage.WestUS`, `Sql.EastUS`

Microsoft maintains the IP list; rules update automatically.

---

## Common patterns

### Multi-tier app subnet design

```
VNet 10.0.0.0/16
├─ web subnet 10.0.1.0/24       (NSG: allow 443 from Internet, allow VNet)
├─ app subnet 10.0.2.0/24       (NSG: allow 8080 from web ASG)
├─ db subnet 10.0.3.0/24        (NSG: allow 1433 from app ASG)
└─ shared subnet 10.0.99.0/24   (Bastion, Storage PE, etc.)
```

### Hub-spoke with shared services

```
Hub 10.0.0.0/16
├─ GatewaySubnet 10.0.0.0/27
├─ AzureFirewallSubnet 10.0.1.0/26
└─ shared subnet 10.0.10.0/24    (Active Directory, monitoring)

Spokes:
- 10.10.0.0/16 (app1)
- 10.20.0.0/16 (app2)

Each spoke peered to hub with use-remote-gateway = true
Each spoke has UDR forcing 0.0.0.0/0 → Azure Firewall in hub
```

---

## Common exam triggers

- "Spoke-to-spoke traffic must transit the firewall" → UDR on spokes pointing to firewall IP; allow forwarded traffic on hub peering
- "Multiple VMs need same set of NSG rules without IP lists" → ASG
- "VPN Gateway must connect from a small subnet" → GatewaySubnet must be `/27` minimum
- "Apply NSG to all VMs in a tier without per-NIC config" → NSG on subnet
- "Block all Internet outbound from a subnet" → NSG rule deny TCP/UDP * to ServiceTag `Internet`
- "Allow only my company's IP range to RDP" → NSG rule allow TCP 3389 from <my-CIDR> to subnet
