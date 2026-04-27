# AZ-700 - Exam-Style Scenarios

12 scenarios covering the major exam domains.

---

### Scenario 1
**You need a private path from VNet to Storage account, with the Storage account no longer reachable from the public internet.**

**Best answer:** Private Endpoint to Storage + disable public network access on the Storage account + Private DNS Zone `privatelink.blob.core.windows.net` linked to the VNet for name resolution.

---

### Scenario 2
**Spoke-to-spoke traffic between two peered spokes (each peered to a hub) must transit through Azure Firewall in the hub.**

**Best answer:** UDR on each spoke routing peer's address space (or `0.0.0.0/0`) to Azure Firewall's IP. Hub peering must have **allow forwarded traffic** = true.

---

### Scenario 3
**A web app must serve users globally with WAF, low-latency edge presence, and origin failover across two regions.**

**Best answer:** Azure Front Door (Standard or Premium for advanced WAF). Configure two origin groups (one per region) with priorities for failover.

---

### Scenario 4
**On-prem-to-on-prem traffic should go through the Microsoft backbone instead of the internet, while also reaching Azure VNets.**

**Best answer:** ExpressRoute Global Reach. Two ER circuits at branch offices; Global Reach links them via Microsoft's backbone.

---

### Scenario 5
**Branch office user laptops need VPN access to Azure VNet using their corporate Azure AD credentials.**

**Best answer:** Point-to-Site VPN on Azure VPN Gateway, configured with OpenVPN protocol and Azure AD authentication.

---

### Scenario 6
**A Web app needs HTTPS with WAF, regional, plus path-based routing (e.g., `/api/*` to one backend pool, `/web/*` to another).**

**Best answer:** Application Gateway WAF_v2 with multiple backend pools and a path-based routing rule.

---

### Scenario 7
**You need to allow outbound HTTPS to `*.microsoft.com` only, blocking everything else.**

**Best answer:** Azure Firewall (Standard or Premium) with an Application Rule: action Allow, FQDN tag or wildcard `*.microsoft.com`, protocol HTTPS:443. Default-deny everything else.

---

### Scenario 8
**Two VNets in different Azure regions must communicate at the Azure backbone (not over public internet).**

**Best answer:** Global VNet Peering. Same effect as VNet peering but cross-region; higher cost but very low latency.

---

### Scenario 9
**An NVA pair (Palo Alto firewalls) provides outbound from a VNet. How do you provide HA?**

**Best answer:** Standard Internal Load Balancer in front of the NVA pair. UDR points to the LB frontend IP (not individual NVA IPs). LB health probes detect NVA failure and shift traffic.

---

### Scenario 10
**A user reports they can't connect to a VM via RDP. What's the fastest tool to identify the cause?**

**Best answer:** Network Watcher → Connection Troubleshoot or IP Flow Verify - tells you exactly which NSG rule (or other path issue) is blocking.

---

### Scenario 11
**Multi-region active-active web app with stateful API (sessions stored in Cosmos DB).**

**Best answer:**
- Front Door at the edge (global, WAF, custom domain, TLS)
- App Gateway in each region for path/host routing
- App Service / VMs / AKS in each region
- Cosmos DB Global Tables for session state replication

---

### Scenario 12
**On-prem must resolve Azure private endpoint hostnames (`privatelink.database.windows.net`).**

**Best answer:**
- Deploy Azure DNS Private Resolver in your hub VNet with an **inbound endpoint**
- Configure on-prem DNS to **conditionally forward** `privatelink.database.windows.net` (and other zones you use) to the inbound endpoint's IP
- Ensure VPN/ER allows DNS traffic between on-prem and the resolver subnet

---

## Scoring guide

- **10-12:** Schedule the exam.
- **7-9:** Re-read fact-sheet and weak-area notes.
- **<7:** More hands-on lab time before retesting.

AZ-700 has 40-60 multi-choice + multi-response + case studies. These scenarios test pattern recognition; build hands-on fluency with VNets, peering, gateways, firewall, App Gateway, and Network Watcher.
