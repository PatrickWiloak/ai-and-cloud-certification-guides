# OpenShift Administrator (EX280) - 6-Week Practice Plan

This plan assumes 1-2 hours of theory + 2-3 hours of hands-on lab per day. EX280 is performance-based - you cannot pass on theory alone.

---

## Lab setup (do this first)

Choose one path:

- [ ] **OpenShift Local (CRC)** - free single-node OpenShift on your laptop ([download](https://developers.redhat.com/products/openshift-local/overview))
- [ ] **Developer Sandbox** - free 30-day shared cluster ([sandbox](https://developers.redhat.com/developer-sandbox))
- [ ] **ROSA / ARO** - paid managed clusters; usable for prep if you minimize uptime

Verify:

```bash
oc whoami
oc whoami --show-server
oc get nodes
oc get co
```

---

## Week 1 - Cluster basics + Projects + RBAC

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-cluster-install-config.md](./notes/01-cluster-install-config.md)
- [ ] [notes/02-projects-quotas-rbac.md](./notes/02-projects-quotas-rbac.md)

### Hands-on
- [ ] Inspect cluster: `oc get co`, `oc get nodes`, `oc get clusterversion`
- [ ] Cordon/drain/uncordon a node
- [ ] Create a project, switch into it, create a deployment, scale it
- [ ] Create a ResourceQuota and LimitRange
- [ ] Add an htpasswd user, edit OAuth, log in as that user
- [ ] Grant alice `admin` on `myapp`, verify with `oc auth can-i`

### Self-check
- [ ] Can I add an htpasswd user end-to-end without notes?
- [ ] Can I write a ResourceQuota and LimitRange YAML?
- [ ] Do I know the difference between `cluster-admin`, `admin`, `edit`, `view`?

---

## Week 2 - Workloads

### Reading
- [ ] [fact-sheet.md](./fact-sheet.md) - workloads section
- [ ] OpenShift docs: Building applications

### Hands-on
- [ ] `oc new-app` from Git repo
- [ ] `oc new-app` from container image
- [ ] Scale, rollback, set image, set env, set resources
- [ ] Configure HPA: `oc autoscale`
- [ ] Use `oc rollout` (status, undo, restart, history)
- [ ] Diagnose a pod stuck in CrashLoopBackOff using `oc logs -p`

### Self-check
- [ ] Can I deploy an app, expose it, and update its image rolling-restart-style?
- [ ] Do I know how to override container resource requests/limits?

---

## Week 3 - Networking and Routes

### Reading
- [ ] [notes/03-networking-routes.md](./notes/03-networking-routes.md)

### Hands-on
- [ ] Expose a Service as a ClusterIP, NodePort, LoadBalancer
- [ ] Create a Route (HTTP, edge TLS, passthrough TLS, reencrypt TLS)
- [ ] Path-based routing on the same hostname
- [ ] Canary route weighting (90/10)
- [ ] Default deny NetworkPolicy + allow specific source
- [ ] Allow from a different namespace
- [ ] Test that NetworkPolicy actually blocks (use `oc rsh` from a pod that should be denied)

### Self-check
- [ ] Can I write a NetworkPolicy from memory for a "deny all, allow frontend" pattern?
- [ ] Do I know the four TLS termination types for Routes?

---

## Week 4 - Storage

### Reading
- [ ] [notes/04-storage-pv-pvc.md](./notes/04-storage-pv-pvc.md)

### Hands-on
- [ ] List storage classes, identify the default
- [ ] Mount a PVC into a deployment using `oc set volume`
- [ ] Create PVC YAML directly with specific access mode and size
- [ ] Set a different default StorageClass
- [ ] Expand a PVC and verify size grew (after pod restart)
- [ ] (If on cluster with NFS) statically provision an NFS PV
- [ ] Diagnose a Pending PVC (`oc describe pvc`)

### Self-check
- [ ] Can I write a PVC YAML with specific access mode and storage class?
- [ ] Do I know which access modes are supported by EBS / Azure Disk / NFS?
- [ ] Can I expand a volume and have the pod see the new size?

---

## Week 5 - Operators, Monitoring, Identity Providers

### Reading
- [ ] [notes/05-operators-monitoring.md](./notes/05-operators-monitoring.md)
- [ ] OpenShift docs: Operators

### Hands-on
- [ ] Install an operator from OperatorHub (e.g., OpenShift Pipelines)
- [ ] Verify the operator reaches `Succeeded` CSV
- [ ] Manual approval of an InstallPlan
- [ ] Enable user-workload monitoring via cluster-monitoring-config
- [ ] Configure HTPasswd identity provider (multiple users)
- [ ] Configure a cluster admin via `add-cluster-role-to-user`

### Self-check
- [ ] Can I install an operator from raw YAML (Subscription + OperatorGroup)?
- [ ] Can I enable user workload monitoring?
- [ ] Can I add and remove htpasswd users on an existing IDP?

---

## Week 6 - Security, Troubleshooting, Mock Exams

### Reading
- [ ] [fact-sheet.md](./fact-sheet.md) - SCC and Security sections
- [ ] [scenarios.md](./scenarios.md) - work through all 15

### Hands-on
- [ ] Add `anyuid` SCC to a service account
- [ ] Diagnose a pod failing on SCC ("unable to validate against any security context constraint")
- [ ] Run `oc adm must-gather`
- [ ] Run `oc debug node/<name>` and `chroot /host`
- [ ] Recover a pod stuck in `Pending` due to PVC issues
- [ ] Recover from broken NetworkPolicy

### Mock exams
- [ ] Sander van Vugt's EX280 practice exam (book or video course)
- [ ] [scenarios.md](./scenarios.md) - aim to do all 15 in 2 hours
- [ ] Score 80%+ on a clean lab session before scheduling

### Schedule the exam
- [ ] Book Red Hat Individual Exam (online) or testing center
- [ ] Confirm 3-hour slot
- [ ] Plan exam-day logistics

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30 min | Read notes / fact-sheet section |
| 90 min | Hands-on lab on the day's topic |
| 15 min | Verify with reboot/rollout, write a one-line cheat sheet |

---

## Stop signals (when you're ready)

- [ ] You can do all 15 scenarios in [scenarios.md](./scenarios.md) without notes in under 2 hours
- [ ] You can configure HTPasswd identity provider end-to-end from memory
- [ ] You can write a Deployment + Service + Route + NetworkPolicy YAML stack from memory
- [ ] You can install an operator from raw YAML (no console)
- [ ] You can debug a stuck pod / PVC / route to root cause without help
- [ ] You've watched at least 80% of an EX280-focused video course (Sander van Vugt or RH364)
