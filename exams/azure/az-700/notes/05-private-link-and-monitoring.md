# 05 - Private Link, Private Endpoints, Monitoring

## Service Endpoints

Subnet-level fast-path to Azure services via Microsoft backbone. Enable per-subnet, per-service.

### What it does

- Routes traffic for the service via Microsoft backbone (not internet)
- Service still has its public IP and DNS
- Service can configure ACL to only accept traffic from your subnet

### Common services

- `Microsoft.Storage` (Blob, ADLS, Files, etc.)
- `Microsoft.Sql`
- `Microsoft.KeyVault`
- `Microsoft.AzureCosmosDB`
- `Microsoft.Web` (App Service)
- `Microsoft.ServiceBus`
- `Microsoft.EventHub`

### Limitations

- Service still publicly reachable; just adds a private path for your subnet
- Cross-region: service endpoint works for storage in any region by default
- Can't use from on-prem (only from VNet)

### When to use

- Cost-sensitive (no PE charge)
- Service-wide access acceptable
- Don't need to disable public access on the service

---

## Private Link / Private Endpoint

Modern, recommended way to privately connect to Azure PaaS.

### What it does

A **Private Endpoint** is a NIC in your VNet with a private IP that maps to a specific Azure PaaS instance. You can:

- Disable public network access on the service entirely
- Reach the service from on-prem via VPN/ER (since it's now a private IP in your VNet)
- Granular: each PE maps to one service instance (one storage account, one SQL DB)

### Private Link

The umbrella name for the platform. Includes:

- Private Endpoints (for Azure PaaS services)
- Private Link Service (for your own custom services exposed privately)

### DNS configuration (critical)

Most PaaS services have a `privatelink.<service>.<region>.<azure>.com` zone for resolution. Steps:

1. Create a Private Endpoint (private IP gets allocated)
2. Create a **Private DNS Zone** named `privatelink.<service>...` (e.g., `privatelink.blob.core.windows.net`)
3. Link the zone to your VNet so VMs can resolve it
4. Add A record in zone pointing service FQDN to PE's private IP (Azure auto-creates this if "integrate with private DNS zone" is checked at PE creation)

For on-prem resolution, configure conditional forwarding to Azure DNS Private Resolver.

### Common services with Private Endpoint

Storage, SQL DB, Cosmos DB, Key Vault, App Service, AKS, Container Registry, Azure SQL Managed Instance, Synapse, Service Bus, Event Hub, Event Grid, ML Workspace, OpenAI, Bot Service, Function App, Logic App, etc.

### Private Link vs Service Endpoint comparison

| Aspect | Service Endpoint | Private Endpoint |
|---|---|---|
| Private IP for service | No | Yes |
| Service publicly reachable | Yes | Configurable (disable public) |
| Per-instance granularity | No (service-wide) | Yes |
| On-prem reachable | No (VNet only) | Yes (via VPN/ER) |
| DNS work needed | None | Private DNS zone + linking |
| Cost | Free | Per-PE hourly + data |

**Default to Private Endpoint for prod**; Service Endpoint when cost matters and service-wide access is acceptable.

---

## Network Watcher

Centralized network monitoring service. **Per-region** - enable in each region you have networking.

### Key tools

#### Connection Monitor (preview-graduated)

Continuous test from source (VM with extension) to destination (IP, FQDN, Azure resource). Captures latency, packet loss, hop counts. Replaces older Connection Monitor (classic).

#### Connection Troubleshoot

One-shot test from a source VM to a destination. Returns hop-by-hop status and any blocking NSG rule. Use when diagnosing a specific connectivity failure.

#### NSG Flow Logs

Logs every flow allowed/denied by NSG rules. Stored in Azure Storage. Enable per NSG.

#### Traffic Analytics

Layer on top of NSG Flow Logs. Provides visualizations: top talkers, app patterns, malicious traffic flagged. Requires Log Analytics workspace.

#### NSG Diagnostics

Tells you which NSG rules are evaluating for a given source-destination flow.

#### Topology

Visualize VNet relationships (peerings, gateways).

#### IP Flow Verify

Quick check: would a packet from this source/dest/port be allowed by NSG?

#### Next Hop

Where would a packet go from this VM to this destination IP?

#### Packet Capture

On-demand pcap on a VM extension. Output to Storage. Use for deep packet inspection of specific flows.

#### VPN Diagnostics

VPN Gateway tunnel logs and metrics. Critical when troubleshooting site-to-site VPN.

---

## Diagnostic settings

Send platform logs and metrics from networking resources to:

- **Log Analytics workspace** - query with KQL, dashboards
- **Azure Storage** - long-term archive
- **Event Hubs** - real-time processing / SIEM ingest

Resources that support diagnostic settings include VNet, VPN Gateway, ER Gateway, Front Door, Application Gateway, Azure Firewall, NSG, Public IP, etc.

---

## Network Insights (in Azure Monitor)

High-level dashboards for networking health and top issues. Aggregates metrics across resources.

---

## Azure Bastion

Fully-managed jumpbox / RDP+SSH gateway. Eliminates the need for VMs to have public IPs for management.

### Properties

- Lives in `AzureBastionSubnet` (`/26` or larger)
- Reachable via Azure portal browser-based RDP/SSH
- Supports both Windows (RDP) and Linux (SSH) targets
- SKUs: Basic and Standard (Standard adds host scaling, custom port, native client connectivity)

### Why it matters

- VMs can have NO public IP - reduces attack surface
- All RDP/SSH goes through Azure portal with Entra ID auth
- Audit logs in Azure Monitor

---

## Common exam triggers

- "Disable public access to Storage account" → Private Endpoint + Private DNS zone + disable public access
- "Resolve `privatelink.*` from on-prem" → Azure DNS Private Resolver outbound endpoint OR DNS forwarder VM in Azure with conditional forwarders
- "Cheap private path to Storage from VNet" → Service Endpoint (if disabling public access not needed)
- "Test connectivity from VM to Azure SQL DB without manual telnet" → Connection Troubleshoot (one-shot) or Connection Monitor (continuous)
- "Find which NSG rule is blocking my traffic" → NSG Diagnostics or IP Flow Verify
- "RDP/SSH to VMs without public IPs" → Azure Bastion
- "VPN Gateway tunnel down" → VPN Diagnostics in Network Watcher
- "Forensic analysis of past traffic patterns" → NSG Flow Logs + Traffic Analytics
- "Custom service exposed privately to multiple customer VNets" → Private Link Service in front of internal load balancer

---

## Quick decision matrix

| Need | Use |
|---|---|
| Private IP for Azure PaaS | Private Endpoint |
| Cheap fast-path to Azure PaaS, public access OK | Service Endpoint |
| Continuous network test | Connection Monitor |
| Single-shot connectivity test | Connection Troubleshoot |
| Which NSG rule is blocking? | NSG Diagnostics / IP Flow Verify |
| Audit traffic flows | NSG Flow Logs + Traffic Analytics |
| Manage VMs without public IPs | Azure Bastion |
| Long-term log archive | Diagnostic settings → Azure Storage |
| Real-time SIEM ingest | Diagnostic settings → Event Hubs |
| Resolve `privatelink.*` from on-prem | Azure DNS Private Resolver + on-prem conditional forwarder |
