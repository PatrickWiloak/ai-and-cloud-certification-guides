# NVIDIA Multimodal GenAI Associate - Fact Sheet

## Quick Reference

**Exam Code:** NCA-MMGA
**Duration:** 60 minutes
**Questions:** 50-60 questions
**Passing Score:** Not officially published
**Cost:** $135 USD
**Validity:** 2 years
**Difficulty:** Associate (foundational)

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Multimodal AI Fundamentals | 25% | Modalities, architectures, VLMs |
| Image and Video Generation | 25% | Diffusion models, text-to-image, video |
| Text and Speech Modalities | 20% | LLMs, TTS, STT, Riva |
| NVIDIA Multimodal Tools | 15% | NIM, NeMo, Build, AI Enterprise |
| Applications and Best Practices | 15% | Multimodal RAG, evaluation, ethics |

## Domain 1: Multimodal AI Fundamentals

### Modality Types
- **Text** - Natural language input and output
- **Image** - Still images (photos, illustrations, diagrams)
- **Audio** - Speech, music, sound effects
- **Video** - Moving images with temporal dimension
- **3D** - Point clouds, meshes, volumetric data

### Multimodal Model Architectures

**Vision-Language Models (VLMs):**
- Process both images and text together
- Examples: LLaVA, GPT-4V, NVIDIA VILA
- Image encoder + LLM decoder architecture
- Applications: image captioning, visual Q&A, document understanding
- **[📖 NVIDIA VILA](https://developer.nvidia.com/blog/tag/multimodal/)** - Vision-language research

**Cross-Modal Alignment:**
- CLIP (Contrastive Language-Image Pre-training)
- Aligns image and text in a shared embedding space
- Enables text-to-image search and zero-shot classification
- Foundation for many multimodal systems

**Fusion Strategies:**
- **Early fusion** - Combine modalities at input level
- **Late fusion** - Process modalities separately, combine at decision
- **Cross-attention fusion** - Attend across modalities during processing
- **Adapter-based** - Add modality adapters to existing LLMs

### Use Cases
- Image captioning and visual question answering
- Text-to-image and text-to-video generation
- Document understanding (OCR + language)
- Multimodal search and retrieval
- Accessibility (image description, speech-to-text)

## Domain 2: Image and Video Generation

### Diffusion Models

**How They Work:**
1. **Forward process** - Gradually add noise to data until pure noise
2. **Reverse process** - Learn to gradually remove noise to generate data
3. **Conditioning** - Guide generation with text prompts or images
4. **Sampling** - Iteratively denoise from random noise to generate output

**Key Concepts:**
- **Noise schedule** - How noise is added/removed over steps
- **Classifier-free guidance** - Balance between prompt adherence and diversity
- **Sampling steps** - More steps = higher quality but slower
- **Latent diffusion** - Operate in compressed latent space (faster)

### Text-to-Image
- Input: text prompt describing desired image
- Model: Stable Diffusion, DALL-E, Imagen, NVIDIA Picasso
- Control: guidance scale, negative prompts, seed
- Resolution: typically 512x512 to 2048x2048

### Image-to-Image
- Input: source image + text prompt for modification
- Strength parameter controls how much to change
- Inpainting: edit specific regions of an image
- Outpainting: extend image beyond original borders
- Style transfer: apply artistic style to content

### Video Generation
- Extension of image generation to temporal domain
- Temporal consistency between frames
- Text-to-video and image-to-video
- Frame interpolation and super-resolution

### NVIDIA Visual AI
- **NVIDIA Picasso** - Visual content generation service
- **Edify** - Foundation models for images and video
- NIM endpoints for image generation models
- **[📖 NVIDIA Build](https://build.nvidia.com/)** - Try models interactively

## Domain 3: Text and Speech

### LLMs for Multimodal Understanding
- LLMs serve as the "brain" for multimodal systems
- Process text descriptions of other modalities
- Generate text responses to multimodal inputs
- Function calling for multimodal tool use

### Speech AI

**Text-to-Speech (TTS):**
- Convert text to natural speech
- Voice cloning and customization
- Emotion and prosody control
- Multi-language support

**Speech-to-Text (STT):**
- Automatic speech recognition (ASR)
- Real-time transcription
- Multi-language recognition
- Noise robustness

### NVIDIA Riva

**Capabilities:**
- GPU-accelerated speech AI
- Streaming and offline ASR
- High-quality TTS
- NLP pipeline integration
- Custom model training
- **[📖 Riva Documentation](https://docs.nvidia.com/deeplearning/riva/user-guide/docs/index.html)**

**Architecture:**
- Pre-trained models optimized for GPU
- TensorRT optimization for low latency
- gRPC API for integration
- Kubernetes deployment support

### Audio Processing
- Mel spectrogram representation
- Audio embedding models
- Speaker identification and verification
- Audio classification (speech, music, noise)

## Domain 4: NVIDIA Multimodal Tools

### NIM for Multimodal
- Optimized containers for multimodal model serving
- VLM endpoints (vision + language)
- Image generation endpoints
- Speech AI endpoints
- OpenAI-compatible APIs where applicable
- **[📖 NIM Documentation](https://docs.nvidia.com/nim/index.html)**

### NeMo for Multimodal Training
- Training framework for multimodal models
- Vision-language model fine-tuning
- Speech model customization
- Multi-GPU and multi-node training support
- **[📖 NeMo Framework](https://docs.nvidia.com/nemo-framework/user-guide/latest/index.html)**

### Build.nvidia.com
- Interactive model testing platform
- Try multimodal models without setup
- API access for integration
- Model cards with capabilities and limitations

### NVIDIA AI Enterprise
- Enterprise deployment platform
- Support and security updates
- Certified containers and models
- Production-ready infrastructure

## Domain 5: Applications and Best Practices

### Multimodal RAG
- Retrieve both text and image documents
- Multimodal embeddings for cross-modal search
- Visual document understanding with VLMs
- Combine retrieved images and text for generation

### Content Moderation
- Filter harmful content across modalities
- Image safety classification
- Text content filtering
- Audio/speech content moderation
- NeMo Guardrails for multimodal safety

### Evaluation
- Text quality metrics (BLEU, ROUGE for captions)
- Image quality metrics (FID, CLIP score)
- Human evaluation for subjective quality
- Cross-modal consistency measurement

### Ethical Considerations
- Bias in generated content
- Deepfake detection and prevention
- Copyright and attribution
- Privacy in multimodal data
- Responsible use guidelines

## Exam Tips

### Key Concepts to Master
1. Modality types and fusion strategies
2. Diffusion model basics (forward/reverse process)
3. VLM architecture (image encoder + LLM)
4. NVIDIA Riva for speech AI
5. NIM endpoints for multimodal models
6. Multimodal RAG concepts
