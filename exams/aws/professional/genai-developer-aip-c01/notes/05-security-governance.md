# Security, Compliance, Governance, and Cost Management for GenAI

**📖 [Amazon Bedrock Security](https://docs.aws.amazon.com/bedrock/latest/userguide/security.html)** - Complete security guide for Bedrock

## 📋 Access Control and IAM

### IAM Policies for Amazon Bedrock

**📖 [Bedrock IAM Actions](https://docs.aws.amazon.com/bedrock/latest/userguide/security-iam.html)** - Identity-based policy reference

**Key Bedrock IAM Actions:**

| Action | Description | Use Case |
|--------|-------------|----------|
| `bedrock:InvokeModel` | Invoke a foundation model | Application model access |
| `bedrock:InvokeModelWithResponseStream` | Invoke with streaming | Real-time streaming apps |
| `bedrock:ListFoundationModels` | List available models | Model discovery |
| `bedrock:GetFoundationModel` | Get model details | Model information |
| `bedrock:CreateModelCustomizationJob` | Fine-tune a model | Model customization |
| `bedrock:CreateKnowledgeBase` | Create a knowledge base | RAG setup |
| `bedrock:Retrieve` | Retrieve from knowledge base | RAG retrieval |
| `bedrock:RetrieveAndGenerate` | Retrieve and generate response | RAG application |
| `bedrock:InvokeAgent` | Invoke an agent | Agent applications |
| `bedrock:CreateGuardrail` | Create a guardrail | Content safety setup |
| `bedrock:ApplyGuardrail` | Apply guardrail to content | Content filtering |

### Least-Privilege Policy Examples

**Application Role - Model Invocation Only:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSpecificModelInvocation",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Resource": [
                "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
                "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
            ]
        }
    ]
}
```

**RAG Application Role:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowKnowledgeBaseAccess",
            "Effect": "Allow",
            "Action": [
                "bedrock:Retrieve",
                "bedrock:RetrieveAndGenerate"
            ],
            "Resource": "arn:aws:bedrock:us-east-1:123456789012:knowledge-base/KB_ID"
        },
        {
            "Sid": "AllowModelInvocation",
            "Effect": "Allow",
            "Action": "bedrock:InvokeModel",
            "Resource": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-*"
        }
    ]
}
```

**Agent Application Role:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAgentInvocation",
            "Effect": "Allow",
            "Action": "bedrock:InvokeAgent",
            "Resource": "arn:aws:bedrock:us-east-1:123456789012:agent-alias/AGENT_ID/ALIAS_ID"
        }
    ]
}
```

**Restrict Model Access (Deny Policy):**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyExpensiveModels",
            "Effect": "Deny",
            "Action": "bedrock:InvokeModel",
            "Resource": [
                "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-opus-*"
            ]
        }
    ]
}
```

### Model Access Management

**📖 [Model Access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html)** - Requesting access to models

- Models must be explicitly enabled in the Bedrock console before use
- Model access is per-region and per-account
- Some models require accepting provider-specific EULAs
- Use IAM policies to control which users/roles can access which models
- Cross-account model sharing via resource-based policies

## 🎯 Data Privacy and Protection

**📖 [Bedrock Data Protection](https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html)** - Privacy and encryption guide

### Data Privacy Guarantees

**AWS Bedrock Data Privacy:**
- **Customer data is NOT used to train or improve foundation models**
- Customer prompts and responses are not shared with model providers
- Data is processed in the customer's AWS region
- No cross-region data transfer without explicit customer configuration
- Customer data is encrypted in transit and at rest

### Encryption

**📖 [Bedrock Encryption](https://docs.aws.amazon.com/bedrock/latest/userguide/encryption-at-rest.html)** - Encryption configuration

**Encryption at Rest:**
- All Bedrock data encrypted at rest by default (AWS-managed keys)
- Option to use customer-managed KMS keys (CMKs) for additional control
- Custom model artifacts encrypted with customer-specified KMS key
- Knowledge Base data encrypted in the vector store

**📖 [AWS KMS Documentation](https://docs.aws.amazon.com/kms/)** - Key management service

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBedrockKMSAccess",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey",
                "kms:CreateGrant"
            ],
            "Resource": "arn:aws:kms:us-east-1:123456789012:key/key-id",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "bedrock.us-east-1.amazonaws.com"
                }
            }
        }
    ]
}
```

**Encryption in Transit:**
- All Bedrock API calls use TLS 1.2+ encryption
- VPC endpoints provide private connectivity (no internet traversal)
- Mutual TLS available for additional security

### VPC Endpoints (PrivateLink)

**📖 [VPC Endpoints for Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/vpc-interface-endpoints.html)** - Private connectivity

VPC endpoints allow applications to access Bedrock without traversing the public internet.

```python
# Create VPC endpoint for Bedrock Runtime
# (via CloudFormation or AWS Console)

# Application code uses the same Bedrock API
# Traffic automatically routes through VPC endpoint
bedrock_runtime = boto3.client(
    'bedrock-runtime',
    region_name='us-east-1',
    endpoint_url='https://vpce-0123456789abcdef-ab12cd34.bedrock-runtime.us-east-1.vpce.amazonaws.com'
)
```

**VPC Endpoint Types for Bedrock:**

| Endpoint | Service | Use Case |
|----------|---------|----------|
| `com.amazonaws.region.bedrock` | Bedrock control plane | Model management, customization |
| `com.amazonaws.region.bedrock-runtime` | Bedrock runtime | Model invocation (InvokeModel) |
| `com.amazonaws.region.bedrock-agent` | Bedrock agent control plane | Agent management |
| `com.amazonaws.region.bedrock-agent-runtime` | Bedrock agent runtime | Agent invocation |

**Security Group Configuration:**
- Allow HTTPS (port 443) inbound from application subnets
- Restrict outbound to VPC endpoint ENIs only
- Use private DNS for seamless endpoint resolution

### PII Detection and Handling

**Using Bedrock Guardrails for PII:**

```python
# Guardrail with PII detection
bedrock.create_guardrail(
    name='pii-protection-guardrail',
    sensitiveInformationPolicyConfig={
        'piiEntitiesConfig': [
            {'type': 'EMAIL', 'action': 'ANONYMIZE'},
            {'type': 'PHONE', 'action': 'ANONYMIZE'},
            {'type': 'NAME', 'action': 'ANONYMIZE'},
            {'type': 'US_SOCIAL_SECURITY_NUMBER', 'action': 'BLOCK'},
            {'type': 'CREDIT_DEBIT_CARD_NUMBER', 'action': 'BLOCK'},
            {'type': 'US_PASSPORT_NUMBER', 'action': 'BLOCK'},
            {'type': 'US_INDIVIDUAL_TAX_IDENTIFICATION_NUMBER', 'action': 'BLOCK'},
            {'type': 'DRIVER_ID', 'action': 'BLOCK'},
            {'type': 'US_BANK_ACCOUNT_NUMBER', 'action': 'BLOCK'},
            {'type': 'IP_ADDRESS', 'action': 'ANONYMIZE'}
        ],
        'regexesConfig': [
            {
                'name': 'employee-id',
                'pattern': 'EMP-[A-Z]{2}[0-9]{6}',
                'action': 'BLOCK',
                'description': 'Block internal employee IDs'
            }
        ]
    },
    blockedInputMessaging='Your request contains sensitive information that cannot be processed.',
    blockedOutputMessaging='The response was blocked because it contained sensitive information.'
)
```

**PII Actions:**
- **BLOCK** - Reject the entire request/response if PII is detected
- **ANONYMIZE** - Replace PII with placeholder text (e.g., [EMAIL], [NAME])

## 📚 Monitoring and Observability

### Amazon CloudWatch for Bedrock

**📖 [Monitoring Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/monitoring.html)** - CloudWatch metrics and logging

**Key Bedrock CloudWatch Metrics:**

| Metric | Description | Use Case |
|--------|-------------|----------|
| `Invocations` | Number of model invocations | Usage tracking |
| `InvocationLatency` | Time to process a request | Performance monitoring |
| `InvocationClientErrors` | 4xx error count | Client-side issue detection |
| `InvocationServerErrors` | 5xx error count | Server-side issue detection |
| `InvocationThrottles` | Throttled request count | Capacity planning |
| `InputTokenCount` | Total input tokens | Cost tracking |
| `OutputTokenCount` | Total output tokens | Cost tracking |

**CloudWatch Dashboard for GenAI:**
```python
import boto3

cloudwatch = boto3.client('cloudwatch')

# Create alarm for high error rate
cloudwatch.put_metric_alarm(
    AlarmName='bedrock-high-error-rate',
    MetricName='InvocationServerErrors',
    Namespace='AWS/Bedrock',
    Statistic='Sum',
    Period=300,
    EvaluationPeriods=2,
    Threshold=10,
    ComparisonOperator='GreaterThanThreshold',
    Dimensions=[
        {'Name': 'ModelId', 'Value': 'anthropic.claude-3-sonnet-20240229-v1:0'}
    ],
    AlarmActions=['arn:aws:sns:us-east-1:123456789012:genai-alerts'],
    AlarmDescription='Alert when Bedrock invocation errors exceed threshold'
)

# Create alarm for cost monitoring (token usage)
cloudwatch.put_metric_alarm(
    AlarmName='bedrock-high-token-usage',
    MetricName='OutputTokenCount',
    Namespace='AWS/Bedrock',
    Statistic='Sum',
    Period=3600,
    EvaluationPeriods=1,
    Threshold=1000000,
    ComparisonOperator='GreaterThanThreshold',
    AlarmActions=['arn:aws:sns:us-east-1:123456789012:cost-alerts'],
    AlarmDescription='Alert when hourly output token count exceeds 1M'
)
```

### AWS CloudTrail for Auditing

**📖 [Logging Bedrock API Calls](https://docs.aws.amazon.com/bedrock/latest/userguide/logging-using-cloudtrail.html)** - API audit trail

CloudTrail records all Bedrock API calls for auditing and compliance.

**Logged Events Include:**
- Who made the API call (IAM principal)
- Which model was invoked
- When the call was made (timestamp)
- Source IP address
- Request parameters (model ID, configuration)
- Response status (success/error)

**Important:** CloudTrail logs API metadata but does NOT log prompt content or model responses by default. Enable Bedrock model invocation logging for full content logging.

**Model Invocation Logging:**

**📖 [Model Invocation Logging](https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html)** - Logging prompts and responses

```python
# Enable model invocation logging
bedrock = boto3.client('bedrock')

bedrock.put_model_invocation_logging_configuration(
    loggingConfig={
        'cloudWatchConfig': {
            'logGroupName': '/aws/bedrock/model-invocation-logs',
            'roleArn': 'arn:aws:iam::123456789012:role/BedrockLoggingRole',
            'largeDataDeliveryS3Config': {
                'bucketName': 'bedrock-invocation-logs',
                'keyPrefix': 'large-data/'
            }
        },
        's3Config': {
            'bucketName': 'bedrock-invocation-logs',
            'keyPrefix': 'invocation-logs/'
        },
        'textDataDeliveryEnabled': True,
        'imageDataDeliveryEnabled': True,
        'embeddingDataDeliveryEnabled': True
    }
)
```

## 🎯 Responsible AI

**📖 [Responsible AI on AWS](https://aws.amazon.com/ai/responsible-ai/)** - AWS responsible AI framework

### Responsible AI Principles

| Principle | Description | Implementation |
|-----------|-------------|----------------|
| **Fairness** | Avoid bias in model outputs | Evaluate for bias, diverse training data |
| **Transparency** | Explain model decisions | Model cards, citations, confidence scores |
| **Safety** | Prevent harmful outputs | Guardrails, content filtering, testing |
| **Privacy** | Protect user data | Encryption, PII filtering, data isolation |
| **Accountability** | Track and audit AI decisions | CloudTrail, invocation logging, monitoring |
| **Controllability** | Maintain human oversight | Human-in-the-loop, kill switches, guardrails |

### Bias Detection and Mitigation

**Types of Bias:**
- **Training Data Bias** - Imbalanced or unrepresentative training data
- **Selection Bias** - Non-random data sampling
- **Confirmation Bias** - Model reinforces existing patterns
- **Representation Bias** - Under/over-representation of groups

**Mitigation Strategies:**
- Evaluate model outputs across diverse demographics
- Use balanced evaluation datasets
- Implement Guardrails to filter biased content
- Monitor model outputs for bias patterns over time
- Regular audits with diverse review teams
- Fine-tune with balanced, high-quality data

### Content Safety with Guardrails

**📖 [Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)** - Content safety controls

**Content Filter Strengths:**

| Level | Filtering Behavior |
|-------|-------------------|
| **NONE** | No filtering applied |
| **LOW** | Block only clearly harmful content |
| **MEDIUM** | Block moderately harmful content |
| **HIGH** | Aggressive filtering, block borderline content |

**Contextual Grounding:**
- Validates that model responses are grounded in provided context
- Grounding threshold (0.0-1.0): How strictly to enforce grounding
- Relevance threshold (0.0-1.0): How relevant the response must be
- Helps prevent hallucinations in RAG applications

## 📋 Cost Management and Optimization

**📖 [Amazon Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)** - Pricing details

### Bedrock Pricing Models

| Pricing Model | How It Works | Best For |
|--------------|-------------|----------|
| **On-Demand** | Pay per input/output token | Variable workloads, development |
| **Provisioned Throughput** | Reserved model capacity (per model unit/hour) | Consistent high-volume production |
| **Batch Inference** | Discounted batch processing | Non-real-time, large-volume processing |
| **Model Customization** | Per training token + model storage | Fine-tuning and continued pre-training |

### Cost Optimization Strategies

**1. Model Selection (Biggest Impact)**
```
Route requests to appropriate model tier:

Simple tasks (classification, extraction)
  → Claude 3 Haiku, Mistral 7B, Titan Text Lite
  → Lowest cost per token

Standard tasks (Q&A, summarization)
  → Claude 3 Sonnet, Llama 3.1 70B
  → Balanced cost/quality

Complex tasks (reasoning, analysis)
  → Claude 3.5 Sonnet, Claude 3 Opus
  → Highest cost but best quality
```

**Model Routing Pattern:**
```python
def route_to_model(query, complexity):
    """Route requests to cost-appropriate models."""
    if complexity == 'simple':
        return 'anthropic.claude-3-haiku-20240307-v1:0'
    elif complexity == 'standard':
        return 'anthropic.claude-3-sonnet-20240229-v1:0'
    else:
        return 'anthropic.claude-3-5-sonnet-20240620-v1:0'

def classify_complexity(query):
    """Simple heuristic for query complexity."""
    if len(query.split()) < 20 and any(kw in query.lower() for kw in ['classify', 'extract', 'yes or no']):
        return 'simple'
    elif len(query.split()) > 100 or any(kw in query.lower() for kw in ['analyze', 'compare', 'explain in detail']):
        return 'complex'
    return 'standard'
```

**2. Response Caching**
```python
import boto3
import hashlib
import json

dynamodb = boto3.resource('dynamodb')
cache_table = dynamodb.Table('BedrockResponseCache')

def get_cached_response(prompt, model_id):
    """Check cache before invoking Bedrock."""
    cache_key = hashlib.sha256(f"{model_id}:{prompt}".encode()).hexdigest()

    try:
        response = cache_table.get_item(Key={'cacheKey': cache_key})
        if 'Item' in response:
            return response['Item']['response']
    except Exception:
        pass
    return None

def cache_response(prompt, model_id, response_text, ttl_hours=24):
    """Cache Bedrock response in DynamoDB."""
    cache_key = hashlib.sha256(f"{model_id}:{prompt}".encode()).hexdigest()
    import time
    cache_table.put_item(Item={
        'cacheKey': cache_key,
        'response': response_text,
        'ttl': int(time.time()) + (ttl_hours * 3600)
    })
```

**3. Token Optimization**
- Write concise prompts (avoid unnecessary context)
- Set appropriate `maxTokens` limits
- Use `stopSequences` to prevent excessive generation
- Summarize long documents before passing to model
- Use structured output formats (JSON) to reduce verbosity

**4. Provisioned Throughput**

**📖 [Provisioned Throughput](https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html)** - Reserved capacity

- Reserve model capacity for consistent performance
- Predictable pricing for high-volume workloads
- Model units define throughput capacity
- 1-month or 6-month commitment terms
- Best when: sustained usage > breakeven vs on-demand

**5. Batch Inference**
- Process large volumes of requests at lower cost
- Asynchronous processing (not real-time)
- Input/output via S3
- Ideal for: document processing, data enrichment, bulk analysis

### Cost Monitoring

```python
# CloudWatch cost tracking dashboard
cloudwatch = boto3.client('cloudwatch')

# Track daily token usage by model
cloudwatch.get_metric_statistics(
    Namespace='AWS/Bedrock',
    MetricName='InputTokenCount',
    Dimensions=[
        {'Name': 'ModelId', 'Value': 'anthropic.claude-3-sonnet-20240229-v1:0'}
    ],
    StartTime='2024-01-01T00:00:00Z',
    EndTime='2024-01-02T00:00:00Z',
    Period=86400,
    Statistics=['Sum']
)
```

**AWS Cost Explorer Tags:**
- Tag Bedrock resources for cost allocation
- Track costs by application, team, or environment
- Set budget alerts with AWS Budgets

## 🎯 Infrastructure as Code for GenAI

**📖 [AWS CloudFormation](https://docs.aws.amazon.com/cloudformation/)** - Infrastructure as code

### CloudFormation for Bedrock Resources

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: GenAI Application Infrastructure

Resources:
  # Knowledge Base
  BedrockKnowledgeBase:
    Type: AWS::Bedrock::KnowledgeBase
    Properties:
      Name: product-knowledge-base
      RoleArn: !GetAtt KnowledgeBaseRole.Arn
      KnowledgeBaseConfiguration:
        Type: VECTOR
        VectorKnowledgeBaseConfiguration:
          EmbeddingModelArn: !Sub 'arn:aws:bedrock:${AWS::Region}::foundation-model/amazon.titan-embed-text-v2:0'
      StorageConfiguration:
        Type: OPENSEARCH_SERVERLESS
        OpensearchServerlessConfiguration:
          CollectionArn: !GetAtt VectorCollection.Arn
          VectorIndexName: knowledge-base-index
          FieldMapping:
            VectorField: embedding
            TextField: text
            MetadataField: metadata

  # Guardrail
  ContentSafetyGuardrail:
    Type: AWS::Bedrock::Guardrail
    Properties:
      Name: content-safety
      BlockedInputMessaging: 'Request blocked by content policy.'
      BlockedOutputMessaging: 'Response blocked by content policy.'
      ContentPolicyConfig:
        FiltersConfig:
          - Type: SEXUAL
            InputStrength: HIGH
            OutputStrength: HIGH
          - Type: VIOLENCE
            InputStrength: HIGH
            OutputStrength: HIGH

  # VPC Endpoint for private Bedrock access
  BedrockRuntimeEndpoint:
    Type: AWS::EC2::VPCEndpoint
    Properties:
      VpcId: !Ref VPC
      ServiceName: !Sub 'com.amazonaws.${AWS::Region}.bedrock-runtime'
      VpcEndpointType: Interface
      SubnetIds:
        - !Ref PrivateSubnet1
        - !Ref PrivateSubnet2
      SecurityGroupIds:
        - !Ref BedrockEndpointSecurityGroup
      PrivateDnsEnabled: true
```

## Exam Tips

### Key Concepts to Remember
- Customer data is NEVER used to train Bedrock foundation models
- VPC endpoints provide private Bedrock access (no internet traversal)
- IAM policies control model access at resource level (specific model ARNs)
- CloudTrail logs API metadata; model invocation logging logs prompts/responses
- Guardrails handle PII (BLOCK or ANONYMIZE actions)
- Encryption at rest uses AWS-managed keys by default, CMKs optional
- On-demand pricing for variable workloads, Provisioned Throughput for high-volume
- Model routing (small model for simple tasks) is the #1 cost optimization strategy
- CloudWatch metrics track invocations, latency, errors, and token counts

### Common Exam Traps
- ❌ Thinking customer data is used for model training (it is NOT)
- ❌ Forgetting VPC endpoints when private connectivity is required
- ❌ Using overly broad IAM policies (allow all models when only one is needed)
- ❌ Not enabling model invocation logging for compliance (CloudTrail alone is insufficient)
- ❌ Ignoring Provisioned Throughput for steady-state high-volume workloads
- ❌ Using expensive models for simple tasks (cost waste)
- ❌ Not configuring Guardrails when PII protection is required
- ❌ Overlooking batch inference for non-real-time processing workloads
