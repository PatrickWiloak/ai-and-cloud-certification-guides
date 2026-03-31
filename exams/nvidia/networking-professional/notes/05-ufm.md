# UFM and Network Management

**[📖 UFM Documentation](https://docs.nvidia.com/networking/display/ufm/)** - Unified Fabric Manager

## NVIDIA UFM Overview

### What is UFM?

NVIDIA Unified Fabric Manager (UFM) is the enterprise platform for managing, monitoring, and optimizing InfiniBand and Ethernet fabrics in AI and HPC data centers.

### UFM Editions

**UFM Enterprise:**
- Full-featured fabric management
- Real-time monitoring and telemetry
- Advanced diagnostics and troubleshooting
- REST API for automation
- Event management and alerting
- License-based

**UFM Cyber-AI:**
- Security-focused network monitoring
- Anomaly detection with machine learning
- Network forensics and threat detection
- Compliance monitoring

**UFM Telemetry:**
- Streaming telemetry collection
- High-resolution counter data
- Integration with external analytics
- Prometheus and Grafana compatible

## Fabric Discovery and Visualization

### Topology Discovery
- Automatic discovery of all fabric nodes and switches
- Real-time topology map visualization
- Detect topology changes (node add/remove, link up/down)
- Physical and logical topology views
- Cable type and length identification

### Fabric Visualization
- Interactive topology diagrams
- Color-coded health status
- Traffic flow visualization
- Congestion hot spot highlighting
- Zoom into specific fabric regions

### Inventory Management
- Complete hardware inventory (switches, HCAs, cables)
- Firmware versions across all devices
- Serial numbers and asset tracking
- Lifecycle management information
- Configuration backup and restore

## Monitoring and Telemetry

### Real-Time Monitoring

**Port Counters:**
- Data counters (packets sent/received, bytes sent/received)
- Error counters (symbol errors, link downed, link recoveries)
- Congestion counters (wait time, VL stalls)
- Discard counters (buffer overruns)

**Health Indicators:**
- Link status (active, down, init, armed)
- Link speed and width
- Signal quality metrics
- Temperature readings
- Power consumption

### UFM Telemetry Service

**Streaming Telemetry:**
- High-frequency counter collection (sub-second)
- Configurable collection intervals
- Multiple export formats
- Time-series data storage

**Integration:**
- Prometheus endpoint for scraping
- Grafana dashboards for visualization
- FluentD/Fluentbit for log streaming
- REST API for custom integrations
- Kafka export for stream processing

### Key Metrics to Monitor

| Category | Metric | Significance |
|----------|--------|-------------|
| Errors | Symbol errors | Physical layer problem |
| Errors | Link error recovery | Intermittent link issue |
| Performance | Port xmit/rcv data | Traffic volume |
| Performance | Port xmit wait | Congestion indicator |
| Health | Link down events | Stability issue |
| Health | Temperature | Thermal monitoring |

## Event Management

### Event Types
- **Critical** - Link failures, hardware errors, switch down
- **Warning** - Rising error rates, temperature approaching threshold
- **Information** - Topology changes, configuration updates

### Alerting
- Email notifications for critical events
- SNMP traps for network management integration
- Syslog forwarding for centralized logging
- REST API webhooks for custom alerting
- Integration with PagerDuty, Slack, etc.

### Event Correlation
- Correlate multiple events to identify root cause
- Link multiple port errors to a common switch failure
- Detect cable-related issues across connected ports
- Historical event analysis for pattern detection

## Fabric Management

### Subnet Manager Integration
- UFM hosts and manages the subnet manager
- SM configuration and tuning through GUI
- Master/standby SM management
- Routing algorithm selection and configuration
- Partition management

### Partition Management
- Create and manage InfiniBand partitions
- Assign ports to partitions for isolation
- Full and limited member configuration
- Multi-tenant network segmentation
- Policy-based partition assignment

### Configuration Management
- Switch configuration backup and restore
- Firmware upgrade coordination
- Bulk configuration changes across fabric
- Configuration compliance checking
- Template-based configuration deployment

## Diagnostics and Troubleshooting

### Built-In Diagnostics

**Cable Diagnostics:**
- Cable health testing
- Signal quality measurement
- Eye diagram analysis (with supported cables)
- Identify marginal cables before failure

**Port Diagnostics:**
- Loopback tests
- BER (Bit Error Rate) testing
- Counter-based analysis
- Traffic generation for testing

**Fabric-Wide Diagnostics:**
- ibdiagnet integration for comprehensive checks
- Routing verification
- Credit loop detection
- Performance baseline comparison

### Troubleshooting Workflows

**Link Failure:**
1. Check UFM events for link down notification
2. Identify affected ports and cables
3. Review error counters on both sides of the link
4. Run cable diagnostics
5. Replace cable or schedule port repair

**Performance Degradation:**
1. Check UFM telemetry for congestion indicators
2. Identify hot spot links via traffic visualization
3. Review routing tables for suboptimal paths
4. Check for link speed negotiation issues
5. Enable adaptive routing if not active

**Intermittent Errors:**
1. Monitor error counter trends over time
2. Correlate errors with workload patterns
3. Check for environmental factors (temperature, vibration)
4. Run BER tests on suspect links
5. Replace marginal cables proactively

### Command-Line Tools

```bash
# Comprehensive fabric diagnostic
ibdiagnet

# Check specific port status
ibstat

# Query performance counters
perfquery <lid> <port>

# List fabric switches
ibswitches

# List fabric HCAs
ibhosts

# Trace route in fabric
ibtracert <src_lid> <dst_lid>

# Query subnet manager
sminfo

# Check partition configuration
iblinkinfo
```

## Key Exam Concepts

- UFM editions and their capabilities
- Fabric discovery and topology visualization
- Telemetry collection and Prometheus integration
- Event management and alerting configuration
- Partition management for multi-tenancy
- Diagnostic workflows for common failure scenarios
- Key command-line diagnostic tools
