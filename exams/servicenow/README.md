# ServiceNow Certifications

ServiceNow is a cloud-native platform for digital workflow automation. It started as IT Service Management (ITSM) software but the **Now Platform** has grown into a horizontal Platform-as-a-Service used for IT, HR, customer service, security operations, low-code app development, and increasingly AI-driven workflows (Now Assist, AI Agents).

The platform is delivered as a multi-instance SaaS - every customer gets one or more dedicated **instances** (e.g., `acmedev.service-now.com`) running on shared infrastructure. Customers configure and extend the platform via the web UI plus server-side **GlideRecord** JavaScript and client-side **Glide AJAX** scripts. Updates ship in two named releases per year (recent: Washington DC, Xanadu, Yokohama, Zurich).

ServiceNow customers tend to be mid-market and enterprise. Skills here are in high demand because the platform is sticky, the language (JavaScript on the Rhino/V8 engine) is not transferable in obvious ways to other ecosystems, and the licensing/role model rewards organizations with internal admins and developers.

---

## Certification Family

ServiceNow certs fall into four ladders:

### Administrator track

| Cert | Code | Audience |
|---|---|---|
| **Certified System Administrator** | **CSA** | Foundational. Required prerequisite for almost every other ServiceNow cert. |
| Certified Application Developer | CAD | Builds custom apps on the Now Platform (scoped apps, server scripts, UI). |

### Implementation Specialist track (CIS-*)

Role-based, product-aligned. Each CIS cert validates implementation skills for one product area. **CSA is a prerequisite for all CIS certs.**

| CIS Cert | Product Area |
|---|---|
| CIS-ITSM | IT Service Management (Incident, Problem, Change, Request) |
| CIS-HR | HR Service Delivery |
| CIS-CSM | Customer Service Management |
| CIS-SAM | Software Asset Management |
| CIS-HAM | Hardware Asset Management |
| CIS-Discovery | Discovery (CMDB population) |
| CIS-EM | Event Management |
| CIS-SecOps | Security Operations |
| CIS-VR | Vulnerability Response |
| CIS-VRM | Vendor Risk Management |
| CIS-RCI | Risk and Compliance |
| CIS-FSM | Field Service Management |
| CIS-PPM (SPM) | Strategic Portfolio Management (formerly PPM) |
| CIS-APM | Application Portfolio Management |

### Architect track

| Cert | Audience |
|---|---|
| **Certified Technical Architect (CTA)** | Top of the ladder. Multi-instance, integration, performance, governance. Application-only, not openly available - candidates go through the CTA program. |
| Certified Master Architect (CMA) | Extends CTA with broader business architecture. |

### Specialty / role certs

- Suite Delivery Specialist (SDS) certs - sales/delivery aligned for ITX, EX, CRM suites.
- Certified Application Specialist - per-product app-builder credentials.
- Now Assist / AI Agent Studio certs - newer, generative AI on the Now Platform.

---

## Where to start

If you are new to ServiceNow, start with the **CSA** in [`csa/`](csa/). Everything else assumes you already understand the platform, tables, ACLs, GlideRecord, and update sets covered by CSA.

After CSA, pick one of:

- **CAD** - if you want to build apps on the platform.
- **CIS-ITSM** - if you work on the most common product area (Incident/Change/Problem/Request implementations).
- **CIS-Discovery** or **CIS-CSM** - if you specialize in CMDB or customer service.

The CTA is years away from a typical CSA pass and gates on hands-on architecture experience.

---

## Training and lab access

- **[Now Learning](https://learning.servicenow.com/)** - free official training. Required for cert vouchers on most certs.
- **[Now Create](https://nowlearning.servicenow.com/nowcreate)** - prescriptive guidance, accelerators, and reference architectures.
- **[Personal Developer Instance (PDI)](https://developer.servicenow.com/dev.do)** - free dedicated instance for hands-on practice. Hibernates after inactivity but wakes on login.
- **[Developer Portal](https://developer.servicenow.com/)** - docs, APIs, sample apps.
- **[ServiceNow Community](https://www.servicenow.com/community/)** - Q&A, release notes discussion.
