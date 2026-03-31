# Image and Video Generation

**[📖 NVIDIA Build](https://build.nvidia.com/)** - Try image generation models interactively

## Diffusion Models

### Core Concept

Diffusion models learn to reverse a noise-adding process:

**Forward Process (Training):**
1. Start with a clean image
2. Gradually add Gaussian noise over T steps
3. End with pure random noise
4. Model learns to predict the noise at each step

**Reverse Process (Generation):**
1. Start with pure random noise
2. Model predicts and removes a small amount of noise
3. Repeat for T steps
4. End with a clean generated image

### Key Concepts

**Noise Schedule:**
- Controls how much noise is added at each step
- Linear, cosine, or custom schedules
- Affects quality and speed of generation

**Classifier-Free Guidance (CFG):**
- Scales the influence of the text prompt on generation
- Higher CFG = more prompt adherence, less diversity
- Lower CFG = more creative, may drift from prompt
- Typical values: 7-12

**Negative Prompts:**
- Describe what should NOT appear in the image
- Steers generation away from undesired content
- Common: "blurry, low quality, distorted"

**Sampling Steps:**
- Number of denoising iterations
- More steps = higher quality but slower
- Diminishing returns beyond ~50 steps
- Fast samplers (DPM, DDIM) need fewer steps

### Latent Diffusion Models

**Architecture:**
- **VAE Encoder** - Compresses image to latent space (smaller)
- **U-Net** - Predicts noise in latent space
- **Text Encoder** - Converts prompt to conditioning embeddings (CLIP)
- **VAE Decoder** - Decompresses latent back to image

**Benefits:**
- Operate in compressed latent space (4-8x smaller)
- Much faster than pixel-space diffusion
- Lower memory requirements
- Foundation for Stable Diffusion, DALL-E 3, etc.

## Text-to-Image Generation

### Workflow
1. User provides text prompt
2. Text encoder converts to embedding
3. Starting from random noise in latent space
4. U-Net iteratively denoises with text conditioning
5. VAE decoder converts latent to final image

### Prompt Engineering for Images

**Effective Prompts:**
- Be specific about subject, style, lighting, composition
- Include quality modifiers ("highly detailed", "professional")
- Specify art style ("photorealistic", "watercolor", "3D render")
- Describe lighting and mood ("golden hour", "dramatic lighting")

**Prompt Structure:**
```
[Subject], [Details], [Style], [Quality], [Lighting]
Example: "A red sports car on a mountain road, cinematic composition,
photorealistic, highly detailed, golden hour lighting"
```

### Control Mechanisms
- **Seed** - Random seed for reproducible generation
- **Resolution** - Output image dimensions
- **Aspect ratio** - Width-to-height ratio
- **CFG scale** - Prompt adherence strength
- **Steps** - Number of denoising steps

## Image-to-Image

### Image Editing
- **img2img** - Transform existing image based on prompt
- **Strength** parameter (0-1) controls how much to change
- Low strength = minor modifications
- High strength = major transformation (almost text-to-image)

### Inpainting
- Edit specific regions of an image
- User provides mask indicating region to modify
- Model fills masked region guided by prompt
- Surrounding context preserved
- Useful for object removal, addition, or replacement

### Outpainting
- Extend image beyond original borders
- Model generates new content that blends with existing
- Maintains style and content consistency
- Useful for expanding compositions

### ControlNet
- Additional control inputs for image generation
- Edge maps, depth maps, pose skeletons
- Precise spatial control over generated content
- Combine with text prompts for detailed control

## Video Generation

### Challenges
- Temporal consistency between frames
- Much higher compute requirements than images
- Motion coherence and physics plausibility
- Audio-visual synchronization

### Approaches
- **Frame-by-frame** with temporal conditioning
- **Autoregressive** - generate frames sequentially
- **Latent video diffusion** - 3D latent space (spatial + temporal)
- **Frame interpolation** - generate key frames, interpolate between

### Applications
- Text-to-video generation
- Image-to-video (animate still images)
- Video editing (modify existing video)
- Video super-resolution and frame interpolation

## NVIDIA Visual AI Tools

### NVIDIA Picasso
- Cloud service for visual generative AI
- Custom model training on proprietary data
- Image and video generation APIs
- Enterprise-grade deployment
- Content moderation built-in

### NVIDIA Edify Models
- Foundation models for images and video
- High-quality generation capabilities
- Fine-tunable for specific domains
- Available through NIM and Build

### NIM for Image Generation
- Optimized inference containers
- GPU-accelerated generation
- API-based access
- Scalable deployment

**[📖 NIM Documentation](https://docs.nvidia.com/nim/index.html)** - Deployment guides

## Key Exam Concepts

- Diffusion model forward and reverse processes
- Classifier-free guidance and its effect
- Latent diffusion architecture (VAE + U-Net + text encoder)
- Text-to-image prompt engineering
- Image-to-image: inpainting, outpainting, style transfer
- Video generation challenges (temporal consistency)
- NVIDIA visual AI tools (Picasso, Edify, NIM)
