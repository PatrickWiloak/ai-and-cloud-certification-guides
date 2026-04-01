# AWS Data Analytics Specialty (DAS-C01) Study Strategy

## Study Approach

### Phase 1: Foundation (Weeks 1-2)
1. **Data Collection** - Kinesis family (Streams, Firehose, Analytics), IoT Core, DMS
2. **Storage** - S3 storage classes, data formats (Parquet, ORC, Avro), partitioning
3. **Glue Fundamentals** - Crawlers, Data Catalog, ETL basics
- **[📖 Kinesis Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)**
- **[📖 Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)**

### Phase 2: Processing and Analysis (Weeks 3-4)
1. **EMR** - Spark, Hive, Presto - cluster configuration and optimization
2. **Glue ETL** - DynamicFrame, bookmarks, transforms, job types
3. **Redshift** - Distribution styles, sort keys, COPY, WLM, Spectrum
4. **Athena** - Cost optimization, federated queries, workgroups
5. **QuickSight** - SPICE, data sources, security (RLS, CLS)
- **[📖 EMR Management Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)**
- **[📖 Redshift Database Developer Guide](https://docs.aws.amazon.com/redshift/latest/dg/welcome.html)**

### Phase 3: Security and Integration (Week 5)
1. **Encryption** - KMS, SSE-S3, SSE-KMS, in-transit encryption
2. **Lake Formation** - Permissions model, LF-Tags, cross-account sharing
3. **VPC** - Endpoints, Enhanced VPC Routing, network isolation
4. **Orchestration** - Step Functions, Glue Workflows
- **[📖 Lake Formation Developer Guide](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)**
- **[📖 KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)**

### Phase 4: Exam Prep (Week 6)
1. Practice scenario-based questions
2. Review service selection decision trees
3. Focus on integration patterns between services
4. Take practice exams and review weak areas

## Recommended Resources

### Primary Resources
- **[AWS Skill Builder](https://skillbuilder.aws/)** - Official exam prep course
- **[AWS Data Analytics Specialty Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-data-analytics-specialty/AWS-Certified-Data-Analytics-Specialty_Exam-Guide.pdf)** - Official exam guide
- **[AWS Analytics Documentation](https://docs.aws.amazon.com/analytics/)** - Service documentation hub
- **[AWS Big Data Blog](https://aws.amazon.com/blogs/big-data/)** - Architecture patterns and best practices

### Hands-On Practice
- Build a streaming pipeline: Kinesis Data Streams - Firehose - S3 - Athena
- Create a Glue ETL job with crawlers and bookmarks
- Configure Lake Formation with column-level security
- Set up Redshift with Spectrum for data lake queries
- Deploy an EMR cluster with Spark and run a PySpark job

## Exam Tactics

### Keywords to Watch For
- "Real-time" + "load to destination" - Kinesis Data Firehose
- "Real-time" + "custom processing" - Kinesis Data Streams
- "Serverless ETL" - AWS Glue
- "Petabyte scale" + "Spark/Hive" - Amazon EMR
- "Ad-hoc SQL on S3" - Amazon Athena
- "Complex joins and aggregations" - Amazon Redshift
- "Full-text search" or "log analytics" - OpenSearch
- "Business dashboards" - Amazon QuickSight
- "Fine-grained access control" or "column-level" - Lake Formation
- "Encrypt" + "audit trail" - SSE-KMS (not SSE-S3)
- "Keep traffic in VPC" - VPC endpoints + Enhanced VPC Routing

### Common Pitfalls
- Kinesis Data Firehose has a minimum 60-second buffer - it is near real-time, not real-time
- Athena LIMIT clause does not reduce the amount of data scanned or cost
- Glue Crawlers discover schema - they do not transform data
- EMR core nodes store HDFS data - do not use Spot instances for core nodes
- Redshift COPY command is always preferred over INSERT for bulk loading
- Lake Formation works alongside IAM, not as a replacement
- S3 Select works on individual objects, not across a dataset

### Time Management
- 180 minutes for 65 questions - approximately 2.5 minutes per question
- Flag scenario questions that require analysis and return to them
- Eliminate clearly wrong answers first (usually 2 are obviously wrong)
- Look for the "most" correct answer - multiple options may seem valid

### Readiness Indicators
- [ ] You can explain when to use each Kinesis service
- [ ] You know S3 format tradeoffs (Parquet vs ORC vs Avro vs CSV)
- [ ] You understand Glue components and their interactions
- [ ] You can design EMR clusters with cost optimization
- [ ] You know Redshift distribution styles and sort key selection
- [ ] You can describe Lake Formation permission model
- [ ] You understand encryption options for each analytics service
- [ ] You score 75%+ consistently on practice exams
