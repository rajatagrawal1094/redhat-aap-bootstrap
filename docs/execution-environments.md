---
title: Execution Environments
---

# Execution Environments

Execution environments define reproducible automation runtimes for AAP jobs.

## Planned Environments

### EE Platform Base

Used for controller configuration, Linux operations, and common API tasks.

### EE Cloud Automation

Used for cloud, Kubernetes, and hybrid infrastructure workflows.

### EE Security Automation

Used for security checks, certificates, Vault lookups, and compliance reporting.

## Design Requirements

- Store execution environment definitions in Git.
- Build images through CI/CD.
- Publish images to an approved registry or Private Automation Hub.
- Register images in automation controller.
- Attach execution environments to job templates intentionally.
