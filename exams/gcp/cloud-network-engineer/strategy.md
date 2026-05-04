---
last-updated: 2026-05-03
---

# GCP Professional Cloud Network Engineer (PCNE) - Exam Strategy

## Format reminder

- 50-60 questions, 120 minutes
- Pass mark ~70-75%

## Top traps

1. **Shared VPC vs VPC Peering vs Network Connectivity Center**:
   - Shared VPC: one VPC, host + service projects (single-region or multi-region)
   - VPC Peering: connect independent VPCs (non-transitive)
   - NCC: transit hub with spokes (transitive, modern multi-VPC pattern)

2. **Load Balancer types (memorize)**:
   - Global External HTTPS: anycast L7 internet-facing (with Cloud Armor)
   - Regional External HTTPS: L7 in one region
   - Global External TCP Proxy / SSL Proxy: L4 anycast
   - Network Load Balancer: regional L4 (passthrough or proxy)
   - Internal Application LB: L7 internal
   - Internal Network LB: L4 internal

3. **Cloud Armor tiers**: Standard (rules, basic DDoS) vs Plus (subscription, Adaptive Protection ML).

4. **Interconnect tiers**:
   - Dedicated: 10 Gbps / 100 Gbps direct, 99.9% / 99.99% / 99.99% multi-region
   - Partner: 50 Mbps - 50 Gbps via SP
   - HA VPN: 99.99% over internet (two tunnels required)

5. **Private Google Access vs Private Service Connect**:
   - PGA: subnet-level enablement, VMs reach Google APIs without public IPs
   - PSC: explicit private IP in your VPC for Google APIs or third-party services

6. **DNS scope**:
   - Cloud DNS public zones: internet-resolvable
   - Cloud DNS private zones: VPC-scoped
   - DNS Peering: forward DNS between VPCs
   - Inbound / Outbound DNS forwarding for hybrid

7. **Firewall rules vs hierarchical firewall policies vs Network Firewall Policies**:
   - VPC firewall rules: VPC-scoped
   - Hierarchical: org / folder level for governance
   - Network Firewall Policies: VPC-attachable, more flexible than legacy VPC FW rules

8. **Cloud NAT**: outbound-only, replaces public IPs for egress; required when private VMs need internet.

9. **VPC Service Controls**: data-exfiltration prevention via service perimeters; works with PSC for private API access.

10. **Routing**: Cloud Router (BGP for VPN/Interconnect), custom routes (static), VPC routing modes (regional vs global).

## High-yield topics easy to miss

- Network Intelligence Center (visualization + Connectivity Tests)
- Packet Mirroring (traffic capture for analysis)
- Cloud IDS (managed IDS service, integrates with Packet Mirroring)
- Cloud CDN edge caching tiers
- Service Directory (managed service registry)
- Network Security Integration (third-party security appliance integration)

## Time management

120 / ~55 = ~2.2 min/question.

## When stuck

1. **Identify the layer** - L4 vs L7.
2. **Identify the scope** - global anycast vs regional vs internal.
3. **Default to managed** - PSC over self-managed proxy, NCC over manual mesh.
4. **Eliminate "manual" or "deprecated"** - VPC peering for 200 VPCs, manual route updates.

## Day-of logistics

120 min, ~55 questions.

## After

**Pass:** Cert valid 2 years.

**Fail:** Most failures cluster on Hybrid Connectivity (~25%) or LB selection (~20%).

## PCNE patterns

- "Centralized network for many projects" = Shared VPC
- "200+ VPC connectivity" = Network Connectivity Center
- "Global L7 with WAF" = Global External HTTPS LB + Cloud Armor
- "Anycast L4" = Global TCP/SSL Proxy LB
- "Hybrid 99.99%" = Two Dedicated Interconnects two metros
- "Private API access from VMs" = PGA or PSC
- "Data exfil prevention" = VPC Service Controls
- "Org-wide firewall policy" = Hierarchical Firewall Policies
- "Outbound-only internet" = Cloud NAT
- "DDoS + WAF + geo-blocking" = Cloud Armor (Plus for Adaptive)
