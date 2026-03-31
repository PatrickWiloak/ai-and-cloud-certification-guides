# DNS Deep Dive

Comprehensive guide to DNS concepts and cloud DNS services.

---

## DNS Fundamentals

### What is DNS?

The Domain Name System translates human-readable domain names (like `example.com`) into IP addresses (like `93.184.216.34`). It is a hierarchical, distributed database.

### DNS Hierarchy

```
Root (.)
  |
  +-- Top-Level Domains (.com, .org, .net, .io)
        |
        +-- Second-Level Domains (example.com)
              |
              +-- Subdomains (api.example.com, www.example.com)
```

---

## Record Types

### A Record
Maps a domain name to an IPv4 address.
```
example.com.    300    IN    A    93.184.216.34
```

### AAAA Record
Maps a domain name to an IPv6 address.
```
example.com.    300    IN    AAAA    2606:2800:220:1:248:1893:25c8:1946
```

### CNAME Record
Creates an alias from one domain name to another. Cannot coexist with other record types at the same name.
```
www.example.com.    300    IN    CNAME    example.com.
```
- Cannot be used at the zone apex (e.g., `example.com` cannot be a CNAME)
- Causes an additional DNS lookup to resolve the target
- Use ALIAS/ANAME records (cloud-specific) for zone apex aliasing

### MX Record
Specifies mail servers for the domain. Priority value determines preference (lower = higher priority).
```
example.com.    300    IN    MX    10    mail1.example.com.
example.com.    300    IN    MX    20    mail2.example.com.
```

### TXT Record
Holds arbitrary text data. Commonly used for email authentication (SPF, DKIM, DMARC) and domain verification.
```
example.com.    300    IN    TXT    "v=spf1 include:_spf.google.com ~all"
example.com.    300    IN    TXT    "google-site-verification=abcdef123456"
```

### SRV Record
Specifies the location of services. Format: `_service._protocol.name TTL IN SRV priority weight port target`.
```
_sip._tcp.example.com.    300    IN    SRV    10 60 5060 sip.example.com.
```
- Used by protocols like SIP, XMPP, LDAP, and Kubernetes service discovery

### NS Record
Delegates a domain or subdomain to specific name servers.
```
example.com.    86400    IN    NS    ns1.example.com.
example.com.    86400    IN    NS    ns2.example.com.
```

### SOA Record
Start of Authority - contains administrative information about the zone.
```
example.com.    86400    IN    SOA    ns1.example.com. admin.example.com. (
    2024010101    ; Serial number
    3600          ; Refresh
    900           ; Retry
    604800        ; Expire
    86400         ; Minimum TTL
)
```

### PTR Record
Reverse DNS - maps an IP address to a domain name.
```
34.216.184.93.in-addr.arpa.    300    IN    PTR    example.com.
```

### CAA Record
Certificate Authority Authorization - specifies which CAs can issue certificates for a domain.
```
example.com.    300    IN    CAA    0 issue "letsencrypt.org"
```

---

## Resolution Process and Caching

### How DNS Resolution Works

```
1. User types "www.example.com" in browser
2. Browser checks its local cache
3. OS checks its resolver cache
4. Query goes to recursive resolver (ISP or configured DNS like 8.8.8.8)
5. Recursive resolver checks its cache
6. If not cached, queries root name server (.)
7. Root returns the .com TLD name servers
8. Recursive resolver queries .com TLD name server
9. TLD returns the authoritative name servers for example.com
10. Recursive resolver queries authoritative name server
11. Authoritative server returns the IP address for www.example.com
12. Response flows back through the chain, cached at each level
```

### Caching and TTL

**Time to Live (TTL)**
- Controls how long a DNS response is cached (in seconds)
- Low TTL (60-300s) - faster failover, more DNS queries
- High TTL (3600-86400s) - fewer queries, slower propagation of changes
- Before making DNS changes, lower the TTL in advance (at least 2x the old TTL before the change)

**Caching Layers**
1. Browser cache (Chrome: `chrome://net-internals/#dns`)
2. Operating system cache (`ipconfig /displaydns` on Windows, `resolvectl query` on Linux)
3. Recursive resolver cache (ISP or public resolver)
4. CDN and proxy caches

**Negative Caching**
- NXDOMAIN (non-existent domain) responses are also cached
- SOA minimum TTL controls negative caching duration
- Can cause issues when creating new records that were previously queried

---

## Cloud DNS Services

### AWS Route 53

**Key Features**
- Authoritative DNS and domain registration
- Public and private hosted zones
- Health checks with DNS failover
- ALIAS records for zone apex (resolve to AWS resources without CNAME penalty)
- Traffic Flow visual policy editor
- DNSSEC signing support

**Pricing**
- $0.50/month per hosted zone
- $0.40 per million queries (standard)
- Health checks: $0.50/month per endpoint

**Docs:** https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html

### Azure DNS

**Key Features**
- Authoritative DNS hosting (no domain registration)
- Public and private DNS zones
- Alias record sets for zone apex (point to Azure resources)
- Integration with Azure Traffic Manager for routing policies
- Azure Private DNS for VNet name resolution

**Pricing**
- $0.50/month per zone (first 25 zones)
- $0.40 per million queries

**Docs:** https://learn.microsoft.com/en-us/azure/dns/dns-overview

### GCP Cloud DNS

**Key Features**
- Authoritative DNS with 100% uptime SLA
- Public and private managed zones
- Forwarding zones (forward to on-premises DNS)
- Peering zones (resolve across VPC networks)
- DNSSEC support
- DNS policies for inbound/outbound resolution

**Pricing**
- $0.20/month per managed zone
- $0.40 per million queries

**Docs:** https://cloud.google.com/dns/docs/overview

---

## Routing Policies

### Simple Routing
Returns a single value (or multiple values in random order).
- Use for single-resource configurations
- All providers support this as the default behavior

### Weighted Routing
Distributes traffic based on assigned weights.
```
api.example.com -> Server A (weight: 70, 70% of traffic)
api.example.com -> Server B (weight: 30, 30% of traffic)
```
- Use for gradual traffic shifting (blue-green, canary deployments)
- AWS Route 53: Weighted routing policy
- Azure: Traffic Manager with weighted routing
- GCP: Cloud DNS with weighted round robin (WRR)

### Latency-Based Routing
Routes traffic to the region with the lowest latency from the user.
- AWS Route 53: Latency routing policy (measures latency from resolver to AWS regions)
- Azure: Traffic Manager with performance routing
- GCP: Not directly available in Cloud DNS (use Cloud Load Balancing instead)

### Geolocation Routing
Routes traffic based on the geographic location of the DNS resolver.
```
Users in Europe -> eu-west-1 endpoint
Users in Asia   -> ap-southeast-1 endpoint
Default         -> us-east-1 endpoint
```
- Must define a default record for unmatched locations
- AWS Route 53: Geolocation routing policy
- Azure: Traffic Manager with geographic routing
- GCP: Cloud DNS with geolocation routing

### Failover Routing
Routes to a primary resource, fails over to secondary on health check failure.
```
api.example.com -> Primary (active, health checked)
api.example.com -> Secondary (standby, used when primary fails)
```
- Requires health checks on the primary endpoint
- AWS Route 53: Failover routing policy
- Azure: Traffic Manager with priority routing
- GCP: Cloud DNS does not have native failover (use Cloud Load Balancing)

### Multivalue Answer Routing
Returns multiple IP addresses and health checks each one.
- Similar to simple routing but with health checks
- Unhealthy records are removed from responses
- Not a replacement for a load balancer - DNS does not account for load

---

## Private DNS Zones

### Purpose
- Resolve custom domain names within your cloud VPC/VNet without exposing them to the internet
- Override public DNS names with private IP addresses
- Service discovery within private networks

### AWS Route 53 Private Hosted Zones
```bash
aws route53 create-hosted-zone --name internal.example.com \
  --caller-reference $(date +%s) \
  --vpc VPCRegion=us-east-1,VPCId=vpc-xxxxxxxx \
  --hosted-zone-config PrivateZone=true
```
- Associated with one or more VPCs
- Can be shared across accounts using RAM (Resource Access Manager)
- Resolution order: private zone first, then public zone

### Azure Private DNS Zones
```bash
az network private-dns zone create --resource-group myRG --name internal.example.com
az network private-dns link vnet create --resource-group myRG \
  --zone-name internal.example.com \
  --name myVNetLink \
  --virtual-network myVNet \
  --registration-enabled true
```
- Auto-registration links automatically create DNS records for VMs in the VNet
- Can link to multiple VNets across subscriptions

### GCP Cloud DNS Private Zones
```bash
gcloud dns managed-zones create internal-zone \
  --dns-name internal.example.com. \
  --visibility private \
  --networks default
```
- Visible only to authorized VPC networks
- DNS peering allows cross-project resolution

### Split-Horizon DNS
Same domain name resolves differently from inside vs outside the network.
```
Public:  api.example.com -> 203.0.113.50 (public LB)
Private: api.example.com -> 10.0.1.50 (internal LB)
```
- Implemented by having both a public and private hosted zone for the same domain
- Private zone takes precedence for queries from within the VPC

---

## DNSSEC

### What is DNSSEC?

DNS Security Extensions provide authentication and integrity for DNS responses by digitally signing records.

**How It Works**
1. Zone owner generates key pairs (KSK and ZSK)
2. DNS records are signed with the ZSK (Zone Signing Key)
3. ZSK is signed with the KSK (Key Signing Key)
4. DS (Delegation Signer) record is published in the parent zone
5. Resolvers validate signatures up the chain of trust to the root

**Key Record Types**
- RRSIG - contains the digital signature for a record set
- DNSKEY - contains the public key used to verify signatures
- DS - delegation signer, published in parent zone
- NSEC/NSEC3 - proves non-existence of a record (prevents spoofing of NXDOMAIN)

### Cloud Provider Support

**AWS Route 53**
- Supports DNSSEC signing for public hosted zones
- Key management via KMS
- Docs: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html

**Azure DNS**
- DNSSEC support for public zones
- Docs: https://learn.microsoft.com/en-us/azure/dns/dnssec

**GCP Cloud DNS**
- DNSSEC signing for public managed zones
- Automatic key rotation
- Docs: https://cloud.google.com/dns/docs/dnssec

### DNSSEC Considerations
- Adds complexity to DNS management
- Larger DNS responses may cause issues with some firewalls
- Key rotation must be handled carefully to avoid outages
- Not all resolvers validate DNSSEC (but adoption is growing)
- DNSSEC does not encrypt DNS queries - use DNS over HTTPS (DoH) or DNS over TLS (DoT) for privacy

---

## Troubleshooting DNS

### Common Tools

```bash
# Query a specific record type
dig example.com A
dig example.com MX
dig example.com TXT

# Query a specific name server
dig @8.8.8.8 example.com A

# Trace the full resolution path
dig +trace example.com

# Reverse DNS lookup
dig -x 93.184.216.34

# Check all records
dig example.com ANY

# nslookup alternative
nslookup example.com
nslookup -type=MX example.com
```

### Common Issues
- **Propagation delays** - wait for old TTL to expire after changes
- **CNAME at zone apex** - use ALIAS/ANAME records instead
- **Missing glue records** - required when NS records point to names within the same zone
- **Circular CNAME** - CNAME pointing to another CNAME that loops back
- **Case sensitivity** - DNS names are case-insensitive, but some implementations are case-sensitive in unexpected places

---

## Additional Resources

- [Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Azure DNS Documentation](https://learn.microsoft.com/en-us/azure/dns/)
- [GCP Cloud DNS Documentation](https://cloud.google.com/dns/docs)
- [IANA Root Servers](https://www.iana.org/domains/root/servers)
- [DNS RFC 1035](https://datatracker.ietf.org/doc/html/rfc1035)
