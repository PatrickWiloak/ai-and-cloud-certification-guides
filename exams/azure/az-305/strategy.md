---
last-updated: 2026-05-03
---

# Azure Solutions Architect Expert (AZ-305) - Exam Strategy

## Format reminder

- 40-60 questions, 100 minutes
- Pass mark: 700 / 1000 (70%)
- Mix of multiple choice, multiple response, drag-and-drop, case studies (2-3 case studies, each with 4-7 questions about a single scenario)
- AZ-104 (Azure Administrator) is the prerequisite

## Top traps

1. **PHS vs PTA vs AD FS**: Microsoft strongly recommends PHS as the simplest. PTA when password sync is unacceptable. AD FS only when legacy compliance demands it - not the modern answer.

2. **Cosmos DB consistency levels**: Strong, Bounded Staleness, Session (default), Consistent Prefix, Eventual. Tested often. Strong = highest correctness, lowest availability; Eventual = highest availability, lowest correctness; Session = read-your-own-writes per session. Pick based on the question's correctness vs availability balance.

3. **Storage tier transitions**: Hot → Cool → Cold → Archive. Each has access frequency and rehydration latency tradeoffs. Lifecycle policy automates.

4. **Resource hierarchy**: Management Group → Subscription → Resource Group → Resource. Policy and RBAC apply at any level and inherit.

5. **Network designs**: Hub-spoke with VNet peering vs Virtual WAN. Virtual WAN is the modern multi-region answer; hub-spoke is for single-region or smaller topologies.

6. **VPN Gateway vs ExpressRoute**: VPN over internet (encrypted by default, lower bandwidth, lower SLA). ExpressRoute private (higher SLA, higher cost, MACsec for encryption on supported speeds).

7. **Azure SQL flavors**:
   - SQL Database (single DB or elastic pool, fully managed PaaS)
   - SQL Managed Instance (closest to on-prem SQL, supports SQL Agent, CLR, cross-DB queries)
   - SQL Server on Azure VM (IaaS, full control, BYOL)
   Pick by the customer's tolerance for managed vs control needs.

8. **Service tier selection** under Azure SQL:
   - DTU vs vCore: vCore is modern, more flexible, supports Hyperscale and Serverless
   - Hyperscale: 100 TB+, fast backups via snapshots
   - Serverless: pause when idle, pay per second active
   - Business Critical: in-memory OLTP, multi-AZ replicas

9. **Data factory vs Synapse vs Databricks**: Data Factory is orchestration. Synapse is the unified analytics platform (SQL pool, Spark pool, pipelines). Databricks is best-in-class Spark with MLflow.

10. **Key Vault vs Managed HSM**: Vault for most use cases (FIPS 140-2 Level 2). Managed HSM for FIPS 140-3 Level 3 (regulatory).

## Case study tactics

Each case study presents a fictitious company with requirements. Read the case study summary once, then for each question, jump back to the relevant section. Don't re-read everything per question. Common mistakes:

- Missing a constraint buried in "Existing Environment" (e.g., "all servers must remain on-prem until 2027")
- Ignoring "must minimize costs" or "must minimize administrative effort" qualifiers
- Picking a technically correct but more expensive answer when "cost-effective" is the criterion

## Time management

100 / ~50 = 2 min/question average. Case study questions are faster (you've already loaded context); standalone scenarios are slower. Pace: aim to be at the second case study by minute 60. Leave 10 min for review.

## When stuck

1. **Read the case study or question for the *deciding constraint*** - cost, time-to-deploy, RPO/RTO, on-prem dependency.
2. **Default to PaaS over IaaS** unless the question rules out PaaS.
3. **Default to Microsoft-recommended pattern** - Microsoft Cloud Adoption Framework + Well-Architected guidance is what AZ-305 tests.
4. **Eliminate deprecated/legacy answers** - AD FS, Azure Service Manager (classic), Resource Manager templates without Bicep references.

## Day-of logistics

100 min, ~50 questions: faster pace than AWS Pro exams. Bring two IDs. Online proctored: clear room.

## After

**Pass:** Cert valid 1 year (Microsoft moved to annual renewal). Renew via short online assessment (free).

**Fail:** Most failures cluster on Identity & Governance (~25%) or Business Continuity (~10-15%). Re-review Azure AD Connect modes, Cosmos DB consistency, ASR vs Backup distinction.

## AZ-305 patterns

- "Hybrid identity, no on-prem federation server" = Azure AD Connect with PHS or PTA
- "Global multi-write key-value" = Cosmos DB
- "Cheap interruptible compute" = Spot VMs
- "Private hybrid 10 Gbps" = ExpressRoute
- "DR for IaaS, RPO minutes" = Azure Site Recovery
- "Many subscriptions, consistent policy" = Management Groups + Azure Policy initiatives
- "Cheap rarely-accessed storage" = Blob Archive tier
- "Service mesh on AKS without code changes" = Istio add-on
- "Multi-region SQL with async replication" = Auto-failover groups
- "Encrypted private hybrid (high speeds)" = ExpressRoute with MACsec
