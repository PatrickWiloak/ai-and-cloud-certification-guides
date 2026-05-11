---
last-updated: 2026-05-08
exam-code: AIP-C01
exam-name: AWS Certified Generative AI Developer - Professional
---

# AWS Certified Generative AI Developer - Professional (AIP-C01) Fact Sheet

## Exam Overview

| Property | Value |
|----------|-------|
| **Exam Code** | AIP-C01 |
| **Exam Name** | AWS Certified Generative AI Developer - Professional |
| **Level** | Professional |
| **Duration** | 205 minutes |
| **Questions** | 85 total (65 scored + 10 unscored) |
| **Question Format** | Multiple choice (1 correct of 4) and multiple response (2+ correct of 5+) |
| **Passing Score** | 750 / 1000 (scaled) |
| **Cost** | $300 USD (50% discount voucher available for prior cert holders) |
| **Valid For** | 3 years |
| **Prerequisites** | None required, but Pro-tier difficulty |
| **Languages** | English |
| **Delivery** | Pearson VUE (online proctored or testing center) |
| **Scoring model** | Compensatory (overall pass; you don't need to pass each section separately) |

**Question scoring rules:**
- No penalty for guessing - **always answer every question**.
- Multiple-response questions are all-or-nothing - you must select **all** correct responses to get credit.
- Unscored questions are not identified during the exam.

**Official references:**
- [Exam page](https://aws.amazon.com/certification/certified-generative-ai-developer-professional/)
- [Exam guide PDF](https://d1.awsstatic.com/onedam/marketing-channels/website/aws/en_US/certification/approved/pdfs/docs-aip/AWS-Certified-Generative-AI-Developer-Pro_Exam-Guide.pdf)
- [Exam guide HTML overview](https://docs.aws.amazon.com/aws-certification/latest/ai-professional-01/ai-professional-01.html)

## Target Candidate

The target candidate should have:

- **2+ years** of experience building production-grade applications on AWS or with open-source technologies
- General AI/ML or data engineering experience
- **1+ year** of hands-on experience implementing GenAI solutions

### Recommended AWS knowledge

- AWS compute, storage, networking services
- AWS security best practices and identity management (IAM)
- AWS deployment and infrastructure as code (CloudFormation, CDK, Terraform)
- AWS monitoring and observability (CloudWatch, X-Ray)
- AWS cost optimization principles

### Job tasks **out of scope** for the candidate

- **Model development and training from scratch**
- **Advanced ML techniques** (math-heavy theory)
- **Data engineering and feature engineering** (deep Spark/Glue/EMR work)

If you don't already do these things in your day job, **don't try to learn them in a week**. The exam tests integrating FMs, not building them.

## Exam Domains and Weightings

| # | Domain | Weight |
|---|--------|--------|
| 1 | Foundation Model Integration, Data Management, and Compliance | **31%** |
| 2 | Implementation and Integration | **26%** |
| 3 | AI Safety, Security, and Governance | **20%** |
| 4 | Operational Efficiency and Optimization for GenAI Applications | **12%** |
| 5 | Testing, Validation, and Troubleshooting | **11%** |

### Domain 1: Foundation Model Integration, Data Management, and Compliance (31%)

Tasks (full breakdown in [Domain 1 deep-dive](notes/01-foundation-models-data-compliance.md)):
- **1.1** Analyze requirements and design GenAI solutions
- **1.2** Select and configure FMs (incl. fine-tuning, LoRA, Model Registry, lifecycle)
- **1.3** Implement data validation and processing pipelines for FM consumption
- **1.4** Design and implement vector store solutions
- **1.5** Design retrieval mechanisms for FM augmentation (RAG)
- **1.6** Implement prompt engineering strategies and governance for FM interactions

### Domain 2: Implementation and Integration (26%)

Tasks (full breakdown in [Domain 2 deep-dive](notes/02-implementation-integration.md)):
- **2.1** Implement agentic AI solutions and tool integrations
- **2.2** Implement model deployment strategies
- **2.3** Design and implement enterprise integration architectures
- **2.4** Implement FM API integrations
- **2.5** Implement application integration patterns and development tools

### Domain 3: AI Safety, Security, and Governance (20%)

Tasks (full breakdown in [Domain 3 deep-dive](notes/03-ai-safety-security-governance.md)):
- **3.1** Implement input and output safety controls
- **3.2** Implement data security and privacy controls
- **3.3** Implement AI governance and compliance mechanisms
- **3.4** Implement responsible AI principles

### Domain 4: Operational Efficiency and Optimization for GenAI Applications (12%)

Tasks (full breakdown in [Domain 4 deep-dive](notes/04-operational-efficiency-optimization.md)):
- **4.1** Implement cost optimization and resource efficiency strategies
- **4.2** Optimize application performance
- **4.3** Implement monitoring systems for GenAI applications

### Domain 5: Testing, Validation, and Troubleshooting (11%)

Tasks (full breakdown in [Domain 5 deep-dive](notes/05-testing-validation-troubleshooting.md)):
- **5.1** Implement evaluation systems for GenAI
- **5.2** Troubleshoot GenAI applications

## Technologies and Concepts (from the official guide)

These concepts may appear on the exam, in no particular order of importance:

- Retrieval Augmented Generation (RAG)
- Vector databases and embeddings
- Prompt engineering and management
- Foundation model (FM) integration
- Agentic AI systems
- Responsible AI practices
- Content safety and moderation
- Model evaluation and validation
- Cost optimization for AI workloads
- Performance tuning for AI applications
- Monitoring and observability for AI systems
- Security and governance for AI applications
- API design and integration patterns
- Event-driven architectures
- Serverless computing
- Container orchestration
- Infrastructure as code (IaC)
- CI/CD for AI applications
- Hybrid cloud architectures
- Enterprise system integration

## In-Scope AWS Services (from the official guide)

These services may appear on the exam. **Memorize the Machine Learning category** - that's where the bulk of testable detail lives.

### Machine Learning (highest priority)

- **Amazon Bedrock** - Managed FM access, the central service for this exam
- **Amazon Bedrock AgentCore** - Production runtime for AI agents (newer; secure agent execution)
- **Amazon Bedrock Knowledge Bases** - Managed RAG with vector store + retrieval
- **Amazon Bedrock Prompt Management** - Prompt template repository + versioning
- **Amazon Bedrock Prompt Flows** - No-code conditional/sequential prompt orchestration
- **Amazon Augmented AI (A2I)** - Human review workflows for ML predictions
- **Amazon Comprehend** - NLP: entities, sentiment, PII detection, topic modeling
- **Amazon Kendra** - Intelligent enterprise search; can be a retriever for RAG
- **Amazon Lex** - Conversational AI / chatbot builder
- **Amazon Q Business** - GenAI assistant for internal data
- **Amazon Q Business Apps** - Custom apps inside Q Business
- **Amazon Q Developer** - GenAI coding assistant
- **Amazon Rekognition** - Computer vision (image/video)
- **Amazon SageMaker AI** - End-to-end ML platform; hosts custom/fine-tuned models
- **Amazon SageMaker Clarify** - Bias and explainability
- **Amazon SageMaker Data Wrangler** - Data prep for ML
- **Amazon SageMaker Ground Truth** - Data labeling (incl. RLHF labeling)
- **Amazon SageMaker JumpStart** - Pre-built models and solution templates
- **Amazon SageMaker Model Monitor** - Drift detection in production
- **Amazon SageMaker Model Registry** - Model versioning and approval workflow
- **Amazon SageMaker Neo** - Compile models for edge/optimized inference
- **Amazon SageMaker Processing** - Pre/post-processing jobs
- **Amazon SageMaker Unified Studio** - Unified ML/data IDE
- **Amazon Textract** - Document OCR + structure extraction
- **Amazon Titan** - AWS-built FM family (text, embeddings, multimodal)
- **Amazon Transcribe** - Speech-to-text

### Application Integration
- Amazon AppFlow, AWS AppConfig, Amazon EventBridge, Amazon SNS, Amazon SQS, AWS Step Functions

### Compute
- AWS App Runner, Amazon EC2, AWS Lambda, AWS Lambda@Edge, AWS Outposts, AWS Wavelength

### Containers
- Amazon ECR, Amazon ECS, Amazon EKS, AWS Fargate

### Customer Engagement
- Amazon Connect

### Database
- Amazon Aurora (with **pgvector** for vector search), Amazon DocumentDB, Amazon DynamoDB (+ Streams), Amazon ElastiCache, Amazon Neptune, Amazon RDS

### Developer Tools
- AWS Amplify, AWS CDK, AWS CLI, AWS CloudFormation, AWS CodeArtifact, AWS CodeBuild, AWS CodeDeploy, AWS CodePipeline, AWS Tools and SDKs, AWS X-Ray

### Analytics
- Amazon Athena, Amazon EMR, AWS Glue, Amazon Kinesis, Amazon OpenSearch Service (with **Neural plugin** for vector search), Amazon QuickSight, Amazon MSK

### Management and Governance
- AWS Auto Scaling, AWS Chatbot, AWS CloudTrail, Amazon CloudWatch (+ CloudWatch Logs, CloudWatch Synthetics), AWS Cost Anomaly Detection, AWS Cost Explorer, Amazon Managed Grafana, AWS Service Catalog, AWS Systems Manager, AWS Well-Architected Tool

### Migration and Transfer
- AWS DataSync, AWS Transfer Family

### Networking and Content Delivery
- Amazon API Gateway, AWS AppSync, Amazon CloudFront, ELB, AWS Global Accelerator, AWS PrivateLink, Amazon Route 53, Amazon VPC

### Security, Identity, and Compliance
- Amazon Cognito, AWS Encryption SDK, IAM, IAM Access Analyzer, IAM Identity Center, AWS KMS, Amazon Macie, AWS Secrets Manager, AWS WAF

### Storage
- Amazon EBS, Amazon EFS, Amazon S3 (+ Intelligent-Tiering, Lifecycle policies, Cross-Region Replication)

## Out-of-Scope AWS Services (from the official guide)

Don't waste time studying these:

| Category | Out-of-scope services |
|----------|----------------------|
| Application Integration | Amazon MQ |
| Analytics | AWS Clean Rooms, AWS Data Exchange, Amazon DataZone, Amazon FinSpace |
| Blockchain | Amazon Managed Blockchain |
| Business Apps | Alexa for Business, Amazon Chime, AWS Wickr, WorkDocs, WorkMail |
| Cost Mgmt | AWS Budgets, Cost and Usage Report, RI reports, Savings Plans |
| Compute | AWS Batch, EC2 Image Builder, ECS/EKS Anywhere, Beanstalk, Lightsail, Local Zones, Serverless App Repository |
| Containers | App2Container, AWS Copilot, ROSA |
| Customer Engagement | Amazon SES |
| Database | Keyspaces, QLDB, Redshift, Timestream |
| Developer Tools | Cloud9, CloudShell, CodeGuru, CodeStar, Corretto |
| End-User Computing | AppStream 2.0, WorkLink, WorkSpaces, WorkSpaces Web |
| Frontend Web/Mobile | Device Farm, Location Service, Pinpoint |
| Game Dev | GameLift, Lumberyard |
| IoT | All IoT services |
| Mgmt & Governance | Console Mobile App, Health Dashboard, License Manager, Proton, Trusted Advisor |
| **Machine Learning** | DeepComposer, DeepRacer, DevOps Guru, **Forecast**, **Fraud Detector**, **Lookout** family (Equipment, Metrics, Vision), HealthLake, Monitron, Panorama |
| Media | All Elemental services, Interactive Video, Kinesis Video Streams, Nimble Studio |
| Migration | Application Discovery, Application Migration, CloudEndure, Migration Hub, Snow Family |
| Networking | App Mesh, Cloud Map, Direct Connect, Private 5G, Transit Gateway, VPN |
| Quantum | Amazon Braket |
| Robotics | AWS RoboMaker |
| Satellite | AWS Ground Station |

**Pay attention to the ML out-of-scope list**: the AIF-C01 (Foundational) covers some of these (Forecast, Fraud Detector, Lookout, etc.), but **AIP-C01 does not**. Don't carry over old study notes.

## Service short-name policy

The exam uses official short names for well-known services to reduce reading load. For example, "Amazon Simple Notification Service (Amazon SNS)" appears as **"Amazon SNS"**. There's a Help feature in the exam interface that lists short-name to full-name mappings for any service that appears with an abbreviation.

## Last-week pacing reminders

- **Read each domain note's "Exam tasks and skills" section first** - that's the verbatim official blueprint. If you can't explain a Skill in plain English with the AWS services it uses, study it.
- **Don't try to memorize service feature matrices.** The exam tests scenario understanding ("which service or pattern fits this requirement?"), not feature checklists.
- **Practice with timing**: 205 min / 85 questions = ~2.4 min per question average. Read the question first, then the choices.
- **For multiple-response questions, count the required number of correct answers** the question states. If it says "select TWO", select exactly two.
- **Eliminate distractors first**. Pro-level exams use plausible-sounding wrong answers - identifying obviously wrong ones is faster than picking the best of two reasonable ones.
