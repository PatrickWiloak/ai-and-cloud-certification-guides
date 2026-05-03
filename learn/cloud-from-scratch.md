# ☁️ Cloud From Scratch

> **A non-cert learning path for understanding cloud computing.**
>
> Eight phases. No exam scaffolding. Each phase ends with "you should now be able to..."

---

## Who this is for

- You're new to cloud, or have spotty knowledge from blog posts
- You don't have an exam date - you want fundamentals you can reason from
- You'd rather build mental models than memorize service names

If you want certifications instead, head back to the **[Study Hub](../STUDY-HUB.md)**.

---

## How to work through it

Each phase has:
- **What you'll learn** - the concepts in plain English
- **Why it matters** - where this shows up in real systems
- **Try it** - a small hands-on suggestion
- **Pointer** - where in this repo to go deeper

Don't try to "complete" each phase. Read, build a small thing, move on. You'll loop back as you build real systems.

---

## Phase 1 - What is cloud, actually?

**What you'll learn**
- The shift from owning datacenters to renting compute by the minute.
- The three service models: IaaS, PaaS, SaaS - and why "serverless" complicated the picture.
- Public cloud vs private cloud vs hybrid vs multi-cloud.
- What a region is, what an availability zone is, why you care.
- The shared responsibility model: where AWS/Azure/GCP's job ends and yours begins.

**Why it matters**
Every "best practice" you'll read assumes this vocabulary. Without it, decisions like "should this go in S3 or EBS?" sound like nonsense.

**Try it**
Sign up for AWS, Azure, or GCP free tier. Spin up a single VM. SSH in. Stop it. Start it. Delete it. Total time: 30 minutes. You'll learn more from this than 10 blog posts.

**Pointer**
- [Free Tier Guide](../resources/free-tier-guide.md)
- Glossary entries: IaaS, PaaS, SaaS, Region, AZ, Shared responsibility model

You should now be able to explain what "the cloud" actually is to a non-technical friend.

---

## Phase 2 - The basic primitives

**What you'll learn**
- **Compute**: VMs, containers, serverless. When to use which.
- **Storage**: object (S3), block (EBS), file (EFS). What problem each solves.
- **Network**: VPC, subnet, IP range, route, gateway. The Lego pieces.
- **Database**: managed vs self-hosted. Why nobody runs their own MySQL anymore.

**Why it matters**
Every cloud system you'll ever build is a combination of these four primitive categories. Get fluent here and the rest is variations.

**Try it**
Build a "static website" by uploading an `index.html` to S3 and enabling website hosting. Cost: roughly $0.

**Pointer**
- [Service Comparison: Compute](../resources/service-comparison-compute.md)
- [Service Comparison: Storage](../resources/service-comparison-storage.md)
- [Service Comparison: Networking](../resources/service-comparison-networking.md)
- [Service Comparison: Databases](../resources/service-comparison-databases.md)

You should now be able to read an architecture diagram and identify the compute, storage, network, and database pieces.

---

## Phase 3 - Networking like you mean it

**What you'll learn**
- IP addresses, CIDR notation, subnets - what `10.0.0.0/16` actually means.
- Public vs private subnets. Why your database should never be public.
- Security groups vs NACLs. Stateful vs stateless firewalls.
- DNS basics: A records, CNAMEs, TTLs. Route 53 / Cloud DNS / Azure DNS.
- Load balancers: Layer 4 (TCP) vs Layer 7 (HTTP). When you'd want each.
- TLS/HTTPS - certificates, why "Let's Encrypt" exists, what a cert authority does.

**Why it matters**
Networking is the most common source of "why doesn't this work?" pain. The error is almost always a security group, a route, or DNS.

**Try it**
Build a VPC with two subnets (public + private). Put a VM in each. Make sure the private one can reach the internet via a NAT gateway. You'll touch every concept above.

**Pointer**
- [Networking Deep Dives](../resources/networking-deep-dives/)
- Glossary entries: VPC, CIDR, Subnet, Security group, DNS, Load balancer, TLS

You should now be comfortable reading and writing network diagrams.

---

## Phase 4 - Identity and access

**What you'll learn**
- Authentication vs authorization (proving you are vs what you can do).
- IAM users, groups, roles, policies. Why roles are usually better than users.
- Least privilege - and why nobody actually does it from day 1.
- Service accounts vs human identity.
- Secrets management - never put credentials in code, ever.
- MFA, SSO, OIDC, SAML - how modern logins actually work.

**Why it matters**
Cloud security incidents almost always trace back to identity: a leaked key, an over-privileged role, a public S3 bucket.

**Try it**
Create an IAM role that lets a Lambda function read from one specific S3 bucket and nothing else. Attach it. Test that it can't read other buckets. This is the muscle memory you want.

**Pointer**
- [AWS IAM CLI cheat sheet](../resources/cli-cheat-sheet-aws.md)
- Glossary: IAM, RBAC, Service account, OIDC, SSO, MFA, Secret

You should now be able to explain why "let's just use root credentials" is a hangable offense.

---

## Phase 5 - DevOps, IaC, and CI/CD

**What you'll learn**
- Why you don't click in consoles in production.
- Infrastructure as Code: Terraform, CloudFormation, Bicep, Pulumi.
- The plan/apply loop. Why state matters. Why state in S3 with locking matters even more.
- Git, branches, pull requests. The actual workflow developers use.
- CI: every commit triggers tests. CD: passing tests roll out automatically.
- Immutable deployments, blue/green, canaries. What "rolling deploys" actually do.

**Why it matters**
Without IaC you can't reproduce environments, can't review changes, can't roll back. Without CI/CD you're shipping by hope.

**Try it**
Write a Terraform file that creates one S3 bucket. Run `terraform plan`, then `terraform apply`. Edit the bucket name. Plan again. Watch Terraform decide what to do. You're now operating like a real engineer.

**Pointer**
- [Terraform CLI cheat sheet](../resources/cli-cheat-sheet-terraform.md)
- [DevOps & CI/CD comparison](../resources/service-comparison-devops-cicd.md)
- Glossary: IaC, CI, CD, Pipeline, Drift, Blue/green

You should now be able to deploy a small thing repeatedly without touching a console.

---

## Phase 6 - Containers and Kubernetes (just enough)

**What you'll learn**
- What a container actually is (a process + a filesystem snapshot, not a tiny VM).
- Docker basics: image, container, Dockerfile, registry.
- Why you'd want orchestration at all.
- Kubernetes core objects: pod, deployment, service, ingress.
- When **not** to use Kubernetes (most apps don't need it; serverless is often better).

**Why it matters**
Containers are how most modern code ships. Kubernetes is the default orchestrator if you outgrow simpler options.

**Try it**
Containerize a Hello World web app. Run it locally with `docker run`. Push to ECR / GCR / Docker Hub. Deploy it to Cloud Run, App Runner, or App Service - serverless container hosting before you touch Kubernetes.

**Pointer**
- [Docker CLI cheat sheet](../resources/cli-cheat-sheet-docker.md)
- [kubectl cheat sheet](../resources/cli-cheat-sheet-kubectl.md)
- [Helm cheat sheet](../resources/cli-cheat-sheet-helm.md)
- [Containers comparison](../resources/service-comparison-containers-kubernetes.md)
- Glossary: Container, Docker, Kubernetes, Pod, Deployment, Service

You should now be able to make a "should we use Kubernetes for this?" call and probably say no.

---

## Phase 7 - Reliability, observability, and cost

**What you'll learn**
- Logs, metrics, traces - the three signals.
- Health checks, readiness vs liveness.
- SLOs and error budgets - how mature teams talk about reliability.
- Alerting that doesn't burn out the team.
- Tagging, budgets, and cost alarms.
- The biggest sources of surprise cloud bills (data transfer, NAT gateway, idle resources).

**Why it matters**
Operations is the long tail. Building a thing that runs once is easy. Building a thing that runs at 3am while you're asleep is the actual job.

**Try it**
Add CloudWatch / Cloud Monitoring / Azure Monitor alarms to the VM you built in Phase 3. Trigger one intentionally (CPU stress). Get the email/SMS. Now you know how the loop works.

**Pointer**
- [Observability comparison](../resources/service-comparison-observability-monitoring.md)
- [Cost Optimization (AWS)](../resources/cost-optimization/aws-cost-optimization.md)
- [Cost Optimization (Azure)](../resources/cost-optimization/azure-cost-optimization.md)
- [Cost Optimization (GCP)](../resources/cost-optimization/gcp-cost-optimization.md)
- Glossary: SLO, Trace, Span, OpenTelemetry, Alert

You should now know what you'd actually monitor for a real production system.

---

## Phase 8 - Putting it together

**What you'll learn**
- Architecture patterns: 3-tier web, serverless API, event-driven, data pipeline.
- The Well-Architected Frameworks (AWS, Azure, GCP) - five-ish pillars across all of them.
- Disaster recovery: RTO, RPO, the four DR strategies.
- Compliance basics: SOC 2, HIPAA, PCI, GDPR. What they require, when they apply.
- Migration: lift and shift vs replatform vs refactor.

**Why it matters**
Now you can read other people's architecture and understand the trade-offs. Eventually, you make those calls yourself.

**Try it**
Pick one [hands-on project](../resources/hands-on-projects/) and build it end to end. Suggested first one: [Deploy a 3-Tier App](../resources/hands-on-projects/deploy-3-tier-app.md).

**Pointer**
- [Architecture Patterns](../resources/architecture-patterns/)
- [AWS Well-Architected](../resources/well-architected/aws-well-architected.md)
- [Azure Well-Architected](../resources/well-architected/azure-well-architected.md)
- [GCP Well-Architected](../resources/well-architected/gcp-well-architected.md)
- [Hands-On Projects](../resources/hands-on-projects/)

You should now be able to design a small production system and defend the choices.

---

## Where to go after this

- **Want a cert?** Head to the **[Study Hub](../STUDY-HUB.md)** and pick a path.
- **Want depth in one cloud?** Pick AWS, Azure, or GCP and follow its associate-level path - the certification material has the most depth.
- **Want depth in AI?** Try **[AI from Scratch](./ai-from-scratch.md)** next.
- **Want hands-on work?** Pick another [hands-on project](../resources/hands-on-projects/).

Good engineers cycle through "build a thing → read a book → build a thing → fix a bug at 3am → read another book." This is the cycle. The cloud is too big to ever finish learning.
