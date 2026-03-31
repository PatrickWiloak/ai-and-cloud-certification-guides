# Confluent Certified Administrator - Study Strategy

## 🎯 Study Approach

### Phase 1: Kafka Architecture Deep Dive (1-2 weeks)
1. **Core Architecture**
   - Understand broker internals (log segments, indexes, compaction)
   - Master replication mechanics (ISR, leader election, failover)
   - Learn ZooKeeper role and KRaft migration path
   - Study controller responsibilities and metadata management

2. **Hands-on Setup**
   - Deploy a multi-broker Kafka cluster (3+ brokers)
   - Configure ZooKeeper ensemble or KRaft quorum
   - Practice broker configuration and tuning
   - Explore log directories and segment files

### Phase 2: Operations and Management (2-3 weeks)
1. **Cluster Operations**
   - Practice topic creation, modification, and deletion
   - Execute partition reassignment and preferred leader election
   - Perform rolling upgrades in a test environment
   - Practice broker decommissioning and addition

2. **Configuration Management**
   - Study all broker-level configurations
   - Understand topic-level configuration overrides
   - Learn client quota management
   - Practice dynamic configuration changes

### Phase 3: Monitoring, Security, and Platform (2-3 weeks)
1. **Monitoring and Troubleshooting**
   - Set up JMX monitoring with Prometheus/Grafana or similar
   - Practice interpreting key metrics
   - Simulate failure scenarios and troubleshoot
   - Monitor consumer lag and identify bottlenecks

2. **Security Configuration**
   - Configure SSL/TLS for encryption
   - Set up SASL authentication (SCRAM recommended for practice)
   - Implement ACLs for authorization
   - Practice end-to-end secure cluster deployment

3. **Confluent Platform**
   - Deploy Control Center and explore monitoring features
   - Configure Schema Registry for high availability
   - Manage Connect clusters via REST API
   - Deploy and manage ksqlDB servers

### Phase 4: Exam Preparation (1 week)
1. **Practice Exams**
   - Take practice exams and review incorrect answers
   - Focus on operations and configuration questions
   - Review domain weightings and adjust study focus

2. **Final Review**
   - Review all critical metrics and their alert thresholds
   - Review CLI commands for topic and ACL management
   - Review security protocol combinations

## 📚 Study Resources

### Official Resources
- **[📖 Kafka Operations](https://kafka.apache.org/documentation/#operations)** - Operations reference
- **[📖 Confluent Admin Guide](https://docs.confluent.io/platform/current/kafka/index.html)** - Administration guide
- **[📖 Confluent Training](https://www.confluent.io/training/)** - Official training courses
- **[📖 Kafka Configuration](https://kafka.apache.org/documentation/#configuration)** - All configuration reference

### Recommended Courses
- **[📖 Administration with Confluent (Confluent)](https://www.confluent.io/training/)** - Official admin course
- **[📖 Kafka Internals](https://developer.confluent.io/courses/)** - Free foundational courses
- **[📖 Confluent Operations Training](https://www.confluent.io/training/)** - Hands-on operations

### Practice and Hands-on
- **[📖 Docker Compose Setup](https://github.com/confluentinc/cp-all-in-one)** - Quick local cluster
- **[📖 Kafka CLI Tools](https://kafka.apache.org/documentation/#quickstart)** - Command-line tools reference
- **[📖 Confluent CLI](https://docs.confluent.io/confluent-cli/current/overview.html)** - Confluent CLI reference

## 🧠 Exam Tactics

### Question Strategy
1. **Configuration Questions** - Know defaults and when/why to change them
2. **CLI Command Questions** - Know exact syntax for common operations
3. **Troubleshooting Questions** - Map symptoms to root causes
4. **Architecture Questions** - Understand component interactions

### Time Management
- **1.5 minutes per question** average
- **Flag and move** - Do not spend more than 2 minutes on any question
- **Reserve 10-15 minutes** for reviewing flagged questions
- **Operations domain is 30%** - Expect 18 questions on managing/operating

### Domain Priorities (by weight)
1. **Managing and Operating (30%)** - Highest weight, focus on CLI and operations
2. **Monitoring and Troubleshooting (20%)** - JMX metrics and problem diagnosis
3. **Confluent Platform (20%)** - Control Center, Schema Registry, Connect
4. **Kafka Fundamentals (15%)** - Architecture and replication mechanics
5. **Security (15%)** - Authentication, authorization, encryption

### Key Areas to Master
- Broker configuration defaults and tuning parameters
- CLI commands for topic management, ACLs, and consumer groups
- JMX metrics and their significance
- Rolling upgrade procedures
- Security protocol and SASL mechanism combinations
- Confluent Platform component architecture

## ⚠️ Common Pitfalls

1. **Confusing `min.insync.replicas` scope** - Set at topic or broker level, not per producer
2. **Partition count cannot be decreased** - Only increased after creation
3. **Rolling upgrade order matters** - Update config, restart one by one, then update protocol
4. **`unclean.leader.election.enable`** - False by default, enabling risks data loss
5. **ACL wildcard matching** - `*` matches all resources of a type, not a regex
6. **Security protocols** - SASL_SSL is SASL auth + TLS, not two separate configs
7. **Consumer lag** - High lag alone is not always a problem, trend matters
8. **Log compaction** - Only applies to closed segments, not the active segment
