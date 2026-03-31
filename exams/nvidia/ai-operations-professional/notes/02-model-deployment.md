# Model Deployment and Serving

**[📖 Triton Inference Server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html)** - NVIDIA model serving platform

## NVIDIA Triton Inference Server

### Architecture

**Core Components:**
- **Model Repository** - Storage location for model artifacts and configs
- **Scheduler** - Manages request queuing and batching
- **Backend** - Framework-specific execution engines
- **Metrics** - Prometheus-compatible performance metrics

**Supported Frameworks:**
- TensorRT (optimized GPU inference)
- ONNX Runtime
- PyTorch (TorchScript and Python backend)
- TensorFlow (SavedModel)
- OpenVINO
- Python backend for custom logic
- Ensemble models (pipeline of models)

### Model Repository Structure

```
model_repository/
  text_classifier/
    config.pbtxt
    1/
      model.plan       # TensorRT engine
    2/
      model.onnx       # ONNX model (newer version)
  embedding_model/
    config.pbtxt
    1/
      model.pt         # PyTorch model
```

### Configuration (config.pbtxt)

```protobuf
name: "text_classifier"
platform: "tensorrt_plan"
max_batch_size: 64
input [
  {
    name: "input_ids"
    data_type: TYPE_INT32
    dims: [512]
  }
]
output [
  {
    name: "logits"
    data_type: TYPE_FP32
    dims: [10]
  }
]
instance_group [
  {
    count: 2
    kind: KIND_GPU
    gpus: [0, 1]
  }
]
dynamic_batching {
  preferred_batch_size: [16, 32, 64]
  max_queue_delay_microseconds: 100
}
```

### Dynamic Batching

- Accumulates individual requests into batches
- Configurable preferred batch sizes
- Maximum queue delay to bound latency
- Priority levels for different request types
- Significantly improves GPU utilization and throughput

### Model Ensembles

- Chain multiple models in a pipeline
- Output of one model feeds into the next
- Preprocessing, inference, and postprocessing stages
- Single API call executes the entire pipeline
- Shared memory between pipeline stages

**[📖 Triton Ensemble Guide](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/user_guide/architecture.html)** - Pipeline configuration

## NVIDIA NIM

### Deployment

```bash
# Deploy NIM container
docker run -d --gpus all \
  -e NGC_API_KEY=$NGC_API_KEY \
  -p 8000:8000 \
  nvcr.io/nim/meta/llama-3.1-8b-instruct:latest
```

**Key Features:**
- Pre-optimized with TensorRT-LLM
- OpenAI-compatible API
- Automatic GPU detection and optimization
- Built-in health checks and metrics
- Supports function calling and structured output

### NIM vs Triton

| Feature | NIM | Triton |
|---------|-----|--------|
| Focus | LLM/GenAI inference | General model serving |
| API | OpenAI-compatible | HTTP/gRPC custom |
| Optimization | Auto-optimized | Manual TensorRT conversion |
| Models | Pre-packaged LLMs | Any framework |
| Setup | Simple Docker run | Model repo + config |

**[📖 NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html)**

## Deployment Patterns

### Blue-Green Deployment
1. Run current version (blue) in production
2. Deploy new version (green) alongside
3. Run validation tests against green
4. Switch load balancer to green
5. Keep blue available for instant rollback
6. Decommission blue after confidence period

### Canary Deployment
1. Deploy new version to small subset (1-5% traffic)
2. Monitor key metrics (latency, error rate, accuracy)
3. Gradually increase traffic percentage
4. Automated rollback if metrics degrade
5. Full promotion when confidence is high

### A/B Testing
- Route traffic by user segments or request attributes
- Compare model performance metrics between versions
- Statistical significance testing before conclusions
- Useful for evaluating model quality improvements
- Requires traffic splitting infrastructure

### Shadow Deployment
- New model receives production traffic but responses are not returned
- Compare new model predictions against current model
- No user impact during testing
- Validates performance under real traffic patterns
- Resource-intensive (runs both models)

## Auto-Scaling

### Metrics-Based Scaling
- **GPU utilization** - Scale up when GPUs are saturated
- **Request queue depth** - Scale up when requests are waiting
- **Latency P95** - Scale up when latency exceeds target
- **Throughput** - Scale to maintain target requests/second

### Kubernetes HPA for Inference
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: triton-inference
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Pods
    pods:
      metric:
        name: nv_inference_request_duration_us
      target:
        type: AverageValue
        averageValue: "50000"  # 50ms target
```

### Scaling Considerations
- GPU provisioning time (minutes, not seconds)
- Model loading time on cold start
- Warm-up requests for consistent performance
- Cost management with scale-to-zero policies
- Pre-scaling for predictable traffic patterns

## Key Exam Concepts

- Triton model repository structure and config.pbtxt
- Dynamic batching configuration and benefits
- Model ensemble pipelines
- NIM deployment and API compatibility
- Blue-green vs canary vs A/B deployment patterns
- Auto-scaling metrics and HPA configuration
