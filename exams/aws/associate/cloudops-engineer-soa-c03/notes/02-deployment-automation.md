# Domain 2: Deployment, Provisioning, and Automation (24%)

## 📋 Overview

This domain covers infrastructure as code, automated deployments, container orchestration, and CI/CD pipelines. It is the largest domain in the exam and emphasizes operational automation across AWS services.

## 🎯 Key Services and Concepts

### AWS CloudFormation

**📖 [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)** - Infrastructure as Code service

#### Template Anatomy

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Template description
Parameters:       # Input values at deploy time
Mappings:         # Static key-value lookups
Conditions:       # Conditional resource creation
Resources:        # AWS resources (REQUIRED)
Outputs:          # Values to export or display
```

#### Key Intrinsic Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `Ref` | Reference parameter or resource | `!Ref MyBucket` |
| `Fn::GetAtt` | Get resource attribute | `!GetAtt MyBucket.Arn` |
| `Fn::Sub` | String substitution | `!Sub 'arn:aws:s3:::${BucketName}'` |
| `Fn::Join` | Join strings with delimiter | `!Join ['-', [prefix, suffix]]` |
| `Fn::Select` | Select from a list | `!Select [0, !GetAZs '']` |
| `Fn::ImportValue` | Import cross-stack output | `!ImportValue SharedVPCId` |
| `Fn::If` | Conditional values | `!If [IsProd, t3.large, t3.micro]` |

#### Stack Management

- **Stacks**: Single unit of deployment; create, update, delete together
- **Change Sets**: Preview changes before executing a stack update
- **Drift Detection**: Identify resources modified outside CloudFormation
- **Nested Stacks**: Reusable template components within a parent stack
- **Stack Sets**: Deploy stacks across multiple accounts and regions
- **Stack Policies**: Protect specific resources from unintended updates
- **Rollback Triggers**: CloudWatch alarms that trigger rollback during stack operations

**📖 [Template Basics](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/gettingstarted.templatebasics.html)** - Template syntax
**📖 [Stack Sets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)** - Multi-account deployment
**📖 [Change Sets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html)** - Preview updates
**📖 [Custom Resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html)** - Extend CloudFormation

#### Update Behaviors

| Update Type | Effect |
|-------------|--------|
| **Update with No Interruption** | Resource updated in place |
| **Update with Some Interruption** | Brief interruption during update |
| **Replacement** | New resource created, old one deleted |

> **Exam Tip:** Always use change sets before updating production stacks. Know which resource property changes cause replacement vs in-place update.

---

### AWS CDK (Cloud Development Kit)

**📖 [AWS CDK](https://docs.aws.amazon.com/cdk/v2/guide/home.html)** - Define infrastructure using programming languages

#### Core Concepts

- **App**: Root construct, contains one or more stacks
- **Stack**: Unit of deployment, maps to a CloudFormation stack
- **Construct**: Building block representing AWS resources
  - **L1 (CFN Resources)**: Direct CloudFormation mappings
  - **L2 (Curated)**: Higher-level abstractions with sensible defaults
  - **L3 (Patterns)**: Complete solution patterns (e.g., ApplicationLoadBalancedFargateService)
- **Synthesis**: CDK code compiles to CloudFormation templates (`cdk synth`)
- **Deploy**: Deploys synthesized template (`cdk deploy`)
- **Diff**: Shows changes between deployed stack and current code (`cdk diff`)

**📖 [CDK Constructs](https://docs.aws.amazon.com/cdk/v2/guide/constructs.html)** - Reusable components
**📖 [CDK Stacks](https://docs.aws.amazon.com/cdk/v2/guide/stacks.html)** - Deployment units
**📖 [CDK Pipelines](https://docs.aws.amazon.com/cdk/v2/guide/cdk_pipeline.html)** - CI/CD automation

> **Exam Tip:** CDK synthesizes to CloudFormation under the hood. CDK is new in SOA-C03 and questions may compare CDK vs CloudFormation for different scenarios.

---

### AWS Elastic Beanstalk

**📖 [AWS Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)** - PaaS for application deployment

#### Deployment Policies

| Policy | Downtime | Speed | Rollback |
|--------|----------|-------|----------|
| **All at Once** | Yes | Fastest | Re-deploy previous version |
| **Rolling** | Partial | Moderate | Re-deploy previous version |
| **Rolling with Additional Batch** | No | Moderate | Re-deploy previous version |
| **Immutable** | No | Slow | Terminate new instances |
| **Traffic Splitting** | No | Slow | Reroute traffic |

#### Key Configuration

- **.ebextensions/**: YAML/JSON config files in `.config` extension for environment customization
- **Saved Configurations**: Reusable environment configuration templates
- **Environment Types**: Web server (HTTP) and worker (SQS-based background processing)
- **Platform Updates**: Managed platform updates for OS and runtime patching

**📖 [Environments](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.managing.html)** - Environment management
**📖 [Deployments](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.deploy-existing-version.html)** - Deployment options
**📖 [Health Monitoring](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/health-enhanced.html)** - Enhanced health

---

### Container Services

#### Amazon ECS (Elastic Container Service)

**📖 [Amazon ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)** - Container orchestration

- **Cluster**: Logical grouping of tasks and services
- **Task Definition**: Blueprint for containers (image, CPU, memory, ports, IAM role)
- **Service**: Maintains desired count of running tasks, integrates with ELB
- **Launch Types**:
  - **EC2**: You manage the underlying EC2 instances
  - **Fargate**: Serverless, AWS manages compute infrastructure
- **Service Auto Scaling**: Target tracking, step scaling, scheduled scaling
- **Task Placement Strategies**: binpack, random, spread

**📖 [ECS Tasks](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)** - Task definitions
**📖 [ECS Services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html)** - Service management
**📖 [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)** - Serverless containers

#### Amazon EKS (Elastic Kubernetes Service)

**📖 [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)** - Managed Kubernetes

- **Managed Node Groups**: AWS manages EC2 instances for worker nodes
- **Fargate Profiles**: Run pods on Fargate without managing nodes
- **EKS Add-ons**: Managed Kubernetes add-ons (CoreDNS, kube-proxy, VPC CNI)
- **kubectl**: CLI tool for Kubernetes cluster management

**📖 [EKS Node Groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)** - Worker nodes
**📖 [EKS Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)** - Serverless pods

#### Amazon ECR (Elastic Container Registry)

**📖 [Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)** - Container image registry

- **Repositories**: Store Docker container images
- **Image Scanning**: Automated vulnerability scanning on push or manual
- **Lifecycle Policies**: Automatically clean up old or untagged images
- **Cross-Region Replication**: Replicate images to other regions
- **Immutable Tags**: Prevent image tag overwriting

**📖 [Image Scanning](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html)** - Vulnerability scanning
**📖 [Lifecycle Policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html)** - Image cleanup

#### ECS vs EKS Decision Criteria

| Factor | ECS | EKS |
|--------|-----|-----|
| Complexity | Simpler, AWS-native | More complex, Kubernetes standard |
| Portability | AWS-specific | Multi-cloud, on-premises |
| Learning Curve | Lower | Higher (requires K8s knowledge) |
| Cost | Lower (no control plane fee) | Higher ($0.10/hr for control plane) |
| Best For | AWS-centric workloads | Kubernetes-native teams |

---

### CI/CD Services

#### AWS CodePipeline

**📖 [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)** - CI/CD orchestration

- **Stages**: Sequential phases (Source, Build, Test, Deploy, Approval)
- **Actions**: Tasks within a stage (can run in parallel or sequential)
- **Artifacts**: Output from one stage passed as input to the next (stored in S3)
- **Manual Approval**: Gate deployments with human approval via SNS notification
- **Cross-Region Actions**: Deploy to resources in different regions

#### AWS CodeBuild

**📖 [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html)** - Build service

- **buildspec.yml**: Defines build phases (install, pre_build, build, post_build)
- **Build Environments**: Managed images or custom Docker images
- **Caching**: S3 caching for build dependencies
- **Environment Variables**: Plain text, Parameter Store, Secrets Manager

#### AWS CodeDeploy

**📖 [AWS CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)** - Deployment automation

- **Compute Platforms**: EC2/On-premises, Lambda, ECS
- **Deployment Types**: In-place (rolling) and Blue/green
- **appspec.yml**: Deployment instructions and lifecycle hooks
- **Rollback**: Automatic rollback on deployment failure or alarm trigger

**📖 [Pipeline Structure](https://docs.aws.amazon.com/codepipeline/latest/userguide/concepts.html)** - Pipeline concepts

---

### EC2 Auto Scaling

**📖 [EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)** - Scaling automation

#### Components

- **Launch Template**: Instance configuration (AMI, instance type, key pair, security groups)
- **Auto Scaling Group (ASG)**: Manages fleet of EC2 instances
- **Scaling Policies**:
  - **Target Tracking**: Maintain a target metric value (e.g., 50% CPU)
  - **Step Scaling**: Scale based on CloudWatch alarm thresholds
  - **Scheduled Scaling**: Scale at predetermined times
  - **Predictive Scaling**: ML-based forecasting of demand

#### Key Settings

- **Desired Capacity**: Target number of instances
- **Min/Max Size**: Boundaries for scaling
- **Cooldown Period**: Wait time between scaling activities (default 300 seconds)
- **Health Check Grace Period**: Time before health checks start on new instances
- **Instance Warm-Up**: Time for new instances to warm up before contributing to metrics
- **Lifecycle Hooks**: Perform custom actions during instance launch or termination

**📖 [Scaling Policies](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scale-based-on-demand.html)** - Dynamic scaling
**📖 [Launch Templates](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html)** - Instance configuration

---

## 📚 AMI Management

- **Golden AMI**: Pre-configured AMI with applications, patches, and agents installed
- **AMI Creation**: Create from running instance or using EC2 Image Builder
- **EC2 Image Builder**: Automated pipeline for building, testing, and distributing AMIs
- **AMI Lifecycle**: Share across accounts, copy across regions, deregister when obsolete

**📖 [EC2 Image Builder](https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html)** - Automated AMI creation

---

## Key Exam Scenarios

1. **Deploy across multiple accounts and regions** - Use CloudFormation StackSets with AWS Organizations integration
2. **Preview infrastructure changes before applying** - Create CloudFormation change set and review proposed changes
3. **Zero-downtime application deployment** - Use Elastic Beanstalk immutable deployment or Blue/green with URL swap
4. **Automate container deployment** - ECS service with CodePipeline; ECR image push triggers pipeline
5. **Scale based on custom business metric** - Publish custom CloudWatch metric; configure Auto Scaling target tracking policy
6. **Maintain desired instance configuration** - Use golden AMIs with launch templates; enforce with AWS Config rules
