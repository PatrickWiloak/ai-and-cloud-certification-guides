# 05 - Automation and Programmability (Domain 6, 10%)

CCNA's smallest domain by weight, but expect 8-12 questions on it. Mostly conceptual.

## Why network automation

- Reduce errors from manual config
- Faster change deployment
- Auditability and version control
- Repeatability across many devices

---

## REST APIs

### HTTP verbs (memorize)

| Verb | Use |
|---|---|
| GET | Retrieve resource |
| POST | Create resource |
| PUT | Replace resource |
| PATCH | Partially update resource |
| DELETE | Remove resource |

### HTTP status codes (high-yield)

| Code | Meaning |
|---|---|
| 200 OK | Success |
| 201 Created | New resource created |
| 204 No Content | Success, no body |
| 301 Moved Permanently | Redirect |
| 400 Bad Request | Client error in request |
| 401 Unauthorized | Auth missing / invalid |
| 403 Forbidden | Auth ok, but not allowed |
| 404 Not Found | Resource doesn't exist |
| 429 Too Many Requests | Rate limited |
| 500 Internal Server Error | Server crashed |
| 503 Service Unavailable | Server overloaded / down |

### Auth methods

- **Basic auth** - username:password base64-encoded in `Authorization` header
- **Bearer token** - `Authorization: Bearer <token>`
- **API key** - in header or query string
- **OAuth 2.0** - delegated auth, common for SaaS APIs

### Sample REST call

```bash
curl -X GET "https://device.example.com/api/v1/interfaces" \
    -H "Authorization: Bearer abc123" \
    -H "Accept: application/json"
```

---

## JSON and YAML

### JSON

```json
{
  "interfaces": [
    {
      "name": "GigabitEthernet0/1",
      "ip_address": "192.168.1.1",
      "mask": "255.255.255.0",
      "vlans": [10, 20, 30]
    }
  ]
}
```

Key-value pairs, arrays in `[]`, objects in `{}`. Strings double-quoted. No comments.

### YAML

```yaml
interfaces:
  - name: GigabitEthernet0/1
    ip_address: 192.168.1.1
    mask: 255.255.255.0
    vlans:
      - 10
      - 20
      - 30
```

Indentation-based. Comments with `#`. Common for Ansible playbooks.

### XML

```xml
<interfaces>
  <interface>
    <name>GigabitEthernet0/1</name>
    <ip_address>192.168.1.1</ip_address>
  </interface>
</interfaces>
```

Older, verbose, used in NETCONF.

---

## Software-Defined Networking (SDN)

### Traditional vs SDN

**Traditional:**

- Each device has its own control plane
- Configured per-device via CLI / SNMP / scripts
- Distributed protocols (OSPF, BGP) make routing decisions

**SDN:**

- Centralized control plane (controller)
- Devices become forwarding plane only
- Controller computes paths and pushes flow rules to devices
- Programmable via APIs (northbound to apps, southbound to devices)

### SDN components

- **Application plane** - apps like network monitoring, security policy
- **Control plane** - the controller (Cisco DNA Center, OpenDaylight, ONOS)
- **Data plane** - the actual switches/routers
- **Northbound API** - from apps to controller (REST common)
- **Southbound API** - from controller to devices (OpenFlow, NETCONF, RESTCONF, gRPC)

### Cisco SDN products

- **Cisco DNA Center** - enterprise SDN controller
- **Cisco SD-WAN (Viptela)** - SD-WAN controller
- **Cisco ACI (APIC)** - data center SDN
- **Meraki** - cloud-managed networking

---

## Network management protocols

### NETCONF

- XML-based config protocol over SSH (port 830)
- Operations: get-config, edit-config, get, lock, unlock, copy-config
- Replaces SNMP for config writes

### RESTCONF

- HTTP-based equivalent of NETCONF
- JSON or XML payloads
- Easier for app developers

### gNMI

- gRPC-based, newer, very efficient
- Used in modern Cisco IOS XR, IOS XE platforms

---

## Configuration management tools

| Tool | Architecture | Config format |
|---|---|---|
| **Ansible** | Agentless (SSH / API) | YAML playbooks |
| **Puppet** | Agent-based, server pulls | Puppet DSL |
| **Chef** | Agent-based, recipes | Ruby DSL |
| **SaltStack** | Agent or agentless | YAML |
| **Terraform** | Agentless | HCL |

For network automation, **Ansible** is by far the most common (covered in CCNA).

### Ansible building blocks

- **Inventory** - list of managed devices
- **Playbook** - YAML file describing desired state
- **Tasks** - units of work
- **Modules** - actions (e.g., `cisco.ios.ios_config`)
- **Roles** - reusable bundles

### Sample Ansible playbook

```yaml
- name: Configure VLANs on access switches
  hosts: access_switches
  gather_facts: no
  tasks:
    - name: Add VLAN 10
      cisco.ios.ios_vlans:
        config:
          - name: SALES
            vlan_id: 10
        state: merged

    - name: Configure access port
      cisco.ios.ios_l2_interfaces:
        config:
          - name: GigabitEthernet0/1
            access:
              vlan: 10
        state: merged
```

Run with:

```bash
ansible-playbook -i inventory.yaml configure-vlans.yaml
```

---

## Cisco DNA Center

- Cisco's enterprise SDN controller
- Manages campus and branch networks
- Provides:
  - Automation (templates, plug-and-play)
  - Assurance (telemetry, AI-driven insights)
  - Security policy (group-based, SD-Access)
- REST API for integration

CCNA tests recognition only. You won't be asked to configure DNA Center.

---

## Things to know for the exam

- REST verbs and what they do
- Common HTTP status codes (200, 201, 400, 401, 403, 404, 500)
- JSON syntax (read it, identify errors, navigate to a value)
- YAML basics (indentation, lists vs dicts)
- Difference between traditional and SDN architectures
- What northbound and southbound APIs are
- Ansible is agentless and uses YAML
- Puppet/Chef are agent-based
- NETCONF uses XML over SSH; RESTCONF uses HTTP/JSON
- DNA Center is Cisco's controller for campus

---

## Sample exam triggers

- "Identify the JSON object's key for a value" → read JSON
- "Which API verb deletes a resource?" → DELETE
- "401 vs 403 status code" → 401 = auth missing, 403 = auth ok but not allowed
- "Agentless config tool that uses SSH" → Ansible
- "SDN controller from Cisco for the campus" → DNA Center
- "Centralized vs distributed control plane" → SDN vs traditional
- "Northbound API consumer" → applications (network monitoring, security tools)
- "Southbound API protocol" → OpenFlow / NETCONF / RESTCONF / gRPC
