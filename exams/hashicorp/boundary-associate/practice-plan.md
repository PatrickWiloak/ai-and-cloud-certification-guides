# Boundary Associate - Practice Plan

A 4-week plan at 8 to 10 hours per week. Compress to 3 weeks if you already use Boundary in production; extend to 6 weeks if zero-trust concepts are new.

## Prerequisites Before Week 1

- Docker Desktop or Podman installed
- Boundary CLI installed (`brew install hashicorp/tap/boundary` or download binary)
- Vault CLI installed
- A local editor with HCL highlighting
- Optional: HCP Boundary account (free trial) for SaaS practice
- Optional: small cloud account (AWS free tier) for dynamic host catalog labs

## Week 1: Architecture, Scopes, Users, First Target

**Reading**
- `fact-sheet.md` cover to cover
- Notes file `01-boundary-architecture.md`
- Official doc: "What is Boundary?" tutorial

**Labs**
- Run `boundary dev` locally. Leave it running in one terminal.
- In another terminal, authenticate: `boundary authenticate password -login-name=admin -password=password -auth-method-id=<shown-at-startup>`
- Create an org scope: `boundary scopes create -scope-id=global -name=demo-org`
- Create a project scope within the org
- Create a static host catalog, host, host set in the project
- Create a TCP target pointing to the host
- Attempt `boundary connect -target-id=...` and reach a local nginx container

**Checkpoint**
- You can explain scopes, targets, hosts, host sets
- You successfully connected through Boundary to a local service
- You understand what `boundary dev` bundled together

## Week 2: Auth Methods, RBAC, Dynamic Host Catalogs

**Reading**
- Notes file `02-targets-and-sessions.md`
- Notes file `04-authentication-and-rbac.md`

**Labs**
- Create a new password auth method in the org scope; make it primary
- Create users and assign them to accounts
- Create groups and assign users
- Create roles with specific grants: one "target-user" that can only authorize sessions, one "target-admin" that can CRUD targets
- Attach roles to groups, verify permissions with `boundary` CLI as different users
- Set up an OIDC auth method against Auth0 or Google (free tier)
- Create a managed group based on an OIDC claim
- Create an AWS dynamic host catalog (if you have AWS creds); set filters on tags

**Checkpoint**
- You can author and understand grant strings
- You can explain primary auth methods and how they simplify login
- You have at least one OIDC-authenticated session
- You understand `:self` qualifiers

## Week 3: Credential Brokering with Vault, Session Management

**Reading**
- Notes file `03-credential-brokering-vault.md`
- Notes file `06-session-recording-and-audit.md` (partial: focus on audit, defer recording if no Enterprise)

**Labs**
- Start a local Vault in dev mode: `vault server -dev`
- Enable the SSH secrets engine with CA for signed cert brokering
- Configure a Vault token for Boundary with a tight policy
- Create a Vault credential store in Boundary
- Create a credential library (Vault SSH cert)
- Attach the library to an SSH target as brokered credentials
- Connect with `boundary connect ssh -target-id=...` and observe credentials flowing
- Try credential injection mode; observe the credential is not exposed to you
- Inspect session lifecycle: `boundary sessions list`, cancel one, verify Vault leases revoked

**Checkpoint**
- You can configure Boundary-Vault integration end to end
- You can explain brokering vs injection
- You can interpret session status transitions

## Week 4: Deployment Modes, Workers, Exam Prep

**Reading**
- Notes file `05-deployment-modes.md`
- Revisit `06-session-recording-and-audit.md` fully
- Scenario run: `scenarios.md`

**Labs**
- Spin up a separate worker process and register it to your controller via PKI (worker-led auth)
- Add worker tags; route a target to that worker using worker filters
- Experiment with multi-hop: ingress worker + egress worker, verify traffic flows
- (Optional, Enterprise) Configure a storage bucket and test session recording
- Use Terraform's `boundary` provider to declare a full scope hierarchy and re-create your lab config as code

**Exam prep**
- Work every scenario in `scenarios.md`, writing answers before reading
- Review every grant string example; be able to parse at a glance
- Create 10 flashcards for resource ID prefixes, drill daily
- Full 60-minute mock using scenarios and fact-sheet quick-fire questions

## Daily Drills (week 4, 15 minutes each)

- Recite the three-tier scope hierarchy
- Name 5 resource ID prefixes
- Parse 3 grant strings
- Explain brokering vs injection
- Describe ingress vs egress workers
- Name the 3 KMS purposes

## Mock Exam Structure

Build a 57-question drill from scenarios and fact sheet:

- 11 on architecture and scopes
- 11 on targets and sessions
- 9 on credential brokering
- 11 on auth methods and RBAC
- 9 on deployment and workers
- 6 on recording and audit

Time strictly. Review every wrong answer against the relevant notes file.

## Hands-on Lab Environment Checklist

- [ ] `boundary version` shows 0.15+
- [ ] `boundary dev` runs successfully
- [ ] You have connected to at least one target
- [ ] You have an OIDC auth method working
- [ ] You have used Vault credential brokering
- [ ] You have configured a second worker and used tags to route
- [ ] (Optional) You have configured dynamic host catalogs

## Final 3 Days

- Day 3: full mock exam, review weak domains
- Day 2: re-read notes files for weak domains only, 30 min on `strategy.md`
- Day 1: light review, rest, early sleep

## Beyond the Associate

Natural follow-ups:

- Vault Associate (deep understanding of the credential side)
- Consul Associate (service discovery tie-ins for dynamic host catalogs)
- Terraform Associate (if not already, to provision Boundary as code)
