---
last-updated: 2026-05-03
---

# Azure DevOps Engineer Expert (AZ-400) - Exam Scenarios

> Eight worked scenarios mirroring AZ-400 question style. AZ-400 tests Azure DevOps Services (Boards, Repos, Pipelines, Artifacts, Test Plans), GitHub integration, and the broader Microsoft DevOps practices around source control, CI/CD, IaC, monitoring, and security.

---

## Scenario 1 - Branching strategy with required reviews (Domain: Source Control)

A team uses Azure Repos and wants: protected `main` branch (no direct pushes), all changes via PR with 2 reviewers and CI passing, build validation for changes touching `/infra/*`.

Which fits?

A. Branch policies on `main`: require minimum 2 reviewers, require build validation triggered on the infra path, require linked work item, require resolution of all comments.
B. Pre-commit hooks on every developer's machine.
C. Server-side hooks in Git.
D. Azure Pipelines triggers only.

**Analysis**

A is right: Azure Repos branch policies are the native enforcement: required reviewers (with optional auto-include), build validation policies (path-filtered if needed), required linked work items, comment resolution. B is client-side and bypassable. C is git server hooks; Azure Repos uses branch policies, not raw hooks. D is the build, not the gate.

**Answer:** A

**Key takeaway:** Azure Repos governance = branch policies (reviewers, builds, comments, work items). GitHub equivalent is branch protection rules. Both are server-side enforcement.

---

## Scenario 2 - Pipeline parallelization (Domain: CI/CD)

A monorepo build serially runs unit tests, integration tests, security scans, and packaging - taking 45 min. The team wants <15 min total.

Which fits?

A. Restructure pipeline into stages with parallel jobs: unit + integration + security in parallel, then packaging stage; use Microsoft-hosted agents with appropriate parallel job count.
B. Buy more Microsoft-hosted parallelism slots; same serial pipeline.
C. Switch to GitHub Actions.
D. Use a single self-hosted agent with more cores.

**Analysis**

A is right: pipeline restructure with parallel jobs is the highest-leverage change. Stages run sequentially but jobs within a stage run in parallel; if you have enough parallelism slots, the three test types complete in max(unit, integration, security) instead of their sum. B doesn't help if the pipeline is serial. C is a tool change, not the actual fix. D - one agent doesn't run jobs in parallel; you need multiple agents/slots.

**Answer:** A

**Key takeaway:** Azure Pipelines parallelism = multiple jobs in a stage + enough parallel-job slots. Stages are sequential by default; jobs in a stage are parallel by default. Memorize the YAML structure.

---

## Scenario 3 - Secrets in Pipelines (Domain: Security in Pipelines)

A Pipeline needs database credentials and API keys. They must not appear in logs and must be rotatable.

Which fits?

A. Azure Key Vault + Variable Group linked to Key Vault; reference variables in YAML; mark variables as secret in any custom variables.
B. Encrypted strings in YAML committed to the repo.
C. Plain environment variables in pipeline definitions.
D. Secrets in Azure DevOps Library marked as secret.

**Analysis**

A is right: Key Vault is the central secret store with rotation, audit, and IAM-based access. Linking Variable Groups to Key Vault pulls secrets at pipeline run time without exposing them. The "isOutput=true" pattern allows passing across jobs without re-reading. B - never encrypt and commit. C is cleartext. D works for Azure DevOps-only secrets but loses Key Vault's central management.

**Answer:** A

**Key takeaway:** Pipeline secrets = Key Vault + Variable Group with Key Vault link. Don't put secrets in YAML. Don't commit encrypted blobs.

---

## Scenario 4 - IaC for multi-env (Domain: Infrastructure)

A team needs to deploy the same infra to dev / staging / prod with environment-specific config and approvals before prod.

Which fits?

A. Bicep templates with parameter files per environment; multi-stage YAML pipeline; Environments with approval gates on prod.
B. Manual ARM template deployments.
C. CloudFormation templates.
D. Terraform without remote state.

**Analysis**

A is right: Bicep is Microsoft's recommended IaC; parameter files per environment is the standard pattern; YAML pipeline stages map to environments; Environments resource with approvals is the gating mechanism. B doesn't scale and isn't auditable. C is AWS, not Azure. D works but Terraform without remote state is non-collaborative; you'd want backend in storage account at minimum.

**Answer:** A

**Key takeaway:** Azure IaC: Bicep (modern, recommended) > ARM JSON (old). Terraform also valid; the AZ-400 answer is usually Bicep. Use Environments + approvals for promotion gates.

---

## Scenario 5 - Deployment ring strategy (Domain: CI/CD)

A consumer app rolls out to internal users (canary), then 5%, then 25%, then 100% with auto-rollback on error rate.

Which fits?

A. Azure Pipelines with environment-based ring deployment; Azure App Service deployment slots with traffic splitting; Application Insights alerts feeding rollback automation via Azure Monitor → Logic App → revert pipeline.
B. Single deployment to all users.
C. Manual config of % per ring.
D. Static deployment scripts.

**Analysis**

A is right: rings are the Microsoft pattern for progressive rollout; deployment slots (in App Service) or traffic-manager weights are the mechanisms; App Insights drives the rollback signal. B doesn't ring. C is manual ops. D doesn't address the question.

**Answer:** A

**Key takeaway:** Azure progressive deployment: rings (multi-environment) + traffic splitting (slots / Front Door / Traffic Manager) + Application Insights alerts + automated rollback.

---

## Scenario 6 - Observability for production app (Domain: Monitoring)

A team needs aggregate dashboards across compute, app logs, infrastructure metrics, distributed traces, and alerts on SLO burn.

Which fits?

A. Azure Monitor: Application Insights for app telemetry + traces, Log Analytics workspace for centralized logs, Workbooks for dashboards, Alerts on log query / metric thresholds, integration with Azure Service Health.
B. Three separate tools.
C. Custom-built ELK on VMs.
D. Azure Monitor for infra metrics only; logs to S3.

**Analysis**

A is right: Azure Monitor is the unified observability platform; App Insights for app + distributed tracing; Log Analytics for logs (KQL queryable); Workbooks for dashboards; Action Groups for routing alerts. B fragments. C reinvents the wheel. D - no S3 in Azure (would be Blob Storage); also incomplete.

**Answer:** A

**Key takeaway:** Azure observability stack: Application Insights (app + traces) + Log Analytics (logs) + Azure Monitor metrics + Workbooks (dashboards) + Action Groups (alert routing).

---

## Scenario 7 - GitHub Advanced Security with Azure DevOps (Domain: Security)

A team using Azure Repos wants secret scanning, dependency vulnerability alerting, and code scanning (SAST) integrated into PRs.

Which fits?

A. GitHub Advanced Security for Azure DevOps (GHAS for ADO) - the ADO-native flavor of GHAS with secret scanning, Dependabot-style dependency review, and CodeQL.
B. Build a custom Linter in Pipelines.
C. Migrate to GitHub.
D. Run third-party SAST in pipelines and ignore secret scanning.

**Analysis**

A is right: GHAS for Azure DevOps is the Microsoft-supported solution that brings GitHub's security features to ADO. B reinvents. C is a heavy migration. D is partial.

**Answer:** A

**Key takeaway:** GitHub Advanced Security (GHAS) for Azure DevOps is the canonical answer for "secret + SAST + dependency scanning on ADO."

---

## Scenario 8 - Self-hosted agents for compliance (Domain: CI/CD)

A team must run pipelines on self-hosted agents inside their Azure VNet for compliance (no Microsoft-hosted agents).

Which fits?

A. Self-hosted agent pool on VM Scale Set with auto-scaling based on queue depth; agents in a private subnet with NSG; service connection via managed identity.
B. Microsoft-hosted agents only.
C. Single VM running an agent.
D. Containerized agents on AKS managed by an external service.

**Analysis**

A is right: self-hosted agents on VMSS with elastic scaling is the standard high-availability pattern. Managed identity replaces credentials. NSG controls network access. B is ruled out by compliance. C is single point of failure. D works but is more complex than VMSS for this requirement.

**Answer:** A

**Key takeaway:** Self-hosted agents at scale = VM Scale Set agent pool with auto-scaling. Managed identities for auth. AKS-hosted agents are also valid but more complex.
