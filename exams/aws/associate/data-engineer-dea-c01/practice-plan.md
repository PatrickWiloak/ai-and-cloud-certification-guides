# DEA-C01 - 8-Week Practice Plan

This plan assumes 2-3 hours per day of focused study, 5-6 days per week. Adjust pacing based on your background. If you held DAS-C01 or DBS-C01, compress to 4-5 weeks by skipping topics you're already strong on.

---

## Week 1 - Foundations and Domain 1A (Ingestion)

### Goals
- Solid mental model of the four exam domains
- Comfortable with all ingestion services

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim, return to it weekly
- [ ] [notes/01-data-ingestion.md](./notes/01-data-ingestion.md) deep read
- [ ] [Official Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-data-engineer-associate/AWS-Certified-Data-Engineer-Associate_Exam-Guide.pdf)

### Hands-on
- [ ] Build: Kinesis Data Firehose → S3 (Parquet) → Glue Crawler → Athena
- [ ] Build: Producer Python script → KDS → Lambda consumer logging to CloudWatch
- [ ] Read AWS docs: Kinesis Data Streams, Firehose, MSK, DMS

### Self-check
- [ ] Can I list when to pick KDS vs Firehose vs MSK?
- [ ] Can I describe full-load + CDC with DMS end-to-end?
- [ ] Can I configure Firehose to convert JSON to Parquet?

---

## Week 2 - Domain 1B (Transformation and Orchestration)

### Reading
- [ ] [notes/02-data-transformation.md](./notes/02-data-transformation.md) deep read
- [ ] AWS Glue ETL programming guide
- [ ] Step Functions developer guide

### Hands-on
- [ ] Build: Glue ETL job that joins three S3 tables, writes Iceberg, uses job bookmarks
- [ ] Build: Step Functions workflow orchestrating two Glue jobs with retries and a Catch state
- [ ] Compare: same workload in Glue Studio vs Glue notebook vs Glue script

### Self-check
- [ ] When do I use DynamicFrame vs DataFrame?
- [ ] When do I pick EMR Serverless vs EMR on EC2 vs Glue?
- [ ] When do I use Step Functions Standard vs Express?
- [ ] When do I use MWAA over Step Functions?

---

## Week 3 - Domain 2A (S3 + Lakehouse)

### Reading
- [ ] [notes/03-data-stores.md](./notes/03-data-stores.md) - sections on S3, Iceberg, Hudi, Delta
- [ ] S3 storage classes and lifecycle docs
- [ ] Athena Iceberg docs

### Hands-on
- [ ] Configure S3 lifecycle policy for hot/warm/cold tiering
- [ ] Build: convert a JSON dataset to Parquet with Athena CTAS, partition by date
- [ ] Build: an Iceberg table on S3 with Athena, do a time-travel query
- [ ] Use Athena partition projection on a high-cardinality date partition

### Self-check
- [ ] What's the right storage class for daily-access logs older than 30 days?
- [ ] Why is Parquet faster and cheaper for analytics?
- [ ] What does Iceberg give me that plain Parquet doesn't?

---

## Week 4 - Domain 2B (Redshift + Operational Stores)

### Reading
- [ ] [notes/03-data-stores.md](./notes/03-data-stores.md) - sections on Redshift, RDS, DynamoDB
- [ ] Redshift Database Developer Guide (chapters on distribution and sort keys)
- [ ] DynamoDB best practices guide

### Hands-on
- [ ] Build: Redshift cluster, COPY 10 GB Parquet from S3, run analytical queries
- [ ] Try Redshift Serverless and compare cost characteristics
- [ ] Build: DynamoDB table with composite key, GSI, DynamoDB Streams → Lambda
- [ ] Try Aurora Zero-ETL to Redshift (if access)

### Self-check
- [ ] Can I describe Redshift distribution styles (EVEN, KEY, ALL) with examples?
- [ ] Can I tell when to use DynamoDB on-demand vs provisioned?
- [ ] Can I list every way to load Redshift (COPY, streaming, Auto Copy, Zero-ETL)?

---

## Week 5 - Domain 3 (Operations and Support)

### Reading
- [ ] [notes/04-data-operations.md](./notes/04-data-operations.md) deep read
- [ ] CloudWatch metrics and alarms docs
- [ ] Glue Data Quality docs

### Hands-on
- [ ] Build: CloudWatch Alarm on Glue job failure → SNS email
- [ ] Build: Glue Data Quality rule that fails the job if completeness < 95%
- [ ] Build: Athena workgroup with per-query data scan limit
- [ ] Use CloudWatch Logs Insights to debug a Lambda or Glue job error

### Self-check
- [ ] Can I list 5 ways to reduce Athena cost?
- [ ] Can I detect a Kinesis consumer lagging behind?
- [ ] Can I write a basic Logs Insights query?

---

## Week 6 - Domain 4 (Security and Governance)

### Reading
- [ ] [notes/05-security-governance.md](./notes/05-security-governance.md) deep read
- [ ] Lake Formation developer guide
- [ ] KMS developer guide (key policies, grants)
- [ ] Macie user guide

### Hands-on
- [ ] Build: S3 bucket with SSE-KMS using a customer-managed key
- [ ] Build: Lake Formation table with column-level grant excluding `ssn`
- [ ] Build: Lake Formation row-level filter so analyst sees only their region
- [ ] Run Macie scheduled job on a sample bucket

### Self-check
- [ ] Can I describe the IAM + Lake Formation layered permission model?
- [ ] Can I set up cross-account lake sharing without copying data?
- [ ] Can I enforce TLS-only access on an S3 bucket?

---

## Week 7 - Architecture Patterns and Integration

### Reading
- [ ] [notes/06-architecture-patterns.md](./notes/06-architecture-patterns.md) deep read
- [ ] [scenarios.md](./scenarios.md) - work through all scenarios
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) end to end

### Hands-on
- [ ] Build: end-to-end CDC pipeline (RDS Postgres → DMS → S3 → Glue → Iceberg → Athena)
- [ ] Build: Streaming pipeline (KDS → Flink → DynamoDB + Firehose → S3)

### Self-check
- [ ] Can I sketch each of the 7 architecture patterns from memory?
- [ ] Can I name 3 cost optimizations for each major service?

---

## Week 8 - Mock Exams and Weak-Area Drilldown

### Practice exams
- [ ] AWS official sample questions (at least 2 passes)
- [ ] [resources/practice-questions/aws-data-engineer-associate.md](../../../../resources/practice-questions/aws-data-engineer-associate.md)
- [ ] One paid practice exam (Tutorials Dojo, Whizlabs, or AWS Skill Builder Official Practice Exam)
- [ ] Score consistently 80%+ before scheduling the real exam

### Weak-area drilldown
- [ ] Identify 3-5 weakest domains/topics
- [ ] Re-read those notes
- [ ] Build a small lab targeting each weak area
- [ ] Re-test on questions specific to those topics

### Final review
- [ ] [strategy.md](./strategy.md) - exam day approach
- [ ] [scenarios.md](./scenarios.md) - second pass of all scenarios
- [ ] AWS Whitepapers: Data Analytics Lens (Well-Architected), Big Data Analytics Options on AWS

### Schedule the exam
- [ ] Book Pearson VUE testing center or online proctoring
- [ ] Confirm 130-minute slot
- [ ] Plan exam-day logistics (ID, quiet space if online)

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30 min | Read notes / fact-sheet section |
| 60 min | Hands-on build |
| 30 min | Practice questions on the day's topic |
| 15 min | Review the next day's plan |

---

## Stop signals (when you're ready)

You're ready to schedule the exam when **all** are true:

- [ ] You consistently score 80%+ on AWS official sample questions twice in a row
- [ ] You can sketch each of the 7 architecture patterns from memory
- [ ] You can describe domain weights (34/26/22/18) and your strongest/weakest of the four
- [ ] You can name the right service for each "exam trigger" line in the fact-sheet without looking
- [ ] You have hands-on built at least 5 of the 8 weekly labs
