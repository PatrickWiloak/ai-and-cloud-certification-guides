# Policy as Code: Sentinel and OPA

Policy as code enforces governance rules on every Terraform run. About 10% of the exam tests your ability to author, test, and attach policies.

## Sentinel Overview

Sentinel is HashiCorp's policy-as-code language. It runs inside HCP Terraform (Plus tier) and Terraform Enterprise (all tiers). Policies evaluate against the run's plan, config, state, and metadata.

### Key Imports

- `tfplan/v2`: everything that would happen on apply (resource_changes, variables, planned_values)
- `tfconfig/v2`: the parsed configuration (module_calls, resources, providers)
- `tfstate/v2`: the current state (what exists now)
- `tfrun`: run metadata (cost estimate, workspace name, organization)

### Policy Structure

```python
import "tfplan/v2" as tfplan

# Get all aws_instance resource changes that create or update
instances = filter tfplan.resource_changes as _, rc {
  rc.type is "aws_instance" and
  rc.mode is "managed" and
  (rc.change.actions contains "create" or rc.change.actions contains "update")
}

# Approved instance types
allowed_types = ["t3.micro", "t3.small", "t3.medium"]

# Main rule
main = rule {
  all instances as _, rc {
    rc.change.after.instance_type in allowed_types
  }
}
```

Every policy must define a `main` rule. The rule evaluates to `true` (pass) or `false` (fail).

### Advisory, Soft-Mandatory, Hard-Mandatory

Enforcement levels are set at policy or policy-set level:

- **Advisory:** failure is logged; run proceeds
- **Soft-Mandatory:** failure blocks run; organization owner can override
- **Hard-Mandatory:** failure blocks run; no override except code fix

Use hard-mandatory for security (public S3, unencrypted volumes), soft-mandatory for best-practice (tagging, cost), advisory for new policies during rollout.

### Policy Sets

Group related policies and attach to workspaces or projects.

```hcl
resource "tfe_policy_set" "security" {
  name          = "global-security"
  organization  = "my-org"
  policies_path = "policies/security"
  global        = true     # applies to all workspaces
  vcs_repo {
    identifier     = "my-org/sentinel-policies"
    branch         = "main"
    oauth_token_id = var.oauth_token
  }
}
```

Attach at organization scope (`global = true`), project scope, or specific workspaces.

### Testing Sentinel Policies

Directory layout:

```
policies/
  restrict-instance-type/
    sentinel.hcl
    restrict-instance-type.sentinel
    test/
      restrict-instance-type/
        pass.json      # input data that should pass
        fail.json      # input data that should fail
```

Run with `sentinel test`. Mock data can be generated from real plans:

```
terraform show -json tfplan > plan.json
# Manually structure into Sentinel test fixture
```

Or use the HCP Terraform UI: download the sentinel-mocks tarball from a run.

### Common Patterns

**Require tags:**

```python
import "tfplan/v2" as tfplan

required_tags = ["Environment", "Owner", "CostCenter"]

resources_with_tags = filter tfplan.resource_changes as _, rc {
  rc.change.after is not null and
  rc.type matches "^aws_" and
  (rc.change.actions contains "create" or rc.change.actions contains "update")
}

main = rule {
  all resources_with_tags as _, rc {
    all required_tags as t {
      rc.change.after.tags is not null and
      rc.change.after.tags[t] is not null
    }
  }
}
```

**Restrict region:**

```python
import "tfplan/v2" as tfplan

allowed_regions = ["us-east-1", "us-west-2"]

main = rule {
  all tfplan.resource_changes as _, rc {
    rc.provider_name is not "registry.terraform.io/hashicorp/aws" or
    rc.change.after is null or
    rc.change.after.region in allowed_regions
  }
}
```

**Cost limit:**

```python
import "tfrun"

limit = 1000  # monthly USD

main = rule {
  tfrun.cost_estimate.proposed_monthly_cost else 0 < limit
}
```

## OPA (Open Policy Agent) for Terraform

OPA is a general-purpose policy engine using the Rego language. HCP Terraform supports OPA policies as an alternative to Sentinel.

### Rego Example

```rego
package terraform

import input.plan as plan

deny[msg] {
  resource := plan.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.after.acl == "public-read"
  msg := sprintf("S3 bucket %v is public-read", [resource.address])
}
```

Rules are `allow`/`deny` and accumulate reasons. OPA evaluates all rules and returns the list of violations.

### Testing Rego

```
conftest test --policy policies/ plan.json
opa test policies/
```

`conftest` wraps OPA for config testing. The `terraform show -json tfplan > plan.json` output is the standard input.

### OPA vs Sentinel

| Aspect | Sentinel | OPA |
|--------|----------|-----|
| Vendor | HashiCorp | CNCF |
| Language | Sentinel (Python-like) | Rego |
| Integration | Native in HCP/TFE | Native in HCP/TFE, also K8s, Envoy, others |
| Tier | Plus / all TFE | Plus / all TFE |
| Testing | `sentinel test` | `opa test`, `conftest` |
| Portability | Limited | High (reuse for K8s admission, etc.) |

Choose Sentinel for HashiCorp-only stacks and tight integration. Choose OPA if you already use it for Kubernetes or API gateways and want a single policy language.

## Continuous Validation with check Blocks

`check` blocks run on every plan and during health assessments. They generate warnings, not failures.

```hcl
check "certificate_expiry" {
  data "tls_certificate" "site" {
    url = "https://${aws_lb.main.dns_name}"
  }

  assert {
    condition     = timecmp(data.tls_certificate.site.certificates[0].not_after, timeadd(timestamp(), "720h")) > 0
    error_message = "Certificate expires within 30 days."
  }
}
```

Pair with health assessments so HCP Terraform surfaces the warning daily.

## Pre-Plan vs Post-Plan Policies

- **Post-plan (standard):** policy runs after plan is computed; sees all resource changes. This is the default and covers most use cases.
- **Pre-plan (Plus tier):** policy runs before plan even starts. Can block based on run metadata (who triggered it, what hours, etc.). Useful for change-window enforcement.

## Mocking and Local Development

For Sentinel:

```
sentinel apply -mocks=/path/to/mocks policy.sentinel
```

For OPA:

```
opa eval -d policies/ -i plan.json 'data.terraform.deny'
```

Build mock fixtures by downloading the mock bundle from a real run in HCP Terraform.

## Anti-Patterns

- Writing a single monolithic policy that tests everything (hard to test, hard to maintain)
- Using soft-mandatory for truly hard requirements (override bypass is easy)
- Skipping tests (policies without tests rot)
- Embedding secrets in policy code
- Writing policies that silently skip when inputs are null (catch nulls explicitly)

## Exam-Ready Checklist

- [ ] Can author a Sentinel policy filtering `tfplan.resource_changes`
- [ ] Understand advisory, soft-mandatory, hard-mandatory
- [ ] Can package policies into a policy set and attach
- [ ] Can write equivalent logic in Rego
- [ ] Can test Sentinel policies with mocks
- [ ] Know when to use `check` blocks vs Sentinel
