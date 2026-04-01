# Deployment, Provisioning, and Automation

**[AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)** - Infrastructure as Code service

## AWS CloudFormation

### Template Anatomy

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Template description
Parameters:       # Input values at stack creation
Mappings:         # Static key-value lookups
Conditions:       # Conditional resource creation
Resources:        # AWS resources to create (REQUIRED)
Outputs:          # Values to return after creation
```

**[Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)** - Complete template syntax

### Parameters
- User inputs at stack creation or update time
- Types: String, Number, CommaDelimitedList, AWS-specific types
- Constraints: AllowedValues, MinLength, MaxLength, Default
- AWS-specific types: AWS::EC2::VPC::Id, AWS::EC2::Subnet::Id, etc.
- **SSM Parameter type** - resolve values from Parameter Store at deploy time

### Intrinsic Functions
- **Ref** - reference parameters and resource logical IDs
- **Fn::GetAtt** - get attributes from resources
- **Fn::Join** - concatenate strings
- **Fn::Sub** - substitute variables in strings
- **Fn::Select** - select from a list
- **Fn::Split** - split a string into a list
- **Fn::ImportValue** - import from another stack's exports
- **Fn::If** - conditional values based on conditions
- **Fn::Base64** - encode to Base64 (user data)

### Conditions
- Create resources conditionally based on parameter values
- Use with Fn::If in resource properties
- Example: Create resources only in production environment

### Mappings
- Static key-value lookups (no dynamic values)
- Use with Fn::FindInMap to retrieve values
- Common use: AMI IDs per region, environment-specific settings

### Outputs
- Return values after stack creation
- Export values for cross-stack references
- Use Fn::ImportValue in other stacks to consume exports

## Stack Operations

### Stack Creation and Updates

**Create Stack**:
- Upload template to S3 or provide inline
- Specify parameters and tags
- Configure IAM role for CloudFormation
- Enable termination protection for production stacks

**Update Stack**:
- Direct update or change set
- Update behaviors: no interruption, some interruption, replacement
- Rollback on failure (default behavior)
- Stack policy to prevent unintended updates to specific resources

**[Stack Updates](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks.html)** - Updating stacks safely

### Change Sets
- Preview changes before applying updates
- Shows resources to be added, modified, or replaced
- Does not indicate if update will succeed
- Best practice: always use change sets for production updates

**[Change Sets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html)** - Preview stack changes

### Drift Detection
- Detect when resources have been modified outside CloudFormation
- Compare actual configuration with template definition
- Resource drift status: IN_SYNC, MODIFIED, DELETED
- Stack drift status: DRIFTED, IN_SYNC, NOT_CHECKED

**[Drift Detection](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift.html)** - Detect configuration drift

### Rollback Behavior
- **CREATE_FAILED** - all resources rolled back and deleted by default
- **UPDATE_ROLLBACK_FAILED** - stack stuck, may need manual intervention
- **Continue rollback** - skip resources causing rollback failure
- Disable rollback for debugging (not recommended for production)

### Deletion Policies
- **Delete** (default) - resource deleted with stack
- **Retain** - resource preserved after stack deletion
- **Snapshot** - create snapshot before deletion (EBS, RDS, Redshift)

## StackSets

**[StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)** - Multi-account, multi-region deployment

### Key Concepts
- **Administrator account** - creates and manages stack sets
- **Target accounts** - accounts where stack instances are deployed
- **Stack instances** - reference to a stack in a target account/region
- **Self-managed** or **service-managed** (with Organizations) permissions

### Deployment Options
- Deploy to specific accounts and regions
- Deploy to organizational units (OUs) with Organizations
- Concurrent or sequential deployment across regions
- Failure tolerance and max concurrent accounts settings
- Automatic deployment to new accounts in an OU

## Nested Stacks

- Reusable template components referenced from parent stack
- Parent stack manages lifecycle of nested stacks
- Use for common patterns (VPC, security groups, ALB)
- Template URL points to S3 location of nested template

**[Nested Stacks](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html)** - Modular templates

## Custom Resources

- Extend CloudFormation with Lambda-backed custom logic
- Use for resources not natively supported
- Send response to pre-signed S3 URL
- Common uses: AMI lookup, external API calls, complex logic

## AWS CDK

**[AWS CDK](https://docs.aws.amazon.com/cdk/v2/guide/home.html)** - Define infrastructure using programming languages

### Core Concepts

**Constructs** - building blocks of CDK applications:
- **L1 (CFN Resources)** - direct CloudFormation resource mapping
- **L2 (Curated)** - higher-level, opinionated constructs with sensible defaults
- **L3 (Patterns)** - complete architectures (e.g., ApplicationLoadBalancedFargateService)

**[CDK Constructs](https://docs.aws.amazon.com/cdk/v2/guide/constructs.html)** - Understanding construct levels

**Apps and Stacks**:
- App is the root construct
- Stacks map to CloudFormation stacks
- Multiple stacks in one app for modular deployment

**Synthesis** - CDK code compiles to CloudFormation templates:
- `cdk synth` generates CloudFormation template
- `cdk deploy` deploys the synthesized template
- `cdk diff` shows changes between deployed and local

### CDK Pipelines
- Self-mutating CI/CD pipeline for CDK applications
- Pipeline updates itself when CDK code changes
- Stages for multi-environment deployment
- Built on CodePipeline

**[CDK Pipelines](https://docs.aws.amazon.com/cdk/v2/guide/cdk_pipeline.html)** - CI/CD for CDK

### CDK vs CloudFormation
- CDK: programming languages, IDE support, testing, abstractions
- CloudFormation: declarative, YAML/JSON, direct template control
- CDK synthesizes to CloudFormation - same deployment engine
- Use CDK for complex logic, CloudFormation for simpler templates

## AWS Systems Manager Automation

**[SSM Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)** - Operational runbooks

### Automation Documents (Runbooks)
- YAML or JSON format defining automation steps
- Pre-built AWS runbooks for common tasks
- Custom runbooks for organization-specific workflows
- Steps: aws:executeScript, aws:runCommand, aws:approve, aws:sleep

### Common Automation Use Cases
- Patch management with maintenance windows
- AMI creation and distribution
- Instance remediation (restart, reboot)
- Compliance enforcement
- Resource provisioning and decommissioning

### State Manager
- Maintain desired state configuration for managed instances
- Associate SSM documents with target instances
- Schedule compliance checks and remediation
- Example: ensure CloudWatch agent is always running

## AWS OpsWorks

**[AWS OpsWorks](https://docs.aws.amazon.com/opsworks/latest/userguide/welcome.html)** - Configuration management

### OpsWorks Stacks
- Uses Chef for configuration management
- Layers define instance configuration (web, app, database)
- Auto-healing replaces failed instances
- Lifecycle events: Setup, Configure, Deploy, Undeploy, Shutdown

### OpsWorks for Chef Automate
- Fully managed Chef server
- Chef cookbooks for configuration
- Compliance scanning and reporting

### OpsWorks for Puppet Enterprise
- Fully managed Puppet master
- Puppet modules for configuration
- Node management and reporting

## AWS Elastic Beanstalk

**[Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)** - PaaS for application deployment

### Environment Types
- **Web Server** - handles HTTP requests (ALB + EC2 ASG)
- **Worker** - processes background tasks (SQS + EC2 ASG)

### Deployment Strategies

**All at once** - deploy to all instances simultaneously:
- Fastest but causes downtime
- Good for development environments

**Rolling** - deploy in batches:
- Reduces capacity during deployment
- No downtime but reduced capacity

**Rolling with additional batch** - launch new instances first:
- Maintains full capacity during deployment
- Takes longer than rolling

**Immutable** - deploy to new instances in new ASG:
- No impact to existing instances
- Quick rollback by terminating new ASG
- Higher cost during deployment

**Blue/Green** - deploy to separate environment:
- Zero downtime
- Swap URLs or use Route 53 for traffic switching
- Full rollback capability

**[Deployment Policies](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rolling-version-deploy.html)** - Deployment options

### Configuration
- **.ebextensions/** - YAML configuration files in source bundle
- **Saved configurations** - reusable environment configurations
- **Environment properties** - environment variables
- Platform updates - managed or immutable

## CI/CD with AWS Code Services

### AWS CodePipeline

**[CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)** - Continuous delivery service

**Pipeline Structure**:
- **Stages** - logical groups of actions
- **Actions** - tasks within stages (source, build, test, deploy, approval)
- **Transitions** - connections between stages (can be disabled)
- **Artifacts** - input and output data between stages

**Common Pipeline Pattern**:
1. Source: CodeCommit, GitHub, S3
2. Build: CodeBuild
3. Test: CodeBuild or third-party
4. Approval: Manual approval action
5. Deploy: CodeDeploy, CloudFormation, ECS, Elastic Beanstalk

### AWS CodeBuild

**[CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html)** - Managed build service

- **buildspec.yml** defines build commands and phases
- Phases: install, pre_build, build, post_build
- Managed and custom build environments
- Build caching for faster builds
- VPC support for accessing private resources

### AWS CodeDeploy

**[CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)** - Deployment automation

**Deployment Targets**:
- EC2 instances and on-premises servers
- Lambda functions
- ECS services

**Deployment Configurations**:
- **In-place** (EC2 only) - update existing instances
- **Blue/green** - deploy to new instances, switch traffic
- **Canary** - shift traffic in two increments
- **Linear** - shift traffic in equal increments

**appspec.yml** - deployment specification:
- Lifecycle hooks: BeforeInstall, AfterInstall, ApplicationStart, ValidateService
- Files section: source and destination for application files
- Permissions section: file permissions

## Key Takeaways

1. **CloudFormation** - know template anatomy, intrinsic functions, and update behaviors
2. **Change sets** - always preview changes before updating production stacks
3. **StackSets** - multi-account and multi-region deployment with Organizations
4. **Drift detection** - identify resources modified outside CloudFormation
5. **CDK** - programming language abstraction that synthesizes to CloudFormation
6. **Elastic Beanstalk** - know all deployment strategies and their trade-offs
7. **CodePipeline** - understand pipeline stages, actions, and common patterns
8. **CodeDeploy** - in-place vs blue/green, appspec.yml lifecycle hooks
9. **SSM Automation** - runbooks for automated operational tasks
10. **Deletion policies** - Retain and Snapshot protect resources on stack deletion
