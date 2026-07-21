# Capacity And Scaling Strategy

## Purpose

This document explains the capacity assumptions for the AAP 2.7 container growth topology project and defines triggers for scaling beyond the single-VM design.

The goal is to show why the selected resources are reasonable for this project environment and when a production design should move to a larger topology.

## Current Project Sizing

| Resource | Project Value | Rationale |
| --- | --- | --- |
| vCPU | 8 | Provides headroom above the documented minimum for running gateway, controller, hub, EDA, metrics, PostgreSQL, Redis, and OS services on one VM. |
| Memory | 48 GB | Provides extra memory for multiple AAP services on one host and leaves room for controller, hub, EDA, metrics, database, Redis, and system overhead. |
| Disk | 500 GB | Provides room for container images, installer files, logs, PostgreSQL data, hub content, EDA data, and future validation artifacts. |
| Architecture | ARM64 / AArch64 | Matches the available VMware project environment and is supported by the AAP 2.7 containerized installer. |
| Topology | Container growth topology | Supports a smaller-footprint deployment without high availability. |

## Workload Assumptions

| Area | Assumption |
| --- | --- |
| Users | Small number of platform admins, developers, and operators. |
| Automation volume | Low to moderate job volume for learning, PoC, and demonstration use. |
| Execution targets | Limited Linux, Windows, network, cloud, or security targets for validation. |
| Hub content | Limited collection and execution environment content during initial installation. |
| EDA usage | Initial rulebook and event-driven automation validation only. |
| Metrics usage | Basic platform metrics service validation. |
| Availability requirement | No production SLA or HA requirement. |

## Capacity Watchpoints

| Watchpoint | Why It Matters | Example Check |
| --- | --- | --- |
| CPU pressure | High job concurrency can affect controller, EDA, hub, database, and gateway on the same VM. | `top`, `podman stats`, monitoring platform. |
| Memory pressure | All AAP services share one memory pool. | `free -h`, `podman stats`. |
| Disk capacity | Hub content, logs, database growth, and container images can consume space quickly. | `df -h`, `podman system df`, backup size trends. |
| Database growth | Job history, metrics, hub content, and platform state increase PostgreSQL storage needs. | PostgreSQL volume size and backup size. |
| Job queue depth | Backlog indicates execution capacity is insufficient. | Controller job status and queue observations. |
| Execution duration | Longer job runtimes can reduce available execution capacity. | Job history and metrics. |
| EDA event load | Event streams can increase worker and Redis/database pressure. | EDA worker health and event processing latency. |
| Hub content volume | Large content syncs and execution environment images require storage planning. | Hub storage and content sync results. |

## Scaling Triggers

| Trigger | Recommended Action |
| --- | --- |
| Need for platform high availability | Move from growth topology to enterprise topology. |
| Need for database lifecycle separation | Use external PostgreSQL with clear backup and restore ownership. |
| Increased job concurrency | Add execution capacity or automation mesh nodes. |
| Need to execute close to target networks | Add execution nodes near managed infrastructure. |
| Heavy EDA workloads | Evaluate EDA worker sizing, event source rate, and Redis/database pressure. |
| Large hub content footprint | Review storage allocation, content lifecycle, and registry strategy. |
| Production SLA or RTO/RPO target | Design redundant platform services, tested backup/restore, and monitoring. |
| Security segmentation requirement | Separate platform, database, execution, and target network zones. |

## Scaling Path

| Stage | Description | Architecture Direction |
| --- | --- | --- |
| Stage 1 | Single-VM project environment | Current container growth topology. |
| Stage 2 | Governed non-production platform | Add SSO, RBAC, configuration-as-code, backup testing, and monitoring. |
| Stage 3 | Expanded execution capacity | Add execution nodes or automation mesh for workload isolation and target proximity. |
| Stage 4 | Production-aligned platform | Evaluate enterprise topology, external database, trusted certificates, and operational controls. |
| Stage 5 | Enterprise automation service | Integrate with ITSM, secrets management, observability, source of truth, CI/CD, and security operations. |

## Recommended Capacity Evidence

Capture the following evidence during future workload testing:

- number of concurrent jobs
- average and peak job runtime
- controller task container CPU and memory
- PostgreSQL storage growth
- Redis CPU and memory
- hub content storage growth
- EDA event processing latency
- backup size and duration
- restore duration
- container restart count

## Production Capacity Planning Questions

- How many organizations and teams will use the platform?
- How many concurrent jobs are expected?
- What target networks must be reached?
- Are workloads long-running or short-lived?
- Is event-driven automation expected to process high-volume event streams?
- How much hub content will be synchronized or published?
- What job history retention is required?
- What RTO and RPO are required?
- Which workloads require isolation by environment, team, network zone, or compliance domain?

