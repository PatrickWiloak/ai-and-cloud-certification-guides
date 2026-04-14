# Terraform Authoring and Operations Professional - Real-World Scenarios

Each scenario models a real production situation similar to what you will encounter on the exam. Work through the "Question" first, then read the "Answer" to validate your thinking.

## Scenario 1: Refactor count to for_each Without Destroying

**Question:** A module has `resource "aws_iam_user" "users" { count = length(var.user_names) name = var.user_names[count.index] }`. Users are referenced by index in state (`aws_iam_user.users[0]`). A developer adds a new name at the start of the list. A plan wants to destroy and recreate every user because indices shifted. How do you refactor safely?

**Answer:** Convert to `for_each = toset(var.user_names)`. This keys resources by the string name rather than index, so adding or removing users only affects the delta. To preserve existing state, add `moved` blocks:

```hcl
moved {
  from = aws_iam_user.users[0]
  to   = aws_iam_user.users["alice"]
}
```

Repeat for each existing user. After apply, the `moved` blocks can remain in code or be removed in a follow-up commit.

## Scenario 2: Stuck State Lock

**Question:** A CI pipeline crashed mid-apply against an S3 backend with a DynamoDB lock. The next plan fails with `Error acquiring the state lock`. The lock ID is shown. The workspace has been stuck for 40 minutes. How do you recover?

**Answer:** First, verify no apply is actually still running. Check the CI job status, check CloudTrail for recent `dynamodb:UpdateItem` on the lock table, and check `aws_s3_object` last-modified times on the `tfstate` file. If the lock is genuinely orphaned, run `terraform force-unlock LOCK_ID`. Immediately follow with `terraform plan -refresh-only` to confirm state integrity. If the prior apply half-completed, reconcile drift before another apply.

## Scenario 3: Import a Manually Created VPC

**Question:** Your team accidentally created a production VPC via the AWS console. It must now be managed by Terraform with zero downtime. How do you bring it under management?

**Answer:** Use `import` blocks (Terraform 1.5+) for a declarative workflow.

```hcl
import {
  to = aws_vpc.prod
  id = "vpc-0abc123"
}

resource "aws_vpc" "prod" {
  # placeholder, will be filled
}
```

Then run `terraform plan -generate-config-out=generated.tf`. Review `generated.tf`, clean it up, and commit. Follow with `terraform plan` which should show no changes. Then `terraform apply` records the import into state.

## Scenario 4: Split Monolith into Dev and Prod

**Question:** A single workspace manages both dev and prod VPCs, RDS instances, and IAM roles. Leadership wants separate state files per environment for blast-radius isolation. You cannot take downtime. What is the migration plan?

**Answer:**

1. Create two new workspaces (`dev-infra`, `prod-infra`) with their own S3 backends or HCP workspaces.
2. `terraform state pull > monolith.tfstate` from the existing workspace.
3. For each dev resource, `terraform state mv -state=monolith.tfstate -state-out=dev.tfstate aws_vpc.dev_vpc aws_vpc.dev_vpc`. Repeat for prod.
4. `terraform state push dev.tfstate` into the new dev workspace. Same for prod.
5. Split the HCL source into `dev/` and `prod/` directories matching each workspace.
6. Run `terraform plan` in each new workspace. It must show zero changes. If not, stop and reconcile.
7. Once both show clean, empty the original workspace state and archive it.

## Scenario 5: Sentinel Policy Blocking Public S3

**Question:** Security requires that no `aws_s3_bucket` in production has `block_public_acls=false`. Write a Sentinel policy, test it, and explain the enforcement level you would choose.

**Answer:**

```python
import "tfplan/v2" as tfplan

s3_buckets = filter tfplan.resource_changes as _, rc {
  rc.type is "aws_s3_bucket_public_access_block" and
  rc.mode is "managed" and
  (rc.change.actions contains "create" or rc.change.actions contains "update")
}

main = rule {
  all s3_buckets as _, rc {
    rc.change.after.block_public_acls is true and
    rc.change.after.block_public_policy is true and
    rc.change.after.ignore_public_acls is true and
    rc.change.after.restrict_public_buckets is true
  }
}
```

Test with `sentinel test -run block-public-s3` using mocks generated from `terraform show -json`. Set enforcement to `hard-mandatory` in production policy sets. This prevents any override, including by org owners, except through a code fix.

## Scenario 6: OIDC Dynamic Credentials

**Question:** Your security team has banned long-lived AWS keys in HCP Terraform. Migrate an existing workspace to OIDC dynamic credentials without causing any failed runs during migration.

**Answer:**

1. Create an IAM OIDC provider in AWS for `app.terraform.io`.
2. Create an IAM role trusting that OIDC provider with a condition on `sub` matching your organization and workspace.
3. Set workspace variables: `TFC_AWS_PROVIDER_AUTH=true`, `TFC_AWS_RUN_ROLE_ARN=arn:aws:iam::...:role/tfc-role`.
4. Remove `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` workspace variables.
5. Run a speculative plan to validate.
6. If plan succeeds, you are migrated. If not, re-add the static vars, debug the trust policy, and retry.

The order matters: if you remove the static vars before the dynamic path works, you get failed runs. If you keep both, static wins and the migration is a no-op.

## Scenario 7: Drift Detection on Critical Workspace

**Question:** Your ops team wants to know within an hour if someone makes a console change to a production resource. How do you enable this with HCP Terraform and what are the caveats?

**Answer:** Enable **health assessments** on the workspace. HCP Terraform periodically runs `terraform plan -refresh-only` and reports drift to the UI and via notifications. Caveats: assessments count against your run concurrency and may incur cost on the paid tier; they do not auto-remediate, only report. For auto-remediation, pair with a scheduled run trigger that applies. For stronger enforcement, combine with AWS Config rules that alert on changes outside Terraform.

## Scenario 8: terraform test for a Module

**Question:** You maintain a public module and want CI to block PRs that break backward compatibility. How do you structure `terraform test` files?

**Answer:** Create `tests/` directory with three files:

- `tests/defaults.tftest.hcl`: `run "defaults" { command = plan; assert { condition = output.subnet_count == 2; error_message = "Default subnet count changed" } }`
- `tests/validation.tftest.hcl`: tests that invalid inputs trigger `validation` errors using `expect_failures`.
- `tests/integration.tftest.hcl`: `run "apply" { command = apply; ... }` with real provider (gated behind a CI secret for AWS creds).

Run via `terraform test` in CI. Unit tests (`command = plan`) are cheap and catch most regressions. Integration tests are slow but required for real provider behavior.

## Scenario 9: Run Triggers for Dependency Chains

**Question:** Workspace `network` manages the VPC. Workspace `apps` consumes the VPC ID via `terraform_remote_state`. When `network` changes CIDRs, `apps` must re-plan. How do you automate?

**Answer:** Configure a run trigger on `apps`: "Trigger runs when these source workspaces apply: [network]". Now, whenever `network` applies, `apps` automatically queues a plan. Pair this with `terraform_remote_state` data source in `apps` so the new VPC ID flows through. For tighter coupling, consider publishing `network` outputs as a module and consuming via the private registry instead of remote state.

## Scenario 10: Debugging a Provider Lock Conflict

**Question:** A teammate committed a `.terraform.lock.hcl` after upgrading the AWS provider. Your local CI runs on Linux AMD64 but produces a hash mismatch error. What is happening and how do you fix?

**Answer:** The lock file pins hashes for specific platforms. Your teammate likely locked on macOS ARM64 only. The fix: `terraform providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=darwin_amd64`. Commit the updated lock. This adds hashes for all platforms your team runs on. Alternatively, run `terraform init -upgrade` in CI to refresh. Long-term fix: add a pre-commit hook that runs `terraform providers lock` with all supported platforms.

## Scenario 11: Private Module Registry Versioning

**Question:** You publish a VPC module at v1.0.0. You add a breaking change. How do you release so consumers are not surprised?

**Answer:** Follow semver. A breaking change bumps major: v2.0.0. Tag the release in VCS (`git tag v2.0.0 && git push --tags`). The registry picks up the tag. Consumers pinning `version = "~> 1.0"` will not upgrade; those pinning `version = ">= 1.0"` will get the break on next init. Document the migration in a CHANGELOG.md. Optionally keep a `v1` maintenance branch for bug fixes without forcing upgrade.

## Scenario 12: Policy Set Scoping

**Question:** Your org has 3 projects: `security`, `platform`, `apps`. Security policies should apply to all projects. Cost policies only to `apps`. How do you configure Sentinel policy sets?

**Answer:** Create two policy sets: `global-security` attached at organization scope (applies to all workspaces in all projects), and `apps-cost` attached to the `apps` project only. HCP Terraform evaluates all applicable policy sets on each run. Workspaces in `apps` get both policies; workspaces in `platform` and `security` get only the global security set. Scope at the project level when possible to avoid per-workspace attachments, which are harder to maintain at scale.
