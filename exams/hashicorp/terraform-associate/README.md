# HashiCorp Terraform Associate (003) Certification

## Exam Overview

The HashiCorp Terraform Associate (003) certification validates your knowledge of basic concepts and skills associated with HashiCorp Terraform. This certification is designed for cloud engineers, DevOps professionals, and infrastructure administrators who use Terraform to manage and automate infrastructure provisioning. The exam covers Infrastructure as Code (IaC) concepts, Terraform workflows, state management, modules, and configuration language fundamentals.

**Exam Code:** Terraform Associate (003)
**Exam Duration:** 60 minutes
**Number of Questions:** 57 questions
**Exam Format:** Multiple choice and fill-in-the-blank
**Passing Score:** 70%
**Cost:** $70.50 USD
**Proctoring:** PSI online proctoring
**Validity:** 2 years
**Prerequisites:** None (recommended 6+ months hands-on Terraform experience)

## Exam Domains

### Domain 1: Understand Infrastructure as Code (IaC) concepts (15%)
- Explain what IaC is
- Describe advantages of IaC patterns
- Understand key IaC principles (idempotency, declarative vs imperative)
- Compare Terraform to other IaC tools (CloudFormation, Ansible, Pulumi)

### Domain 2: Understand the purpose of Terraform (15%)
- Explain multi-cloud and provider-agnostic benefits
- Explain the benefits of state
- Describe Terraform workflow (Write, Plan, Apply)
- Understand Terraform use cases
- Describe how Terraform works with providers and plugins

### Domain 3: Understand Terraform basics (20%)
- Handle Terraform and provider installation and versioning
- Describe plugin-based architecture
- Write Terraform configuration using HCL
- Understand Terraform settings, providers, and required_providers
- Understand resource arguments, attributes, and meta-arguments
- Use provisioners as a last resort
- Describe built-in dependency management (implicit and explicit)

### Domain 4: Use Terraform outside of core workflow (10%)
- Describe when to use terraform import
- Use terraform state command
- Describe when to use terraform taint and terraform replace
- Describe terraform workspace and its use cases
- Describe Terraform debugging (TF_LOG)

### Domain 5: Interact with Terraform modules (10%)
- Contrast and use different module sources
- Interact with module inputs and outputs
- Describe variable scope within modules/child modules
- Set module version
- Use the Terraform Registry

### Domain 6: Use the core Terraform workflow (15%)
- Describe the Terraform workflow (init, validate, plan, apply, destroy)
- Initialize a Terraform working directory (terraform init)
- Validate a Terraform configuration (terraform validate)
- Generate and review an execution plan (terraform plan)
- Execute changes to infrastructure (terraform apply)
- Destroy Terraform-managed infrastructure (terraform destroy)

### Domain 7: Implement and maintain state (15%)
- Describe default local backend
- Describe state locking
- Handle backend and cloud integration configuration
- Describe remote state storage mechanisms (S3, GCS, Consul, Terraform Cloud)
- Understand state file purpose and function
- Describe terraform refresh and its behavior
- Describe backend authentication methods
- Describe remote state data source

## Key Study Areas

### Terraform Configuration Language (HCL)
- **Resources:** Defining infrastructure components
- **Data Sources:** Querying existing infrastructure
- **Variables:** Input, output, and local values
- **Expressions:** Conditional logic, loops, and functions
- **Providers:** Cloud and service provider plugins
- **Provisioners:** Last-resort configuration management

### State Management
- **Local State:** Default file-based storage
- **Remote Backends:** S3, GCS, Azure Blob, Consul, Terraform Cloud
- **State Locking:** Preventing concurrent modifications
- **State Commands:** list, mv, rm, pull, push, import
- **Sensitive Data:** Managing secrets in state files

### Modules
- **Module Structure:** Root and child modules
- **Module Sources:** Local, registry, GitHub, S3
- **Module Registry:** Public and private registries
- **Module Versioning:** Constraining module versions
- **Module Composition:** Building reusable infrastructure patterns

### Core Workflow
- **terraform init:** Initialize working directory, download providers
- **terraform plan:** Preview changes before applying
- **terraform apply:** Execute infrastructure changes
- **terraform destroy:** Remove managed infrastructure
- **terraform fmt:** Format configuration files
- **terraform validate:** Check configuration syntax

### Advanced Features
- **Workspaces:** Managing multiple environments
- **Import:** Bringing existing resources under management
- **Debugging:** Using TF_LOG for troubleshooting
- **Provisioners:** local-exec and remote-exec
- **Dynamic Blocks:** Generating repeated nested blocks

## Hands-On Skills Required

### CLI Proficiency
- **terraform init:** Provider and module initialization
- **terraform plan/apply:** Infrastructure deployment
- **terraform state:** State manipulation commands
- **terraform workspace:** Environment management
- **terraform import:** Importing existing resources

### Configuration Writing
- **Resource definitions and data sources**
- **Variable declarations and type constraints**
- **Output values and expressions**
- **Module calls and composition**
- **Provider configuration and aliasing**

### Infrastructure Patterns
- **Multi-environment deployments (dev/staging/prod)**
- **Modular infrastructure design**
- **Remote state with locking**
- **Provider version constraints**
- **Resource dependency management**

## Study Tips

1. **Hands-On Practice:** Build real infrastructure with Terraform on any cloud provider
2. **Use Free Tiers:** Leverage AWS Free Tier or GCP credits for practice
3. **Read Documentation:** Study the official Terraform documentation thoroughly
4. **Write HCL:** Practice writing configurations from scratch, not just copying
5. **State Management:** Understand how state works - this is heavily tested
6. **Module Design:** Build and publish your own modules for practice
7. **Terraform Cloud:** Set up a free account and practice remote operations
8. **Practice Exams:** Take official HashiCorp practice exams

## Comprehensive Study Resources

### Quick Links (Terraform Associate Specific)
- **[Terraform Associate Exam Page](https://www.hashicorp.com/certifications/terraform-associate)** - Registration and exam details
- **[Terraform Documentation](https://developer.hashicorp.com/terraform/docs)** - Complete Terraform documentation
- **[Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials)** - Official hands-on tutorials
- **[Terraform Registry](https://registry.terraform.io/)** - Providers, modules, and policies
- **[Terraform Associate Study Guide](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003)** - Official study guide
- **[Terraform Exam Review](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-review-003)** - Official exam review

### Recommended Courses
- HashiCorp Learn Terraform tutorials (free)
- Bryan Krausen - Terraform Associate on Udemy
- Andrew Brown - Terraform Associate on freeCodeCamp (free)
- KodeKloud Terraform for Beginners

### Practice Resources
- HashiCorp official practice exam
- Bryan Krausen practice tests on Udemy
- Tutorials Dojo Terraform practice exams
- Hands-on labs with Terraform Cloud free tier

## Exam Registration

Register through:
- **PSI Online:** Online proctored exam via PSI
- **HashiCorp Certification Portal:** [hashicorp.com/certifications](https://www.hashicorp.com/certifications)

## Exam Day Preparation

### Technical Setup (Online Exam)
- Stable internet connection
- Webcam and microphone
- Clean, quiet workspace
- Valid government-issued ID
- PSI Secure Browser installed

### Exam Strategy
1. **Read questions carefully:** Pay attention to exact wording and keywords
2. **Eliminate wrong answers:** Use process of elimination
3. **Flag uncertain questions:** Review flagged questions at the end
4. **Time management:** ~1 minute per question with review time
5. **Practical thinking:** Apply hands-on experience to scenarios

### Common Question Types
- **Concept questions:** IaC benefits, Terraform purpose
- **Configuration questions:** HCL syntax, resource definitions
- **Workflow questions:** Correct command sequences
- **State questions:** Backend configuration, state management
- **Module questions:** Sources, versioning, composition

## Career Benefits

### Job Opportunities
- Cloud Infrastructure Engineer
- DevOps Engineer
- Site Reliability Engineer
- Platform Engineer
- Cloud Solutions Architect

### Professional Development
- Foundation for Terraform Authoring and Operations certifications
- Industry recognition for IaC skills
- Technical credibility with HashiCorp ecosystem
- Multi-cloud infrastructure management expertise

## Next Steps After Certification

### Advanced Certifications
- **Terraform Authoring Associate:** Advanced configuration and patterns
- **Vault Associate:** Secrets management and security
- **Consul Associate:** Service networking and discovery

### Continuous Learning
- Stay updated with new Terraform features and providers
- Contribute to Terraform providers and modules
- Practice multi-cloud infrastructure patterns
- Explore Terraform Cloud and Enterprise features
