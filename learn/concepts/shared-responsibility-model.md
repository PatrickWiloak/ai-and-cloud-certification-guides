# Shared Responsibility Model

> **4-minute read.**

## The one-line answer

The cloud provider secures the cloud itself (hardware, hypervisor, datacenter physical security). You secure what you put in it (your code, your data, who can access it, how it's configured).

## Why this exists

In the on-prem era, security was simple in concept: it's all yours. You owned the racks, the cables, the badge readers, the firewall, the OS, the app. Whatever broke, it was your fault.

Cloud splits the stack. The provider runs hardware you'll never see. You run code on top. So the question becomes: when there's a breach, who was responsible?

Cloud providers published the **shared responsibility model** to make this explicit. It's a contract that says: here's where our job ends and yours begins.

## The basic split

| Layer | Who's responsible? |
|-------|-------------------|
| Physical datacenters | Provider |
| Hardware, hypervisor | Provider |
| Network fabric inside the cloud | Provider |
| Operating system | Depends on service (see below) |
| Runtime, libraries | You (mostly) |
| **Your code** | **You** |
| **Your data** | **You** |
| **Identity & access (who can do what)** | **You** |
| **Configuration of cloud services** | **You** |

The most important line: **identity and access management is always your job.** No cloud provider can tell whether the request to delete your S3 bucket came from you or from a leaked AWS key.

## How the line shifts by service

The further "up the stack" you go (IaaS → PaaS → SaaS), the more the provider does:

### IaaS (e.g., EC2 VM)
- Provider: hardware, hypervisor
- You: OS patches, runtime, app, data, IAM, network rules

### PaaS (e.g., AWS Lambda, App Service)
- Provider: hardware, OS, runtime
- You: your function code, dependencies, data, IAM

### SaaS / managed (e.g., S3, RDS, DynamoDB)
- Provider: hardware, OS, software, patches
- You: your data, who can access it, how you configure it

This is why "I just put it in S3, AWS handles security" is wrong. AWS handles S3 itself. You handle whether your bucket is public, who has access, and what's in it.

## The 90% of cloud breaches

Most cloud breaches you hear about aren't AWS/Azure/GCP being hacked. They're customer mistakes:

- **Public S3 buckets** with sensitive data
- **Leaked API keys** in public GitHub repos
- **Over-permissive IAM roles** exploited after a phishing attack
- **Unpatched VMs** running outdated software
- **Open security group** rules (`0.0.0.0/0` on port 22 or 3389)
- **Default passwords** on managed databases

All of these are "your side of the line." The provider is fine.

## A small concrete example

You launch an EC2 VM running a web app. There's a vuln in your version of OpenSSL. Attacker exploits it, exfiltrates data.

Whose problem?

- **The hypervisor was patched** - AWS's job, done.
- **The hardware wasn't tampered with** - AWS's job, done.
- **The OS / OpenSSL on the VM wasn't patched** - your job. ← failure here.
- **The IAM role attached to the VM had wide S3 read access** - your job. ← failure compounded here.

This is a customer-side breach in AWS's framing, even though "OpenSSL" was the vulnerable piece. You owned the OS-level patching.

## How to think about it day to day

When you adopt a new cloud service, ask:

1. **What does the provider handle?** (Read their shared responsibility doc.)
2. **What's now my responsibility?** Especially: data, IAM, configuration.
3. **What's the default state?** (Some services default to "open" which is bad.)
4. **What's the secure configuration?** (Read their best-practices doc.)

For each new service, the answers shift slightly. Get used to checking.

## Provider-specific docs

- **AWS**: [shared responsibility model](https://aws.amazon.com/compliance/shared-responsibility-model/)
- **Azure**: [shared responsibility in the cloud](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)
- **GCP**: [shared responsibilities](https://cloud.google.com/architecture/framework/security/shared-responsibility-shared-fate)

All three say roughly the same thing. The diagrams differ.

## What to look at next

- **[Glossary: Shared responsibility model, IAM, Security group](../glossary.md#security--identity)**
- **[IaaS vs PaaS vs SaaS](./iaas-paas-saas.md)** - the line shifts at each layer
- **[Compliance guides](../../resources/compliance-guides/)** - SOC 2, HIPAA, PCI all build on shared responsibility
