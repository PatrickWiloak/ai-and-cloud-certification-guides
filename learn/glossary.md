# 📖 Cloud + AI Glossary

> **200+ terms across cloud, AI/ML, DevOps, networking, and security - in plain English.**
>
> Use Ctrl+F. This is a reference doc, not something to read end-to-end.

Categories:
- [Cloud Fundamentals](#cloud-fundamentals)
- [AWS](#aws)
- [Microsoft Azure](#microsoft-azure)
- [Google Cloud (GCP)](#google-cloud-gcp)
- [Networking](#networking)
- [Security & Identity](#security--identity)
- [DevOps & Infrastructure as Code](#devops--infrastructure-as-code)
- [Containers & Kubernetes](#containers--kubernetes)
- [Data & Databases](#data--databases)
- [AI / Machine Learning](#ai--machine-learning)
- [LLMs & Generative AI](#llms--generative-ai)
- [Observability](#observability)

---

## Cloud Fundamentals

**Availability Zone (AZ)** - A physically separate datacenter (or cluster) inside a cloud region. AZs in the same region are connected by low-latency links. You spread workloads across AZs to survive a single datacenter failure.

**Bare metal** - A physical server you rent, no hypervisor, no virtualization layer. Used when you need maximum performance or specific hardware.

**Cloud computing** - On-demand delivery of compute, storage, networking, and software over the internet, billed by usage instead of owned outright.

**Cold storage** - Cheap, slow storage for data you rarely access (archives, backups, compliance retention). Examples: S3 Glacier, Azure Archive Blob, GCS Coldline.

**Compute** - Anything that runs code: VMs, containers, serverless functions, batch jobs.

**Edge / Edge computing** - Compute that runs close to the user (CDN points of presence, local devices) instead of in a central region. Lower latency for end users.

**Elasticity** - The ability to automatically scale resources up and down based on demand. Distinguished from "scalability" (which just means "can grow").

**Hybrid cloud** - Mixing on-premises infrastructure with public cloud, with networking and identity that span both.

**Hypervisor** - The software layer that runs VMs on physical hardware. Examples: KVM, Xen, Hyper-V, VMware ESXi.

**IaaS (Infrastructure as a Service)** - You rent raw VMs, networks, and storage. You manage the OS and everything above it. Examples: EC2, Azure VMs, GCE.

**Multi-cloud** - Using two or more public clouds (AWS + GCP, Azure + AWS, etc.) for workloads. Different from hybrid (which mixes on-prem and cloud).

**Multi-tenant** - A single instance of software/infrastructure serves many customers, with isolation between them. Most SaaS is multi-tenant.

**On-premises (on-prem)** - Infrastructure you own and run in your own datacenter (or office closet).

**PaaS (Platform as a Service)** - Provider manages OS, runtime, scaling. You deploy code. Examples: Heroku, Elastic Beanstalk, App Engine, Render.

**Private cloud** - Cloud-style infrastructure dedicated to a single organization, often on-prem or in a colo.

**Public cloud** - Multi-tenant cloud run by a hyperscaler (AWS, Azure, GCP, Oracle, IBM).

**Region** - A geographic area (e.g., us-east-1, eu-west-2) containing multiple AZs. Latency between regions is high; you typically deploy per region.

**Reserved Instance / Reservation / Committed Use Discount** - Pre-pay or commit to using a resource for 1-3 years in exchange for a big discount.

**SaaS (Software as a Service)** - You use software over the internet; provider runs everything. Examples: Gmail, Salesforce, Slack, Notion.

**Serverless** - You write code; the platform runs it on demand and bills per execution. No servers for you to manage. Examples: Lambda, Cloud Functions, Cloud Run, Azure Functions.

**Shared responsibility model** - The cloud provider secures the cloud; you secure what you put **in** the cloud. Where the line is depends on the service (more services managed = less for you).

**Spot / Preemptible Instance** - A cheap VM the provider can reclaim with little notice. Good for fault-tolerant batch work, bad for stateful production.

**Tenancy** - Whether your resources share hardware with others (shared tenancy) or run on dedicated hardware (dedicated tenancy).

**Virtual machine (VM)** - A simulated computer running on shared physical hardware via a hypervisor.

**Workload** - Any application, service, or batch job running in the cloud. Cloud architects love this word.

---

## AWS

**ALB (Application Load Balancer)** - Layer 7 (HTTP/HTTPS) load balancer. Routes by path, host, headers.

**AMI (Amazon Machine Image)** - A snapshot/template of a VM disk used to launch EC2 instances.

**Athena** - Serverless SQL queries over data in S3.

**AWS** - Amazon Web Services. The largest public cloud.

**CloudFormation** - AWS's native infrastructure-as-code tool. JSON or YAML templates.

**CloudFront** - AWS's content delivery network (CDN).

**CloudTrail** - Logs every API call made in your AWS account. Audit trail.

**CloudWatch** - Metrics, logs, and alarms.

**DynamoDB** - Managed key-value / document NoSQL database. Single-digit-millisecond reads at any scale.

**EBS (Elastic Block Store)** - Block storage volumes attached to EC2 instances. Like a virtual hard drive.

**EC2 (Elastic Compute Cloud)** - AWS's VM service.

**ECS (Elastic Container Service)** - AWS's container orchestrator. Simpler than EKS; AWS-flavored.

**EKS (Elastic Kubernetes Service)** - Managed Kubernetes on AWS.

**ElastiCache** - Managed Redis or Memcached.

**Fargate** - Serverless compute for containers. Run ECS or EKS pods without managing nodes.

**IAM (Identity and Access Management)** - AWS's permissions system. Users, roles, policies.

**Kinesis** - Streaming data service. Kinesis Data Streams = Kafka-like; Firehose = ingest to S3/Redshift; Analytics = SQL on streams.

**Lambda** - AWS's serverless function service.

**NLB (Network Load Balancer)** - Layer 4 (TCP/UDP) load balancer. Faster, fewer features than ALB.

**RDS (Relational Database Service)** - Managed Postgres, MySQL, MariaDB, SQL Server, Oracle.

**Route 53** - AWS's DNS service.

**S3 (Simple Storage Service)** - Object storage. The most fundamental AWS service.

**SNS (Simple Notification Service)** - Pub/sub messaging.

**SQS (Simple Queue Service)** - Message queue.

**VPC (Virtual Private Cloud)** - Your own isolated network in AWS.

---

## Microsoft Azure

**AKS (Azure Kubernetes Service)** - Managed Kubernetes on Azure.

**App Service** - PaaS for web apps and APIs. Easier than Kubernetes; less flexible.

**ARM (Azure Resource Manager)** - The deployment and management layer for Azure. Templates are like CloudFormation.

**Azure** - Microsoft's public cloud.

**Azure AD / Entra ID** - Microsoft's cloud identity provider. Used for SSO, B2B, B2C, conditional access.

**Azure DevOps** - CI/CD, repos, boards, artifacts. The Azure-flavored GitHub.

**Azure Functions** - Serverless functions on Azure.

**Bicep** - A friendlier DSL that compiles to ARM templates.

**Blob Storage** - Azure's object storage (equivalent to S3).

**Cosmos DB** - Globally-distributed multi-model database. NoSQL, document, graph, key-value, all in one.

**Event Grid / Event Hubs / Service Bus** - Azure's three messaging services. Event Grid = events, Event Hubs = high-throughput streaming, Service Bus = enterprise queues.

**Resource Group** - A logical container for related Azure resources. Permissions and lifecycle apply to the group.

**Subscription** - A billing/permission boundary in Azure. You usually have several (dev, prod, etc.) under a tenant.

**Synapse Analytics** - Azure's data warehouse + analytics platform.

**Tenant** - The top-level identity boundary in Microsoft 365 / Azure (one per organization).

**Virtual Network (VNet)** - Azure's equivalent of a VPC.

---

## Google Cloud (GCP)

**BigQuery** - GCP's serverless data warehouse. Pay per query and storage.

**Cloud Functions** - GCP's FaaS (function-as-a-service).

**Cloud Run** - Run containers serverlessly on GCP. Scales to zero.

**Cloud SQL** - Managed Postgres, MySQL, SQL Server.

**Cloud Storage (GCS)** - GCP's object storage (equivalent to S3 / Blob).

**Dataflow** - Managed Apache Beam (stream + batch processing).

**Firestore** - Serverless NoSQL document DB. Real-time client SDKs.

**GCE (Google Compute Engine)** - GCP's VM service.

**GCP** - Google Cloud Platform.

**GKE (Google Kubernetes Engine)** - Managed Kubernetes on GCP. The original; Google invented Kubernetes.

**IAM (GCP)** - Same name as AWS, different model. Roles attach to identities and apply to resources.

**Pub/Sub** - GCP's globally-distributed pub/sub messaging.

**Spanner** - Globally-consistent relational database. Distributed but ACID.

**VPC (GCP)** - GCP's virtual network. Notably, GCP VPCs are global (not regional like AWS).

**Vertex AI** - GCP's unified ML platform. Training, deployment, AutoML, foundation models.

---

## Networking

**API Gateway** - A managed front door for APIs. Handles auth, rate limiting, routing, transforms.

**ASN (Autonomous System Number)** - The unique ID for a network on the internet (used in BGP).

**BGP (Border Gateway Protocol)** - The protocol the internet uses to route between networks.

**CDN (Content Delivery Network)** - Edge cache for static (and sometimes dynamic) content. CloudFront, Cloud CDN, Azure CDN, Cloudflare, Fastly.

**CIDR (Classless Inter-Domain Routing)** - The notation for IP ranges (e.g., `10.0.0.0/16`). The number after the slash is how many bits are fixed.

**DNS (Domain Name System)** - Translates names (`example.com`) to IPs (`93.184.216.34`).

**Egress** - Traffic leaving your network/cloud. Often the part that costs money.

**Firewall** - Filters traffic by rules. Cloud-native versions are usually called security groups, NACLs, or firewall policies.

**HTTP/HTTPS** - The protocols the web runs on. HTTPS = HTTP over TLS.

**Ingress** - Traffic coming into your network. In Kubernetes, also a resource type that exposes services to the internet.

**Latency** - The time it takes a request to round-trip. Measured in milliseconds.

**Load balancer** - Distributes incoming traffic across many backend servers.

**NAT (Network Address Translation)** - Lets private IPs reach the internet by sharing a public IP.

**OSI model** - 7-layer abstraction for networking. Layer 4 = TCP/UDP, Layer 7 = HTTP. Not literally how things work, but useful vocabulary.

**Peering** - A direct network connection between two networks (VPCs, datacenters, ISPs).

**Private link / Private endpoint** - A way to access a managed service over a private IP without traversing the public internet.

**Public IP** - An IP routable on the internet. Public IPs are scarce (IPv4) and often cost money.

**Reverse proxy** - A server that takes inbound requests and forwards them to backend services. Nginx, HAProxy, Envoy.

**Route table** - Defines where packets go based on destination IP. Each subnet has one.

**Security group** - A stateful firewall attached to a VM/pod/service. Rules are usually allow-only.

**Subnet** - A subdivision of a VPC into a smaller IP range, typically scoped to one AZ.

**TCP/UDP** - Transport protocols. TCP = reliable, ordered, connection-based. UDP = best-effort, fast, no connection.

**TLS (Transport Layer Security)** - The encryption protocol that powers HTTPS. SSL is the deprecated predecessor.

**VPN (Virtual Private Network)** - Encrypted tunnel between networks (or a user and a network).

**VPC peering** - Connect two VPCs so they can route to each other. Non-transitive.

---

## Security & Identity

**Access key** - A pair of credentials (key ID + secret) that authenticates programmatic access. Treat like a password.

**ACL (Access Control List)** - A list of rules saying who can do what to a resource.

**API key** - A long token used to authenticate API calls. Less powerful than a credential pair; widely used for SaaS.

**Audit log** - A record of who did what, when. Required for most compliance frameworks.

**Authentication (AuthN)** - Proving who you are. (Username/password, MFA, SSO.)

**Authorization (AuthZ)** - What you're allowed to do once authenticated. (RBAC, ABAC, policies.)

**Bearer token** - Anyone who holds it can use it. JWTs are typically bearer tokens.

**Certificate** - A signed public key that proves identity. Used by TLS.

**CIA triad** - Confidentiality, Integrity, Availability. The three goals of infosec.

**CSPM (Cloud Security Posture Management)** - Tools that scan your cloud for misconfigurations. Wiz, Prisma, AWS Security Hub.

**Encryption at rest** - Data on disk is encrypted. Decryption happens on read.

**Encryption in transit** - Data over the network is encrypted (typically TLS).

**IAM (Identity and Access Management)** - Generic term for controlling who can do what. Each cloud has its own IAM service.

**JWT (JSON Web Token)** - A signed JSON blob carrying claims (user ID, expiry, etc.). Common in API auth.

**KMS (Key Management Service)** - Cloud service for managing encryption keys. AWS KMS, Azure Key Vault, GCP KMS.

**Least privilege** - Give an identity only the permissions it needs, no more.

**MFA (Multi-Factor Authentication)** - Requires more than just a password (e.g., TOTP, hardware key, SMS).

**OAuth 2.0** - The protocol that powers "Sign in with Google." Authorization framework.

**OIDC (OpenID Connect)** - Authentication layer on top of OAuth 2.0. Adds identity tokens.

**Penetration test (pentest)** - Authorized hacking. Hire someone to break in so you can fix it.

**RBAC (Role-Based Access Control)** - Permissions are grouped into roles; you assign roles to users.

**Secret** - Sensitive data (passwords, API keys, certificates) stored separately from code.

**Secrets manager** - A service for storing and rotating secrets. AWS Secrets Manager, HashiCorp Vault, Azure Key Vault, GCP Secret Manager.

**Service account** - An identity that belongs to a service or app, not a human.

**SIEM (Security Information and Event Management)** - Aggregates logs and alerts on suspicious patterns. Splunk, Sentinel, Elastic SIEM.

**SSO (Single Sign-On)** - Log in once, access many apps. Usually SAML or OIDC.

**WAF (Web Application Firewall)** - Filters HTTP requests for attacks (SQL injection, XSS, etc.).

**Zero Trust** - Don't trust the network perimeter. Verify every request, regardless of source.

---

## DevOps & Infrastructure as Code

**Ansible** - Agentless configuration management tool. YAML playbooks, runs over SSH.

**Artifact** - The output of a build (a JAR, a Docker image, a binary). Stored in an artifact registry.

**Blue/green deployment** - Two production environments (blue = current, green = new). Switch traffic once green is verified.

**Canary deployment** - Roll out a new version to a small percentage of users, watch metrics, expand if good.

**CD (Continuous Deployment)** - Every commit that passes tests goes to production. Automated end-to-end.

**CI (Continuous Integration)** - Every commit triggers a build and test run. Catches regressions fast.

**CICD pipeline** - Automated workflow that builds, tests, and deploys code. GitHub Actions, GitLab CI, Jenkins, CircleCI.

**Docker** - The most common container runtime / image format.

**Drift** - When live infrastructure no longer matches what's in code. Bad. IaC tools detect it.

**GitOps** - Git is the source of truth for infrastructure. Tools like ArgoCD or Flux sync the cluster to git.

**IaC (Infrastructure as Code)** - Define infrastructure in text files, version it, deploy it. Terraform, CloudFormation, Bicep, Pulumi.

**Idempotent** - Running the operation multiple times produces the same result. IaC tools rely on this.

**Immutable infrastructure** - Servers are never modified after deploy. To "update," you replace.

**Pulumi** - IaC using real programming languages (TypeScript, Python, Go).

**Rolling deployment** - Replace instances gradually rather than all at once.

**SRE (Site Reliability Engineering)** - Google-coined discipline for running production. SLOs, error budgets, postmortems.

**Terraform** - The dominant IaC tool. HCL syntax, multi-cloud, state-driven.

**Terragrunt** - A wrapper around Terraform for managing many environments / modules.

---

## Containers & Kubernetes

**Container** - A packaged app + dependencies that runs in an isolated process. Lighter than a VM, heavier than a function.

**Container registry** - Where Docker images live. Docker Hub, ECR, GCR/Artifact Registry, ACR.

**ConfigMap** - A Kubernetes object holding non-secret config. Mount as files or env vars.

**CRD (Custom Resource Definition)** - Lets you extend Kubernetes with your own resource types.

**Deployment** - Kubernetes resource that manages replica sets and rolling updates.

**Helm** - The package manager for Kubernetes. Charts = templated manifests.

**Image** - A built container blueprint. You run an image, you get a container.

**Ingress** - A Kubernetes resource that exposes HTTP services to the outside world. Backed by an ingress controller (Nginx, Traefik, etc.).

**Kubernetes (K8s)** - Open-source container orchestrator. Schedules pods across nodes, restarts failures, handles networking and storage.

**Kustomize** - Built-in Kubernetes templating without Helm. Layer-based overlays.

**Manifest** - A YAML file describing a Kubernetes resource.

**Namespace** - A logical partition inside a cluster. Used for tenancy, RBAC, and resource quotas.

**Node** - A worker machine in a Kubernetes cluster. Runs pods.

**Operator** - A custom controller that automates managing a stateful app (databases, caches) on Kubernetes.

**Pod** - The smallest deployable unit in Kubernetes. One or more containers sharing network and storage.

**Replica** - One copy of a pod. Deployments manage replicas.

**Secret (Kubernetes)** - Like a ConfigMap but for sensitive data. Base64-encoded by default (not actually encrypted).

**Service (Kubernetes)** - A stable network endpoint that routes to pods. ClusterIP, NodePort, LoadBalancer.

**Service mesh** - Layer that adds traffic management, security, and observability to service-to-service calls. Istio, Linkerd, Consul.

**StatefulSet** - Like a Deployment but for stateful apps. Stable identities, persistent storage.

**Sidecar** - A second container in a pod that augments the main one (logging, proxy, etc.).

---

## Data & Databases

**ACID** - Atomicity, Consistency, Isolation, Durability. The promises of traditional relational databases.

**BASE** - Basically Available, Soft state, Eventual consistency. The relaxed promises of many NoSQL systems.

**Columnar storage** - Data on disk is organized by column, not row. Great for analytics. Used by data warehouses.

**Data lake** - A bunch of raw files in object storage. Schema-on-read.

**Data lakehouse** - Lake + warehouse hybrid. Open table formats (Delta, Iceberg, Hudi) on object storage with warehouse-like queries.

**Data warehouse** - Optimized for analytical queries over large datasets. BigQuery, Redshift, Snowflake, Synapse.

**Document DB** - Stores JSON-like documents. MongoDB, Firestore, DynamoDB (sort of).

**ETL / ELT** - Extract, Transform, Load (transform before loading) vs Extract, Load, Transform (load raw, transform inside the warehouse). ELT is increasingly common.

**Eventual consistency** - Reads might be stale right after a write but will eventually catch up.

**Graph DB** - Stores nodes and edges. Neo4j, Neptune, ArangoDB.

**Index** - A separate data structure that makes queries faster. Costs disk and write speed.

**Key-value store** - Simplest DB model. Get/put by key. Redis, DynamoDB, etcd.

**NoSQL** - Anything that isn't a traditional SQL relational database. Document, key-value, graph, time-series, etc.

**OLAP (Online Analytical Processing)** - Big aggregate queries over historical data. Warehouses.

**OLTP (Online Transaction Processing)** - Fast, small transactions. Operational databases.

**ORM (Object-Relational Mapper)** - Library that maps DB rows to objects in your code. SQLAlchemy, Prisma, ActiveRecord.

**Relational DB** - Tables with rows and columns, joined via keys. Postgres, MySQL, SQL Server, Oracle.

**Replica** - A read-only copy of a database for scaling reads or disaster recovery.

**Schema** - The structure of your data (tables, columns, types).

**Sharding** - Splitting a dataset across multiple servers based on a key.

**Time-series DB** - Optimized for timestamped data. InfluxDB, TimescaleDB, Prometheus.

**Transaction** - A group of operations that succeed or fail together.

**Vector database** - Stores high-dimensional vectors (embeddings) for similarity search. Pinecone, Weaviate, pgvector, Qdrant, Milvus.

---

## AI / Machine Learning

**Algorithm (ML)** - The recipe used to learn from data. Linear regression, decision trees, neural networks.

**Bias (ML)** - Systematic error from a model. Often means the model unfairly favors some groups.

**Classification** - Predicting a discrete label (spam / not spam).

**Clustering** - Unsupervised grouping of similar items.

**Cross-validation** - Splitting your training data multiple ways to check that performance generalizes.

**Dataset** - The collection of examples a model learns from.

**Deep learning** - ML using neural networks with many layers.

**Epoch** - One pass over the training set.

**Feature** - An input variable used by a model.

**Feature engineering** - Crafting input variables to make a model learn better.

**GPU (Graphics Processing Unit)** - Originally for graphics, now the workhorse of ML training. Massively parallel.

**Gradient descent** - The optimization algorithm at the core of most neural network training.

**Hyperparameter** - A setting you choose before training (learning rate, batch size, etc.). Distinguished from learned parameters (weights).

**Inference** - Running a trained model on new data to get predictions. Distinguished from training.

**Label** - The correct answer for a training example. Used in supervised learning.

**Loss function** - Measures how wrong the model's predictions are. Training minimizes this.

**ML (Machine Learning)** - Algorithms that improve with data, instead of being explicitly programmed.

**Model** - The output of training. Takes inputs, gives predictions.

**Neural network** - A model loosely inspired by neurons. Weighted connections in layers.

**Overfitting** - Model memorizes training data and performs badly on new data.

**Regression** - Predicting a continuous number (price, temperature).

**Reinforcement learning** - Agent learns by acting in an environment and getting rewards. AlphaGo, robotics, game AI.

**Supervised learning** - Training on labeled examples.

**TPU (Tensor Processing Unit)** - Google's custom chip for ML. Comparable to a GPU.

**Training** - Adjusting model weights based on data to minimize loss.

**Underfitting** - Model is too simple to capture the pattern.

**Unsupervised learning** - Finding structure in unlabeled data (clustering, dimensionality reduction).

**Validation set** - Held-out data used during training to tune hyperparameters.

---

## LLMs & Generative AI

**Agent (AI)** - An LLM-powered system that can take actions (call tools, read files, send messages) toward a goal.

**Attention** - The core mechanism in transformers. Lets each token "look at" other tokens when computing its representation.

**Benchmark** - A standard test for models. MMLU, HumanEval, SWE-bench, GSM8K, etc.

**Chain-of-thought (CoT)** - Asking the model to "think step by step" before answering. Often improves reasoning.

**Chunking** - Splitting documents into smaller pieces for embedding / retrieval. Bad chunking ruins RAG.

**Claude** - Anthropic's family of LLMs (Haiku, Sonnet, Opus).

**Context window** - The max number of tokens the model can consider at once. Bigger = more text in, but slower and more expensive.

**Distillation** - Training a smaller model to mimic a larger one.

**Embedding** - A vector that represents the meaning of text (or images, audio). Similar meanings = nearby vectors.

**Eval** - Automated test of model quality. Can be deterministic (does it match a regex?) or model-graded.

**Fine-tuning** - Continuing training of a base model on your own data to specialize it.

**Foundation model** - A large, general-purpose model trained on broad data. GPT, Claude, Gemini, Llama.

**Function calling / Tool use** - The model returns a structured request to invoke a function, then resumes once the result is fed back in.

**Generative AI (GenAI)** - Models that generate new content (text, images, audio, video) instead of classifying.

**GPT** - OpenAI's family of LLMs (GPT-3.5, 4, 4o, etc.). The first widely-known LLM.

**Grounding** - Constraining a model's answers to verified sources (often via RAG).

**Hallucination** - When a model confidently makes up something false.

**Inference cost** - Per-token (or per-second) cost of running a model. Often tracked as $/M tokens in/out.

**LangChain / LlamaIndex** - Frameworks for building LLM apps. LangChain = general orchestration, LlamaIndex = retrieval-focused.

**Latent space** - The high-dimensional space embeddings live in.

**LLM (Large Language Model)** - A model trained on huge amounts of text to predict the next token.

**LoRA (Low-Rank Adaptation)** - Cheap fine-tuning by training only a small adapter, not the whole model.

**MCP (Model Context Protocol)** - Anthropic's open protocol for connecting LLMs to tools and data sources.

**Multimodal** - Models that handle multiple input/output types (text + image, text + audio, etc.).

**Parameter** - One of the learned numbers in a model. GPT-3 had 175B; modern flagship models can have hundreds of billions.

**Prompt** - The text you give the model.

**Prompt caching** - Reusing a precomputed prompt prefix to save cost and latency. Anthropic and OpenAI both support it.

**Prompt engineering** - The craft of writing prompts that get good outputs reliably.

**Prompt injection** - An attack where malicious text tells the model to ignore its instructions.

**RAG (Retrieval-Augmented Generation)** - Look up relevant documents, stuff them into the prompt, then generate. Standard pattern for "chat with your docs."

**RLHF (Reinforcement Learning from Human Feedback)** - Training step where humans rank model outputs to teach it preferences.

**Reranker** - A second-stage model that re-scores retrieved chunks for relevance.

**Sampling** - The process of choosing the next token. Temperature, top-p, top-k are sampling parameters.

**Semantic search** - Search by meaning, not keywords. Powered by embeddings.

**SFT (Supervised Fine-Tuning)** - Fine-tuning on labeled examples.

**System prompt** - Top-level instructions to the model. Sets the role/behavior.

**Temperature** - Controls randomness in sampling. 0 = deterministic, higher = more varied.

**Token** - The unit a model reads/writes. Usually ~4 characters of English. Costs are per-token.

**Tokenizer** - Splits text into tokens. Different models use different tokenizers.

**Top-k / Top-p sampling** - Restrict the model's choices to the most likely next tokens.

**Transformer** - The neural network architecture behind nearly all modern LLMs. Introduced in "Attention Is All You Need" (2017).

**Vibe coding** - Writing software primarily by prompting an AI model rather than editing code yourself. Term popularized in 2025.

---

## Observability

**Alert** - A rule that fires when a metric crosses a threshold. Wakes someone up (or not).

**APM (Application Performance Monitoring)** - Tools that trace requests through your app and surface slowness. Datadog, New Relic, AppDynamics.

**Cardinality** - The number of unique label combinations on a metric. High cardinality = expensive metrics.

**Distributed tracing** - Following a single request across many services. OpenTelemetry, Jaeger, Tempo, X-Ray.

**Error budget** - The amount of failure tolerated by an SLO. If you blow it, no risky deploys.

**Log** - A timestamped text record of an event.

**Metric** - A numeric measurement over time (request count, error rate, latency).

**Observability** - The ability to understand what's happening inside a system from its outputs (logs, metrics, traces).

**OpenTelemetry (OTel)** - The open standard for instrumenting apps with logs, metrics, and traces.

**SLO (Service Level Objective)** - The target for a service's reliability (e.g., "99.9% of requests under 500ms").

**Span** - One unit of work in a distributed trace.

**Trace** - The full journey of a request across services. Made up of spans.

---

## Want a term added?

Open an issue or PR. See [CONTRIBUTING.md](../CONTRIBUTING.md).
