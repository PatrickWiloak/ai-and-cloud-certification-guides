# GCP Integration & Streaming Fundamentals

## Integration Services Overview

### GCP Integration Portfolio
| Service | Purpose | Use Case |
|---------|---------|----------|
| **Pub/Sub** | Messaging and event ingestion | Asynchronous communication |
| **Cloud Functions** | Event-driven computing | Event processing |
| **Cloud Run** | Containerized applications | HTTP APIs, microservices |
| **Workflows** | Service orchestration | Multi-step processes |
| **Eventarc** | Event-driven architectures | Event routing |
| **Cloud Tasks** | Asynchronous task execution | Background job processing |
| **Cloud Scheduler** | Cron job service | Scheduled tasks |

### Integration Patterns Decision Tree
```
Need reliable messaging? → Pub/Sub
Need event processing? → Cloud Functions
Need HTTP APIs? → Cloud Run
Need workflow orchestration? → Workflows
Need task queuing? → Cloud Tasks
Need scheduled jobs? → Cloud Scheduler
```

## Cloud Pub/Sub

### What is Pub/Sub?
Messaging service for building event-driven systems and streaming analytics.

### Core Concepts
- **Topic**: Named resource to which messages are sent
- **Subscription**: Named resource representing stream of messages
- **Message**: Data sent through Pub/Sub
- **Publisher**: Application that sends messages
- **Subscriber**: Application that receives messages

### Pub/Sub Architecture
```
Publishers → Topic → Subscriptions → Subscribers
                ├─ Subscription A → Subscriber A
                ├─ Subscription B → Subscriber B  
                └─ Subscription C → Subscriber C
```

### Message Delivery Types
| Type | Description | Use Case |
|------|-------------|----------|
| **Pull** | Subscriber requests messages | Batch processing, controlled rate |
| **Push** | Pub/Sub delivers to HTTP endpoint | Real-time processing, serverless |

### Message Ordering
#### Standard Pub/Sub
- **No ordering guarantees**: Messages may arrive out of order
- **At-least-once delivery**: Messages delivered one or more times
- **Best effort ordering**: Generally preserves order but not guaranteed

#### Ordered Delivery
```python
# Enable message ordering
from google.cloud import pubsub_v1

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)

# Publish with ordering key
future = publisher.publish(
    topic_path,
    data.encode("utf-8"),
    ordering_key="user123"  # Messages with same key are ordered
)
```

### Message Attributes and Filtering
```python
# Publish with attributes
future = publisher.publish(
    topic_path,
    data.encode("utf-8"),
    event_type="user_signup",
    region="us-central1",
    user_tier="premium"
)

# Subscription filter
subscription_filter = 'attributes.event_type="user_signup" AND attributes.user_tier="premium"'
```

### Dead Letter Topics
**Handle messages that can't be processed**

```python
# Create subscription with dead letter policy
from google.cloud import pubsub_v1

subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(project_id, subscription_id)
dead_letter_topic = publisher.topic_path(project_id, dead_letter_topic_id)

subscription = subscriber.create_subscription(
    request={
        "name": subscription_path,
        "topic": topic_path,
        "dead_letter_policy": {
            "dead_letter_topic": dead_letter_topic,
            "max_delivery_attempts": 5
        }
    }
)
```

### Exactly-Once Delivery
**Available in specific regions for critical applications**

```python
# Enable exactly-once delivery
subscription = subscriber.create_subscription(
    request={
        "name": subscription_path,
        "topic": topic_path,
        "enable_exactly_once_delivery": True
    }
)
```

## Cloud Functions (2nd Gen)

### What are Cloud Functions?
Event-driven serverless compute platform that automatically runs code in response to events.

### Function Triggers
| Trigger Type | Description | Use Case |
|--------------|-------------|----------|
| **HTTP(S)** | HTTP requests | APIs, webhooks |
| **Pub/Sub** | Messages from topics | Event processing |
| **Cloud Storage** | Bucket events | File processing |
| **Firestore** | Database changes | Data synchronization |
| **Firebase Auth** | User authentication | User management |
| **Cloud Scheduler** | Scheduled execution | Cron jobs |

### Function Example
```python
import functions_framework
from google.cloud import storage

@functions_framework.cloud_event
def process_file(cloud_event):
    """Process file upload to Cloud Storage"""
    
    # Extract event data
    data = cloud_event.data
    bucket_name = data["bucket"]
    file_name = data["name"]
    
    # Process the file
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    
    # Download and process file content
    content = blob.download_as_text()
    processed_content = content.upper()  # Simple processing
    
    # Upload processed file
    output_blob = bucket.blob(f"processed_{file_name}")
    output_blob.upload_from_string(processed_content)
    
    print(f"Processed {file_name}")
```

### Function Configuration
```yaml
# functions-framework configuration
runtime: python311
entry_point: process_file
env_variables:
  ENV: production
timeout: 540s
memory: 512Mi
min_instances: 0
max_instances: 100
concurrency: 1000
```

### Error Handling and Retries
```python
@functions_framework.cloud_event
def reliable_function(cloud_event):
    try:
        # Function logic
        process_data(cloud_event.data)
        
    except RetryableError as e:
        # Log error and let Pub/Sub retry
        print(f"Retryable error: {e}")
        raise  # Function will be retried
        
    except FatalError as e:
        # Log error but don't retry
        print(f"Fatal error: {e}")
        return  # Acknowledge message to prevent retry
```

## Cloud Run

### What is Cloud Run?
Fully managed serverless platform for running containerized applications.

### Key Features
- **Containerized**: Run any language or framework
- **Serverless**: Scale to zero when not used
- **HTTP(S)**: Request-response model
- **Portable**: Standard containers work anywhere
- **Fast scaling**: Handle traffic spikes quickly

### Service Configuration
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-app
  annotations:
    run.googleapis.com/ingress: all
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/minScale: "0"
        autoscaling.knative.dev/maxScale: "100"
        run.googleapis.com/memory: "512Mi"
        run.googleapis.com/cpu: "1000m"
    spec:
      containerConcurrency: 1000
      timeoutSeconds: 300
      containers:
      - image: gcr.io/project/image
        ports:
        - containerPort: 8080
        env:
        - name: ENV
          value: production
```

### Cloud Run Jobs
**Run containers to completion**

```bash
# Deploy a job
gcloud run jobs create process-data \
  --image=gcr.io/project/processor \
  --region=us-central1 \
  --task-timeout=3600 \
  --parallelism=10 \
  --task-count=100

# Execute the job
gcloud run jobs execute process-data --region=us-central1
```

### Traffic Management
```bash
# Deploy new revision with traffic split
gcloud run deploy my-service \
  --image=gcr.io/project/image:v2 \
  --traffic=v1=80,v2=20 \
  --region=us-central1
```

## Workflows

### What are Workflows?
Fully managed orchestration platform for serverless workloads.

### Workflow Definition
```yaml
# workflow.yaml
- init:
    assign:
      - projectId: ${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
      - zone: "us-central1-a"
      - machineType: "e2-micro"

- createVM:
    call: googleapis.compute.v1.instances.insert
    args:
      project: ${projectId}
      zone: ${zone}
      body:
        name: "workflow-vm"
        machineType: ${"zones/" + zone + "/machineTypes/" + machineType}
        # ... VM configuration
    result: vmResult

- waitForVM:
    call: sys.sleep
    args:
      seconds: 30

- processData:
    call: http.post
    args:
      url: ${"http://" + vmResult.networkInterfaces[0].accessConfigs[0].natIP + ":8080/process"}
      body:
        data: "processing request"
    result: processResult

- cleanup:
    call: googleapis.compute.v1.instances.delete
    args:
      project: ${projectId}
      zone: ${zone}
      instance: "workflow-vm"

- complete:
    return: ${processResult}
```

### Workflow Steps
| Step Type | Purpose | Example |
|-----------|---------|---------|
| **call** | Invoke HTTP API or connector | Call Cloud Function |
| **assign** | Set variables | Store configuration |
| **condition** | Conditional logic | If/else branching |
| **for** | Iteration | Process list of items |
| **parallel** | Concurrent execution | Run steps in parallel |
| **try/except** | Error handling | Handle failures |
| **switch** | Multiple conditions | Route based on values |

### Error Handling
```yaml
- processStep:
    try:
      call: http.post
      args:
        url: "https://api.example.com/process"
        timeout: 30
    except:
      as: e
      steps:
        - logError:
            call: sys.log
            args:
              text: ${"Error: " + e.message}
        - retry:
            call: sys.sleep
            args:
              seconds: 60
        - retryProcess:
            call: http.post
            args:
              url: "https://api.example.com/process"
```

## Eventarc

### What is Eventarc?
Asynchronous event delivery service that routes events from Google services to Cloud Run services.

### Event Sources
| Source | Event Types | Use Case |
|--------|-------------|----------|
| **Cloud Storage** | Object create/delete/update | File processing |
| **Pub/Sub** | Message published | Message processing |
| **Cloud Audit Logs** | API calls | Security monitoring |
| **Firebase** | Database/auth changes | Application events |
| **BigQuery** | Job completion | Data pipeline events |

### Eventarc Trigger
```bash
# Create trigger for Cloud Storage events
gcloud eventarc triggers create storage-trigger \
  --destination-run-service=process-files \
  --destination-run-region=us-central1 \
  --event-filters="type=google.cloud.storage.object.v1.finalized" \
  --event-filters="bucket=my-upload-bucket" \
  --location=us-central1
```

### Event Handler
```python
import functions_framework
from cloudevents.http import CloudEvent

@functions_framework.cloud_event
def handle_storage_event(cloud_event: CloudEvent):
    """Handle Cloud Storage events via Eventarc"""
    
    # Extract event data
    data = cloud_event.data
    bucket = data["bucket"]
    name = data["name"]
    event_type = cloud_event["type"]
    
    print(f"Processing {event_type} for {name} in {bucket}")
    
    # Process based on event type
    if event_type == "google.cloud.storage.object.v1.finalized":
        process_new_file(bucket, name)
    elif event_type == "google.cloud.storage.object.v1.deleted":
        cleanup_references(bucket, name)
```

## Cloud Tasks

### What is Cloud Tasks?
Fully managed asynchronous task execution service.

### Task Types
| Type | Description | Use Case |
|------|-------------|----------|
| **HTTP tasks** | Send HTTP requests | Call APIs, webhooks |
| **App Engine tasks** | Call App Engine handlers | Legacy App Engine apps |

### Task Queue Configuration
```python
from google.cloud import tasks_v2

# Create task queue
client = tasks_v2.CloudTasksClient()
parent = f"projects/{project_id}/locations/{location_id}"

queue = {
    "name": f"{parent}/queues/my-queue",
    "rate_limits": {
        "max_dispatches_per_second": 10,
        "max_burst_size": 100,
        "max_concurrent_dispatches": 50
    },
    "retry_config": {
        "max_attempts": 5,
        "max_retry_duration": {"seconds": 3600},
        "min_backoff": {"seconds": 1},
        "max_backoff": {"seconds": 600},
        "max_doublings": 16
    }
}

response = client.create_queue(parent=parent, queue=queue)
```

### Creating Tasks
```python
# Create HTTP task
task = {
    "http_request": {
        "http_method": tasks_v2.HttpMethod.POST,
        "url": "https://my-service.run.app/process",
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"user_id": "123", "action": "send_email"}).encode()
    },
    "schedule_time": timestamp_pb2.Timestamp(
        seconds=int(time.time()) + 300  # Schedule 5 minutes from now
    )
}

# Add task to queue
response = client.create_task(
    parent=queue_path,
    task=task
)
```

## Cloud Scheduler

### What is Cloud Scheduler?
Fully managed cron job service for scheduling tasks.

### Schedule Formats
| Format | Description | Example |
|--------|-------------|---------|
| **Unix cron** | Traditional cron syntax | `0 9 * * 1` (9 AM on Mondays) |
| **App Engine cron** | Descriptive format | `every monday 09:00` |

### Job Types
- **HTTP jobs**: Send HTTP requests
- **Pub/Sub jobs**: Publish messages
- **App Engine jobs**: Call App Engine handlers

### Job Configuration
```bash
# Create HTTP job
gcloud scheduler jobs create http my-job \
  --schedule="0 9 * * 1" \
  --uri="https://my-service.run.app/weekly-report" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"report_type": "weekly"}' \
  --time-zone="America/New_York"

# Create Pub/Sub job
gcloud scheduler jobs create pubsub my-pubsub-job \
  --schedule="*/5 * * * *" \
  --topic="projects/my-project/topics/monitoring" \
  --message-body='{"check": "health"}' \
  --attributes="source=scheduler,type=health_check"
```

## Dataflow

### What is Dataflow?
Fully managed service for executing Apache Beam pipelines for batch and stream processing.

### Dataflow Pipeline Example
```python
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

def run_pipeline():
    pipeline_options = PipelineOptions([
        '--project=my-project',
        '--region=us-central1',
        '--runner=DataflowRunner',
        '--temp_location=gs://my-bucket/temp',
        '--staging_location=gs://my-bucket/staging'
    ])
    
    with beam.Pipeline(options=pipeline_options) as pipeline:
        (pipeline
         | 'Read from Pub/Sub' >> beam.io.ReadFromPubSub(topic='projects/my-project/topics/input')
         | 'Parse JSON' >> beam.Map(json.loads)
         | 'Filter Events' >> beam.Filter(lambda x: x.get('event_type') == 'purchase')
         | 'Transform Data' >> beam.Map(transform_purchase_data)
         | 'Window Data' >> beam.WindowInto(beam.window.FixedWindows(60))  # 1-minute windows
         | 'Aggregate' >> beam.CombinePerKey(sum)
         | 'Write to BigQuery' >> beam.io.WriteToBigQuery(
             table='my-project:dataset.purchase_summary',
             write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
         ))

def transform_purchase_data(element):
    return (element['product_category'], element['amount'])
```

### Streaming vs Batch
| Mode | Description | Use Case |
|------|-------------|----------|
| **Batch** | Process bounded datasets | Historical data analysis |
| **Streaming** | Process unbounded datasets | Real-time analytics |

## Integration Patterns

### Event-Driven Architecture
```
Event Source → Pub/Sub → Cloud Function → Database
                    └─→ Cloud Run → External API
                    └─→ Dataflow → BigQuery
```

### Microservices Communication
```
API Gateway → Cloud Run Service A ──Pub/Sub──→ Cloud Run Service B
                    │                              │
                    └── Cloud SQL               Cloud Storage
```

### Data Pipeline
```
Source Data → Cloud Storage → Dataflow → BigQuery → Data Studio
                 │              │
                 └─ Pub/Sub ────┴─ Cloud Function → Monitoring
```

## Best Practices

### Pub/Sub
1. **Use appropriate delivery type**: Pull for batch, Push for real-time
2. **Implement idempotency**: Handle duplicate message delivery
3. **Set appropriate acknowledgment deadlines**: Balance processing time and latency
4. **Use message ordering when needed**: For scenarios requiring order
5. **Monitor subscription health**: Track message backlog and processing rates

### Cloud Functions
1. **Keep functions focused**: Single responsibility principle
2. **Handle cold starts**: Optimize initialization code
3. **Use environment variables**: For configuration
4. **Implement proper error handling**: Distinguish retryable vs non-retryable errors
5. **Monitor function performance**: Track execution time and error rates

### Cloud Run
1. **Design for statelessness**: Don't rely on local state
2. **Optimize container startup**: Minimize cold start time
3. **Set appropriate concurrency**: Balance resource usage and latency
4. **Use health checks**: Ensure service reliability
5. **Implement graceful shutdown**: Handle termination signals

### Workflows
1. **Keep workflows simple**: Break complex workflows into smaller ones
2. **Use proper error handling**: Implement retry logic and timeouts
3. **Minimize workflow execution time**: Avoid long-running operations
4. **Use connectors**: Leverage built-in service integrations
5. **Monitor workflow execution**: Track success rates and performance

## Common Integration Pitfalls

### Message Processing Issues
- **Duplicate processing**: Not implementing idempotency
- **Message loss**: Inappropriate acknowledgment handling
- **Ordering problems**: Assuming message order without guarantees
- **Backpressure**: Not handling high message volumes
- **Dead letter handling**: Not configuring dead letter topics

### Function and Container Issues
- **Cold start problems**: Not optimizing initialization
- **Memory leaks**: Not properly cleaning up resources
- **Timeout issues**: Functions exceeding time limits
- **Concurrency problems**: Race conditions in concurrent execution
- **Error propagation**: Not properly handling and logging errors

### Workflow and Orchestration Problems
- **Complex workflows**: Creating overly complicated orchestrations
- **Error handling**: Inadequate error recovery mechanisms
- **State management**: Not properly managing workflow state
- **Performance issues**: Inefficient workflow design
- **Monitoring gaps**: Insufficient visibility into workflow execution

### Cost Optimization Issues
- **Over-provisioning**: Allocating more resources than needed
- **Inefficient processing**: Not optimizing data processing pipelines
- **Unnecessary data movement**: Moving data more than required
- **Poor scheduling**: Running jobs during peak pricing periods
- **Lack of monitoring**: Not tracking and optimizing costs