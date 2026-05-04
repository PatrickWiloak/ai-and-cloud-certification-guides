---
last-updated: 2026-05-03
---

# AWS Advanced Networking Specialty (ANS-C01) - Exam Strategy

> Cert-specific tactics for the deepest AWS networking exam.

## Format reminder

- 65 scored questions, 170 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response
- ~2.6 min/question; some BGP/DX scenarios are dense

## Top traps

1. **MACsec eligibility**: only on dedicated DX 10 Gbps and 100 Gbps connections, requires MACsec-capable router. Hosted/partner DX or smaller speeds → IPsec-over-DX.
2. **DX SLA tiers**: 99.9% (single DX), 99.99% (two DX, two locations), 99.999% (multi-region resiliency, four DX, two regions). The numbers matter.
3. **TGW vs Cloud WAN vs VPC peering**:
   - <10 VPCs single region: peering is fine.
   - 10+ VPCs single region: TGW.
   - Multi-region with segmentation policy: Cloud WAN.
4. **Multicast**: only TGW Multicast supports it. Subnet-level multicast doesn't work in VPC.
5. **DNS resolution direction**: inbound endpoints serve VPC DNS *to* on-prem; outbound endpoints query *from* VPC. Two endpoints, two directions, often both needed.
6. **Route 53 Resolver vs Private Hosted Zones**: PHZ is *what* the names resolve to inside a VPC; Resolver is the *how* between on-prem and VPC.
7. **GWLB endpoints**: ENI-based, GENEVE-encapsulated, used to route traffic *through* a third-party appliance fleet. Different from regular VPC endpoints (PrivateLink).
8. **BGP attributes**: AS_PATH, LOCAL_PREF, MED. Know which way each influences route selection. AS path prepending is the most-tested technique for shifting outbound traffic.
9. **Network Firewall vs WAF vs Shield**:
   - Network Firewall: stateful packet inspection, IDS/IPS, deep inspection at VPC level.
   - WAF: HTTP/HTTPS layer 7, attaches to ALB / CloudFront / API Gateway.
   - Shield Standard: free DDoS for everyone. Shield Advanced: paid, response team, cost protection.
10. **VPC endpoint types**: Gateway (S3, DynamoDB - free, route table entry) vs Interface (PrivateLink - hourly cost, ENI per AZ) vs Gateway Load Balancer endpoints (for appliance routing).

## High-yield topics easy to miss

- AWS Cloud WAN: core network policy document, segments, sharing, edge locations
- Transit Gateway Connect (GRE + BGP for SD-WAN integration)
- Direct Connect SiteLink (cross-region traffic on customer's DX)
- TGW peering attachments (cross-region TGW connectivity, used pre-Cloud WAN)
- AWS Verified Access (zero-trust application access without VPN)
- AWS Network Access Analyzer + Reachability Analyzer (the two analyzers - know the difference)
- AWS Network Manager (visualization layer over TGW)
- AWS Global Accelerator: anycast IPs, custom routing accelerators (UDP forwarding for gaming)

## Time management

170 / 65 = 2.6 min/question. Pace: Q20 by 50 min, Q40 by 100 min, Q65 by 160 min. Leave 10 min for flagged review. Don't over-invest in BGP scenarios on first pass; they're time sinks.

## When stuck

1. **Read the *throughput* and *resilience* numbers** - they decide MACsec vs IPsec, single vs dual DX.
2. **Default to AWS-native** before third-party (unless question names a third-party).
3. **Eliminate options that don't transit** - peering and PrivateLink are not transitive.
4. **Mind the encryption layer** - MACsec is L2, IPsec is L3, TLS is L7. The question's constraint dictates which.

## Day-of logistics

170 min, 65 questions: similar pacing to Pro exams but with denser networking scenarios. Bring two IDs.

## After

**Pass:** Specialty cert valid 3 years.

**Fail:** Most failures cluster in Domain 1 (Network Design - 30%) or Domain 2 (Implement+Maintain - 26%). If you missed by <50 points, regroup in 4-6 weeks; retake after 14 days.

## ANS-C01 patterns

- "Centralized inspection across VPCs" = TGW + inspection VPC + GWLB or Network Firewall
- "Static IPs + TCP latency" = Global Accelerator
- "HTTP/S caching" = CloudFront
- "Multicast" = TGW Multicast (only option)
- "Multi-region segmentation policy" = Cloud WAN
- "Hybrid bidirectional DNS" = Resolver inbound + outbound endpoints
- "99.99% hybrid availability" = Two DX, two locations
- "Encrypted DX (10 Gbps dedicated)" = MACsec
- "Encrypted DX (hosted/smaller speeds)" = IPsec VPN over DX
