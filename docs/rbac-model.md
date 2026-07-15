---
title: RBAC Model
---

# RBAC Model

The project uses a simple enterprise RBAC model that can be expanded later.

## Teams

- Platform Admins
- Automation Developers
- Linux Operators
- Security Automation
- Auditors

## Access Model

| Team | Responsibility | Typical Access |
| --- | --- | --- |
| Platform Admins | Own AAP configuration and governance | Admin on demo organization |
| Automation Developers | Build and maintain automation content | Project and template authoring |
| Linux Operators | Run approved operational templates | Execute selected job templates |
| Security Automation | Manage security workflows | Execute and edit security templates |
| Auditors | Review configuration and job history | Read-only access |

## Design Notes

The demo should show least-privilege access. Operators should launch approved templates without managing credentials or platform-wide settings.
