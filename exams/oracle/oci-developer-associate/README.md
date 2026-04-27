# Oracle Cloud Infrastructure Developer Associate (1Z0-1084-24)

The OCI Developer Associate certification validates skills in developing and deploying cloud-native applications on Oracle Cloud Infrastructure. This certification demonstrates proficiency in using OCI development services, APIs, SDKs, and DevOps tools to build modern applications.

## 📋 Quick Links

- [**Fact Sheet**](fact-sheet.md) - Exam logistics and objectives
- [**Practice Plan**](practice-plan.md) - Structured study schedule

## 📚 Study Materials

### Core Notes
- [Cloud Native Development](notes/01-cloud-native-development.md)
- [Application Deployment Integration](notes/02-application-deployment-integration.md)
- [Devops Monitoring](notes/03-devops-monitoring.md)
## 🎯 Exam Details

- **Exam Code**: 1Z0-1084-24
- **Duration**: 105 minutes
- **Number of Questions**: 55 questions
- **Passing Score**: 68%
- **Question Types**: Multiple choice, multiple select
- **Cost**: $150 USD
- **Validity**: Recertification required every 2 years
- **Language**: Available in multiple languages
- **Delivery**: Pearson VUE (online proctored or test center)

## 📖 Exam Domains

### 1. Working with OCI APIs and SDKs (20%)

#### OCI REST APIs
- **API Basics**
  - RESTful API principles
  - API endpoints and regions
  - Request signatures (authentication)
  - Request/response format (JSON)
  - Pagination for large result sets
  - API versioning

- **Authentication**
  - User principal (API key signing)
  - Instance principal (for compute instances)
  - Resource principal (for Functions, etc.)
  - API key generation and management
  - Session tokens for CLI/SDK

- **API Request Structure**
  - Required headers (date, authorization, content-type)
  - Request signing algorithm
  - HTTP methods (GET, POST, PUT, DELETE)
  - Query parameters and path parameters
  - Error handling and status codes

#### OCI SDKs
- **Supported Languages**
  - Java SDK
  - Python SDK
  - Go SDK
  - TypeScript/JavaScript SDK
  - .NET SDK
  - Ruby SDK

- **SDK Configuration**
  - Install SDK dependencies
  - Configure SDK authentication
  - Set up config file (~/.oci/config)
  - Environment variables for configuration
  - Retry and timeout configuration

- **SDK Usage Patterns**
  - Initialize service clients
  - Make API calls (CRUD operations)
  - Handle responses and errors
  - Use waiters for async operations
  - Pagination with SDK
  - Resource creation examples

### 2. Serverless Application Development (25%)

#### OCI Functions
- **Functions Basics**
  - Functions service overview
  - Function triggers (HTTP, Events, scheduled)
  - Cold start vs warm invoke
  - Function timeouts and memory limits
  - Local development with Fn Project
  - Function context and parameters

- **Function Development**
  - Supported languages (Java, Python, Node.js, Go, etc.)
  - Function handlers and input/output
  - Environment variables and configuration
  - Logging from functions
  - Testing functions locally
  - Packaging and dependencies

- **Functions Deployment**
  - Create function applications
  - Deploy functions using Fn CLI
  - Update function configuration
  - Function versioning
  - IAM policies for Functions
  - Resource principal for Functions

- **Integration Patterns**
  - HTTP trigger via API Gateway
  - Event-driven with Events service
  - Scheduled execution
  - Integration with Object Storage
  - Database access from Functions
  - Calling other OCI services

#### API Gateway
- **Gateway Configuration**
  - Create API Gateway instances
  - Deployment specifications
  - Route configuration (path, methods)
  - Backend types (Functions, HTTP, Stock Response)
  - API authentication and authorization

- **Advanced Features**
  - Request/response transformation
  - Rate limiting and throttling
  - CORS configuration
  - API validation
  - Usage plans and API keys
  - Monitoring API performance

#### Events Service
- **Event-Driven Architecture**
  - Event types and schemas
  - Event rules and filtering
  - Actions (Functions, Streaming, Notifications)
  - Event delivery guarantees
  - Retry and dead letter queue

- **Common Event Sources**
  - Object Storage events (create, delete, update)
  - Compute instance state changes
  - Database events
  - Custom application events
  - IAM events

### 3. Container-Based Application Development (20%)

#### Container Basics
- **Docker Fundamentals**
  - Dockerfile best practices
  - Multi-stage builds
  - Image layers and caching
  - Container registry concepts
  - Image tagging strategies

#### Oracle Container Engine for Kubernetes (OKE)
- **OKE Cluster Management**
  - Create OKE clusters (quick create vs custom)
  - Managed nodes vs virtual nodes vs self-managed
  - Node pool configuration
  - Cluster access and authentication
  - kubectl configuration

- **Application Deployment on OKE**
  - Kubernetes manifests (Deployments, Services, ConfigMaps, Secrets)
  - Helm charts for packaging
  - Ingress controllers and load balancing
  - Persistent volume claims with OCI Block Volumes
  - Horizontal Pod Autoscaling (HPA)
  - Resource requests and limits

- **OKE Networking**
  - VCN-native pod networking vs flannel
  - Service types (ClusterIP, NodePort, LoadBalancer)
  - Network policies
  - Integration with OCI Load Balancer
  - Private vs public API endpoint

#### Container Registry (OCIR)
- **Registry Operations**
  - Push/pull images to OCIR
  - Image retention policies
  - Image vulnerability scanning
  - Repository naming conventions
  - Authentication tokens for OCIR
  - Integration with CI/CD pipelines

#### Container Instances
- **Serverless Containers**
  - Deploy containers without Kubernetes
  - Container group concepts
  - Resource allocation (CPU, memory)
  - Container restart policies
  - Use cases for Container Instances

### 4. DevOps and CI/CD (15%)

#### OCI DevOps Service
- **Project Setup**
  - Create DevOps projects
  - Configure code repositories
  - External connections (GitHub, GitLab, Bitbucket)
  - Artifact registry for build outputs
  - Notification topics

- **Build Pipelines**
  - Build pipeline stages
  - Build specifications (build_spec.yaml)
  - Managed build environments
  - Build parameters and variables
  - Artifact publishing
  - Trigger builds on code commit

- **Deployment Pipelines**
  - Deployment strategies (rolling, canary, blue-green)
  - Deploy to OKE clusters
  - Deploy to compute instances
  - Deploy Functions
  - Approval gates and manual steps
  - Automated testing in pipeline

#### Infrastructure as Code
- **Resource Manager**
  - Terraform on OCI
  - Create stacks from Git repositories
  - Plan, apply, destroy workflows
  - Stack variables and outputs
  - Drift detection
  - Integration with CI/CD

### 5. Messaging and Streaming (10%)

#### Queue Service
- **Queue Basics**
  - Create and configure queues
  - Send and receive messages
  - Message visibility timeout
  - Dead letter queues
  - Queue monitoring
  - Use cases for async processing

#### Streaming Service
- **Stream Processing**
  - Create streams and partitions
  - Produce messages to streams
  - Consume messages from streams
  - Consumer groups
  - Stream retention policies
  - Integration with Kafka API

- **Stream Use Cases**
  - Real-time data ingestion
  - Event sourcing patterns
  - Log aggregation
  - IoT data collection
  - Integration with Service Connector Hub

#### Notifications Service
- **Topic and Subscriptions**
  - Create notification topics
  - Subscription types (email, SMS, Functions, HTTPS)
  - Message publishing
  - Filtering rules
  - Integration with alarms and events

### 6. Database and Data Services (10%)

#### Autonomous Database for Developers
- **Database Access**
  - Connection strings and wallets
  - SQL*Net vs TLS connections
  - Database user management
  - Resource manager and consumer groups
  - Connection pooling best practices

- **Application Integration**
  - JDBC/ODBC connections
  - Python (cx_Oracle, python-oracledb)
  - Node.js (node-oracledb)
  - REST APIs with ORDS
  - GraphQL with ORDS

- **Developer Features**
  - JSON collections
  - RESTful web services
  - APEX for rapid development
  - Machine learning in database
  - Database actions and tools

#### NoSQL Database
- **NoSQL Development**
  - Tables, rows, and schema-less design
  - Primary keys and indexing
  - SDK for NoSQL (Java, Python, Node.js, Go)
  - Query language
  - Consistency models
  - Time-to-live (TTL) for data

### 7. Application Observability and Security (10%)

#### Application Performance Monitoring (APM)
- **APM Integration**
  - Instrument applications with APM agents
  - Distributed tracing setup
  - Trace data analysis
  - Performance baselines and alerts
  - Integration with Functions and OKE

#### Logging for Applications
- **Custom Logging**
  - Emit logs from applications
  - Log ingestion API
  - Log Analytics for application logs
  - Structured logging (JSON)
  - Correlation IDs for tracing

#### Security Best Practices
- **Vault for Secrets**
  - Store database credentials in Vault
  - Retrieve secrets programmatically
  - Secret rotation automation
  - Integration with Functions and containers

- **IAM for Applications**
  - Resource principal for serverless
  - Instance principal for compute
  - Dynamic groups for resource access
  - Least privilege policies
  - API key vs principal authentication

## 🎓 Prerequisites & Recommended Experience

### Prerequisites
- **OCI Foundations (1Z0-1085-24)** - Recommended but not required
- Programming experience in at least one language (Java, Python, Node.js, Go)
- Understanding of REST APIs and HTTP
- Basic knowledge of containerization (Docker)

### Recommended Experience
- 6-12 months developing on OCI
- Experience with cloud-native application patterns
- Familiarity with microservices architecture
- Basic DevOps and CI/CD knowledge
- Understanding of Kubernetes concepts

### Technical Skills
- Develop applications using OCI SDKs and APIs
- Build serverless applications with Functions
- Deploy containerized applications to OKE
- Implement CI/CD pipelines with DevOps service
- Integrate messaging and streaming services
- Implement application observability
- Apply security best practices for cloud applications

## Study Strategy

### Recommended Timeline: 8-10 Weeks

**Weeks 1-2: APIs, SDKs, and Serverless Foundations**
- OCI REST API structure and authentication
- SDK installation and basic usage
- Functions development and deployment
- API Gateway configuration
- Hands-on: Build serverless application with Functions and API Gateway

**Weeks 3-4: Container Development**
- Docker basics and best practices
- OKE cluster creation and configuration
- Deploy applications to OKE
- Container Registry operations
- Hands-on: Deploy microservices application to OKE

**Weeks 5-6: DevOps and CI/CD**
- OCI DevOps service setup
- Build pipelines and specifications
- Deployment pipelines and strategies
- Infrastructure as Code with Terraform
- Hands-on: Implement complete CI/CD pipeline

**Weeks 7-8: Messaging, Data, and Observability**
- Queue and Streaming services
- Database connectivity and best practices
- NoSQL development
- APM and logging integration
- Hands-on: Build event-driven application

**Weeks 9-10: Practice and Review**
- Practice exams (multiple attempts)
- Code labs and sample applications
- Review weak areas
- Final hands-on projects

### Essential Hands-on Labs
- Develop and deploy serverless application using Functions and API Gateway
- Build and deploy microservices on OKE with load balancing
- Create CI/CD pipeline for application deployment
- Implement event-driven architecture with Events and Streaming
- Integrate application with Autonomous Database
- Configure APM for distributed tracing
- Implement security with Vault and resource principals
- Build message-driven application with Queue service
- Use OCI SDKs to manage resources programmatically

## 📚 Study Resources

### Official Oracle Resources
- **[OCI Developer Associate Learning Path](https://mylearn.oracle.com/ou/learning-path/become-an-oci-developer-associate-2024/136200)** - Official training (FREE)
- **[OCI SDK Documentation](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdks.htm)** - All language SDKs
- **[OCI Functions Documentation](https://docs.oracle.com/en-us/iaas/Content/Functions/home.htm)** - Serverless development
- **[OKE Documentation](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm)** - Kubernetes service
- **[Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)** - Development environment

### Recommended Materials
1. **Oracle University**: Official OCI Developer Associate course
2. **GitHub**: OCI SDK samples and examples
3. **Practice Tests**: Oracle official practice exam
4. **Hands-on Labs**: Oracle Cloud Infrastructure Tutorials

### Development Tools
- **OCI CLI**: Command-line interface for OCI
- **Fn CLI**: Functions development tool
- **kubectl**: Kubernetes command-line tool
- **Docker Desktop**: Container development
- **Terraform**: Infrastructure as Code
- **Postman**: API testing

## Exam Tips

### Question Strategy
- Practical, code-oriented questions
- Focus on "how to" implement solutions
- SDK code snippets and API usage
- Container and Kubernetes concepts
- DevOps workflow and pipeline configuration

### Common Question Themes
- SDK authentication methods (user, instance, resource principal)
- Functions development and deployment
- OKE cluster configuration and application deployment
- API Gateway configuration and routing
- CI/CD pipeline stages and build specifications
- Event-driven architecture patterns
- Database connectivity from applications
- Container registry operations
- Messaging patterns (Queue, Streaming, Notifications)
- Application security best practices

### Developer Best Practices
- **Use resource principals**: For serverless and compute authentication
- **Implement retry logic**: Handle transient failures
- **Log structured data**: JSON format for easier analysis
- **Use environment variables**: For configuration and secrets
- **Instrument applications**: APM for observability
- **Container best practices**: Multi-stage builds, minimal base images
- **Secure secrets**: Use Vault, not hardcoded credentials
- **Automate deployments**: CI/CD for consistency

### Time Management
- 105 minutes for 55 questions = ~1.9 minutes per question
- Code snippets may require more time to analyze
- Flag uncertain questions for review
- Leave 15 minutes for final review

## 📈 Success Criteria

- Develop cloud-native applications using OCI services
- Build serverless applications with Functions and API Gateway
- Deploy containerized applications to OKE
- Implement CI/CD pipelines with OCI DevOps
- Integrate messaging and streaming services
- Connect applications to OCI databases
- Implement observability with APM and logging
- Apply security best practices for cloud applications
- Use OCI SDKs and APIs effectively

## Career Path and Next Steps

### After OCI Developer Associate
1. **OCI Architect Associate** - Understand full solution architecture
2. **Kubernetes Certifications** - CKA, CKAD for deeper Kubernetes knowledge
3. **Specialty Certifications** - Focus on specific OCI services
4. **DevOps and SRE Roles** - Advanced automation and reliability

### Related Certifications
- **OCI Architect Associate** - Architectural perspective
- **OCI Operations Associate** - Operations and management
- **Certified Kubernetes Administrator (CKA)** - Advanced Kubernetes

### Development Career Paths
- **Cloud Application Developer**
- **Serverless Developer**
- **DevOps Engineer**
- **Cloud Solutions Engineer**
- **Site Reliability Engineer (SRE)**

---

**Build modern, cloud-native applications on Oracle Cloud Infrastructure!** 💻
