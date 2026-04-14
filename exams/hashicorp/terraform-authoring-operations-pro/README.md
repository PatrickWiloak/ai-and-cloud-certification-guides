# HashiCorp Terraform Authoring and Operations Professional Certification

## Exam Overview

The HashiCorp Terraform Authoring and Operations Professional certification (current exam, which replaces the older Terraform Associate Professional exam) validates advanced, hands-on Terraform expertise across the full lifecycle of writing, reviewing, debugging, and operating production-grade Terraform code. It targets senior cloud engineers, platform engineers, SREs, and infrastructure architects who are responsible for designing module systems, managing large state ecosystems, and operating Terraform at scale through HCP Terraform (formerly Terraform Cloud) or Terraform Enterprise.

Unlike the Terraform Associate exam, which emphasizes conceptual understanding and basic workflow, the Professional exam is a **performance-based, hands-on lab exam**. Candidates are given access to a live Terraform environment and must complete real authoring and operations tasks, including writing HCL, debugging broken configurations, remediating state issues, configuring workspaces, and authoring policy-as-code.

**Exam Code:** Terraform Authoring and Operations Professional
**Exam Duration:** 4 hours
**Exam Format:** Hands-on performance-based labs (live Terraform CLI and HCP Terraform environment)
**Passing Score:** Variable threshold determined by HashiCorp (pass/fail reporting)
**Cost:** $295 USD
**Proctoring:** PSI online proctored
**Validity:** 2 years
**Prerequisites:** Terraform Associate (003) certification recommended; at least 12 months hands-on production Terraform experience strongly advised

## Who Should Take This Exam

- Senior infrastructure engineers authoring reusable Terraform modules consumed across an organization
- Platform engineers building internal developer platforms on top of HCP Terraform or Terraform Enterprise
- SREs and DevOps leads operating Terraform pipelines, policy frameworks, and drift remediation workflows
- Consultants implementing Terraform adoption, migration, or governance patterns for clients
- Architects defining state layout, workspace structure, and module boundaries for complex organizations

## Prerequisites and Recommended Experience

- Strong working knowledge of HCL2 including dynamic blocks, for expressions, type constraints, and complex variable validation
- Experience authoring and publishing modules to a private registry (HCP or Terraform Enterprise)
- Experience with remote state backends (S3, GCS, Azure Blob, HCP) including state locking and migration
- Familiarity with Sentinel or OPA policy-as-code
- Practical experience with VCS-driven, CLI-driven, and API-driven workflows in HCP Terraform
- Comfort with Terraform CLI subcommands beyond plan and apply (state, import, taint/replace, console, graph, refresh, force-unlock)

## Exam Domains (high-level breakdown)

1. Author and maintain Terraform modules (approximately 25%)
2. Understand and manage Terraform state (approximately 20%)
3. Use the Terraform CLI for operations and debugging (approximately 15%)
4. Operate HCP Terraform and Terraform Enterprise (approximately 15%)
5. Implement policy as code with Sentinel and OPA (approximately 10%)
6. Automate Terraform with VCS integrations, run tasks, and CI/CD (approximately 15%)

See `fact-sheet.md` for the detailed topic list per domain.

## Study Path

1. Start with the `fact-sheet.md` to understand exam format and weights.
2. Work through the six note files under `notes/` in order. Each covers one major domain and includes command examples, HCL snippets, and common pitfalls.
3. Complete the labs in `practice-plan.md` over a 6 to 8 week schedule.
4. Run through `scenarios.md` to test real-world decision making.
5. Use `strategy.md` the week before the exam to finalize tactics.

## Hands-on Lab Requirements

Because this is a performance-based exam, passive reading is not enough. You must practice:

- Writing modules from scratch against AWS, Azure, or GCP providers
- Remediating broken configurations (syntax, logic, provider version conflicts)
- Using `terraform state mv`, `terraform state rm`, and `terraform import` to reconcile drift
- Configuring HCP Terraform workspaces in CLI-driven, VCS-driven, and API-driven modes
- Authoring Sentinel policies and attaching policy sets to workspaces

Recommended lab environment: a free HCP Terraform account, an AWS/Azure/GCP sandbox, and a local Terraform CLI (at least version 1.6 or newer to cover `terraform test`).

## Official Resources

- Exam page: https://developer.hashicorp.com/certifications/infrastructure-automation
- Exam review guide: https://developer.hashicorp.com/terraform/tutorials/certification-associate-tutorials-003 (associate) and the Professional review page on developer.hashicorp.com
- HCP Terraform documentation: https://developer.hashicorp.com/terraform/cloud-docs
- Terraform CLI documentation: https://developer.hashicorp.com/terraform/cli
- Sentinel documentation: https://developer.hashicorp.com/sentinel/docs
- Terraform language reference: https://developer.hashicorp.com/terraform/language
- HashiCorp Learn Terraform tutorials: https://developer.hashicorp.com/terraform/tutorials

## Recommended Supplementary Resources

- "Terraform: Up and Running" (3rd edition) by Yevgeniy Brikman for module and state patterns
- HashiCorp Well-Architected Framework for Terraform
- Public module examples on registry.terraform.io for reading real-world HCL
- `terraform-aws-modules/*` GitHub repositories for production module patterns

## Recertification

The certification is valid for 2 years. Recertification requires passing the current version of the exam. Because the Professional exam is hands-on, continued production work with Terraform is the most efficient preparation for recertification.

## Common Pitfalls to Avoid

- Treating it like the Associate exam. It is not multiple choice, so memorization alone will not suffice.
- Neglecting HCP Terraform features. Workspaces, run triggers, and policy sets are heavily tested.
- Skipping Sentinel. Even if your organization uses OPA, HashiCorp tests Sentinel authoring.
- Ignoring `terraform test`. Module testing is part of the authoring domain on current exam blueprints.
- Poor CLI muscle memory. The lab environment does not forgive slow typing or frequent doc lookups.

## Time Investment Estimate

- If you already have 12+ months production Terraform experience: 40 to 60 hours of focused prep
- If you have 6 to 12 months experience: 80 to 120 hours including heavy lab time
- If you only have Associate-level knowledge: consider deferring until you have more production reps

See `practice-plan.md` for a concrete week-by-week schedule.
