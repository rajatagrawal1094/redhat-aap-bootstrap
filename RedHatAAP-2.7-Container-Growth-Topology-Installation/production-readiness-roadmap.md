# Production Readiness Roadmap

## Purpose

This roadmap explains how the single-VM AAP 2.7 container growth topology project can evolve into a production-ready automation platform.

The current project is a strong baseline for learning, PoC, workshops, and consulting demonstrations. It is not a final production architecture.

## Current State

| Area | Current Position |
| --- | --- |
| Topology | Container growth topology on one RHEL VM. |
| Availability | No high availability. |
| Database | Installer-managed local PostgreSQL. |
| Redis | Standalone Redis. |
| Identity | Local platform login for initial validation. |
| Certificates | Installer-generated or non-production certificate posture. |
| Secrets | Public artifacts are sanitized; no enterprise secrets integration yet. |
| Backup | Procedure documented; restore test evidence not yet captured. |
| Monitoring | Command-based health checks documented. |
| Automation content | Post-install configuration plan documented; content governance not implemented. |

## Roadmap Phases

| Phase | Focus | Outcomes |
| --- | --- | --- |
| Phase 1 | Baseline platform validation | Installation, inventory, browser, container, and volume validation complete. |
| Phase 2 | Governance foundation | Subscription manifest, organizations, teams, RBAC, credentials, inventories, and projects configured. |
| Phase 3 | Configuration as code | Platform objects managed from Git-backed configuration files. |
| Phase 4 | Operational readiness | Backups tested, monitoring added, certificate lifecycle defined, runbooks exercised. |
| Phase 5 | Integration readiness | Source control, secrets, ITSM, observability, source of truth, and notification integrations configured. |
| Phase 6 | Production architecture | Enterprise topology, external database, automation mesh, SSO, trusted certificates, and DR plan implemented. |

## Production Readiness Checklist

| Area | Required Production Action | Current Status |
| --- | --- | --- |
| Topology | Decide whether enterprise topology is required. | Gap identified. |
| High availability | Define redundancy for gateway, controller, hub, EDA, metrics, database, and execution capacity. | Not implemented. |
| Database | Evaluate and design external PostgreSQL. | Not implemented. |
| Redis | Confirm Redis mode and resilience pattern for production topology. | Standalone in current project. |
| Identity | Integrate with enterprise identity provider. | Not implemented. |
| RBAC | Define organizations, teams, roles, permissions, and separation of duties. | Planned. |
| Certificates | Replace installer-generated certificates with trusted certificates. | Not implemented. |
| Secrets | Integrate approved secrets management process or platform. | Not implemented. |
| Backup | Run and validate supported backup playbook. | Documented only. |
| Restore | Test restore into a non-production clone. | Not implemented. |
| Monitoring | Integrate with enterprise observability and alerting. | Command-based checks only. |
| Logging | Define platform log retention, collection, and audit use cases. | Not implemented. |
| Content governance | Define certified, validated, community, and internal content lifecycle. | Planned. |
| Execution environments | Define approved build, test, publish, and promotion flow. | Planned. |
| Automation mesh | Add execution nodes where network locality or workload isolation is required. | Not implemented. |
| Change management | Align platform changes with enterprise maintenance and approval processes. | Basic checklist documented. |
| Compliance | Map controls to organizational policy and regulatory requirements. | Not implemented. |

## Migration Considerations

| Consideration | Guidance |
| --- | --- |
| Hostname | Keep the production FQDN stable and trusted by users and API clients. |
| Inventory | Treat installer inventory as a controlled architecture artifact. |
| Database | Plan whether data will be migrated or the production environment will be built fresh. |
| Certificates | Introduce trusted certificates before broad user adoption. |
| Identity | Configure SSO before onboarding many users. |
| RBAC | Define access model before publishing production job templates. |
| Content | Establish promotion rules before syncing broad content into private automation hub. |
| Credentials | Avoid manually entered long-lived secrets where enterprise vault integration is available. |
| Backup | Test restore before treating the platform as a critical service. |

## Production Decision Gates

| Gate | Question | Required Evidence |
| --- | --- | --- |
| Gate 1 | Is this topology acceptable for the target workload? | Architecture review and workload assumptions. |
| Gate 2 | Is the platform recoverable? | Backup and restore test evidence. |
| Gate 3 | Is access governed? | SSO, RBAC, organization, team, and audit evidence. |
| Gate 4 | Are secrets protected? | Credential model and secrets integration evidence. |
| Gate 5 | Is content governed? | Hub sync, collection approval, and EE promotion evidence. |
| Gate 6 | Is the platform observable? | Monitoring, logging, alert, and health dashboard evidence. |
| Gate 7 | Is execution capacity sufficient? | Capacity test results and scaling design. |
| Gate 8 | Is operational ownership clear? | RACI, runbooks, support model, and escalation path. |

