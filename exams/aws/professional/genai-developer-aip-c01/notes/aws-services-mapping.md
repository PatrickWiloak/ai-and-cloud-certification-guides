# AWS Services Mapping (Reverse Index)

> **Service-by-service review.** For last-mile cramming, walk down this list and ensure you can answer "what would the exam test about this service?" for each.
>
> Organized by AWS in-scope category. Each entry: short description + the exam-relevant role it plays + which Domain(s) it shows up in.

## Machine Learning (the most-tested category)

### Amazon Bedrock
- **What**: Managed access to foundation models from multiple providers (Anthropic, AI21, Cohere, Meta, Mistral, Stability, Amazon Titan/Nova). The central service for this exam.
- **Exam roles**: model invocation (InvokeModel, Converse), streaming (ConverseStream), batch inference, fine-tuning, continued pre-training, Provisioned Throughput, Cross-Region Inference, prompt caching.
- **Where tested**: Domains 1, 2, 3, 4, 5 (all).

### Amazon Bedrock AgentCore
- **What**: Production runtime for AI agents - secure execution, memory, identity, gateway, browser tool, code interpreter, observability.
- **Exam roles**: production-grade agent runtime when Bedrock Agents alone is insufficient.
- **Where tested**: Domain 2 (agentic).

### Amazon Bedrock Knowledge Bases
- **What**: Managed RAG - ingestion + chunking + embedding + vector store + retrieval.
- **Exam roles**: default RAG choice; Retrieve and RetrieveAndGenerate APIs; metadata filters; hybrid search; reranking; multimodal.
- **Where tested**: Domain 1 (1.4, 1.5), Domain 3 (grounding), Domain 4 (retrieval perf), Domain 5 (RAG eval).

### Amazon Bedrock Prompt Management
- **What**: Centralized prompt template repository with versioning and aliasing.
- **Exam roles**: parameterized templates, versions, approval workflows, A/B variants.
- **Where tested**: Domain 1 (1.6), Domain 3 (governance), Domain 4 (A/B testing), Domain 5 (versioning).

### Amazon Bedrock Prompt Flows
- **What**: Visual / no-code prompt orchestration with chains, branching, KB nodes, Lambda nodes.
- **Exam roles**: complex prompt systems, no-code workflows, conditional branching.
- **Where tested**: Domain 1 (1.6), Domain 2 (2.5).

### Amazon Augmented AI (A2I)
- **What**: Human review workflows for ML predictions.
- **Exam roles**: human-in-the-loop review, low-confidence escalation, in-production annotation.
- **Where tested**: Domain 2 (2.1.5), Domain 3 (transparency), Domain 5 (user-centered eval).

### Amazon Comprehend
- **What**: NLP service for entities, sentiment, key phrases, language detection, **PII detection**, custom classifiers.
- **Exam roles**: real-time PII detection in prompts, intent classification, pre-processing for FMs.
- **Where tested**: Domain 1 (1.3, 1.6), Domain 3 (3.1, 3.2, 3.4).

### Amazon Kendra
- **What**: Intelligent enterprise search with semantic understanding.
- **Exam roles**: enterprise-source retriever for RAG (alternative to vector DB), high-precision search with built-in connectors.
- **Where tested**: Domain 1 (1.4, 1.5).

### Amazon Lex
- **What**: Conversational chatbot builder with intents and slots.
- **Exam roles**: conversational front-end, slot filling, intent recognition, paired with Bedrock for free-form responses.
- **Where tested**: Domain 1 (1.6), Domain 2 (2.5).

### Amazon Q Business
- **What**: GenAI assistant for internal knowledge - connectors to enterprise sources (S3, SharePoint, Salesforce, ServiceNow, Confluence, etc.).
- **Exam roles**: no-code internal employee assistant; alternative to building custom RAG for enterprise data.
- **Where tested**: Domain 2 (2.5).

### Amazon Q Business Apps
- **What**: Build custom apps on top of Q Business (with custom prompts and actions).
- **Exam roles**: low-code GenAI apps over enterprise data.
- **Where tested**: Domain 2 (2.5).

### Amazon Q Developer
- **What**: GenAI assistant for developers - inline IDE suggestions, refactoring, AWS-aware code, transformation (Java upgrades, .NET porting).
- **Exam roles**: developer productivity, GenAI error pattern recognition for troubleshooting.
- **Where tested**: Domain 2 (2.5.4, 2.5.6).

### Amazon Rekognition
- **What**: Computer vision (object/face/text detection).
- **Exam roles**: image preprocessing for multimodal pipelines; metadata extraction.
- **Where tested**: Domain 1 (1.3 multimodal).

### Amazon SageMaker AI
- **What**: End-to-end ML platform; hosts custom and fine-tuned models on managed endpoints.
- **Exam roles**: deploy custom / open-source LLMs; fine-tuned models that don't fit Bedrock; hybrid solutions.
- **Where tested**: Domain 1 (1.2.4), Domain 2 (2.2).

### Amazon SageMaker Clarify
- **What**: Bias detection (data and model) and explainability.
- **Exam roles**: fairness evaluation in classical ML; bias drift monitoring.
- **Where tested**: Domain 3 (3.4).

### Amazon SageMaker Data Wrangler
- **What**: Interactive data prep for ML.
- **Exam roles**: data validation and prep before FM consumption (interactive flows).
- **Where tested**: Domain 1 (1.3).

### Amazon SageMaker Ground Truth
- **What**: Data labeling service (human + automated labeling, RLHF).
- **Exam roles**: labeling for fine-tuning datasets; annotation workflows.
- **Where tested**: Domain 2 (HITL), Domain 5 (annotation).

### Amazon SageMaker JumpStart
- **What**: Pre-built models and solution templates (popular open-source LLMs deployable in one click).
- **Exam roles**: quick deployment of open-source LLMs (Llama, Mistral, Falcon, etc.) on SageMaker.
- **Where tested**: Domain 2 (2.2).

### Amazon SageMaker Model Monitor
- **What**: Drift detection in production (data quality, model quality, bias drift, feature attribution drift).
- **Exam roles**: ongoing drift monitoring; pairs with Clarify for bias drift.
- **Where tested**: Domain 3 (3.3.4), Domain 4 (4.3).

### Amazon SageMaker Model Registry
- **What**: Model versioning + approval workflow.
- **Exam roles**: lifecycle management of fine-tuned/custom models; CI/CD with approval gates.
- **Where tested**: Domain 1 (1.2.4), Domain 3 (governance).

### Amazon SageMaker Neo
- **What**: Compile models for optimized / edge inference (across hardware targets).
- **Exam roles**: edge or cost-optimized inference; cross-environment deployment.
- **Where tested**: Domain 2 (2.3.4).

### Amazon SageMaker Processing
- **What**: Pre/post-processing jobs (data prep, model evaluation jobs).
- **Exam roles**: large-scale data transformation for FM consumption.
- **Where tested**: Domain 1 (1.3).

### Amazon SageMaker Unified Studio
- **What**: Unified ML/data IDE.
- **Exam roles**: single workspace for data + ML + GenAI development.
- **Where tested**: Domain 2 (developer experience).

### Amazon Textract
- **What**: Document OCR + structure extraction (forms, tables).
- **Exam roles**: document preprocessing for RAG / FM input; multimodal pipeline component.
- **Where tested**: Domain 1 (1.3 multimodal).

### Amazon Titan
- **What**: Amazon-built FM family (Titan Text, Titan Text Embeddings v2, Titan Multimodal Embeddings, Titan Image Generator).
- **Exam roles**: default first-party embedding model; multimodal embeddings; cost-effective text generation.
- **Where tested**: Domain 1 (1.5 embeddings), broader generation.

### Amazon Transcribe
- **What**: Speech-to-text (with custom vocabulary, speaker diarization).
- **Exam roles**: audio preprocessing for multimodal pipelines.
- **Where tested**: Domain 1 (1.3 multimodal).

---

## Application Integration

### Amazon AppFlow
- **What**: SaaS integration service (Salesforce, ServiceNow, Slack, Marketo, etc. → S3 / Redshift / etc.).
- **Exam roles**: ingest SaaS data into S3 for Knowledge Base ingestion.
- **Where tested**: Domain 2 (2.3 enterprise integration), Domain 1 (1.4 data sources).

### AWS AppConfig
- **What**: Application config management with feature flags, validators, gradual rollouts.
- **Exam roles**: dynamic model selection, prompt routing flags, parameter tuning without redeploy.
- **Where tested**: Domain 1 (1.2.2), Domain 2 (2.4.4 routing).

### Amazon EventBridge
- **What**: Serverless event bus.
- **Exam roles**: event-driven enterprise integration; trigger ingestion on S3 changes; auto-remediation on alarms.
- **Where tested**: Domain 1 (1.4.5 maintenance), Domain 2 (2.3 integration), Domain 4 (4.3 monitoring).

### Amazon SNS
- **What**: Pub/sub messaging.
- **Exam roles**: alarm notifications, approval workflow gates, fan-out.
- **Where tested**: Domain 4 (alerting), Domain 2 (approval).

### Amazon SQS
- **What**: Managed message queue.
- **Exam roles**: async FM invocation, batch embedding pipeline, decoupling.
- **Where tested**: Domain 2 (2.4 async).

### AWS Step Functions
- **What**: Serverless state machine / workflow orchestrator.
- **Exam roles**: agent orchestration (ReAct), circuit breaker, query transformation, document processing, approval workflows, custom evaluation pipelines.
- **Where tested**: Domain 1 (1.5, 1.6), Domain 2 (2.1, 2.2, 2.3, 2.5), Domain 5 (eval pipelines).

---

## Compute

### AWS App Runner
- **What**: Managed container app service.
- **Exam roles**: deploying GenAI apps without managing infrastructure.
- **Where tested**: Domain 2 (deployment).

### Amazon EC2
- **What**: Virtual servers.
- **Exam roles**: hosting custom inference (rare in this exam); MCP servers for stateful workloads via ECS/EKS instead.
- **Where tested**: Domain 2 (general).

### AWS Lambda
- **What**: Serverless functions.
- **Exam roles**: FM invocation glue, tool / action group implementations, prompt chains, retrieval orchestration, validators, MCP stateless tool servers, evaluators.
- **Where tested**: every domain.

### AWS Lambda@Edge
- **What**: Lambda at CloudFront edge locations.
- **Exam roles**: low-latency request processing at edge; rare for this exam.
- **Where tested**: Domain 2 (2.3.4 edge).

### AWS Outposts
- **What**: AWS infrastructure on-premises.
- **Exam roles**: hybrid AI for regulated data that can't leave premises.
- **Where tested**: Domain 2 (2.3.4 hybrid).

### AWS Wavelength
- **What**: AWS infrastructure inside telecom carrier networks (5G edge).
- **Exam roles**: ultra-low-latency edge AI use cases.
- **Where tested**: Domain 2 (2.3.4 edge).

---

## Containers

### Amazon ECR
- **What**: Container registry.
- **Exam roles**: store custom inference / agent / MCP server images.
- **Where tested**: Domain 2.

### Amazon ECS / Amazon EKS
- **What**: Container orchestration (ECS managed, EKS Kubernetes).
- **Exam roles**: stateful or heavy MCP servers; long-running agent workloads; custom inference deployments.
- **Where tested**: Domain 2 (2.1.7, 2.2).

### AWS Fargate
- **What**: Serverless container compute (with ECS or EKS).
- **Exam roles**: stateless / stateful container workloads without managing servers.
- **Where tested**: Domain 2 (deployment).

---

## Customer Engagement

### Amazon Connect
- **What**: Cloud contact center.
- **Exam roles**: GenAI-enhanced contact center (Bedrock + Lex + Connect).
- **Where tested**: Domain 2 (business systems).

---

## Database

### Amazon Aurora
- **What**: MySQL/PostgreSQL-compatible relational DB. **Aurora PostgreSQL with pgvector** for vector search.
- **Exam roles**: vectors next to relational data; SQL filtering combined with vector similarity.
- **Where tested**: Domain 1 (1.4, 1.5).

### Amazon DocumentDB
- **What**: MongoDB-compatible document DB. Vector search support.
- **Exam roles**: vector search if you already use Mongo APIs.
- **Where tested**: Domain 1 (1.4).

### Amazon DynamoDB (+ Streams)
- **What**: Serverless key-value / document DB. Streams expose change data.
- **Exam roles**: conversation history, session state, agent memory; metadata stores; change-driven ingestion via Streams.
- **Where tested**: Domain 1 (1.4, 1.6), Domain 2 (state).

### Amazon ElastiCache
- **What**: Managed Redis / Memcached. Redis with vector support.
- **Exam roles**: hot semantic cache, conversation hot history, fast retrievals.
- **Where tested**: Domain 4 (caching).

### Amazon Neptune
- **What**: Graph DB. **Neptune Analytics** supports vector search alongside graph queries.
- **Exam roles**: graph-RAG use cases (knowledge graphs with embeddings).
- **Where tested**: Domain 1 (1.4).

### Amazon RDS
- **What**: Managed relational DB (multiple engines).
- **Exam roles**: PostgreSQL with pgvector for vector search; data sources.
- **Where tested**: Domain 1 (1.4).

---

## Developer Tools

### AWS Amplify
- **What**: Front-end + backend deployment toolkit.
- **Exam roles**: declarative UI components for GenAI apps; rapid prototyping.
- **Where tested**: Domain 2 (2.5.2).

### AWS CDK / AWS CloudFormation
- **What**: Infrastructure as code.
- **Exam roles**: deploy GenAI stacks reproducibly; standardized components.
- **Where tested**: Domain 1 (1.1.3), Domain 2 (CI/CD).

### AWS CLI / SDK
- **What**: Command-line + programmatic AWS access.
- **Exam roles**: programmatic Bedrock invocation; Bedrock SDK exponential backoff.
- **Where tested**: Domain 2 (2.4 resilience).

### AWS CodeArtifact / CodeBuild / CodeDeploy / CodePipeline
- **What**: CI/CD services.
- **Exam roles**: end-to-end GenAI CI/CD with prompt eval gates, model deployment, rollback.
- **Where tested**: Domain 2 (2.3.5).

### AWS X-Ray
- **What**: Distributed tracing.
- **Exam roles**: end-to-end traces across API Gateway → Lambda → Bedrock; agent observability; troubleshooting latency.
- **Where tested**: Domain 2, 4, 5.

---

## Analytics

### Amazon Athena
- **What**: Serverless SQL over S3.
- **Exam roles**: querying logs, eval results, large structured datasets.
- **Where tested**: Domain 4 (analysis).

### Amazon EMR
- **What**: Managed big-data processing (Spark, Hive, Presto, Trino).
- **Exam roles**: large-scale data prep for FM consumption (rare in scope).
- **Where tested**: Domain 1 (1.3 limited).

### AWS Glue
- **What**: Serverless ETL + Data Catalog + Glue Data Quality.
- **Exam roles**: data validation (**Glue Data Quality**), data lineage tracking, data catalog for source attribution.
- **Where tested**: Domain 1 (1.3), Domain 3 (3.3 lineage).

### Amazon Kinesis
- **What**: Real-time streaming.
- **Exam roles**: streaming ingestion for real-time RAG updates; rare here.
- **Where tested**: Domain 1 (data pipelines).

### Amazon OpenSearch Service
- **What**: Managed Elasticsearch / OpenSearch with k-NN plugin and **Neural plugin** for direct Bedrock embedding integration.
- **Exam roles**: vector search at scale; hybrid search; Bedrock KB backing store; full-text + vector together.
- **Where tested**: Domain 1 (1.4, 1.5), Domain 4 (perf).

### Amazon QuickSight
- **What**: BI / dashboarding.
- **Exam roles**: business-stakeholder reporting; rarely picked over CloudWatch / Grafana for ops.
- **Where tested**: Domain 4 (reporting), Domain 5.

### Amazon Managed Streaming for Apache Kafka (Amazon MSK)
- **What**: Managed Kafka.
- **Exam roles**: enterprise event streaming integration.
- **Where tested**: Domain 2 (integration).

---

## Management and Governance

### AWS Auto Scaling
- **What**: Auto scaling for many AWS resources (EC2, ECS, Lambda concurrency, SageMaker endpoints, DynamoDB, etc.).
- **Exam roles**: scaling SageMaker endpoints, DynamoDB capacity, ECS services.
- **Where tested**: Domain 4 (4.1.3, 4.2.5).

### AWS Chatbot
- **What**: ChatOps integration with Slack and Microsoft Teams for AWS notifications.
- **Exam roles**: notify on alarms; trigger chat-based remediation.
- **Where tested**: Domain 4 (alerting).

### AWS CloudTrail
- **What**: API call audit log.
- **Exam roles**: who-called-what audit; **Bedrock data events** for per-invocation audit.
- **Where tested**: Domain 1 (1.6 audit), Domain 3 (3.3 audit), Domain 4 (4.3).

### Amazon CloudWatch / CloudWatch Logs / CloudWatch Synthetics
- **What**: Monitoring service - metrics, logs, alarms, dashboards, anomaly detection, synthetics canaries, Logs Insights queries.
- **Exam roles**: GenAI ops metrics (token usage, latency, errors), prompt analysis, anomaly detection, synthetic monitoring of prompts.
- **Where tested**: Domain 3 (3.3.4), Domain 4 (4.3 entire), Domain 5 (5.2.5).

### AWS Cost Anomaly Detection
- **What**: Automatic detection of unusual cost / usage patterns.
- **Exam roles**: catch runaway agents / cost spikes; trigger remediation.
- **Where tested**: Domain 4 (4.1, 4.3).

### AWS Cost Explorer
- **What**: Visualize and analyze AWS spend.
- **Exam roles**: cost analysis by tag (per-team, per-tenant, per-prompt-template).
- **Where tested**: Domain 4 (4.3).

### Amazon Managed Grafana
- **What**: Managed Grafana for cross-source dashboards.
- **Exam roles**: rich operational dashboards combining CloudWatch + Prometheus + other sources.
- **Where tested**: Domain 4 (4.3 reporting).

### AWS Service Catalog
- **What**: Catalog of approved IT/cloud products.
- **Exam roles**: publish standardized GenAI patterns / templates for self-service compliance.
- **Where tested**: Domain 1 (1.1.3), Domain 3 (3.3 governance).

### AWS Systems Manager
- **What**: Operations services (Parameter Store, Run Command, Sessions Manager, etc.).
- **Exam roles**: Parameter Store for storing model IDs, prompt template references, configuration.
- **Where tested**: Domain 1 (1.2.2 dynamic config) - though AppConfig is preferred.

### AWS Well-Architected Tool
- **What**: Tool for reviewing workloads against the Well-Architected Framework, including the **Generative AI Lens**.
- **Exam roles**: design-time review; standardized component validation.
- **Where tested**: Domain 1 (1.1.3).

---

## Migration and Transfer

### AWS DataSync
- **What**: Data transfer service (NFS, SMB, S3, Azure Blob, GCS, HDFS, etc.).
- **Exam roles**: land enterprise file data in S3 for KB ingestion.
- **Where tested**: Domain 1 (1.4 connectivity).

### AWS Transfer Family
- **What**: Managed SFTP, FTPS, FTP, AS2 endpoints into S3.
- **Exam roles**: legacy file-based integrations into S3 for KB ingestion.
- **Where tested**: Domain 1 (1.4), Domain 2 (2.3 enterprise integration).

---

## Networking and Content Delivery

### Amazon API Gateway
- **What**: Managed API gateway (REST, HTTP, WebSocket).
- **Exam roles**: front-door for GenAI APIs; auth, rate limiting, request validation, transformations, WebSocket streaming.
- **Where tested**: Domain 1, 2, 3, 4 (all).

### AWS AppSync
- **What**: Managed GraphQL service.
- **Exam roles**: real-time subscriptions for streaming AI responses.
- **Where tested**: Domain 2 (2.4.2 streaming).

### Amazon CloudFront
- **What**: CDN.
- **Exam roles**: edge caching for public GenAI endpoints; AWS WAF integration.
- **Where tested**: Domain 4 (caching), Domain 3 (WAF).

### Elastic Load Balancing (ELB)
- **What**: Load balancers (ALB, NLB, GWLB).
- **Exam roles**: load balance custom inference / agent containers.
- **Where tested**: Domain 2.

### AWS Global Accelerator
- **What**: Global static IP front for AWS services.
- **Exam roles**: lower-latency global routing to GenAI endpoints.
- **Where tested**: Domain 2.

### AWS PrivateLink
- **What**: Private connectivity to AWS services via VPC endpoints.
- **Exam roles**: **Bedrock VPC endpoints**, SageMaker VPC endpoints; keep traffic off public internet.
- **Where tested**: Domain 3 (3.2.1), Domain 4 (latency).

### Amazon Route 53
- **What**: DNS service.
- **Exam roles**: custom domains for GenAI APIs, health-check-based failover.
- **Where tested**: Domain 2.

### Amazon VPC
- **What**: Virtual network.
- **Exam roles**: network isolation; VPC endpoints for Bedrock; secure GenAI deployments.
- **Where tested**: Domain 3 (3.2.1).

---

## Security, Identity, and Compliance

### Amazon Cognito
- **What**: User authentication (User Pools + Identity Pools).
- **Exam roles**: end-user auth for GenAI apps; federated identities for AWS resource access.
- **Where tested**: Domain 2 (2.3.3), Domain 3 (3.2.1).

### AWS Encryption SDK
- **What**: Client-side encryption library.
- **Exam roles**: encrypt sensitive data before sending to Bedrock or storing.
- **Where tested**: Domain 3 (3.2).

### IAM (and IAM Access Analyzer, IAM Identity Center)
- **What**: Identity and access management.
- **Exam roles**: least-privilege roles for Lambda / agents; tag-based ABAC for tenancy; identity federation; cross-account / public access detection.
- **Where tested**: Domain 2 (2.3.3), Domain 3 (3.2 entire).

### AWS KMS
- **What**: Key management for encryption.
- **Exam roles**: customer-managed keys for fine-tuned model artifacts, KB data, S3 logs.
- **Where tested**: Domain 3 (3.2).

### Amazon Macie
- **What**: PII / sensitive data discovery in S3 (at rest).
- **Exam roles**: scan training data, KB sources, log buckets for PII.
- **Where tested**: Domain 3 (3.2.2).

### AWS Secrets Manager
- **What**: Secrets storage with rotation.
- **Exam roles**: third-party API keys for tools; database creds; never embed in prompts.
- **Where tested**: Domain 3 (3.2).

### AWS WAF
- **What**: Web app firewall.
- **Exam roles**: protect public GenAI endpoints from L7 attacks; rate limiting; basic injection patterns.
- **Where tested**: Domain 3 (3.1.4 defense in depth).

---

## Storage

### Amazon EBS
- **What**: Block storage for EC2.
- **Exam roles**: SageMaker / EC2 inference disks.
- **Where tested**: Domain 2 (rare).

### Amazon EFS
- **What**: Managed NFS file system.
- **Exam roles**: shared model artifacts across instances; Lambda + EFS for large dependencies.
- **Where tested**: Domain 2 (rare).

### Amazon S3 (Intelligent-Tiering, Lifecycle, Cross-Region Replication)
- **What**: Object storage.
- **Exam roles**: KB source documents; prompt template storage; Bedrock Model Invocation Logs destination; eval data; cost optimization via tiering / lifecycle.
- **Where tested**: every domain.

---

## Out-of-scope reminder

Don't waste time studying these for AIP-C01:

- **ML services NOT in scope**: DeepRacer, DeepComposer, DevOps Guru, Forecast, Fraud Detector, Lookout for Equipment / Metrics / Vision, HealthLake, Monitron, Panorama
- **Compute NOT in scope**: Batch, Beanstalk, Lightsail, Snow Family
- **Database NOT in scope**: Redshift, Timestream, Keyspaces, QLDB
- **Other not in scope**: SES, IoT family, GameLift, Braket, all media services, Direct Connect, Transit Gateway

---

## Last-mile crash review checklist

Walk this list. For each, you should be able to give a 30-second answer to "what does it do and when would the exam use it?"

- [ ] Bedrock InvokeModel / Converse / streaming
- [ ] Bedrock Provisioned Throughput vs on-demand vs batch
- [ ] Bedrock Cross-Region Inference
- [ ] Bedrock fine-tuning + custom model + PT requirement
- [ ] Bedrock Knowledge Bases (connectors, chunking, embeddings, vector stores, hybrid, reranker, metadata filters)
- [ ] Bedrock Guardrails (six policy types, apply to input + output, ApplyGuardrail standalone)
- [ ] Bedrock Agents (action groups, KB assoc, Guardrails, traces, return of control, versions/aliases)
- [ ] Bedrock AgentCore (Runtime, Memory, Identity, Gateway, Browser, Code Interpreter, Observability)
- [ ] Bedrock Prompt Management (templates, versions, aliases, approval)
- [ ] Bedrock Prompt Flows (visual chains, branching, KB nodes, Lambda nodes)
- [ ] Bedrock Model Evaluation (automatic, human, LLM-as-Judge; single, multi-model, RAG)
- [ ] Bedrock Data Automation (PDF/image/audio/video → structured)
- [ ] Bedrock Model Invocation Logs (S3 + CloudWatch Logs)
- [ ] Strands Agents (open-source code-first SDK)
- [ ] AWS Agent Squad (open-source multi-agent orchestrator)
- [ ] MCP servers on Lambda (stateless) / ECS (stateful)
- [ ] SageMaker AI endpoints (real-time / async / serverless / batch / MME)
- [ ] SageMaker JumpStart, Neo, Model Registry, Model Monitor, Clarify, Ground Truth, Data Wrangler, Processing
- [ ] Amazon Comprehend (real-time PII)
- [ ] Amazon Macie (S3 at-rest PII discovery) - don't confuse with Comprehend
- [ ] Amazon Kendra as RAG retriever
- [ ] Amazon Q Business (employee assistant) vs Q Developer (developer assistant)
- [ ] Amazon Lex (slots + intents)
- [ ] OpenSearch (k-NN + Neural plugin), Aurora pgvector, Neptune Analytics, DocumentDB, ElastiCache Redis vector
- [ ] DynamoDB for state / conversation / metadata
- [ ] Step Functions for ReAct, circuit breaker, query transformation, agent orchestration
- [ ] Lambda for tool servers, validators, integration glue
- [ ] AppConfig for dynamic model selection / parameter tuning
- [ ] EventBridge for event-driven integration + auto remediation
- [ ] AppFlow, DataSync, Transfer Family (data ingestion)
- [ ] API Gateway (REST + WebSocket + auth + rate limit + transform)
- [ ] AppSync (GraphQL streaming)
- [ ] CloudFront + WAF (edge protection)
- [ ] X-Ray (distributed traces)
- [ ] CloudWatch (metrics, logs, alarms, dashboards, Synthetics, anomaly detection)
- [ ] CloudTrail data events for Bedrock
- [ ] Cost Anomaly Detection + Cost Explorer + tagging
- [ ] PrivateLink (Bedrock VPC endpoints)
- [ ] IAM (least privilege, ABAC tags, Identity Center federation)
- [ ] KMS, Secrets Manager
- [ ] Lake Formation (granular data access)
- [ ] Glue Data Catalog + Glue Data Quality + lineage
- [ ] AWS Well-Architected Generative AI Lens
- [ ] CAF-AI, GenAI Lifecycle Operational Excellence framework
