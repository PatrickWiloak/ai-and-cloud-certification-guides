# ML Security and Compliance

**[Security in SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/security.html)** - Security overview

## IAM for SageMaker

### Execution Roles

**[SageMaker Roles](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html)** - IAM roles for SageMaker

**Execution Role** - the IAM role SageMaker assumes to perform actions:
- Required for all SageMaker operations (training, inference, processing)
- Needs access to S3 for data and model artifacts
- Needs access to ECR for custom containers
- Needs access to KMS for encryption keys
- Needs CloudWatch Logs permissions for logging

**Minimum Permissions**:
- `s3:GetObject`, `s3:PutObject` for data and model S3 buckets
- `ecr:GetDownloadUrlForLayer`, `ecr:BatchGetImage` for containers
- `logs:CreateLogGroup`, `logs:PutLogEvents` for CloudWatch Logs
- `kms:Decrypt`, `kms:GenerateDataKey` for KMS encryption

### Least Privilege Policies

**[IAM Policy Examples](https://docs.aws.amazon.com/sagemaker/latest/dg/security_iam_id-based-policy-examples.html)** - Policy examples

**Best Practices**:
- Create separate roles for training, inference, and processing
- Restrict S3 access to specific buckets and prefixes
- Use resource-based conditions (e.g., specific SageMaker resources)
- Enable MFA for human users accessing SageMaker Studio
- Use IAM conditions: `sagemaker:InstanceTypes` to restrict instance types

**Condition Keys for SageMaker**:
- `sagemaker:InstanceTypes` - restrict allowed instance types
- `sagemaker:VolumeKmsKey` - require encryption on volumes
- `sagemaker:NetworkIsolation` - require network isolation
- `sagemaker:VpcSecurityGroupIds` - require VPC configuration

### Cross-Account Access
- Use IAM roles for cross-account model sharing
- S3 bucket policies for cross-account data access
- Model Registry cross-account access
- ECR cross-account repository access

## VPC Configuration

**[VPC Configuration](https://docs.aws.amazon.com/sagemaker/latest/dg/infrastructure-connect-to-resources.html)** - Private networking

### SageMaker in VPC

**Why Use VPC**:
- Keep training data and model artifacts private
- Control network access with security groups
- Meet compliance requirements for data isolation
- Access on-premises resources via VPN or Direct Connect

**Configuration**:
- Specify VPC, subnets, and security groups in job configuration
- SageMaker creates ENIs in your subnets
- All traffic stays within VPC (no internet access by default)
- Use VPC endpoints for AWS service access

### VPC Endpoints for SageMaker

**Required Endpoints** (when running in VPC without internet):
- `com.amazonaws.region.sagemaker.api` - SageMaker API
- `com.amazonaws.region.sagemaker.runtime` - Inference API
- `com.amazonaws.region.s3` - S3 Gateway endpoint (for data access)
- `com.amazonaws.region.ecr.api` and `ecr.dkr` - ECR (for containers)
- `com.amazonaws.region.logs` - CloudWatch Logs
- `com.amazonaws.region.kms` - KMS (if using encryption)

**[VPC Endpoints](https://docs.aws.amazon.com/sagemaker/latest/dg/interface-vpc-endpoint.html)** - Private access to SageMaker

### Network Isolation

**[Network Isolation](https://docs.aws.amazon.com/sagemaker/latest/dg/mkt-algo-model-internet-free.html)** - No internet access

- Enable `EnableNetworkIsolation` for training and inference
- Container cannot make outbound network calls
- All data must be provided through S3 input channels
- Required for some compliance scenarios
- Does not affect communication with SageMaker APIs

### Security Groups
- Control inbound and outbound traffic for SageMaker ENIs
- Allow inter-node communication for distributed training
- Restrict access to specific CIDR ranges
- Allow traffic to VPC endpoints

## Encryption

### Encryption at Rest

**[Data Encryption](https://docs.aws.amazon.com/sagemaker/latest/dg/encryption-at-rest.html)** - Encryption overview

**S3 Encryption**:
- SSE-S3: Amazon-managed keys (default)
- SSE-KMS: Customer-managed or AWS-managed KMS keys
- CSE: Client-side encryption before upload
- Recommended: SSE-KMS with customer-managed keys for control

**EBS Volume Encryption**:
- Training job volumes encrypted with KMS
- Specify `VolumeKmsKeyId` in training job configuration
- Endpoint instance volumes encrypted
- Processing job volumes encrypted

**Model Artifacts**:
- Stored in S3 with bucket encryption policy
- Use KMS encryption for sensitive models
- Encryption key specified in training job output configuration

### Encryption in Transit

**TLS/SSL**:
- All SageMaker API calls use HTTPS (TLS 1.2+)
- Inter-container communication encrypted for distributed training
- Endpoint invocations over HTTPS
- S3 data transfer encrypted in transit

**Inter-Container Encryption**:
- Enable for distributed training jobs
- Encrypts data between training instances
- Small performance overhead
- Required for sensitive data compliance

## Compliance and Governance

### Model Governance

**Model Cards**:

**[Model Cards](https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html)** - Model documentation

- Document model details, intended use, and limitations
- Record training data, evaluation metrics, and bias analysis
- Required for regulatory compliance in some industries
- Exportable for external audits

**Model Registry**:
- Version tracking for all model artifacts
- Approval workflow (Pending, Approved, Rejected)
- Metadata: metrics, parameters, data sources
- Lineage tracking for reproducibility

**SageMaker Lineage**:

**[Lineage Tracking](https://docs.aws.amazon.com/sagemaker/latest/dg/lineage-tracking.html)** - Track ML artifacts

- Track relationships between data, models, and endpoints
- Artifacts: datasets, models, endpoints, code
- Associations: training data -> model -> endpoint
- Query lineage for audit and compliance

### CloudTrail Auditing

**[CloudTrail Logging](https://docs.aws.amazon.com/sagemaker/latest/dg/logging-using-cloudtrail.html)** - API audit trail

- All SageMaker API calls logged in CloudTrail
- Track who created/deleted training jobs, endpoints
- Monitor access to models and data
- Integration with CloudWatch for alerting on suspicious activity

### Data Privacy

**Data Handling Best Practices**:
- Encrypt all data at rest and in transit
- Use VPC to isolate ML workloads
- Implement data access controls with IAM
- Use Feature Store with fine-grained access control
- Delete training data when no longer needed
- Comply with data retention policies

**PII Handling**:
- Use Amazon Macie to discover PII in S3 data
- Implement data masking or tokenization
- SageMaker Clarify for bias detection on sensitive attributes
- Log access to sensitive data with CloudTrail

## Responsible AI

### SageMaker Clarify

**[SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-fairness-and-explainability.html)** - Bias and explainability

**Pre-Training Bias Metrics**:
- Class Imbalance (CI)
- Difference in Proportions of Labels (DPL)
- KL Divergence
- LP Norm

**Post-Training Bias Metrics**:
- Disparate Impact (DI)
- Difference in Positive Proportions in Predicted Labels (DPPL)
- Treatment Equality (TE)

**Model Explainability**:
- SHAP (SHapley Additive exPlanations) values
- Feature attribution for individual predictions
- Global feature importance across dataset
- Helps understand model decision-making

### Ground Truth for Labeling

**[SageMaker Ground Truth](https://docs.aws.amazon.com/sagemaker/latest/dg/sms.html)** - Data labeling

- Managed data labeling service
- Human labelers (Amazon Mechanical Turk, private, vendor)
- Active learning to reduce labeling effort
- Built-in labeling workflows for common tasks
- Use for: generating ground truth labels for model quality monitoring

## Key Takeaways

1. **Execution roles** - every SageMaker operation needs an IAM role with appropriate permissions
2. **Least privilege** - use IAM conditions to restrict instance types and require encryption
3. **VPC** - run SageMaker in VPC for data isolation, use VPC endpoints for service access
4. **Network isolation** - prevents container outbound calls, required for some compliance
5. **Encryption** - KMS for S3, EBS volumes, and model artifacts; TLS for transit
6. **CloudTrail** - all SageMaker API calls logged for audit
7. **Model Cards** - document model details for governance and compliance
8. **Lineage** - track data-to-model-to-endpoint relationships
9. **Clarify** - bias detection (pre and post-training) and SHAP explainability
10. **Cross-account** - use IAM roles and bucket policies for secure model sharing
