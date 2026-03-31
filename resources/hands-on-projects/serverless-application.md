# Hands-On Project: Build a Serverless Application

Build a serverless REST API with authentication and a static frontend.

**Estimated Time:** 3-4 hours
**Difficulty:** Intermediate
**Prerequisites:** Basic programming (Node.js or Python), cloud account

---

## Architecture Overview

```
                        CloudFront / CDN
                           |
                     S3 Static Website (Frontend - SPA)
                           |
                      API Gateway (REST API)
                           |
                      Cognito / Auth (JWT validation)
                           |
                    Lambda Functions (Business logic)
                           |
                    DynamoDB (NoSQL Database)
```

**Cloud Equivalents**

| Component | AWS | Azure | GCP |
|---|---|---|---|
| API Gateway | API Gateway | API Management | API Gateway |
| Functions | Lambda | Functions | Cloud Functions |
| Database | DynamoDB | Cosmos DB | Firestore |
| Auth | Cognito | Entra ID B2C | Firebase Auth |
| Static hosting | S3 + CloudFront | Static Web Apps | Cloud Storage + CDN |

---

## Step 1: Create the Database

### AWS DynamoDB

```bash
aws dynamodb create-table \
  --table-name Items \
  --attribute-definitions \
    AttributeName=PK,AttributeType=S \
    AttributeName=SK,AttributeType=S \
  --key-schema \
    AttributeName=PK,KeyType=HASH \
    AttributeName=SK,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST

# Add a Global Secondary Index for querying by type
aws dynamodb update-table \
  --table-name Items \
  --attribute-definitions AttributeName=itemType,AttributeType=S \
  --global-secondary-index-updates '[{
    "Create": {
      "IndexName": "TypeIndex",
      "KeySchema": [{"AttributeName": "itemType", "KeyType": "HASH"}],
      "Projection": {"ProjectionType": "ALL"}
    }
  }]'
```

### Azure Cosmos DB

```bash
az cosmosdb create --name my-serverless-db --resource-group myRG \
  --capabilities EnableServerless

az cosmosdb sql database create --account-name my-serverless-db \
  --resource-group myRG --name ItemsDB

az cosmosdb sql container create --account-name my-serverless-db \
  --resource-group myRG --database-name ItemsDB --name Items \
  --partition-key-path "/itemType"
```

### GCP Firestore

```bash
gcloud firestore databases create --location=us-central
```

---

## Step 2: Create Lambda Functions

### List Items (GET /items)

```python
# functions/list_items.py
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("Items")

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super().default(obj)

def handler(event, context):
    try:
        # Get query parameters
        params = event.get("queryStringParameters") or {}
        item_type = params.get("type")

        if item_type:
            response = table.query(
                IndexName="TypeIndex",
                KeyConditionExpression="itemType = :t",
                ExpressionAttributeValues={":t": item_type}
            )
        else:
            response = table.scan()

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(response["Items"], cls=DecimalEncoder)
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
```

### Create Item (POST /items)

```python
# functions/create_item.py
import json
import uuid
import boto3
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("Items")

def handler(event, context):
    try:
        # Get the authenticated user
        claims = event["requestContext"]["authorizer"]["claims"]
        user_id = claims["sub"]

        body = json.loads(event["body"])

        item = {
            "PK": f"ITEM#{uuid.uuid4()}",
            "SK": f"USER#{user_id}",
            "itemType": body["type"],
            "name": body["name"],
            "description": body.get("description", ""),
            "createdAt": datetime.utcnow().isoformat(),
            "createdBy": user_id
        }

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"message": "Item created", "id": item["PK"]})
        }
    except KeyError as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": f"Missing field: {str(e)}"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
```

### Deploy Lambda Functions

```bash
# Package the function
cd functions
zip list_items.zip list_items.py
zip create_item.zip create_item.py

# Create IAM role
aws iam create-role --role-name lambda-api-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach DynamoDB policy
aws iam attach-role-policy --role-name lambda-api-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess

aws iam attach-role-policy --role-name lambda-api-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Create functions
aws lambda create-function \
  --function-name list-items \
  --runtime python3.12 \
  --handler list_items.handler \
  --role arn:aws:iam::123456789012:role/lambda-api-role \
  --zip-file fileb://list_items.zip \
  --timeout 10 \
  --memory-size 256

aws lambda create-function \
  --function-name create-item \
  --runtime python3.12 \
  --handler create_item.handler \
  --role arn:aws:iam::123456789012:role/lambda-api-role \
  --zip-file fileb://create_item.zip \
  --timeout 10 \
  --memory-size 256
```

---

## Step 3: Set Up Authentication

### AWS Cognito User Pool

```bash
# Create User Pool
aws cognito-idp create-user-pool \
  --pool-name my-app-users \
  --auto-verified-attributes email \
  --username-attributes email \
  --policies '{
    "PasswordPolicy": {
      "MinimumLength": 8,
      "RequireUppercase": true,
      "RequireLowercase": true,
      "RequireNumbers": true,
      "RequireSymbols": false
    }
  }'

# Create App Client
aws cognito-idp create-user-pool-client \
  --user-pool-id us-east-1_xxxxx \
  --client-name my-app-client \
  --explicit-auth-flows ALLOW_USER_SRP_AUTH ALLOW_REFRESH_TOKEN_AUTH \
  --supported-identity-providers COGNITO

# Create a domain for hosted UI
aws cognito-idp create-user-pool-domain \
  --user-pool-id us-east-1_xxxxx \
  --domain my-app-auth
```

---

## Step 4: Create API Gateway

```bash
# Create REST API
aws apigateway create-rest-api --name my-serverless-api \
  --endpoint-configuration types=REGIONAL

# Get root resource ID
ROOT_ID=$(aws apigateway get-resources --rest-api-id API_ID \
  --query 'items[?path==`/`].id' --output text)

# Create /items resource
aws apigateway create-resource --rest-api-id API_ID \
  --parent-id $ROOT_ID --path-part items

# Create GET method with Cognito authorizer
aws apigateway create-authorizer --rest-api-id API_ID \
  --name CognitoAuth \
  --type COGNITO_USER_POOLS \
  --provider-arns arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_xxxxx \
  --identity-source method.request.header.Authorization

# Create GET method
aws apigateway put-method --rest-api-id API_ID \
  --resource-id ITEMS_ID \
  --http-method GET \
  --authorization-type COGNITO_USER_POOLS \
  --authorizer-id AUTH_ID

# Integrate with Lambda
aws apigateway put-integration --rest-api-id API_ID \
  --resource-id ITEMS_ID \
  --http-method GET \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:list-items/invocations

# Enable CORS
aws apigateway put-method --rest-api-id API_ID \
  --resource-id ITEMS_ID \
  --http-method OPTIONS \
  --authorization-type NONE

# Deploy
aws apigateway create-deployment --rest-api-id API_ID --stage-name prod
```

**API Endpoint:** `https://API_ID.execute-api.us-east-1.amazonaws.com/prod`

---

## Step 5: Deploy the Frontend

### Static Site on S3

```bash
# Create bucket
aws s3 mb s3://my-serverless-app-frontend

# Configure for static website hosting
aws s3 website s3://my-serverless-app-frontend \
  --index-document index.html --error-document index.html

# Build and deploy the frontend
cd frontend
npm run build
aws s3 sync build/ s3://my-serverless-app-frontend --delete
```

### CloudFront Distribution

```bash
aws cloudfront create-distribution \
  --origin-domain-name my-serverless-app-frontend.s3.us-east-1.amazonaws.com \
  --default-root-object index.html \
  --default-cache-behavior '{
    "TargetOriginId": "S3Origin",
    "ViewerProtocolPolicy": "redirect-to-https",
    "ForwardedValues": {"QueryString": false, "Cookies": {"Forward": "none"}}
  }'
```

### Frontend Authentication Code

```javascript
// Using AWS Amplify for Cognito integration
import { Amplify } from 'aws-amplify';
import { signIn, signUp, fetchAuthSession } from 'aws-amplify/auth';

Amplify.configure({
  Auth: {
    Cognito: {
      userPoolId: 'us-east-1_xxxxx',
      userPoolClientId: 'xxxxxxxxxxxxxxxxxxxxxxxxxx',
    }
  }
});

// Sign in
async function login(email, password) {
  const result = await signIn({ username: email, password });
  return result;
}

// Get JWT token for API calls
async function getToken() {
  const session = await fetchAuthSession();
  return session.tokens.idToken.toString();
}

// Call API with auth
async function fetchItems() {
  const token = await getToken();
  const response = await fetch('https://API_ID.execute-api.us-east-1.amazonaws.com/prod/items', {
    headers: { Authorization: token }
  });
  return response.json();
}
```

---

## Step 6: Azure and GCP Alternatives

### Azure - Static Web Apps + Functions

```bash
# Create a Static Web App (includes Functions backend)
az staticwebapp create --name my-serverless-app \
  --resource-group myRG --source https://github.com/user/repo \
  --branch main --app-location "/frontend" --api-location "/api" \
  --output-location "build"
```

### GCP - Cloud Functions + API Gateway

```bash
# Deploy Cloud Function
gcloud functions deploy list-items \
  --runtime python312 \
  --trigger-http \
  --entry-point handler \
  --allow-unauthenticated

# Create API Gateway config
gcloud api-gateway api-configs create my-config \
  --api my-api --openapi-spec openapi.yaml

gcloud api-gateway gateways create my-gateway \
  --api my-api --api-config my-config --location us-central1
```

---

## Verification Checklist

- [ ] DynamoDB table is created with correct key schema
- [ ] Lambda functions deploy and execute successfully
- [ ] API Gateway routes map to correct Lambda functions
- [ ] Cognito user pool is configured with an app client
- [ ] API requires authentication (returns 401 without a token)
- [ ] Frontend is accessible via CloudFront with HTTPS
- [ ] Frontend can sign in and make authenticated API calls
- [ ] CORS is configured correctly (no browser errors)

---

## Cleanup

```bash
# Delete in reverse order
aws cloudfront delete-distribution --id DIST_ID
aws s3 rb s3://my-serverless-app-frontend --force
aws apigateway delete-rest-api --rest-api-id API_ID
aws lambda delete-function --function-name list-items
aws lambda delete-function --function-name create-item
aws cognito-idp delete-user-pool --user-pool-id us-east-1_xxxxx
aws dynamodb delete-table --table-name Items
```

---

## Additional Resources

- [AWS Serverless Application Model (SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)
- [Serverless Framework](https://www.serverless.com/framework/docs)
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [Amazon Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html)
- [Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/overview)
- [GCP Cloud Functions](https://cloud.google.com/functions/docs)
