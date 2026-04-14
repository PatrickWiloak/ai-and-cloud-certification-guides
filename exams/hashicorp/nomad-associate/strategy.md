# Nomad Associate - Exam Strategy

60 minutes, 57 questions, multiple-choice and multi-select. About 63 seconds per question on average. Pace is important; lingering on one hard question costs you two easy ones.

## The Week Before

- Run PSI system check 48+ hours out.
- Confirm testing space is quiet and clutter-free.
- Normal sleep; don't cram.
- One full timed mock, review gaps.

## The Day Of

- Real meal 60-90 min out.
- Close all apps and notifications.
- Bathroom break right before check-in.
- Water nearby.

## Time Budget

- 57 questions / 60 minutes = 63 sec/q average
- First pass: ~45 minutes at 47 sec/q; flag and skip hard ones
- Second pass: 12 minutes on flagged
- Final 3 minutes: verify all answered

## Question Approach

1. Read carefully. Identify the ask.
2. Identify the domain (arch, jobspec, scheduling, networking, storage, ACL).
3. Eliminate clearly wrong answers.
4. Pick the most specific of the remaining.
5. Flag if unsure, move on.

## Common Trap Patterns

### Job Type Confusion

- `service`: long-running, auto-restart, scalable
- `batch`: run to completion, not restarted
- `system`: one allocation per node in scope (like K8s DaemonSet)
- `sysbatch`: run to completion on every node (one-off cluster ops)

Questions describe behavior, ask for the type. Know all four.

### Driver Selection

- `docker` for container images
- `exec` for chrooted/cgrouped native binaries
- `raw_exec` for untrusted/unsandboxed (disabled by default)
- `java` for JAR files
- `qemu` for KVM VMs
- `podman`, `containerd` as Docker alternatives

Watch for wrong driver assignments (e.g., "java" for a JAR is correct; "exec" is wrong though technically possible).

### Network Modes

- `host`: task shares host network; ports are host ports
- `bridge`: Nomad creates a network namespace with NAT
- `none`: no network
- CNI plugins: custom (calico, etc.)

`bridge` is common and supports port mapping. `host` is high-performance but no isolation.

### Service Provider

- `provider = "consul"` (default): registers with Consul
- `provider = "nomad"` (1.3+): Nomad native catalog

Some questions ask which requires Consul installed. Only the consul provider does.

### Constraints vs Affinities

- **Constraints:** hard requirements; fail to place if unmet
- **Affinities:** soft preferences with weights; scheduler prefers but doesn't require

Questions describing "must" or "required" want constraints. "Prefer" or "should" wants affinities.

### Canary vs Rolling Update

Canary: N new-version instances run alongside old. Promote manually (or via auto_promote) to replace all.
Rolling: no overlap; each old instance replaced one at a time.

### Restart vs Reschedule

- **restart:** task stays on same alloc, Nomad restarts the task
- **reschedule:** alloc itself moves (to a new node) after restart attempts exhausted

Restart first, then reschedule.

### Raft Quorum Math

- 3 servers: quorum 2, tolerates 1 failure
- 5 servers: quorum 3, tolerates 2 failures
- 7 servers: quorum 4, tolerates 3 failures
- Recommended: 3 for small, 5 for large. Never use even numbers.

### System Jobs Don't Honor count

`system` and `sysbatch` jobs run one allocation per node matching constraints. `count` is ignored or implied.

### Default Ports

- 4646: HTTP API and UI
- 4647: RPC
- 4648: Serf gossip

Memorize these.

### Namespace vs Region

- Namespace: logical partition for multi-tenancy
- Region: physical grouping (independent servers)

A job belongs to one region and one namespace.

## Frequently Tested Topics

- Which files are auto-loaded? (Nomad reads `-config` directory recursively)
- What does `nomad job plan` do? (Dry run, shows diff and scheduling result)
- What's the difference between `-purge` and regular stop? (Purge removes job spec from state entirely)
- How do periodic jobs work? (Cron-like `periodic { cron = "..." }`)
- How does service mesh work with Consul Connect? (Sidecar proxy injected per task)
- When is preemption used? (Higher-priority jobs can evict lower-priority)

## Answer Patterns That Are Often Wrong

- Options mentioning Kubernetes concepts (kubelet, pod, ingress controller directly) in Nomad context
- Options suggesting YAML as Nomad's config (HCL and JSON only)
- Options claiming `raw_exec` is safe default (it's disabled by default)
- Options confusing system with service jobs

## Answer Patterns That Are Often Right

- Options specifying "HCL" or "HCL2" for config format
- Options mentioning Consul for service discovery by default
- Options highlighting the scheduler's bin-packing behavior
- Options referencing Raft for server consensus

## Multi-Select Considerations

Some questions ask for all correct answers. Evaluate each option independently. Typically 2-3 correct out of 4-5.

## Reading Difficult Questions

Focus on:

- **Goal:** what outcome is desired
- **Constraint:** what must/must not happen
- **Environment:** OSS vs Enterprise, with/without Consul, with/without Vault

## Mental State

- This is Associate-level. You studied; trust it.
- Flag and move on when stuck; fresh eyes help on pass 2.
- Don't change confident answers unless you see a specific error.

## After Submitting

- Results often within minutes.
- Credly badge email for pass.
- Fail? Review domain breakdown for retake focus.

## Post-Certification

- Update LinkedIn and resume.
- Deploy a real Nomad cluster at work or home to cement skills.
- Consider Consul Associate next.
