# Stakeholder And Operating Model

## Purpose

This document defines the operating model for the AAP 2.7 container growth topology project. It identifies stakeholders, ownership boundaries, responsibilities, and handoff expectations.

The project environment is non-production, but the operating model shows how ownership would mature as the platform moves toward production.

## Stakeholder Map

| Stakeholder | Primary Interest | Project Responsibility |
| --- | --- | --- |
| Executive sponsor | Business value, risk, cost, and adoption path. | Approves investment and prioritizes automation outcomes. |
| Enterprise architect | Alignment with enterprise standards and platform strategy. | Reviews topology, integration model, production gaps, and roadmap. |
| Solution architect | Design quality, requirements traceability, and implementation fit. | Owns architecture package and technical recommendations. |
| Platform owner | AAP lifecycle, governance, and day-2 operations. | Owns platform configuration and operational readiness. |
| Linux/platform administrator | RHEL, Podman, host health, and patching. | Builds and maintains the VM and host-level services. |
| Automation developer | Playbooks, roles, collections, workflows, and execution environments. | Builds and maintains automation content. |
| Security team | Credentials, RBAC, identity, certificates, audit, and compliance. | Reviews security posture and approves production controls. |
| Network team | DNS, firewall, routing, and target access. | Provides inbound, outbound, and target network paths. |
| Database team | PostgreSQL lifecycle and recoverability. | Advises or owns database strategy when externalized. |
| Operations/support team | Monitoring, incident response, backups, and change control. | Runs health checks and handles incidents. |
| Business requester | Automation service consumption. | Requests, approves, or consumes automated services. |

## Responsibility Matrix

| Activity | Solution Architect | Platform Owner | Linux Admin | Security | Network | Automation Developer | Operations |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Define requirements | Accountable | Consulted | Consulted | Consulted | Consulted | Consulted | Consulted |
| Select topology | Accountable | Responsible | Consulted | Consulted | Consulted | Informed | Consulted |
| Build RHEL VM | Consulted | Informed | Responsible | Consulted | Consulted | Informed | Consulted |
| Register RHEL and enable content | Consulted | Informed | Responsible | Informed | Informed | Informed | Consulted |
| Configure installer inventory | Responsible | Accountable | Consulted | Consulted | Informed | Informed | Informed |
| Run AAP installer | Responsible | Accountable | Responsible | Informed | Informed | Informed | Consulted |
| Validate browser and containers | Responsible | Accountable | Responsible | Informed | Informed | Informed | Responsible |
| Define RBAC model | Responsible | Accountable | Informed | Consulted | Informed | Consulted | Consulted |
| Manage credentials | Consulted | Accountable | Informed | Responsible | Informed | Consulted | Consulted |
| Define network rules | Consulted | Consulted | Consulted | Consulted | Responsible | Informed | Informed |
| Back up and restore | Consulted | Accountable | Responsible | Consulted | Informed | Informed | Responsible |
| Monitor platform | Consulted | Accountable | Responsible | Consulted | Consulted | Informed | Responsible |
| Approve production migration | Responsible | Accountable | Consulted | Consulted | Consulted | Consulted | Consulted |

## Operating Principles

- Platform gateway is the preferred user and API entry point.
- Public artifacts must not contain passwords, tokens, manifests, or private key material.
- The project environment is suitable for learning, PoC, demos, workshops, and early architecture validation.
- Production adoption requires a separate architecture review and additional controls.
- Platform changes should be traceable to requirements, design decisions, and validation evidence.
- Day-2 operations should include health checks, backup planning, restore validation, certificate lifecycle, and capacity monitoring.

## Handoff Expectations

| Handoff Area | Required Artifact |
| --- | --- |
| Architecture | README, ADRs, architecture views, review checklist. |
| Requirements | BRD, TRD, traceability matrix. |
| Security | Network/security design, security/compliance model, known limitations. |
| Operations | Operations runbook, backup/restore runbook, acceptance evidence. |
| Platform configuration | Post-install configuration plan and automation implementation roadmap. |
| Production migration | Capacity/scaling strategy and production-readiness roadmap. |

## Production Operating Model Changes

Before a similar design is used for production, ownership should be updated as follows:

- Database ownership should move to a database or platform operations team if PostgreSQL is externalized.
- Certificate ownership should move to the PKI or security team.
- Backup and restore ownership should include storage, backup, and platform operations.
- Monitoring ownership should include the enterprise observability team.
- RBAC and identity ownership should include IAM and security.
- Change control should follow enterprise maintenance and approval processes.

