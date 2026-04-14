# Boundary Associate - Exam Strategy

60 minutes, 57 questions, multiple-choice and multi-select. About 63 seconds per question on average. Pace yourself: a rushed answer to a question you know is worse than a thoughtful guess on one you don't.

## The Week Before

- Run PSI system check.
- Confirm your exam location is quiet, well-lit, and clutter-free.
- Sleep normally.
- Do one full timed mock exam and review gaps.

## The Day Of

- Eat a real meal 60-90 minutes out.
- Close all non-exam apps and notifications.
- Bathroom break immediately before check-in.
- Keep water nearby.

## Time Budget

- 57 questions / 60 minutes = 63 sec/q average
- First pass: 45 minutes, 47 sec/q avg, skip anything needing more than 90 seconds
- Second pass: 12 minutes on flagged items
- Last 3 minutes: sanity check, ensure nothing left blank

## Question Approach

1. Read the stem carefully. Identify what is being asked (not what sounds familiar).
2. Identify the domain (architecture, RBAC, credentials, workers, sessions, ops).
3. Eliminate clearly wrong answers first (wrong product, wrong syntax, wrong direction).
4. Pick the most specific remaining answer.
5. Flag and move on if unsure.

## Common Trap Patterns

### Scope Confusion
Questions will ask where a resource can exist. Core rule: targets, hosts, credential stores live in project scopes; auth methods can exist in global, org, or project (but most commonly org); roles can exist in any scope with different grant_scope options.

### Grant String Parsing
Many questions show a grant string and ask what it does, or describe a permission and ask for the correct grant. Practice this.

- `ids=*;type=target;actions=authorize-session` - any target in this scope, authorize sessions
- `ids=*;type=session;actions=list,read,cancel:self` - see your own sessions only

Watch for `:self` and the difference between `children` vs `descendants` grant_scope.

### Brokering vs Injection
- **Brokering:** credential passed to client; client sees it
- **Injection:** credential used by worker in the session; client never sees it

Question phrasings like "the user should not see the database password" point to injection.

### Worker Types
- **Ingress:** accepts client connections; must be reachable from clients
- **Egress:** reaches targets; must be reachable to targets
- Often one worker serves both roles in simple deployments; multi-hop needs both

### Auth Method Primary Flag
Only one primary per auth type per scope. Primary is implied when users login without specifying the method ID. Questions will test "what happens if two OIDC methods in one scope, one primary, one not?" Answer: users must specify the non-primary method's ID explicitly.

### Static vs Dynamic Host Catalog
- **Static (hcst_):** hosts managed manually
- **Dynamic / plugin (hcplg_):** hosts synced from a cloud provider (AWS, Azure) using filters

Dynamic catalogs require plugin configuration with cloud creds; static don't.

### TCP vs SSH Target
- **TCP target (ttcp_):** raw TCP proxy; any protocol
- **SSH target (tssh_):** SSH-specific; supports credential injection and session recording

SSH-specific features (injection, recording) only work on SSH targets.

### Session Lifecycle
Know the states: pending, active, canceling, terminated. Know what triggers each transition.

## Frequently Tested Topics

- What purpose does each KMS key serve? (root, worker-auth, recovery)
- How do workers authenticate to controllers? (KMS-based or PKI)
- What is the difference between a host and a target?
- Where are credentials stored? (credential stores, then libraries within)
- How does Boundary integrate with Vault? (token with policy, credential store with library)
- What is a managed group? (dynamic membership based on auth claims)
- How does boundary connect ssh differ from boundary connect? (SSH-aware, handles known_hosts, credentials)

## Reading Difficult Questions

Questions with long stems often include distractors. Focus on:

- What is the GOAL? (connect to a target, grant access, etc.)
- What is the CONSTRAINT? (user shouldn't see creds, workers in private net, etc.)
- What is the DESIRED OUTCOME? (configuration, command, or concept)

## Multi-Select Questions

Some questions ask "select all that apply." Carefully evaluate each option independently. It's usually 2 or 3 correct out of 4 or 5 choices.

## When to Guess

If you can eliminate 2 options, guess between the remaining 2. Never leave blank. There's no negative scoring.

## Answer Patterns That Are Usually Wrong

- Options that suggest Boundary is a full VPN replacement
- Options that claim a feature without mentioning the required tier (e.g., session recording in Community Edition)
- Options that confuse Vault and Boundary responsibilities
- Options with invalid resource ID prefixes (`target_123` when it should be `ttcp_` or `tssh_`)

## Answer Patterns That Are Often Right

- Options that explicitly reference scopes
- Options that include "primary" for auth methods in simple-auth scenarios
- Options that use `:self` for personal session management
- Options that mention managed groups for OIDC-driven RBAC

## Keyboard Efficiency

The exam UI is web-based. Use keyboard shortcuts where available (flagging, navigating questions). Most PSI exams let you tab through options.

## Mental State

- Trust your preparation. You've done this in labs.
- Don't panic on a weird question. Flag and move on.
- Fresh eyes on second pass catch things you missed.

## After Submitting

- Results typically within minutes.
- Credly badge email arrives shortly after passing.
- Failed? Review the domain breakdown and focus retake study accordingly.

## Post-Certification

- Update LinkedIn and resume.
- Consider Vault Associate next for the full identity/secrets stack.
- Deploy a real Boundary cluster to cement learning.
