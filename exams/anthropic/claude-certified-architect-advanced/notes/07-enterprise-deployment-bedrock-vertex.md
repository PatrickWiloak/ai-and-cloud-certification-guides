# 07 - Enterprise Deployment: Bedrock, Vertex, and First-Party

Enterprise Claude deployments rarely go through the public first-party API alone. Regulated customers need managed cloud deployments with IAM, private networking, audit logging, data residency guarantees, and compliance attestations. The Advanced tier expects you to choose among three primary deployment paths: Anthropic first-party, Amazon Bedrock, and Google Cloud Vertex AI.

---

## The Three Paths

| Dimension | First-Party | Amazon Bedrock | Google Vertex AI |
|---|---|---|---|
| Auth | API key | IAM | Service account |
| Private networking | IP allowlist, PrivateLink (enterprise) | PrivateLink, VPC | VPC Service Controls, Private Service Connect |
| Regions | Anthropic-managed | AWS regions | GCP regions |
| Model IDs | `claude-sonnet-4-6` | `anthropic.claude-sonnet-4-6-YYYYMMDD-v1:0` | `claude-sonnet-4-6@YYYYMMDD` |
| Billing | Anthropic | AWS | GCP |
| Compliance | SOC 2, ISO 27001, HIPAA (BAA) | SOC 2, HIPAA-eligible | SOC 2, HIPAA-eligible |
| Extras | First-party features first | Bedrock Agents, Guardrails | Vertex pipelines, Model Garden |

Pick based on where the customer already is, how private the traffic must be, and which compliance attestations matter.

---

## Claude on Amazon Bedrock

### Model IDs

Region-scoped and date-stamped. Example patterns:

- `anthropic.claude-opus-4-6-YYYYMMDD-v1:0`
- `anthropic.claude-sonnet-4-6-YYYYMMDD-v1:0`
- `anthropic.claude-haiku-4-5-YYYYMMDD-v1:0`

Always confirm the current ID in Bedrock docs; model IDs update as new versions publish.

### Auth

IAM - no Anthropic API key. Call `bedrock-runtime.InvokeModel` or `InvokeModelWithResponseStream`. Permissions granted via IAM policies on the model resource ARN.

### Private Networking

AWS PrivateLink for Bedrock lets you reach the service over private VPC endpoints. Combined with VPC endpoint policies, you can guarantee no public internet egress.

### Cross-Region Inference

Bedrock supports cross-region inference profiles: one profile routes requests across multiple regions to absorb capacity spikes. Useful for bursty workloads.

### Bedrock-Specific Features

- Bedrock Agents: AWS's hosted agent orchestration (separate from the Claude Agent SDK; mostly relevant for AWS-native customers)
- Bedrock Guardrails: input/output content filtering layered on any Bedrock model
- Bedrock Knowledge Bases: managed RAG with vector stores
- CloudTrail integration: audit every InvokeModel call

### Audit and Observability

- CloudTrail for API-level audit
- CloudWatch Metrics for token counts and invocation metrics
- CloudWatch Logs for invocation logs (if enabled)

### When Bedrock Is the Right Answer

- Customer is AWS-native and needs IAM auth
- Needs PrivateLink
- Needs AWS-managed audit via CloudTrail
- Wants Bedrock Guardrails layered on top
- Regulated workload requiring HIPAA BAA from AWS

### Feature Lag

Bedrock sometimes lags the first-party API on new Claude features. Example: a brand-new beta feature may land on the Anthropic API weeks before Bedrock. For leading-edge features, first-party may be required.

---

## Claude on Google Vertex AI

### Model IDs

Publisher-scoped: `publishers/anthropic/models/claude-sonnet-4-6@YYYYMMDD`. Or shorthand `claude-sonnet-4-6@YYYYMMDD` when the publisher is implied.

### Auth

Google Cloud service accounts with IAM roles on the Vertex endpoint. Application Default Credentials work in GCP-native services.

### Private Networking

- VPC Service Controls: perimeter around Vertex AI preventing data exfiltration outside approved VPCs
- Private Service Connect: private endpoint for Vertex

### Regions

Regional endpoints (e.g., `us-east5`, `europe-west1`). Model availability varies by region; check per-model matrix.

### Vertex-Specific Features

- Integration with Vertex AI Pipelines for ML workflows
- Vertex Model Garden unified catalog
- Native integration with BigQuery for RAG
- Cloud Logging and Cloud Monitoring for observability

### When Vertex Is the Right Answer

- Customer is GCP-native
- Needs VPC Service Controls
- Wants Google-managed audit via Cloud Logging
- Integrates with BigQuery / Vertex AI pipelines

### Feature Lag

Like Bedrock, Vertex sometimes lags the first-party API. Confirm feature availability per region.

---

## Anthropic First-Party API

### When It Wins

- Latest features first (extended thinking, new tools, new models land here first)
- Simpler auth (API key)
- Unified experience across all Anthropic features
- Flexible contracting (including ZDR for qualified customers)

### When It Does Not Win

- Customer cannot send traffic to third-party endpoints without friction
- Auditing requirements demand cloud-native logs (CloudTrail, Cloud Logging)
- Billing must consolidate with AWS or GCP

### Private Networking

Enterprise customers can negotiate PrivateLink to the Anthropic API. Standard customers use public endpoints with IP allowlisting.

---

## Compliance

Across all three paths:

- SOC 2 Type II
- ISO 27001, ISO 42001 (AI management systems)
- HIPAA eligibility via BAA on the first-party API and Bedrock; check Vertex
- EU data residency options (EU-region endpoints on Bedrock and Vertex)

### Zero Data Retention (ZDR)

ZDR means Anthropic does not retain inputs or outputs after the request is served. Default is short-term retention for abuse detection. ZDR is contractual and typically available to qualified enterprise customers on the first-party API; check current Bedrock and Vertex ZDR posture separately.

### HIPAA

Requires a signed BAA. Covered workloads must use a HIPAA-eligible model and endpoint. Log and control PHI access on your side; Anthropic (and Bedrock / Vertex) cover the service side.

### EU AI Act

Claude models are general-purpose AI (GPAI). You, as the deployer, have downstream obligations: transparency, risk assessment, potentially conformity assessment depending on use case. Document your system, maintain technical documentation, and record automated decision-making where applicable.

---

## Data Residency

- Bedrock: pick a region; data stays in that region during inference. For multi-region, use cross-region inference profiles explicitly.
- Vertex: pick a regional endpoint. VPC Service Controls enforce boundary.
- First-party: enterprise customers can request regional routing (e.g., EU-only).

Always check current regional availability for each model; new models may not be available in every region at launch.

---

## Multi-Cloud Claude Gateway

A common enterprise pattern: a central gateway abstracts the three paths. Benefits:

- Failover across providers
- Per-tenant routing (tenant A uses Bedrock, tenant B uses Vertex)
- Consistent observability and policy enforcement

Complexity cost: you become responsible for feature-parity reconciliation. Not every Claude feature is available on every path.

---

## Deployment Decision Tree

```
Is customer AWS-native + needs IAM/PrivateLink?      -> Bedrock
Is customer GCP-native + needs VPC-SC?               -> Vertex
Does customer need leading-edge Claude features?     -> First-party
Is customer off-cloud or multi-cloud?                -> First-party (or gateway)
Does customer need CloudTrail-native audit?          -> Bedrock
Does customer need BigQuery-native RAG?              -> Vertex
Does customer need contractual ZDR?                  -> First-party (confirm on Bedrock/Vertex)
```

---

## Operational Playbook

### Rolling Out a New Model Version on Bedrock

1. Check regional availability and inference profile compatibility
2. Update IAM policies if the new model ARN differs
3. Run eval on shadow traffic
4. Use weighted routing to phase in the new model
5. Retire the old model's inference profile after migration

### Rolling Out on Vertex

1. Check publisher model availability per region
2. Update service account permissions
3. Shadow-test in a non-production project
4. Phase in via weighted routing

### Rolling Out on First-Party

1. Update model ID in config
2. Phase via feature flags per cohort
3. Monitor quality and cost
4. Retain previous model ID as rollback

---

## Advanced Exam Focus

Expect scenarios that specify compliance, cloud, and networking constraints and ask for the right deployment. Key signals:

- "AWS-native" + "IAM" + "no public egress" -> Bedrock with PrivateLink
- "GCP-native" + "BigQuery" + "VPC perimeter" -> Vertex with VPC-SC
- "Latest Claude features" + "contractual ZDR" -> First-party
- "HIPAA" -> any path with BAA; verify current coverage
- "EU data residency" -> any path with EU regional endpoint; document GPAI obligations
