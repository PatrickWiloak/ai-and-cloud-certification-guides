---
last-updated: 2026-05-03
---

# Azure Solutions Architect Expert (AZ-305) - Exam Scenarios

> Eight worked scenarios mirroring AZ-305 question style. Illustrative, not real exam questions. AZ-305 tests architectural design across identity, governance, data, business continuity, and infrastructure. Questions often present a customer requirement set; you choose the design that *best* meets the constraints.

---

## Scenario 1 - Identity for hybrid workforce (Domain: Identity & Governance)

A company with 8,000 on-prem AD users wants single sign-on to Azure AD-integrated SaaS apps and Azure resources. They prefer not to expose on-prem AD federation servers to the internet.

Which fits?

A. Azure AD Connect with Pass-Through Authentication (PTA) and Seamless Single Sign-On.
B. Azure AD Connect with Password Hash Sync (PHS).
C. Azure AD Connect with AD FS federation.
D. Cloud-only Azure AD users; manual sync from AD.

**Analysis**

Both A and B avoid AD FS infrastructure. The difference: PHS replicates a hash of the password hash to Azure AD (online auth, simplest, recommended). PTA installs lightweight agents that validate against on-prem AD in real time (good when on-prem password policies must be enforced live, no password sync). The question mentions "prefer not to expose on-prem AD federation" which rules out C. PTA is more often the AZ-305 answer when the brief mentions "respect on-prem password policies" or "no password hash in cloud"; PHS is the answer when "simplest" is emphasized.

**Answer:** A or B depending on exact constraint wording (default A here for "no on-prem exposure beyond a lightweight outbound agent")

**Key takeaway:** Azure AD authentication options: PHS (simplest), PTA (no password sync, lightweight agents), AD FS (legacy, on-prem federation servers). AD FS is rarely the right modern answer.

---

## Scenario 2 - Database tier for global app (Domain: Data Storage)

A global app needs single-millisecond reads from any region, multi-region writes, key-value access pattern, and 99.999% availability.

Which fits?

A. Azure Cosmos DB with multi-region writes enabled.
B. Azure SQL Database with auto-failover groups.
C. Azure Database for PostgreSQL Flexible Server with read replicas.
D. Azure Cache for Redis Premium tier.

**Analysis**

A is right: Cosmos DB is purpose-built for global, multi-write, key-value (and document) access with the 99.999% SLA when multi-region writes are enabled. B has one write region only (failover groups). C - PostgreSQL replicas are read-only secondaries. D is a cache, not a primary store.

**Answer:** A

**Key takeaway:** Cosmos DB for global multi-write + sub-ms reads. Azure SQL / PostgreSQL / MySQL for relational with regional or read-only replicas.

---

## Scenario 3 - Cost-effective compute for batch (Domain: Compute)

A monthly data processing job runs 8 hours, can be interrupted and restarted, and processes 5 TB. Cost is the primary concern.

Which fits?

A. Azure Virtual Machine Scale Set with Spot priority and a maximum price; eviction policy "Deallocate."
B. Reserved Instance VMs purchased for 3 years.
C. Azure Container Instances on regular pricing.
D. Azure Functions on Consumption plan.

**Analysis**

A is right: Spot VMs cut compute cost 70-90%. The job is interruptible and restartable, the textbook fit for spot. B locks in 3 years of always-on cost for an 8-hour-per-month workload. C is convenient but doesn't have the discount. D - Functions has a 10-minute timeout on Consumption (Premium plan extends it but at higher cost).

**Answer:** A

**Key takeaway:** Azure compute pricing tiers: Pay-as-you-go (default), Reserved Instances (1-3 yr commit, 30-72%), Savings Plans (similar to AWS, more flexible), Spot (interruptible, 70-90% off), Hybrid Benefit (BYOL Windows / SQL).

---

## Scenario 4 - Hybrid network with Azure (Domain: Infrastructure)

A company needs private connectivity from on-prem to Azure with 10 Gbps bandwidth, encrypted, with redundancy.

Which fits?

A. Two ExpressRoute circuits at different peering locations with MACsec on the connections; Azure Virtual WAN as the hub.
B. Site-to-site VPN over the public internet.
C. Single ExpressRoute circuit.
D. Azure Bastion.

**Analysis**

A is right: ExpressRoute provides private (non-internet) connectivity; two circuits at different locations meet the redundancy ask; MACsec for encryption (where supported); Virtual WAN simplifies multi-region scale. B doesn't meet 10 Gbps reliably and is over the internet. C lacks redundancy. D is for management plane access, not site connectivity.

**Answer:** A

**Key takeaway:** Hybrid Azure connectivity: ExpressRoute (private, dedicated, 50 Mbps - 100 Gbps), VPN Gateway (over internet, 1.25 Gbps per tunnel), Virtual WAN (transit hub for multi-region/multi-site).

---

## Scenario 5 - Disaster recovery for IaaS (Domain: Business Continuity)

A multi-tier app on Azure VMs needs DR with RTO 1 hour, RPO 5 minutes, in a paired region.

Which fits?

A. Azure Site Recovery (ASR) replication of VMs to the paired region; recovery plans for orchestrated failover; periodic non-disruptive DR drills.
B. Azure Backup with cross-region restore.
C. Manually export VHDs to a storage account in the paired region.
D. Multi-region active-active.

**Analysis**

A is right: ASR is the Azure-native DR service for IaaS, supports VM replication with RPO ~30 seconds to ~5 minutes, recovery plans for orchestrated multi-VM failover, and DR drills without affecting production. B is for restore, not DR; Backup RPO is measured in hours/days. C is manual and not orchestrated. D is overkill.

**Answer:** A

**Key takeaway:** Azure DR products: ASR for IaaS replication + failover; Azure Backup for restore from snapshots; geo-redundant storage for data. ASR is the default DR pattern.

---

## Scenario 6 - Governance for many subscriptions (Domain: Identity & Governance)

A large org has 200 Azure subscriptions and needs consistent policy enforcement, mandatory tags, denied resource types in some scopes, and a clear hierarchy.

Which fits?

A. Management Groups hierarchy mirroring org structure; Azure Policy assigned at MG levels with policy initiatives; Resource Locks on critical resources.
B. Per-subscription Azure Policy assignments.
C. Azure Blueprints (deprecated path).
D. Custom Lambda-equivalent enforcement.

**Analysis**

A is right: Management Groups → subscriptions → resource groups gives the hierarchy; Azure Policy assigned at MG level applies to everything underneath; initiatives bundle related policies (e.g., security baseline). B is operationally heavy at 200 subs. C - Blueprints is being phased out (Microsoft recommends Template Specs + Policy now). D reinvents Azure Policy.

**Answer:** A

**Key takeaway:** Azure governance hierarchy: Management Groups → Subscriptions → Resource Groups → Resources. Apply Policy and RBAC at the right level (usually MG for breadth, RG for least privilege).

---

## Scenario 7 - Storage tier selection (Domain: Data Storage)

A media archive needs to store 500 TB of files accessed less than once per month, with retrieval within hours acceptable. Cost is critical.

Which fits?

A. Azure Blob Storage Archive tier with lifecycle management.
B. Azure Files Premium tier.
C. Azure Blob Storage Hot tier with reserved capacity.
D. Azure NetApp Files.

**Analysis**

A is right: Archive tier is the cheapest (~$0.001/GB/month), purpose-built for rarely accessed data; rehydration takes hours (3-15 hours for standard, 1-3 hours for high priority); lifecycle management automates tier transitions. B is for high-perf SMB shares. C costs ~10x more for the access pattern described. D is for high-perf NFS/SMB, premium pricing.

**Answer:** A

**Key takeaway:** Blob storage tiers: Hot (frequent access), Cool (>30 day, infrequent), Cold (>90 day), Archive (>180 day, hours to retrieve). Pick by access pattern + cost target.

---

## Scenario 8 - Microservices on AKS (Domain: Compute)

A team wants to run microservices on AKS with mTLS between services, automatic retries, circuit breaking, and observability without modifying app code.

Which fits?

A. AKS with Istio (or Linkerd) service mesh; managed via Azure Service Mesh add-on.
B. AKS with Application Gateway Ingress Controller (AGIC) only.
C. AKS with Azure Front Door.
D. AKS with custom proxy code in each service.

**Analysis**

A is right: service mesh is exactly designed for sidecar-injected mTLS, retries, circuit breaking, and observability without app changes. Azure has a native Istio add-on for AKS. B is for ingress, not east-west between services. C is global L7 routing, also ingress-only. D is the wrong answer to all "without modifying app code" requirements.

**Answer:** A

**Key takeaway:** Service mesh = sidecar-injected mTLS + retries + circuit breaking + tracing. AKS Istio add-on is the Azure-managed option. AGIC and Front Door are ingress-only.
