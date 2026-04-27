# Azure Study Resources Guide

Consolidated Azure study resources referenced across the Microsoft Azure certifications in this repo. Use this as the central hub when preparing for any Azure certification.

---

## Official Microsoft Resources

### Documentation and learning paths
- **[📖 Microsoft Learn](https://learn.microsoft.com/training/)** - Free official learning paths and modules
- **[📖 Microsoft Learn Certifications](https://learn.microsoft.com/credentials/)** - Cert pages, study guides, exam prep
- **[📖 Azure Documentation](https://learn.microsoft.com/azure/)** - Authoritative service docs
- **[📖 Azure Architecture Center](https://learn.microsoft.com/azure/architecture/)** - Reference architectures and patterns
- **[📖 Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/)** - Migration / governance methodology
- **[📖 Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)** - Reliability, security, cost, ops, performance

### Blogs
- **[Azure Blog](https://azure.microsoft.com/blog/)** - Product launches and feature updates
- **[Azure Architecture Blog](https://techcommunity.microsoft.com/category/azure/blog/azurearchitectureblog)**
- **[Azure DevOps Blog](https://devblogs.microsoft.com/devops/)**
- **[Microsoft Security Blog](https://www.microsoft.com/security/blog/)**
- **[Azure SQL Blog](https://techcommunity.microsoft.com/category/azure/blog/azuresqlblog)**

### Video and event content
- **[Microsoft Build sessions](https://build.microsoft.com/)**
- **[Microsoft Ignite sessions](https://ignite.microsoft.com/)**
- **[Microsoft Mechanics on YouTube](https://www.youtube.com/c/MicrosoftMechanicsSeries)**
- **[Azure Friday on YouTube](https://www.youtube.com/playlist?list=PLLasX02E8BPCNCK8Thcxu-Y-XOkxQI8s9)**

---

## Hands-on Practice

### Free / low-cost lab environments
- **[Azure Free Account](https://azure.microsoft.com/free/)** - $200 credit for 30 days + always-free tier
- **[Microsoft Learn Sandbox](https://learn.microsoft.com/training/)** - Free hands-on environments embedded in learning modules (no credit card)
- **[Azure for Students](https://azure.microsoft.com/free/students/)** - $100 credit, no credit card

### Commercial lab platforms
- **A Cloud Guru / Pluralsight** - sandbox accounts, broad catalog
- **WhizLabs** - practice exams + labs
- **Cloud Academy** - hands-on labs and learning paths
- **MeasureUp** - the official Microsoft practice test partner

### Building your own
- Use **ARM templates**, **Bicep**, or **Terraform** to spin up + tear down lab environments
- Set [Cost alerts](https://learn.microsoft.com/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) before you start

---

## Practice Exams

| Provider | Strength | Cost |
|---|---|---|
| **MeasureUp Official Practice Test** | Microsoft's official partner; closest to the real exam | $90-130 |
| **Whizlabs** | Volume of questions, cheap | $10-20 per cert |
| **Tutorials Dojo / Jon Bonso** | Quality explanations (he covers Azure too now) | $15-30 |
| **Scott Duffy / Tim Warner (Udemy)** | Often bundled with video courses | varies |
| **ExamTopics** | Free but quality varies; treat as supplementary | free |

Aim for **80%+ on the same practice exam twice in a row** before scheduling.

---

## Video Courses

- **Scott Duffy** (Udemy) - popular for AZ-104, AZ-204, AZ-305, AZ-500
- **Tim Warner** (Pluralsight, his own site) - deep AZ-104, AZ-305 content
- **John Savill** ([YouTube](https://www.youtube.com/@NTFAQGuy)) - **free**, exam-aligned cram videos for almost every Azure cert
- **A Cloud Guru / Pluralsight** - broad catalog
- **Microsoft Learn** - free official courses

**John Savill's exam-prep playlists are widely considered the best free resource** for AZ-104, AZ-204, AZ-305, AZ-500, AI-102, DP-203, etc.

---

## Communities

- **[r/AZURE](https://reddit.com/r/AZURE)** - active study + general discussion
- **[r/AzureCertification](https://reddit.com/r/AzureCertification)** - cert-focused
- **[Microsoft Q&A](https://learn.microsoft.com/answers/)** - official Q&A platform
- **[Microsoft Tech Community](https://techcommunity.microsoft.com/)** - blog + forums
- **John Savill Discord** (linked from his YouTube channel)

---

## Cost-Optimization for Lab Use

- Activate the **$200 free credit** at start of prep; budget so it lasts the full 30 days.
- Tag every resource with `cert:<exam-code>`.
- Use [Cost alerts](https://learn.microsoft.com/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) at $25 / $50 / $100.
- Tear down resources after every lab session (RGs make this easy: delete the RG).
- Prefer **Spot VMs** for compute-heavy labs.
- Use **B-series burstable VMs** for cheap always-on labs.
- See [Azure Cost Optimization Guide](../resources/cost-optimization/azure-cost-optimization.md).

---

## Repo Cross-References

- **[Azure CLI Cheat Sheet](../resources/cli-cheat-sheet-azure.md)**
- **[Azure Well-Architected Notes](../resources/well-architected/azure-well-architected.md)**
- **[Azure Cost Optimization](../resources/cost-optimization/azure-cost-optimization.md)**
- **[Azure Troubleshooting](../resources/troubleshooting/azure-troubleshooting.md)**
- **[On-Prem to Azure Migration](../resources/migration-guides/on-prem-to-azure.md)**
- **[Service Comparisons (cross-cloud)](../resources/)**
- **[Practice Resources (cross-vendor)](../resources/practice-resources.md)**

---

> Last reviewed: 2026-04. Microsoft Learn URLs are stable; if a link breaks, search for the title text in [learn.microsoft.com](https://learn.microsoft.com/).
