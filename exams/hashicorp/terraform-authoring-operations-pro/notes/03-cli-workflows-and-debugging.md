# CLI Workflows and Debugging

The Professional exam tests CLI fluency under time pressure. You need muscle memory for the commands and the ability to debug quickly using logs, graphs, and console.

## The Core Lifecycle Commands

```
terraform init       # download providers, configure backend
terraform validate   # syntax and internal consistency check
terraform plan       # compute diff, show actions
terraform apply      # execute the plan
terraform destroy    # tear down all managed resources
```

All are idempotent except `apply`. `plan` is safe to run repeatedly and often.

## terraform init Flags

```
terraform init \
  -backend-config=prod.tfbackend \  # extra backend settings
  -upgrade \                          # bump providers within constraints
  -reconfigure \                      # throw away old backend config
  -migrate-state \                    # copy state to new backend
  -get=false \                        # skip module download
  -input=false \                      # no interactive prompts (CI)
  -lock-timeout=60s                   # wait for state lock
```

**`-backend-config`** can point to a file or a key=value pair. Useful for per-environment backends without duplicating the `terraform {}` block.

## terraform plan Flags

```
terraform plan \
  -out=tfplan \                  # save plan for later apply
  -var-file=prod.tfvars \        # load variables
  -var="region=us-west-2" \      # inline override
  -target=aws_instance.web \     # plan only this resource (use sparingly)
  -replace=aws_instance.web \    # force replacement
  -refresh-only \                # just refresh state, no diff
  -refresh=false \               # skip refresh
  -destroy \                     # plan for destroy
  -detailed-exitcode \           # 0=no changes, 1=error, 2=changes present
  -generate-config-out=gen.tf \  # for import blocks
  -parallelism=10                # max concurrent operations (default 10)
```

`-detailed-exitcode` is CI-friendly: exit 2 means "apply would change things".

## terraform apply Flags

```
terraform apply tfplan           # apply a saved plan (no prompts)
terraform apply -auto-approve    # skip interactive prompt
terraform apply -input=false     # no prompts for variables
```

Saved plans are the safest pattern for CI: `plan -out` in one job, human approves, `apply tfplan` in the next job. Saved plans bind to the exact state version; if state changes, apply fails.

## terraform state Subcommands

See the state management note for detailed usage. Most-used on the exam:

```
terraform state list
terraform state show ADDRESS
terraform state mv SRC DST
terraform state rm ADDRESS
terraform state pull
terraform state push FILE
terraform state replace-provider OLD_FQN NEW_FQN
```

## terraform console

An interactive REPL for expressions:

```
$ terraform console
> var.region
"us-east-1"
> [for s in aws_subnet.this : s.id]
["subnet-abc", "subnet-def"]
> try(var.nonexistent, "default")
"default"
> cidrsubnet("10.0.0.0/16", 8, 3)
"10.0.3.0/24"
```

Perfect for:

- Testing `for` expressions before writing HCL
- Evaluating `locals` without running apply
- Inspecting outputs of existing state

## terraform graph

Generates a DOT representation of the dependency graph.

```
terraform graph | dot -Tpng > graph.png
terraform graph -type=plan
terraform graph -type=apply
terraform graph -type=plan-destroy
```

Useful when debugging cycles or unexpected orderings.

## terraform providers

```
terraform providers              # show provider tree per module
terraform providers lock -platform=linux_amd64 -platform=darwin_arm64
terraform providers mirror /path # download providers for air-gapped use
terraform providers schema -json # full schema dump
```

`providers lock` is essential for multi-platform teams (Mac developers + Linux CI).

## Debug Logging

```
export TF_LOG=TRACE                      # most verbose
export TF_LOG=DEBUG                      # verbose
export TF_LOG=INFO                       # informational
export TF_LOG=WARN                       # warnings only
export TF_LOG=ERROR                      # errors only
export TF_LOG_PATH=./terraform.log       # send to file
export TF_LOG_CORE=DEBUG                 # core only
export TF_LOG_PROVIDER=TRACE             # providers only
export TF_LOG_PROVIDER_AWS=TRACE         # single provider (1.6+)
```

TRACE shows every gRPC call between Terraform and providers. Use it to diagnose:

- Provider crashes (look for panic in logs)
- Slow operations (correlate timestamps)
- Unexpected API calls (e.g., refresh hitting rate limits)

## Environment Variables Worth Knowing

| Variable | Effect |
|----------|--------|
| `TF_VAR_foo` | Set input variable `foo` |
| `TF_CLI_ARGS` | Append flags to every Terraform command |
| `TF_CLI_ARGS_plan` | Append flags only to `terraform plan` |
| `TF_INPUT=0` | Disable interactive prompts |
| `TF_IN_AUTOMATION=1` | Suppress hints about CLI usage |
| `TF_PLUGIN_CACHE_DIR` | Shared provider cache across workspaces |
| `TF_REGISTRY_DISCOVERY_RETRY` | Retry count for registry lookups |
| `TF_WORKSPACE` | Select workspace without `terraform workspace select` |

`TF_PLUGIN_CACHE_DIR=~/.terraform.d/plugin-cache` dramatically speeds up init in CI.

## Provider Lock File

`.terraform.lock.hcl` pins provider versions and hashes.

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.40.0"
  constraints = "~> 5.0"
  hashes = [
    "h1:abc...",
    "zh:def...",
  ]
}
```

- Commit this file to version control
- Regenerate across platforms with `terraform providers lock -platform=...`
- `terraform init` enforces matching hashes; mismatch blocks init
- `terraform init -upgrade` fetches newer versions within constraints

## Working with Saved Plans

```
terraform plan -out=tfplan
terraform show tfplan             # human-readable
terraform show -json tfplan | jq  # machine-readable, pipe to tools
```

The JSON form is the basis for Sentinel, OPA, Checkov, and custom governance. Structure includes `resource_changes`, `configuration`, `prior_state`, `planned_values`.

## Common Error Patterns

**"Error locking state: ConditionalCheckFailedException"**
Someone else holds the lock. Wait, or force-unlock if stale.

**"Error: Provider produced inconsistent final plan"**
Provider bug or a computed attribute that changes between plan and apply. File an issue and/or add `lifecycle.ignore_changes`.

**"Error: Unsupported Terraform Core version"**
Your CLI is older than `required_version`. Upgrade.

**"Error: Failed to query available provider packages"**
Network/registry issue. Check proxy, TF_REGISTRY_DISCOVERY_RETRY, or use a mirror.

**"Error: Invalid function argument"**
HCL-level. Run `terraform console` to isolate.

**"Error: Cycle: ..."**
Circular dependency. Check `terraform graph` or restructure references.

## Targeted Operations

`-target` and `-replace` are escape hatches. On the exam, use them only if explicitly required. They break the declarative model.

```
terraform plan -target=aws_instance.web      # only this resource
terraform apply -replace=aws_instance.web    # force recreate this resource
```

Prefer `moved` blocks, `removed` blocks, `import` blocks, or `lifecycle.replace_triggered_by` for persistent intent.

## Formatter and Validator

```
terraform fmt -recursive           # format all files
terraform fmt -check               # exit non-zero if changes needed (CI)
terraform fmt -diff                # show what would change
terraform validate                 # syntax and internal references
terraform validate -json           # machine-readable output
```

Both are fast and cheap. Run both on every commit via pre-commit hooks.

## Workspace Commands

```
terraform workspace list
terraform workspace new dev
terraform workspace select prod
terraform workspace delete old-env
terraform workspace show
```

CLI workspaces are distinct from HCP Terraform workspaces. CLI workspaces just partition state within a single backend. HCP Terraform workspaces are full environments with their own variables, runs, and permissions. In HCP-backed configurations, CLI workspaces map to HCP workspaces via tags.

## Exam-Ready Checklist

- [ ] Can read `TF_LOG=TRACE` output enough to pinpoint a failing API call
- [ ] Can save and apply a plan file
- [ ] Can use `terraform console` to debug expressions
- [ ] Can regenerate the lock file for multiple platforms
- [ ] Know when `-target` and `-replace` are appropriate (rarely)
- [ ] Can decode `detailed-exitcode` in CI scripts
