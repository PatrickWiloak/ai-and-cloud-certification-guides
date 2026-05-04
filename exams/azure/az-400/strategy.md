---
last-updated: 2026-05-03
---

# Azure DevOps Engineer Expert (AZ-400) - Exam Strategy

## Format reminder

- 40-60 questions, 100-120 minutes
- Pass mark: 700 / 1000 (70%)
- Multiple choice, multiple response, drag-and-drop, occasional case studies
- AZ-104 OR AZ-204 is the prerequisite cert before AZ-400

## Top traps

1. **Azure DevOps Services vs GitHub** - both are Microsoft, both tested. Know which features are GitHub-only (Actions, Codespaces, Copilot) vs ADO-only (Boards work item types, Test Plans). GHAS works in both with subset differences.

2. **Bicep vs ARM JSON vs Terraform**: Bicep is the modern AZ-400 default unless the question specifies multi-cloud (then Terraform). ARM JSON is legacy but appears in older content.

3. **Service connections**: managed identity > service principal with secret > service principal with certificate (for highest security) - all > username/password. Memorize the hierarchy.

4. **Pipeline YAML structure**: stages → jobs (parallel by default within a stage) → steps (sequential within a job) → tasks. Know how `dependsOn` and `condition` modify defaults.

5. **Variable groups vs library vs Key Vault**: variable groups are reusable across pipelines; library is the umbrella; Key Vault is for secrets pulled into a variable group.

6. **Approvals vs branch policies**: branch policies gate code merging; environment approvals gate deployments. Different stages of the lifecycle.

7. **Deployment slots in App Service**: blue/green at the slot level (Production + Staging). Slot swap is the cutover; warm-up requests come built-in. Slot-specific settings (sticky to slot) vs not.

8. **GitOps with Azure**: Flux v2 / Argo CD as the GitOps engine, with Bicep/Helm/Kustomize as the source format. Microsoft has a Flux extension for AKS.

9. **Application Insights data**: requests, dependencies, exceptions, traces, custom events, page views, availability tests. Each has a sampling strategy. Sampling = trade detail for cost.

10. **Secret rotation**: Key Vault with rotation policies; Managed Identities to avoid storing secrets at all where possible (Azure SQL, Storage, etc., support MI auth).

## High-yield topics easy to miss

- Azure DevOps Boards: Agile / Scrum / CMMI process templates - know which features differ
- Azure Test Plans (manual + exploratory testing)
- Azure Artifacts feeds (NuGet, npm, Maven, Python) with upstream sources
- Universal Packages (versioned binaries up to 4 TB)
- Container Registry: image signing with Notary v2, vulnerability scanning, replication, geo-replication
- Azure Container Apps vs AKS - know when each is appropriate
- AKS extensions (Flux, Open Service Mesh, Dapr) and add-ons (Container Insights, Defender, Azure Policy)
- Microsoft Defender for DevOps (formerly Defender for Cloud DevOps)
- Azure Monitor Workbooks, Insights, Dashboards - subtle differences

## Time management

100-120 / ~50 = ~2 min/question. AZ-400 case studies have multiple questions; budget 15 min total per case study. Pace: half done by halfway through your time budget.

## When stuck

1. **Eliminate "configure manually" answers** - AZ-400 favors automation.
2. **Default to Bicep** in IaC questions unless multi-cloud is specified.
3. **Default to managed identities** over service principals for Azure resource auth.
4. **Choose the Microsoft-recommended pattern** - the exam often tests recognition of Microsoft DevOps practices, not raw technical correctness.

## Day-of logistics

100-120 min for ~50 questions. Bring two IDs.

## After

**Pass:** Cert valid 1 year (annual renewal via free online assessment).

**Fail:** Most failures are on Source Control (~10%) or Continuous Delivery (~30-40%). Re-review Pipeline YAML structure, Environments + approvals, deployment slots.

## AZ-400 patterns

- "Branch protection / required reviewers" = Azure Repos Branch Policies
- "Pipeline secrets" = Key Vault + Variable Group with Key Vault link
- "IaC for Azure" = Bicep
- "Multi-environment promotion with approvals" = Pipeline Environments + approval gates
- "Progressive rollout" = deployment rings + slots / traffic split + App Insights alerts
- "Centralized observability" = Azure Monitor + App Insights + Log Analytics + Workbooks
- "Self-hosted agents at scale" = VMSS agent pool
- "Service connections" = managed identity > SP+cert > SP+secret
- "Secret + SAST + dependency scanning on ADO" = GHAS for Azure DevOps
- "GitOps for AKS" = Flux v2 with the Azure GitOps extension
