---
last-updated: 2026-05-03
---

# AWS Advanced Networking Specialty (ANS-C01) - Exam Scenarios

> Eight worked scenarios mirroring ANS-C01 question style. Illustrative, not real exam questions. ANS-C01 is the deepest networking AWS exam; questions test routing, BGP behavior, encryption, multicast, and multi-region patterns at a level no other AWS cert reaches.

---

## Scenario 1 - Centralized inspection with Gateway Load Balancer (Domain 1: 30%)

A company runs 40 VPCs and wants east-west traffic between any two VPCs to be inspected by a third-party next-gen firewall fleet, with horizontal scaling of the firewall fleet without changing routing.

Which architecture fits?

A. Transit Gateway with a dedicated inspection VPC; Gateway Load Balancer (GWLB) in the inspection VPC fronting the firewall ASG; TGW route tables direct VPC-to-VPC through the GWLB endpoints.
B. VPC peering mesh with security groups doing the inspection.
C. Each VPC has its own firewall instances; VPC peering between VPCs.
D. AWS Network Firewall in each VPC; CloudWatch alarms aggregate findings.

**Analysis**

A is right: GWLB + GENEVE encapsulation is the AWS-native pattern for transparently routing through a third-party appliance fleet. The fleet scales horizontally; GWLB handles flow stickiness via 5-tuple. TGW + inspection VPC + GWLB endpoints is the canonical multi-VPC pattern. B is non-transitive and offers no inspection. C is per-VPC firewalls (operational explosion). D is AWS-native but the question said "third-party next-gen firewall."

**Answer:** A

**Key takeaway:** Third-party appliance horizontal scale = GWLB. Native AWS firewall = AWS Network Firewall. Both can be centralized via inspection VPC + TGW.

---

## Scenario 2 - Direct Connect failover design (Domain 2: 26%)

A company has a single 10 Gbps Direct Connect connection to a partner DX location. They need 99.99% availability for the hybrid path with cost as a secondary concern.

Which design fits?

A. Add a second 10 Gbps Direct Connect connection at a different DX location; configure BGP active-active with equal-cost multi-path (ECMP) on the DX gateway.
B. Add a site-to-site VPN as backup; BGP failover to VPN if the DX path fails.
C. Add a second 10 Gbps DX at the same DX location for redundancy.
D. SiteLink for cross-region traffic on the existing DX.

**Analysis**

A is right: 99.99% requires DX at *two physically separated DX locations* (the AWS resiliency recommendation). ECMP across both for active-active. B reaches only ~99.9% because VPN is over public internet (subject to ISP outages). C only protects against connection-level failure, not DX-location failure. D is for inter-region routing.

**Answer:** A

**Key takeaway:** AWS DX SLA targets: 99.9% (single DX), 99.99% (resiliency: two DX, different locations), 99.999% (multi-region resiliency, four DX). Memorize these numbers.

---

## Scenario 3 - Hybrid DNS resolution (Domain 1: 30%)

On-premises systems need to resolve names in three private VPCs, and VPC instances need to resolve on-prem names. The on-prem DNS is BIND.

Which fits?

A. Route 53 Resolver inbound endpoints in each VPC for on-prem→VPC; outbound endpoints with conditional forwarding rules pointing at the on-prem BIND for VPC→on-prem.
B. Route 53 Private Hosted Zones associated with each VPC; on-prem queries go to public Route 53.
C. Forward on-prem DNS to AWS public Route 53 servers.
D. AWS Managed AD as the DNS for both on-prem and VPC.

**Analysis**

A is right: this is the canonical hybrid DNS pattern. Inbound endpoints serve VPC DNS to on-prem. Outbound endpoints with rules forward to on-prem for specific zones. B doesn't work for on-prem→VPC. C doesn't allow on-prem private zones to be resolved. D is heavy-handed and not the AWS-recommended hybrid DNS pattern.

**Answer:** A

**Key takeaway:** Bidirectional hybrid DNS = Route 53 Resolver inbound + outbound endpoints + conditional forwarding rules.

---

## Scenario 4 - Multicast in AWS (Domain 1: 30%)

A trading firm migrated from on-premises and needs IP multicast (PIM-style) between hosts in the same VPC. Existing app uses UDP multicast for market-data fanout.

Which fits?

A. Transit Gateway multicast domain; instances join via TGW Multicast Group.
B. EC2 instances in the same subnet; configure multicast routing on the OS.
C. Application Load Balancer with multicast target groups.
D. AWS Cloud Map service discovery.

**Analysis**

A is right: TGW Multicast is the only AWS-native multicast, including IGMPv2 group membership and source/member registration. B doesn't work because VPC fabric drops multicast packets by default. C - ALB doesn't do multicast. D is service discovery, not multicast.

**Answer:** A

**Key takeaway:** Multicast in AWS = TGW Multicast (only option). VPC native networking blocks multicast.

---

## Scenario 5 - Encrypting data on Direct Connect (Domain 4: 14%)

A regulated workload must use encrypted hybrid connectivity. The Direct Connect runs at 10 Gbps to a partner DX location.

Which encryption is correct?

A. Site-to-site IPsec VPN over the DX connection; BGP via the VPN tunnel.
B. MACsec on the DX connection.
C. TLS at the application layer; no network-level encryption.
D. Customer-side encryption gateway between on-prem and DX.

**Analysis**

A is right *and* B is also valid; the deciding factor is DX bandwidth tier. **MACsec is supported only on dedicated DX 100 Gbps and 10 Gbps direct connections (not all hosted partner ports), and requires a MACsec-capable customer router.** If the question explicitly says "hosted DX from partner" or "non-MACsec router," IPsec VPN over DX is the answer. If it says "10 Gbps dedicated direct connection," MACsec is preferred (lower overhead, native).

**Answer:** B (when MACsec is supported); A as fallback

**Key takeaway:** MACsec for native, low-overhead, dedicated 10 Gbps+ DX. IPsec-over-DX as the always-works fallback. The exam tests the boundary: read for "hosted" vs "dedicated."

---

## Scenario 6 - Cloud WAN segmentation (Domain 1: 30%)

A multinational has 6 regions and 80 VPCs. They want segments (production, dev, shared services) where production VPCs talk to each other across regions but not to dev, and shared services is reachable by both.

Which fits?

A. AWS Cloud WAN with three segments (prod, dev, shared); attach each VPC to the appropriate segment; segment policies define inter-segment connectivity.
B. Transit Gateway in each region peered together; manual route table configuration per VPC.
C. VPC peering with explicit routing per VPC; manual maintenance.
D. AWS Network Manager dashboards on top of TGW.

**Analysis**

A is right: Cloud WAN's segment + sharing model is purpose-built for this; segments are global across regions; sharing rules at the segment level. B works but is operationally heavy (TGW route tables per region, manual peering). C does not scale. D is monitoring only.

**Answer:** A

**Key takeaway:** Cloud WAN is for global multi-region segmentation. TGW is for regional. The boundary is "do I need cross-region segments with policy?" → Cloud WAN.

---

## Scenario 7 - Latency optimization for global SaaS (Domain 3: 20%)

A SaaS team has clients in six continents and wants TCP termination close to the user, fixed source IPs for whitelisting, and DDoS protection.

Which combination fits?

A. AWS Global Accelerator + ALB origin; Shield Advanced.
B. CloudFront in front of ALB; Route 53 latency-based routing.
C. Route 53 geolocation routing to regional ALBs.
D. Direct Connect from each region to the user.

**Analysis**

A is right: Global Accelerator gives anycast static IPs (for whitelisting), TCP termination at edge POPs (lower latency), automatic failover, and Shield Advanced is included with GA endpoints. B is for HTTP/S caching - works but no static IPs, no TCP termination control. C is DNS-only; no static IPs. D is on-prem connectivity, not user-facing.

**Answer:** A

**Key takeaway:** Need static IPs + TCP latency reduction = Global Accelerator. Need HTTP/S caching = CloudFront. The two are different products and the question constraints (static IPs, TCP) tell you which one.

---

## Scenario 8 - VPC peering vs Transit Gateway scale (Domain 1: 30%)

A company will grow from 5 VPCs to 200 VPCs over 12 months. They want connectivity between any two VPCs with minimal operational overhead at the new scale.

Which approach fits?

A. Transit Gateway as the hub; all VPCs attach to TGW.
B. Full mesh of VPC peering between every pair.
C. AWS PrivateLink between every pair.
D. AWS Cloud WAN with segments.

**Analysis**

A is right (with Cloud WAN as a viable answer if multi-region). At 200 VPCs, full peering mesh is 19,900 connections (n*(n-1)/2). TGW is 200 attachments. B is non-transitive and doesn't scale. C is for service exposure between VPCs, not full IP-routed connectivity. D works if multi-region, but TGW is the standard at this scale.

**Answer:** A

**Key takeaway:** TGW vs peering boundary: roughly 5-10 VPCs is the inflection. Peering is fine for small fixed topologies; TGW for everything else.
