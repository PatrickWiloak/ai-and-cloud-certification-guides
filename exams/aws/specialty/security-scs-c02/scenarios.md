---
last-updated: 2026-05-03
---

# AWS Security Specialty (SCS-C02) - Exam Scenarios

> Eight worked scenarios mirroring SCS-C02 question style. Illustrative, not real exam questions. SCS-C02 tests AWS-specific security mechanisms (IAM, KMS, VPC, GuardDuty, Macie, etc.) at depth and incident response patterns. Questions often differentiate between "stops the attack now" vs "prevents recurrence."

---

## Scenario 1 - GuardDuty + automated response (Domain 1: 14%)

GuardDuty triggers an `UnauthorizedAccess:EC2/MaliciousIPCaller.Custom` finding for an EC2 instance making outbound calls to a known C2 IP. The SOC needs immediate isolation, snapshot for forensics, and a Slack notification.

Which fits with least operational overhead?

A. EventBridge rule on GuardDuty findings → Step Functions: ModifyInstanceAttribute (isolation SG) → CreateSnapshot → Slack webhook via Lambda.
B. AWS Systems Manager Incident Manager runbook triggered by EventBridge with the same actions.
C. Single Lambda invoked by EventBridge that does all three actions.
D. CloudWatch alarm + SNS to email; SOC manually responds.

**Analysis**

B is the most modern and operationally light - Incident Manager is purpose-built for this with native runbooks, retry logic, and post-incident reports. A is the second-best (Step Functions for orchestration). C works but doesn't separate concerns. D is manual.

**Answer:** B (or A if Incident Manager isn't an option)

**Key takeaway:** Modern AWS IR = Systems Manager Incident Manager. EventBridge → Step Functions is fine when Incident Manager isn't called out. One-big-Lambda is the third-best option.

---

## Scenario 2 - KMS encryption with cross-account key access (Domain 5: 18%)

A company encrypts S3 objects in account A with a customer-managed KMS key. Account B needs to read these objects via cross-account IAM role.

Which steps are required?

A. Add account B's principals to the KMS key policy with kms:Decrypt; account B's role policy must also allow kms:Decrypt; bucket policy must allow account B to s3:GetObject.
B. Add account B to the IAM trust policy of account A's key-creating role.
C. Make the KMS key public.
D. Enable cross-account replication.

**Analysis**

A is right: KMS keys require **both** the key policy (granting access from cross-account principals) **and** the IAM policy on the requesting principal (allowing kms:Decrypt). This is the dual-control model that's heavily tested. B confuses key access with role assumption. C is never the right answer for KMS. D is for replication, not read access.

**Answer:** A

**Key takeaway:** KMS cross-account access = key policy (in owning account) + IAM policy (in requesting account). Both required. Bucket policy gives S3 access; KMS policy gives decrypt access.

---

## Scenario 3 - VPC traffic inspection (Domain 3: 20%)

A regulated workload requires deep packet inspection, intrusion prevention, and TLS inspection of all egress traffic from production VPCs.

Which architecture fits?

A. AWS Network Firewall in a centralized inspection VPC with TLS inspection enabled (with appropriate certs); TGW routes all egress through the inspection VPC.
B. Security groups with stricter rules.
C. AWS WAF with managed rule sets attached to ALBs.
D. NACLs with deny rules for known bad IPs.

**Analysis**

A is right: AWS Network Firewall does stateful inspection, IPS, and (since 2023) TLS inspection. The centralized inspection VPC pattern is the AWS-recommended scale-out. B/D are L3/L4 only - no DPI. C is L7 HTTP/S inbound, not egress.

**Answer:** A

**Key takeaway:** Network Firewall = stateful + IDS/IPS + TLS inspection at VPC scale. WAF = HTTP/S rules at ALB / CloudFront / API Gateway. Security groups + NACLs = L3/L4 only.

---

## Scenario 4 - Sensitive data discovery (Domain 5: 18%)

A company stores millions of customer records in S3 across many buckets. They need ongoing discovery and classification of PII (SSN, credit card numbers, etc.) with alerting on findings.

Which fits?

A. Amazon Macie with sensitive data discovery jobs scheduled across the org; findings forwarded via EventBridge to Security Hub.
B. Custom Lambda using Comprehend on each S3 PutObject event.
C. AWS Glue DataBrew profiling jobs.
D. Manual code review.

**Analysis**

A is right: Macie is purpose-built for S3 PII / PCI / financial-data discovery, with managed identifier sets and ongoing scheduled jobs. EventBridge → Security Hub is the standard finding aggregation pattern. B works for new objects but not historical data, and reinvents Macie. C profiles data shape, not PII specifically. D doesn't scale.

**Answer:** A

**Key takeaway:** S3 PII / sensitive-data discovery = Macie. Custom-built solutions on Comprehend are wrong unless the question explicitly says "outside S3."

---

## Scenario 5 - Detecting compromised IAM credentials (Domain 1: 14%)

An IAM user's access keys are committed to a public GitHub repo. AWS detects this and quarantines the keys with the AWSCompromisedKeyQuarantineV2 policy. The SOC also gets a CloudWatch event.

What's the correct response sequence?

A. Rotate the leaked keys (deactivate old, create new), revoke active sessions via aws sts revoke-session, audit CloudTrail for any actions taken with the leaked keys, scan resources created in the audit window.
B. Just delete the user account.
C. Wait for AWS to fully clean it up.
D. Move to a new region.

**Analysis**

A is right: the standard playbook - rotate, revoke active sessions, audit, scan for backdoors / resources. The quarantine policy AWS applies blocks new high-risk actions but doesn't kill in-flight sessions or scrub artifacts. The audit step is required for a complete response. B kills the user but doesn't fix the larger compromise. C / D are not serious answers.

**Answer:** A

**Key takeaway:** Compromised credential response: rotate → revoke sessions → audit CloudTrail → check for artifacts. This is a sequence; you'll see questions test the right ordering.

---

## Scenario 6 - Bucket policy + SCP combination (Domain 4: 16%)

An organization wants to ensure that no S3 bucket in any account can be made public, even by an account admin.

Which fits?

A. Service Control Policy in AWS Organizations denying s3:PutBucketPolicy and s3:PutBucketAcl that grant public access; combined with S3 Block Public Access at the account level.
B. CloudWatch alarm on public buckets; manual remediation.
C. Bucket policy applied to every bucket.
D. AWS Config rule with auto-remediation.

**Analysis**

A is right: SCPs are evaluated *before* IAM and act as a guardrail that no action in the account can override - this is what stops even an admin from making a bucket public. S3 Block Public Access at the account level is the second layer. B is reactive. C requires per-bucket effort and admins can override. D is reactive.

**Answer:** A

**Key takeaway:** SCPs are preventive guardrails; admins cannot bypass them. AWS Config + auto-remediation is detective + corrective. Use both: SCPs to prevent, Config to verify.

---

## Scenario 7 - Logging at scale (Domain 2: 18%)

A multi-account org needs centralized, immutable, queryable storage of all CloudTrail events for 7 years for compliance.

Which fits?

A. Organization-level CloudTrail logging to a centralized S3 bucket in a log archive account; S3 Object Lock in compliance mode for immutability; lifecycle policy moving to Glacier Deep Archive after 90 days.
B. Per-account CloudTrail with each writing to its own bucket.
C. CloudWatch Logs with 7-year retention.
D. CloudTrail Lake with no S3 archive.

**Analysis**

A is right: organization trail centralizes, log archive account isolates, Object Lock compliance mode prevents deletion (even by root), Glacier Deep Archive cuts cost over 7-year retention. B doesn't centralize. C - CloudWatch Logs is expensive at this scale and 7-year retention. D - Lake is great for query but not the primary archival pattern.

**Answer:** A

**Key takeaway:** Organization CloudTrail + log archive account + S3 Object Lock + lifecycle to Glacier = the canonical immutable audit trail. Object Lock "compliance mode" is unbreakable; "governance mode" can be overridden by privileged users.

---

## Scenario 8 - Secrets in EKS workloads (Domain 5: 18%)

A team running on EKS needs database credentials, API keys, and JWT signing keys in their pods with rotation, audit, and least privilege.

Which fits?

A. AWS Secrets Manager + IAM Roles for Service Accounts (IRSA) for each pod's role; mount via Secrets Store CSI Driver with automatic rotation.
B. K8s Secrets stored in etcd, base64-encoded.
C. ConfigMap with passwords.
D. Hard-code in image, redeploy on rotation.

**Analysis**

A is right: Secrets Manager provides rotation + audit + least-privilege via IAM; IRSA gives each service account a unique IAM role; Secrets Store CSI Driver mounts secrets as files with periodic refresh. B is base64, not encryption (unless you've enabled etcd encryption explicitly with KMS, and even then K8s Secrets lack rotation). C is plaintext config. D is the worst.

**Answer:** A

**Key takeaway:** EKS secrets pattern = AWS Secrets Manager + IRSA + Secrets Store CSI. K8s Secrets in etcd is acceptable only with envelope encryption via KMS *and* you accept losing rotation/audit.
