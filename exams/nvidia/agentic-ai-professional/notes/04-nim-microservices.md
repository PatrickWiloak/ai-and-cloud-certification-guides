# NVIDIA NIM Microservices for Agents

**[📖 NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Getting started with NVIDIA NIM

## NIM Overview

NVIDIA NIM (NVIDIA Inference Microservices) provides optimized, containerized AI model serving with:
- Pre-built Docker containers for popular models
- OpenAI-compatible API for easy integration
- TensorRT-LLM optimization under the hood
- GPU auto-configuration and performance tuning
- Support for function calling and structured output

**[📖 NIM Model Catalog](https://build.nvidia.com/)** - Browse and test available NIM models

## Model Selection for Agent Workloads

### Key Requirements for Agent Models
- **Function calling support** - Model must handle tool_choice and function schemas
- **Strong instruction following** - Agents rely on precise instruction adherence
- **Reasoning capability** - Complex tasks require multi-step reasoning
- **Context length** - Longer context supports more tools and conversation history
- **Low latency** - Interactive agents need fast response times

### Recommended Models
- **LLaMA 3.1 (8B, 70B, 405B)** - Strong function calling, various size/quality trade-offs
- **Mixtral 8x7B** - Good balance of speed and quality via mixture of experts
- **Nemotron** - NVIDIA's models optimized for enterprise agent workloads
- **Mistral Large** - High-quality reasoning and function calling

### Size vs Quality Trade-offs
| Model Size | Latency | Function Calling | Reasoning | Use Case |
|-----------|---------|-----------------|-----------|----------|
| 7-8B | Low | Good | Basic | Simple tool agents |
| 13-34B | Medium | Strong | Good | General-purpose agents |
| 70B+ | Higher | Excellent | Advanced | Complex multi-step agents |

## Deployment Options

### Docker Container
```bash
docker run -d --gpus all \
  -e NGC_API_KEY=$NGC_API_KEY \
  -p 8000:8000 \
  nvcr.io/nim/meta/llama-3.1-8b-instruct:latest
```
- Single-node deployment for development and small-scale use
- Simple setup with GPU pass-through
- Environment variable configuration

### Kubernetes Deployment
- Helm charts for production deployment
- Auto-scaling based on request queue depth or GPU utilization
- Rolling updates for model version changes
- Health checks and readiness probes
- Resource limits and GPU scheduling

**[📖 NIM Kubernetes Guide](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Kubernetes deployment documentation

### Cloud Deployment
- Available on AWS, Azure, GCP with NVIDIA GPU instances
- NVIDIA AI Enterprise for managed deployment
- Cloud marketplace listings for quick provisioning
- Integration with cloud-native load balancers and monitoring

## Configuration for Agent Workloads

### Function Calling Setup
- Ensure the deployed model supports function calling
- Configure `tool_choice` parameter in API requests
- Set appropriate `max_tokens` for tool call responses
- Enable structured JSON output mode when needed

### Latency Optimization
- **Streaming** - Enable SSE streaming for responsive user experience
- **KV-cache management** - Paged attention for efficient memory use
- **Batching** - Continuous batching for concurrent agent sessions
- **Quantization** - FP8 on H100, INT8/FP16 on A100 for faster inference
- **Context length** - Use shorter context when possible to reduce compute

### Scaling Configuration
- Horizontal scaling with multiple NIM instances behind a load balancer
- Separate inference service from tool execution service
- Queue-based processing for asynchronous tool calls
- Auto-scaling triggers: request queue length, GPU utilization, latency P95

**[📖 NIM Performance Guide](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)** - Performance tuning documentation

## Integration with Agent Frameworks

### LangChain Integration
- Use NIM as the LLM backend via OpenAI-compatible endpoint
- Configure base URL to point to NIM service
- Full support for LangChain agent patterns (ReAct, etc.)
- Tool binding through LangChain's tool abstraction

### LlamaIndex Integration
- NIM as LLM for query engines and agents
- Support for function calling and structured output
- Integration with LlamaIndex agent modules

### Custom Frameworks
- OpenAI-compatible chat completions API
- Standard HTTP/REST interface
- Streaming via Server-Sent Events
- Works with any framework that supports OpenAI API format

### NVIDIA AI Workbench
- Development environment for agent prototyping
- Pre-configured with NIM SDK and agent libraries
- Notebook-based experimentation
- Easy transition from development to production

**[📖 NVIDIA AI Workbench](https://developer.nvidia.com/ai-workbench)** - Development environment

## API Reference

### Chat Completions with Tools
```json
POST /v1/chat/completions
{
  "model": "meta/llama-3.1-8b-instruct",
  "messages": [...],
  "tools": [...],
  "tool_choice": "auto",
  "stream": true
}
```

### Key API Parameters
- `tools` - Array of function definitions
- `tool_choice` - "auto", "required", or specific function
- `stream` - Enable streaming responses
- `max_tokens` - Maximum response length
- `temperature` - Control randomness (lower for agents)

## Key Exam Concepts

- NIM deployment options: Docker, Kubernetes, cloud
- Model selection criteria for agent workloads
- Function calling configuration and API usage
- Latency optimization techniques for interactive agents
- Scaling strategies for production agent systems
- Integration with LangChain, LlamaIndex, and custom frameworks
