# Service Comparison - DevOps and CI/CD

## Overview

This guide compares CI/CD services, infrastructure as code tools, and DevOps platforms across AWS, Azure, Google Cloud, and popular third-party options like GitHub Actions and GitLab CI. Understanding these tools is essential for DevOps and platform engineering certification exams.

---

## CI/CD Pipeline Services

### CodePipeline vs Azure DevOps vs Cloud Build

| Feature | AWS CodePipeline | Azure DevOps Pipelines | Google Cloud Build |
|---------|-----------------|------------------------|---------------------|
| Type | Orchestration service | Full CI/CD platform | CI/CD build service |
| Pipeline Definition | JSON/YAML (CloudFormation) | YAML (azure-pipelines.yml) | YAML (cloudbuild.yaml) |
| Source Providers | CodeCommit, S3, GitHub, Bitbucket, ECR | Azure Repos, GitHub, Bitbucket, SVN | Cloud Source Repos, GitHub, Bitbucket |
| Build Service | CodeBuild (separate) | Built-in (hosted/self-hosted agents) | Built-in (workers) |
| Parallel Stages | Yes | Yes (jobs within stages) | Yes (concurrent builds) |
| Manual Approvals | Yes (SNS notifications) | Yes (environments + approvals) | Yes (manual gates) |
| Artifact Storage | S3 + CodeArtifact | Azure Artifacts (feeds) | Artifact Registry |
| Caching | CodeBuild local caching / S3 | Pipeline caching (task) | Kaniko cache / bucket cache |
| Max Pipeline Duration | No limit (stage timeout configurable) | 360 hours (self-hosted), 60 min (hosted free) | 24 hours |
| Free Tier | 1 active pipeline free | 1 parallel job (1,800 min/month) | 120 build-min/day |
| Pricing Model | Per pipeline + per action execution | Per parallel job (hosted/self-hosted) | Per build-minute |
| Self-Hosted Runners | CodeBuild (custom images) | Self-hosted agents | Private pools |
| Test Reporting | CodeBuild test reports | Built-in test analytics | Custom (export to BigQuery) |
| Security Scanning | CodeGuru, Inspector | DevOps security (SARIF) | Binary Authorization, Artifact Analysis |

### GitHub Actions vs GitLab CI

| Feature | GitHub Actions | GitLab CI/CD |
|---------|---------------|--------------|
| Pipeline Definition | YAML (.github/workflows/) | YAML (.gitlab-ci.yml) |
| Runner Types | GitHub-hosted, self-hosted | SaaS runners, self-managed |
| Parallel Jobs | Matrix strategy | Parallel keyword + DAG |
| Caching | actions/cache | Built-in cache (key-based) |
| Artifacts | Upload/download actions | Job artifacts |
| Environments | Environments + protection rules | Environments + approval gates |
| Container Registry | GitHub Container Registry (ghcr.io) | GitLab Container Registry |
| Package Registry | GitHub Packages | GitLab Package Registry |
| Secret Management | Repository/organization/environment secrets | CI/CD variables (protected/masked) |
| OIDC | Supported (cloud provider federation) | Supported (cloud provider federation) |
| Reusable Workflows | Reusable workflows + composite actions | Include templates + extends |
| Free Tier | 2,000 min/month (public repos unlimited) | 400 CI/CD min/month |
| Self-Hosted Pricing | Free (unlimited minutes) | Free (unlimited minutes) |
| Security Scanning | Dependabot, CodeQL, secret scanning | SAST, DAST, dependency scanning, secret detection |
| Marketplace | 20,000+ actions | CI/CD catalog |

---

## Build Services Deep Dive

### AWS CodeBuild vs Azure Pipelines Agents vs Cloud Build Workers

| Feature | AWS CodeBuild | Azure Pipelines (Hosted) | Google Cloud Build |
|---------|--------------|---------------------------|---------------------|
| Compute Options | 7 sizes (3 GB to 145 GB RAM) | Standard (6 GB), Large (16 GB) | Standard, High CPU, E2 |
| Custom Images | Yes (Docker images) | Yes (container jobs) | Yes (custom builders) |
| GPU Support | Yes | No (hosted), Yes (self-hosted) | No |
| Build Cache | Local, S3 | Pipeline caching | Kaniko layer cache |
| Concurrent Builds | Account limits (adjustable) | Parallel jobs (1 free) | 30 concurrent (adjustable) |
| Build Timeout | 8 hours (default), 480 min (max) | 60 min (free), 360 hours (paid) | 24 hours |
| VPC Access | VPC integration | Self-hosted agent in VNet | Private pool in VPC |
| Batch Builds | Yes (build graph) | N/A | Yes (build triggers) |
| Local Testing | CodeBuild local agent | N/A | cloud-build-local |
| Buildspec | buildspec.yml | azure-pipelines.yml | cloudbuild.yaml |

---

## Source Code Management

### CodeCommit vs Azure Repos vs Cloud Source Repositories

| Feature | AWS CodeCommit | Azure Repos | Google Cloud Source Repos |
|---------|---------------|-------------|---------------------------|
| Status | No new customers (2024) | Active | Active |
| Git Hosting | Yes | Yes (Git + TFVC) | Yes (mirrors GitHub/Bitbucket) |
| Pull Requests | Yes (basic) | Yes (rich PR experience) | No (use mirrored repo) |
| Branch Policies | Limited | Comprehensive | Limited |
| Code Search | Basic | Semantic code search | Basic |
| Integration | CodePipeline, CodeBuild | Azure Pipelines, Boards | Cloud Build triggers |
| Pricing | Free (5 users), then per user | Free (5 users, unlimited private repos) | Free (5 users, 50 GB) |

Note: Most teams use GitHub or GitLab as their primary source repository regardless of cloud provider.

---

## Artifact Management

### CodeArtifact vs Azure Artifacts vs Artifact Registry

| Feature | AWS CodeArtifact | Azure Artifacts | Google Artifact Registry |
|---------|-----------------|-----------------|--------------------------|
| Package Types | npm, PyPI, Maven, NuGet, Swift, Cargo | npm, NuGet, Maven, Python, Universal | Docker, npm, Python, Maven, Go, Apt, Yum |
| Container Registry | No (use ECR) | No (use ACR) | Yes (integrated) |
| Upstream Sources | Public registries, other domains | Public registries, other feeds | Public registries (remote repos) |
| Retention Policies | N/A | Retention policies per feed | Cleanup policies |
| Vulnerability Scanning | N/A (use Inspector) | N/A (use Defender) | Artifact Analysis |
| Cross-Account Sharing | Cross-account policies | Organization-scoped feeds | Cross-project IAM |
| Pricing | Per GB stored + per request | Free (2 GB), then per GB | Per GB stored + per request |

---

## Infrastructure as Code

### CloudFormation vs Bicep/ARM vs Deployment Manager/Terraform

| Feature | AWS CloudFormation | Azure Bicep/ARM | Google Deployment Manager |
|---------|-------------------|-----------------|---------------------------|
| Language | JSON/YAML | Bicep (DSL) / ARM JSON | YAML + Jinja2/Python |
| State Management | Managed (stack state) | Managed (deployment state) | Managed (deployment state) |
| Drift Detection | Yes | What-if (preview) | Preview |
| Modules/Reuse | Nested stacks, modules | Modules, template specs | Templates, composites |
| Rollback | Automatic on failure | N/A (manual) | N/A (manual) |
| Import Existing | Resource import | N/A | N/A |
| Cross-Account | StackSets | Deployment stacks | N/A |
| Change Preview | Change sets | What-if | Preview |
| Custom Resources | Lambda-backed | Deployment scripts | N/A |

### Terraform Cross-Cloud Comparison

| Feature | AWS Provider | Azure Provider | Google Provider |
|---------|-------------|----------------|-----------------|
| Resources | 1,300+ | 1,000+ | 900+ |
| Data Sources | 600+ | 400+ | 400+ |
| Authentication | IAM roles, access keys | Service principal, managed identity, CLI | Service account, application default |
| State Backend | S3 + DynamoDB | Azure Storage + blob lease | GCS |
| Import Support | Yes (import block) | Yes (import block) | Yes (import block) |
| Community Modules | 8,000+ | 3,000+ | 2,000+ |

---

## Deployment Strategies

### Blue/Green and Canary Deployment

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Compute | CodeDeploy (EC2, ECS, Lambda) | Azure DevOps + slots / Traffic Manager | Cloud Deploy (GKE, Cloud Run) |
| Kubernetes | CodeDeploy (EKS) / Argo Rollouts | Flagger / Argo Rollouts | Cloud Deploy + Skaffold |
| Serverless | Lambda aliases + weighted routing | Deployment slots | Cloud Run traffic splitting |
| Feature Flags | CloudWatch Evidently (deprecated) | App Configuration | Firebase Remote Config |
| Progressive Delivery | CodeDeploy (linear/canary) | Flagger | Cloud Deploy (canary strategy) |
| Rollback | Automatic (CodeDeploy) | Manual / automated (pipelines) | Automatic (Cloud Deploy) |

### GitOps Tools

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Native GitOps | Flux (EKS add-on) | Flux (Arc extension) | Config Sync |
| ArgoCD Support | Self-managed on EKS | Self-managed on AKS | Self-managed on GKE |
| Config Management | Systems Manager | Azure Automation / Arc | OS Config |
| Policy as Code | OPA/Gatekeeper | Azure Policy / OPA | Policy Controller |

---

## DevOps Monitoring and Feedback

### Pipeline Observability

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Build Metrics | CodeBuild CloudWatch metrics | Pipeline analytics | Cloud Build insights |
| Deployment Tracking | CodeDeploy dashboards | Release analytics | Cloud Deploy delivery pipeline |
| DORA Metrics | Custom (via CloudWatch) | Built-in DORA metrics | Custom (via Cloud Monitoring) |
| Failure Alerts | SNS + EventBridge | Service hooks + notifications | Pub/Sub + Cloud Functions |
| Test Analytics | CodeBuild test reports | Test analytics (trends) | Custom |

### Software Supply Chain Security

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| SBOM Generation | Inspector SBOM export | DevOps + Defender | Artifact Analysis |
| Image Signing | ECR + Notation/cosign | ACR + Notation | Binary Authorization |
| Provenance | CodeBuild attestation | N/A | SLSA provenance (Cloud Build) |
| Vulnerability Scanning | Inspector, ECR scanning | Defender for DevOps | Artifact Analysis |
| Policy Enforcement | Inspector + EventBridge | Azure Policy / Defender | Binary Authorization |
| SLSA Level | Level 3 (CodeBuild) | N/A | Level 3 (Cloud Build) |
| Dependency Review | Inspector | Dependabot (GitHub integration) | Artifact Analysis |

---

## CI/CD Pipeline Patterns

### Recommended Architecture per Cloud

**AWS Pipeline Architecture:**
```
GitHub/CodeCommit -> CodePipeline -> CodeBuild -> ECR -> CodeDeploy -> ECS/EKS
                                        |
                                   CodeArtifact (packages)
                                   Inspector (scanning)
```

**Azure Pipeline Architecture:**
```
Azure Repos/GitHub -> Azure Pipelines -> ACR -> Azure Pipelines (release) -> AKS/App Service
                                          |
                                     Azure Artifacts
                                     Defender for DevOps
```

**GCP Pipeline Architecture:**
```
GitHub/CSR -> Cloud Build -> Artifact Registry -> Cloud Deploy -> GKE/Cloud Run
                                    |
                              Artifact Analysis
                              Binary Authorization
```

---

## Cost Comparison

### Monthly Cost Estimate (Small Team - 5 Developers)

| Service | AWS | Azure | GCP | GitHub Actions |
|---------|-----|-------|-----|----------------|
| CI/CD Pipeline | ~$5 (CodePipeline) | ~$40 (1 parallel job) | ~$10 (Cloud Build) | Free (2,000 min) |
| Build Minutes (500 builds/mo) | ~$50 (CodeBuild) | Included | ~$15 | Included |
| Artifact Storage (10 GB) | ~$2 (CodeArtifact) | Free (first 2 GB) | ~$3 | Included |
| Container Registry (50 GB) | ~$5 (ECR) | ~$5 (ACR Basic) | ~$5 | Free (ghcr.io) |
| Total Estimate | ~$62/month | ~$45/month | ~$33/month | Free-$10/month |

---

## Certification Exam Focus Areas

### AWS DevOps Professional (DOP-C02)
- CodePipeline stages, actions, and transitions
- CodeBuild buildspec.yml structure and environment variables
- CodeDeploy deployment configurations (in-place, blue/green)
- CloudFormation stack policies, drift detection, StackSets
- EventBridge integration for pipeline automation

### Azure DevOps Engineer Expert (AZ-400)
- Azure Pipelines YAML vs Classic
- Multi-stage pipeline design
- Azure Artifacts feeds and upstream sources
- Deployment slots and swap operations
- Azure Boards integration and work item tracking

### Google Cloud DevOps Engineer
- Cloud Build trigger types and substitution variables
- Cloud Deploy delivery pipelines and targets
- Artifact Registry cleanup policies
- Binary Authorization attestation workflow
- SRE principles and error budgets

---

## Documentation Links

- AWS CodePipeline: https://docs.aws.amazon.com/codepipeline/latest/userguide/
- AWS CodeBuild: https://docs.aws.amazon.com/codebuild/latest/userguide/
- AWS CodeDeploy: https://docs.aws.amazon.com/codedeploy/latest/userguide/
- Azure DevOps: https://learn.microsoft.com/en-us/azure/devops/
- Azure Pipelines: https://learn.microsoft.com/en-us/azure/devops/pipelines/
- Google Cloud Build: https://cloud.google.com/build/docs
- Google Cloud Deploy: https://cloud.google.com/deploy/docs
- GitHub Actions: https://docs.github.com/en/actions
- GitLab CI/CD: https://docs.gitlab.com/ee/ci/
- Terraform: https://developer.hashicorp.com/terraform/docs

---

## Key Takeaways

1. **Azure DevOps** provides the most complete all-in-one DevOps platform (repos, boards, pipelines, artifacts, test plans)
2. **GitHub Actions** offers the best developer experience and marketplace ecosystem
3. **AWS CodePipeline** is most suitable when deep AWS integration is required
4. **Cloud Build** is cost-effective and provides strong supply chain security (SLSA Level 3)
5. **GitLab CI/CD** excels in built-in security scanning (SAST, DAST, dependency scanning)
6. Most organizations use a hybrid approach - GitHub/GitLab for source + cloud-native tools for deployment
7. GitOps (Flux/ArgoCD) is becoming the standard for Kubernetes deployments across all clouds
8. Supply chain security (SBOM, signing, provenance) is increasingly important for exam questions
