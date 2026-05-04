# HashiCorp Terraform Associate (003) - Practice Questions

15 scenario-based questions for Terraform Associate prep.

> **Cert page:** [exams/hashicorp/terraform-associate/](../../exams/hashicorp/terraform-associate/)

---

### Question 1
**Scenario:** A new team member runs `terraform plan` and sees changes they didn't make. The state file is in S3. What's most likely?

A. Someone made manual changes to resources outside Terraform
B. The state file is stale
C. Terraform is buggy
D. Drift detection is permanent

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** This is **drift** - the actual infrastructure state differs from what Terraform recorded. Manual console changes, other tools modifying resources, or state file corruption can cause this. `terraform refresh` (or `plan -refresh-only`) syncs state with reality. Avoid manual changes to TF-managed resources.
</details>

---

### Question 2
**Scenario:** You want to share Terraform state across a team and prevent simultaneous applies. What backend feature do you need?

A. Local state with git
B. Remote state with state locking (S3 + DynamoDB, or Terraform Cloud)
C. Terraform Cloud only
D. Encrypted local state

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Remote state (S3, Azure Storage, GCS, Terraform Cloud, Consul) supports state locking. S3 backend uses a DynamoDB table for locks. Without locking, two simultaneous `apply` operations corrupt state. Local state with git races on commit; not safe.
</details>

---

### Question 3
**Scenario:** What's the difference between `terraform import` and `terraform apply`?

A. `import` brings existing infrastructure into Terraform state without modifying it; `apply` modifies infrastructure to match config
B. They're equivalent
C. `import` is destructive
D. `apply` is read-only

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `import` adds an existing resource (created outside Terraform) to the state file. You still need to write matching config; `import` doesn't generate config. After import, run `plan` to verify config matches reality.
</details>

---

### Question 4
**Scenario:** A module input variable should be required but no default value should be set. What's the right declaration?

A. Set `default = null` and check at runtime
B. Just declare the variable without a `default` - Terraform will require it
C. Use `validation` block
D. Use `sensitive = true`

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** A variable without `default` is required. If users don't pass it, Terraform errors out at plan time. `null` default makes it optional with null fallback.
</details>

---

### Question 5
**Scenario:** Sensitive output (e.g., a generated password) should be stored in state but not displayed in plan/apply output. How?

A. `sensitive = true` on the output declaration
B. Encrypt the entire state file
C. Don't put sensitive data in state
D. Use a separate state file

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `sensitive = true` on output (or variable) hides it from CLI output. The value is still in state - that's why state files should be in encrypted-at-rest backends. Use Vault for true secret management.
</details>

---

### Question 6
**Scenario:** A `count = 3` resource is replaced with `for_each` over 3 named items. After this change, what happens?

A. Terraform recognizes them as the same resources
B. Terraform plans to destroy 3 and create 3 (the addressing changes from `[0]/[1]/[2]` to `["a"]/["b"]/["c"]`)
C. Terraform errors out
D. Terraform converts automatically

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Resource addresses change between `count` and `for_each`. Terraform sees this as destroy+create unless you use `terraform state mv` to remap. For long-lived resources, prefer `for_each` from the start to avoid this churn.
</details>

---

### Question 7
**Scenario:** Provider versions should be pinned for reproducibility. Where?

A. In `terraform { required_providers { ... version = "~> 4.0" } }`
B. In environment variables
C. In the state file
D. In the backend configuration

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Pin in `required_providers`. `~> 4.0` allows `>= 4.0, < 5.0`. Use `terraform init` to install. The `.terraform.lock.hcl` file (committed to git) records exact versions for reproducibility.
</details>

---

### Question 8
**Scenario:** Workspaces in OSS Terraform vs Terraform Cloud - what's a key difference?

A. OSS workspaces are state-file-level (one state per workspace, same backend); Cloud workspaces are full execution environments with their own variables and config
B. They're identical
C. OSS workspaces require Cloud
D. Cloud workspaces don't have state

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** OSS `terraform workspace` creates separate state files in the same backend - same code, different state. Cloud workspaces are first-class objects with their own variables, run history, RBAC, and execution.
</details>

---

### Question 9
**Scenario:** What does `terraform fmt` do?

A. Formats `.tf` files to canonical style (whitespace, alignment, ordering)
B. Validates syntax
C. Tests the configuration
D. Generates documentation

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `fmt` is a formatter (analogous to `gofmt`). It rewrites files to canonical style. `validate` checks syntax. `terraform-docs` (third-party) generates docs.
</details>

---

### Question 10
**Scenario:** A module is published to the Terraform Registry as `myorg/network/aws`. How do you reference it in a config?

A. `source = "myorg/network/aws"`
B. `source = "registry.terraform.io/myorg/network/aws"`
C. `module "net" { source = "myorg/network/aws" version = "1.2.3" }`
D. Both A and C work; B is the explicit form

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Public registry modules use `<namespace>/<name>/<provider>` and Terraform implicitly resolves to registry.terraform.io. Versions are highly recommended. Explicit registry URL works too.
</details>

---

### Question 11
**Scenario:** When does Terraform create an implicit dependency between resources?

A. Never; you must use `depends_on`
B. When one resource references another's attribute (e.g., `aws_subnet.id` referenced by `aws_instance`)
C. Only within the same module
D. Only when explicitly declared

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Attribute references create implicit dependencies in the dependency graph. `depends_on` is for cases where there's no attribute reference but ordering still matters (e.g., IAM policy must exist before EC2 launches).
</details>

---

### Question 12
**Scenario:** Backend `partial configuration` with `terraform init -backend-config=...` is useful for what?

A. Switching backends without code changes
B. Keeping backend secrets out of source control
C. Per-environment configuration
D. All of the above

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Partial config lets you specify backend at init time via `-backend-config="bucket=mybucket"` or a `.hcl` file. Common for: keeping bucket names per-env, keeping access keys out of git, switching prod/staging buckets.
</details>

---

### Question 13
**Scenario:** What does `terraform taint` do (still supported but deprecated)?

A. Marks a resource for replacement on next apply
B. Permanently breaks the resource
C. Removes from state
D. Locks the resource

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `taint` marks a resource for destroy+create on next apply. Modern equivalent: `terraform apply -replace=<resource>` (preferred since 0.15.2). Useful when you've changed an external dependency that Terraform doesn't track.
</details>

---

### Question 14
**Scenario:** A child module needs to expose a value to its caller. How?

A. Output blocks in the module
B. Variables
C. Resource attributes
D. Provider config

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Module outputs are the explicit interface for what callers can consume. Caller accesses with `module.<name>.<output_name>`. Variables flow IN; outputs flow OUT.
</details>

---

### Question 15
**Scenario:** What's the order of operations for `terraform apply`?

A. Plan, then apply changes, then update state
B. Read config, refresh state, plan, prompt for approval, apply, update state
C. Validate, plan, apply, format
D. Apply changes, then plan

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** `apply` reads config + current state, refreshes state from real infra (unless `-refresh=false`), generates plan, prompts unless `-auto-approve`, applies in dependency order, then writes new state.
</details>

---

### Question 16
**Scenario:** Your team uses S3 + DynamoDB as the Terraform backend. What does the DynamoDB table provide?

A. State storage
B. State locking (preventing concurrent applies)
C. Audit history
D. Encryption keys

<details><summary>Answer</summary>

**Correct: B**

**Why:** S3 stores the state file; DynamoDB stores a lock entry while an `apply` is running. The lock prevents two engineers from running `apply` simultaneously and corrupting state.
</details>

---

### Question 17
**Scenario:** You need to import an existing AWS resource (e.g., a manually-created S3 bucket) into Terraform management.

A. `terraform import aws_s3_bucket.mybucket bucket-name`
B. Manually edit the state file
C. `terraform refresh`
D. Recreate the bucket via Terraform

<details><summary>Answer</summary>

**Correct: A**

**Why:** `terraform import` brings existing resources under management, mapping a real-world resource ID to a TF resource address. You also need the `resource "aws_s3_bucket" "mybucket" {}` block in your config (Terraform 1.5+ supports `import` blocks too).
</details>

---

### Question 18
**Scenario:** Best way to share infrastructure modules across teams:

A. Copy/paste HCL between repos
B. Publish to the public Terraform Registry, a private registry (Terraform Cloud / Enterprise), or a versioned git tag
C. Hardcode in each repo
D. Use raw Bash scripts

<details><summary>Answer</summary>

**Correct: B**

**Why:** Modules are TF's reuse unit. Source from public registry, private registry, git (`git::https://...?ref=v1.2.0`), or local paths. Versioning is critical so consumers don't break on upstream changes.
</details>

---

### Question 19
**Scenario:** What's `count` vs `for_each` for module / resource iteration?

A. `count` uses an integer (creates N indexed copies); `for_each` uses a map or set of strings (creates one per key)
B. They're identical
C. `count` is for modules only
D. `for_each` is deprecated

<details><summary>Answer</summary>

**Correct: A**

**Why:** Use `for_each` when you have a logical key (e.g., per-tenant config); resources are addressed by key. Use `count` when truly indexed (e.g., 3 identical replicas). `count` is fragile to reordering; `for_each` is more robust.
</details>

---

### Question 20
**Scenario:** Sensitive output value (e.g., DB password) needs to be passed to a downstream module.

A. Mark output as `sensitive = true`; pass to downstream module input variable also marked sensitive
B. Print to console
C. Commit to git
D. Email it

<details><summary>Answer</summary>

**Correct: A**

**Why:** `sensitive = true` masks the value in CLI output and `terraform plan`. Still stored in state (encrypt the backend), but not displayed. The full path: source secret in a manager (Vault, Secrets Manager) and use a data source instead of putting the value through TF at all.
</details>

---

### Question 21
**Scenario:** Workspaces in Terraform - what are they for?

A. Separate state files for the same config (e.g., dev / staging / prod)
B. Visual editing
C. Module isolation
D. Provider versioning

<details><summary>Answer</summary>

**Correct: A**

**Why:** Workspaces give you multiple state files for the same config. Use case: same module deployed to dev/staging/prod with different vars. Modern best practice prefers separate directories or backend configs over workspaces for production environment isolation.
</details>

---

### Question 22
**Scenario:** A Terraform provider defines:

A. Cloud-specific resource and data source types
B. Backend storage
C. Module syntax
D. State encryption

<details><summary>Answer</summary>

**Correct: A**

**Why:** Providers (`aws`, `azurerm`, `google`, `kubernetes`, `random`, etc.) implement resources and data sources for a target API. Terraform Core handles graph + state; providers handle CRUD against APIs.
</details>

---

### Question 23
**Scenario:** What does `terraform validate` do?

A. Checks syntax + internal consistency without contacting providers
B. Applies the plan
C. Refreshes state
D. Tests in production

<details><summary>Answer</summary>

**Correct: A**

**Why:** `validate` checks HCL syntax and references inside the config. Doesn't talk to provider APIs (so it's fast and offline). Used in CI before `plan`.
</details>

---

### Question 24
**Scenario:** Best way to handle provider version constraints:

A. Pin in `required_providers` in a `terraform { ... }` block; commit `.terraform.lock.hcl`
B. Don't pin; use latest
C. Pin globally in environment
D. Edit ~/.terraform.d/

<details><summary>Answer</summary>

**Correct: A**

**Why:** Pin major and minor (e.g., `~> 5.0` for AWS provider 5.x). The lock file (`.terraform.lock.hcl`) records exact versions across providers and platforms; commit it for reproducibility.
</details>

---

### Question 25
**Scenario:** Drift - someone changed a resource in the cloud console.

A. Run `terraform plan` to see drift; either accept the change into config or `terraform apply` to revert
B. Ignore
C. Delete state
D. Recreate everything

<details><summary>Answer</summary>

**Correct: A**

**Why:** `plan` shows the difference between config and reality. You then decide: update config to match reality (accept the change) or `apply` to overwrite reality with config (revert). Drift detection should be regular (CI cron, Terraform Cloud).
</details>

---

## Scoring guide

- **22-25:** Ready. Combine with HashiCorp's official prep + a Udemy course for confidence.
- **17-21:** Solid; review weak areas.
- **<17:** Hands-on practice + re-read fact-sheet.

Terraform Associate is multiple-choice, 60 minutes, ~57 questions. These reinforce concepts; for full coverage see HashiCorp Learn and the [exams/hashicorp/terraform-associate/](../../exams/hashicorp/terraform-associate/) materials.
