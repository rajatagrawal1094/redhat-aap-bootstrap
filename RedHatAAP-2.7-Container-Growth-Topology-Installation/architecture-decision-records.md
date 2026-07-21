# Architecture Decision Records

This file captures the key architecture decisions for the AAP 2.7 container growth topology project.

## Decision Summary

| ID | Decision | Status | Reason |
| --- | --- | --- | --- |
| ADR-001 | Use AAP 2.7 containerized installer | Accepted | AAP 2.7 supports containerized installation on RHEL, and this project targets a VM-based deployment rather than OpenShift. |
| ADR-002 | Use container growth topology | Accepted | Provides a smaller-footprint AAP deployment suitable for labs, PoCs, workshops, and solution architecture demonstrations. |
| ADR-003 | Use one RHEL 10.2 VM | Accepted | Keeps the project environment reproducible while still showing gateway, controller, hub, EDA, metrics, PostgreSQL, and Redis together. |
| ADR-004 | Use local PostgreSQL for this project | Accepted | Reduces installation complexity for this installation. Production designs should evaluate an external PostgreSQL service. |
| ADR-005 | Use standalone Redis | Accepted | Matches the single-node project environment pattern. Redis HA or clustering is deferred to enterprise topology design. |
| ADR-006 | Install in non-FIPS mode | Accepted | Keeps the project environment straightforward. FIPS must be selected at the RHEL OS installation stage when required. |
| ADR-007 | Set `hub_seed_collections=false` | Accepted | Reduces initial installation time and resource usage. Collection synchronization is a post-install task. |
| ADR-008 | Enable Automation Metrics Service | Accepted | The AAP 2.7 growth topology installer preflight required an automation metrics host in this project environment. |
| ADR-009 | Defer Lightspeed and Ansible MCP Server | Accepted | Keeps this installation focused on core platform readiness. These services can be added as optional extensions. |
| ADR-010 | Use platform gateway as the access point | Accepted | AAP 2.7 routes user and API access through platform gateway, which centralizes the user experience and API entry point. |

## ADR-001 - Containerized Installer

Context: The project needed an AAP 2.7 deployment on a RHEL VM.

Decision: Use the AAP 2.7 containerized installer package.

Consequences:

- AAP services run as Podman containers.
- The installer inventory becomes a critical architecture artifact.
- Operational runbooks must cover container health, named volumes, backup, restore, and upgrade lifecycle.

## ADR-002 - Container Growth Topology

Context: The project needed a realistic but reproducible AAP environment for architecture validation and technical demonstration.

Decision: Use the container growth topology.

Consequences:

- The design is suitable for projects, PoCs, demos, workshops, and small non-critical environments.
- The design is not highly available.
- A production design must revisit topology, database placement, execution capacity, certificates, monitoring, and disaster recovery.

## ADR-003 - Single RHEL VM

Context: The goal was to install all major AAP services in one environment without requiring a multi-node deployment.

Decision: Use one RHEL 10.2 VM with 8 vCPU, 48 GB RAM, and 500 GB disk.

Consequences:

- All platform services share one failure domain.
- Sizing is above the documented minimum and appropriate for a hands-on project environment.
- Resource monitoring matters because gateway, controller, hub, EDA, metrics, PostgreSQL, and Redis share the same host.

## ADR-004 - Local PostgreSQL

Context: The platform needs PostgreSQL databases for AAP components.

Decision: Use installer-managed local PostgreSQL for this project.

Consequences:

- Installation is simpler.
- Database lifecycle is tied to the AAP VM.
- Production migration should consider external PostgreSQL, database backup ownership, restore testing, and performance requirements.

## ADR-005 - Standalone Redis

Context: Redis is required by AAP components for cache, queueing, and platform communication patterns.

Decision: Use `redis_mode=standalone`.

Consequences:

- Redis design matches the single-node project environment.
- Redis is not highly available.
- Enterprise topology planning should revisit Redis resilience requirements.

## ADR-006 - Non-FIPS

Context: The project environment does not target regulated FIPS workloads.

Decision: Install the RHEL VM and AAP in non-FIPS mode.

Consequences:

- Installation is simpler.
- This environment should not be represented as FIPS compliant.
- If FIPS is required, rebuild the RHEL VM with FIPS enabled during OS installation.

## ADR-007 - Hub Collection Seeding Disabled

Context: Private Automation Hub can be installed with or without initial collection seeding.

Decision: Use `hub_seed_collections=false`.

Consequences:

- Initial installation is smaller and faster.
- Hub starts without seeded collections.
- Certified, validated, community, and internal content can be synchronized after base platform validation.

## ADR-008 - Automation Metrics Service Included

Context: During installation, the AAP 2.7 container growth topology preflight required a host in `[automationmetrics]`.

Decision: Install Automation Metrics Service on the same VM.

Consequences:

- Metrics service is present in this installation.
- Metrics has its own database and read-only access to controller data.
- Backup and operations runbooks must include metrics service considerations.

## ADR-009 - Lightspeed And MCP Deferred

Context: The inventory includes optional sections for Ansible Lightspeed and Ansible MCP Server.

Decision: Defer these services for this installation.

Consequences:

- This installation focuses on core AAP platform services.
- Lightspeed and MCP can be added as optional extensions with their own configuration, security review, and validation.

## ADR-010 - Gateway-First Access

Context: AAP 2.7 introduces platform gateway as the main entry point.

Decision: Treat platform gateway as the user and API entry point.

Consequences:

- Users access `https://aap.lab.example.com`.
- API clients should use gateway-routed API paths.
- Direct component API access is not the target integration pattern for this project.
