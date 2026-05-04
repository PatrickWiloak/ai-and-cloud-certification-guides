---
last-updated: 2026-05-03
---

# AWS Security Specialty (SCS-C02) - Exam Strategy

> Cert-specific tactics. SCS-C02 is the most popular AWS Specialty by a large margin and the right cert for anyone in cloud security or DevSecOps.

## Format reminder

- 65 scored questions, 170 minutes
- Pass mark ~750 / 1000 (~75%)
- Multiple choice + multiple response

## Top traps

1. **Preventive vs Detective vs Corrective**: each control type is tested. SCP = preventive, Config rule = detective, Config auto-remediation = corrective. The question's wording usually telegraphs which one is wanted.

2. **KMS dual-control**: cross-account KMS access requires *both* the key policy granting access AND the IAM principal's policy allowing kms:Decrypt. Forgetting the IAM side is the classic trap.

3. **IAM evaluation logic**: explicit deny > explicit allow > implicit deny. SCPs evaluated first. Permissions boundary, IAM policy, resource policy, session policy - know how each constrains.

4. **GuardDuty finding sources**: VPC Flow Logs, CloudTrail management events, CloudTrail S3 data events, DNS logs, EKS audit logs (with EKS Protection), RDS Protection, Lambda Protection, Malware Protection. Know which feature enables which.

5. **Macie vs Inspector vs GuardDuty**:
   - Macie: S3 PII / sensitive-data discovery
   - Inspector: vulnerability scanning of EC2 / ECR / Lambda
   - GuardDuty: threat detection across logs
   Don't confuse them.

6. **CloudTrail layers**: management events (default), data events (S3 / Lambda / etc., extra cost), Insights events (anomalies), CloudTrail Lake (queryable archive).

7. **Secrets Manager vs Parameter Store**: Secrets Manager for rotation + cross-account + cross-region replication. Parameter Store for static config (free) or up to 10K secrets at SSM scale.

8. **Network Firewall vs WAF vs Shield**:
   - Network Firewall: stateful packet inspection, IPS, TLS inspection (since 2023), VPC level
   - WAF: HTTP/S layer 7 rules, attaches to ALB/CloudFront/API Gateway/AppSync
   - Shield Standard: free DDoS for everyone
   - Shield Advanced: paid, 24/7 DRT response, cost protection, near-real-time visibility

9. **Encryption types**:
   - SSE-S3: S3-managed keys (basic)
   - SSE-KMS: KMS-managed keys (auditable, IAM-controlled)
   - SSE-C: customer-provided keys (rare; you manage them)
   - DSSE-KMS: dual-layer SSE-KMS (compliance use cases)
   - Client-side: encrypted before upload

10. **VPC endpoint policies + KMS key policies + bucket policies**: questions often test the *combination* of all three needed for a specific access pattern.

## High-yield topics easy to miss

- AWS Verified Access (VPN-less zero-trust app access)
- IAM Identity Center (formerly SSO) for federated workforce identity
- IAM Roles Anywhere (X.509 cert-based AWS access for on-prem workloads)
- AWS Private CA (private certificate authority for internal TLS)
- AWS Certificate Manager + ACM PCA for cert lifecycle
- AWS Audit Manager (compliance evidence collection)
- AWS Security Hub: aggregates findings from GuardDuty, Macie, Inspector, IAM Access Analyzer, third-party
- IAM Access Analyzer: external access analyzer (resources accessible outside zone of trust) AND unused access analyzer (find unused permissions)
- AWS Detective: investigation/triage on findings using a graph of CloudTrail + VPC + GuardDuty
- AWS Firewall Manager: org-wide WAF / Network Firewall / Shield management

## Time management

170 / 65 = 2.6 min/question. Pace: Q20 by 50 min, Q40 by 100 min, Q65 by 160 min. Leave 10 min for flagged review. Many questions are pattern-match short; bank time for the longer "what should the SOC do first" sequences.

## When stuck

1. **Read the *control type* word in the question** - prevent, detect, alert, remediate. Each maps to different services.
2. **Default to managed AWS services** over custom Lambda glue when both work.
3. **Eliminate "manual" or "console" answers** - SCS-C02 favors automation.
4. **For multi-step IR questions, the *sequence* matters** - contain → investigate → eradicate → recover → lessons learned.

## Day-of logistics

170 min, 65 questions: standard pacing. Bring two IDs.

## After

**Pass:** Specialty cert valid 3 years.

**Fail:** Most failures are in Domain 5 (Identity and Access Management - 16%) or Domain 3 (Infrastructure Security - 20%). KMS / IAM trust policy / VPC endpoint trivia is the biggest miss area.

## SCS-C02 patterns

- "Prevent action across the org" = SCP
- "Detect non-compliant resources" = Config rule
- "Auto-remediate non-compliant" = Config auto-remediation
- "S3 PII discovery" = Macie
- "EC2 / ECR / Lambda vulnerability scan" = Inspector
- "Threat detection across logs" = GuardDuty
- "Aggregated findings" = Security Hub
- "Cross-account KMS" = key policy + IAM policy (both)
- "Centralized logging immutable" = Org CloudTrail + log archive account + S3 Object Lock
- "Compromised credential response" = rotate → revoke sessions → audit → scan
- "EKS secrets" = Secrets Manager + IRSA + CSI Driver
- "Inbound HTTP rules" = WAF
- "Egress / east-west DPI" = Network Firewall
- "DDoS response team + cost protection" = Shield Advanced
