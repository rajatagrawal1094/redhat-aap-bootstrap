# Post-Install Platform Configuration

This file defines the next architecture milestone after the AAP 2.7 container growth topology installation.

## Objective

Move from an installed platform to a governed automation service.

The installation proves that AAP is running. The post-install configuration proves that the platform can support teams, content, controlled execution, and enterprise integration patterns.

## Target Configuration Domains

| Domain | Configuration outcome |
| --- | --- |
| Subscription | AAP entitlement is activated with a manifest. |
| Organizations | Platform ownership and automation domains are represented. |
| Teams | Platform admins, automation developers, operators, security automation, and auditors are separated. |
| RBAC | Users can only administer, build, execute, or review according to role. |
| Credentials | Machine, source control, registry, hub, vault, and notification credentials are modeled without exposing secrets. |
| Inventories | Static or dynamic inventory sources are defined for lab targets. |
| Projects | Git-backed automation content is synchronized into controller. |
| Execution environments | Approved runtimes are registered and attached to templates. |
| Job templates | Standard operational jobs are available for controlled launch. |
| Workflows | Multi-step operational processes include prechecks, execution, validation, and notification. |
| Private Automation Hub | Collection and execution environment content is governed. |
| Event-Driven Ansible | Event sources and rulebooks can trigger controller actions. |
| Notifications | Teams receive job and workflow status through email, chat, ITSM, or webhooks. |

## Reference RBAC Model

| Team | Responsibility | Typical access |
| --- | --- | --- |
| Platform Admins | Own platform configuration and lifecycle. | Organization admin and platform administration. |
| Automation Developers | Build and maintain automation content. | Project, template, and workflow authoring within assigned organizations. |
| Linux Operators | Run approved Linux operations. | Execute approved job templates and workflows. |
| Security Automation | Build and run security workflows. | Execute and maintain approved security automation. |
| Auditors | Review automation state and job history. | Read-only access. |

## Example Configuration-As-Code Model

Use a private repository or branch for real environment data. Public examples must remain sanitized.

```text
config/
  dev/
    organizations.yml
    teams.yml
    users.yml
    rbac.yml
    inventories.yml
    credentials.yml
    projects.yml
    job_templates.yml
    workflows.yml
    notification_templates.yml
    execution_environments.yml
```

## Example Workflow Pattern

```text
Linux Patch And Validate Workflow
  |
  |-- Precheck
  |-- Approval if reboot is required
  |-- Apply updates
  |-- Reboot if approved
  |-- Validate services
  |-- Generate report
  |-- Send notification
```

## Solution Architect Value

This post-install phase demonstrates that AAP is not just installed. It is operated as a platform service with:

- source-controlled configuration
- repeatable platform setup
- least-privilege access
- governed credentials
- approved execution environments
- auditable workflows
- reusable automation content
- clear operating ownership

## Evidence To Capture

| Evidence | Purpose |
| --- | --- |
| Subscription screen | Shows entitlement activation. |
| Organization and team screenshots | Shows access model implementation. |
| RBAC screenshots | Shows least-privilege design. |
| Credential screenshots without secret values | Shows credential model without leaking secrets. |
| Project sync result | Shows source control integration. |
| Execution environment registration | Shows controlled runtime design. |
| Job template launch | Shows operational execution. |
| Workflow visualizer screenshot | Shows end-to-end automation design. |
| Job output | Shows technical validation. |
| Notification/ticket output | Shows enterprise integration. |

## Recommended Implementation Order

1. Activate subscription manifest.
2. Create organizations and teams.
3. Define RBAC.
4. Add sanitized demo users.
5. Add credentials from private secret storage.
6. Add inventories.
7. Add Git-backed projects.
8. Register execution environments.
9. Create job templates.
10. Create workflow templates.
11. Configure notifications.
12. Validate with a real job run.
13. Capture screenshots and sanitized outputs.

