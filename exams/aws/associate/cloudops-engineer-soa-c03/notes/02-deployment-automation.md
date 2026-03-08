# Domain 2: Deployment, Provisioning, and Automation (24%)

## 📋 Overview

This is the largest domain on the SOA-C03 exam, covering infrastructure as code, automated deployments, container operations, and CI/CD pipelines. The domain emphasizes operational best practices for provisioning and managing AWS resources at scale.

## 🎯 Key Services

### AWS CloudFormation

**📖 [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)** - Infrastructure as Code service

#### Template Anatomy

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Template description
Parameters:       # Input values at deployment
Mappings:         # Static key-value lookups
Conditions:       # Conditional resource creation
Resources:        # AWS resources (REQUIRED)
Outputs:          # Return values
```

**📖 [Template Basics](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/gettingstarted.templatebasics.html)** - Template structure
**📖 [Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)** - Complete resource reference

#### Key Intrinsic Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `Ref` | Reference parameter or resource ID | `!Ref MyVPC` |
| `Fn::GetAtt` | Get resource attribute | `!GetAtt MyALB.DNSName` |
| `Fn::Sub` | String substitution | `!Sub 'arn:aws:s3:::${BucketName}'` |
| `Fn::Join` | Concatenate strings | `!Join ['-', [!Ref Env, 'bucket']]` |
| `Fn::Select` | Select from list | `!Select [0, !GetAZs '']` |
| `Fn::ImportValue` | Cross-stack reference | `!ImportValue SharedVPCId` |
| `Fn::If` | Conditional value | `!If [IsProd, t3.large, t3.micro]` |

**📖 [Intrinsic Functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html)** - Function reference

#### Stack Operations

- **Create Stack**: Deploy new resources from template
- **Update Stack**: Modify existing resources (use change sets to preview)
- **Delete Stack**: Remove all resources (respects DeletionPolicy)
- **Drift Detection**: Identify resources modified outside CloudFormation
- **Rollback**: Automatic rollback on failure (configurable)
- **Stack Policies**: Prevent accidental updates to critical resources

**📖 [Change Sets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html)** - Preview changes
**📖 [Drift Detection](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift.html)** - Detect configuration drift

#### Stack Sets

- Deploy stacks across multiple accounts and regions
- Requires administrator and execution roles
- Supports service-managed permissions with AWS Organizations
- Concurrent deployment with failure tolerance settings

**📖 [Stack Sets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)** - Multi-account deployment

#### Resource Protection

- **DeletionPolicy**: Retain, Snapshot, or Delete (default)
- **UpdateReplacePolicy**: Control behavior when resource must be replaced
- **Stack Termination Protection**: Prevent accidental stack deletion

**📖 [DeletionPolicy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html)** - Resource retention

---

### AWS CDK (Cloud Development Kit)

**📖 [AWS CDK](https://docs.aws.amazon.com/cdk/v2/guide/home.html)** - Infrastructure with programming languages

#### Core Concepts

- **App**: Root construct containing one or more stacks
- **Stack**: Unit of deployment (synthesizes to CloudFormation template)
- **Construct**: Cloud component representing one or more AWS resources
  - **L1 (Cfn)**: Direct CloudFormation mapping (e.g., `CfnBucket`)
  - **L2 (Curated)**: AWS-provided abstractions with defaults (e.g., `Bucket`)
  - **L3 (Patterns)**: Multi-resource patterns (e.g., `ApplicationLoadBalancedFargateService`)

**📖 [CDK Constructs](https://docs.aws.amazon.com/cdk/v2/guide/constructs.html)** - Construct levels
**📖 [CDK Stacks](https://docs.aws.amazon.com/cdk/v2/guide/stacks.html)** - Stack management

#### CDK Workflow

1. `cdk init` - Initialize new CDK project
2. Write infrastructure code in TypeScript, Python, Java, C#, or Go
3. `cdk synth` - Synthesize CloudFormation template
4. `cdk diff` - Compare deployed stack with local changes
5. `cdk deploy` - Deploy stack to AWS
6. `cdk destroy` - Remove stack and resources

**📖 [CDK CLI Reference](https://docs.aws.amazon.com/cdk/v2/guide/cli.html)** - CDK commands
**📖 [CDK Workshop](https://cdkworkshop.com/)** - Interactive tutorial

#### CDK Pipelines

- Self-mutating CI/CD pipeline for CDK applications
- Automatically updates the pipeline itself when CDK code changes
- Supports multi-account, multi-region deployments
- Integrates with CodePipeline and CodeBuild

**📖 [CDK Pipelines](https://docs.aws.amazon.com/cdk/v2/guide/cdk_pipeline.html)** - CI/CD for CDK

---

### AWS Elastic Beanstalk

**📖 [AWS Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)** - PaaS for application deployment

#### Deployment Policies

| Policy | Downtime | Speed | Rollback | Use Case |
|--------|----------|-------|----------|----------|
| All at Once | Yes | Fastest | Manual redeploy | Dev/test |
| Rolling | None | Slow | Manual redeploy | Production (cost-sensitive) |
| Rolling with Batch | None | Slow | Manual redeploy | Production (maintain capacity) |
| Immutable | None | Slower | Terminate new ASG | Production (safe) |
| Blue/Green | None | Varies | Swap URLs | Production (zero-risk) |

**📖 [Deployment Policies](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rolling-version-deploy.html)** - Deployment options
**📖 [Blue/Green Deployments](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.CNAMESwap.html)** - Environment swap

#### Configuration

- **.ebextensions/**: YAML/JSON config files for environment customization
- **Platform Hooks**: Scripts executed during deployment lifecycle
- **Saved Configurations**: Reusable environment configurations
- **Environment Properties**: Environment variables accessible to applications

**📖 [Configuration Files](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ebextensions.html)** - .ebextensions reference

---

### Container Services

#### Amazon ECS (Elastic Container Service)

**📖 [Amazon ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)** - Container orchestration

- **Launch Types:**
  - **EC2**: You manage the container instances (more control)
  - **Fargate**: Serverless (AWS manages infrastructure)
- **Task Definitions**: Blueprint for containers (image, CPU, memory, ports, volumes)
- **Services**: Maintain desired count of tasks, integrate with ELB
- **Service Auto Scaling**: Target tracking, step scaling, or scheduled scaling

**📖 [Task Definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)** - Container blueprints
**📖 [ECS Services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html)** - Service management
**📖 [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)** - Serverless containers

#### Amazon EKS (Elastic Kubernetes Service)

**📖 [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)** - Managed Kubernetes

- **Managed Node Groups**: AWS manages EC2 instances for worker nodes
- **Fargate Profiles**: Run pods serverlessly without managing nodes
- **EKS Add-ons**: Managed Kubernetes add-ons (CoreDNS, kube-proxy, VPC CNI)
- **kubectl**: Kubernetes CLI configured with aws eks update-kubeconfig

**📖 [EKS Node Groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)** - Worker nodes
**📖 [EKS Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)** - Serverless pods

#### Amazon ECR (Elastic Container Registry)

**📖 [Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)** - Container image registry

- **Repositories**: Store Docker images with tag immutability option
- **Image Scanning**: Basic (Clair) or Enhanced (Amazon Inspector) vulnerability scanning
- **Lifecycle Policies**: Automatically clean up old or untagged images
- **Cross-Region Replication**: Replicate images across regions
- **Pull Through Cache**: Cache public registry images

**📖 [Image Scanning](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html)** - Vulnerability scanning
**📖 [Lifecycle Policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html)** - Image cleanup

---

### CI/CD Services

#### AWS CodePipeline

**📖 [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)** - CI/CD orchestration

- **Stages**: Source, Build, Test, Deploy (customizable)
- **Actions**: Tasks within stages (source pull, build, deploy, manual approval)
- **Artifacts**: Passed between stages via S3
- **Manual Approval**: Gate deployments with approval actions

#### AWS CodeBuild

**📖 [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html)** - Build service

- **buildspec.yml**: Defines build phases (install, pre_build, build, post_build)
- **Build Environments**: Managed images or custom Docker images
- **Environment Variables**: Plaintext, Parameter Store, or Secrets Manager
- **Caching**: S3 or local caching for dependencies

#### AWS CodeDeploy

**📖 [AWS CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)** - Deployment automation

- **Compute Platforms**: EC2/On-premises, Lambda, ECS
- **Deployment Types**: In-place (rolling) or Blue/green
- **appspec.yml**: Deployment hooks and lifecycle events
- **Rollback**: Automatic rollback on failure or alarm trigger

---

### EC2 Auto Scaling

**📖 [EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)** - Scaling automation

#### Scaling Policies

| Policy Type | Description | Use Case |
|------------|-------------|----------|
| Target Tracking | Maintain metric at target value | Keep CPU at 60% |
| Step Scaling | Scale by different amounts at different thresholds | Graduated response |
| Scheduled | Scale at specific times | Known traffic patterns |
| Predictive | ML-based forecasting | Recurring patterns |

#### Key Configuration

- **Launch Templates**: Instance configuration (AMI, instance type, security groups, user data)
- **Desired/Min/Max Capacity**: Control scaling boundaries
- **Cooldown Period**: Prevent rapid scaling oscillation
- **Health Checks**: EC2 status checks or ELB health checks
- **Instance Refresh**: Rolling replacement of instances for updates

**📖 [Scaling Policies](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html)** - Policy types
**📖 [Launch Templates](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html)** - Instance configuration

---

## 📚 AMI Management

- **AMI Creation**: Create from running or stopped instances
- **AMI Sharing**: Share across accounts or make public
- **AMI Copying**: Copy across regions for DR or global deployment
- **EC2 Image Builder**: Automated pipeline for creating and maintaining AMIs
- **Golden AMI**: Pre-configured base image with security patches and tools

**📖 [EC2 Image Builder](https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html)** - AMI automation

---

## 🎯 Exam Tips for Domain 2

1. **CloudFormation vs CDK**: CDK generates CloudFormation templates; know when to use each
2. **Change Sets**: Always use change sets to preview updates before applying
3. **DeletionPolicy: Retain**: Prevents resource deletion when stack is deleted
4. **Elastic Beanstalk**: Know all deployment policies and their trade-offs
5. **ECS vs EKS**: ECS is simpler and AWS-native; EKS for Kubernetes workloads
6. **Fargate**: No instance management, pay per task resource usage
7. **Auto Scaling**: Target tracking is the simplest and most recommended policy type
8. **Stack Sets**: For multi-account deployment, understand trust relationships
