# AWS Certified Machine Learning Engineer - Associate (MLA-C01)

## Exam Overview

The AWS Certified Machine Learning Engineer - Associate (MLA-C01) validates the ability to build, train, deploy, and maintain machine learning solutions using AWS services. This certification targets ML practitioners who implement production ML workloads.

**Exam Details:**
- **Exam Code:** MLA-C01
- **Duration:** 170 minutes
- **Number of Questions:** 65 scored questions
- **Question Types:** Multiple choice and multiple response
- **Passing Score:** 720 out of 1000 (approximately 72%)
- **Cost:** $150 USD
- **Delivery:** Pearson VUE testing center or online proctoring
- **Validity:** 3 years
- **Prerequisites:** None (1+ years ML experience recommended)

## Exam Domains

### Domain 1: Data Preparation for ML (28%)
- Ingest, transform, and validate data for ML workloads
- Feature engineering and feature stores
- Data quality assessment and handling

**Key Services:**
- Amazon SageMaker Data Wrangler
- Amazon SageMaker Feature Store
- AWS Glue / Glue DataBrew
- Amazon Athena
- Amazon S3

### Domain 2: ML Model Development (26%)
- Choose appropriate algorithms for business problems
- Train and tune ML models
- Evaluate model performance

**Key Services:**
- Amazon SageMaker Training Jobs
- SageMaker Built-in Algorithms (XGBoost, Linear Learner, BlazingText, etc.)
- SageMaker Autopilot
- SageMaker Experiments
- SageMaker Debugger
- Amazon Bedrock (foundation model fine-tuning)

### Domain 3: ML Model Deployment and Operations (22%)
- Deploy models to production endpoints
- Design inference architectures
- Implement CI/CD for ML pipelines

**Key Services:**
- SageMaker Endpoints (real-time, serverless, async)
- SageMaker Batch Transform
- SageMaker Pipelines
- SageMaker Model Registry
- AWS CodePipeline / CodeBuild
- AWS Lambda (lightweight inference)

### Domain 4: ML Solution Monitoring and Maintenance (24%)
- Monitor model performance in production
- Detect and address data/model drift
- Retrain and update models

**Key Services:**
- SageMaker Model Monitor
- Amazon CloudWatch
- SageMaker Clarify (bias detection, explainability)
- SageMaker Model Dashboard
- AWS CloudTrail

## Study Resources

- [**Fact Sheet**](fact-sheet.md) - Exam logistics and detailed domain breakdown
- [**Practice Plan**](practice-plan.md) - 6-week structured study schedule
- [**Data Preparation Notes**](notes/01-data-preparation.md) - Feature engineering, data wrangling
- [**Model Development Notes**](notes/02-model-development.md) - Training, algorithms, tuning

## Key Differences from MLS-C01 (ML Specialty)

| Aspect | MLS-C01 (Specialty) | MLA-C01 (Associate) |
|--------|---------------------|---------------------|
| **Level** | Specialty ($300) | Associate ($150) |
| **Focus** | Deep ML theory + AWS | Practical ML engineering on AWS |
| **Prerequisites** | 2+ years ML experience | 1+ year ML experience |
| **GenAI Content** | None (legacy exam) | Includes Amazon Bedrock, foundation models |
| **Status** | Retiring March 2026 | Active (recommended replacement) |

## Tips

- Focus on SageMaker — it dominates the exam
- Understand the full ML lifecycle: data prep → training → deployment → monitoring
- Know when to use built-in algorithms vs custom containers vs foundation models
- Practice with SageMaker Studio in the AWS Free Tier
