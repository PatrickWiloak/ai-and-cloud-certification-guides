---
last-updated: 2026-05-03
---

# Postmortem study guide - Cloudflare global outage from a regex, 2019-07-02

> A real public postmortem from Cloudflare. One regex update brought CPUs to 100% across the global network for ~30 minutes. The lessons map to SRE, change management, and observability.

## What happened

At 13:42 UTC on 2 July 2019, Cloudflare engineers deployed a routine update to their **WAF managed rules**. The deploy contained a new rule designed to detect a specific class of cross-site scripting (XSS) attack via regular expression matching.

The regex was **catastrophically backtracking** - it matched in linear time on most inputs but degraded to **exponential time** on certain malicious-looking inputs. As traffic flowed through the WAF, every node in Cloudflare's network burned through CPU evaluating the regex, eventually pegging at 100% across the global fleet.

**The result:** ~30 minutes of degraded or failed HTTP for any site behind Cloudflare, including dashboard, API, and many third-party services that relied on Cloudflare. ~80% of Cloudflare's network was affected.

The fix: a global rollback (kill switch) of the WAF rule. Recovery began once the rule was reverted; full restoration ~30 minutes after the deploy.

[**📖 Official Cloudflare blog post**](https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/) - the canonical writeup.

## Root cause analysis

1. **Catastrophic regex backtracking.** The pattern `(?:(?:\"|'|\]|\}|\\\\|\d|(?:nan|infinity|true|false|null|undefined|symbol|math)|\`|\-|\+)+[)]*;?((?:\s|-|~|!|{}|\|\||\+)*.*(?:.*=.*)))` had nested unbounded repetition that caused exponential matching time on certain inputs.
2. **No CPU-time-limited test** detected the backtrack before deploy - the test suite ran the regex on benign inputs only.
3. **Global rollout, no canary.** The change went to all of production simultaneously; there was no progressive rollout that would have caught CPU usage spikes in a small fraction of the fleet first.

## What Cloudflare changed (their published actions)

- **Re-engineering the WAF** to use a different regex engine that doesn't have catastrophic backtracking (`re2` family - linear-time guarantees) instead of PCRE.
- **Bounded CPU time** per rule evaluation - if a rule takes longer than a threshold, abort and log.
- **Progressive rollout** for WAF rules: dogfood first, then small subset, then global.
- **Improved kill switch / global disable** for any WAF rule.

## What this teaches

### Catastrophic regex
- PCRE-style regex with nested unbounded quantifiers can backtrack exponentially. Rule of thumb: if you see `(.*)+`, `(\w+)*`, `(a|aa)+` patterns, validate with input-time analysis.
- Use a linear-time engine (RE2, Hyperscan) for any regex evaluating attacker-controlled input.

### Progressive rollout
- Even "obvious" config changes need canary deployment. CPU saturation is a class of failure that doesn't show in unit tests.
- Map to: [Cloud Deploy progressive delivery](../exams/gcp/cloud-devops-engineer/scenarios.md), CodeDeploy canary.

### CPU as an SLO
- CPU saturation on a hot path is as bad as a code bug; treat it as a first-class SLI. Multi-burn-rate alerts on CPU + p99 latency would have caught this.
- Map to: [Service Monitoring SLOs (PDOE)](../exams/gcp/cloud-devops-engineer/scenarios.md), SRE workbook.

### Kill switches
- Every WAF rule, every feature flag, every client SDK should have a global off-switch that an oncall can flip in seconds. The Cloudflare team had one for WAF and used it.
- Map to: feature-flag systems (Optimizely, LaunchDarkly, GrowthBook), config-as-code with rapid revert paths.

### Adversarial input testing
- For any system that processes user input (WAF, parsers, search), the test suite must include adversarial / pathological inputs, not just happy-path examples.
- Map to: fuzz testing (`afl`, `libfuzzer`, Atheris), property-based testing.

## Cert mapping

| Cert | Domains tested by this incident |
|---|---|
| **GCP Cloud DevOps Engineer (PDOE)** | SLO design, multi-burn-rate alerts, canary deploys, rollback automation |
| **AWS DevOps Engineer Pro (DOP-C02)** | CodeDeploy canary, CloudWatch alarms as rollback signals |
| **Azure DevOps Engineer Expert (AZ-400)** | Deployment rings, App Insights alerts |
| **AWS Security Specialty (SCS-C02)** | WAF rule lifecycle, secure deploy of security policies |
| **CySA+** | Detection engineering, false positive vs catastrophic case |

## Discussion questions

1. Your team uses PCRE-style regex in a hot path on attacker-controlled data. What do you change tomorrow?
2. What's the smallest canary scope that would have caught this incident before global impact?
3. CPU at 100% across the fleet - what alarms do you wish you had had set up?
4. What's the kill switch design for *your* most critical config-driven feature?
5. How would you simulate a "catastrophic backtrack" event in a chaos engineering experiment?

## Related

- [Chaos engineering patterns](./architecture-patterns/chaos-engineering-patterns.md)
- [Observability basics](../learn/concepts/observability-basics.md)
- [SRE roadmap](./certification-roadmap-devops-sre.md)
- [SRE and reliability topic index](../topics/sre-and-reliability.md)
