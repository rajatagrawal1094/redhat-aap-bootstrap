---
title: Configuration As Code Model
---

# Configuration As Code Model

The `config/` directory is the declarative source of truth for AAP objects.

## Object Types

- organizations
- teams
- users
- role assignments
- inventories
- credentials
- projects
- job templates
- workflow templates
- notification templates
- schedules
- execution environments

## Environment Layout

```text
config/
  dev/
  prod-example/
```

The `dev` directory is safe demo data. The `prod-example` directory shows how a real enterprise environment could be organized without exposing real values.

## Apply Pattern

Playbooks should:

1. Load YAML configuration files.
2. Validate required keys.
3. Create or update AAP objects idempotently.
4. Report changed objects.
5. Run validation after configuration.

## Naming Convention

Use names that communicate ownership and purpose:

```text
<domain> - <platform/object> - <action>
Linux - Patch and Validate
Security - Baseline Audit
Network - Backup Configurations
Platform - Sync Project Content
```
