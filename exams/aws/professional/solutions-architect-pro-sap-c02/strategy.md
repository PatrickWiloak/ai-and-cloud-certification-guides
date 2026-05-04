---
last-updated: 2026-05-03
---

# AWS Solutions Architect Pro (SAP-C02) - Exam Strategy

> Cert-specific tactics. General study advice lives in [study-strategies.md](../../../../resources/study-strategies.md). This is what's different about SAP-C02.

## Format reminder

- 75 scored questions, 180 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response (mix of pick-1 and pick-N)
- ~2.4 minutes per question average; some scenarios are a half-page paragraph

## Time management math

180 min / 75 questions = **2.4 min per question** average. In practice:

- Easy / pattern-match questions (~20-25): 60-90 seconds each
- Medium scenarios (~30-40): 2-3 minutes each
- Hard / extended scenarios (~10-15): 4-5 minutes each

Plan to be at question 25 by the 60-minute mark and question 50 by 120 minutes. Reserve the final 30 minutes for flagged questions and review. **Always answer every question** - blank = wrong, guess + flag is strictly better.

## The top traps for THIS exam

1. **"Cost-effective" vs "least operational overhead"** - these are different criteria and the right answer differs. SAP-C02 questions explicitly say which one matters. Re-read the *last* sentence of the question; it usually contains the deciding criterion.

2. **Overly correct vs *most appropriate*** - several options will technically work. The exam tests your ability to pick the AWS-recommended pattern, which is usually managed services > self-managed, native services > third-party, and Control Tower / Organizations / Service Catalog over custom CloudFormation pipelines.

3. **Multi-account governance defaulting** - if a question mentions baseline guardrails, account factory, multi-account inheritance, mandatory tags, or "least operational overhead at scale," the answer is almost always Control Tower + SCPs + Config rules. Resist building it from primitives.

4. **DynamoDB vs Aurora vs RDS vs DocumentDB** - read the access pattern carefully. Single-key lookups at scale = DynamoDB. Joins / complex queries = relational. Key-value with multi-region active writes = DynamoDB Global Tables. The "obvious" SQL answer is sometimes the trap.

5. **Direct Connect + VPN combos** - lots of hybrid questions test the layered approach: DX for bandwidth + VPN as encrypted overlay, or MACsec for native encryption on supported DX speeds. Know the differences.

6. **Transit Gateway routing** - know how route tables on TGW direct traffic between VPC attachments; the "centralized inspection" pattern is heavily tested. Cloud WAN is starting to appear too.

7. **Migration tool selection**:
   - Heterogeneous DB migration with low downtime → SCT + DMS with CDC
   - Lift-and-shift servers → MGN (Application Migration Service)
   - Lift-and-shift databases (homogeneous) → DMS
   - Bulk one-time data transfer offline → Snow family
   - Bulk online transfer → DataSync
   - Don't mix these up.

8. **Pilot light vs warm standby boundary** - if the RTO is "tens of minutes to hour" and cost matters, pilot light. If RTO is "minutes" and cost matters less, warm standby. Active-active only when RTO/RPO are zero or near-zero.

## Common high-yield topics easy to miss

- AWS Resource Access Manager (RAM) for cross-account resource sharing (Transit Gateway, License Manager, Subnets)
- AWS Network Firewall vs Gateway Load Balancer (third-party appliance pattern)
- VPC endpoint types: Gateway (S3, DynamoDB - free) vs Interface (private link, ENI-based - hourly cost) vs Gateway Load Balancer endpoints
- Aurora Limitless Database, Aurora Serverless v2 capacity model
- AWS PrivateLink + VPC endpoint services (when you're the *provider*, not consumer)
- License-included vs BYOL on EC2 (Windows, Oracle, SQL Server) and dedicated host vs dedicated instance for licensing
- KMS key types: AWS-managed vs customer-managed vs imported vs CloudHSM-backed
- Lake Formation for fine-grained access on S3 data lake (cross-account cross-region)
- AWS Backup with cross-region cross-account vaults

## When you're stuck on a question

1. **Eliminate the wrong** - usually 1-2 options are clearly wrong. Down to 2-3.
2. **Read the last sentence again** - the criterion is there: cost / overhead / availability / RTO.
3. **Default to managed** - if two options work, the AWS-managed one wins.
4. **Default to native AWS** - third-party tools are valid but rarely the exam's answer unless explicitly named.
5. **Flag and move on** - don't burn 6 minutes on one question. Come back.

## Day-of logistics

- 180-minute exam: bring water, plan for one bathroom break (clock keeps running)
- Pearson VUE testing center: arrive 30 min early; have two government IDs
- Online proctored: clear your room of books/papers, single monitor, work surface clear; the proctor will have you do a 360° room scan
- The whiteboard / scratch paper at testing centers - don't rely on it; do mental math
- Pace check: at 60 min you should be at question 25; at 120 min question 50

## After the exam

**Pass:** wait 24-72h for the official email with score breakdown by domain. The Professional cert is valid 3 years; recert by passing again or earning a different Professional/Specialty.

**Fail:** AWS gives a domain-by-domain score band. Spend 2-3 weeks targeting the weak domain(s) specifically; you can retake after 14 days. Most failures are 720-740, very close - don't take 3 months off, regroup and retest in 4 weeks.

## SAP-C02 specific patterns to internalize

- "Designs a solution that..." → look for AWS-native, managed, low-overhead.
- "Existing solution has issue X..." → minimum-change answer that fixes the issue.
- "Migrate within X weeks..." → fastest tool that meets the constraint, not the most thorough.
- "Operationally efficient..." → managed services, infrastructure-as-code, automation.
- "Cost-effective..." → reserved capacity for steady, spot for fault-tolerant batch, serverless for spiky.

The cert rewards the candidate who has internalized AWS's prescriptive guidance, not the one who can build anything from primitives.
