# Requirements Traceability Matrix

## Purpose

This matrix connects business requirements to technical requirements, design decisions, implementation evidence, validation evidence, and production gaps.

It is intended to show that the project is not only an installation guide, but a traceable solution architecture artifact.

## Traceability Matrix

| Business Requirement | Technical Requirement | Design Artifact | Implementation Evidence | Validation Evidence | Production Gap |
| --- | --- | --- | --- | --- | --- |
| BR-001: Provide a working AAP 2.7 platform | TR-PLAT-001 through TR-PLAT-007 | [architecture-decision-records.md](architecture-decision-records.md) | `inventory-growth` defines gateway, controller, hub, EDA, metrics, database, and Redis mode. | Browser validation and `podman ps`. | Production topology and HA are not implemented. |
| BR-002: Demonstrate major AAP service domains | TR-PLAT-001 through TR-PLAT-006 | [architecture-views.md](architecture-views.md) | Architecture diagram and component overview. | Required containers are listed in acceptance evidence. | Component-level monitoring is not integrated with enterprise observability. |
| BR-003: Provide reproducible guidance | TR-INF-001 through TR-INF-008 | [README.md](README.md) | Step-by-step installation process and sanitized inventory. | Inventory parse, command outputs, and validation matrix. | Full automation of preflight and validation is still planned. |
| BR-004: Use sanitized public artifacts | TR-SEC-001 through TR-SEC-003 | [security-and-compliance-model.md](security-and-compliance-model.md) | Passwords replaced with `<redacted>`. | Secret scan passes. | Enterprise secrets platform integration is not implemented. |
| BR-005: Explain architecture decisions | TR-PLAT-001 through TR-PLAT-009 | [architecture-decision-records.md](architecture-decision-records.md) | ADRs document topology, database, Redis, FIPS, metrics, and gateway decisions. | Architecture review checklist confirms decision coverage. | Future production decisions need separate approval. |
| BR-006: Define operational ownership | TR-OPS-001 through TR-OPS-006 | [stakeholder-operating-model.md](stakeholder-operating-model.md) | Operating model and RACI-style responsibility matrix. | Operations runbook lists health checks and evidence. | Production support ownership must be mapped to real teams. |
| BR-007: Explain security and compliance posture | TR-SEC-001 through TR-SEC-008 | [security-and-compliance-model.md](security-and-compliance-model.md) | Security posture, trust boundaries, and compliance limitations. | Network/security design and acceptance evidence. | SSO, RBAC, certificates, audit export, and FIPS are not implemented. |
| BR-008: Identify production readiness gaps | NFR-001 through NFR-007 | [production-readiness-roadmap.md](production-readiness-roadmap.md) | Roadmap documents required changes before production. | Known limitations are explicitly documented. | Production migration requires design, implementation, and testing. |
| BR-009: Support consulting-style discussion | TR-VAL-001 through TR-VAL-008 | [architecture-review-checklist.md](architecture-review-checklist.md) | Review checklist and client-facing conclusion. | Architecture package can be reviewed against acceptance criteria. | Customer-specific requirements must be gathered before final design. |
| BR-010: Support configuration-as-code work | TR-INT-001 through TR-INT-008 | [post-install-platform-configuration.md](post-install-platform-configuration.md) | Configuration domains and implementation sequence defined. | Evidence to capture is listed. | Platform configuration-as-code is not implemented yet. |
| BR-011: Provide evidence-based validation | TR-VAL-001 through TR-VAL-008 | [acceptance-test-evidence.md](acceptance-test-evidence.md) | Browser screenshot, container names, volume names, and inventory criteria. | Acceptance status is marked passed where evidence exists. | API token, backup, restore, RBAC, and workflow evidence remain additional evidence. |
| BR-012: Define a path to scale | NFR-001 and NFR-002 | [capacity-and-scaling-strategy.md](capacity-and-scaling-strategy.md) | Current sizing and scale triggers documented. | Resource and capacity checks are in the operations runbook. | Load testing and workload-specific capacity planning are not complete. |

## Traceability Status

| Area | Status | Notes |
| --- | --- | --- |
| Business requirements | Complete for project environment | Requirements are defined for a non-production architecture project. |
| Technical requirements | Complete for project environment | Requirements map to the AAP 2.7 container growth topology. |
| Implementation evidence | Partially complete | Installation, inventory, browser, container, and volume evidence are present. |
| Operational evidence | Partially complete | Runbooks are present; backup and restore execution evidence remains to be captured. |
| Production readiness | Planned | Roadmap identifies the technical work required before production adoption. |

## Open Traceability Items

| Item | Required Action |
| --- | --- |
| API validation evidence | Capture gateway API token test without exposing token values. |
| Subscription activation evidence | Capture manifest activation screenshot without exposing sensitive account information. |
| Backup evidence | Run the supported backup playbook and capture sanitized output. |
| Restore evidence | Restore into a non-production clone and capture validation output. |
| RBAC evidence | Implement sample organizations, teams, and roles, then capture screenshots. |
| Workflow evidence | Create and launch a sample workflow template. |
| Automation code evidence | Add preflight and validation playbooks, roles, and CI checks. |

