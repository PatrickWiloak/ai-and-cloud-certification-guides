---
last-updated: 2026-05-03
---

# Azure Network Engineer Associate (AZ-700) - Exam Strategy

## Format reminder

- 40-60 questions, 100 minutes
- Pass mark: 700 / 1000 (70%)
- Multiple choice + multiple response + drag-and-drop + occasional case studies
- AZ-104 is the practical prerequisite

## Top traps

1. **VNet peering vs Virtual WAN vs ExpressRoute Global Reach**:
   - VNet peering: any-to-any in Azure regions, non-transitive
   - Virtual WAN: managed transit hub for global multi-region with peering, VPN, ExpressRoute
   - ExpressRoute Global Reach: connects on-prem locations to each other via ExpressRoute circuits
   Each has a distinct purpose; AZ-700 tests the boundaries.

2. **VPN Gateway SKUs**: Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, VpnGw4, VpnGw5. AZ variants for zone-redundant. Basic is legacy. Memorize bandwidth tiers (per gateway, not per tunnel).

3. **ExpressRoute peering types**:
   - Private peering: VNets
   - Microsoft peering: M365, Azure PaaS public endpoints
   - Public peering: deprecated
   ExpressRoute FastPath: bypasses gateway for higher throughput.

4. **Hub-spoke vs Virtual WAN**:
   - Hub-spoke: classic, more control, more management
   - Virtual WAN: managed hub, simpler at scale, supports SD-WAN integration
   Virtual WAN is the modern multi-region pattern.

5. **Azure Front Door vs Application Gateway vs Traffic Manager**:
   - Front Door: global L7 with WAF, anycast IPs
   - App Gateway: regional L7 with WAF, internal or public
   - Traffic Manager: DNS-based global routing (no traffic flows through it)
   Front Door is the modern global L7; App Gateway is regional L7.

6. **Load Balancer vs Application Gateway**:
   - Load Balancer: L4 (TCP/UDP), regional, public or internal
   - App Gateway: L7 (HTTP/S), with WAF, regional
   Load Balancer + App Gateway is sometimes layered (LB in front of App Gateway is rare; usually just App Gateway).

7. **Private Endpoints vs Service Endpoints**:
   - Service Endpoint: extends VNet identity to PaaS, still public IP
   - Private Endpoint: PaaS via private IP in VNet, truly private
   Private Endpoint is the modern answer.

8. **Network Watcher vs Connection Monitor vs Connection Troubleshoot**:
   - Network Watcher: umbrella service
   - Connection Monitor: continuous L4/L7 connectivity tests with metrics + alerts
   - Connection Troubleshoot: ad-hoc diagnostic
   - IP Flow Verify: per-NSG rule check
   - Effective Security Rules: aggregated NSG view per NIC

9. **DNS scope**:
   - Public DNS zones: hosted by Azure DNS, internet-resolvable
   - Private DNS zones: VNet-scoped, registered virtual networks resolve from them
   - Private Resolver: hybrid DNS resolution on-prem ↔ Azure (the Azure equivalent of Route 53 Resolver inbound/outbound endpoints)

10. **NAT Gateway**: provides outbound SNAT with port allocation, replaces default outbound. Critical for SNAT exhaustion fixes.

## High-yield topics easy to miss

- Azure Route Server (BGP between NVAs and the VNet platform)
- Virtual Network Manager (ANM, formerly AVNM): centralized VNet config + connectivity at scale
- Azure DDoS Protection tiers: Network Protection (per-VNet) vs IP Protection (per-PIP) vs Standard (legacy term)
- BGP attributes in ExpressRoute: AS_PATH, MED, weight (for outbound traffic engineering)
- ExpressRoute Direct (10/100 Gbps direct fiber to MS edge router, not via partner)
- ExpressRoute Local (cheaper, only to nearest region pair)
- Bastion Standard SKU vs Developer SKU
- Application Gateway v1 (legacy) vs v2 (autoscaling, zone-redundant, WAF v2 with bot protection)
- Forced tunneling on VPN/ExpressRoute (default route via on-prem)

## Time management

100 / ~50 = 2 min/question. Pace: half done by minute 50. Leave 10 min for review.

## When stuck

1. **Identify the layer** - L4 vs L7 - by what's being routed (TCP ports vs HTTP paths/headers).
2. **Identify the scope** - regional vs global - by the question's user / service distribution.
3. **Default to Microsoft-recommended modern patterns** - Virtual WAN over hub-spoke at scale, Private Endpoints over Service Endpoints, Front Door for global.
4. **Eliminate legacy** - Basic Load Balancer SKU, VPN Gateway Basic, ExpressRoute public peering, App Gateway v1.

## Day-of logistics

100 min, ~50 questions. Bring two IDs.

## After

**Pass:** Cert valid 1 year (annual renewal via free online assessment).

**Fail:** Most failures cluster on Hybrid Connectivity (~25%) or Routing (~25%). ExpressRoute peering types and VPN SKU selection are common miss areas.

## AZ-700 patterns

- "Multi-region transit at scale" = Virtual WAN
- "Single-region multi-VNet routing" = VNet peering or hub-spoke
- "On-prem ↔ Azure private" = ExpressRoute (private peering)
- "On-prem ↔ M365 / public PaaS private" = ExpressRoute (Microsoft peering)
- "Global L7 with WAF" = Front Door
- "Regional L7 with WAF" = Application Gateway v2
- "Global L4 (rare)" = Cross-region Load Balancer (preview/limited regions)
- "DNS hybrid" = Azure DNS Private Resolver
- "SNAT exhaustion" = NAT Gateway
- "Centralized network policy" = Virtual Network Manager
- "BGP between NVAs and Azure" = Route Server
- "Browser-based RDP" = Bastion
- "DDoS on a public IP" = DDoS IP Protection (per-IP, paid)
