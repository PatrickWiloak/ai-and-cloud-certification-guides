---
last-updated: 2026-05-03
difficulty: intermediate
reading-time: 7 min
---

# Multimodal models

> **7-minute read. Assumes you've read [LLM basics](./llm-basics.md).**

## The one-line answer

A multimodal model accepts inputs beyond text - images, audio, video, sometimes documents like PDFs - and reasons across them in the same context as text. You attach a screenshot to a prompt and ask "what's broken in this UI?" The model answers as if it had read both the screenshot and the question.

## What "multimodal" actually means

The model has been trained on paired data (text + images, text + audio) so that all input types produce vectors in a shared embedding space. From the model's perspective, an image is just another sequence of tokens, encoded by a vision encoder, that gets attended to alongside the text tokens.

Most current frontier models are multimodal:

- **Claude 3.5+ Sonnet, Claude 3.7, Claude 4** - text and images
- **GPT-4o, GPT-4-Turbo** - text, images, audio (4o)
- **Gemini 1.5+, Gemini 2** - text, images, audio, video, PDFs

Output is still mostly text. Image and video *generation* is a separate model class (Imagen, Stable Diffusion, Sora, Veo).

## Common patterns

### Visual question answering
"What's in this image?" "Read the text on this receipt." Use cases: accessibility (alt-text generation), content moderation, OCR-as-a-service.

### Document understanding
Drop a PDF or screenshot of a doc into the prompt. The model reads it, extracts structured data, answers questions. Often replaces hand-rolled OCR + parser pipelines.

### Visual reasoning
"Which of these UI mockups is most accessible? Why?" "What's wrong with this architecture diagram?" The model reasons about layout, relationships, intent.

### Multimodal RAG
Index images alongside text. A user asks a question, you retrieve relevant images and chunks together, the model sees both. Useful for catalog search, technical doc search where diagrams matter.

### Agent screenshot loops
The agent takes a screenshot, the model decides what to click next, the harness clicks, takes another screenshot. The loop you'll find in projects like Claude Computer Use, Anthropic's "Operator", browser-use agents.

## Practical considerations

### Image preprocessing
Most APIs accept images up to a few MB or a few thousand pixels per side. Larger images get downsampled. **Downsample on your side first** when fidelity matters less than cost. A 4K screenshot resized to 1080p produces nearly identical answers at a fraction of the tokens.

### Token cost
Images aren't free. Each image consumes a chunk of your context window - typically 1-2K tokens per image at standard resolution, more at high detail. Budget accordingly.

### Latency
Multimodal calls are slower than text-only. The vision encoder runs first, then the LLM. Plan for higher p95 latency.

### Image quality matters
Blurry text doesn't OCR well, regardless of model. Photos with the relevant region in shadow or partly off-frame produce worse extraction. Crop and adjust *before* sending when you can.

### Resolution mode
Some APIs offer "auto / high / low" detail. High costs more but matters for small text or fine detail. Default to auto, override when you can measure the win.

## When NOT to use multimodal

### When OCR is fine
If you need text out of an image and the source is high-quality (scanned forms, screenshots of text), a dedicated OCR (Textract, Document AI, Azure AI Document Intelligence) is usually faster, cheaper, and more accurate per character. Use the multimodal LLM for *interpretation*, OCR for *extraction* - or use both, sequentially.

### When you have structured input
A multimodal call to read JSON-from-an-image is wasteful when you can just send the JSON.

### When the image is purely decorative
"Tell me about this product" with the product photo attached, when the SKU is in the prompt. The image adds tokens without adding signal.

### When you need pixel-perfect output
Multimodal models are bad at "where exactly is X in this image" coordinate-style tasks. They're approximate. For pixel coordinates, use a real vision model trained for it (object detection, segmentation).

## Common pitfalls

### Treating "vision" as deterministic
The model can read text in an image. It can also misread text. Especially handwriting, low-contrast text, or unusual fonts. Don't pipe the output into a billing system without a confirmation step.

### Asking too much per image
"Describe this image, count the people, identify the brand of every product visible, and rate the lighting." Split into separate calls; per-task accuracy goes up.

### Ignoring image format quirks
SVGs are sometimes rejected. Animated GIFs are usually treated as the first frame. Transparent PNG backgrounds can confuse the model. Check format support per API.

### Privacy
Images in prompts are sent to the model provider. PII in screenshots, sensitive documents - same considerations as any other prompt content. Check your provider's data retention policy.

### Confusing multimodal *input* with multimodal *output*
You attached an image and asked the model to "draw a similar one." It can't (most multimodal LLMs are input-only on the visual side). For generation, use a separate model.

## Audio and video

These are newer territory but the patterns are similar:

- **Audio in**: send a clip, the model transcribes and reasons. GPT-4o, Gemini 1.5+. Useful for voice agents, podcast Q&A.
- **Video in**: Gemini handles video natively (frame sampled at intervals). Useful for video summarization, content tagging.

Caveats: audio and video are *much* more token-expensive than text or images, latency is higher still, and capabilities vary widely between providers and model versions. Test with your real content before committing.

## What to look at next

- **[LLM basics](./llm-basics.md)** - the foundation
- **[Embeddings and vector search](./embeddings-and-vector-search.md)** - multimodal embeddings (CLIP, etc.) for retrieval
- **[Prompt engineering](./prompt-engineering.md)** - prompting techniques for image-augmented calls
- **[Tool use and function calling](./tool-use-and-function-calling.md)** - structured output from image inputs
