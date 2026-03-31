# Deep Learning - Databricks ML Associate

## Overview

This section covers deep learning on Databricks, representing 13% of the exam. You need to understand how to run TensorFlow and PyTorch on Databricks, distributed training approaches, and transfer learning.

**[📖 Deep Learning](https://docs.databricks.com/en/machine-learning/deep-learning/index.html)** - DL overview on Databricks
**[📖 Distributed Training](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html)** - Distributed DL

## Key Topics

### 1. Deep Learning on Databricks

**[📖 TensorFlow on Databricks](https://docs.databricks.com/en/machine-learning/deep-learning/tensorflow.html)** - TF integration
**[📖 PyTorch on Databricks](https://docs.databricks.com/en/machine-learning/deep-learning/pytorch.html)** - PyTorch integration

**Key Concepts:**
- Use GPU-enabled ML Runtime for deep learning workloads
- TensorFlow and PyTorch are pre-installed in the ML Runtime
- Single-node training runs on the driver node with GPU
- MLflow integration logs DL models with `mlflow.tensorflow` or `mlflow.pytorch`
- TensorBoard is integrated into Databricks notebooks for visualization
- Select GPU instance types (e.g., g4dn, p3 on AWS) for the cluster

### 2. Single-Node Training

```python
import tensorflow as tf
import mlflow

# Enable autologging
mlflow.tensorflow.autolog()

# Build model
model = tf.keras.Sequential([
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(10, activation='softmax')
])

model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])

# Train - MLflow autologging captures params and metrics
model.fit(X_train, y_train, epochs=10, validation_split=0.2)
```

**Key Concepts:**
- Single-node training is the simplest approach
- Suitable for datasets that fit in the memory of one GPU
- Use MLflow autologging to track experiments automatically
- Epochs, batch size, and learning rate are key hyperparameters

### 3. Transfer Learning

Transfer learning uses a model pre-trained on a large dataset as a starting point for a new task.

**Key Concepts:**
- Start with a pre-trained model (ResNet, BERT, VGG, etc.)
- Freeze base layers (keep pre-trained weights)
- Add new layers for the specific task
- Fine-tune by unfreezing some layers and training on domain data
- Much faster and requires less data than training from scratch

**Common Pre-Trained Models:**
| Domain | Models | Use Case |
|--------|--------|----------|
| Image | ResNet, VGG, EfficientNet | Image classification, object detection |
| Text | BERT, GPT, RoBERTa | Text classification, NER, QA |
| General | Hugging Face models | Various NLP and vision tasks |

```python
# Transfer learning with TensorFlow
base_model = tf.keras.applications.ResNet50(weights='imagenet', include_top=False)
base_model.trainable = False  # Freeze base layers

model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.GlobalAveragePooling2D(),
    tf.keras.layers.Dense(256, activation='relu'),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])
```

### 4. Distributed Deep Learning

**[📖 TorchDistributor](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html)** - PyTorch distribution
**[📖 Horovod](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/horovod-runner.html)** - Horovod integration

**Distributed Training Approaches:**
| Approach | Description | Use Case |
|----------|-------------|----------|
| Data parallelism | Replicate model, split data across workers | Most common; model fits on one GPU |
| Model parallelism | Split model across workers | Very large models |

**TorchDistributor (PyTorch):**
```python
from pyspark.ml.torch.distributor import TorchDistributor

def train_fn():
    # Standard PyTorch training code
    model = MyModel()
    # ... training loop
    return model

distributor = TorchDistributor(num_processes=4, local_mode=False, use_gpu=True)
model = distributor.run(train_fn)
```

**HorovodRunner:**
```python
from sparkdl import HorovodRunner

def train_hvd():
    import horovod.tensorflow as hvd
    hvd.init()
    # ... distributed training code

hr = HorovodRunner(np=4)
hr.run(train_hvd)
```

**Key Concepts:**
- Data parallelism replicates the model to each worker and splits the training data
- Each worker computes gradients on its data subset, then gradients are averaged
- TorchDistributor is the native way to distribute PyTorch on Databricks
- Horovod supports TensorFlow, PyTorch, and MXNet
- Single-node multi-GPU is simpler but limited to one machine
- Petastorm reads Parquet data directly into DL frameworks

### 5. MLflow for Deep Learning

```python
# TensorFlow autologging
mlflow.tensorflow.autolog()

# PyTorch autologging
mlflow.pytorch.autolog()

# Manual logging
with mlflow.start_run():
    mlflow.log_param("epochs", 10)
    mlflow.log_param("batch_size", 32)
    mlflow.log_metric("val_accuracy", 0.92)
    mlflow.pytorch.log_model(model, "model")
```

**Key Concepts:**
- Autologging captures architecture, hyperparameters, and metrics automatically
- Model artifacts include the serialized model and its dependencies
- Use MLflow Model Registry to manage model versions
- TensorBoard logs can be viewed directly in Databricks notebooks

## Exam Tips for This Domain

1. **GPU Runtime** - Required for deep learning; know the instance types
2. **Transfer learning** - Freeze base layers, add task-specific head, optionally fine-tune
3. **Data parallelism vs model parallelism** - Data parallelism is most common
4. **TorchDistributor** - Native PyTorch distributed training on Databricks
5. **Horovod** - Framework-agnostic distributed training
6. **Focus on Databricks integration** - The exam tests platform knowledge, not DL theory

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Deep Learning | [docs.databricks.com/en/machine-learning/deep-learning/index.html](https://docs.databricks.com/en/machine-learning/deep-learning/index.html) |
| TensorFlow | [docs.databricks.com/en/machine-learning/deep-learning/tensorflow.html](https://docs.databricks.com/en/machine-learning/deep-learning/tensorflow.html) |
| PyTorch | [docs.databricks.com/en/machine-learning/deep-learning/pytorch.html](https://docs.databricks.com/en/machine-learning/deep-learning/pytorch.html) |
| Distributed Training | [docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/index.html) |
| TorchDistributor | [docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html](https://docs.databricks.com/en/machine-learning/deep-learning/distributed-training/torch-distributor.html) |
