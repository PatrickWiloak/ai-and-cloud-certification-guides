---
last-updated: 2026-05-03
---

# Decision matrix - LLM serving

You need to serve an LLM (or many) at production scale. The choice splits into **hosted API** (Anthropic / OpenAI / Bedrock / Vertex) vs **self-hosted inference server** (vLLM / TGI / SGLang / llama.cpp / TensorRT-LLM). This page scores each against criteria that drive the decision.

## Criteria

| # | Criterion | Why it matters |
|---|---|---|
| 1 | Time to first token (TTFT) | Chat UX |
| 2 | Throughput (tokens/sec aggregate) | Cost per million tokens |
| 3 | Hardware requirements | What GPUs do you need / can you afford |
| 4 | Operational overhead | Who keeps it running |
| 5 | Structured output / tool use | Modern agent workloads need this |
| 6 | Model coverage | Which models can you serve |
| 7 | Cost predictability | Per-token vs per-GPU-hour |
| 8 | Privacy / data residency | Can data leave your environment |

## Scoring (self-hosted inference servers)

Scale: 1 (poor) → 5 (excellent).

| Server | TTFT | Throughput | HW flexibility | Ops | Structured out | Model coverage | Notes |
|---|---|---|---|---|---|---|---|
| **vLLM** | 5 | 5 | 4 (Nvidia best, AMD growing) | 4 (mature, OpenAI-compat API) | 4 (good) | 5 | Default for self-hosted Nvidia |
| **TGI (Hugging Face)** | 4 | 4 | 4 | 4 | 4 | 5 (HF-native) | Slightly behind vLLM in performance, often newer model support |
| **SGLang** | 5 | 5 | 4 | 3 (smaller ecosystem) | 5 (best for structured + multi-turn) | 4 | Best for agent workloads |
| **llama.cpp** | 3 (CPU is slow) | 2 | 5 (CPU / Mac / phone / GPU) | 5 (tiny binary) | 3 | 4 (GGUF format) | Edge / on-device / no-GPU |
| **TensorRT-LLM** | 5 | 5 (peak Nvidia) | 2 (Nvidia only, complex build) | 2 | 4 | 3 | Highest perf if you're willing to fight the toolchain |
| **Triton Inference Server** | varies | varies | 4 (multi-backend) | 3 | varies | 5 (multi-model) | Operational shell over TRT-LLM, vLLM, etc. |

## Scoring (hosted APIs)

| Provider | TTFT | Throughput | Model quality | Ops | Tool use / agents | Coverage | Privacy options |
|---|---|---|---|---|---|---|---|
| **Anthropic API** | 5 | 5 | 5 (Claude 4 family) | 5 | 5 (best agent SDK) | 1 (Claude only) | 4 (no training on data; Bedrock for HIPAA) |
| **OpenAI** | 5 | 4 | 5 (GPT-4 / o-series) | 5 | 4 | 2 (OpenAI only) | 3 (Azure OpenAI for stricter privacy) |
| **AWS Bedrock** | 4 | 4 | 5 (Claude + Llama + Mistral + Titan) | 5 | 4 | 5 (multi-model) | 5 (AWS native, HIPAA, BAA) |
| **Azure OpenAI** | 4 | 4 | 5 | 5 | 4 | 2 (OpenAI only) | 5 (Azure native) |
| **Vertex AI** | 4 | 4 | 4 (Gemini + partners) | 5 | 4 | 4 (multi-model) | 5 (GCP native) |
| **Together / Fireworks / Groq** | 5 | 5 (Groq is wildly fast) | 3-4 (open models) | 5 | 3 | 4 | 3 |

## Recommendations by scenario

- **Building product features now, want best quality, don't have GPU budget for hosting** → **Anthropic API** for agentic / Claude-best workloads; **OpenAI** for GPT-4-family workloads; **Bedrock** if you're already on AWS and need HIPAA / BAA.
- **Cost-sensitive, willing to lose some frontier quality, traffic is high and steady** → **Together / Fireworks / Groq** for hosted open models; or self-host **vLLM** on rented GPUs (Modal / RunPod / Lambda Labs).
- **Privacy / data sovereignty / can't send data to external APIs** → self-host **vLLM** on your own GPUs, or use **Bedrock** in your AWS account with PrivateLink, or **Azure OpenAI** in your tenant with private endpoints.
- **Edge / no GPU / on-device / Apple Silicon** → **llama.cpp** with GGUF.
- **Heavy agent / tool-use workload** → **Anthropic API** (Claude Agent SDK) for hosted; **SGLang** for self-hosted (best structured generation).
- **Custom / fine-tuned open model at very high throughput, willing to operate** → self-host **vLLM** or **TensorRT-LLM**; **Triton** as the operational shell.

## The default recommendation

For most teams shipping a product right now: start with **a hosted API** (Anthropic, OpenAI, or whichever cloud you're already on). Latency is fine, cost is fine until you have real volume, and you skip the entire ops burden.

Switch to self-hosted only when one of these triggers fires:
- Volume in the tens of billions of tokens/month (math starts favoring own GPUs)
- Privacy / regulatory requirement that hosted APIs can't satisfy
- Custom-fine-tuned model not available on a hosted endpoint
- Latency from a region without good hosted-API presence

## Anti-patterns

- Self-hosting at low volume: a single A100 hour is $2-4. If you're using <1B tokens/month, hosted APIs are almost always cheaper after counting ops time.
- Picking by raw token-per-second benchmark without measuring TTFT and inter-token latency. A throughput champion with 30s TTFT is unusable for chat.
- Ignoring prefix caching: if your system prompt is 2K stable tokens reused across requests, every modern serving stack supports caching - configure it.
- Burning GPU-hours overnight when you have no traffic: idle GPUs eat money fast.

## Related

- [Inference servers](../learn/concepts/inference-servers.md) - the underlying tech
- [GenAI platforms comparison](./service-comparison-genai-platforms.md) - hosted detail
- [LLM observability comparison](./service-comparison-llm-observability.md)
- [Run Llama on a single GPU](./hands-on-projects/run-llama-on-single-gpu.md) - hands-on with vLLM
- [Quantization and distillation](../learn/concepts/quantization-and-distillation.md)
