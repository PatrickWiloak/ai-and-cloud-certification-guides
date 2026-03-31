# Confluent Certified Administrator - Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: Kafka Architecture and Internals

#### Day 1-2: Broker Architecture
- [ ] Study broker internals (log directories, segment files, indexes)
- [ ] Understand controller election and responsibilities
- [ ] Learn broker discovery and metadata propagation
- [ ] Hands-on: Deploy a 3-broker cluster with Docker Compose
- [ ] Lab: Explore log directories and examine segment files
- [ ] Review Notes: `01-kafka-architecture.md`

#### Day 3-4: Replication Deep Dive
- [ ] Study ISR mechanics and replica.lag.time.max.ms
- [ ] Understand leader election and unclean leader election
- [ ] Learn min.insync.replicas behavior with different acks settings
- [ ] Hands-on: Create topics with RF=3 and simulate broker failures
- [ ] Lab: Monitor ISR changes during broker stop/start cycles

#### Day 5-6: ZooKeeper and KRaft
- [ ] Study ZooKeeper role (metadata, controller election, configuration)
- [ ] Learn ZooKeeper ensemble deployment and configuration
- [ ] Understand KRaft mode architecture and migration
- [ ] Hands-on: Deploy ZooKeeper ensemble and KRaft cluster
- [ ] Lab: Perform ZooKeeper to KRaft migration

#### Day 7: Week 1 Review
- [ ] Complete architecture practice questions
- [ ] Review broker configuration parameters
- [ ] Summarize key architectural concepts

### Week 2: Cluster Operations - Part 1

#### Day 8-9: Topic Management
- [ ] Master kafka-topics CLI tool (create, describe, alter, delete)
- [ ] Study topic configuration overrides (retention, compaction, compression)
- [ ] Learn kafka-configs for dynamic configuration
- [ ] Hands-on: Create topics with various configurations
- [ ] Lab: Modify topic configurations and observe effects
- [ ] Review Notes: `02-cluster-operations.md`

#### Day 10-11: Partition Reassignment
- [ ] Study kafka-reassign-partitions tool (generate, execute, verify)
- [ ] Understand preferred leader election
- [ ] Learn partition balancing strategies
- [ ] Hands-on: Execute partition reassignment across brokers
- [ ] Lab: Decommission a broker by reassigning all partitions

#### Day 12-13: Client Configuration
- [ ] Study producer configuration tuning for operations
- [ ] Learn consumer group management (describe, reset-offsets)
- [ ] Understand client quotas (produce, fetch, request rate)
- [ ] Hands-on: Configure and apply client quotas
- [ ] Lab: Reset consumer group offsets to specific positions

#### Day 14: Week 2 Review
- [ ] Complete operations practice questions
- [ ] Practice CLI commands from memory
- [ ] Review partition reassignment workflows

### Week 3: Cluster Operations - Part 2

#### Day 15-16: Rolling Upgrades
- [ ] Study rolling upgrade procedures for Kafka brokers
- [ ] Understand inter.broker.protocol.version and log.message.format.version
- [ ] Learn compatibility matrix between versions
- [ ] Hands-on: Perform a rolling upgrade in test environment
- [ ] Lab: Upgrade broker configurations with zero downtime
- [ ] Review Notes: `02-cluster-operations.md`

#### Day 17-18: Capacity Planning
- [ ] Study disk sizing for log retention and replication
- [ ] Learn network capacity planning (replication factor impact)
- [ ] Understand memory requirements (page cache, JVM heap)
- [ ] Hands-on: Calculate disk requirements for given throughput
- [ ] Lab: Tune JVM settings and monitor GC behavior

#### Day 19-20: Log Management
- [ ] Study log cleanup policies (delete vs compact)
- [ ] Understand log compaction mechanics and configuration
- [ ] Learn segment management and retention enforcement
- [ ] Hands-on: Configure log compaction and observe behavior
- [ ] Lab: Set up time-based and size-based retention policies

#### Day 21: Week 3 Review
- [ ] Complete advanced operations practice questions
- [ ] Review upgrade procedures and compatibility
- [ ] Practice capacity planning calculations

### Week 4: Monitoring and Troubleshooting

#### Day 22-23: JMX Metrics
- [ ] Study critical broker metrics (UnderReplicatedPartitions, ISR changes)
- [ ] Learn request metrics (latency, queue time, handler idle)
- [ ] Understand topic and partition metrics
- [ ] Hands-on: Set up JMX monitoring with Prometheus and Grafana
- [ ] Lab: Create dashboards for critical Kafka metrics
- [ ] Review Notes: `03-monitoring-troubleshooting.md`

#### Day 24-25: Consumer Lag and Troubleshooting
- [ ] Study consumer lag monitoring tools and metrics
- [ ] Learn common causes of consumer lag
- [ ] Understand under-replicated partition troubleshooting
- [ ] Hands-on: Simulate and troubleshoot consumer lag
- [ ] Lab: Diagnose under-replicated partitions

#### Day 26-27: Performance Troubleshooting
- [ ] Study OS-level metrics (disk I/O, network, CPU, memory)
- [ ] Learn request queue and handler saturation diagnosis
- [ ] Understand producer and consumer performance tuning
- [ ] Hands-on: Use kafka-producer-perf-test and kafka-consumer-perf-test
- [ ] Lab: Identify and resolve performance bottlenecks

#### Day 28: Week 4 Review
- [ ] Complete monitoring practice questions
- [ ] Review key metrics and alert thresholds
- [ ] Practice troubleshooting scenarios

### Week 5: Security and Confluent Platform

#### Day 29-30: Security Configuration
- [ ] Study SASL mechanisms (PLAIN, SCRAM, GSSAPI, OAUTHBEARER)
- [ ] Learn SSL/TLS configuration for brokers and clients
- [ ] Understand ACL management and authorization
- [ ] Hands-on: Configure SASL/SCRAM authentication
- [ ] Lab: Set up SSL/TLS encryption and ACLs
- [ ] Review Notes: `04-security.md`

#### Day 31-32: Confluent Control Center and Schema Registry
- [ ] Study Control Center features and configuration
- [ ] Learn Schema Registry high availability setup
- [ ] Understand Schema Registry security and access control
- [ ] Hands-on: Deploy and configure Control Center
- [ ] Lab: Set up Schema Registry cluster with HA
- [ ] Review Notes: `05-confluent-platform.md`

#### Day 33-34: Connect and ksqlDB Administration
- [ ] Study Connect distributed cluster management
- [ ] Learn ksqlDB server deployment and configuration
- [ ] Understand Connect plugin management and worker tuning
- [ ] Hands-on: Deploy Connect cluster and manage connectors
- [ ] Lab: Deploy ksqlDB cluster in headless mode

#### Day 35: Week 5 Review
- [ ] Complete security and platform practice questions
- [ ] Review security protocol matrix
- [ ] Practice Confluent Platform deployment scenarios

### Week 6: Exam Preparation

#### Day 36-37: Full Practice Exams
- [ ] Take first full-length practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify weak domains and knowledge gaps
- [ ] Create flashcards for missed concepts

#### Day 38-39: Targeted Review
- [ ] Focus study on weakest domains
- [ ] Review all CLI commands and their flags
- [ ] Review all critical JMX metrics
- [ ] Practice troubleshooting decision trees

#### Day 40-41: Final Review
- [ ] Take second full-length practice exam
- [ ] Review broker configuration defaults table
- [ ] Review security configuration matrix
- [ ] Review rolling upgrade procedures
- [ ] Light review of all notes

#### Day 42: Exam Day Preparation
- [ ] Quick review of fact sheet
- [ ] Review common pitfalls and tricky topics
- [ ] Ensure exam environment is ready
- [ ] Rest and prepare mentally

## 📊 Domain Study Time Allocation

| Domain | Weight | Recommended Hours |
|--------|--------|-------------------|
| Managing and Operating | 30% | 20-25 hours |
| Monitoring and Troubleshooting | 20% | 14-18 hours |
| Confluent Platform | 20% | 14-18 hours |
| Kafka Fundamentals | 15% | 10-12 hours |
| Security | 15% | 10-12 hours |
| **Total** | **100%** | **68-85 hours** |
