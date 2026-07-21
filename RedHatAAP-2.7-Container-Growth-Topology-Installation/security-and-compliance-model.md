# Security And Compliance Model

## Purpose

This document defines the security and compliance posture for the AAP 2.7 container growth topology project.

It separates the controls implemented or documented in the project environment from the controls required before production adoption.

## Security Position

| Area | Project Position | Production Expectation |
| --- | --- | --- |
| Identity | Local admin validation. | Enterprise SSO through supported identity integration. |
| Authorization | Baseline access after installation. | Defined organizations, teams, RBAC, and separation of duties. |
| Secrets | Public files use `<redacted>` placeholders. | Approved secrets management or vault-backed credential model. |
| Certificates | Installer-generated or non-production certificate posture. | Organization-approved TLS certificates and lifecycle management. |
| Database | Local PostgreSQL on the AAP VM. | Restricted database access and external PostgreSQL if required. |
| Redis | Local standalone Redis. | Resilience and segmentation reviewed for production topology. |
| Network | Required traffic paths documented. | Enforced firewall rules and approved ingress/egress paths. |
| Audit | Installation evidence captured. | Audit log retention, job history retention, and compliance evidence. |
| FIPS | Non-FIPS. | FIPS enabled during OS installation if required by policy. |

## Identity And Access Model

| Control | Project Requirement | Production Requirement |
| --- | --- | --- |
| Admin access | Limit admin access to trusted operators. | Use named admin accounts through SSO. |
| User access | Validate local login for installation. | Map users and groups from enterprise identity provider. |
| RBAC | Document reference model. | Implement organization, team, and role assignments. |
| Least privilege | Planned in post-install model. | Enforce role-specific access for admins, developers, operators, security, and auditors. |
| API access | Use gateway-routed API paths. | Use scoped API tokens or service accounts with rotation. |

## Credential And Secret Handling

| Secret Type | Project Handling | Production Handling |
| --- | --- | --- |
| Registry password | Redacted in public inventory. | Use registry service account or approved secret store. |
| AAP admin passwords | Redacted in public inventory. | Store in approved password vault or secret management system. |
| Database passwords | Redacted in public inventory. | Rotate and protect through approved operational process. |
| SSH keys | Not committed. | Use managed keys, limited scope, and rotation. |
| Subscription manifest | Not committed. | Store and upload through controlled entitlement process. |
| API tokens | Not committed. | Use scoped tokens, expiration, and rotation. |

## Network Security Model

| Flow | Security Position |
| --- | --- |
| Workstation to AAP gateway | Allow HTTPS from trusted admin/client networks. |
| Workstation to VM SSH | Restrict SSH to trusted administrator source IPs. |
| AAP VM to Red Hat services | Allow outbound HTTPS for subscription, content, and registry access. |
| AAP VM to Git or registry services | Use scoped credentials and outbound-only access where possible. |
| AAP VM to managed targets | Open only approved target-network ports. |
| Platform services to PostgreSQL and Redis | Keep local or internal to the platform network. |

## Compliance Position

| Compliance Area | Current Position | Required Production Action |
| --- | --- | --- |
| FIPS | Disabled. | Rebuild with FIPS enabled during RHEL installation if required. |
| High availability | Not implemented. | Implement enterprise topology if availability requirements demand it. |
| Disaster recovery | Documented only. | Test restore and define RTO/RPO. |
| Auditability | Evidence package created. | Integrate audit logs and job history with enterprise retention requirements. |
| Change control | Checklist documented. | Align with enterprise CAB or change process. |
| Data protection | Secrets redacted in public artifacts. | Protect backups, manifests, credentials, keys, and logs. |

## Security Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Plaintext secrets in installer inventory | Credential exposure. | Use private inventory, vault, and public redaction. |
| Installer-generated certificates | Browser trust warnings and weaker enterprise trust posture. | Replace with trusted certificates. |
| Local admin access | Weak accountability if shared. | Use named users and SSO for production. |
| Broad RBAC permissions | Excessive privilege. | Define least-privilege roles before onboarding users. |
| Unrestricted outbound access | Increased attack surface. | Restrict egress to required endpoints. |
| Untested restore | Recovery uncertainty. | Perform restore test before production use. |

## Security Evidence To Capture

- SSO configuration evidence.
- RBAC screenshots for organizations, teams, and roles.
- Credential records showing secret values hidden.
- Certificate issuer and expiration evidence.
- Firewall rules or network security group evidence.
- Backup artifact protection evidence.
- Audit log and job history retention settings.
- API token creation and revocation evidence without exposing token values.

