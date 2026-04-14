# Terraform Authoring and Operations Professional - Fact Sheet

## Exam Logistics

| Attribute | Value |
|-----------|-------|
| Exam name | HashiCorp Certified: Terraform Authoring and Operations Professional |
| Delivery | Performance-based hands-on labs in a live Terraform environment |
| Duration | 4 hours |
| Number of tasks | Approximately 15 to 25 lab tasks across multiple scenarios |
| Passing score | HashiCorp does not publish a numeric cut score; result reported as pass or fail |
| Cost | $295 USD |
| Proctoring | PSI online proctoring, webcam and screen share required |
| Language | English |
| Validity | 2 years |
| Retake policy | 14-day wait after first attempt, 30-day wait after second, 1-year wait after third |
| Recommended experience | 12+ months hands-on production Terraform, Associate-level knowledge assumed |

## Exam Domains and Weights

The current exam blueprint (subject to revision by HashiCorp) covers six major domains. Weights below are realistic estimates based on HashiCorp's published objectives.

### Domain 1: Author and maintain Terraform modules (approximately 25%)

- Design module interfaces (inputs, outputs, type constraints, validation blocks)
- Use `optional()` and nullable attributes in complex types
- Apply `for_each`, `count`, and `dynamic` blocks correctly
- Use `moved` blocks to refactor resources without destroy/create
- Use `removed` blocks (Terraform 1.7+) to drop resources from state without destroy
- Use `import` blocks for declarative imports (Terraform 1.5+)
- Author `terraform test` files (`.tftest.hcl`) with `run` blocks and mocked providers
- Publish modules to a private registry (HCP Terraform or Terraform Enterprise)
- Version modules using semantic versioning and pin module sources
- Document modules with README, examples/, and input/output descriptions

### Domain 2: Understand and manage Terraform state (approximately 20%)

- Choose an appropriate remote backend (S3+DynamoDB, GCS, Azure Blob, HCP, Consul)
- Configure state locking and understand lock conflicts
- Perform `terraform state list`, `show`, `mv`, `rm`, `replace-provider`, `pull`, `push`
- Handle state migration between backends (`terraform init -migrate-state`)
- Recover from corrupt or lost state
- Use `-refresh-only` plans to reconcile drift safely
- Split monolithic state using `terraform state mv` or `moved` blocks
- Use `terraform_remote_state` data source vs published outputs
- Secure state files (encryption at rest, access control, secret handling)

### Domain 3: Use the Terraform CLI for operations and debugging (approximately 15%)

- Use `TF_LOG`, `TF_LOG_PATH`, and `TF_LOG_PROVIDER` for debugging
- Use `terraform console` to evaluate expressions
- Use `terraform graph` and `terraform providers` for dependency analysis
- Use `terraform plan -out` and `terraform apply plan.tfplan` for approval flows
- Use `-target`, `-replace`, and `-refresh=false` judiciously
- Use `terraform force-unlock` safely
- Interpret error messages from providers and core
- Use `terraform validate`, `fmt`, and pre-commit hooks
- Debug provider plugin issues, lock file conflicts, and version constraints

### Domain 4: Operate HCP Terraform and Terraform Enterprise (approximately 15%)

- Configure CLI-driven, VCS-driven, and API-driven workspaces
- Manage variable sets (workspace, project, organization scope)
- Configure run triggers and workspace notifications
- Use agents for private networks
- Configure SSO, teams, and team access permissions
- Use projects to group workspaces
- Understand no-code provisioning and the public module registry
- Use dynamic provider credentials (OIDC) for AWS, Azure, GCP, Vault
- Configure run tasks for third-party integrations (Snyk, Checkov, Bridgecrew, etc.)

### Domain 5: Implement policy as code with Sentinel and OPA (approximately 10%)

- Author Sentinel policies using `tfplan/v2`, `tfconfig/v2`, `tfstate/v2`, `tfrun` imports
- Use enforcement levels (advisory, soft-mandatory, hard-mandatory)
- Package policies into policy sets and attach to workspaces or projects
- Author OPA Rego policies for Terraform plans
- Test Sentinel policies with `sentinel test`
- Understand cost estimation policies and how they integrate with runs

### Domain 6: Automate Terraform with VCS, run tasks, and CI/CD (approximately 15%)

- Configure VCS integration (GitHub, GitLab, Bitbucket, Azure DevOps)
- Use speculative plans on pull requests
- Use `working_directory` and trigger patterns to scope workspace runs
- Integrate Terraform with GitHub Actions or GitLab CI using `hashicorp/setup-terraform`
- Use API-driven workflows with `tfe` provider for self-service workspace provisioning
- Implement drift detection using HCP Terraform health assessments or scheduled runs
- Use run tasks to integrate security scanners into the run lifecycle

## Key CLI Commands to Master

```
terraform init [-backend-config=...] [-migrate-state] [-reconfigure] [-upgrade]
terraform plan -out=tfplan [-target=...] [-replace=...] [-refresh-only] [-var-file=...]
terraform apply tfplan
terraform state list | show | mv | rm | pull | push | replace-provider
terraform import ADDRESS ID
terraform force-unlock LOCK_ID
terraform workspace list | new | select | delete
terraform console
terraform graph | terraform providers | terraform providers lock
terraform test
terraform fmt -recursive
terraform validate
terraform login | logout
```

## Key HCL Features to Master

- `optional()` and `nullable` in object type constraints
- `validation` blocks with `condition`, `error_message`
- `precondition` and `postcondition` blocks in resources and data sources
- `check` blocks (Terraform 1.5+) for continuous validation
- `moved` blocks for refactoring
- `removed` blocks for dropping resources without destroy (Terraform 1.7+)
- `import` blocks for declarative imports
- Ephemeral resources and write-only attributes (Terraform 1.10+)
- `for_each` with sets and maps, `count` with conditional creation
- `dynamic` blocks with nested iteration
- `terraform_data` resource (replaces `null_resource` in modern configs)

## Sentinel Policy Example

```python
import "tfplan/v2" as tfplan

allowed_regions = ["us-east-1", "us-west-2"]

main = rule {
  all tfplan.resource_changes as _, rc {
    rc.type is not "aws_instance" or
    rc.change.after.availability_zone[:len(rc.change.after.availability_zone)-1] in allowed_regions
  }
}
```

## HCP Terraform Workspace Execution Modes

| Mode | Description | When to use |
|------|-------------|-------------|
| Remote | Plans and applies run in HCP Terraform | Default, full UI history |
| Local | State stored remotely, execution local | Legacy pipelines, agent-unfriendly networks |
| Agent | Runs execute on self-hosted agent | Private networks, custom tooling |

## Policy Enforcement Levels

| Level | Behavior |
|-------|----------|
| advisory | Logs failure, run proceeds |
| soft-mandatory | Run blocked, organization owner can override |
| hard-mandatory | Run blocked, no override possible (except via code fix) |

## Dynamic Provider Credentials Flow (AWS example)

1. HCP Terraform issues an OIDC token per run.
2. Workspace sends token to AWS STS via `AssumeRoleWithWebIdentity`.
3. AWS returns short-lived credentials.
4. Terraform AWS provider uses those credentials for the run.
5. Credentials expire at run end. No static keys stored.

Required workspace variables: `TFC_AWS_PROVIDER_AUTH=true`, `TFC_AWS_RUN_ROLE_ARN=arn:aws:iam::...`.

## Common Exam Task Types (performance-based)

- "Refactor this module to use `for_each` instead of `count`, preserve state."
- "This `terraform apply` is failing with a lock error. Resolve without data loss."
- "Split a monolithic workspace into dev and prod using workspace naming and state mv."
- "Author a Sentinel policy that blocks public S3 buckets."
- "Configure a VCS-driven workspace with speculative plans on PRs."
- "Import an existing EC2 instance into a new Terraform module."
- "Write a `terraform test` file that validates module behavior."

## Scoring Philosophy

Tasks are scored by the end state of the lab environment, not by the exact commands you ran. If your final state file, module outputs, and workspace configuration match the rubric, you earn the points even if your approach differed from the expected one.

## Version Scope

As of the 2025 exam refresh, the exam covers Terraform CLI versions 1.5 through 1.10. Expect questions and tasks involving `import` blocks, `check` blocks, `moved` and `removed` blocks, `terraform test`, and (for newer revisions) ephemeral resources.

## Red Flags That Indicate You Are Not Ready

- You have never published a module to a registry.
- You have never migrated state between backends.
- You have never written a Sentinel or OPA policy.
- You cannot explain when to use `-target` and why it is usually wrong.
- You have never debugged a broken provider lock file.

If any of the above apply, spend more lab time before scheduling.
