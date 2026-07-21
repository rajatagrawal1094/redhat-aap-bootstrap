# Architecture Views

## Purpose

This document provides additional architecture views for the AAP 2.7 container growth topology project.

The main architecture diagram is available as:

- [images/aap-27-containerized-architecture.svg](images/aap-27-containerized-architecture.svg)
- [images/aap-27-containerized-architecture.png](images/aap-27-containerized-architecture.png)

The views below focus on context, deployment, and data flow.

## Context View

```mermaid
flowchart LR
  Users["Platform admins, automation developers, operators"]
  AAP["AAP 2.7 project environment<br/>aap.lab.example.com"]
  RedHat["Red Hat subscription, repositories, and registry"]
  Git["Git repositories"]
  Targets["Managed infrastructure targets"]
  ITSM["ITSM and notification systems"]
  Secrets["Secrets platform"]
  Observability["Monitoring and logging"]

  Users -->|"HTTPS 443"| AAP
  AAP -->|"HTTPS 443"| RedHat
  AAP -->|"HTTPS or SSH"| Git
  AAP -->|"SSH, WinRM, network APIs, cloud APIs"| Targets
  AAP -. "future integration" .-> ITSM
  AAP -. "future integration" .-> Secrets
  AAP -. "future integration" .-> Observability
```

## Deployment View

```mermaid
flowchart TB
  subgraph VM["RHEL 10.2 VM - aap.lab.example.com - 192.168.34.155"]
    Gateway["Platform Gateway<br/>automation-gateway<br/>automation-gateway-proxy"]
    Controller["Automation Controller<br/>web, task, rsyslog"]
    Hub["Private Automation Hub<br/>api, content, web, workers"]
    EDA["Event-Driven Ansible<br/>api, daphne, web, workers"]
    Metrics["Automation Metrics Service<br/>web, tasks, scheduler"]
    Receptor["Receptor"]
    Postgres["Local PostgreSQL"]
    Redis["Standalone Redis<br/>redis-tcp, redis-unix"]
    Volumes["Podman named volumes"]
  end

  Gateway --> Controller
  Gateway --> Hub
  Gateway --> EDA
  Gateway --> Metrics
  Controller --> Receptor
  Controller --> Postgres
  Hub --> Postgres
  EDA --> Postgres
  Metrics --> Postgres
  Controller --> Redis
  EDA --> Redis
  Postgres --> Volumes
  Hub --> Volumes
  Redis --> Volumes
```

## Access Flow

```mermaid
sequenceDiagram
  actor User
  participant Gateway as Platform Gateway
  participant Controller as Automation Controller
  participant Hub as Private Automation Hub
  participant EDA as Event-Driven Ansible

  User->>Gateway: Open https://aap.lab.example.com
  Gateway->>Gateway: Authenticate and authorize
  User->>Gateway: Navigate to platform function
  Gateway->>Controller: Route controller UI/API request
  Gateway->>Hub: Route hub UI/API request
  Gateway->>EDA: Route EDA UI/API request
```

## Installation Flow

```mermaid
flowchart TD
  VM["Create RHEL VM"]
  User["Create sudo installer user"]
  Register["Register with rhc connect"]
  ValidateHost["Validate hostname, IP, time, DNS"]
  Registry["Validate registry.redhat.io access"]
  Installer["Download and extract AAP 2.7 installer"]
  Backup["Back up original inventory-growth"]
  Inventory["Configure sanitized inventory-growth"]
  Parse["Validate inventory with ansible-inventory"]
  Install["Run AAP installer"]
  Browser["Validate gateway UI"]
  Runtime["Validate containers and volumes"]

  VM --> User --> Register --> ValidateHost --> Registry --> Installer --> Backup --> Inventory --> Parse --> Install --> Browser --> Runtime
```

## Data And Persistence View

| Data Area | Location | Protection Consideration |
| --- | --- | --- |
| Platform configuration | PostgreSQL | Back up and protect as sensitive platform state. |
| Job history | PostgreSQL | Define retention and audit requirements before production. |
| Hub content | Hub data volume and PostgreSQL | Protect collection and execution environment content. |
| EDA state | EDA data and PostgreSQL | Include in backup and restore validation. |
| Redis data | Redis volumes | Keep internal to the platform network. |
| Installer inventory | Installer directory and Git-safe sanitized copy | Keep private values out of public repositories. |
| Subscription manifest | Platform UI and private file handling process | Do not commit manifest files. |
| Certificates and keys | Platform-managed paths | Protect and rotate through approved process. |

## Architecture Interpretation

This architecture is intentionally compact. It gives a complete view of AAP 2.7 services on one VM, but every major platform component shares the same compute, storage, network, and failure domain.

That makes the design useful for learning and validation, but production requirements should trigger a review of enterprise topology, external PostgreSQL, trusted certificates, SSO, RBAC, backup/restore testing, monitoring, automation mesh, and disaster recovery.

