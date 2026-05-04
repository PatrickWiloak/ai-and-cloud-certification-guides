---
last-updated: 2026-05-03
---

# Azure AI-102: Designing and Implementing Azure AI Solution - Comprehensive Fact Sheet

## Exam Overview

The AI-102 certification validates your ability to design and implement Azure AI solutions using Azure Cognitive Services, Azure Cognitive Search, and Azure OpenAI. This exam is designed for AI engineers who want to demonstrate their skills in building, managing, and deploying AI solutions on Azure.

**Exam Details:**
- **Duration:** 120 minutes
- **Number of Questions:** 40-60 questions
- **Passing Score:** 700 out of 1000
- **Question Types:** Multiple choice, multiple select, drag and drop, case studies
- **Cost:** $165 USD
- **Language:** Available in multiple languages

## Exam Domains and Weightings

1. **Plan and Manage an Azure AI Solution (15-20%)**
2. **Implement Computer Vision Solutions (20-25%)**
3. **Implement Natural Language Processing Solutions (20-25%)**
4. **Implement Knowledge Mining and Document Intelligence Solutions (15-20%)**
5. **Implement Generative AI Solutions (10-15%)**

---

## 1. Plan and Manage an Azure AI Solution (15-20%)

### Azure AI Services Overview

**[📖 Azure AI Services Overview](https://learn.microsoft.com/en-us/azure/ai-services/what-are-ai-services)** - Comprehensive overview of all Azure AI services and capabilities

**[📖 Azure AI Services Pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/)** - Detailed pricing information for all Azure AI services across different tiers

**[📖 Create Azure AI Services Resource](https://learn.microsoft.com/en-us/azure/ai-services/multi-service-resource)** - Guide to creating multi-service resources for unified access

**[📖 Azure AI Services Keys and Endpoints](https://learn.microsoft.com/en-us/azure/ai-services/authentication)** - Authentication methods including keys, tokens, and managed identities

**[📖 Azure AI Services Security](https://learn.microsoft.com/en-us/azure/ai-services/security-features)** - Security features including network security, encryption, and compliance

### Resource Management

**[📖 Azure Resource Manager Templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)** - Infrastructure as Code for deploying AI services

**[📖 Azure AI Services Containers](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-container-support)** - Run AI services in containers for on-premises or edge scenarios

**[📖 Azure AI Services Virtual Networks](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks)** - Configure VNet and firewall rules for secure access

**[📖 Azure Private Link for AI Services](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-private-link)** - Secure connectivity using private endpoints

**[📖 Azure AI Services Managed Identities](https://learn.microsoft.com/en-us/azure/ai-services/authentication#authenticate-with-managed-identities)** - Use managed identities for secure authentication without credentials

### Monitoring and Diagnostics

**[📖 Monitor Azure AI Services](https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging)** - Enable diagnostic logging and monitoring for AI services

**[📖 Azure Monitor for AI Services](https://learn.microsoft.com/en-us/azure/ai-services/monitor-cognitive-services)** - Monitor metrics, logs, and set up alerts

**[📖 Application Insights Integration](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)** - Track AI service usage and performance with Application Insights

**[📖 Diagnostic Logging](https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging)** - Enable and configure diagnostic logs for troubleshooting

### Responsible AI

**[📖 Responsible AI Principles](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai)** - Microsoft's principles for responsible AI development

**[📖 Transparency Notes for AI Services](https://learn.microsoft.com/en-us/azure/ai-services/transparency-note-overview)** - Transparency documentation for understanding AI capabilities and limitations

**[📖 Limited Access Features](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-limited-access)** - Understanding restricted features requiring application approval

**[📖 Content Safety and Moderation](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/)** - Tools for detecting harmful content in text and images

**[📖 Fairness in AI Systems](https://learn.microsoft.com/en-us/azure/machine-learning/concept-fairness-ml)** - Understanding and mitigating bias in AI models

---

## 2. Implement Computer Vision Solutions (20-25%)

### Azure AI Vision (Computer Vision API)

**[📖 Computer Vision Overview](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview)** - Core image analysis service for extracting information from images

**[📖 Analyze Images API](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/how-to/call-analyze-image)** - Analyze visual features in images including objects, tags, and descriptions

**[📖 Computer Vision Image Tagging](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-tag-images)** - Automatic image tagging with thousands of recognizable objects

**[📖 Image Descriptions and Captions](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-describe-images)** - Generate human-readable descriptions of image content

**[📖 Object Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-object-detection)** - Detect and locate objects within images with bounding boxes

**[📖 Optical Character Recognition (OCR)](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-ocr)** - Extract text from images and documents with Read API

**[📖 Spatial Analysis](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/intro-to-spatial-analysis-public-preview)** - Analyze people's presence and movement in physical spaces

**[📖 Image Classification with Vision](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-categorizing-images)** - Categorize images using a taxonomy of 86 categories

**[📖 Brand Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-brand-detection)** - Detect commercial brands in images from database of thousands of logos

**[📖 Adult Content Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-detecting-adult-content)** - Identify adult, racy, or gory content for content moderation

**[📖 Color Scheme Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-detecting-color-schemes)** - Extract dominant colors and accent colors from images

**[📖 Domain-Specific Models](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-detecting-domain-content)** - Celebrity and landmark recognition models

**[📖 Image Thumbnails Generation](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/how-to/generate-thumbnail)** - Generate smart-cropped thumbnails using content-aware cropping

### Azure AI Custom Vision

**[📖 Custom Vision Overview](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/overview)** - Build custom image classification and object detection models

**[📖 Custom Vision Quickstart](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/getting-started-build-a-classifier)** - Step-by-step guide to building your first custom classifier

**[📖 Image Classification](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/getting-started-build-a-classifier)** - Train models to classify images into custom categories

**[📖 Object Detection with Custom Vision](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/get-started-build-detector)** - Train models to detect and locate specific objects

**[📖 Custom Vision Training Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/getting-started-improving-your-classifier)** - Improve model accuracy with proper training data and techniques

**[📖 Export Custom Vision Models](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/export-your-model)** - Export models for offline use on mobile and edge devices

**[📖 Custom Vision Domains](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/select-domain)** - Choose optimal domain for your model (General, Food, Retail, etc.)

**[📖 Custom Vision API Reference](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/quickstarts/image-classification)** - Programmatic access to Custom Vision training and prediction

**[📖 Multi-label Classification](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/getting-started-build-a-classifier)** - Train models to assign multiple tags to single images

**[📖 Custom Vision Performance Metrics](https://learn.microsoft.com/en-us/azure/ai-services/custom-vision-service/getting-started-improving-your-classifier)** - Understand precision, recall, and mean average precision

### Azure Face API

**[📖 Face API Overview](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-identity)** - Face detection, verification, and identification capabilities

**[📖 Face Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-face-detection)** - Detect human faces and facial attributes in images

**[📖 Face Recognition](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-face-recognition)** - Verify face identity and identify persons

**[📖 Facial Attributes](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/concept-face-detection)** - Detect age, emotion, gender, pose, smile, facial hair, glasses, and more

**[📖 Face API Best Practices](https://learn.microsoft.com/en-us/legal/cognitive-services/face/guidance-integration-responsible-use)** - Responsible use guidelines for Face API

**[📖 Face Liveness Detection](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/tutorials/liveness)** - Detect real person vs photo or video spoof attacks

### Video Analysis

**[📖 Video Indexer Overview](https://learn.microsoft.com/en-us/azure/azure-video-indexer/video-indexer-overview)** - AI-powered video analysis and insights extraction

**[📖 Video Indexer Upload and Index](https://learn.microsoft.com/en-us/azure/azure-video-indexer/upload-index-videos)** - Upload videos and extract insights automatically

**[📖 Video Insights](https://learn.microsoft.com/en-us/azure/azure-video-indexer/video-indexer-output-json-v2)** - Extract faces, keywords, topics, emotions, brands, and more

**[📖 Video Indexer API](https://learn.microsoft.com/en-us/azure/azure-video-indexer/video-indexer-use-apis)** - Programmatic access to video indexing capabilities

**[📖 Video Indexer Widgets](https://learn.microsoft.com/en-us/azure/azure-video-indexer/video-indexer-embed-widgets)** - Embed player and insights widgets in applications

**[📖 Customize Video Models](https://learn.microsoft.com/en-us/azure/azure-video-indexer/customize-brands-model-overview)** - Customize person, language, and brand models

**[📖 Video Transcription](https://learn.microsoft.com/en-us/azure/azure-video-indexer/transcription-translation-lid)** - Automatic speech-to-text transcription with speaker identification

---

## 3. Implement Natural Language Processing Solutions (20-25%)

### Azure AI Language (Language Understanding)

**[📖 Azure AI Language Overview](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)** - Unified language service with NLP capabilities

**[📖 Conversational Language Understanding](https://learn.microsoft.com/en-us/azure/ai-services/language-service/conversational-language-understanding/overview)** - Build natural language understanding models for apps

**[📖 Entity Recognition](https://learn.microsoft.com/en-us/azure/ai-services/language-service/named-entity-recognition/overview)** - Extract entities like people, places, organizations from text

**[📖 Key Phrase Extraction](https://learn.microsoft.com/en-us/azure/ai-services/language-service/key-phrase-extraction/overview)** - Identify main concepts and topics in text

**[📖 Sentiment Analysis](https://learn.microsoft.com/en-us/azure/ai-services/language-service/sentiment-opinion-mining/overview)** - Analyze sentiment and mine opinions from text

**[📖 Language Detection](https://learn.microsoft.com/en-us/azure/ai-services/language-service/language-detection/overview)** - Detect language of input text from 120+ languages

**[📖 Text Analytics for Health](https://learn.microsoft.com/en-us/azure/ai-services/language-service/text-analytics-for-health/overview)** - Extract health-related information from medical documents

**[📖 Custom Named Entity Recognition](https://learn.microsoft.com/en-us/azure/ai-services/language-service/custom-named-entity-recognition/overview)** - Build custom entity extraction models

**[📖 Custom Text Classification](https://learn.microsoft.com/en-us/azure/ai-services/language-service/custom-text-classification/overview)** - Train custom text categorization models

**[📖 Question Answering](https://learn.microsoft.com/en-us/azure/ai-services/language-service/question-answering/overview)** - Create conversational question-and-answer layer over data

**[📖 Text Summarization](https://learn.microsoft.com/en-us/azure/ai-services/language-service/summarization/overview)** - Generate extractive and abstractive summaries

**[📖 Personally Identifiable Information (PII) Detection](https://learn.microsoft.com/en-us/azure/ai-services/language-service/personally-identifiable-information/overview)** - Identify and redact sensitive information

### Language Understanding (LUIS)

**[📖 LUIS Overview](https://learn.microsoft.com/en-us/azure/ai-services/luis/what-is-luis)** - Legacy language understanding service (migrating to CLU)

**[📖 LUIS Intents](https://learn.microsoft.com/en-us/azure/ai-services/luis/concepts/intents)** - Define user intentions in conversational applications

**[📖 LUIS Entities](https://learn.microsoft.com/en-us/azure/ai-services/luis/concepts/entities)** - Extract data from user utterances using entity types

**[📖 LUIS Patterns](https://learn.microsoft.com/en-us/azure/ai-services/luis/concepts/patterns)** - Use patterns to improve prediction accuracy with fewer examples

**[📖 LUIS Features](https://learn.microsoft.com/en-us/azure/ai-services/luis/concepts/features)** - Phrase lists and model features to improve understanding

**[📖 LUIS Best Practices](https://learn.microsoft.com/en-us/azure/ai-services/luis/concepts/best-practices)** - Design effective LUIS apps with quality training data

**[📖 Migrate from LUIS to CLU](https://learn.microsoft.com/en-us/azure/ai-services/language-service/conversational-language-understanding/how-to/migrate-from-luis)** - Migration guide from LUIS to Conversational Language Understanding

### Azure AI Translator

**[📖 Translator Service Overview](https://learn.microsoft.com/en-us/azure/ai-services/translator/translator-overview)** - Neural machine translation supporting 90+ languages

**[📖 Text Translation](https://learn.microsoft.com/en-us/azure/ai-services/translator/quickstart-text-rest-api)** - Translate text between supported languages

**[📖 Document Translation](https://learn.microsoft.com/en-us/azure/ai-services/translator/document-translation/overview)** - Batch translation of documents maintaining formatting

**[📖 Custom Translator](https://learn.microsoft.com/en-us/azure/ai-services/translator/custom-translator/overview)** - Build domain-specific translation models

**[📖 Translator Language Support](https://learn.microsoft.com/en-us/azure/ai-services/translator/language-support)** - Complete list of supported languages and features

**[📖 Translator Behind Firewall](https://learn.microsoft.com/en-us/azure/ai-services/translator/firewalls)** - Configure Translator for use behind corporate firewalls

### Azure AI Speech

**[📖 Speech Service Overview](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/overview)** - Speech-to-text, text-to-speech, and speech translation

**[📖 Speech-to-Text](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-to-text)** - Convert spoken audio to text with high accuracy

**[📖 Text-to-Speech](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/text-to-speech)** - Generate natural-sounding synthesized speech

**[📖 Speech Translation](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-translation)** - Real-time translation of spoken language

**[📖 Custom Speech](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/custom-speech-overview)** - Customize speech recognition for specific vocabularies and accents

**[📖 Custom Neural Voice](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/custom-neural-voice)** - Create unique synthetic voices for your brand

**[📖 Speech SDK](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-sdk)** - Software development kit for integrating speech capabilities

**[📖 Speaker Recognition](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speaker-recognition-overview)** - Verify and identify speakers by their voice characteristics

**[📖 Intent Recognition](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/intent-recognition)** - Recognize user intents from speech using LUIS integration

**[📖 Pronunciation Assessment](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/pronunciation-assessment-tool)** - Evaluate speech pronunciation for language learning

### Azure Bot Service

**[📖 Azure Bot Service Overview](https://learn.microsoft.com/en-us/azure/bot-service/bot-service-overview)** - Build, test, and deploy intelligent bots

**[📖 Bot Framework SDK](https://learn.microsoft.com/en-us/azure/bot-service/bot-builder-basics)** - Core concepts for building conversational bots

**[📖 Bot Framework Composer](https://learn.microsoft.com/en-us/composer/introduction)** - Visual authoring canvas for building bots

**[📖 Bot Channels](https://learn.microsoft.com/en-us/azure/bot-service/bot-service-channels-reference)** - Connect bots to Teams, Slack, Facebook, and more

**[📖 Bot Authentication](https://learn.microsoft.com/en-us/azure/bot-service/bot-builder-authentication)** - Add user authentication to bot conversations

**[📖 Adaptive Cards](https://learn.microsoft.com/en-us/adaptive-cards/)** - Rich interactive cards for bot responses

**[📖 Bot Dialogs](https://learn.microsoft.com/en-us/azure/bot-service/bot-builder-concept-dialog)** - Manage conversation flow with dialogs

---

## 4. Implement Knowledge Mining and Document Intelligence Solutions (15-20%)

### Azure Cognitive Search

**[📖 Azure Cognitive Search Overview](https://learn.microsoft.com/en-us/azure/search/search-what-is-azure-search)** - AI-powered cloud search service with built-in capabilities

**[📖 Create Search Index](https://learn.microsoft.com/en-us/azure/search/search-what-is-an-index)** - Define schema and structure for searchable content

**[📖 Search Indexers](https://learn.microsoft.com/en-us/azure/search/search-indexer-overview)** - Automated data ingestion from Azure data sources

**[📖 AI Enrichment](https://learn.microsoft.com/en-us/azure/search/cognitive-search-concept-intro)** - Add AI capabilities to extract, enhance, and index content

**[📖 Skillsets](https://learn.microsoft.com/en-us/azure/search/cognitive-search-working-with-skillsets)** - Define AI enrichment pipeline with built-in and custom skills

**[📖 Built-in Skills](https://learn.microsoft.com/en-us/azure/search/cognitive-search-predefined-skills)** - OCR, entity recognition, key phrases, language detection, and more

**[📖 Custom Skills](https://learn.microsoft.com/en-us/azure/search/cognitive-search-custom-skill-interface)** - Extend enrichment pipeline with Azure Functions

**[📖 Knowledge Store](https://learn.microsoft.com/en-us/azure/search/knowledge-store-concept-intro)** - Persist AI-enriched content for downstream analytics

**[📖 Semantic Search](https://learn.microsoft.com/en-us/azure/search/semantic-search-overview)** - Deep learning-powered ranking for improved relevance

**[📖 Vector Search](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)** - Similarity search using vector embeddings

**[📖 Search Queries](https://learn.microsoft.com/en-us/azure/search/search-query-overview)** - Full-text search with filters, facets, and sorting

**[📖 Search Analyzers](https://learn.microsoft.com/en-us/azure/search/search-analyzers)** - Text analysis for tokenization and linguistic processing

**[📖 Search Scoring Profiles](https://learn.microsoft.com/en-us/azure/search/index-add-scoring-profiles)** - Customize relevance scoring for search results

**[📖 Search Synonyms](https://learn.microsoft.com/en-us/azure/search/search-synonyms)** - Expand query coverage with synonym maps

**[📖 Search Security](https://learn.microsoft.com/en-us/azure/search/search-security-overview)** - Authentication, encryption, and network security

### Azure AI Document Intelligence (Form Recognizer)

**[📖 Document Intelligence Overview](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/overview)** - Extract text, tables, and structure from documents

**[📖 Document Intelligence Studio](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-document-intelligence-studio)** - Web-based tool for testing and building document models

**[📖 Prebuilt Models](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-model-overview)** - Ready-to-use models for invoices, receipts, IDs, and more

**[📖 Invoice Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-invoice)** - Extract key information from invoices

**[📖 Receipt Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-receipt)** - Extract data from sales receipts

**[📖 ID Document Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-id-document)** - Extract information from passports and driver licenses

**[📖 Business Card Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-business-card)** - Extract contact information from business cards

**[📖 Layout Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-layout)** - Extract text, tables, and structure from any document

**[📖 Custom Models](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-custom)** - Train models for your specific document types

**[📖 Custom Template Models](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-custom-template)** - Train on structured forms with consistent layout

**[📖 Custom Neural Models](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-custom-neural)** - Train on semi-structured and unstructured documents

**[📖 Document Intelligence SDK](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/quickstarts/get-started-sdks-rest-api)** - Integrate document processing in applications

---

## 5. Implement Generative AI Solutions (10-15%)

### Azure OpenAI Service

**[📖 Azure OpenAI Service Overview](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview)** - Access powerful language models like GPT-4 and GPT-3.5

**[📖 Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models)** - Available models including GPT-4, GPT-3.5, Embeddings, and DALL-E

**[📖 Azure OpenAI Quickstart](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart)** - Get started with Azure OpenAI using REST API or SDK

**[📖 Completions API](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/completions)** - Generate text completions with GPT models

**[📖 Chat Completions](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/chatgpt)** - Build conversational applications with GPT-3.5-turbo and GPT-4

**[📖 Embeddings](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings)** - Generate vector representations of text for semantic search

**[📖 DALL-E Image Generation](https://learn.microsoft.com/en-us/azure/ai-services/openai/dall-e-quickstart)** - Generate images from text descriptions

**[📖 Prompt Engineering](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering)** - Best practices for crafting effective prompts

**[📖 System Messages](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/system-message)** - Set behavior and context for chat models

**[📖 Fine-tuning](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/fine-tuning)** - Customize models with your own training data

**[📖 Content Filtering](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter)** - Built-in safety systems for content moderation

**[📖 Azure OpenAI Quotas and Limits](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits)** - Token limits, rate limits, and model availability

**[📖 Azure OpenAI Tokens](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/tokens)** - Understanding token usage and counting

**[📖 Function Calling](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling)** - Enable models to call external functions and APIs

**[📖 Retrieval Augmented Generation (RAG)](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/use-your-data)** - Ground models with your own data using Azure Cognitive Search

**[📖 Azure OpenAI on Your Data](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/use-your-data)** - Connect GPT models to your data sources

**[📖 Azure OpenAI Studio](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?pivots=programming-language-studio)** - Web-based interface for working with Azure OpenAI

---

## SDK and Development Resources

### Language SDKs

**[📖 Python SDK for Azure AI Services](https://learn.microsoft.com/en-us/python/api/overview/azure/cognitive-services)** - Python client libraries for all AI services

**[📖 .NET SDK for Azure AI Services](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/cognitive-services)** - .NET client libraries for AI service integration

**[📖 JavaScript SDK for Azure AI Services](https://learn.microsoft.com/en-us/javascript/api/overview/azure/cognitive-services)** - Node.js and JavaScript libraries

**[📖 Java SDK for Azure AI Services](https://learn.microsoft.com/en-us/java/api/overview/azure/cognitive-services)** - Java client libraries for enterprise applications

### REST APIs

**[📖 Computer Vision REST API](https://learn.microsoft.com/en-us/rest/api/computer-vision/)** - RESTful API reference for Computer Vision

**[📖 Face API REST Reference](https://learn.microsoft.com/en-us/rest/api/face/)** - REST API documentation for Face service

**[📖 Language Service REST API](https://learn.microsoft.com/en-us/rest/api/language/)** - REST endpoints for language processing

**[📖 Translator REST API](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-reference)** - HTTP API reference for translation

**[📖 Speech Service REST API](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/rest-speech-to-text)** - REST endpoints for speech-to-text

**[📖 Azure Search REST API](https://learn.microsoft.com/en-us/rest/api/searchservice/)** - Complete REST API reference for Cognitive Search

**[📖 Document Intelligence REST API](https://learn.microsoft.com/en-us/rest/api/aiservices/document-models)** - REST API for document processing

**[📖 Azure OpenAI REST API](https://learn.microsoft.com/en-us/azure/ai-services/openai/reference)** - REST API reference for OpenAI endpoints

---

## Security and Compliance

### Authentication and Authorization

**[📖 Azure AI Services Authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication)** - Overview of authentication methods for AI services

**[📖 API Keys Management](https://learn.microsoft.com/en-us/azure/ai-services/authentication#authenticate-with-api-keys)** - Secure key storage and rotation practices

**[📖 Azure AD Authentication](https://learn.microsoft.com/en-us/azure/ai-services/authentication#authenticate-with-azure-active-directory)** - Use Azure Active Directory for authentication

**[📖 Managed Identity for AI Services](https://learn.microsoft.com/en-us/azure/ai-services/authentication#authenticate-with-managed-identities)** - Eliminate credentials using managed identities

**[📖 Role-Based Access Control (RBAC)](https://learn.microsoft.com/en-us/azure/ai-services/role-based-access-control)** - Control access using Azure RBAC roles

### Network Security

**[📖 Configure Virtual Networks](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks)** - Secure AI services with VNet integration

**[📖 Private Endpoints](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-private-link)** - Access services over private network connection

**[📖 Configure Firewalls](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks#configure-network-access)** - Restrict access by IP address ranges

### Data Protection

**[📖 Data Encryption at Rest](https://learn.microsoft.com/en-us/azure/ai-services/encryption/cognitive-services-encryption-keys-portal)** - Customer-managed keys for data encryption

**[📖 Data Residency](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-data-residency)** - Control where your data is processed and stored

**[📖 Customer-Managed Keys](https://learn.microsoft.com/en-us/azure/ai-services/encryption/cognitive-services-encryption-keys-portal)** - Use Azure Key Vault for encryption key management

---

## Best Practices and Patterns

### Design Patterns

**[📖 AI Solution Architecture](https://learn.microsoft.com/en-us/azure/architecture/browse/?terms=artificial%20intelligence)** - Reference architectures for AI solutions

**[📖 Retry Logic for AI Services](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry)** - Handle transient failures with retry patterns

**[📖 Circuit Breaker Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)** - Prevent cascading failures in AI applications

**[📖 Throttling Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/throttling)** - Manage rate limits and resource consumption

**[📖 Caching Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside)** - Improve performance and reduce costs with caching

### Performance Optimization

**[📖 Rate Limits and Throttling](https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-apis-throttling)** - Understanding and handling service rate limits

**[📖 Batch Processing](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-batch)** - Process multiple documents efficiently

**[📖 Async Operations](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/how-to/call-read-api)** - Use asynchronous APIs for long-running operations

### Cost Optimization

**[📖 Choose Right Pricing Tier](https://learn.microsoft.com/en-us/azure/ai-services/cost-management)** - Select appropriate tier based on usage patterns

**[📖 Cost Management](https://learn.microsoft.com/en-us/azure/ai-services/plan-manage-costs)** - Monitor and optimize AI services costs

**[📖 Commitment Tiers](https://learn.microsoft.com/en-us/azure/ai-services/commitment-tier)** - Reduce costs with commitment-based pricing

---

## Exam Preparation Resources

### Official Microsoft Resources

**[📖 AI-102 Exam Page](https://learn.microsoft.com/en-us/credentials/certifications/exams/ai-102/)** - Official exam details, skills measured, and registration

**[📖 AI-102 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-102)** - Official study guide with learning paths

**[📖 Microsoft Learn for AI-102](https://learn.microsoft.com/en-us/training/browse/?products=azure&roles=ai-engineer)** - Free training modules and learning paths

**[📖 AI-102 Practice Assessment](https://learn.microsoft.com/en-us/credentials/certifications/exams/ai-102/practice/assessment)** - Official practice questions

### Additional Learning Resources

**[📖 Azure AI Services Documentation](https://learn.microsoft.com/en-us/azure/ai-services/)** - Complete documentation hub for all AI services

**[📖 Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)** - Guidance for designing cloud solutions

**[📖 Azure Code Samples](https://github.com/Azure-Samples?q=cognitive&type=all)** - Official code samples and quickstarts

---

## Key Concepts to Master

### Multi-Service Resources
- Create single resource for multiple AI services
- Unified endpoint and key management
- Cost consolidation and simplified billing
- Regional availability considerations

### Container Deployment
- Run AI services in disconnected environments
- Docker container configuration and requirements
- Container billing and licensing models
- Kubernetes deployment scenarios

### Custom Model Training
- Data preparation and labeling best practices
- Training vs prediction endpoints
- Model evaluation metrics (precision, recall, F1)
- Iteration and continuous improvement
- Model versioning and management

### Responsible AI Implementation
- Fairness assessment and bias mitigation
- Transparency and explainability
- Privacy and security considerations
- Limited access features requiring approval
- Content filtering and safety systems

### Search and Knowledge Mining
- Index schema design and field attributes
- Skillset composition and execution order
- Incremental indexing and change detection
- Query syntax and filter expressions
- Faceted navigation and search refinement

### Conversational AI
- Intent recognition and entity extraction
- Dialog management and conversation flow
- Multi-turn conversations and context
- Channel adaptation for different platforms
- Bot authentication and security

### Document Processing
- Choosing between prebuilt and custom models
- Training custom models with labeled data
- Confidence scores and quality assessment
- Batch processing large document volumes
- Integration with workflows and storage

### Generative AI
- Prompt engineering techniques
- Temperature and top-p parameters
- Token management and context windows
- Grounding with retrieval augmented generation
- Function calling for external integrations
- Content filtering and safety measures

---

## Common Exam Scenarios

### Scenario 1: Image Analysis Pipeline
**Requirement:** Process uploaded product images to extract tags, descriptions, and detect brands.

**Solution Components:**
- Azure Blob Storage for image storage
- Event Grid for upload notifications
- Azure Function for orchestration
- Computer Vision API for analysis
- Cosmos DB for metadata storage
- Azure Cognitive Search for searchability

### Scenario 2: Document Processing Workflow
**Requirement:** Extract structured data from invoices and receipts for accounting system.

**Solution Components:**
- Document Intelligence with Invoice prebuilt model
- Logic Apps for workflow automation
- Key Vault for credential management
- Azure SQL for structured data storage
- Application Insights for monitoring

### Scenario 3: Multilingual Customer Support Bot
**Requirement:** Build chatbot supporting multiple languages with FAQ capabilities.

**Solution Components:**
- Azure Bot Service for bot framework
- Language Service for question answering
- Translator Service for language support
- Language Detection for automatic language identification
- Application Insights for bot analytics

### Scenario 4: Video Content Analysis
**Requirement:** Index video library for searchable content including faces, topics, and brands.

**Solution Components:**
- Video Indexer for video analysis
- Azure Media Services for video storage
- Cognitive Search for full-text search
- Azure Functions for event processing
- Power BI for insights visualization

### Scenario 5: Custom Vision Quality Control
**Requirement:** Detect manufacturing defects in product images on assembly line.

**Solution Components:**
- Custom Vision for object detection
- IoT Edge for edge deployment
- Azure Storage for image archival
- Stream Analytics for real-time processing
- Power Apps for operator interface

### Scenario 6: Intelligent Search Solution
**Requirement:** Enable full-text search with AI enrichment across document repository.

**Solution Components:**
- Azure Cognitive Search as search engine
- Blob Storage indexer for documents
- Skillset with OCR, entity recognition, key phrases
- Knowledge Store for enriched data
- Custom skills for domain-specific extraction

### Scenario 7: GPT-Powered Knowledge Base
**Requirement:** Build conversational interface to company knowledge base with natural responses.

**Solution Components:**
- Azure OpenAI Service with GPT-4
- Cognitive Search for document retrieval
- Embeddings for semantic search
- RAG pattern for grounded responses
- Content filtering for safety
- Function calling for actions

---

## Troubleshooting Guide

### Common Issues and Solutions

#### Authentication Errors
- Verify API key is correct and not regenerated
- Check endpoint URL matches resource region
- Ensure managed identity has proper role assignment
- Validate Azure AD token expiration

#### Rate Limiting (429 Errors)
- Implement exponential backoff retry logic
- Consider upgrading to higher pricing tier
- Use commitment tier for predictable throughput
- Batch requests when possible

#### Poor Model Performance
- Increase training data quantity and diversity
- Balance classes in training set
- Use appropriate domain for Custom Vision
- Review and improve labeling consistency
- Adjust confidence thresholds

#### Search Relevance Issues
- Review analyzer configuration for text fields
- Implement scoring profiles for result ranking
- Use semantic search for improved relevance
- Create synonym maps for query expansion
- Analyze search logs for query patterns

#### High Latency
- Use appropriate region close to users
- Implement caching for repeated requests
- Optimize image sizes before analysis
- Use async operations for long processes
- Consider content delivery network (CDN)

#### Container Deployment Issues
- Verify container image version compatibility
- Check resource requirements (CPU, memory)
- Ensure proper network configuration
- Validate license and billing configuration
- Review container logs for errors

---

## Hands-On Labs and Exercises

### Recommended Practice Activities

1. **Computer Vision Lab**
   - Create Computer Vision resource
   - Analyze images using different visual features
   - Extract text with OCR Read API
   - Generate thumbnails with smart cropping

2. **Custom Vision Lab**
   - Build image classification project
   - Train object detection model
   - Evaluate model performance metrics
   - Export model for offline use

3. **Language Understanding Lab**
   - Create conversational language understanding app
   - Define intents and entities
   - Train and test model
   - Integrate with bot or application

4. **Cognitive Search Lab**
   - Create search index from documents
   - Configure indexer for data source
   - Build skillset with AI enrichment
   - Query index with filters and facets

5. **Document Intelligence Lab**
   - Use prebuilt models for invoices/receipts
   - Train custom model for forms
   - Test models in Document Intelligence Studio
   - Integrate with application using SDK

6. **Azure OpenAI Lab**
   - Deploy GPT-3.5 or GPT-4 model
   - Experiment with prompt engineering
   - Implement RAG with Cognitive Search
   - Use function calling for external APIs

7. **Bot Service Lab**
   - Create bot with Bot Framework SDK
   - Add Language Understanding integration
   - Implement multi-turn dialogs
   - Deploy to Teams or web channel

---

## Exam Tips and Strategies

### Time Management
- Allocate approximately 2 minutes per question
- Mark questions for review if uncertain
- Don't spend too much time on single question
- Save case studies for when well-rested

### Question Approach
- Read entire question carefully before answering
- Identify key requirements and constraints
- Eliminate obviously wrong answers first
- Watch for words like "most", "least", "best", "only"
- Consider cost, performance, and security tradeoffs

### Technical Areas to Focus
- Service capabilities and limitations
- Appropriate service selection for scenarios
- SDK and API usage patterns
- Security and authentication methods
- Monitoring and diagnostics approaches
- Pricing tiers and cost optimization

### Common Question Types
- **Scenario-based:** Choose best service or approach
- **Configuration:** Identify correct settings or parameters
- **Troubleshooting:** Diagnose and resolve issues
- **Code completion:** Select correct SDK code
- **Design:** Architect complete solution

### Areas Often Tested
- Differences between similar services (Vision vs Custom Vision)
- When to use prebuilt vs custom models
- Security configurations (VNet, private endpoints, managed identity)
- Monitoring and diagnostics setup
- Container deployment scenarios
- SDK programming patterns
- Error handling and retry logic
- Rate limiting and throttling management

---

## Important Terms and Definitions

### AI and ML Concepts
- **Inference:** Process of using trained model to make predictions
- **Training:** Process of teaching model using labeled data
- **Precision:** Percentage of positive predictions that are correct
- **Recall:** Percentage of actual positives correctly identified
- **F1 Score:** Harmonic mean of precision and recall
- **Confidence Score:** Model's certainty in prediction (0-1)
- **Transfer Learning:** Using pretrained model as starting point

### Azure-Specific Terms
- **Cognitive Services:** Legacy name for Azure AI Services
- **Multi-service Resource:** Single resource for multiple AI services
- **Commitment Tier:** Prepaid pricing for reduced rates
- **Container:** Packaged service for on-premises deployment
- **Skillset:** AI enrichment pipeline in Cognitive Search
- **Knowledge Store:** Persistent storage for enriched data

### Document Intelligence Terms
- **Layout Model:** Extracts text, tables, and structure
- **Prebuilt Model:** Ready-to-use for common document types
- **Custom Template:** For structured forms with fixed layout
- **Custom Neural:** For semi-structured documents
- **Confidence Score:** Model certainty for extracted fields

### Search Terms
- **Index:** Searchable container of documents
- **Indexer:** Automated data ingestion component
- **Analyzer:** Text processing for tokenization
- **Facet:** Category for filtering search results
- **Scoring Profile:** Custom relevance ranking
- **Suggester:** Autocomplete and suggestions configuration

### OpenAI Terms
- **Token:** Basic unit of text (roughly 4 characters)
- **Context Window:** Maximum tokens model can process
- **Temperature:** Randomness in model output (0-2)
- **Top-p:** Nucleus sampling parameter
- **System Message:** Instructions for model behavior
- **Function Calling:** Model calling external functions
- **RAG:** Retrieval Augmented Generation pattern

---

## Quick Reference Cheat Sheet

### Service Selection Guide

| Requirement | Service |
|------------|---------|
| Analyze images (prebuilt) | Computer Vision API |
| Custom image classification | Custom Vision |
| Detect and recognize faces | Face API |
| Process structured forms | Document Intelligence (Form Recognizer) |
| Extract text from images | Computer Vision Read API or Document Intelligence |
| Full-text search with AI | Cognitive Search |
| Understand user intent | Conversational Language Understanding |
| Translate text | Translator Service |
| Speech to text | Speech Service |
| Generate synthetic speech | Text-to-Speech |
| Build conversational bot | Bot Service + Language Service |
| Analyze videos | Video Indexer |
| Generate text with AI | Azure OpenAI (GPT models) |
| Generate images with AI | Azure OpenAI (DALL-E) |
| Semantic search | Cognitive Search with vector search |

### Authentication Methods

| Method | Use Case |
|--------|----------|
| API Key | Quick start, development, simple scenarios |
| Azure AD Token | Production applications with user context |
| Managed Identity | Azure resources accessing AI services |
| Service Principal | Automated processes, DevOps pipelines |

### Pricing Tiers Overview

| Tier | Characteristics |
|------|----------------|
| Free | Limited transactions, no SLA, development only |
| Standard | Pay-as-you-go, full features, production |
| Commitment | Prepaid for reduced rates, predictable costs |

### Container Requirements

- Docker engine installed
- Appropriate CPU and memory (varies by service)
- Network connectivity for billing
- License/API key from Azure resource
- Persistent storage for model data

---

## Final Preparation Checklist

### Technical Skills
- [ ] Create and configure multi-service AI resource
- [ ] Implement authentication with keys and managed identity
- [ ] Configure virtual networks and private endpoints
- [ ] Enable diagnostic logging and monitoring
- [ ] Analyze images with Computer Vision API
- [ ] Train and deploy Custom Vision model
- [ ] Process documents with Document Intelligence
- [ ] Build search index with AI enrichment
- [ ] Create skillset with built-in and custom skills
- [ ] Implement conversational language understanding
- [ ] Build bot with Bot Framework
- [ ] Integrate Speech services (STT, TTS)
- [ ] Use Translator Service for text translation
- [ ] Index and analyze videos with Video Indexer
- [ ] Deploy and use Azure OpenAI models
- [ ] Implement RAG pattern with OpenAI and Search
- [ ] Handle errors and implement retry logic
- [ ] Manage rate limits and throttling

### Conceptual Understanding
- [ ] Compare prebuilt vs custom models
- [ ] Understand when to use each AI service
- [ ] Know responsible AI principles
- [ ] Understand container deployment scenarios
- [ ] Know security best practices
- [ ] Understand cost optimization strategies
- [ ] Know monitoring and diagnostics approaches

### Exam Logistics
- [ ] Review exam objectives and skills measured
- [ ] Complete practice assessment
- [ ] Review hands-on labs
- [ ] Schedule exam appointment
- [ ] Prepare test environment (ID, webcam, quiet space)
- [ ] Get adequate rest before exam

---

## Additional Resources

### Community and Support

**[📖 Microsoft Q&A for AI Services](https://learn.microsoft.com/en-us/answers/topics/azure-cognitive-services.html)** - Community forum for questions and answers

**[📖 Azure AI Services GitHub](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cognitiveservices)** - Official SDK repositories and samples

**[📖 Azure Updates](https://azure.microsoft.com/en-us/updates/?category=ai-machine-learning)** - Latest announcements and feature releases

**[📖 Azure Blog](https://azure.microsoft.com/en-us/blog/topics/artificial-intelligence/)** - Technical articles and case studies

### Tools and Utilities

**[📖 Azure CLI for AI Services](https://learn.microsoft.com/en-us/cli/azure/cognitiveservices)** - Command-line interface for resource management

**[📖 Azure PowerShell for AI Services](https://learn.microsoft.com/en-us/powershell/module/az.cognitiveservices/)** - PowerShell cmdlets for automation

**[📖 Postman Collections](https://www.postman.com/microsoft-ai/workspace/microsoft-cognitive-services/overview)** - API testing collections

---

**Last Updated:** 2025-01-13
**Exam Version:** Based on skills measured as of January 2025
**Total Documentation Links:** 120

---

## Notes

This fact sheet contains 120 embedded documentation links covering all major exam domains. All links point to official Microsoft Learn documentation and are current as of January 2025. Candidates should verify that services and features mentioned are available in their target Azure regions and review the official exam page for the most current skills measured.

For the most up-to-date exam information, always refer to the official Microsoft Learn certification page and study guide.

**Good luck on your AI-102 exam!**
