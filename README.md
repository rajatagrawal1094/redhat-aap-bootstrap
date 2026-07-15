# Red Hat AAP Bootstrap

Configuration-as-Code project for bootstrapping Red Hat Ansible Automation Platform with controller objects, RBAC, execution environments, private automation hub, workflows, and enterprise integrations.

## Purpose

This repository demonstrates how to treat Red Hat Ansible Automation Platform as an enterprise automation service that can be configured, validated, and operated from source control.

The project is designed as a portfolio-grade implementation for senior infrastructure automation, platform engineering, solution architecture, and technical consulting roles.

## Target Platform Version

This project targets **Red Hat Ansible Automation Platform 2.7**. See [AAP 2.7 Lab Plan](docs/aap-27-lab-plan.md) before installing or connecting a lab environment.

For a complete reader-facing setup walkthrough, see [AAP 2.7 Step-by-Step Installation Guide](docs/aap-27-step-by-step-installation-guide.md).

## Current Lab Status

The base AAP 2.7 containerized platform install is complete in the lab.

Installed on the single-node `aap.lab.example.com` VM:

- platform gateway
- automation controller
- private automation hub
- Event-Driven Ansible controller
- Automation Metrics Service
- local database

Deferred add-ons:

- Ansible Lightspeed
- Ansible MCP Server

## What This Project Will Build

- Platform connectivity and prerequisite validation
- Automation controller configuration as code
- Organizations, teams, users, and RBAC
- Inventories, credentials, projects, and job templates
- Workflow templates for enterprise operations
- Private Automation Hub content governance patterns
- Custom execution environment definitions
- Notification and ticketing integration patterns
- CI/CD validation for automation content
- Documentation for architecture, operations, and demo delivery

## Target Architecture

![AAP 2.7 containerized lab architecture](docs/assets/aap-27-containerized-architecture.svg)

Interactive explorer: [docs/interactive/aap-architecture.html](docs/interactive/aap-architecture.html). Open it locally or serve it through GitHub Pages for full interactivity.

Platform screenshots: [docs/platform-screenshots.md](docs/platform-screenshots.md)

```text
GitHub repository
  |
  |-- config-as-code YAML
  |-- custom Ansible collection
  |-- execution environment definitions
  |-- CI/CD validation
  |
Red Hat Ansible Automation Platform
  |
  |-- platform gateway
  |-- automation controller
  |-- private automation hub
  |-- optional Event-Driven Ansible
  |
Enterprise integrations
  |
  |-- GitHub
  |-- Vault or SOPS
  |-- Slack or Microsoft Teams
  |-- Jira or ServiceNow-style ticketing
  |-- container registry
```

## Repository Layout

```text
.
├── collections/                 # Custom Ansible collection source
├── config/                      # Declarative AAP configuration data
├── docs/                        # Architecture and operating documentation
├── execution-environments/      # Custom execution environment definitions
├── inventories/                 # Example inventories
├── playbooks/                   # Bootstrap, configure, and validate playbooks
├── .github/workflows/           # CI/CD workflows
├── ansible.cfg                  # Local Ansible configuration
├── requirements.yml             # Public collection dependencies
└── Makefile                     # Common operator/developer commands
```

## Quick Start

Install public Ansible collection dependencies:

```bash
make install-requirements
```

Run static checks:

```bash
make lint
```

Validate local prerequisites:

```bash
make validate-prereqs
```

The AAP connection values are intentionally not committed. Copy `.env.example` or `inventories/group_vars/all.example.yml` into private local files before connecting this project to a real AAP instance.

## Security Notice

Do not commit:

- Red Hat subscription manifests
- registry credentials
- AAP access tokens
- private automation hub tokens
- vault passwords
- SSH private keys
- real customer or employer hostnames
- internal IP addresses
- exported platform database backups

All committed examples must remain sanitized and demo-safe.

## Project Roadmap

1. Repository foundation and documentation
2. AAP connectivity and health checks
3. Controller configuration as code
4. Private Automation Hub configuration
5. Execution environment build and registration
6. Enterprise Linux patch workflow
7. Notifications and ticketing integration
8. CI/CD pipeline for automation content
9. Optional Event-Driven Ansible remediation workflow
10. Portfolio demo video and screenshots

## Portfolio Outcomes

This project is intended to demonstrate:

- Ansible Automation Platform architecture
- AAP administration and configuration automation
- Ansible collection design
- Role and playbook development
- Execution environment lifecycle management
- RBAC and delegation design
- Secure credential handling
- Enterprise workflow automation
- CI/CD for infrastructure automation
- Technical documentation and enablement
