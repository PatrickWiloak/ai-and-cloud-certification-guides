---
last-updated: 2026-05-03
---

# Decision matrix - Infrastructure-as-code tool

You're picking an IaC tool for a new project (or replacing one that hurts). This page scores the main contenders against criteria that drive the choice.

## Criteria

| # | Criterion | Why it matters |
|---|---|---|
| 1 | Multi-cloud support | Are you single-cloud or genuinely multi-cloud? |
| 2 | Language model | HCL DSL vs real programming language vs JSON / YAML |
| 3 | State management | Where does state live; lock model |
| 4 | Module ecosystem | Reusable components without writing your own |
| 5 | Provider/resource coverage | Does it cover the services you actually use |
| 6 | Drift detection | Built-in or bolt-on |
| 7 | Vendor lock | Easy to migrate out if your needs change |
| 8 | Learning curve | Time to first useful infra change |

## Scoring

Scale: 1 (poor) → 5 (excellent).

| Tool | Multi-cloud | Language | State | Modules | Coverage | Drift | Lock-in | Learning curve | Total |
|---|---|---|---|---|---|---|---|---|---|
| **Terraform** | 5 | 3 (HCL DSL) | 4 (S3+DynamoDB / GCS / Azure Blob backends) | 5 (huge registry) | 5 | 4 (terraform plan) | 3 (HCL is portable; HashiCorp BSL since 2023) | 3 (HCL takes some learning) | 32 |
| **OpenTofu** | 5 | 3 (HCL, fork) | 4 | 4 (mostly TF-compatible) | 4 (slightly behind TF) | 4 | 5 (Apache 2.0 OSS) | 3 | 32 |
| **Pulumi** | 5 | 5 (TS / Python / Go / .NET / YAML) | 4 (Pulumi Cloud or self-host) | 4 | 4 | 4 | 4 | 4 (real lang familiar) | 34 |
| **AWS CloudFormation** | 1 (AWS-only) | 2 (JSON / YAML) | 5 (managed by AWS) | 4 (CFN modules + StackSets) | 5 (AWS) | 4 (drift detection native) | 1 (AWS-only) | 3 | 25 |
| **AWS CDK** | 1 (AWS-only) | 5 (TS / Python / Java / .NET / Go) | 5 (synthesizes to CFN) | 4 (constructs library) | 5 (AWS) | 4 (via CFN) | 1 | 4 (real lang) | 29 |
| **Bicep** (Azure) | 1 (Azure-only) | 4 (Bicep DSL, much cleaner than ARM) | 5 (managed by Azure) | 4 (modules + Template Specs) | 5 (Azure) | 4 (what-if) | 1 (Azure-only) | 4 | 28 |
| **GCP Deployment Manager** | 1 (GCP-only) | 2 (YAML / Jinja / Python templates) | 4 | 2 | 3 | 3 | 1 | 3 | 19 |
| **Crossplane** | 5 (K8s-native, providers for AWS/Azure/GCP/etc) | 4 (K8s YAML / Composition / KCL) | 5 (etcd-backed via K8s API) | 4 (Compositions) | 4 | 5 (K8s reconciler) | 3 | 2 (K8s + new mental model) | 32 |

## Recommendations by scenario

- **Single cloud, AWS, ops-team builds and operates infra** → **CloudFormation** is the conservative pick (zero new tooling); **CDK** if your team prefers code over YAML.
- **Single cloud, Azure** → **Bicep**. Modern Azure-native, much better than ARM JSON.
- **Multi-cloud or planning multi-cloud** → **Terraform** or **OpenTofu**. Terraform if you accept HashiCorp BSL; OpenTofu if you need fully open-source / Linux Foundation governance.
- **Software engineering team that resents HCL** → **Pulumi**. Real programming languages, real tests, real abstractions. Pays off at scale.
- **Already running Kubernetes-everywhere and want infra to look like other K8s objects** → **Crossplane**. The "GitOps for cloud infra" answer.
- **Migrating from CloudFormation/ARM** → start with **OpenTofu** or **Terraform**, import existing resources via `terraform import`.

## Anti-patterns

- Picking the "cool" tool over the boring one your team already knows. IaC's value is consistency; tool churn destroys that.
- Storing Terraform state on a developer laptop or in git. State must live in a backend with locking (S3+DynamoDB, GCS, Azure Blob, Pulumi Cloud, Terraform Cloud).
- Putting secrets in the tfvars / parameters file committed to git. Use a secret manager + IAM, not the IaC parameter file.
- Massive monoliths - one apply taking 10 minutes is a sign to split into smaller stacks.
- Manual changes to managed resources (drift). Run `plan` regularly to detect.

## What about Ansible / Chef / Puppet / Salt?

Configuration management, not infrastructure provisioning. Use them to configure what's inside a VM (packages, files, services); use IaC to provision the VM itself. Some teams use Ansible for both, but it's not its sweet spot.

## Related

- [Terraform explained](../learn/concepts/terraform-explained.md)
- [CLI cheat sheet: Terraform](./cli-cheat-sheet-terraform.md)
- [HashiCorp certifications](../exams/hashicorp/) - Terraform Associate is the gateway cert
- [Build infra with Terraform](./hands-on-projects/terraform-infrastructure.md) - hands-on
