# Terraform Authoring and Operations Professional - Practice Plan

This is an 8-week plan assuming 8 to 12 hours per week of dedicated study plus lab time. Compress to 6 weeks if you already have strong production experience, or extend to 12 weeks if you are coming directly from the Associate exam.

## Prerequisites Before Week 1

- HCP Terraform account (free tier is sufficient for most labs)
- AWS or Azure or GCP sandbox account with budget alarms configured
- Local Terraform CLI 1.9 or newer installed
- Git and a GitHub or GitLab account for VCS-driven workspace labs
- `tfenv` or `asdf` for managing multiple Terraform versions

## Week 1: Module Authoring Foundations

**Reading**
- Notes file `01-state-management-advanced.md` sections on state fundamentals (skim)
- Notes file `02-modules-and-registry.md` in full
- Official docs: Module Development, Module Composition

**Labs**
- Build a VPC module with public and private subnets using `for_each` over a subnet map
- Add variable validation for CIDR overlap
- Add `precondition` and `postcondition` checks to assert VPC health
- Write a `README.md` and `examples/complete/` directory

**Checkpoint**
- Your module must accept a map of AZ to subnet CIDRs and output subnet IDs keyed by AZ.
- Run `terraform fmt -recursive` and `terraform validate` with zero errors.

## Week 2: Advanced HCL and terraform test

**Reading**
- Notes file `02-modules-and-registry.md` sections on testing and publishing
- Official docs: `terraform test`, `check` blocks, `moved` blocks

**Labs**
- Add a `tests/` directory to last week's module
- Write three `.tftest.hcl` files: one unit (plan only), one integration (apply), one validation of outputs
- Refactor a resource using `moved` blocks without destroying
- Use `removed` blocks to drop an output or resource from state

**Checkpoint**
- `terraform test` runs clean with at least 3 `run` blocks.
- You can explain the difference between `check` blocks and `validation` blocks.

## Week 3: State Management Deep Dive

**Reading**
- Notes file `01-state-management-advanced.md` in full
- Official docs: backends, state locking, import blocks

**Labs**
- Configure an S3 + DynamoDB backend with KMS encryption
- Migrate a workspace from local state to S3 backend using `terraform init -migrate-state`
- Import three existing resources (one with `terraform import` CLI, two with `import` blocks)
- Simulate a lock conflict and use `terraform force-unlock` to recover
- Split a state into two by using `terraform state mv` and a new backend prefix

**Checkpoint**
- You can recover from a corrupt state by pulling, editing, and pushing.
- You understand when `-refresh-only` is safer than a regular plan.

## Week 4: CLI Workflows and Debugging

**Reading**
- Notes file `03-cli-workflows-and-debugging.md` in full

**Labs**
- Run `TF_LOG=TRACE terraform plan` and read the provider RPC traffic
- Use `terraform console` to test `for` expressions and `try()` calls
- Use `terraform graph | dot -Tpng > graph.png` to visualize dependencies
- Generate a saved plan file, inspect with `terraform show -json tfplan | jq`, then apply
- Debug a broken `.terraform.lock.hcl` by regenerating with `terraform providers lock`

**Checkpoint**
- Given a failing plan, you can narrow the failure to a specific resource and produce a minimal reproduction.

## Week 5: HCP Terraform and Enterprise Operations

**Reading**
- Notes file `04-terraform-cloud-enterprise.md` in full
- Official docs: workspaces, variable sets, projects, dynamic credentials

**Labs**
- Create a CLI-driven workspace and push a local state
- Create a VCS-driven workspace connected to a GitHub repo, enable speculative plans on PRs
- Create an API-driven workspace using the `tfe` provider
- Configure dynamic AWS credentials via OIDC (no static keys)
- Set up variable sets at organization scope and apply to a project
- Configure a run trigger so workspace B runs after workspace A applies

**Checkpoint**
- You can explain the tradeoffs between the three execution modes (remote, local, agent).
- You have a working OIDC integration and can prove no long-lived AWS keys are stored.

## Week 6: Policy as Code with Sentinel and OPA

**Reading**
- Notes file `05-policy-as-code-sentinel-opa.md` in full
- Official docs: Sentinel language, Sentinel imports, OPA Conftest

**Labs**
- Write three Sentinel policies: block public S3, require tags, restrict instance types
- Test each with `sentinel test` using mock data generated from a real plan
- Package into a policy set, attach to a workspace, run a plan that violates and one that passes
- Write equivalent policies in Rego and evaluate with `conftest` against a plan JSON

**Checkpoint**
- You can explain the three enforcement levels and when to use each.
- You can generate Sentinel mock data from a real run.

## Week 7: CI/CD Automation and Run Tasks

**Reading**
- Notes file `06-collaboration-and-automation.md` in full
- Official docs: run tasks, GitHub Actions `setup-terraform`

**Labs**
- Build a GitHub Actions pipeline that runs `terraform fmt`, `validate`, `plan` on PRs
- Configure a run task pointing to a local Checkov webhook (use a sample signed receiver)
- Use the `tfe` provider to provision workspaces for a new team self-service flow
- Enable drift detection (health assessments) on a production workspace and review results

**Checkpoint**
- You understand the difference between speculative plans, run triggers, and run tasks.
- You can provision a workspace end-to-end via API using `tfe`.

## Week 8: Full Lab Simulations and Weak Area Reinforcement

**Activities**
- Take a 4-hour timed mock lab (build your own scenario list from `scenarios.md`)
- Review every scenario in `scenarios.md` and write out your solution steps before reading the answer
- Re-do any lab from weeks 1 to 7 where you were slow or needed to look up commands
- Read `strategy.md` and `fact-sheet.md` end to end two days before the exam

**Daily drills (15 minutes each, last 7 days)**
- `terraform state` subcommands from memory
- Sentinel `tfplan/v2` traversal idioms
- HCP Terraform API endpoints for workspace and variable management
- CLI flags for `plan` and `apply` (`-target`, `-replace`, `-refresh-only`, `-out`, `-var-file`)

## Mock Exam Structure (build your own)

Pick 5 of the following as a 4-hour timed drill:

1. Refactor a `count`-based module to `for_each` preserving state (30 min)
2. Import 3 existing resources into a new module using `import` blocks (30 min)
3. Migrate a workspace from S3 to HCP Terraform preserving state (30 min)
4. Write a Sentinel policy blocking unencrypted EBS volumes, test and attach (45 min)
5. Configure a VCS workspace with OIDC AWS credentials, prove zero static keys (45 min)
6. Debug a failing plan with a provider lock conflict (30 min)
7. Author a module test suite covering plan, apply, and failure cases (45 min)
8. Split a monolithic workspace into 3 using state mv and run triggers (45 min)

## Hands-on Lab Environment Checklist

- [ ] `terraform -version` shows 1.9 or newer
- [ ] `terraform login` completed against HCP Terraform
- [ ] AWS/Azure/GCP credentials available via OIDC or env vars
- [ ] Private GitHub or GitLab repo for VCS-driven workspaces
- [ ] `sentinel` CLI installed for policy testing
- [ ] `conftest` installed for OPA testing (optional)
- [ ] `jq` and `yq` installed for plan inspection
- [ ] Budget alert set at $50 to catch runaway labs

## Final Week Tactics

- Day 7 to 4: wrap up any incomplete labs from weeks 1 to 7
- Day 3: full 4-hour mock exam using your scenario stack
- Day 2: targeted review of weakest domain
- Day 1: rest, light review of CLI flags and Sentinel syntax, no new material
- Exam day: set up a quiet workspace, ensure stable network, have water on hand, and do not plan anything else for the 4 hours
