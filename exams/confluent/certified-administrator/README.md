# Confluent Certified Administrator for Apache Kafka

## Exam Overview

The Confluent Certified Administrator for Apache Kafka exam validates the ability to deploy, manage, monitor, and troubleshoot Apache Kafka clusters and the Confluent Platform. This certification demonstrates proficiency in cluster operations, performance tuning, security configuration, and platform management.

**Exam Details:**
- **Exam Code:** Confluent Certified Administrator
- **Duration:** 90 minutes
- **Number of Questions:** 60 multiple-choice questions
- **Passing Score:** 70%
- **Cost:** $150 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (hands-on Kafka administration experience recommended)

## Exam Domains

### Domain 1: Kafka Fundamentals (15%)
- Core architecture concepts (brokers, topics, partitions)
- Replication and leader election
- Log segments and storage mechanics
- ZooKeeper and KRaft controller modes
- Message delivery guarantees

**Key Concepts:**
- In-sync replicas (ISR) and replica management
- Controller broker responsibilities
- Log retention and compaction
- Broker discovery and metadata

### Domain 2: Managing and Operating (30%)
- Cluster deployment and configuration
- Topic management and partition reassignment
- Rolling upgrades and version compatibility
- Capacity planning and resource management
- Broker configuration tuning

**Key Operations:**
- Topic creation, modification, and deletion
- Partition reassignment and preferred leader election
- Broker decommissioning and addition
- Configuration management (broker, topic, client)

### Domain 3: Monitoring and Troubleshooting (20%)
- JMX metrics and monitoring tools
- Consumer lag analysis
- Under-replicated partitions troubleshooting
- Performance bottleneck identification
- Log analysis and debugging

**Key Metrics:**
- Broker metrics (request rates, latency, ISR shrink/expand)
- Topic metrics (bytes in/out, messages per second)
- Consumer metrics (lag, commit rate, rebalance frequency)
- OS-level metrics (disk I/O, network, CPU, memory)

### Domain 4: Security (15%)
- Authentication mechanisms (SASL, SSL)
- Authorization with ACLs
- Encryption in transit (SSL/TLS)
- Encryption at rest
- Security best practices

**Key Concepts:**
- SASL mechanisms (PLAIN, SCRAM, GSSAPI, OAUTHBEARER)
- SSL/TLS configuration for inter-broker and client communication
- ACL management and authorization
- Security protocol combinations

### Domain 5: Confluent Platform (20%)
- Confluent Control Center
- Schema Registry administration
- Kafka Connect management
- ksqlDB cluster management
- Confluent Platform deployment and configuration

**Key Components:**
- Control Center monitoring and alerting
- Schema Registry high availability
- Connect distributed cluster management
- ksqlDB server configuration

## Study Materials

### Official Resources
- **[📖 Apache Kafka Documentation](https://kafka.apache.org/documentation/)** - Complete Kafka reference
- **[📖 Confluent Platform Documentation](https://docs.confluent.io/platform/current/overview.html)** - Confluent Platform guide
- **[📖 Kafka Operations](https://kafka.apache.org/documentation/#operations)** - Operations and administration guide
- **[📖 Confluent Training](https://www.confluent.io/training/)** - Official training courses

### Study Guide Files
| Resource | Description |
|----------|-------------|
| [Fact Sheet](fact-sheet.md) | Quick reference with exam details and key facts |
| [Study Strategy](strategy.md) | Recommended study approach and timeline |
| [Practice Plan](practice-plan.md) | Week-by-week study schedule with hands-on labs |
| [Scenarios](scenarios.md) | High-yield exam scenarios and solution patterns |
| [Notes](notes/) | Detailed topic notes organized by domain |

### Notes Index
| File | Topics Covered |
|------|---------------|
| [01 - Kafka Architecture](notes/01-kafka-architecture.md) | Brokers, ZooKeeper/KRaft, ISR, log segments |
| [02 - Cluster Operations](notes/02-cluster-operations.md) | Topic config, partition reassignment, rolling upgrades |
| [03 - Monitoring & Troubleshooting](notes/03-monitoring-troubleshooting.md) | JMX metrics, consumer lag, under-replicated partitions |
| [04 - Security](notes/04-security.md) | SASL, SSL/TLS, ACLs, encryption |
| [05 - Confluent Platform](notes/05-confluent-platform.md) | Control Center, Schema Registry, Connectors, ksqlDB |
