# SC-200 Exam Day Strategy

## Format Overview

The SC-200 is a Microsoft Role-Based Associate exam delivered by Pearson VUE. It uses a conventional scored item format (not CAT) where every question is delivered and contributes to your score. You will see 40 to 60 items within 100 minutes, including one or more case studies that are presented as sealed sections you cannot revisit after leaving.

Passing score is 700 out of 1000. The 1000 scale is not a percentage; Microsoft applies scaled scoring, so you cannot precisely reverse-engineer how many questions you missed. Aim for 85%+ on practice exams to feel safe.

## Before Exam Day

### Online proctored exam setup
- Install OnVUE at least 48 hours before and run the system test
- Use a wired internet connection if possible, minimum 1 Mbps up/down
- Clear your room: no paper, no second monitor unplugged from power, no phone within reach
- Webcam required; you will photograph your ID and the room
- Bathroom breaks are NOT allowed during the exam
- Dress code: no hats (religious exceptions permitted), no jackets once exam starts

### In-person exam setup
- Arrive 30 minutes early
- Bring 2 forms of ID, one government-issued with photo and signature
- Lockers for belongings; no electronics
- Given laminated whiteboard and marker for notes

## Time Management

With 100 minutes for 40 to 60 questions:
- Average 1 minute 40 seconds to 2 minutes 30 seconds per question
- Case studies consume more time; expect 10 to 15 minutes per case study
- Plan: target 60 minutes for non-case-study questions, 30 minutes for case studies, 10 minutes buffer

### Pacing gates
- 25% time elapsed = 25% questions answered
- 50% time elapsed = 50% answered, ideally with marks for return
- 75% time = all case studies complete
- Final 25% = review and marked questions

If you fall behind, stop re-reading. Make your best choice, flag, move on. Time pressure failures are more common than knowledge failures on this exam.

## Question Type Strategy

### Multiple choice (single answer)
- Read the question twice, noting absolute words: "only", "always", "never", "best", "first"
- Eliminate clearly wrong options first
- If two answers look valid, re-read the question for constraints (cost, time, least privilege, least admin effort)

### Multiple response
- Know how many to select ("Select two", "Select all that apply")
- Each correct counts; wrong answers do not subtract (no negative marking)
- Be willing to guess all N if unsure, but choose with intent

### Drag and drop and build list
- Order matters. Re-read the prompt for sequencing keywords: "first", "then", "before"
- If you are not sure, work outward from the steps you are certain about (first and last)

### Hot area and active screen
- Examine the entire UI; Microsoft loves to include distractor settings
- Look for the exact setting name from the answer options
- Verify blades, tabs, and dropdown selections before committing

### Case studies
- Read the overview and requirements first
- Open each supporting section in tabs; you can flip between them
- Answer each question, finish the case, then move on. YOU CANNOT RETURN after leaving the case study section
- Keep a mental list of key facts: workspace region, licensing SKUs, compliance scope

### Yes/No series (also called series of statements)
- Each statement is isolated; do not let previous statements bias you
- You cannot return to a previous statement once you advance

## Common Microsoft Exam Traps

### "Least administrative effort" vs "most granular control"
Microsoft often asks for the least effort solution even if another answer is technically valid. Default to built-in features (content hub solutions, Fusion, out-of-box workbooks) over custom builds unless a requirement blocks them.

### "Minimum permissions" principle
When asked about roles, choose the narrowest role that fits. Common pitfall: picking Contributor when Sentinel Responder or Security Reader suffices.

### Agent ambiguity (MMA vs AMA)
As of 2024, Microsoft Monitoring Agent is deprecated. Azure Monitor Agent (AMA) is the current answer unless the question explicitly references legacy systems. Data Collection Rules (DCRs) pair with AMA.

### Sentinel vs Defender XDR overlap
- Sentinel: cross-cloud, custom data sources, advanced SOAR, long retention
- Defender XDR: Microsoft workloads, unified incidents, AIR automation, advanced hunting
- When both could solve it, look at: data source (is it Microsoft product only?), automation requirements, retention requirements, multi-cloud needs

### Analytics rule type selection
- **Scheduled** - default; runs every 5 minutes to 14 days
- **Microsoft security** - forwards MS product alerts (minimal setup)
- **NRT** - ~1 minute latency, limited KQL (no `join`, no time aggregations)
- **Fusion** - zero configuration, multistage attack correlation, always enable
- **Anomaly** - customizable UEBA anomalies, require UEBA
- **Threat intelligence** - auto-generated from TI indicator tables

### Defender for Cloud plan mapping
Know which plan covers which resource:
- **Servers P1** - MDE integration, vuln assessment, file integrity, security baselines
- **Servers P2** - adds JIT VM access, adaptive application controls, network hardening, 500 MB free logs
- **Storage** - malware scanning, sensitive data discovery, activity monitoring
- **SQL** - anomaly detection, SQL injection, vuln assessment
- **Containers** - runtime protection, vuln scanning, K8s admission control
- **App Service, Key Vault, DNS, Resource Manager, APIs, AI services** - each has specific scope

## Technical Quick Reference

### KQL reading checklist under time pressure
1. What table(s)?
2. What time window?
3. What filter conditions?
4. What aggregation/projection?
5. What join type, if any?

### Incident response order of operations
1. Triage (severity, scope, false positive check)
2. Contain (isolate device, disable user, block hash)
3. Eradicate (remove malware, revoke tokens, reset credentials)
4. Recover (re-enable, re-onboard, validate)
5. Lessons learned (post-incident review, update detections)

### Automation order
Automation rules run before playbooks. Order rules matter. Test in a non-production workspace when possible.

## During the Exam

### First 60 seconds
- Tutorial and NDA acceptance
- Do not waste the timer; these do not count against the 100 minutes until you click through

### Read carefully
- English on this exam is not particularly tricky, but Microsoft loves double negatives in Yes/No series
- Translate the question to your own words mentally before looking at answers

### Mark for review liberally
- Use mark-for-review for any question you are not 95% on
- Do not over-use; the review screen is a list you must scroll through

### When stuck
- Eliminate obviously wrong choices
- Recognize Microsoft-preferred terminology: "Azure Monitor Agent", "Microsoft Entra ID", "Microsoft Sentinel", "Microsoft Defender XDR" (not "M365 Defender")
- If you see an old product name ("Azure Security Center", "Azure Sentinel"), assume the question is updated and translate mentally

### Last 10 minutes
- Review only your marked questions
- Do NOT change answers unless you have new information; gut instinct is usually correct
- Ensure no question is left blank (no negative marking)

## After the Exam

- Score displayed immediately (pass/fail and score report)
- Digital badge arrives via Credly within 24 to 48 hours
- Transcript updated on learn.microsoft.com within 24 hours
- If you fail: review the score report by domain, wait the required retake period, focus retake studies on weakest domains
- Certification valid 1 year; renewal is free and online

## Final Mental Notes

- Trust your preparation; second-guessing on exam day costs more points than incorrect knowledge
- Keep breathing; simulate case studies during practice so they feel familiar
- You are demonstrating what a competent SOC analyst would do on the job, not tricky trivia
