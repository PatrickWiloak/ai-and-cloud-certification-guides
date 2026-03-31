# Text and Speech Modalities

**[📖 NVIDIA Riva Documentation](https://docs.nvidia.com/deeplearning/riva/user-guide/docs/index.html)** - Speech AI platform

## LLMs in Multimodal Systems

### Role of LLMs
- Serve as the "reasoning engine" for multimodal systems
- Process and generate text based on multimodal inputs
- Coordinate between different modality-specific models
- Generate descriptions, answers, and instructions

### Multimodal Prompting
- Include text descriptions of non-text inputs
- Structured prompts for multimodal understanding
- System prompts that define multimodal capabilities
- Few-shot examples with multimodal content

## Speech-to-Text (ASR)

### Automatic Speech Recognition

**Pipeline:**
1. Audio input (microphone or file)
2. Audio preprocessing (noise reduction, normalization)
3. Feature extraction (mel spectrogram)
4. Acoustic model (encoder for speech features)
5. Decoder (converts features to text tokens)
6. Language model (improves text output quality)
7. Text output

**Key Concepts:**
- **Word Error Rate (WER)** - Primary quality metric
- **Real-time factor** - Processing time vs audio duration
- **Streaming vs batch** - Real-time transcription vs post-processing
- **Domain adaptation** - Custom vocabulary for specific industries

### NVIDIA Riva ASR
- GPU-accelerated speech recognition
- Streaming and offline modes
- Multi-language support
- Custom vocabulary and domain adaptation
- Low-latency inference with TensorRT
- **[📖 Riva ASR](https://docs.nvidia.com/deeplearning/riva/user-guide/docs/asr/asr-overview.html)**

## Text-to-Speech (TTS)

### Speech Synthesis

**Pipeline:**
1. Text input
2. Text normalization (expand abbreviations, numbers)
3. Linguistic analysis (phonemes, stress, intonation)
4. Acoustic model (generate mel spectrogram from text)
5. Vocoder (convert spectrogram to audio waveform)
6. Audio output

**Key Concepts:**
- **Naturalness** - How human-like the speech sounds
- **Prosody** - Rhythm, stress, and intonation patterns
- **Voice cloning** - Create synthetic voice from audio samples
- **Multi-speaker** - Single model with multiple voice options
- **Emotion control** - Adjust emotional tone of speech

### NVIDIA Riva TTS
- GPU-accelerated speech synthesis
- High-quality natural voices
- Low-latency streaming output
- Custom voice creation
- SSML support for speech control
- **[📖 Riva TTS](https://docs.nvidia.com/deeplearning/riva/user-guide/docs/tts/tts-overview.html)**

## NVIDIA Riva Platform

### Architecture
- gRPC-based API for speech services
- TensorRT-optimized inference pipeline
- Kubernetes-native deployment
- Multi-GPU scaling for concurrent users

### Key Features
- Streaming ASR for real-time transcription
- High-quality TTS with natural voices
- NLP pipeline integration (intent, entity, sentiment)
- Custom model fine-tuning with NeMo
- Multi-language support

### Deployment
```bash
# Deploy Riva with NGC
docker pull nvcr.io/nvidia/riva/riva-quickstart:latest

# Start Riva services
bash riva_init.sh  # Download models
bash riva_start.sh  # Start services
```

### Use Cases
- Contact center AI (call transcription and analysis)
- Voice assistants and chatbots
- Meeting transcription and summarization
- Accessibility tools
- Real-time translation

## Audio Processing

### Mel Spectrogram
- Visual representation of audio signal
- Frequency on Y-axis, time on X-axis
- Color/intensity represents amplitude
- Perceptually motivated frequency scale
- Standard input for speech models

### Audio Features
- **Sample rate** - Number of audio samples per second
- **Channels** - Mono (1) or stereo (2)
- **Bit depth** - Dynamic range resolution
- **Duration** - Length of audio segment

### Audio Classification
- Classify audio into categories
- Speech vs music vs noise
- Environmental sound recognition
- Speaker identification
- Emotion recognition from voice

### Speaker Diarization
- "Who spoke when" in multi-speaker audio
- Segment audio by speaker
- Assign speaker labels to segments
- Essential for meeting transcription
- Riva provides diarization capabilities

## Multimodal Speech Applications

### Voice + Vision
- Describe images to visually impaired users
- Voice-controlled image generation
- Visual search with voice queries
- Voice annotations on images

### Voice + Text
- Dictation with formatting
- Voice-to-document pipelines
- Multilingual voice translation
- Voice-enabled chatbots

## Key Exam Concepts

- ASR pipeline stages and Word Error Rate metric
- TTS pipeline stages and naturalness concepts
- NVIDIA Riva architecture and capabilities
- Streaming vs batch speech processing
- Mel spectrogram as audio representation
- Speaker diarization concept
- Common speech AI applications
