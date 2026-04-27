# DEA-C01 - Exam Strategy

## Exam logistics

- **Duration:** 130 minutes
- **Questions:** 65 (50 scored + 15 unscored)
- **Pace target:** ~2 minutes per question. Slightly less if you want a buffer for review.
- **Format:** Multiple choice (one correct) and multiple response (two or three correct, marked).
- **Delivery:** Pearson VUE testing center or online proctoring.
- **Passing score:** 720 / 1000 (scaled).

---

## Three-pass approach

### Pass 1 - First sweep (90 minutes)

- Read each question carefully **once**.
- If you know the answer in <90 seconds, mark and move on.
- If you don't, **flag and skip**. Don't burn time on hard ones in pass 1.
- Aim to finish pass 1 in 90 minutes. That leaves 40 minutes for hard items.

### Pass 2 - Hard items (35 minutes)

- Return to flagged questions.
- For each, eliminate clearly wrong answers first.
- If two options remain, look for **specific qualifiers** in the prompt: "most cost-effective," "lowest latency," "least operational overhead," "fully managed."
- These qualifiers usually disambiguate.

### Pass 3 - Review (5 minutes)

- Skim all marked questions. Don't second-guess unless you spot a clear error.
- Trust your first instinct unless you find a concrete reason to change.

---

## Question-reading discipline

### Key qualifiers and their meanings

| Qualifier | Likely answer style |
|---|---|
| "Most cost-effective" | Lowest-cost option that meets requirements (Spot, lifecycle, columnar, partitioning) |
| "Lowest latency" | Sub-second answers (KDS, DynamoDB, DAX, ElastiCache) |
| "Least operational overhead" | Serverless / fully managed (Glue, Athena, Firehose, Lambda, Step Functions) |
| "Highly available" | Multi-AZ, replicas, auto-scaling, redundant writes |
| "Most secure" | Customer-managed KMS, VPC endpoints, least-privilege IAM |
| "Long-term archive" | Glacier Deep Archive |
| "Real-time" | KDS, Flink, Lambda |
| "Near-real-time" | Firehose (60s-15min), Lambda |

### Common traps

1. **Self-managed when serverless exists.** "Run Spark on EC2" is rarely the right answer when Glue or EMR Serverless solves the same problem.
2. **Plain Parquet when Iceberg is better.** Iceberg is the modern lakehouse default; if the question mentions ACID, schema evolution, or time travel, Iceberg is correct.
3. **Lambda for >15-minute jobs.** Lambda has a 15-minute hard cap. "Long-running ETL" rules it out.
4. **DAS-C01 / DBS-C01 services.** Some questions reference still-current services (Redshift, EMR) but watch for distractor answers using retired services.
5. **Mixing storage class with retrieval requirement.** Glacier Deep Archive cannot serve a "queries must complete in seconds" requirement.
6. **Confusing Gateway and Interface VPC endpoints.** S3 and DynamoDB are Gateway (free); everything else is Interface (paid).
7. **Misreading "must" vs "should."** "Must encrypt" rules out unencrypted options absolutely; "should be cost-effective" is a tiebreaker, not a hard requirement.

---

## Domain-specific tactics

### Domain 1 (34%) - Ingestion and Transformation

This domain has the most questions and the most service choices. Memorize the **decision flowchart** in [notes/06-architecture-patterns.md](./notes/06-architecture-patterns.md). Common confusions:

- KDS vs Firehose vs MSK - latency tier and management overhead
- Glue vs EMR vs Lambda - workload size and infra preference
- Step Functions vs MWAA - AWS-native vs Airflow-native

### Domain 2 (26%) - Data Stores

Memorize:

- Six S3 storage classes and their min-duration / retrieval characteristics
- Redshift: RA3 vs DC2 vs Serverless decision
- Iceberg vs Hudi vs Delta differentiation
- DynamoDB: on-demand vs provisioned, GSI vs LSI

### Domain 3 (22%) - Operations

Common patterns:

- CloudWatch alarm targets (Glue/EMR/Step Functions state metrics)
- Athena workgroup data limits
- Glue Data Quality with DQDL

### Domain 4 (18%) - Security and Governance

Smallest domain but precise. Memorize:

- IAM + Lake Formation layered model
- Encryption hierarchy (SSE-S3 / SSE-KMS / DSSE-KMS)
- VPC endpoints (Gateway = S3/DynamoDB, Interface = everything else)
- Lake Formation column / row / cell-level + LF-Tags

---

## Time management

- Don't spend more than 3 minutes on any single question. If you can't answer in 3, flag and move on.
- Watch the clock in 30-minute segments. After 30 minutes you should be at q15 or further.
- Plan to finish pass 1 with at least 30 minutes left.
- Save 5 minutes at the end for a final review of flagged items.

---

## What to do the day before

- **Don't cram.** Sleep matters more than another mock exam.
- Re-read the [fact-sheet.md](./fact-sheet.md) "Highest-yield study facts" section.
- Skim [notes/06-architecture-patterns.md](./notes/06-architecture-patterns.md) decision flowcharts.
- Confirm exam-day logistics (location, ID, time, online check-in process if remote).

---

## What to do the day of

### Online proctoring

- Quiet, well-lit room
- Clean desk - no notes, no second monitor
- Government-issued photo ID
- 30-minute buffer for check-in
- Stable internet (wired Ethernet preferred)

### Testing center

- Government-issued photo ID
- Arrive 30 minutes early
- Lockers usually available for personal items

### During the exam

- Read every word, especially the qualifier
- If two answers seem equally correct, the prompt has a tiebreaker - find it
- Don't change answers without a concrete reason
- Take a 30-second mental break at q33 (halfway)

---

## After the exam

- Score appears within minutes for online; same-day email for testing centers
- Detailed score report (pass/fail per domain) appears within 1-5 days
- If you fail, the score report tells you which domains were weakest - use that to plan a re-test (24-hour retake wait)

---

## Common reasons people fail

1. **Underestimating Domain 1 (34%)** - if Domain 1 is your weakest, you can't pass even if all others are strong.
2. **Surface-level Lake Formation knowledge** - row/column/cell + LF-Tags appear repeatedly.
3. **Confusing retired services with current services** - DAS-C01 vintage answers won't be correct.
4. **Skipping hands-on labs** - the exam is scenario-based; reading isn't enough.
5. **Cramming the night before** - you need fresh recall, not exhausted recognition.

Good luck. The DEA-C01 is one of the most useful current AWS Associate certs. Once you pass, look at SAA-C03 (architectural framing) and MLA-C01 (ML pipelines) as natural complements.
