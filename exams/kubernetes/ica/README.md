# Istio Certified Associate (ICA)

## Overview

The Istio Certified Associate (ICA) is a hands-on, performance-based certification that validates the practical skills required to install, configure, operate, and troubleshoot Istio service mesh on Kubernetes. The credential is offered by the CNCF in partnership with Solo.io and was launched as Istio graduated within the CNCF and as service mesh adoption matured into mainstream platform engineering.

ICA sits alongside other CNCF performance-based exams (CKA, CKAD, CKS) and follows the same proctored, terminal-based format. Candidates work in a real Kubernetes cluster and demonstrate Istio configuration through `kubectl`, `istioctl`, and YAML manifests against time-boxed tasks.

## Target Audience

- Platform engineers and SREs operating Kubernetes at scale
- Security engineers responsible for zero-trust mTLS, authn, and authz
- DevOps engineers implementing canary releases, traffic shaping, and resilience
- Cloud architects designing microservice connectivity
- Anyone who already holds CKA/CKAD and wants service mesh depth

## Prerequisites

- Strong Kubernetes fluency (CKA-level or equivalent)
- Comfort with kubectl and YAML manifests
- Basic networking concepts (HTTP, TLS, DNS, service discovery)
- Familiarity with at least one ingress controller pattern
- Practical experience with at least one mesh deployment (Istio, Linkerd) is helpful but not required

## Domain Focus

The exam covers the following blueprint areas (full weighting in fact-sheet.md):

1. Installation and Upgrade (istioctl, Helm, Operator)
2. Traffic Management (VirtualService, DestinationRule, Gateway, ServiceEntry)
3. Security (PeerAuthentication, RequestAuthentication, AuthorizationPolicy)
4. Observability (telemetry, metrics, tracing, access logs)
5. Resilience (timeouts, retries, circuit breaking, fault injection)
6. Multi-Cluster and Ambient Mesh (newer track)
7. Troubleshooting (proxy config, sidecar injection, certificate issues)

## Official Resources

- Istio Certified Associate program: https://training.linuxfoundation.org/certification/istio-certified-associate/
- Istio documentation: https://istio.io/latest/docs/
- Istio reference (CRDs): https://istio.io/latest/docs/reference/config/
- Istio blog: https://istio.io/latest/blog/
- CNCF Slack #istio channel
- istioctl reference: https://istio.io/latest/docs/reference/commands/istioctl/

## How This Guide Is Organized

- README.md: orientation
- fact-sheet.md: blueprint, format, exam mechanics, references
- practice-plan.md: 6 week study plan with hands-on labs
- strategy.md: performance-based exam tactics
- scenarios.md: 10 troubleshooting / configuration scenarios
- notes/: six topic notes covering the blueprint

## What Makes This Exam Different

ICA is performance-based. You will configure real Istio resources in a real cluster and the proctoring system will grade your output, not your reasoning. Memorizing concepts is necessary but not sufficient: you must be fast and accurate with `kubectl apply`, `istioctl analyze`, `istioctl proxy-config`, and YAML editing under time pressure.

The exam allows access to Istio documentation during the test. Bookmark efficiently and practice the doc layout so you can navigate quickly.

## Study Time Estimate

- Existing CKA holder with mesh exposure: 40-60 hours
- CKA holder, no mesh experience: 80-120 hours
- New to Kubernetes: do CKA first

## Suggested Next Steps

- CKS for security depth on Kubernetes itself
- Linkerd certifications (when available) for comparative service mesh
- Cilium / eBPF certifications for newer data plane patterns
- Solo.io Gloo Mesh for enterprise mesh management depth
