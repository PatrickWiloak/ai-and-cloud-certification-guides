# NCA-MMGA High-Yield Scenarios and Practice Problems

## Scenario 1: Choosing a Multimodal Architecture

**Scenario**: A company wants to build a system that takes photos of damaged products and generates text descriptions for insurance claims. The system needs to identify the product, describe the damage, and estimate severity. Which architecture is most appropriate?

**Solution Pattern**:
- **Best Choice**: Vision-Language Model (VLM) with structured prompting
- Image encoder processes the product photo
- LLM generates detailed text description based on visual features
- Structured prompt requests specific information (product type, damage type, severity)
- Fine-tune on domain-specific examples for accuracy

**Common Distractors**:
- Text-only LLM - cannot process images
- Image classifier only - classifies but does not generate descriptions
- OCR system - reads text in images but does not analyze visual damage
- Diffusion model - generates images, does not analyze them

**Key Takeaway**: VLMs combine image understanding with text generation, ideal for visual analysis with natural language output.

---

## Scenario 2: Image Generation Quality

**Scenario**: A marketing team uses a text-to-image model but finds that generated images do not closely match their prompts. Increasing the number of sampling steps from 20 to 100 does not help. What should be adjusted?

**Solution Pattern**:
- **Increase classifier-free guidance (CFG) scale** from 7 to 12-15
- Higher CFG scale increases prompt adherence
- Also improve prompt specificity (be more descriptive)
- Add negative prompts to steer away from unwanted elements
- Try different seeds for variety while maintaining prompt adherence

**Common Distractors**:
- Keep increasing steps beyond 100 - diminishing returns, not the issue
- Reduce image resolution - does not improve prompt adherence
- Switch to a larger model - may help but CFG is the first lever
- Remove all prompt details - makes adherence worse

**Key Takeaway**: Classifier-free guidance scale is the primary control for prompt adherence in diffusion models. Sampling steps affect quality, not adherence.

---

## Scenario 3: Speech AI Deployment

**Scenario**: A call center wants real-time transcription of customer calls with under 200ms latency. Calls are in English and Spanish. Which NVIDIA solution should be used?

**Solution Pattern**:
- **NVIDIA Riva** with streaming ASR
- Deploy on GPU for low-latency inference
- Configure multi-language ASR models (English + Spanish)
- Use streaming mode for real-time transcription
- TensorRT optimization ensures sub-200ms latency

**Common Distractors**:
- Batch ASR processing - does not meet real-time requirement
- CPU-based ASR - unlikely to meet latency requirements
- LLM for transcription - not designed for ASR, too slow
- Manual transcription - defeats the purpose of automation

**Key Takeaway**: NVIDIA Riva provides GPU-accelerated streaming ASR with low latency, ideal for real-time call center transcription.

---

## Scenario 4: Multimodal RAG

**Scenario**: A technical support system needs to answer questions about products using a knowledge base that contains manuals with text, diagrams, and photos. How should the system be built?

**Solution Pattern**:
- **Multimodal RAG architecture**:
  1. Extract text, images, and diagrams from manuals
  2. Generate multimodal embeddings (text + image)
  3. Store in vector database
  4. On query: retrieve relevant text and images
  5. VLM processes retrieved text + images to generate answer
  6. Response includes references to specific diagrams

**Common Distractors**:
- Text-only RAG - misses critical visual information in diagrams
- Fine-tune LLM on all manuals - cannot update when manuals change
- Image search only - does not combine text understanding
- Keyword search - misses semantic meaning

**Key Takeaway**: Multimodal RAG retrieves and reasons over both text and images, essential when knowledge bases contain visual content.

---

## Scenario 5: Content Moderation

**Scenario**: A user-facing image generation service needs to prevent generating harmful content. Users provide text prompts. What safety measures should be implemented?

**Solution Pattern**:
- **Multi-layer moderation**:
  1. **Input text filtering** - Detect harmful text prompts before generation
  2. **Prompt rewriting** - Modify borderline prompts to be safe
  3. **Output image classification** - NSFW/safety classifier on generated images
  4. **NeMo Guardrails** - Programmatic safety rails
  5. **Rate limiting** - Prevent abuse through excessive requests
  6. **Logging** - Audit trail for moderation decisions

**Common Distractors**:
- Only output filtering - harmful content still generated (wastes GPU)
- Only input filtering - some prompts may bypass text filters
- Relying on model training alone - insufficient for edge cases
- Manual review of all images - does not scale

**Key Takeaway**: Defense in depth with both input text filtering and output image classification provides comprehensive safety for generative image services.

---

## Scenario 6: Evaluation Metric Selection

**Scenario**: A team has trained a custom text-to-image model and needs to evaluate quality. They want to measure both image realism and how well images match text prompts. Which metrics should they use?

**Solution Pattern**:
- **FID (Frechet Inception Distance)** for image realism/quality
  - Lower FID = more realistic images
  - Compares generated image distribution to real images
- **CLIP Score** for text-image alignment
  - Higher CLIP Score = better prompt adherence
  - Measures similarity between text and image in CLIP space
- **Human evaluation** for subjective quality
  - A/B comparisons with baseline model
  - Rating scales for naturalness and relevance

**Common Distractors**:
- BLEU score - for text generation, not image generation
- Word Error Rate - for speech recognition, not images
- Accuracy - requires labeled classification, not generation quality
- Loss value alone - training metric, not generation quality

**Key Takeaway**: FID measures image quality, CLIP Score measures text-image alignment. Both are needed for comprehensive text-to-image evaluation.
