# Modules and Registry

Module authoring is the largest single domain on the Professional exam (about 25%). You must be able to design clean interfaces, handle complex inputs, test thoroughly, and publish to a registry.

## Module Anatomy

A well-structured module directory:

```
modules/vpc/
├── README.md           # usage, inputs, outputs, examples
├── main.tf             # primary resources
├── variables.tf        # input declarations
├── outputs.tf          # exported values
├── versions.tf         # required_providers, required_version
├── locals.tf           # computed values (optional)
├── examples/
│   ├── complete/
│   │   └── main.tf
│   └── minimal/
│       └── main.tf
└── tests/
    ├── defaults.tftest.hcl
    └── integration.tftest.hcl
```

Keep modules focused. A VPC module that also provisions RDS is two modules in disguise.

## Input Variables with Complex Types

```hcl
variable "subnets" {
  description = "Subnet configuration keyed by name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = optional(bool, false)
    tags              = optional(map(string), {})
  }))
  validation {
    condition     = alltrue([for s in var.subnets : can(cidrnetmask(s.cidr_block))])
    error_message = "All subnets must have valid CIDR blocks."
  }
}
```

Key features:

- `optional(type, default)` provides defaults within object types (Terraform 1.3+)
- `validation` blocks enforce invariants with custom error messages
- Multiple `validation` blocks are allowed per variable
- `nullable = false` prevents null assignments

## Output Variables

```hcl
output "subnet_ids" {
  description = "Map of subnet name to ID"
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "database_password" {
  value     = aws_rds_cluster.main.master_password
  sensitive = true
}
```

`sensitive = true` redacts the value from plan/apply output but does not hide it from state. Use `ephemeral = true` (Terraform 1.10+) when consumers need the value but it should not persist.

## for_each vs count

Prefer `for_each` when:

- Resources have distinct identifiers (names, keys)
- You want stable addresses when the list changes

Use `count` when:

- You need conditional creation: `count = var.enabled ? 1 : 0`
- The instances are truly interchangeable

```hcl
resource "aws_subnet" "this" {
  for_each          = var.subnets
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = merge({ Name = each.key }, each.value.tags)
}
```

Address: `aws_subnet.this["public-a"]`. Stable across list reorderings.

## Dynamic Blocks

```hcl
resource "aws_security_group" "web" {
  name = "web"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }
}
```

Dynamic blocks iterate to generate nested configuration blocks. Use sparingly. Often a cleaner design is to split into multiple resources.

## Lifecycle Meta-Arguments

```hcl
resource "aws_instance" "web" {
  # ...
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags["LastModified"]]
    replace_triggered_by  = [aws_launch_template.web.latest_version]

    precondition {
      condition     = var.instance_type != "t2.nano"
      error_message = "Production cannot use t2.nano."
    }
    postcondition {
      condition     = self.public_ip != ""
      error_message = "Instance must have a public IP."
    }
  }
}
```

- `create_before_destroy` avoids downtime on replaces
- `prevent_destroy` blocks accidental deletion (must remove before destroying)
- `ignore_changes` prevents drift on specific attributes
- `replace_triggered_by` forces replacement when referenced resources change
- `precondition` validates inputs before any operation
- `postcondition` validates computed results after operation

## check Blocks (Terraform 1.5+)

```hcl
check "health" {
  data "http" "endpoint" {
    url = "https://${aws_lb.main.dns_name}/health"
  }
  assert {
    condition     = data.http.endpoint.status_code == 200
    error_message = "Load balancer health check failed."
  }
}
```

Unlike `postcondition`, `check` blocks never block apply. They issue warnings. Useful for continuous validation in HCP Terraform health assessments.

## Module Composition Patterns

**Root module calls child modules:**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  # inputs
}

module "app" {
  source = "./modules/app"
  vpc_id = module.vpc.vpc_id
}
```

**Module sources:**

- Local: `source = "./modules/app"`
- Terraform Registry: `source = "terraform-aws-modules/vpc/aws"`
- Private Registry (HCP): `source = "app.terraform.io/my-org/vpc/aws"`
- Git: `source = "git::https://github.com/org/repo.git//path?ref=v1.0.0"`
- GitHub shorthand: `source = "github.com/org/repo"`
- S3: `source = "s3::https://s3.amazonaws.com/bucket/module.zip"`

Always pin versions (`version = "~> 1.2"`) or git refs (`?ref=v1.2.0`).

## Version Constraints

```hcl
terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

Operators:

- `=` exact
- `!=` not equal
- `>, >=, <, <=` ranges
- `~>` pessimistic: `~> 1.2` means `>= 1.2, < 2.0`; `~> 1.2.3` means `>= 1.2.3, < 1.3.0`

## Publishing to the HCP Terraform Private Registry

1. Repo named `terraform-<provider>-<name>` (e.g., `terraform-aws-vpc`)
2. Semantic version tags (`v1.0.0`)
3. Connect VCS to HCP Terraform
4. In HCP: Registry > Publish Module > select repo
5. Future tags auto-publish

Consumers:

```hcl
module "vpc" {
  source  = "app.terraform.io/my-org/vpc/aws"
  version = "~> 1.0"
}
```

## terraform test

Test files use the `.tftest.hcl` extension and live in the module root or a `tests/` subdirectory.

```hcl
# tests/defaults.tftest.hcl

variables {
  region = "us-east-1"
}

run "plan_only" {
  command = plan

  assert {
    condition     = length(aws_subnet.this) == 2
    error_message = "Expected 2 subnets, got ${length(aws_subnet.this)}"
  }
}

run "apply_real" {
  command = apply

  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "CIDR mismatch"
  }
}
```

- `command = plan` is free and fast (no provider API calls for the apply phase)
- `command = apply` creates real infrastructure and destroys it after
- `expect_failures` lets you assert a run block should fail (useful for validation tests)
- `providers` block can mock providers for unit-like tests

Run with `terraform test`. Integrate in CI to block PRs.

## README Standards

A module README should include:

- Purpose (one sentence)
- Usage example (copy-pasteable HCL block)
- Requirements (Terraform version, provider versions)
- Inputs table (generated by `terraform-docs`)
- Outputs table
- Examples directory links
- License and maintainers

Use `terraform-docs markdown . > README.md` to auto-generate input/output tables.

## Versioning Strategy

Follow semantic versioning:

- MAJOR: breaking change (removed input, changed type, incompatible default)
- MINOR: new feature, backward-compatible (new optional input)
- PATCH: bug fix, no interface change

Breaking changes require a CHANGELOG and migration notes. Maintain the previous major for bug fixes for at least one release cycle.

## Anti-Patterns

- Mixing provider configuration inside modules (providers should be configured in root)
- Accepting provider as a string input and using `provider = "aws.${var.region}"` (does not work)
- Hardcoding region or account-specific values
- Using `terraform_remote_state` inside modules (tight coupling)
- Depending on environment variables for business logic

## Exam-Ready Checklist

- [ ] Can author a module with complex object variables and validation
- [ ] Can write `terraform test` files with plan and apply runs
- [ ] Can publish a module to HCP private registry
- [ ] Can use `moved` blocks to refactor
- [ ] Know when to use `count` vs `for_each` vs `dynamic`
- [ ] Can read and write `precondition`, `postcondition`, `check` blocks
