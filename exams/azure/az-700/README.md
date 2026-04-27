# Microsoft Certified: Azure Network Engineer Associate (AZ-700)

## Overview

The Azure Network Engineer Associate certification validates the ability to design, implement, and maintain Azure networking infrastructure: hybrid connectivity (VPN, ExpressRoute), VNets, Azure Firewall, Application Gateway, Load Balancer, Front Door, traffic management (Traffic Manager, Route Tables), and private connectivity (Private Endpoints, Private Link).

This is the canonical Azure-networking specialty for network engineers, cloud architects, and security professionals working with Azure-hosted workloads.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | AZ-700 |
| **Full Name** | Microsoft Certified: Azure Network Engineer Associate |
| **Provider** | Microsoft |
| **Format** | Multiple choice, multiple response, case studies |
| **Duration** | 100 minutes |
| **Cost** | $165 USD |
| **Validity** | 1 year (renewable for free annually via Microsoft Learn) |
| **Passing Score** | 700 / 1000 |

**[📖 Official AZ-700 page](https://learn.microsoft.com/credentials/certifications/azure-network-engineer-associate/)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Design, implement, and manage hybrid networking | 10-15% |
| 2 | Design and implement core networking infrastructure | 20-25% |
| 3 | Design and implement routing | 25-30% |
| 4 | Secure and monitor networks | 15-20% |
| 5 | Design and implement private access to Azure services | 15-20% |

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Reference with high-yield facts and Microsoft Learn links |
| [practice-plan.md](practice-plan.md) | 8-week study plan |
| [scenarios.md](scenarios.md) | 12 exam-style scenarios |
| [notes/01-vnets-and-core-networking.md](notes/01-vnets-and-core-networking.md) | VNets, subnets, peering, NSGs, ASGs |
| [notes/02-hybrid-connectivity.md](notes/02-hybrid-connectivity.md) | VPN Gateway, ExpressRoute, Virtual WAN |
| [notes/03-load-balancing-and-traffic.md](notes/03-load-balancing-and-traffic.md) | Load Balancer, Application Gateway, Front Door, Traffic Manager |
| [notes/04-routing-and-firewall.md](notes/04-routing-and-firewall.md) | Route tables, BGP, Azure Firewall, NVAs |
| [notes/05-private-link-and-monitoring.md](notes/05-private-link-and-monitoring.md) | Private Endpoint, Private Link, Network Watcher, Connection Monitor |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Azure admin (AZ-104) + networking experience | 4-6 weeks |
| AZ-104 only, light networking | 6-8 weeks |
| New to Azure | 12+ weeks; consider AZ-104 first |

---

## Hands-on Setup

- Azure free account ($200 credit, 30 days) or Visual Studio subscription credits
- Build out: 2 VNets in different regions, peer them, deploy a VPN Gateway pair, attach Azure Firewall, add Application Gateway with WAF, configure Private Endpoint to Azure SQL DB
- Each lab session, tear down to control cost (Azure networking can run $$$)

---

## Companion Materials

- **[AZ-104 Azure Administrator](../az-104/)** - prerequisite-level Azure knowledge
- **[Hybrid Connectivity Deep Dive](../../../resources/networking-deep-dives/hybrid-connectivity.md)**
- **[Multi-Cloud Networking](../../../resources/networking-deep-dives/multi-cloud-networking.md)**
- **[Cisco CCNA](../../cisco/ccna-200-301/)** - foundational networking concepts
- **[AWS Advanced Networking ANS-C01](../../aws/specialty/advanced-networking-ans-c01/)** - AWS counterpart
