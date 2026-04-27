# GCP Study Resources Guide

Consolidated Google Cloud study resources referenced across the GCP certifications in this repo. Use this as the central hub when preparing for any GCP certification.

---

## Official Google Resources

### Documentation and learning paths
- **[📖 Google Cloud Documentation](https://cloud.google.com/docs)** - Authoritative service documentation
- **[📖 Google Cloud Skills Boost](https://www.cloudskillsboost.google/)** - Free + paid official labs and learning paths
- **[📖 Google Cloud Certification Page](https://cloud.google.com/learn/certification)** - Cert paths, exam guides, registration
- **[📖 Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework)** - Reliability, security, cost, ops, performance, sustainability
- **[📖 Cloud Architecture Center](https://cloud.google.com/architecture)** - Reference architectures, blueprints, solution guides
- **[📖 Solution Library](https://cloud.google.com/solutions)** - Industry and use-case solutions

### Blogs
- **[Google Cloud Blog](https://cloud.google.com/blog)** - Product launches and feature updates
- **[Google Cloud Tech Blog (Medium)](https://medium.com/google-cloud)** - Engineering write-ups
- **[Inside Machine Learning](https://cloud.google.com/blog/products/ai-machine-learning)** - ML/AI specifically
- **[Data Analytics Blog](https://cloud.google.com/blog/products/data-analytics)**
- **[Identity & Security](https://cloud.google.com/blog/products/identity-security)**

### Video and event content
- **[Google Cloud Next sessions](https://cloud.withgoogle.com/next/)** - annual conference
- **[Google Cloud on YouTube](https://www.youtube.com/@googlecloud)** - product demos and tech talks
- **[Cloud Study Jams on YouTube](https://www.youtube.com/playlist?list=PLIivdWyY5sqJ1YuMdGjRwMmEd1hrOoeG6)**

---

## Hands-on Practice

### Free / low-cost lab environments
- **[Google Cloud Free Tier](https://cloud.google.com/free)** - $300 credit for 90 days + always-free tier
- **[Cloud Skills Boost](https://www.cloudskillsboost.google/)** - Hands-on Qwiklabs (subscription gives unlimited lab time)
- **[Cloud Skills Boost Innovators Plus](https://cloud.google.com/innovators)** - Free tier for Google Innovators
- **[Google Cloud Sandbox](https://cloud.google.com/blog/topics/training-certifications/level-up-with-google-cloud-skills-boost-sandbox)** - Sandbox projects for paid Skills Boost users

### Commercial lab platforms
- **A Cloud Guru / Pluralsight** - sandbox accounts, broad GCP catalog
- **Whizlabs** - practice exams + labs
- **KodeKloud** - DevOps-focused labs

### Building your own
- Use **Terraform** ([google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)) or **Deployment Manager** to spin up + tear down lab environments
- Use a **dedicated GCP project per cert prep** to keep costs and resources isolated
- Set [Budget alerts](https://cloud.google.com/billing/docs/how-to/budgets) before you start

---

## Practice Exams

| Provider | Strength | Cost |
|---|---|---|
| **Google Cloud Skills Boost Practice Exam** | Official; closest to real exam style | included with subscription or one-off |
| **Whizlabs** | Volume of questions; cheap | $10-20 per cert |
| **Tutorials Dojo (Jon Bonso)** | High-quality explanations (he covers GCP) | $15-30 |
| **Dan Sullivan / A Cloud Guru** | Bundled with Pluralsight courses | varies |
| **ExamTopics** | Free; quality varies; treat as supplementary | free |

Aim for **80%+ on the same practice exam twice in a row** before scheduling.

---

## Video Courses

- **Dan Sullivan** (Pluralsight + his own books) - the most-recommended PCA, PDE, Cloud Engineer prep
- **Linux Academy / A Cloud Guru** - broad GCP catalog; check freshness as services evolve fast
- **Coursera Google Cloud specializations** - official multi-week courses; thorough but slower
- **Stephane Maarek** (Udemy) - some GCP content (more limited than his AWS catalog)

---

## Communities

- **[r/googlecloud](https://reddit.com/r/googlecloud)** - active discussion + cert reports
- **[r/GoogleCloudCertified](https://reddit.com/r/GoogleCloudCertified)** - cert-focused
- **[Google Cloud Community](https://www.googlecloudcommunity.com/)** - official forums
- **[GCP Slack (cloudcommunity)](https://googlecloud-community.slack.com/)** - real-time discussion

---

## Cost-Optimization for Lab Use

- Activate the **$300 / 90-day free credit** when you commit to studying.
- One project per cert prep; use IAM to make sure you only have access to that project.
- Set **Budget alerts** at $25 / $50 / $100 thresholds.
- Tear down resources after every lab session - delete the project to nuke everything cleanly.
- Prefer **preemptible / Spot VMs** for compute-heavy labs.
- Use **e2-micro** instances for cheap always-on labs (free tier eligible).
- See [GCP Cost Optimization Guide](../resources/cost-optimization/gcp-cost-optimization.md).

---

## Repo Cross-References

- **[GCP CLI Cheat Sheet](../resources/cli-cheat-sheet-gcp.md)**
- **[GCP Well-Architected Notes](../resources/well-architected/gcp-well-architected.md)**
- **[GCP Cost Optimization](../resources/cost-optimization/gcp-cost-optimization.md)**
- **[GCP Troubleshooting](../resources/troubleshooting/gcp-troubleshooting.md)**
- **[On-Prem to GCP Migration](../resources/migration-guides/on-prem-to-gcp.md)**
- **[Service Comparisons (cross-cloud)](../resources/)**
- **[Practice Resources (cross-vendor)](../resources/practice-resources.md)**

---

> Last reviewed: 2026-04. GCP renames products occasionally (e.g., Vertex AI consolidated AutoML / AI Platform); if a service name in this guide looks dated, check the [GCP product page](https://cloud.google.com/products) for the current name.
