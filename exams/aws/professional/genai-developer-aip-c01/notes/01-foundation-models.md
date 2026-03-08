# Foundation Models: Types, Selection, and Implementation

**📖 [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/)** - Complete guide to accessing foundation models on AWS

## 📋 Foundation Model Concepts

### What Are Foundation Models?

Foundation models (FMs) are large-scale machine learning models pre-trained on vast datasets that can be adapted to a wide range of downstream tasks. They serve as the base for generative AI applications.

**📖 [Foundation Models on AWS](https://aws.amazon.com/what-is/foundation-models/)** - Understanding foundation models

**Key Characteristics:**
- Pre-trained on massive, diverse datasets (text, code, images)
- Billions of parameters learned during training
- Transfer learning enables adaptation to specific tasks
- Can generate text, code, images, embeddings, and more
- Accessed via APIs without managing infrastructure

### Transformer Architecture

**Core Components:**
- **Self-Attention Mechanism** - Weighs importance of different parts of input
- **Multi-Head Attention** - Multiple attention patterns in parallel
- **Positional Encoding** - Preserves sequence order information
- **Feed-Forward Networks** - Process attention outputs
- **Layer Normalization** - Stabilizes training

**Model Types:**
| Type | Architecture | Examples | Use Cases |
|------|-------------|----------|-----------|
| **Encoder-only** | Bidirectional context | BERT, RoBERTa | Classification, NER, embeddings |
| **Decoder-only** | Autoregressive (left-to-right) | GPT, Claude, Llama | Text generation, chat, code |
| **Encoder-Decoder** | Sequence-to-sequence | T5, BART | Translation, summarization |
| **Diffusion** | Iterative denoising | Stable Diffusion, DALL-E | Image generation |

### Tokenization

**📖 [Understanding Tokens](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)** - How models process text

- Models process text as tokens, not characters or words
- Typical ratio: ~1 token per 4 characters in English
- Different models use different tokenizers (BPE, SentencePiece, WordPiece)
- Token limits define the context window (input + output)
- Pricing is based on input and output token counts

## 🎯 Model Providers on Amazon Bedrock

**📖 [Supported Models in Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html)** - Complete list of available models

### Anthropic Claude

**📖 [Claude on Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html)** - Claude model configuration

- **Claude 3.5 Sonnet** - Best balance of intelligence and speed, excellent at coding
- **Claude 3 Opus** - Most capable, complex reasoning and analysis
- **Claude 3 Sonnet** - Balanced performance and cost
- **Claude 3 Haiku** - Fastest and most cost-effective, near-instant responses

**Strengths:**
- Advanced reasoning and analysis
- Long context window (up to 200K tokens)
- Strong coding capabilities
- Nuanced instruction following
- Vision capabilities (image understanding)

**Best For:** Complex reasoning, code generation, document analysis, multi-turn conversation

### Meta Llama

**📖 [Llama on Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-meta.html)** - Llama model configuration

- **Llama 3.1 8B** - Lightweight, fast inference
- **Llama 3.1 70B** - Strong general-purpose performance
- **Llama 3.1 405B** - Largest open model, near-frontier performance

**Strengths:**
- Open-source model weights (customizable)
- Strong multilingual capabilities
- Competitive performance across benchmarks
- Good code generation

**Best For:** Multilingual tasks, customizable deployments, general-purpose text generation

### Amazon Titan

**📖 [Amazon Titan Models](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-models.html)** - Amazon's own foundation models

- **Titan Text Express** - General-purpose text generation
- **Titan Text Lite** - Cost-effective, lightweight text tasks
- **Titan Text Premier** - Advanced text generation
- **Titan Embeddings V2** - Text-to-vector conversion for semantic search
- **Titan Image Generator** - Text-to-image generation and editing
- **Titan Multimodal Embeddings** - Combined text and image embeddings

**Strengths:**
- Native AWS integration and optimization
- Built-in content safety features
- Strong embedding models for RAG
- Competitive pricing
- Watermarking for Titan Image Generator

**Best For:** Embeddings for RAG, image generation, cost-effective text tasks

### Cohere

**📖 [Cohere on Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-cohere.html)** - Cohere model configuration

- **Command R+** - Advanced RAG-optimized generation with citations
- **Command R** - Efficient RAG-optimized generation
- **Embed English/Multilingual** - High-quality text embeddings

**Strengths:**
- RAG-optimized with built-in citation generation
- Strong enterprise search capabilities
- Excellent embedding models
- Multilingual support

**Best For:** RAG applications, enterprise search, document retrieval

### Mistral AI

**📖 [Mistral on Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-mistral.html)** - Mistral model configuration

- **Mistral Large** - Most capable Mistral model
- **Mixtral 8x7B** - Mixture-of-experts architecture, efficient
- **Mistral 7B** - Compact, fast, cost-effective

**Strengths:**
- Efficient mixture-of-experts architecture
- Strong multilingual performance
- Competitive coding capabilities
- Low latency for smaller models

**Best For:** Cost-effective generation, multilingual tasks, coding assistance

### AI21 Labs

- **Jamba-Instruct** - Hybrid transformer-Mamba architecture

**Best For:** Long-context tasks, summarization, multilingual content

### Stability AI

**📖 [Stability AI on Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-stability-diffusion.html)** - Stable Diffusion configuration

- **Stable Diffusion XL (SDXL)** - High-quality image generation

**Strengths:**
- Photorealistic image generation
- Style transfer and image editing
- Negative prompts for content control
- High-resolution output

**Best For:** Image generation, creative content, visual design

## 📚 Model Selection Criteria

### Selection Framework

When choosing a foundation model for a use case, evaluate across these dimensions:

**📖 [Choosing a Model](https://docs.aws.amazon.com/bedrock/latest/userguide/models-features.html)** - Model feature comparison

| Criterion | Questions to Ask |
|-----------|-----------------|
| **Task Type** | What is the primary task? (generation, classification, search, image) |
| **Quality** | What level of accuracy/reasoning is required? |
| **Latency** | What is the acceptable response time? |
| **Context Window** | How much input text needs to be processed? |
| **Cost** | What is the budget per request? |
| **Throughput** | How many concurrent requests are expected? |
| **Customization** | Does the model need fine-tuning? |
| **Language** | What languages must be supported? |
| **Modality** | Text-only, multimodal, or image generation? |
| **Compliance** | Are there data residency or regulatory requirements? |

### Task-to-Model Mapping

| Task | Recommended Models | Reasoning |
|------|-------------------|-----------|
| Complex analysis & reasoning | Claude 3 Opus, Claude 3.5 Sonnet | Superior analytical capabilities |
| Fast chatbot responses | Claude 3 Haiku, Mistral 7B | Low latency, cost-effective |
| Code generation | Claude 3.5 Sonnet | Top coding benchmark performance |
| Text embeddings for RAG | Titan Embeddings V2, Cohere Embed | Optimized for vector similarity |
| Enterprise search | Cohere Command R+ | Built-in citations and RAG optimization |
| Image generation | Stable Diffusion XL, Titan Image | High-quality visual output |
| Multilingual content | Llama 3.1, Mistral Large | Broad language support |
| Summarization | Claude 3 Sonnet, Titan Text | Long context, concise output |
| Document understanding | Claude 3 (with vision) | Multimodal input capabilities |
| Cost-sensitive batch processing | Titan Text Lite, Mistral 7B | Lowest per-token cost |

### Model Parameter Configuration

**📖 [Inference Parameters](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)** - Configuring model behavior

**Key Parameters:**

| Parameter | Range | Effect |
|-----------|-------|--------|
| **Temperature** | 0.0 - 1.0 | Controls randomness. Lower = more deterministic, Higher = more creative |
| **Top-P** | 0.0 - 1.0 | Nucleus sampling. Considers tokens comprising top P probability mass |
| **Top-K** | 1 - 500 | Limits token selection to top K most probable tokens |
| **Max Tokens** | Model-dependent | Maximum number of tokens in the response |
| **Stop Sequences** | List of strings | Sequences that cause the model to stop generating |

**Parameter Guidelines:**
- **Factual Q&A:** Temperature 0.0-0.3, Top-P 0.9
- **Creative writing:** Temperature 0.7-1.0, Top-P 0.95
- **Code generation:** Temperature 0.0-0.2, Top-P 0.9
- **Summarization:** Temperature 0.0-0.3, Top-P 0.9
- **Brainstorming:** Temperature 0.8-1.0, Top-P 1.0

## 🎯 Bedrock API Implementation

### InvokeModel API

**📖 [InvokeModel API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html)** - Model invocation reference

```python
import boto3
import json

bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')

# Invoke Claude 3 Sonnet
response = bedrock_runtime.invoke_model(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "temperature": 0.7,
        "messages": [
            {
                "role": "user",
                "content": "Explain the benefits of RAG architecture."
            }
        ],
        "system": "You are a helpful AI architecture expert."
    })
)

result = json.loads(response['body'].read())
print(result['content'][0]['text'])
```

### Converse API (Unified Interface)

**📖 [Converse API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html)** - Simplified multi-model conversation API

```python
# Converse API works across all models with unified format
response = bedrock_runtime.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[
        {
            "role": "user",
            "content": [{"text": "What are the key AWS services for GenAI?"}]
        }
    ],
    system=[{"text": "You are an AWS solutions architect."}],
    inferenceConfig={
        "maxTokens": 512,
        "temperature": 0.5,
        "topP": 0.9
    }
)

# Unified response format
output_text = response['output']['message']['content'][0]['text']
token_usage = response['usage']  # inputTokens, outputTokens, totalTokens
```

**Benefits of Converse API:**
- Consistent request/response format across all models
- Automatic model-specific parameter mapping
- Built-in token usage tracking
- Simplified multi-turn conversation management
- Tool use (function calling) support

### Streaming Responses

**📖 [InvokeModelWithResponseStream](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html)** - Streaming API reference

```python
# Streaming for real-time response display
response = bedrock_runtime.invoke_model_with_response_stream(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 2048,
        "messages": [
            {"role": "user", "content": "Write a detailed technical overview."}
        ]
    })
)

stream = response.get('body')
for event in stream:
    chunk = json.loads(event['chunk']['bytes'])
    if chunk['type'] == 'content_block_delta':
        print(chunk['delta']['text'], end='', flush=True)
```

### Embedding Generation

```python
# Generate embeddings with Titan Embeddings V2
response = bedrock_runtime.invoke_model(
    modelId='amazon.titan-embed-text-v2:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "inputText": "Amazon Bedrock is a fully managed service for foundation models.",
        "dimensions": 1024,
        "normalize": True
    })
)

result = json.loads(response['body'].read())
embedding = result['embedding']  # 1024-dimensional vector
```

## 📋 Amazon SageMaker for GenAI

**📖 [SageMaker JumpStart](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-jumpstart.html)** - Pre-trained model deployment

### When to Use SageMaker vs Bedrock

| Criterion | Amazon Bedrock | Amazon SageMaker |
|-----------|---------------|-----------------|
| **Use When** | Need quick FM access via API | Need full model customization |
| **Infrastructure** | Fully managed, no setup | Manage endpoints and instances |
| **Model Source** | Bedrock model catalog | JumpStart, Hugging Face, custom |
| **Customization** | Fine-tuning, continued pre-training | Full training pipeline control |
| **Cost Model** | Pay per token | Pay per instance hour |
| **Scaling** | Automatic | Manual or auto-scaling config |
| **Latency** | Optimized by AWS | Depends on instance type |

### SageMaker JumpStart
- Deploy pre-trained models with one click
- Access 300+ models from Hugging Face, Meta, etc.
- Customize with transfer learning
- Deploy to real-time or batch endpoints

## Exam Tips

### Key Concepts to Remember
- Bedrock is the primary service for accessing FMs on AWS (managed, no infrastructure)
- Converse API provides a unified interface across all Bedrock models
- Temperature controls randomness; lower = more deterministic
- Context window = max input + output tokens
- Titan Embeddings is the go-to for generating vectors for RAG
- Choose the right model size: smaller for simple tasks, larger for complex reasoning
- Provisioned Throughput for consistent high-volume workloads
- SageMaker when you need full control; Bedrock when you want managed simplicity

### Common Exam Traps
- ❌ Recommending SageMaker when Bedrock is sufficient (overcomplicating)
- ❌ Using large models for simple classification tasks (cost waste)
- ❌ Ignoring context window limits when processing long documents
- ❌ Setting high temperature for factual Q&A (causes hallucinations)
- ❌ Forgetting to request model access before using a provider in Bedrock
