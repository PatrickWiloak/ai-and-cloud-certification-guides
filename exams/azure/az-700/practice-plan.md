# AZ-700 - 8-Week Practice Plan

This plan assumes 1-2 hours of theory + 1-2 hours of hands-on lab per day.

Networking labs in Azure can be expensive (gateways, ER, App Gateway). Tear down between sessions.

---

## Lab setup

- [ ] Activate Azure free account ($200 credit) or Visual Studio sub
- [ ] Set up cost alerts at $50, $100, $150 thresholds
- [ ] Create a resource group named `learn-az700`
- [ ] Practice tearing it down at end of each session: `az group delete --name learn-az700`

---

## Week 1 - VNets, Subnets, NSGs, Peering

- [ ] Read [notes/01-vnets-and-core-networking.md](./notes/01-vnets-and-core-networking.md)
- [ ] Lab: 2 VNets, peer them, deploy a VM in each, ping across
- [ ] Lab: NSG rule blocking 80, then allowing - test with curl
- [ ] Lab: ASGs - tag two VMs and write rules using ASGs
- [ ] Lab: Hub-spoke topology with allow gateway transit / use remote gateway

---

## Week 2 - Hybrid Connectivity (VPN)

- [ ] Read [notes/02-hybrid-connectivity.md](./notes/02-hybrid-connectivity.md)
- [ ] Lab: Deploy a VPN Gateway (this takes 30-45 min, plan accordingly)
- [ ] Lab: Configure a "fake on-prem" VPN with another VNet + a Linux VM running strongSwan or Azure VPN Gateway in another region
- [ ] Lab: Establish Site-to-Site VPN; verify traffic
- [ ] Lab: Active-active VPN gateway

### Self-check
- [ ] Can I size GatewaySubnet correctly?
- [ ] Do I know VPN Gateway SKU tradeoffs?
- [ ] Can I configure BGP on a VPN connection?

---

## Week 3 - Hybrid Connectivity (ExpressRoute) + Virtual WAN

- [ ] Read [notes/02-hybrid-connectivity.md](./notes/02-hybrid-connectivity.md) - ER and Virtual WAN sections
- [ ] You can't actually deploy ExpressRoute in a lab (requires provider). Read docs end-to-end and follow Microsoft Learn guided lab simulations
- [ ] Lab: Deploy a Virtual WAN with two regional hubs and connect VNets
- [ ] Read about ER Direct, Global Reach, FastPath, ExpressRoute coexistence with VPN

---

## Week 4 - Load Balancing (LB, App Gateway, Front Door, Traffic Manager)

- [ ] Read [notes/03-load-balancing-and-traffic.md](./notes/03-load-balancing-and-traffic.md)
- [ ] Lab: Standard Load Balancer with 2-VM backend pool, public IP, health probe, distribution rule
- [ ] Lab: Application Gateway WAF_v2 with path-based routing and SSL termination
- [ ] Lab: Front Door Standard with two origins in different regions; test failover
- [ ] Lab: Traffic Manager with Priority routing across two endpoints

### Self-check
- [ ] Can I pick the right LB option for any prompt?
- [ ] Do I know App Gateway vs Front Door tradeoffs?
- [ ] Can I configure WAF rules?

---

## Week 5 - Routing and Azure Firewall

- [ ] Read [notes/04-routing-and-firewall.md](./notes/04-routing-and-firewall.md)
- [ ] Lab: Hub-spoke with Azure Firewall Standard
- [ ] Lab: Force-tunnel spokes through hub firewall via UDR
- [ ] Lab: Configure FQDN application rules (allow only `microsoft.com` and subdomains)
- [ ] Lab: DNAT rule to publish a port from public IP to a VM in spoke
- [ ] Read about Azure Firewall Premium features (TLS inspection, IDPS)
- [ ] Read about Firewall Policy hierarchical management
- [ ] Read about Azure Route Server (deploy if budget allows)

---

## Week 6 - Private Link / Endpoints, DNS

- [ ] Read [notes/05-private-link-and-monitoring.md](./notes/05-private-link-and-monitoring.md)
- [ ] Lab: Storage account with Private Endpoint; disable public access; verify access from VM in same VNet
- [ ] Lab: Configure Private DNS zone for `privatelink.blob.core.windows.net`; link to VNet
- [ ] Lab: Configure Azure DNS Private Resolver with inbound + outbound endpoints
- [ ] Lab: SQL DB with Private Endpoint
- [ ] Compare Service Endpoint vs Private Endpoint (cost, granularity, when to use)

---

## Week 7 - Monitoring, Bastion, Misc

- [ ] Read [notes/05-private-link-and-monitoring.md](./notes/05-private-link-and-monitoring.md) - Network Watcher and monitoring sections
- [ ] Lab: Azure Bastion deployment
- [ ] Lab: NSG Flow Logs to Storage; enable Traffic Analytics
- [ ] Lab: Connection Troubleshoot test from VM to internet (then through firewall, observe difference)
- [ ] Lab: VPN Diagnostics on a VPN Gateway tunnel
- [ ] Read about Network Insights dashboards in Azure Monitor

---

## Week 8 - Practice Exams + Review

- [ ] Re-read [fact-sheet.md](./fact-sheet.md) cover to cover
- [ ] Work through [scenarios.md](./scenarios.md)
- [ ] Microsoft Learn AZ-700 Practice Assessment
- [ ] One paid practice exam (MeasureUp, Whizlabs)
- [ ] Score 80%+ before scheduling

---

## Stop signals (you're ready)

- [ ] You can sketch a hub-spoke with VPN/ER, Azure Firewall, force-tunnel, and PE-to-Storage from memory
- [ ] You can pick the right LB option for any prompt
- [ ] You know App Gateway vs Front Door tradeoffs
- [ ] You know Service Endpoint vs Private Endpoint tradeoffs
- [ ] You can troubleshoot connectivity issues using Network Watcher tools
- [ ] You score 80%+ on practice exams twice in a row
