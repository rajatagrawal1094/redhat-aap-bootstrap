# Business Requirements Document

## Document Purpose

This Business Requirements Document defines the business need, scope, stakeholders, success criteria, and business-level acceptance requirements for a Red Hat Ansible Automation Platform 2.7 container growth topology installation.

The project demonstrates how an organization can create a reproducible automation platform environment for learning, proof of concept work, workshops, platform validation, and early solution architecture discussions.

## Business Problem

Infrastructure, operations, security, and platform teams often need a controlled environment to evaluate enterprise automation capabilities before committing to a production architecture. Without a working platform, architecture discussions can stay abstract and disconnected from practical requirements such as access control, content governance, event-driven automation, reporting, backup, and operational ownership.

This project solves that problem by creating a complete single-VM AAP 2.7 environment that exposes the major platform services and documents the business and technical tradeoffs.

## Business Objectives

| ID | Objective | Description |
| --- | --- | --- |
| BO-001 | Establish a working AAP platform | Install AAP 2.7 with gateway, controller, private automation hub, Event-Driven Ansible controller, metrics service, PostgreSQL, and Redis. |
| BO-002 | Support architecture validation | Provide a practical environment for topology, sizing, access, content, and integration discussions. |
| BO-003 | Enable automation governance planning | Define how users, teams, RBAC, credentials, inventories, projects, and workflows would be governed after installation. |
| BO-004 | Reduce proof of concept lead time | Provide repeatable installation guidance and sanitized artifacts that can be reused for demonstrations and customer conversations. |
| BO-005 | Document production gaps | Clearly separate what this single-VM project proves from what a production deployment still requires. |
| BO-006 | Create portfolio-grade evidence | Produce artifacts that demonstrate solution architecture discipline, not only product installation steps. |

## Business Scope

### In Scope

- Document business and technical requirements for the AAP 2.7 project environment.
- Install AAP 2.7 using the container growth topology.
- Validate the installation through browser access, inventory parsing, container checks, and volume checks.
- Document architecture decisions, network/security design, backup and restore posture, operations runbook, and acceptance evidence.
- Define optional post-install configuration work for platform governance.
- Identify a path from this project environment to a production-ready architecture.

### Out Of Scope

- Production high availability implementation.
- External PostgreSQL deployment.
- Enterprise SSO implementation.
- Full RBAC implementation.
- Automation mesh expansion.
- Production certificate replacement.
- Backup and restore execution evidence.
- Live integration with ITSM, secrets management, source-of-truth, SIEM, or observability platforms.
- Performance benchmarking under production workload.

## Business Stakeholders

| Stakeholder | Business Interest |
| --- | --- |
| Executive sponsor | Understand the value of automation platform adoption and the path to production readiness. |
| Platform owner | Establish platform ownership, lifecycle, operating model, and governance. |
| Infrastructure operations | Validate operational automation patterns for Linux, Windows, network, cloud, and virtualization domains. |
| Security team | Review credential handling, RBAC, auditability, certificate posture, and compliance limitations. |
| Automation developers | Use a working platform to build, test, and promote automation content. |
| Service owners | Understand how job templates and workflows can standardize operational tasks. |
| Support team | Understand day-2 checks, incident triage, backup expectations, and escalation paths. |
| Enterprise architecture | Confirm topology fit, integration patterns, constraints, and production migration path. |

## Business Requirements

| ID | Requirement | Priority | Acceptance Criteria |
| --- | --- | --- | --- |
| BR-001 | The project must provide a working AAP 2.7 platform environment. | Must | AAP UI loads through platform gateway and required containers are running. |
| BR-002 | The project must demonstrate the major AAP service domains. | Must | Gateway, controller, hub, EDA, metrics, PostgreSQL, and Redis are documented and visible in the design. |
| BR-003 | The project must be reproducible by a technical reader. | Must | Installation steps, prerequisites, inventory, validation commands, and command outputs are documented. |
| BR-004 | The project must use sanitized public artifacts. | Must | Passwords, registry secrets, tokens, and manifests are not committed. |
| BR-005 | The project must explain key architecture decisions. | Must | Architecture Decision Records are available and linked from the README. |
| BR-006 | The project must define operational ownership and day-2 checks. | Should | Operations runbook and stakeholder operating model are documented. |
| BR-007 | The project must explain security and compliance posture. | Should | Network/security design and security/compliance model identify controls and limitations. |
| BR-008 | The project must identify production readiness gaps. | Must | Production roadmap and known limitations clearly state what remains before production use. |
| BR-009 | The project must support consulting-style customer discussion. | Should | Business requirements, technical requirements, traceability, and review checklist are included. |
| BR-010 | The project must support future configuration-as-code work. | Should | Post-install configuration domains and recommended implementation order are documented. |
| BR-011 | The project must show evidence-based validation. | Must | Acceptance evidence includes browser, inventory, container, volume, and topology validation. |
| BR-012 | The project must define a clear path to scale. | Should | Capacity and scaling strategy describes watchpoints and triggers for enterprise topology or automation mesh. |

## Business Success Criteria

| Success Criteria | Measurement |
| --- | --- |
| Platform installation completed | Installer completes with `failed=0` and `unreachable=0`. |
| Platform access validated | Browser reaches `https://aap.lab.example.com`. |
| Core services running | Podman container validation shows required AAP services. |
| Platform data persistence visible | Podman volume validation shows required named volumes. |
| Architecture package complete | BRD, TRD, ADRs, security, operations, backup, traceability, roadmap, and limitations are present. |
| Public artifacts safe | Secret scan finds no real passwords, private keys, or tokens. |
| Production boundary clear | Documentation states that this is not a highly available production architecture. |

## Business Risks

| Risk | Business Impact | Mitigation |
| --- | --- | --- |
| Single-VM failure domain | Entire platform is unavailable if the VM fails. | Position this as learning, PoC, demo, and non-critical use only; document production topology path. |
| Local PostgreSQL | Database lifecycle depends on the same VM. | Document external database as a production readiness item. |
| No SSO or RBAC implementation yet | Governance is not fully proven. | Define RBAC and identity as post-install configuration work. |
| Installer-generated certificates | Users may see browser trust warnings. | Replace with organization-approved certificates for production. |
| No restore test evidence yet | Recoverability is not proven end to end. | Add restore testing as a required production readiness activity. |
| No workload benchmark | Capacity assumptions are not production validated. | Track resource usage and define scaling triggers. |

## Assumptions

- The organization has access to Red Hat subscriptions and AAP 2.7 installation media.
- The environment can reach Red Hat subscription and registry services.
- The project environment is non-production.
- The hostname `aap.lab.example.com` and static IP `192.168.34.155` are valid for this project environment.
- The installer user has sudo access through the `wheel` group.
- Public project artifacts must not contain real secrets.

## Constraints

- Single RHEL VM.
- Local PostgreSQL.
- Standalone Redis.
- Non-FIPS installation.
- No platform high availability.
- No production SSO, certificate, backup automation, or monitoring implementation in the base installation.

## Dependencies

- Red Hat Enterprise Linux 10.2 VM.
- Red Hat subscription registration.
- Red Hat registry access.
- AAP 2.7 containerized installer package.
- Working DNS and time synchronization.
- Workstation browser access to the AAP FQDN.

## Business Acceptance

The business-level acceptance condition is met when the project provides a working AAP 2.7 environment and a complete architecture package that explains why the topology was selected, what it proves, what it does not prove, and what must change before production adoption.

