# 03 - Load Balancing, Traffic Management, App Gateway, Front Door

Five Azure load-balancing options. Picking the right one is the most-tested skill in this domain.

---

## Decision matrix (memorize this)

| Option | Layer | Scope | TLS | WAF | Path-based | Use case |
|---|---|---|---|---|---|---|
| **Azure Load Balancer (Standard)** | L4 (TCP/UDP) | Regional | No (passthrough) | No | No | Internal/public TCP/UDP |
| **Azure Application Gateway** | L7 (HTTP/S) | Regional | Yes | Optional (WAF SKU) | Yes | Web apps in one region |
| **Azure Front Door** | L7 (HTTP/S) | Global | Yes | Optional (WAF) | Yes | Multi-region web edge |
| **Azure Traffic Manager** | DNS | Global | Pass-through | No | No | DNS-based routing across regions |
| **Cross-region Load Balancer** | L4 | Global | No | No | No | Layer 4 across regions |

---

## Azure Load Balancer (Standard)

L4 load balancer for any TCP or UDP traffic. Internal (private IP) or public.

### Components

- **Frontend IP** - public or private
- **Backend pool** - VMs / Scale Sets / NICs
- **Health probe** - TCP, HTTP/HTTPS
- **Load balancing rule** - frontend → backend with port mapping
- **Inbound NAT rule** - port forward to specific backend (e.g., RDP to a specific VM)
- **Outbound rule** - SNAT to provide outbound internet from private VMs

### Distribution modes

- **5-tuple** - default (source IP, source port, dest IP, dest port, protocol)
- **3-tuple** - source IP affinity
- **2-tuple** - source IP affinity, sticky across protocols/ports

### Standard vs Basic

Basic LB is deprecating Sept 30, 2025 (or thereabouts). Use Standard. Basic doesn't support availability zones, isn't included in monitoring, has fewer features.

### Common scenarios

- Public LB for HA web farm (just TCP, no HTTP-aware features)
- Internal LB in front of a private SQL cluster
- Outbound SNAT for VMs that need internet without public IPs

---

## Application Gateway

L7 load balancer for HTTP/HTTPS. Regional. Replaces an ALB or HAProxy in front of web apps.

### Features

- **Path-based routing** - `/api/*` to pool A, `/web/*` to pool B
- **Multi-site hosting** - multiple FQDNs on one Application Gateway
- **SSL termination** - decrypt at the gateway
- **End-to-end TLS** - re-encrypt to backend
- **WAF (Web Application Firewall)** - OWASP rules, custom rules, bot protection (with WAF v2 SKU)
- **Autoscaling** (v2 SKU)
- **Zone redundancy** (v2 SKU)
- **Cookie-based affinity** for sticky sessions

### SKU choices

- **Standard_v2** - modern, autoscaling, zone-redundant, no WAF
- **WAF_v2** - everything in Standard_v2 + WAF
- v1 SKUs (Standard, WAF) are legacy; new deployments should use v2

### Required subnet

App Gateway needs its own subnet (no other resources). Recommend `/24`.

### Backend pool members

- Azure VMs / VMSS
- App Services (any region)
- IP addresses (including on-prem via VPN/ER)
- Azure Kubernetes (via Application Gateway Ingress Controller)

---

## Azure Front Door

L7 global edge service. Anycast on Microsoft's CDN/edge network.

### Tiers

- **Front Door Standard** - core L7 + CDN; lightweight WAF rules
- **Front Door Premium** - everything + advanced WAF (managed bot rules, ML-based filtering, private link to origins, custom WAF rules)

### Features

- Routing across regions / origins
- WAF (Premium for advanced)
- Caching (CDN)
- Custom domains + managed TLS certs
- URL rewrite/redirect at edge
- Origin priority + weight (failover + traffic split)
- Global Anycast IP for the frontend
- Health probes to origins
- Rules engine for path-based / header-based routing

### Use cases

- Global website with users worldwide
- Multi-region failover for SaaS apps
- Edge caching (CDN replacement)
- API gateway pattern at the edge

### Front Door vs Application Gateway

- Front Door = global. Application Gateway = regional.
- Many architectures use **Front Door at the edge → Application Gateway in each region → backend**. Front Door provides the global edge + WAF at the perimeter; App Gateway can do additional regional routing and end-to-end TLS to the backend.

---

## Traffic Manager

DNS-based global routing. Returns different IP/CNAME based on routing method.

### Routing methods

| Method | Behavior |
|---|---|
| **Performance** | Lowest-latency endpoint from user (uses Microsoft latency table) |
| **Weighted** | Split traffic by configured weights |
| **Priority** | Active/passive failover (try primary; fall back to secondary if unhealthy) |
| **Geographic** | By client geo-IP (e.g., EU users to EU endpoint) |
| **Multivalue** | Return all healthy IPs (DNS round-robin) |
| **Subnet** | By client IP/subnet (less common) |

### Notes

- DNS-only. Does NOT proxy traffic (unlike Front Door).
- Health checks are external; updates DNS records as endpoints become unhealthy.
- TTL determines how quickly clients shift on failover.

### Traffic Manager vs Front Door

- Traffic Manager is **DNS-based** (clients resolve to a regional endpoint, then connect directly).
- Front Door is **HTTP-proxy-based** (clients connect to Front Door's edge, which proxies to origins).
- Front Door provides edge caching, WAF, faster failover (no DNS TTL wait).
- Traffic Manager is cheaper and works for non-HTTP protocols (just DNS resolution).

---

## Cross-region Load Balancer

L4 global load balancer. Backend = regional Azure Load Balancers.

- Single global Anycast IP
- Source NAT preserved (?)
- Health probes through regional LBs to backend pools
- Cheaper than Front Door for L4 use cases

Newer service; less feature-rich than Traffic Manager + LB combo. Useful when you need a global L4 entry point.

---

## CDN (Azure Front Door SKU vs Azure CDN)

Microsoft's content delivery offerings:

- **Front Door (Standard / Premium)** - the modern Microsoft CDN + edge service
- **Azure CDN from Edgio (formerly Verizon)** - legacy, retiring
- **Azure CDN Standard from Microsoft** - legacy, retiring; replaced by Front Door

For new deployments, use **Azure Front Door**.

---

## Patterns

### Multi-region active-active web app

```
Front Door (global, WAF, custom domain, TLS termination)
     │
     ├─ App Gateway (East US) ─→ App Service / VMs (East US)
     └─ App Gateway (West US) ─→ App Service / VMs (West US)
```

State managed via Cosmos DB Global Tables, geo-redundant Storage, SQL DB Active Geo-Replication.

### Internal API gateway

```
On-prem  ──VPN──┐
                │
      App Gateway (private IP, internal LB mode)
                │
        ┌───────┼─────────────┐
   App Service / Function / AKS Ingress
```

App Gateway can have only internal IP (no public). Provides WAF + path routing for internal-only APIs.

### Multi-site hosting

App Gateway with two listeners on the same public IP, different host headers. Different backend pools per site. Both with TLS terminated at App Gateway.

---

## Common exam triggers

- "Global HTTPS with WAF" → Front Door (Premium for advanced WAF)
- "Regional HTTPS with WAF and path-based routing" → App Gateway WAF_v2
- "TCP load balancing across multiple VMs in a region" → Azure Load Balancer (Standard)
- "DNS-based regional failover, no proxy" → Traffic Manager (Priority)
- "Multi-region active-active web with edge caching" → Front Door + per-region App Gateway
- "Sticky sessions for stateful HTTP app" → App Gateway with cookie-based affinity
- "Block bots and scrapers" → Front Door Premium WAF or App Gateway WAF_v2 with bot protection rules
- "Active-passive across two regions" → Traffic Manager Priority routing
- "Outbound internet from private VMs without public IPs" → Standard LB outbound rule with SNAT, or NAT Gateway
- "Replace Azure CDN" → Azure Front Door
