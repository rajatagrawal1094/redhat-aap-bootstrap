# Architecture Review Checklist

## Purpose

This checklist supports a solution architecture review of the AAP 2.7 container growth topology project.

Use it to evaluate whether the project is clearly scoped, technically defensible, operationally supportable, and ready for the next architecture stage.

## Review Checklist

| Area | Review Question | Status | Evidence |
| --- | --- | --- | --- |
| Business alignment | Does the project explain the business problem and objectives? | Complete | [business-requirements-document.md](business-requirements-document.md) |
| Scope | Are in-scope and out-of-scope items clear? | Complete | BRD, README, known limitations. |
| Topology | Is the container growth topology justified? | Complete | ADR-002 and README design rationale. |
| Host sizing | Is the selected VM sizing documented? | Complete | README and capacity strategy. |
| Platform components | Are required AAP components explained? | Complete | README component overview and architecture views. |
| Inventory | Is the installer inventory documented and sanitized? | Complete | `inventory-growth` and README inventory explanation. |
| Security | Are identity, RBAC, secrets, certificates, and FIPS posture addressed? | Partial | Security model documents current gaps. |
| Network | Are traffic paths and trust boundaries documented? | Complete | Network and security design. |
| Operations | Are day-2 checks and incident triage documented? | Complete | Operations runbook. |
| Backup | Is backup and restore design documented? | Partial | Procedure documented; restore evidence still needed. |
| Validation | Is installation validation evidence captured? | Complete | Acceptance test evidence. |
| Production readiness | Are production gaps and roadmap documented? | Complete | Production readiness roadmap and known limitations. |
| Scaling | Are scaling triggers and capacity watchpoints documented? | Complete | Capacity and scaling strategy. |
| Traceability | Are requirements mapped to implementation and evidence? | Complete | Requirements traceability matrix. |
| Handoff | Is ownership clear enough for operational handoff? | Complete | Stakeholder and operating model. |
| Automation code | Is there a plan for Ansible playbooks, roles, and validation automation? | Planned | Automation implementation roadmap. |

## Review Questions For A Customer Conversation

- What business outcomes should the automation platform support first?
- Is this environment for learning, PoC, non-production, or production?
- What availability target is required?
- What RTO and RPO are required?
- Which identity provider should be used?
- What teams and roles need access?
- What target systems will AAP manage?
- What firewall paths are required?
- What secrets platform is approved?
- What source control platform is authoritative?
- What automation content should be allowed in private automation hub?
- What workflows should be standardized first?
- What event sources should trigger EDA rulebooks?
- What monitoring and audit evidence must be retained?
- Who owns backup, restore, patching, certificates, and upgrades?

## Review Outcome Template

| Decision | Result |
| --- | --- |
| Topology accepted for current project | Yes |
| Production use accepted as-is | No |
| Production roadmap required | Yes |
| Security review required before production | Yes |
| Backup and restore test required before production | Yes |
| SSO and RBAC required before broad onboarding | Yes |
| Automation code implementation recommended | Yes |

