# Known Limitations

## Purpose

This document states the known limitations of the AAP 2.7 container growth topology project.

The goal is to prevent readers from mistaking a successful single-VM installation for a production-ready enterprise architecture.

## Limitations

| ID | Limitation | Impact | Recommended Next Step |
| --- | --- | --- | --- |
| LIM-001 | Single VM failure domain | VM failure affects gateway, controller, hub, EDA, metrics, PostgreSQL, Redis, and local volumes. | Use enterprise topology for production availability requirements. |
| LIM-002 | No high availability | Platform services are not redundant. | Define HA requirements and target topology before production use. |
| LIM-003 | Local PostgreSQL | Database lifecycle, backup, restore, and failure handling are tied to the AAP VM. | Evaluate external PostgreSQL for production. |
| LIM-004 | Standalone Redis | Redis is not deployed as a resilient service. | Review Redis requirements in production topology planning. |
| LIM-005 | Non-FIPS installation | The environment should not be represented as FIPS compliant. | Enable FIPS during RHEL installation if required. |
| LIM-006 | Installer-generated or non-production certificates | Browser trust warnings can occur and certificate lifecycle is not enterprise-managed. | Replace with organization-approved certificates. |
| LIM-007 | No SSO implementation | User lifecycle and authentication are not integrated with enterprise identity. | Configure supported SSO integration before broad onboarding. |
| LIM-008 | RBAC not fully implemented | Least-privilege access is documented but not proven through platform configuration. | Implement organizations, teams, roles, and access tests. |
| LIM-009 | No restore test evidence | Recoverability is not proven end to end. | Run restore into a non-production clone and capture evidence. |
| LIM-010 | No workload benchmark | Capacity is not validated under real production job load. | Run representative job concurrency and duration tests. |
| LIM-011 | No enterprise monitoring integration | Health checks are command-based and manual. | Integrate logs, metrics, and alerts with enterprise observability. |
| LIM-012 | No secrets platform integration | Public artifacts are sanitized, but enterprise secrets workflow is not implemented. | Integrate with approved vault or secret management process. |
| LIM-013 | No ITSM integration | Request and incident-driven workflows are not implemented. | Integrate with ITSM after RBAC and credential model are ready. |
| LIM-014 | No source-of-truth inventory integration | Inventory source integration is planned but not implemented. | Add dynamic inventory from NetBox, CMDB, cloud, or approved source. |
| LIM-015 | No automation mesh expansion | Execution capacity is local to the single project environment. | Add execution nodes when isolation, scaling, or target proximity is required. |

## Appropriate Uses

This project is appropriate for:

- learning
- hands-on platform exploration
- proof of concept deployments
- demos
- instructor-led workshops
- architecture discussions
- configuration-as-code design planning
- portfolio evidence

## Inappropriate Uses Without Additional Work

This project should not be used as-is for:

- critical production automation
- regulated FIPS workloads
- strict high availability requirements
- multi-site disaster recovery
- large-scale job execution
- sensitive credential operations without enterprise secrets controls
- broad enterprise user onboarding without SSO and RBAC

