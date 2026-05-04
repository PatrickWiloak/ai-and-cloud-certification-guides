---
last-updated: 2026-05-03
---

# GCP Professional Cloud Architect (PCA) - Exam Scenarios

> Eight worked scenarios mirroring PCA question style. Illustrative, not real exam questions. PCA tests architecture trade-offs across compute, network, storage, data, security, and ops. The exam includes case studies (e.g., Mountkirk Games, EHR Healthcare) - questions reference fictional companies whose context constrains the right answer.

---

## Scenario 1 - Compute selection (Domain 1: Designing solutions)

A team needs to run 200 microservices on GKE with auto-scaling, mTLS between services, and managed certificate renewal. They want minimum operational overhead.

Which fits?

A. GKE Autopilot with Anthos Service Mesh add-on; Certificate Authority Service for managed cert lifecycle.
B. GKE Standard with manual Istio install; cert-manager for certs.
C. Compute Engine MIGs running each service.
D. Cloud Run for everything.

**Analysis**

A is right: Autopilot manages the control plane and node infra; Anthos Service Mesh (now Cloud Service Mesh) is the managed Istio with auto-injected mTLS. Certificate Authority Service handles cert lifecycle. B works but operational overhead is high. C is too low-level. D doesn't fit "200 microservices with mTLS between them" pattern.

**Answer:** A

**Key takeaway:** GKE Autopilot for least-ops K8s. Cloud Service Mesh for mTLS + observability. Certificate Authority Service for internal PKI.

---

## Scenario 2 - Hybrid connectivity (Domain 2: Managing solutions)

A company has on-prem datacenters and needs encrypted, private 10 Gbps connectivity to GCP with redundancy across two metros.

Which fits?

A. Two Dedicated Interconnects at two different metros; HA VPN over the Interconnect (or MACsec on Interconnect where supported); Cloud Router with BGP.
B. Single Dedicated Interconnect.
C. Cloud VPN over public internet at 5 Gbps.
D. Carrier Peering only.

**Analysis**

A is right: 99.99% requires Interconnects in two metros (or four-way redundancy for 99.99% with single metro). MACsec is supported on Dedicated Interconnect (newer feature) or HA VPN over Interconnect for encryption. Cloud Router with BGP for dynamic routing. B lacks redundancy. C is the public-internet path. D is for Google services (M-peering), not VPC connectivity.

**Answer:** A

**Key takeaway:** GCP hybrid: Dedicated Interconnect (private, dedicated, 10/100 Gbps) > Partner Interconnect (50 Mbps - 50 Gbps via SP) > HA VPN (over internet, 99.99% with 2 tunnels). MACsec for native encryption.

---

## Scenario 3 - Database for transactional global app (Domain 1)

A retailer needs a globally consistent, transactional database with horizontal scale-out, sub-second writes from anywhere, no vendor lock-in.

Which fits?

A. Cloud Spanner with multi-region configuration (us, eu, asia).
B. Cloud SQL for PostgreSQL with read replicas.
C. Firestore.
D. BigQuery.

**Analysis**

A is right: Spanner is globally consistent (TrueTime), strongly consistent transactions across regions, horizontal scale via splits. Multi-region config supports 99.999% availability with global writes. B doesn't horizontally scale or write globally. C is document store with regional or multi-region but eventual consistency on multi-region by default. D is analytics warehouse, not transactional.

**Answer:** A

**Key takeaway:** Spanner = globally consistent SQL. Pick when you need ACID across regions. Cloud SQL is regional, vertically scaled. Firestore is document, eventually consistent. BigQuery is OLAP.

---

## Scenario 4 - DR strategy (Domain 3: Ensuring solution success)

An app on GCE + Cloud SQL needs DR to a different region with RTO 1 hour, RPO 5 minutes.

Which fits?

A. Cloud SQL HA failover replica in primary region; cross-region read replica in DR region; instance templates + MIG in DR region scaled to 0; on disaster, promote read replica and scale up MIG.
B. Cloud SQL Backups only; restore on disaster.
C. Active-active across regions.
D. Single-region with daily snapshots.

**Analysis**

A is right: cross-region read replica gives < 5 min replication lag (RPO); promotion + MIG scale-up fits 1h RTO. B - backup restores blow the RTO. C is overkill (and complex). D doesn't meet RPO.

**Answer:** A

**Key takeaway:** GCP DR mapping: Cold (backups) → minutes-hours RTO; Warm (replica + small standby MIG) → minutes RTO; Hot (active-active) → near-zero RTO. Match to RPO/RTO.

---

## Scenario 5 - Cost optimization steady workload (Domain 1)

A SaaS runs 500 e2-standard-4 VMs 24/7 in us-central1 for 3 years. Highest discount with full flexibility within instance family.

Which fits?

A. 3-year Committed Use Discounts (CUDs) at the resource level (e2 family in us-central1) with autoscaling MIGs.
B. Sustained Use Discounts only (automatic).
C. Spot VMs.
D. Pay-as-you-go with daily shutdown.

**Analysis**

A is right: CUDs offer up to 57% discount for 3-year commitments at resource level; spend-based CUDs offer family flexibility. SUD is automatic but smaller discount. C - spot for steady prod is risky. D doesn't apply (24/7 workload).

**Answer:** A

**Key takeaway:** GCP discount hierarchy: Sustained Use (automatic, ~30%) < Committed Use Discounts (1-3 yr, up to 70% for memory-optimized) < Spot (preemptible, 60-91% off but interruptible).

---

## Scenario 6 - Multi-tenant data isolation in BigQuery (Domain 2)

A SaaS stores customer data in BigQuery. Each customer's data must be queryable by their team only.

Which fits?

A. Per-customer datasets with IAM at the dataset level; row-level security if customers share datasets; column-level security with policy tags via Data Catalog for sensitive fields.
B. Single shared table with customer_id column; trust app-layer authorization.
C. One BigQuery project per customer.
D. Cloud SQL instead of BigQuery.

**Analysis**

A is right: dataset-level IAM is the standard isolation; row-level and column-level security let you have a shared table with per-row access if needed. Policy tags on columns enforce data masking at query time. B is no isolation. C is over-engineered (project explosion at thousands of customers). D abandons the analytics tool.

**Answer:** A

**Key takeaway:** BigQuery isolation: dataset IAM (default) > row-level access policies > column-level policy tags. Per-project per customer is rare and only for highest compliance.

---

## Scenario 7 - Service mesh and zero trust (Domain 3)

A company wants zero-trust between microservices on GKE: every service-to-service request authenticated, authorized per-call, encrypted.

Which fits?

A. Cloud Service Mesh with workload identity, mTLS everywhere, AuthorizationPolicy for fine-grained allow/deny.
B. NetworkPolicies in K8s only.
C. Istio installed manually.
D. App-layer JWT only.

**Analysis**

A is right: Cloud Service Mesh (managed Istio) is the GCP-native answer for zero-trust between services. Workload Identity binds K8s service accounts to GCP service accounts. mTLS is auto-injected. AuthorizationPolicy enforces per-call authz. B is L4 only. C manual Istio works but not the managed answer. D is partial.

**Answer:** A

**Key takeaway:** GKE service mesh = Cloud Service Mesh. Workload Identity for GCP-resource access. AuthorizationPolicy for service-to-service.

---

## Scenario 8 - Multi-region serverless app (Domain 1)

A consumer app on Cloud Run needs global users to hit the nearest region with low latency, automatic failover, and a single endpoint URL.

Which fits?

A. Cloud Run services in multiple regions; Global External HTTPS Load Balancer with serverless NEGs as backends; Cloud CDN in front for static.
B. One Cloud Run service in us-central1 with Cloud CDN.
C. Three independent Cloud Run services with separate URLs and DNS round-robin.
D. App Engine Flex.

**Analysis**

A is right: Global External HTTPS LB with serverless NEGs is the canonical multi-region Cloud Run pattern. The LB does anycast IP, geo-routing, automatic failover. Cloud CDN caches static. B has single-region latency. C lacks unified URL and clean failover. D is legacy and doesn't address the question better than Cloud Run.

**Answer:** A

**Key takeaway:** Multi-region Cloud Run = Global LB with serverless NEGs. The same pattern works for App Engine, GKE, and Compute Engine backends.
