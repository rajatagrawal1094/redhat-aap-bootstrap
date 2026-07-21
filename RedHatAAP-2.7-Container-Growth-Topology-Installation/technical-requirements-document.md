# Technical Requirements Document

## Document Purpose

This Technical Requirements Document defines the technical requirements for installing and validating Red Hat Ansible Automation Platform 2.7 using the container growth topology on a single Red Hat Enterprise Linux VM.

It translates the business requirements into platform, infrastructure, security, operations, validation, and production-readiness requirements.

## Technical Scope

The technical scope includes:

- RHEL host preparation.
- AAP 2.7 containerized installer execution.
- `inventory-growth` configuration.
- Platform gateway, automation controller, private automation hub, Event-Driven Ansible controller, Automation Metrics Service, PostgreSQL, and Redis deployment.
- Browser and container-level validation.
- Supporting architecture and operational documentation.

The technical scope does not include production high availability, external PostgreSQL, SSO, full RBAC implementation, automation mesh expansion, restore test execution, or production monitoring implementation.

## Target Environment

| Item | Value |
| --- | --- |
| AAP version | 2.7 |
| Installer | `ansible-automation-platform-containerized-setup-2.7-2` |
| Deployment topology | Container growth topology |
| Deployment model | Single RHEL VM |
| Hostname | `aap.lab.example.com` |
| IP address | `192.168.34.155` |
| OS | Red Hat Enterprise Linux 10.2 |
| Architecture | ARM64 / AArch64 |
| vCPU | 8 |
| Memory | 48 GB |
| Disk | 500 GB |
| FIPS | Disabled |
| Installer user | `rajat` with sudo access through `wheel` |
| Database | Installer-managed local PostgreSQL |
| Redis | Standalone Redis |

## Platform Component Requirements

| ID | Requirement | Implementation |
| --- | --- | --- |
| TR-PLAT-001 | Platform gateway must be installed as the primary UI and API entry point. | `[automationgateway]` points to `aap.lab.example.com`. |
| TR-PLAT-002 | Automation controller must be installed for job execution and workflow orchestration. | `[automationcontroller]` points to `aap.lab.example.com`. |
| TR-PLAT-003 | Private automation hub must be installed for content management. | `[automationhub]` points to `aap.lab.example.com`. |
| TR-PLAT-004 | Event-Driven Ansible controller must be installed for event-based automation capability. | `[automationeda]` points to `aap.lab.example.com`. |
| TR-PLAT-005 | Automation Metrics Service must be installed. | `[automationmetrics]` points to `aap.lab.example.com`. |
| TR-PLAT-006 | PostgreSQL must be available locally for platform databases. | `[database]` points to `aap.lab.example.com`. |
| TR-PLAT-007 | Redis must run in standalone mode. | `redis_mode=standalone`. |
| TR-PLAT-008 | Hub collection seeding must be disabled for the initial install. | `hub_seed_collections=false`. |
| TR-PLAT-009 | Dashboard collection feature must be disabled for the initial build. | `FEATURE_DASHBOARD_COLLECTION_ENABLED=false`. |

## Infrastructure Requirements

| ID | Requirement | Acceptance Criteria |
| --- | --- | --- |
| TR-INF-001 | VM must meet or exceed AAP 2.7 containerized installer requirements. | VM has 8 vCPU, 48 GB RAM, and 500 GB disk. |
| TR-INF-002 | VM must use a supported RHEL version. | `hostnamectl` shows RHEL 10.2. |
| TR-INF-003 | VM must have static hostname and IP configuration. | Hostname is `aap.lab.example.com`; IP is `192.168.34.155/24`. |
| TR-INF-004 | Time synchronization must be enabled. | `timedatectl` shows synchronized clock and active NTP. |
| TR-INF-005 | RHEL subscription and content access must be active. | `rhc status` confirms connection and repository generation. |
| TR-INF-006 | VM must resolve and reach Red Hat registry endpoints. | `curl -I https://registry.redhat.io/v2/` returns HTTP `401` before authentication. |
| TR-INF-007 | Podman must be available. | `podman --version` returns an installed version. |
| TR-INF-008 | Installer must run from the target host. | `ansible_connection=local`. |

## Security Requirements

| ID | Requirement | Acceptance Criteria |
| --- | --- | --- |
| TR-SEC-001 | Public project artifacts must not include real passwords. | Password fields use `<redacted>` in committed files. |
| TR-SEC-002 | Registry credentials must not be committed. | `registry_password=<redacted>` in public inventory. |
| TR-SEC-003 | Subscription manifests must not be committed. | `.gitignore` excludes manifest and secret artifacts. |
| TR-SEC-004 | Installer user must have controlled sudo access. | User is a member of `wheel`. |
| TR-SEC-005 | PostgreSQL and Redis must not be exposed to user networks. | Network design states that these services remain internal to the VM or platform network. |
| TR-SEC-006 | Browser certificate posture must be documented. | Certificate warning guidance and production certificate recommendation are documented. |
| TR-SEC-007 | Production identity integration must be identified as a future requirement. | SSO and RBAC are documented as production readiness items. |
| TR-SEC-008 | FIPS posture must be clear. | Non-FIPS decision is documented; FIPS requires OS-level enablement before installation. |

## Operational Requirements

| ID | Requirement | Acceptance Criteria |
| --- | --- | --- |
| TR-OPS-001 | Day-2 health checks must be documented. | Operations runbook includes hostname, time, subscription, container, and volume checks. |
| TR-OPS-002 | Incident triage must be documented. | Operations runbook includes common symptoms and first checks. |
| TR-OPS-003 | Backup and restore posture must be documented. | Backup and restore runbook includes procedures and validation expectations. |
| TR-OPS-004 | Change management checks must be documented. | Operations runbook includes pre-change and post-change checks. |
| TR-OPS-005 | Acceptance evidence must be documented. | Acceptance evidence file captures completed validation areas. |
| TR-OPS-006 | Operational evidence must be retained in sanitized form. | Evidence list includes inventory, diagram, container output, volumes, browser screenshot, and backup/restore output. |

## Validation Requirements

| ID | Requirement | Validation Method |
| --- | --- | --- |
| TR-VAL-001 | Inventory must parse successfully. | `ansible-inventory -i inventory-growth --list`. |
| TR-VAL-002 | Inventory graph must show expected groups and host. | `ansible-inventory -i inventory-growth --graph`. |
| TR-VAL-003 | Active inventory must not include unresolved placeholders or hostname typos. | Placeholder and typo scan. |
| TR-VAL-004 | Installer must complete successfully. | Play recap shows `failed=0` and `unreachable=0`. |
| TR-VAL-005 | Gateway UI must load. | Browser reaches `https://aap.lab.example.com`. |
| TR-VAL-006 | Required containers must be running. | `podman ps --format` output includes required AAP service containers. |
| TR-VAL-007 | Required named volumes must exist. | `podman volume ls` output includes expected AAP volumes. |
| TR-VAL-008 | Podman pods must match expected topology behavior. | `podman pod ps` shows no pods for this project environment. |

## Integration Requirements

The base installation prepares for, but does not fully implement, the following integrations:

| ID | Integration | Requirement |
| --- | --- | --- |
| TR-INT-001 | Source control | AAP should be able to pull automation content from GitHub, GitLab, Bitbucket, or internal Git. |
| TR-INT-002 | Container registry | AAP should be able to use approved execution environment images. |
| TR-INT-003 | Private automation hub | Hub should support approved collection and execution environment content. |
| TR-INT-004 | ITSM | Future workflows should support request fulfillment, incident response, and approvals. |
| TR-INT-005 | Secrets management | Future design should integrate with an enterprise secrets platform. |
| TR-INT-006 | Observability | Future design should integrate platform and job telemetry with monitoring and alerting tools. |
| TR-INT-007 | Source of truth | Future inventories should support trusted inventory sources such as NetBox, CMDB, or cloud APIs. |
| TR-INT-008 | Security operations | Future EDA use cases should support SIEM, scanner, and compliance signals. |

## Nonfunctional Requirements

| ID | Requirement | Project Position | Production Position |
| --- | --- | --- | --- |
| NFR-001 | Availability | Single VM, no HA. | Use enterprise topology and resilient backing services. |
| NFR-002 | Scalability | Sized for learning and PoC. | Add execution nodes, automation mesh, and external services as workload grows. |
| NFR-003 | Recoverability | Backup and restore procedure documented. | Restore testing and RTO/RPO targets required. |
| NFR-004 | Security | Secrets redacted; local admin access used. | SSO, RBAC, secrets management, certificates, and audit integration required. |
| NFR-005 | Maintainability | Installer inventory and runbooks documented. | Change management, patching, upgrade planning, and monitoring required. |
| NFR-006 | Observability | Container and browser checks documented. | Centralized logs, metrics, alerts, and dashboards required. |
| NFR-007 | Compliance | Non-FIPS and non-production. | Compliance controls must be mapped to organizational requirements. |

## Technical Acceptance

The technical implementation is accepted when:

- the RHEL host is prepared and validated
- AAP 2.7 containerized installation completes successfully
- the platform UI loads through platform gateway
- the required containers and volumes are present
- the sanitized inventory parses successfully
- architecture, operational, security, backup, and validation documents are present
- known gaps are documented with a production roadmap

