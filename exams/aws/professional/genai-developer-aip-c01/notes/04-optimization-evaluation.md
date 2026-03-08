# Optimization and Evaluation of Generative AI Solutions

**📖 [Amazon Bedrock Model Customization](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)** - Fine-tuning and continued pre-training on AWS

## 📋 Model Customization

### Fine-Tuning vs Continued Pre-Training

**📖 [Model Customization Overview](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)** - Understanding customization options

| Aspect | Fine-Tuning | Continued Pre-Training |
|--------|-------------|----------------------|
| **Purpose** | Adapt model behavior for specific tasks | Expand model's domain knowledge |
| **Data Format** | Instruction-response pairs (JSONL) | Unlabeled domain text |
| **Data Volume** | Hundreds to thousands of examples | Large corpus of domain text |
| **Training Time** | Hours | Hours to days |
| **Cost** | Per training token + storage | Per training token + storage |
| **Use Case** | Task-specific behavior, output format | Industry jargon, proprietary knowledge |
| **Models** | Titan, Llama, Cohere (select models) | Titan, Llama (select models) |

### Fine-Tuning on Amazon Bedrock

**📖 [Fine-Tuning a Model](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models-ft.html)** - Step-by-step fine-tuning guide

**Training Data Format (JSONL):**
```json
{"prompt": "Classify the sentiment: 'I love this product!'", "completion": "Positive"}
{"prompt": "Classify the sentiment: 'Terrible experience, would not recommend.'", "completion": "Negative"}
{"prompt": "Classify the sentiment: 'The product is okay, nothing special.'", "completion": "Neutral"}
```

**For Chat/Instruction Models (Llama, Claude-compatible format):**
```json
{"system": "You are a customer support agent.", "messages": [{"role": "user", "content": "How do I reset my password?"}, {"role": "assistant", "content": "To reset your password, go to Settings > Security > Reset Password. Enter your email and follow the instructions."}]}
{"system": "You are a customer support agent.", "messages": [{"role": "user", "content": "What is your return policy?"}, {"role": "assistant", "content": "We offer a 30-day return policy for all unused items in original packaging."}]}
```

**Fine-Tuning Configuration:**
```python
import boto3

bedrock = boto3.client('bedrock')

response = bedrock.create_model_customization_job(
    jobName='customer-support-fine-tune',
    customModelName='customer-support-model-v1',
    roleArn='arn:aws:iam::123456789012:role/BedrockFineTuneRole',
    baseModelIdentifier='amazon.titan-text-express-v1',
    trainingDataConfig={
        's3Uri': 's3://my-training-bucket/training-data/train.jsonl'
    },
    validationDataConfig={
        'validators': [{
            's3Uri': 's3://my-training-bucket/training-data/validation.jsonl'
        }]
    },
    outputDataConfig={
        's3Uri': 's3://my-training-bucket/output/'
    },
    hyperParameters={
        'epochCount': '3',
        'batchSize': '8',
        'learningRate': '0.00001',
        'learningRateWarmupSteps': '10'
    }
)
```

**Key Hyperparameters:**

| Parameter | Description | Guidance |
|-----------|-------------|----------|
| **Epochs** | Number of passes through training data | 1-10 (start with 3, watch for overfitting) |
| **Batch Size** | Samples processed per update | 4-32 (smaller for small datasets) |
| **Learning Rate** | Step size for weight updates | 1e-6 to 1e-4 (lower for fine-tuning) |
| **Warmup Steps** | Gradual increase in learning rate | 5-20% of total steps |

### Continued Pre-Training

**📖 [Continued Pre-Training](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models-cp.html)** - Domain adaptation

**Use Cases:**
- Teach the model industry-specific terminology (legal, medical, financial)
- Incorporate proprietary knowledge into model weights
- Improve performance on domain-specific language patterns

**Training Data:** Plain text documents in S3 (no instruction formatting needed)
```
# training_data.txt (or JSONL with "input" field)
The patient presented with acute myocardial infarction requiring immediate
percutaneous coronary intervention. The troponin levels were elevated at
15.2 ng/mL, indicating significant myocardial damage...
```

### When to Fine-Tune vs Use RAG vs Prompt Engineering

| Approach | Best When | Cost | Effort | Speed |
|----------|-----------|------|--------|-------|
| **Prompt Engineering** | Quick behavior adjustment | Lowest | Low | Immediate |
| **RAG** | Dynamic knowledge, factual grounding | Medium | Medium | Hours (setup) |
| **Fine-Tuning** | Specific task/format, consistent behavior | Higher | High | Hours-days |
| **Continued Pre-Training** | Domain vocabulary/knowledge | Highest | Highest | Days |

**Decision Framework:**
1. Start with **prompt engineering** (cheapest, fastest)
2. If knowledge needs to be current or traceable, add **RAG**
3. If model behavior/format needs fundamental change, consider **fine-tuning**
4. If model lacks domain language understanding, use **continued pre-training**

## 🎯 Prompt Engineering

**📖 [Prompt Engineering Guidelines](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html)** - AWS best practices

### Prompting Techniques

#### Zero-Shot Prompting
No examples provided; the model relies on its pre-trained knowledge.

```
Classify the following customer review as Positive, Negative, or Neutral.

Review: "The delivery was fast and the product quality exceeded my expectations."
Classification:
```

**Best For:** Tasks the model handles well without examples

#### Few-Shot Prompting
Include examples to guide model behavior and output format.

```
Classify customer reviews as Positive, Negative, or Neutral.

Review: "Absolutely love it! Best purchase ever."
Classification: Positive

Review: "Product broke after two days. Very disappointed."
Classification: Negative

Review: "It works fine, nothing remarkable."
Classification: Neutral

Review: "The shipping was delayed but the product quality is great."
Classification:
```

**Best For:** Specific output format, classification tasks, edge cases

#### Chain-of-Thought (CoT) Prompting
Guide the model to show step-by-step reasoning.

```
A customer wants to return an item purchased 45 days ago. Our policy allows
returns within 30 days. However, the item was defective upon arrival.

Think through this step by step:
1. Check the standard return window
2. Consider any exceptions for defective items
3. Determine the appropriate action
4. Provide the recommendation
```

**Best For:** Complex reasoning, math problems, multi-step analysis

#### System Prompts
Define the model's persona, behavior, and constraints.

```python
response = bedrock_runtime.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    system=[{
        "text": """You are a technical support specialist for AWS services.

        Rules:
        - Only answer questions about AWS services
        - Provide specific, actionable guidance
        - Include relevant AWS documentation links when helpful
        - If unsure, say so rather than guessing
        - Never share pricing information (direct users to aws.amazon.com/pricing)
        - Respond in the same language as the user's question"""
    }],
    messages=[
        {"role": "user", "content": [{"text": user_question}]}
    ]
)
```

#### Prompt Templates

```python
# Reusable prompt template with variable injection
SUMMARIZATION_TEMPLATE = """Summarize the following document in {num_sentences} sentences.
Focus on the key points and main conclusions.

Document:
{document_text}

Summary:"""

def summarize_document(document_text, num_sentences=3):
    prompt = SUMMARIZATION_TEMPLATE.format(
        document_text=document_text,
        num_sentences=num_sentences
    )
    response = bedrock_runtime.converse(
        modelId='anthropic.claude-3-sonnet-20240229-v1:0',
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 512, "temperature": 0.3}
    )
    return response['output']['message']['content'][0]['text']
```

### Prompt Engineering Best Practices

**Structure:**
- Be specific and explicit about the desired output
- Use delimiters to separate instructions from content (```, ---, XML tags)
- Specify the output format (JSON, bullet points, numbered list)
- Include constraints and boundaries clearly

**Performance:**
- Start simple, add complexity as needed
- Test prompts across multiple inputs to verify consistency
- Use temperature 0.0-0.3 for factual tasks, 0.7-1.0 for creative tasks
- Minimize token usage in prompts for cost efficiency

**Safety:**
- Include instructions to handle edge cases
- Add guardrails in the prompt ("If you don't know, say so")
- Test for prompt injection vulnerabilities
- Use Bedrock Guardrails for additional safety layers

## 📚 Model Evaluation

**📖 [Amazon Bedrock Model Evaluation](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html)** - Evaluating model performance

### Evaluation Types on Bedrock

| Type | Method | Best For |
|------|--------|----------|
| **Automatic Evaluation** | Built-in metrics computed automatically | Quick comparison, standard metrics |
| **Human Evaluation** | Human reviewers rate model outputs | Subjective quality, nuanced assessment |
| **Model Comparison** | Side-by-side comparison of models | Choosing between models for a task |

### Text Generation Metrics

**📖 [Evaluation Metrics](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation-automatic.html)** - Understanding evaluation metrics

| Metric | What It Measures | Range | Best For |
|--------|-----------------|-------|----------|
| **BLEU** | N-gram overlap with reference text | 0-1 (higher = better) | Translation quality |
| **ROUGE-1** | Unigram overlap with reference | 0-1 (higher = better) | Summarization recall |
| **ROUGE-2** | Bigram overlap with reference | 0-1 (higher = better) | Summarization fluency |
| **ROUGE-L** | Longest common subsequence | 0-1 (higher = better) | Summarization overall |
| **BERTScore** | Semantic similarity via embeddings | 0-1 (higher = better) | Meaning preservation |
| **Perplexity** | Model confidence in predictions | Lower = better | Language model quality |
| **Accuracy** | Correct predictions / total | 0-1 (higher = better) | Classification tasks |
| **F1 Score** | Harmonic mean of precision & recall | 0-1 (higher = better) | Classification balance |

### RAG-Specific Evaluation Metrics

| Metric | What It Measures | Evaluates |
|--------|-----------------|-----------|
| **Faithfulness** | Is the answer supported by retrieved context? | Generation quality |
| **Answer Relevancy** | Does the answer address the question? | Generation quality |
| **Context Precision** | Are retrieved chunks relevant to the query? | Retrieval quality |
| **Context Recall** | Did retrieval find all relevant information? | Retrieval quality |
| **Answer Correctness** | Is the answer factually correct? | End-to-end quality |

### Running Model Evaluation on Bedrock

```python
bedrock = boto3.client('bedrock')

# Create an automatic evaluation job
response = bedrock.create_evaluation_job(
    jobName='model-comparison-eval',
    roleArn='arn:aws:iam::123456789012:role/BedrockEvalRole',
    evaluationConfig={
        'automated': {
            'datasetMetricConfigs': [
                {
                    'taskType': 'Summarization',
                    'dataset': {
                        'name': 'summarization-dataset',
                        'datasetLocation': {
                            's3Uri': 's3://eval-bucket/datasets/summarization.jsonl'
                        }
                    },
                    'metricNames': ['Rouge', 'BertScore']
                }
            ]
        }
    },
    inferenceConfig={
        'models': [
            {
                'bedrockModel': {
                    'modelIdentifier': 'anthropic.claude-3-sonnet-20240229-v1:0',
                    'inferenceParams': '{"maxTokens": 512, "temperature": 0.3}'
                }
            },
            {
                'bedrockModel': {
                    'modelIdentifier': 'anthropic.claude-3-haiku-20240307-v1:0',
                    'inferenceParams': '{"maxTokens": 512, "temperature": 0.3}'
                }
            }
        ]
    },
    outputDataConfig={
        's3Uri': 's3://eval-bucket/results/'
    }
)
```

### Human Evaluation Workflow

```python
# Create a human evaluation job
response = bedrock.create_evaluation_job(
    jobName='human-eval-chatbot',
    roleArn='arn:aws:iam::123456789012:role/BedrockEvalRole',
    evaluationConfig={
        'human': {
            'humanWorkflowConfig': {
                'flowDefinitionArn': 'arn:aws:sagemaker:us-east-1:123456789012:flow-definition/human-eval-flow',
                'instructions': 'Rate each response on helpfulness, accuracy, and safety (1-5 scale).'
            },
            'datasetMetricConfigs': [
                {
                    'taskType': 'General',
                    'dataset': {
                        'name': 'chatbot-test-set',
                        'datasetLocation': {
                            's3Uri': 's3://eval-bucket/datasets/chatbot-test.jsonl'
                        }
                    },
                    'metricNames': ['Helpfulness', 'Accuracy', 'Safety']
                }
            ]
        }
    },
    inferenceConfig={
        'models': [{
            'bedrockModel': {
                'modelIdentifier': 'anthropic.claude-3-sonnet-20240229-v1:0'
            }
        }]
    },
    outputDataConfig={
        's3Uri': 's3://eval-bucket/human-eval-results/'
    }
)
```

## 🎯 RLHF (Reinforcement Learning from Human Feedback)

### RLHF Process Overview

```
Step 1: Supervised Fine-Tuning (SFT)
  → Train model on high-quality instruction-response pairs
  ↓
Step 2: Reward Model Training
  → Collect human preferences (compare response pairs)
  → Train a reward model to score responses
  ↓
Step 3: Policy Optimization (PPO)
  → Optimize the model to maximize reward model scores
  → Balance between reward and staying close to original model (KL divergence)
  ↓
Step 4: Evaluation
  → Human evaluation of aligned model
  → Iterate as needed
```

### Key RLHF Concepts

| Concept | Description |
|---------|-------------|
| **Reward Model** | Predicts human preference scores for model outputs |
| **PPO (Proximal Policy Optimization)** | RL algorithm that updates model weights to maximize reward |
| **KL Divergence Penalty** | Prevents model from diverging too far from base model |
| **Human Preferences** | Pairwise comparisons: "Which response is better?" |
| **Alignment** | Making model behavior match human values and intentions |

### RLHF vs Other Alignment Techniques

| Technique | Complexity | Data Required | Best For |
|-----------|-----------|---------------|----------|
| **RLHF** | High | Preference data | Deep alignment with human values |
| **DPO (Direct Preference Optimization)** | Medium | Preference data | Simpler alignment without reward model |
| **Constitutional AI (CAI)** | Medium | Principles/rules | Self-guided alignment |
| **Instruction Tuning** | Low | Instruction-response pairs | Task-specific behavior |

## 📋 Hallucination Detection and Mitigation

### Types of Hallucinations

| Type | Description | Example |
|------|-------------|---------|
| **Factual** | States incorrect facts | "AWS was founded in 2010" |
| **Fabrication** | Invents non-existent entities | "The AWS Aurora Quantum service..." |
| **Inconsistency** | Contradicts itself within a response | "The limit is 100... the limit is 500" |
| **Outdated** | Uses outdated information | Citing deprecated service features |
| **Attribution** | Incorrect source citations | "According to AWS docs..." (wrong reference) |

### Mitigation Strategies

1. **RAG (Retrieval Augmented Generation)**
   - Ground responses in verified source documents
   - Most effective for knowledge-based hallucinations

2. **Guardrails Contextual Grounding**
   - Validate that responses are supported by provided context
   - Set grounding threshold to filter ungrounded responses

3. **Prompt Engineering**
   - Instruct model: "Only answer based on provided context"
   - Request citations: "Cite the source for each claim"
   - Add uncertainty: "If unsure, say you don't know"

4. **Temperature Control**
   - Lower temperature (0.0-0.3) for factual tasks
   - Reduces randomness and creative hallucinations

5. **Human-in-the-Loop**
   - Flag low-confidence responses for human review
   - Implement feedback loops for continuous improvement

6. **Response Validation**
   - Cross-check generated responses against knowledge base
   - Use a second model to verify factual claims

## Exam Tips

### Key Concepts to Remember
- Start with prompt engineering, then RAG, then fine-tuning (escalating cost/effort)
- Fine-tuning changes model behavior; RAG adds knowledge without retraining
- Continued pre-training teaches domain vocabulary; fine-tuning teaches task behavior
- BLEU for translation, ROUGE for summarization, BERTScore for semantic similarity
- Lower temperature = more deterministic, less hallucination
- Guardrails contextual grounding checks response faithfulness to context
- RLHF aligns model with human preferences using a reward model
- Bedrock Model Evaluation supports both automatic and human evaluation

### Common Exam Traps
- ❌ Choosing fine-tuning when prompt engineering solves the problem (overcomplicating)
- ❌ Using high temperature for factual Q&A tasks (increases hallucinations)
- ❌ Confusing BLEU (translation) with ROUGE (summarization)
- ❌ Ignoring validation data when fine-tuning (risk of overfitting)
- ❌ Not considering RAG for reducing hallucinations
- ❌ Overlooking Bedrock Model Evaluation for comparing model performance
- ❌ Fine-tuning to add knowledge that changes frequently (use RAG instead)
