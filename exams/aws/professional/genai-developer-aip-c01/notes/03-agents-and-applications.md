# Amazon Bedrock Agents, Action Groups, Guardrails, and Application Patterns

**📖 [Amazon Bedrock Agents Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)** - Complete guide to building autonomous agents

## 📋 Amazon Bedrock Agents

### What Are Bedrock Agents?

Bedrock Agents are autonomous AI systems that can reason, plan, and execute multi-step tasks by combining foundation model capabilities with external tools and knowledge. Agents break down user requests into steps, decide which actions to take, invoke APIs, and synthesize responses.

**📖 [How Agents Work](https://docs.aws.amazon.com/bedrock/latest/userguide/agents-how.html)** - Agent architecture and reasoning

### Agent Architecture

```
User Request
  ↓
Bedrock Agent (Foundation Model)
  ↓ (reasoning + planning)
┌─────────────────────────────────────┐
│  Decide Next Action                 │
│  ↓                                  │
│  Action Group 1 → Lambda → API      │
│  Action Group 2 → Lambda → Database │
│  Knowledge Base → Vector Store      │
│  ↓                                  │
│  Synthesize Results                 │
│  ↓                                  │
│  More steps needed? → Loop back     │
└─────────────────────────────────────┘
  ↓
Final Response to User
```

### Key Components

**Agent Foundation Model:**
- The FM that powers the agent's reasoning (e.g., Claude 3 Sonnet)
- Interprets user requests and decides on actions
- Generates the final response from collected information

**Agent Instructions:**
- Natural language description of the agent's purpose and behavior
- Defines the agent's persona, capabilities, and constraints
- Acts as the system prompt guiding the agent's decisions

**Action Groups:**
- Define the tools/APIs the agent can invoke
- Each action group maps to a Lambda function
- Described by an OpenAPI schema or function definitions
- Agent decides which action group to call based on user intent

**Knowledge Bases:**
- Attach one or more Knowledge Bases for RAG
- Agent automatically retrieves context when needed
- Provides grounded information for responses

**Session Management:**
- Maintains conversation state across turns
- Session attributes persist context
- Prompt session attributes for dynamic context injection

### Creating an Agent

**📖 [Create a Bedrock Agent](https://docs.aws.amazon.com/bedrock/latest/userguide/agents-create.html)** - Step-by-step guide

**Agent Configuration:**
```python
import boto3

bedrock_agent = boto3.client('bedrock-agent')

# Create an agent
response = bedrock_agent.create_agent(
    agentName='customer-service-agent',
    foundationModel='anthropic.claude-3-sonnet-20240229-v1:0',
    instruction="""You are a customer service agent for an e-commerce company.
    You can look up order status, process returns, and answer product questions.
    Always be polite and professional. If you cannot help, escalate to a human agent.
    Never share sensitive customer data like full credit card numbers.""",
    agentResourceRoleArn='arn:aws:iam::123456789012:role/AmazonBedrockAgentRole',
    idleSessionTTLInSeconds=1800
)
```

## 🎯 Action Groups

**📖 [Action Groups](https://docs.aws.amazon.com/bedrock/latest/userguide/agents-action-create.html)** - Defining agent actions

### Defining Action Groups with OpenAPI Schema

```yaml
# openapi-schema.yaml
openapi: 3.0.0
info:
  title: Order Management API
  version: 1.0.0
paths:
  /getOrderStatus:
    get:
      summary: Get the status of a customer order
      description: Retrieves the current status and tracking information for an order
      operationId: getOrderStatus
      parameters:
        - name: orderId
          in: query
          required: true
          schema:
            type: string
          description: The unique order identifier
      responses:
        '200':
          description: Order status retrieved successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  orderId:
                    type: string
                  status:
                    type: string
                    enum: [pending, shipped, delivered, cancelled]
                  trackingNumber:
                    type: string
                  estimatedDelivery:
                    type: string

  /processReturn:
    post:
      summary: Initiate a return for an order
      description: Processes a return request for a specific order
      operationId: processReturn
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - orderId
                - reason
              properties:
                orderId:
                  type: string
                  description: The order to return
                reason:
                  type: string
                  description: Reason for the return
      responses:
        '200':
          description: Return initiated successfully
```

### Lambda Action Handler

**📖 [Lambda Functions for Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents-lambda.html)** - Implementing action handlers

```python
import json
import boto3

dynamodb = boto3.resource('dynamodb')
orders_table = dynamodb.Table('Orders')

def lambda_handler(event, context):
    """Lambda function to handle Bedrock Agent action group requests."""

    # Extract action details from the agent
    action_group = event.get('actionGroup')
    api_path = event.get('apiPath')
    http_method = event.get('httpMethod')
    parameters = event.get('parameters', [])
    request_body = event.get('requestBody', {})

    # Route to appropriate handler
    if api_path == '/getOrderStatus' and http_method == 'GET':
        order_id = next(p['value'] for p in parameters if p['name'] == 'orderId')
        result = get_order_status(order_id)

    elif api_path == '/processReturn' and http_method == 'POST':
        body = request_body.get('content', {}).get('application/json', {}).get('properties', [])
        order_id = next(p['value'] for p in body if p['name'] == 'orderId')
        reason = next(p['value'] for p in body if p['name'] == 'reason')
        result = process_return(order_id, reason)

    else:
        result = {"error": "Unknown action"}

    # Return response in the format Bedrock Agents expects
    return {
        'messageVersion': '1.0',
        'response': {
            'actionGroup': action_group,
            'apiPath': api_path,
            'httpMethod': http_method,
            'httpStatusCode': 200,
            'responseBody': {
                'application/json': {
                    'body': json.dumps(result)
                }
            }
        }
    }

def get_order_status(order_id):
    response = orders_table.get_item(Key={'orderId': order_id})
    item = response.get('Item', {})
    return {
        'orderId': order_id,
        'status': item.get('status', 'not found'),
        'trackingNumber': item.get('trackingNumber', 'N/A'),
        'estimatedDelivery': item.get('estimatedDelivery', 'N/A')
    }

def process_return(order_id, reason):
    orders_table.update_item(
        Key={'orderId': order_id},
        UpdateExpression='SET #s = :status, returnReason = :reason',
        ExpressionAttributeNames={'#s': 'status'},
        ExpressionAttributeValues={':status': 'return_initiated', ':reason': reason}
    )
    return {
        'orderId': order_id,
        'returnStatus': 'initiated',
        'message': f'Return initiated for order {order_id}'
    }
```

### Function Definition (Alternative to OpenAPI)

```python
# Define action group with function definitions instead of OpenAPI
response = bedrock_agent.create_agent_action_group(
    agentId='AGENT_ID',
    agentVersion='DRAFT',
    actionGroupName='order-management',
    actionGroupExecutor={
        'lambda': 'arn:aws:lambda:us-east-1:123456789012:function:order-handler'
    },
    functionSchema={
        'functions': [
            {
                'name': 'getOrderStatus',
                'description': 'Get the current status of a customer order',
                'parameters': {
                    'orderId': {
                        'description': 'The unique order identifier',
                        'type': 'string',
                        'required': True
                    }
                }
            },
            {
                'name': 'processReturn',
                'description': 'Initiate a return for a customer order',
                'parameters': {
                    'orderId': {
                        'description': 'The order to return',
                        'type': 'string',
                        'required': True
                    },
                    'reason': {
                        'description': 'Reason for the return',
                        'type': 'string',
                        'required': True
                    }
                }
            }
        ]
    }
)
```

### Invoking an Agent

**📖 [InvokeAgent API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_InvokeAgent.html)** - Agent invocation reference

```python
bedrock_agent_runtime = boto3.client('bedrock-agent-runtime')

# Invoke the agent
response = bedrock_agent_runtime.invoke_agent(
    agentId='AGENT_ID',
    agentAliasId='AGENT_ALIAS_ID',
    sessionId='unique-session-id',
    inputText='What is the status of order ORD-12345?',
    enableTrace=True  # Enable trace for debugging
)

# Process streaming response
completion = ""
for event in response['completion']:
    if 'chunk' in event:
        chunk_data = event['chunk']
        completion += chunk_data['bytes'].decode('utf-8')

    # Trace events show agent reasoning
    if 'trace' in event:
        trace = event['trace']['trace']
        if 'orchestrationTrace' in trace:
            print(f"Agent reasoning: {trace['orchestrationTrace']}")

print(f"Agent response: {completion}")
```

## 📚 Amazon Bedrock Guardrails

**📖 [Bedrock Guardrails Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)** - Content safety and filtering

### What Are Guardrails?

Guardrails provide configurable safeguards for GenAI applications. They filter harmful content, detect PII, block denied topics, and validate response grounding. Guardrails can be applied to any Bedrock model invocation.

### Guardrail Components

**📖 [Guardrail Configuration](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-create.html)** - Setting up guardrails

| Component | Purpose | Configuration |
|-----------|---------|---------------|
| **Content Filters** | Block harmful content categories | Hate, insults, sexual, violence, misconduct (adjustable thresholds) |
| **Denied Topics** | Block specific subject matter | Define topics to avoid (up to 30 per guardrail) |
| **Word Filters** | Block specific words/phrases | Custom word lists, profanity filter |
| **PII Filters** | Detect and handle personal data | Detect/redact: names, emails, phone numbers, SSN, etc. |
| **Contextual Grounding** | Validate response grounding | Check if response is supported by provided context |

### Content Filter Configuration

```python
bedrock = boto3.client('bedrock')

response = bedrock.create_guardrail(
    name='production-guardrail',
    description='Content safety guardrail for production chatbot',
    contentPolicyConfig={
        'filtersConfig': [
            {'type': 'SEXUAL', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'VIOLENCE', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'HATE', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'INSULTS', 'inputStrength': 'MEDIUM', 'outputStrength': 'HIGH'},
            {'type': 'MISCONDUCT', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'}
        ]
    },
    topicPolicyConfig={
        'topicsConfig': [
            {
                'name': 'investment-advice',
                'definition': 'Providing specific investment recommendations or financial advice',
                'examples': [
                    'Should I buy this stock?',
                    'What cryptocurrency should I invest in?'
                ],
                'type': 'DENY'
            },
            {
                'name': 'medical-diagnosis',
                'definition': 'Diagnosing medical conditions or prescribing treatments',
                'examples': [
                    'What disease do I have based on these symptoms?',
                    'Should I take this medication?'
                ],
                'type': 'DENY'
            }
        ]
    },
    sensitiveInformationPolicyConfig={
        'piiEntitiesConfig': [
            {'type': 'EMAIL', 'action': 'ANONYMIZE'},
            {'type': 'PHONE', 'action': 'ANONYMIZE'},
            {'type': 'US_SOCIAL_SECURITY_NUMBER', 'action': 'BLOCK'},
            {'type': 'CREDIT_DEBIT_CARD_NUMBER', 'action': 'BLOCK'},
            {'type': 'NAME', 'action': 'ANONYMIZE'}
        ],
        'regexesConfig': [
            {
                'name': 'internal-id-pattern',
                'description': 'Block internal employee IDs',
                'pattern': 'EMP-[0-9]{6}',
                'action': 'BLOCK'
            }
        ]
    },
    contextualGroundingPolicyConfig={
        'filtersConfig': [
            {'type': 'GROUNDING', 'threshold': 0.7},
            {'type': 'RELEVANCE', 'threshold': 0.7}
        ]
    },
    blockedInputMessaging='I cannot process this request due to content policy.',
    blockedOutputMessaging='I cannot provide this response due to content policy.'
)
```

### Applying Guardrails to Model Invocation

```python
# Apply guardrail to InvokeModel
response = bedrock_runtime.invoke_model(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "messages": [{"role": "user", "content": user_input}]
    }),
    guardrailIdentifier='guardrail-id',
    guardrailVersion='1'
)

# Apply guardrail to Converse API
response = bedrock_runtime.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[{"role": "user", "content": [{"text": user_input}]}],
    guardrailConfig={
        "guardrailIdentifier": "guardrail-id",
        "guardrailVersion": "1"
    }
)
```

## 🎯 GenAI Application Patterns

### Pattern 1: Conversational Chatbot

**📖 [Building Chatbots with Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html)** - Multi-turn conversation

```
User → API Gateway (WebSocket) → Lambda → Bedrock (Converse API)
                                    ↕
                              DynamoDB (Session/History)
                                    ↕
                              Guardrails (Content Safety)
```

**Key Design Decisions:**
- Use Converse API for unified multi-turn conversation management
- Store conversation history in DynamoDB for persistence
- Apply Guardrails for content safety
- Use streaming for better user experience
- Implement session timeout and cleanup

### Pattern 2: Document Processing Pipeline

```
Documents → S3 → EventBridge → Step Functions Workflow
                                    ↓
                              Step 1: Textract (Extract text from PDF/images)
                                    ↓
                              Step 2: Bedrock (Summarize, classify, extract entities)
                                    ↓
                              Step 3: Bedrock (Generate embeddings)
                                    ↓
                              Step 4: OpenSearch (Index for search)
                                    ↓
                              Step 5: DynamoDB (Store metadata)
                                    ↓
                              Step 6: SNS (Notify completion)
```

**📖 [AWS Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/)** - Workflow orchestration

### Pattern 3: Code Assistant

```
Developer → IDE Plugin → API Gateway → Lambda
                                          ↓
                                    Bedrock (Claude 3.5 Sonnet)
                                          ↓
                                    Code Suggestion / Review / Explanation
```

**Amazon Q Developer Integration:**
- IDE plugins for VS Code, JetBrains, CLI
- Inline code suggestions
- Code transformation and modernization
- Security vulnerability detection
- Unit test generation

**📖 [Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/)** - AI coding assistant

### Pattern 4: Multi-Agent Collaboration

```
Supervisor Agent
  ↓
┌─────────────────────────────────────┐
│  Research Agent → Knowledge Base    │
│  Analysis Agent → Data APIs         │
│  Writing Agent → Output Generation  │
└─────────────────────────────────────┘
  ↓
Supervisor synthesizes final response
```

**Implementation with Step Functions:**
```python
# Step Functions state machine for multi-agent orchestration
{
    "StartAt": "ResearchPhase",
    "States": {
        "ResearchPhase": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:research-agent",
            "Next": "AnalysisPhase"
        },
        "AnalysisPhase": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:analysis-agent",
            "Next": "WritingPhase"
        },
        "WritingPhase": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:writing-agent",
            "End": true
        }
    }
}
```

### Pattern 5: Human-in-the-Loop

```
User Query → Bedrock Agent → Generate Response
                                  ↓
                            Confidence Check
                           /              \
                    High Confidence    Low Confidence
                          ↓                  ↓
                    Return Response    SNS → Human Reviewer
                                              ↓
                                        Approve/Edit
                                              ↓
                                        Return to User
```

**Implementation with Step Functions:**
- Use Step Functions callback pattern for human approval
- SNS or SQS to notify human reviewers
- Task token to resume workflow after approval
- Timeout handling for unresponsive reviewers

## 📋 Multi-Turn Conversation Management

### Conversation History with DynamoDB

```python
import boto3
import json
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
conversations_table = dynamodb.Table('Conversations')

def store_message(session_id, role, content):
    """Store a conversation message in DynamoDB."""
    conversations_table.put_item(
        Item={
            'sessionId': session_id,
            'timestamp': datetime.utcnow().isoformat(),
            'role': role,
            'content': content
        }
    )

def get_conversation_history(session_id, max_messages=20):
    """Retrieve conversation history for a session."""
    response = conversations_table.query(
        KeyConditionExpression='sessionId = :sid',
        ExpressionAttributeValues={':sid': session_id},
        ScanIndexForward=True,  # Chronological order
        Limit=max_messages
    )
    return [
        {"role": item['role'], "content": [{"text": item['content']}]}
        for item in response['Items']
    ]

def chat_with_history(session_id, user_message):
    """Send a message with conversation history to Bedrock."""
    # Get history
    history = get_conversation_history(session_id)

    # Add current message
    history.append({
        "role": "user",
        "content": [{"text": user_message}]
    })

    # Invoke Bedrock with full history
    bedrock_runtime = boto3.client('bedrock-runtime')
    response = bedrock_runtime.converse(
        modelId='anthropic.claude-3-sonnet-20240229-v1:0',
        messages=history,
        inferenceConfig={"maxTokens": 1024, "temperature": 0.7}
    )

    assistant_message = response['output']['message']['content'][0]['text']

    # Store both messages
    store_message(session_id, 'user', user_message)
    store_message(session_id, 'assistant', assistant_message)

    return assistant_message
```

## Exam Tips

### Key Concepts to Remember
- Agents = FM + Action Groups + Knowledge Bases (autonomous multi-step reasoning)
- Action groups require Lambda functions and OpenAPI schemas (or function definitions)
- Guardrails apply to both input and output (bidirectional filtering)
- Guardrails support: content filters, denied topics, PII, word filters, grounding
- Agents maintain session state across multiple turns
- Step Functions orchestrate complex multi-step GenAI workflows
- Converse API is the unified conversation interface across all Bedrock models
- DynamoDB is ideal for conversation history storage (low latency, scalable)
- Amazon Q Developer is the AI coding assistant (not for general GenAI apps)

### Common Exam Traps
- ❌ Confusing Agents (autonomous reasoning) with Knowledge Bases (retrieval only)
- ❌ Forgetting that action groups need Lambda functions as handlers
- ❌ Not applying Guardrails when content safety is required
- ❌ Using complex custom orchestration when Bedrock Agents suffice
- ❌ Ignoring session management for multi-turn conversations
- ❌ Overlooking Step Functions for complex GenAI workflow orchestration
- ❌ Choosing API Gateway REST when WebSocket is needed for streaming
