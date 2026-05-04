---
last-updated: 2026-05-03
---

# GCP Professional Cloud Network Engineer (PCNE) - Exam Scenarios

> Six worked scenarios mirroring PCNE question style.

---

## Scenario 1 - Shared VPC vs VPC peering

A company has a central platform team and 30 application projects. Network admin should be centralized; application teams provision their own resources within designated subnets.

**Options:** A. Shared VPC: host project owns the VPC; service projects attach. Subnet-level IAM lets app teams use specific subnets. B. VPC peering between every pair. C. Cloud VPN between projects. D. Each project has its own isolated VPC.

**Analysis:** A is right - Shared VPC is purpose-built for centralized networking with delegated subnet IAM. B is non-transitive and operationally heavy. C is overkill. D doesn't share at all.

**Answer:** A

**Key takeaway:** Shared VPC for centralized networking with delegated app teams. VPC peering for connecting independent VPCs.

---

## Scenario 2 - Hybrid 99.99% availability

Production needs 99.99% private connectivity to a single GCP region.

**Options:** A. Two Dedicated Interconnects in two metros (or four-way redundancy in one metro). B. Single Dedicated Interconnect. C. HA VPN. D. Cloud Interconnect Connect (deprecated).

**Analysis:** A is right - 99.99% requires two metros. C (HA VPN) hits 99.99% over public internet but isn't private. B is single point of failure.

**Answer:** A

**Key takeaway:** GCP hybrid SLA: HA VPN 99.99% (over internet), Dedicated Interconnect 99.9% (single metro) → 99.99% (two metros) → 99.99% multi-region.

---

## Scenario 3 - Global load balancing for HTTP

A consumer app needs anycast IP, geo-routing to nearest backend, WAF-style filtering, and TLS termination at edge.

**Options:** A. Global External HTTPS Load Balancer with backend services across regions; Cloud Armor for WAF; managed certificates. B. Network Load Balancer regional. C. Internal HTTPS LB. D. Cloud DNS round-robin.

**Analysis:** A is right - Global External HTTPS LB is anycast, edge-terminated, with Cloud Armor integration. B is regional L4. C is internal-only. D is DNS, not LB.

**Answer:** A

**Key takeaway:** Global External HTTPS LB = the L7 anycast solution. Cloud Armor = WAF + DDoS Adaptive Protection. Use TCP proxy LB for non-HTTP global L4.

---

## Scenario 4 - Private Google Access vs Private Service Connect

VMs without public IPs need to reach Google APIs (Cloud Storage, BigQuery, etc.).

**Options:** A. Private Google Access on the subnet; or Private Service Connect endpoints for private-IP access to Google APIs. B. NAT Gateway. C. Public IP per VM. D. Cloud VPN.

**Analysis:** A is right - both options. PGA enables egress from no-public-IP VMs to Google APIs (uses private.googleapis.com / restricted.googleapis.com). PSC creates private IPs in your VPC for Google APIs (more secure perimeter, used with VPC Service Controls). B works but uses egress capacity. C exposes VMs unnecessarily. D is heavy.

**Answer:** A

**Key takeaway:** PGA = enable Google APIs from private VMs (still uses Google network). PSC = private IP endpoint in your VPC. PSC is the modern higher-security choice.

---

## Scenario 5 - Cloud Armor

A company needs DDoS protection, geo-blocking (block Russia, China for compliance), and OWASP Top 10 rule sets in front of an HTTPS LB.

**Options:** A. Cloud Armor security policy with managed OWASP rules + geo-restriction rule; Adaptive Protection enabled. B. CDN-only. C. Manual IP blocking with Cloud Functions. D. Cloud NAT.

**Analysis:** A is right - Cloud Armor has managed WAF rules (OWASP), geo-IP rules, and Adaptive Protection (ML-based DDoS detection). B doesn't block. C is reactive. D is for outbound.

**Answer:** A

**Key takeaway:** Cloud Armor = WAF + Adaptive DDoS protection. Standard tier (rules) and Plus tier (subscription, includes Adaptive Protection).

---

## Scenario 6 - Multi-VPC mesh at scale

A company will grow to 200 VPCs across multiple regions. They want full any-to-any connectivity with minimal management.

**Options:** A. Network Connectivity Center (NCC) with VPCs as spokes. B. Full mesh of VPC peering. C. Shared VPC at the org level. D. Manual Cloud Routes.

**Analysis:** A is right - NCC with VPC spokes is GCP's transit answer (released GA 2023+) for multi-VPC connectivity at scale. B is non-transitive. C - Shared VPC is one VPC shared across projects, not multi-VPC connectivity. D is manual.

**Answer:** A

**Key takeaway:** GCP transit: Network Connectivity Center (modern transit hub, similar to AWS TGW / Azure Virtual WAN). Shared VPC is a different pattern (one VPC, many projects).
