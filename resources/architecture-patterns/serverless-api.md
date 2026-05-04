# Serverless API Architecture

A comprehensive guide to building scalable, cost-effective serverless APIs using AWS Lambda, Azure Functions, and Google Cloud Functions.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Security Considerations](#security-considerations)
8. [Performance Optimization](#performance-optimization)
9. [Cost Estimates](#cost-estimates)
10. [Best Practices](#best-practices)
11. [Common Patterns](#common-patterns)
12. [Monitoring and Observability](#monitoring-and-observability)
13. [CI/CD for Serverless](#cicd-for-serverless)
14. [Common Pitfalls](#common-pitfalls)

---

## Architecture Overview

### What is Serverless API Architecture?

Serverless API architecture is a cloud-native approach to building APIs where:
- **No Server Management**: Cloud provider manages infrastructure
- **Pay-Per-Use**: Charged only for actual execution time
- **Auto-Scaling**: Automatically scales with demand
- **Event-Driven**: Functions triggered by events (HTTP, queues, streams)
- **Stateless**: Functions don't maintain state between invocations

### Core Components

1. **API Gateway**: HTTP endpoint management and routing
2. **Functions**: Serverless compute executing business logic
3. **Database**: Managed database services (DynamoDB, Cosmos DB, Firestore)
4. **Storage**: Object storage for files and assets
5. **Authentication**: Managed authentication services
6. **Event Bus**: Asynchronous event processing

### Benefits

- **Cost-Effective**: No idle capacity costs
- **Zero Administration**: No server patching or management
- **Infinite Scalability**: Scales automatically from zero to thousands
- **High Availability**: Built-in redundancy across availability zones
- **Fast Time-to-Market**: Focus on code, not infrastructure
- **Polyglot**: Use multiple languages in same application

### Use Cases

- RESTful APIs for mobile/web applications
- Microservices architecture
- Real-time data processing APIs
- IoT device backends
- Webhook handlers
- API aggregators/facades
- Event-driven workflows
- Chatbot backends

### When to Use Serverless

**Good Fit**:
- Variable or unpredictable traffic
- Rapid prototyping and MVPs
- Event-driven workloads
- Microservices architecture
- Infrequent batch processing
- APIs with clear request/response patterns

**Poor Fit**:
- Long-running processes (>15 minutes)
- Consistent high-volume traffic (may be more expensive)
- Applications requiring persistent connections (WebSockets)
- Legacy applications with tight coupling
- Workloads requiring specific hardware/kernel access

---

## Architecture Diagram Description

### High-Level Architecture

```mermaid
flowchart LR
  C[Clients] --> CDN[CDN<br/>optional]
  CDN --> AG[API gateway<br/>auth, rate limit, throttle]
  AG --> F1[Function: GET /orders]
  AG --> F2[Function: POST /orders]
  AG --> F3[Function: webhook handler]
  F1 --> DB[(Managed DB:<br/>DynamoDB / Cosmos / Firestore)]
  F2 --> DB
  F2 --> Q[Queue]
  Q --> WORKER[Worker function:<br/>async processing]
  WORKER --> DB
  WORKER --> S3[(Object storage)]
  F3 --> EB[Event bus]
```

```
                         [Clients/Users]
                                |
                                |
                    [CDN/Custom Domain] (optional)
                                |
                                |
                         [API Gateway]
                                |
            +-------------------+-------------------+
            |                   |                   |
            |                   |                   |
    [Lambda/Function 1]  [Lambda/Function 2]  [Lambda/Function 3]
        GET /users          POST /users         GET /users/:id
            |                   |                   |
            +-------------------+-------------------+
                                |
                    +-----------+-----------+
                    |                       |
              [NoSQL Database]        [Object Storage]
              (DynamoDB/Cosmos)       (S3/Blob/GCS)
                    |                       |
                    |                       |
              [Cache Layer]            [CDN Assets]
              (Redis/Memcached)
```

### Request Flow

```
1. Client makes HTTP request
   ↓
2. DNS resolves to API Gateway
   ↓
3. API Gateway validates request, checks auth
   ↓
4. Routes to appropriate Lambda function
   ↓
5. Lambda function executes (cold start if necessary)
   ↓
6. Function queries database or services
   ↓
7. Function processes data and formats response
   ↓
8. Response returned through API Gateway
   ↓
9. Client receives response
```

### Asynchronous Processing Pattern

```
[API Gateway] → [Lambda: API Handler]
                      ↓
                [Event Queue/Topic]
                      ↓
        +-------------+-------------+
        |                           |
[Lambda: Processor 1]     [Lambda: Processor 2]
        |                           |
        +-------------+-------------+
                      ↓
                [Database/Storage]
```

### Microservices Architecture

```
[API Gateway]
      |
      +-- /users     → [User Service Lambda] → [Users DB]
      |
      +-- /orders    → [Order Service Lambda] → [Orders DB] → [Event Bus]
      |
      +-- /payments  → [Payment Service Lambda] → [Payment DB] ← [Event Bus]
      |
      +-- /notifications → [Notification Lambda] → [Email Service]
```

---

## Component Breakdown

### API Gateway

#### Responsibilities
- HTTP request routing
- Request/response transformation
- Rate limiting and throttling
- Authentication and authorization
- Request validation
- CORS handling
- API versioning
- Caching responses

#### Features by Provider
- **AWS API Gateway**: REST, HTTP, WebSocket APIs
- **Azure API Management**: Full API lifecycle management
- **GCP API Gateway**: OpenAPI-based gateway

### Serverless Functions

#### Characteristics
- **Ephemeral**: Containers destroyed after execution
- **Stateless**: No guarantee of state preservation
- **Timeout Limits**: Max 15 min (AWS Lambda), 10 min (Azure), 9 min (GCP)
- **Memory Allocation**: 128 MB - 10 GB (varies by provider)
- **Cold Starts**: Initial latency when scaling from zero
- **Concurrent Executions**: Provider-specific limits

#### Execution Model
1. Request arrives at API Gateway
2. Gateway invokes function
3. If no warm container available, cold start occurs
4. Function executes code
5. Function returns response
6. Container may be reused for subsequent requests (warm)

### Managed Databases

#### NoSQL Options
- **AWS DynamoDB**: Key-value and document database
- **Azure Cosmos DB**: Multi-model globally distributed
- **GCP Firestore**: Document database with real-time sync
- **MongoDB Atlas**: Managed MongoDB (multi-cloud)

#### SQL Options
- **AWS RDS Proxy**: Connection pooling for Lambda
- **AWS Aurora Serverless**: Auto-scaling relational DB
- **Azure SQL Database Serverless**: Serverless SQL
- **GCP Cloud SQL**: Managed PostgreSQL/MySQL

### Storage

- **AWS S3**: Object storage with Lambda triggers
- **Azure Blob Storage**: Object storage with event triggers
- **GCP Cloud Storage**: Unified object storage

### Authentication

- **AWS Cognito**: User authentication and authorization
- **Azure AD B2C**: Identity management
- **GCP Identity Platform**: Authentication service
- **Auth0**: Third-party auth (multi-cloud)

### Caching

- **AWS ElastiCache**: Redis/Memcached managed service
- **Azure Cache for Redis**: Managed Redis
- **GCP Memorystore**: Redis and Memcached
- **API Gateway Caching**: Built-in response caching

---

## AWS Implementation

### Architecture Components

#### API Gateway Configuration

```yaml
# serverless.yml (Serverless Framework)
service: serverless-api-aws

provider:
  name: aws
  runtime: nodejs18.x
  region: us-east-1
  stage: ${opt:stage, 'dev'}

  environment:
    DYNAMODB_TABLE: ${self:service}-${self:provider.stage}
    BUCKET_NAME: ${self:service}-uploads-${self:provider.stage}

  iam:
    role:
      statements:
        - Effect: Allow
          Action:
            - dynamodb:Query
            - dynamodb:Scan
            - dynamodb:GetItem
            - dynamodb:PutItem
            - dynamodb:UpdateItem
            - dynamodb:DeleteItem
          Resource: "arn:aws:dynamodb:${self:provider.region}:*:table/${self:provider.environment.DYNAMODB_TABLE}"

functions:
  getUsers:
    handler: handlers/users.getAll
    events:
      - http:
          path: users
          method: get
          cors: true
          authorizer:
            type: COGNITO_USER_POOLS
            authorizerId: !Ref ApiGatewayAuthorizer

  getUser:
    handler: handlers/users.getOne
    events:
      - http:
          path: users/{id}
          method: get
          cors: true
          authorizer:
            type: COGNITO_USER_POOLS
            authorizerId: !Ref ApiGatewayAuthorizer

  createUser:
    handler: handlers/users.create
    events:
      - http:
          path: users
          method: post
          cors: true
          authorizer:
            type: COGNITO_USER_POOLS
            authorizerId: !Ref ApiGatewayAuthorizer

  updateUser:
    handler: handlers/users.update
    events:
      - http:
          path: users/{id}
          method: put
          cors: true
          authorizer:
            type: COGNITO_USER_POOLS
            authorizerId: !Ref ApiGatewayAuthorizer

  deleteUser:
    handler: handlers/users.delete
    events:
      - http:
          path: users/{id}
          method: delete
          cors: true
          authorizer:
            type: COGNITO_USER_POOLS
            authorizerId: !Ref ApiGatewayAuthorizer

resources:
  Resources:
    UsersTable:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: ${self:provider.environment.DYNAMODB_TABLE}
        AttributeDefinitions:
          - AttributeName: id
            AttributeType: S
          - AttributeName: email
            AttributeType: S
        KeySchema:
          - AttributeName: id
            KeyType: HASH
        GlobalSecondaryIndexes:
          - IndexName: EmailIndex
            KeySchema:
              - AttributeName: email
                KeyType: HASH
            Projection:
              ProjectionType: ALL
        BillingMode: PAY_PER_REQUEST
        StreamSpecification:
          StreamViewType: NEW_AND_OLD_IMAGES

    UploadsBucket:
      Type: AWS::S3::Bucket
      Properties:
        BucketName: ${self:provider.environment.BUCKET_NAME}
        CorsConfiguration:
          CorsRules:
            - AllowedOrigins:
                - '*'
              AllowedMethods:
                - GET
                - PUT
                - POST
                - DELETE
              AllowedHeaders:
                - '*'

    ApiGatewayAuthorizer:
      Type: AWS::ApiGateway::Authorizer
      Properties:
        Name: CognitoAuthorizer
        Type: COGNITO_USER_POOLS
        IdentitySource: method.request.header.Authorization
        RestApiId: !Ref ApiGatewayRestApi
        ProviderARNs:
          - !GetAtt UserPool.Arn

    UserPool:
      Type: AWS::Cognito::UserPool
      Properties:
        UserPoolName: ${self:service}-user-pool
        UsernameAttributes:
          - email
        AutoVerifiedAttributes:
          - email
        Schema:
          - Name: email
            Required: true
            Mutable: false
```

#### Lambda Function Example (Node.js)

```javascript
// handlers/users.js
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();
const { v4: uuidv4 } = require('uuid');

const USERS_TABLE = process.env.DYNAMODB_TABLE;

// Helper function for responses
const response = (statusCode, body) => ({
  statusCode,
  headers: {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  },
  body: JSON.stringify(body),
});

// GET /users
module.exports.getAll = async (event) => {
  try {
    const params = {
      TableName: USERS_TABLE,
      Limit: 100,
    };

    const result = await dynamodb.scan(params).promise();

    return response(200, {
      users: result.Items,
      count: result.Count,
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    return response(500, { error: 'Could not fetch users' });
  }
};

// GET /users/{id}
module.exports.getOne = async (event) => {
  try {
    const { id } = event.pathParameters;

    const params = {
      TableName: USERS_TABLE,
      Key: { id },
    };

    const result = await dynamodb.get(params).promise();

    if (!result.Item) {
      return response(404, { error: 'User not found' });
    }

    return response(200, result.Item);
  } catch (error) {
    console.error('Error fetching user:', error);
    return response(500, { error: 'Could not fetch user' });
  }
};

// POST /users
module.exports.create = async (event) => {
  try {
    const data = JSON.parse(event.body);

    // Validation
    if (!data.email || !data.name) {
      return response(400, { error: 'Email and name are required' });
    }

    const user = {
      id: uuidv4(),
      email: data.email,
      name: data.name,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    const params = {
      TableName: USERS_TABLE,
      Item: user,
      ConditionExpression: 'attribute_not_exists(id)',
    };

    await dynamodb.put(params).promise();

    return response(201, user);
  } catch (error) {
    if (error.code === 'ConditionalCheckFailedException') {
      return response(409, { error: 'User already exists' });
    }
    console.error('Error creating user:', error);
    return response(500, { error: 'Could not create user' });
  }
};

// PUT /users/{id}
module.exports.update = async (event) => {
  try {
    const { id } = event.pathParameters;
    const data = JSON.parse(event.body);

    const params = {
      TableName: USERS_TABLE,
      Key: { id },
      UpdateExpression: 'SET #name = :name, updatedAt = :updatedAt',
      ExpressionAttributeNames: {
        '#name': 'name',
      },
      ExpressionAttributeValues: {
        ':name': data.name,
        ':updatedAt': new Date().toISOString(),
      },
      ReturnValues: 'ALL_NEW',
      ConditionExpression: 'attribute_exists(id)',
    };

    const result = await dynamodb.update(params).promise();

    return response(200, result.Attributes);
  } catch (error) {
    if (error.code === 'ConditionalCheckFailedException') {
      return response(404, { error: 'User not found' });
    }
    console.error('Error updating user:', error);
    return response(500, { error: 'Could not update user' });
  }
};

// DELETE /users/{id}
module.exports.delete = async (event) => {
  try {
    const { id } = event.pathParameters;

    const params = {
      TableName: USERS_TABLE,
      Key: { id },
      ConditionExpression: 'attribute_exists(id)',
    };

    await dynamodb.delete(params).promise();

    return response(204, {});
  } catch (error) {
    if (error.code === 'ConditionalCheckFailedException') {
      return response(404, { error: 'User not found' });
    }
    console.error('Error deleting user:', error);
    return response(500, { error: 'Could not delete user' });
  }
};
```

### AWS Advanced Patterns

#### Lambda with RDS Proxy

```javascript
// Connection pooling for SQL databases
const mysql = require('mysql2/promise');

let connection = null;

const getConnection = async () => {
  if (connection) {
    return connection;
  }

  connection = await mysql.createConnection({
    host: process.env.RDS_PROXY_ENDPOINT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: { rejectUnauthorized: false },
  });

  return connection;
};

module.exports.handler = async (event) => {
  const conn = await getConnection();
  const [rows] = await conn.execute('SELECT * FROM users');
  return {
    statusCode: 200,
    body: JSON.stringify(rows),
  };
};
```

#### Step Functions Integration

```yaml
# Orchestrating multiple Lambda functions
stepFunctions:
  stateMachines:
    orderProcessing:
      name: OrderProcessingStateMachine
      definition:
        StartAt: ValidateOrder
        States:
          ValidateOrder:
            Type: Task
            Resource: !GetAtt ValidateOrderFunction.Arn
            Next: ProcessPayment
          ProcessPayment:
            Type: Task
            Resource: !GetAtt ProcessPaymentFunction.Arn
            Next: UpdateInventory
          UpdateInventory:
            Type: Task
            Resource: !GetAtt UpdateInventoryFunction.Arn
            Next: SendConfirmation
          SendConfirmation:
            Type: Task
            Resource: !GetAtt SendConfirmationFunction.Arn
            End: true
```

### AWS Cost Breakdown (Monthly)

**Assumptions**:
- 10 million API requests
- Average function duration: 200ms
- Memory: 512 MB
- DynamoDB: 10 GB storage, 5 million reads, 1 million writes

#### API Gateway
- **REST API**: $3.50 per million requests
  - 10M requests × $3.50 = $35.00
- **Data Transfer**: First 10 TB free in most cases

#### Lambda
- **Requests**: $0.20 per million requests
  - 10M requests × $0.20 = $2.00
- **Compute**: $0.0000166667 per GB-second
  - 10M × 0.2s × 0.5 GB = 1,000,000 GB-seconds
  - $0.0000166667 × 1,000,000 = $16.67
- **Free Tier**: 1M requests + 400,000 GB-seconds/month free
  - After free tier: ~$15.00

#### DynamoDB
- **Storage**: $0.25 per GB
  - 10 GB × $0.25 = $2.50
- **On-Demand Reads**: $0.25 per million reads
  - 5M reads × $0.25 = $1.25
- **On-Demand Writes**: $1.25 per million writes
  - 1M writes × $1.25 = $1.25

#### CloudWatch
- **Logs Ingestion**: $0.50 per GB
  - Estimate 2 GB logs = $1.00
- **Logs Storage**: $0.03 per GB
  - Estimate 10 GB = $0.30

#### Cognito
- **MAU**: First 50,000 MAUs free
- **Beyond Free Tier**: $0.0055 per MAU

**Total Monthly Cost (AWS): ~$58.97**

---

## Azure Implementation

### Architecture Components

#### Azure Functions with API Management

```yaml
# function.json (HTTP Trigger)
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "httpTrigger",
      "direction": "in",
      "name": "req",
      "methods": ["get", "post"],
      "route": "users/{id?}"
    },
    {
      "type": "http",
      "direction": "out",
      "name": "res"
    },
    {
      "type": "cosmosDB",
      "direction": "out",
      "name": "outputDocument",
      "databaseName": "UsersDB",
      "collectionName": "Users",
      "createIfNotExists": true,
      "connectionStringSetting": "CosmosDBConnection"
    }
  ]
}
```

#### Azure Function Example (Node.js)

```javascript
// users/index.js
const { CosmosClient } = require('@azure/cosmos');

const endpoint = process.env.COSMOS_ENDPOINT;
const key = process.env.COSMOS_KEY;
const client = new CosmosClient({ endpoint, key });

const database = client.database('UsersDB');
const container = database.container('Users');

module.exports = async function (context, req) {
  context.log('Processing HTTP request');

  const method = req.method;
  const userId = context.bindingData.id;

  try {
    switch (method) {
      case 'GET':
        if (userId) {
          // Get specific user
          const { resource } = await container.item(userId, userId).read();
          if (!resource) {
            context.res = {
              status: 404,
              body: { error: 'User not found' },
            };
            return;
          }
          context.res = {
            status: 200,
            body: resource,
          };
        } else {
          // Get all users
          const { resources } = await container.items
            .query('SELECT * FROM c')
            .fetchAll();
          context.res = {
            status: 200,
            body: { users: resources, count: resources.length },
          };
        }
        break;

      case 'POST':
        const newUser = {
          id: require('uuid').v4(),
          email: req.body.email,
          name: req.body.name,
          createdAt: new Date().toISOString(),
        };

        await container.items.create(newUser);

        context.res = {
          status: 201,
          body: newUser,
        };
        break;

      case 'PUT':
        const { resource: existingUser } = await container
          .item(userId, userId)
          .read();

        if (!existingUser) {
          context.res = {
            status: 404,
            body: { error: 'User not found' },
          };
          return;
        }

        const updatedUser = {
          ...existingUser,
          ...req.body,
          updatedAt: new Date().toISOString(),
        };

        await container.item(userId, userId).replace(updatedUser);

        context.res = {
          status: 200,
          body: updatedUser,
        };
        break;

      case 'DELETE':
        await container.item(userId, userId).delete();
        context.res = {
          status: 204,
        };
        break;

      default:
        context.res = {
          status: 405,
          body: { error: 'Method not allowed' },
        };
    }
  } catch (error) {
    context.log.error('Error:', error);
    context.res = {
      status: 500,
      body: { error: 'Internal server error' },
    };
  }
};
```

#### Infrastructure as Code (Bicep)

```bicep
// main.bicep
param location string = resourceGroup().location
param appName string = 'serverless-api'

// Storage Account for Functions
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${appName}storage${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appName}-insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// Cosmos DB Account
resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
  name: '${appName}-cosmos'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

// Function App Plan (Consumption)
resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: '${appName}-func'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2021-08-01').keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'COSMOS_ENDPOINT'
          value: cosmosAccount.properties.documentEndpoint
        }
        {
          name: 'COSMOS_KEY'
          value: listKeys(cosmosAccount.id, '2021-10-15').primaryMasterKey
        }
      ]
    }
  }
}

// API Management Service
resource apiManagement 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: '${appName}-apim'
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'admin@example.com'
    publisherName: 'API Publisher'
  }
}
```

### Azure Cost Breakdown (Monthly)

**Same assumptions as AWS example**

#### Azure Functions
- **Executions**: $0.20 per million executions
  - 10M executions × $0.20 = $2.00
- **Compute**: $0.000016 per GB-second
  - 10M × 0.2s × 0.5 GB = 1,000,000 GB-seconds
  - $0.000016 × 1,000,000 = $16.00
- **Free Tier**: 1M executions + 400,000 GB-seconds free
  - After free tier: ~$15.00

#### API Management (Consumption Tier)
- **Calls**: $3.50 per million calls
  - 10M calls × $3.50 = $35.00
- **No gateway hours charge** (Consumption tier)

#### Cosmos DB (Serverless)
- **Storage**: $0.25 per GB
  - 10 GB × $0.25 = $2.50
- **Request Units**: $0.25 per million RUs
  - Estimate 50M RUs = $12.50

#### Application Insights
- **Data Ingestion**: First 5 GB free, $2.30/GB after
  - Estimate 2 GB = Free

#### Azure AD B2C
- **MAU**: First 50,000 MAUs free
- **Premium Features**: $0.00325 per MAU

**Total Monthly Cost (Azure): ~$67.00**

---

## GCP Implementation

### Architecture Components

#### Cloud Functions with API Gateway

```javascript
// functions/users/index.js
const { Firestore } = require('@google-cloud/firestore');
const firestore = new Firestore();
const USERS_COLLECTION = 'users';

exports.getUsers = async (req, res) => {
  try {
    const snapshot = await firestore.collection(USERS_COLLECTION).get();
    const users = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    res.status(200).json({
      users,
      count: users.length,
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.getUser = async (req, res) => {
  try {
    const { id } = req.params;
    const doc = await firestore.collection(USERS_COLLECTION).doc(id).get();

    if (!doc.exists) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.createUser = async (req, res) => {
  try {
    const { email, name } = req.body;

    if (!email || !name) {
      res.status(400).json({ error: 'Email and name are required' });
      return;
    }

    const user = {
      email,
      name,
      createdAt: new Date().toISOString(),
    };

    const docRef = await firestore.collection(USERS_COLLECTION).add(user);

    res.status(201).json({ id: docRef.id, ...user });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    const docRef = firestore.collection(USERS_COLLECTION).doc(id);
    const doc = await docRef.get();

    if (!doc.exists) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    await docRef.update({
      ...updates,
      updatedAt: new Date().toISOString(),
    });

    const updated = await docRef.get();
    res.status(200).json({ id: updated.id, ...updated.data() });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const docRef = firestore.collection(USERS_COLLECTION).doc(id);
    const doc = await docRef.get();

    if (!doc.exists) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    await docRef.delete();
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
```

#### Infrastructure as Code (Terraform)

```hcl
# GCP Serverless API with Terraform

# Cloud Functions
resource "google_cloudfunctions_function" "get_users" {
  name        = "getUsers"
  runtime     = "nodejs18"
  entry_point = "getUsers"

  available_memory_mb   = 512
  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  trigger_http          = true

  environment_variables = {
    FIRESTORE_PROJECT_ID = var.project_id
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.get_users.project
  region         = google_cloudfunctions_function.get_users.region
  cloud_function = google_cloudfunctions_function.get_users.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# API Gateway
resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id   = "serverless-api"
}

resource "google_api_gateway_api_config" "api_config" {
  provider      = google-beta
  api           = google_api_gateway_api.api.api_id
  api_config_id = "config"

  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = filebase64("openapi.yaml")
    }
  }

  gateway_config {
    backend_config {
      google_service_account = google_service_account.api_gateway.email
    }
  }
}

resource "google_api_gateway_gateway" "gateway" {
  provider   = google-beta
  api_config = google_api_gateway_api_config.api_config.id
  gateway_id = "serverless-gateway"
}

# Firestore Database
resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
}
```

### GCP Cost Breakdown (Monthly)

**Same assumptions as previous examples**

#### Cloud Functions
- **Invocations**: $0.40 per million invocations
  - 10M invocations × $0.40 = $4.00
- **Compute Time**: $0.0000025 per GB-second
  - 10M × 0.2s × 0.5 GB = 1,000,000 GB-seconds
  - $0.0000025 × 1,000,000 = $2.50
- **Networking**: $0.12/GB egress (estimate 100 GB) = $12.00
- **Free Tier**: 2M invocations + 400,000 GB-seconds free
  - After free tier: ~$16.00

#### API Gateway
- **API Calls**: $3.00 per million calls (first 2M free)
  - 10M calls × $3.00 = $30.00

#### Firestore
- **Storage**: $0.18 per GB
  - 10 GB × $0.18 = $1.80
- **Document Reads**: $0.06 per 100,000 reads
  - 5M reads × $0.06/100K = $3.00
- **Document Writes**: $0.18 per 100,000 writes
  - 1M writes × $0.18/100K = $1.80

#### Cloud Monitoring
- **Logs Ingestion**: First 50 GB free, $0.50/GB after
  - Estimate 2 GB = Free

#### Cloud Storage (for function code)
- **Storage**: $0.020 per GB = ~$0.20

**Total Monthly Cost (GCP): ~$52.80**

---

## Security Considerations

### Authentication and Authorization

#### API-Level Authentication
- **API Keys**: Simple but less secure, for public APIs
- **JWT Tokens**: Standard for stateless authentication
- **OAuth 2.0**: Industry-standard authorization framework
- **OpenID Connect**: Identity layer on top of OAuth 2.0

#### Provider-Specific Solutions
- **AWS**: Cognito User Pools, IAM authorizers, Lambda authorizers
- **Azure**: Azure AD, Azure AD B2C, Easy Auth
- **GCP**: Identity Platform, IAM, Firebase Authentication

#### Implementation Example (JWT)

```javascript
const jwt = require('jsonwebtoken');

const verifyToken = (token) => {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    return decoded;
  } catch (error) {
    throw new Error('Invalid token');
  }
};

module.exports.handler = async (event) => {
  try {
    const token = event.headers.Authorization.replace('Bearer ', '');
    const user = verifyToken(token);

    // User authenticated, proceed with request
    // ...
  } catch (error) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Unauthorized' }),
    };
  }
};
```

### Input Validation

#### Validation Libraries
- **Joi**: Schema validation for Node.js
- **Yup**: JavaScript object schema validator
- **class-validator**: Decorator-based validation for TypeScript

#### Example Validation

```javascript
const Joi = require('joi');

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  name: Joi.string().min(2).max(50).required(),
  age: Joi.number().integer().min(18).max(120).optional(),
});

module.exports.createUser = async (event) => {
  try {
    const body = JSON.parse(event.body);

    const { error, value } = userSchema.validate(body);
    if (error) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.details[0].message }),
      };
    }

    // Proceed with validated data
    // ...
  } catch (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: 'Invalid request body' }),
    };
  }
};
```

### Rate Limiting and Throttling

#### API Gateway Level
- **AWS**: API Gateway throttling (10,000 RPS default, burst 5,000)
- **Azure**: API Management rate limiting policies
- **GCP**: API Gateway quotas and rate limits

#### Application Level (Redis)

```javascript
const Redis = require('ioredis');
const redis = new Redis(process.env.REDIS_URL);

const rateLimit = async (userId, limit = 100, window = 60) => {
  const key = `rate_limit:${userId}`;
  const current = await redis.incr(key);

  if (current === 1) {
    await redis.expire(key, window);
  }

  if (current > limit) {
    throw new Error('Rate limit exceeded');
  }

  return current;
};

module.exports.handler = async (event) => {
  const userId = event.requestContext.authorizer.userId;

  try {
    await rateLimit(userId);
    // Process request
  } catch (error) {
    return {
      statusCode: 429,
      body: JSON.stringify({ error: 'Too many requests' }),
    };
  }
};
```

### CORS Configuration

```javascript
const corsHeaders = {
  'Access-Control-Allow-Origin': process.env.ALLOWED_ORIGIN || '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Access-Control-Max-Age': '86400',
};

module.exports.handler = async (event) => {
  // Handle preflight requests
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: corsHeaders,
      body: '',
    };
  }

  // Process actual request
  return {
    statusCode: 200,
    headers: {
      ...corsHeaders,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ message: 'Success' }),
  };
};
```

### Secrets Management

#### Environment Variables
- Store non-sensitive config in environment variables
- Never commit secrets to version control

#### Secret Stores
- **AWS**: Secrets Manager, Parameter Store
- **Azure**: Key Vault
- **GCP**: Secret Manager

#### Example (AWS Secrets Manager)

```javascript
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

let cachedSecret = null;

const getSecret = async (secretName) => {
  if (cachedSecret) {
    return cachedSecret;
  }

  const data = await secretsManager
    .getSecretValue({ SecretId: secretName })
    .promise();

  cachedSecret = JSON.parse(data.SecretString);
  return cachedSecret;
};

module.exports.handler = async (event) => {
  const dbCredentials = await getSecret('prod/db/credentials');
  // Use credentials
};
```

### Data Encryption

#### At Rest
- Enable encryption for databases and storage
- Use customer-managed keys for compliance requirements

#### In Transit
- Always use HTTPS (enforced by API Gateway)
- Use TLS 1.2 or higher
- Certificate pinning for mobile apps

---

## Performance Optimization

### Cold Start Mitigation

#### Keep Functions Warm
- **Scheduled Invocations**: CloudWatch Events, Azure Functions timer
- **Provisioned Concurrency** (AWS): Keep functions initialized
- **Premium Plan** (Azure): Pre-warmed instances
- **Min Instances** (GCP): Minimum number of instances

#### Optimize Package Size
- Remove unnecessary dependencies
- Use Lambda Layers (AWS) or shared dependencies
- Tree-shaking for JavaScript
- Compile Go/Rust functions (faster cold starts)

#### Example: Warming Function

```javascript
// warmer.js
module.exports.warm = async (event) => {
  if (event.source === 'serverless-plugin-warmup') {
    console.log('Warming function');
    return 'Lambda is warm';
  }
  // Regular function logic
};
```

### Connection Pooling

#### Database Connections

```javascript
// Reuse connections across invocations
let connection = null;

const getConnection = async () => {
  if (connection && connection.isConnected()) {
    return connection;
  }

  connection = await createDatabaseConnection();
  return connection;
};

module.exports.handler = async (event) => {
  const conn = await getConnection();
  // Use connection
};
```

### Caching Strategies

#### Response Caching (API Gateway)
- Cache GET requests at API Gateway level
- Set appropriate TTLs based on data freshness requirements
- Use cache keys for personalized responses

#### Application-Level Caching (Redis)

```javascript
const Redis = require('ioredis');
const redis = new Redis(process.env.REDIS_URL);

const getCachedOrFetch = async (key, fetchFn, ttl = 300) => {
  const cached = await redis.get(key);
  if (cached) {
    return JSON.parse(cached);
  }

  const data = await fetchFn();
  await redis.setex(key, ttl, JSON.stringify(data));
  return data;
};

module.exports.getUser = async (event) => {
  const userId = event.pathParameters.id;

  const user = await getCachedOrFetch(
    `user:${userId}`,
    () => fetchUserFromDatabase(userId),
    600 // 10 minutes TTL
  );

  return {
    statusCode: 200,
    body: JSON.stringify(user),
  };
};
```

### Asynchronous Processing

#### Offload Heavy Tasks

```javascript
// API handler - responds quickly
module.exports.submitJob = async (event) => {
  const jobId = generateJobId();
  const data = JSON.parse(event.body);

  // Send to queue for processing
  await sqsClient.sendMessage({
    QueueUrl: process.env.PROCESSING_QUEUE_URL,
    MessageBody: JSON.stringify({ jobId, data }),
  }).promise();

  return {
    statusCode: 202,
    body: JSON.stringify({ jobId, status: 'processing' }),
  };
};

// Background processor
module.exports.processJob = async (event) => {
  for (const record of event.Records) {
    const { jobId, data } = JSON.parse(record.body);

    // Long-running processing
    await processData(data);

    // Update job status
    await updateJobStatus(jobId, 'completed');
  }
};
```

### Batch Processing

```javascript
// Process multiple items efficiently
module.exports.processBatch = async (event) => {
  const items = event.Records.map(r => JSON.parse(r.body));

  // Batch database writes
  const batchWrite = {
    RequestItems: {
      [TABLE_NAME]: items.map(item => ({
        PutRequest: { Item: item },
      })),
    },
  };

  await dynamodb.batchWrite(batchWrite).promise();
};
```

---

## Cost Estimates

### Cost Comparison Summary

| Traffic Level | AWS Lambda | Azure Functions | GCP Cloud Functions |
|---------------|-----------|-----------------|---------------------|
| 1M requests/month | Free | Free | Free |
| 10M requests/month | $59 | $67 | $53 |
| 100M requests/month | $350 | $380 | $320 |
| 1B requests/month | $2,800 | $3,200 | $2,600 |

*Note: Prices are estimates including API Gateway, compute, and basic database usage.*

### Cost Optimization Tips

1. **Right-Size Memory**: More memory = faster execution = lower cost
2. **Use Free Tiers**: Stay within free tiers for dev/test
3. **Optimize Code**: Faster functions cost less
4. **Cache Aggressively**: Reduce function invocations
5. **Batch Operations**: Process multiple items per invocation
6. **Use Reserved Capacity**: For predictable workloads
7. **Monitor Costs**: Set up billing alerts

---

## Best Practices

### Function Design

1. **Single Responsibility**: One function = one purpose
2. **Stateless**: Don't rely on container state
3. **Idempotent**: Safe to retry
4. **Fail Fast**: Validate inputs early
5. **Timeouts**: Set appropriate timeouts
6. **Error Handling**: Graceful error handling
7. **Logging**: Structured logging

### Code Organization

```
/
├── functions/
│   ├── users/
│   │   ├── index.js
│   │   ├── get.js
│   │   ├── create.js
│   │   └── update.js
│   ├── orders/
│   └── payments/
├── shared/
│   ├── database.js
│   ├── validation.js
│   └── utils.js
├── tests/
├── package.json
└── serverless.yml
```

### Testing

```javascript
// users.test.js
const { getUser } = require('../functions/users');

describe('getUser', () => {
  it('should return user by ID', async () => {
    const event = {
      pathParameters: { id: '123' },
    };

    const result = await getUser(event);

    expect(result.statusCode).toBe(200);
    expect(JSON.parse(result.body)).toHaveProperty('id', '123');
  });

  it('should return 404 for non-existent user', async () => {
    const event = {
      pathParameters: { id: 'non-existent' },
    };

    const result = await getUser(event);

    expect(result.statusCode).toBe(404);
  });
});
```

---

## Common Patterns

### 1. CRUD API Pattern
Standard create, read, update, delete operations

### 2. Backend for Frontend (BFF)
Separate APIs for different client types (mobile, web)

### 3. API Aggregator
Combine multiple services into single API

### 4. Event-Driven Pattern
Functions triggered by events (database changes, file uploads)

### 5. Fan-Out/Fan-In
Parallel processing of tasks, aggregate results

### 6. Saga Pattern
Distributed transactions across services

### 7. Circuit Breaker
Prevent cascading failures

---

## Monitoring and Observability

### Key Metrics

- **Invocation Count**: Number of function executions
- **Duration**: Execution time
- **Error Rate**: Failed invocations
- **Throttles**: Rate-limited requests
- **Cold Starts**: New container initializations
- **Concurrent Executions**: Simultaneous function runs

### Distributed Tracing

- **AWS X-Ray**: End-to-end request tracing
- **Azure Application Insights**: Application performance management
- **GCP Cloud Trace**: Request latency tracking

### Logging Best Practices

```javascript
// Structured logging
const log = (level, message, metadata = {}) => {
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    level,
    message,
    ...metadata,
    requestId: context.requestId,
  }));
};

log('info', 'Processing user request', { userId: '123' });
log('error', 'Database connection failed', { error: err.message });
```

---

## CI/CD for Serverless

### Deployment Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy Serverless API

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Deploy to AWS
        run: |
          npm install -g serverless
          serverless deploy --stage production
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

## Common Pitfalls

1. **Ignoring Cold Starts**: Not optimizing for cold start performance
2. **Over-Permissioning**: Granting excessive IAM permissions
3. **No Timeout Strategy**: Default timeouts causing issues
4. **Missing Error Handling**: Unhandled promise rejections
5. **Synchronous Anti-Pattern**: Waiting for non-critical operations
6. **No Monitoring**: Flying blind without metrics
7. **Shared State**: Relying on container reuse
8. **Database Connection Leaks**: Not reusing connections
9. **Large Package Sizes**: Slow cold starts from big deployments
10. **No Cost Monitoring**: Surprise bills from runaway functions

---

## Conclusion

Serverless APIs offer a powerful, cost-effective way to build modern applications. By following the patterns and best practices outlined in this guide, you can build scalable, secure, and maintainable serverless APIs on any major cloud provider.

**Key Takeaways**:
- Design for failure and statelessness
- Optimize for cold starts
- Implement proper monitoring
- Security at every layer
- Cost awareness from day one

---

**Document Version**: 1.0
**Last Updated**: 2024-10-13
**Author**: Cloud Architecture Team
