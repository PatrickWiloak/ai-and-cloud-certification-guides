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

## Scoring guide

- **13-15:** Ready. Combine with HashiCorp's official prep + a Udemy course for confidence.
- **10-12:** Solid; review weak areas.
- **<10:** Hands-on practice + re-read fact-sheet.

Terraform Associate is multiple-choice, 60 minutes, ~57 questions. These reinforce concepts; for full coverage see HashiCorp Learn and the [exams/hashicorp/terraform-associate/](../../exams/hashicorp/terraform-associate/) materials.
