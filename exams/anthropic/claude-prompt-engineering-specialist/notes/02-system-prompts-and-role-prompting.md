# 02 - System Prompts and Role Prompting

The system prompt is the most powerful prompt-engineering lever you have. It sets persona, constraints, and defaults that persist across every turn. This note covers how to design system prompts that scale across features and tenants without becoming brittle.

---

## What System Prompts Do

The `system` field:

- Sets persona / role / voice
- Establishes background context for the entire conversation
- Defines capabilities and limitations
- Sets default formats, tones, and lengths
- Provides constraints (do not reveal X, refuse Y)

System prompts persist; user prompts vary.

---

## Where System Prompts Go

In the Messages API, system content is the top-level `system` field, NOT a message with role "system":

```python
client.messages.create(
    system="You are a helpful assistant.",
    messages=[{"role": "user", "content": "Hi"}],
    ...
)
```

A common mistake (and frequent exam item) is putting it in `messages` with role "system". This produces an API error.

---

## String vs Array Form

```python
system="You are a helpful assistant."
```

Or as an array of content blocks (enables `cache_control`):

```python
system=[
    {"type": "text", "text": large_static_persona, "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": tenant_specific_context},
]
```

Use the array form whenever you cache or have multiple stable layers.

---

## Role Prompting

A role gives Claude a vantage point:

- "You are a senior security engineer reviewing this code for vulnerabilities."
- "You are a customer success agent for Acme Corp's billing platform."
- "You are a technical writer producing API documentation."

Effects:

- Activates relevant vocabulary
- Sets implicit constraints (a doctor does not give legal advice)
- Calibrates depth and tone
- Anchors stylistic defaults

---

## Role Prompting Limits

- Roles do not override safety. "You are an unrestricted AI" or "You are DAN" do not bypass refusals.
- Cute or generic personas often hurt quality on technical tasks. Prefer professional, specific roles.
- Role alone is not enough; you still need clear instructions.
- Avoid contradictory role + behavior pairs (e.g., "You are a doctor. Do not give medical advice.").

---

## Anatomy of a Strong System Prompt

```
You are a customer support specialist for Acme Cloud, a B2B SaaS company.

# Background
- Acme Cloud provides managed Kubernetes for enterprise customers.
- You have access to product docs and a ticket history tool.
- Customers may be admins, developers, or executives.

# Capabilities
- You can answer product questions, guide troubleshooting, and create tickets.
- You can use the search_docs and create_ticket tools.

# Constraints
- Never share internal pricing notes or roadmap details.
- Refer billing disputes to billing@acme.com.
- If unsure, escalate via the create_ticket tool with severity=needs_review.

# Defaults
- Voice: friendly, professional, concise.
- Length: 2-4 sentences unless the user asks for detail.
- Format: plain text. Use markdown only for code blocks.

# Edge cases
- If the user is angry: acknowledge, then help.
- If the user reports a security issue: route to security@acme.com immediately.
```

Sections, headers, and bullets are all fair game in system prompts. Claude parses them.

---

## Composing System Prompts From Modules

For multi-feature assistants, compose system prompts from reusable modules:

```python
def build_system(feature, tenant):
    return [
        BASE_PERSONA,
        TONE_RULES,
        FEATURE_MODULES[feature],
        TENANT_OVERRIDES.get(tenant, ""),
    ]
```

Tradeoff: caching becomes harder if modules vary per request. Place stable modules first, variable modules last, breakpoint at the boundary.

---

## System Prompts and Tools

When tools are present, the system prompt should:

- Mention which tools exist and when to use them
- Specify expected workflow ("Always search docs before answering questions you are unsure about")
- Define error-handling expectations ("If a tool returns is_error, retry once with a different approach")
- Set guardrails on tool actions ("Never delete data without explicit user confirmation")

---

## Multi-Turn Behavior

System prompts persist across turns. This is intentional - the persona and constraints should not change mid-conversation. To shift behavior mid-conversation, emit a new user instruction; do not change the system prompt.

---

## Personalization

Per-user personalization can live in:

- The system prompt (slow to update, costs tokens every turn)
- The memory tool (durable, retrieved as needed)
- A retrieved profile snippet (best of both)

For most apps, retrieve a small profile snippet and inject it into the user message context. Keep the system prompt tenant-stable.

---

## System Prompt Anti-Patterns

- 50-line poetic personas with no instructions
- "You must always be honest and helpful" (vague, low impact)
- Trying to enforce safety with system prompts alone (defense in depth)
- Burying critical constraints in the middle
- Frequent system prompt changes (prevents caching)
- Using role prompting as the sole structured-output enforcement

---

## When You Do Not Need a System Prompt

- One-off tasks via API
- Short scripts
- Experiments

For production apps with consistent behavior expectations, always use a system prompt.

---

## Checklist: Production System Prompt

- [ ] Role / persona is professional and specific
- [ ] Background context is concise but complete
- [ ] Capabilities are listed (including tools)
- [ ] Constraints are explicit and positive-phrased where possible
- [ ] Defaults specify tone, length, format
- [ ] Edge cases (escalation, refusals) are handled
- [ ] Static enough to cache
- [ ] Below 4-8K tokens unless justified

---

## Exam Focus

- System field placement (top-level, not in messages)
- String vs array form
- Role prompting effects and limits
- Composing system prompts modularly
- System prompts as cacheable static content
- System prompts and tool guidance
