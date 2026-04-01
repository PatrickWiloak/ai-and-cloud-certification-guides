# MLA-C01 Study Strategy

## Study Approach

### Phase 1: Foundation (3-4 weeks)
1. **ML Engineering Fundamentals**
   - Review ML lifecycle: data prep, training, deployment, monitoring
   - Understand supervised, unsupervised, and deep learning approaches
   - Learn AWS ML service landscape and when to use each

2. **SageMaker Core Services**
   - Focus on SageMaker Studio as the development environment
   - Master data preparation with Data Wrangler and Processing
   - Understand Feature Store for feature management
   - Learn Glue ETL for data transformation

### Phase 2: Model Development and Deployment (3-4 weeks)
1. **Training and Tuning**
   - SageMaker training jobs and instance selection
   - Built-in algorithms and custom training containers
   - Hyperparameter tuning strategies
   - Model evaluation and experiment tracking

2. **Deployment and Pipelines**
   - Endpoint types: real-time, batch, serverless, async
   - SageMaker Pipelines for ML workflows
   - MLOps patterns with SageMaker Projects
   - Deployment strategies: blue/green, canary

3. **Hands-on Practice**
   - Build end-to-end ML pipelines
   - Deploy models with different inference options
   - Configure Model Monitor for drift detection
   - Practice with SageMaker Studio notebooks

### Phase 3: Exam Preparation (2 weeks)
1. **Monitoring, Security, and GenAI**
   - Model Monitor capabilities and drift types
   - IAM roles and VPC configuration for SageMaker
   - Amazon Bedrock and foundation models
   - Responsible AI with SageMaker Clarify

2. **Practice and Review**
   - Take multiple practice tests
   - Review incorrect answers thoroughly
   - Focus on weak domains

## Comprehensive Study Resources

**Official Resources:**
- **[MLA-C01 Official Exam Page](https://aws.amazon.com/certification/certified-machine-learning-engineer-associate/)** - Registration and details
- **[AWS Skill Builder](https://skillbuilder.aws/)** - FREE official training and labs
- **[ML Engineer Learning Plan](https://explore.skillbuilder.aws/learn/learning_plan/view/2191/machine-learning-engineer-learning-plan)** - Official study plan
- **[SageMaker Developer Guide](https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html)** - Complete documentation
- **[SageMaker Examples](https://github.com/aws/amazon-sagemaker-examples)** - GitHub examples

### Recommended Courses
1. **AWS Skill Builder - MLA-C01 Exam Prep** (FREE)
2. **AWS Machine Learning University** - Free ML courses from Amazon
3. **Coursera/edX AWS ML courses** - Structured learning paths
4. **Tutorials Dojo Practice Exams** - Exam-focused practice

## Exam Tactics

### Question Strategy
1. **Read Carefully**: Identify the ML lifecycle stage the question addresses
2. **Eliminate**: Remove obviously incorrect answers first
3. **SageMaker First**: When in doubt, the SageMaker-native solution is usually correct
4. **Cost vs Performance**: Balance inference cost with latency requirements
5. **Managed Services**: Prefer managed services over custom implementations

### Domain Focus by Weight
- **Data Preparation for ML (28%)** - Largest domain, prioritize this
- **ML Model Development (26%)** - Second priority, heavy on SageMaker training
- **Monitoring, Maintenance, and Security (24%)** - Third priority
- **Deployment and Orchestration (22%)** - Important for MLOps focus

### Common Patterns
- **Data Prep**: S3 -> Glue ETL -> Feature Store -> Training
- **Training**: SageMaker Training Job with Spot instances -> Model Registry
- **Deployment**: Model Registry -> Pipeline -> Endpoint with auto-scaling
- **Monitoring**: Model Monitor -> CloudWatch Alarm -> Retraining Pipeline
- **GenAI**: Bedrock -> Knowledge Base -> Agent -> Guardrails

### Time Management
- **2 minutes per question** average (85 questions, 170 minutes)
- **Flag and move**: Don't spend too long on difficult questions
- **Review time**: Reserve 20 minutes for flagged questions
- **Quick wins**: Answer easy questions first

## Common Pitfalls

### Study Mistakes
- Focusing too much on ML theory and not enough on AWS services
- Skipping hands-on SageMaker practice
- Not understanding the difference between endpoint types
- Ignoring Data Wrangler and Feature Store
- Underestimating the monitoring and security domain

### Exam Mistakes
- Not reading questions carefully - missing "MOST cost-effective" or "LEAST effort"
- Choosing custom solutions when SageMaker built-in features exist
- Confusing SageMaker Processing with SageMaker Training
- Not considering Feature Store for feature sharing scenarios
- Overlooking Bedrock for generative AI questions

## Progress Tracking

### Weekly Milestones
- **Week 1-2**: Master data ingestion, Glue ETL, and Data Wrangler
- **Week 3-4**: Complete Feature Store and data quality checks
- **Week 5-6**: Finish SageMaker training, tuning, and model registry
- **Week 7-8**: Complete deployment, pipelines, and MLOps
- **Week 9**: Study monitoring, security, and Bedrock
- **Week 10**: Practice exams and final review

### Self-Assessment Questions
- Can I design a data pipeline from S3 through Glue to Feature Store?
- Do I understand SageMaker training job configuration and instance selection?
- Can I choose the right endpoint type for different inference requirements?
- Do I know how to set up Model Monitor for drift detection?
- Can I build an end-to-end ML pipeline with SageMaker Pipelines?
- Do I understand IAM roles and VPC configuration for SageMaker?
- Can I explain when to use Bedrock vs SageMaker for ML workloads?
