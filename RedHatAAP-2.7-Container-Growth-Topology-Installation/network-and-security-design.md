# Network And Security Design

This file documents the network, trust, and access model for the AAP 2.7 container growth topology project.

## Network Summary

| Item | Value |
| --- | --- |
| Hostname | `aap.lab.example.com` |
| Static IP | `192.168.34.155` |
| Network interface | `enp2s0` |
| Deployment model | Single RHEL VM running Podman containers |
| User entry point | Platform gateway |
| Main browser URL | `https://aap.lab.example.com` |
| Installer execution model | Local install with `ansible_connection=local` |

## Trust Boundaries

| Boundary | Description | Design position |
| --- | --- | --- |
| Workstation to AAP VM | Admin browser, SSH, and validation traffic from the operator workstation. | Allow only trusted admin networks. |
| AAP VM to Red Hat services | Subscription, registry, and content access. | Allow outbound HTTPS to Red Hat endpoints required by the install. |
| Gateway to platform services | Gateway routes UI and API traffic to controller, hub, EDA, and metrics services. | Treat gateway as the intended access point. |
| Containers to local backing services | AAP services use local PostgreSQL, Redis, named volumes, and container networks. | Keep database and Redis access local to the platform. |
| AAP to automation targets | Controller and execution capacity reach managed infrastructure. | Add target-network rules only for approved automation domains. |
| AAP to external integrations | Git, registry, ITSM, secrets, observability, and collaboration systems. | Use outbound access with least required scope and audited credentials. |

## Project Traffic Matrix

| Source | Destination | Port | Protocol | Purpose | Exposure guidance |
| --- | --- | --- | --- | --- | --- |
| Admin workstation | `aap.lab.example.com` | 443 | HTTPS | AAP UI and gateway-routed APIs. | Allow from trusted admin/client networks. |
| Admin workstation | `aap.lab.example.com` | 22 | SSH | VM administration and installer troubleshooting. | Restrict to administrator source IPs. |
| AAP VM | `registry.redhat.io` | 443 | HTTPS | Pull AAP container images. | Outbound only. |
| AAP VM | Red Hat subscription and content services | 443 | HTTPS | RHEL registration, repositories, and entitlement checks. | Outbound only. |
| AAP VM | Git provider | 443 or 22 | HTTPS or SSH | Pull automation content after platform configuration. | Outbound only; prefer scoped tokens or deploy keys. |
| AAP VM | Container registry or Private Automation Hub | 443 | HTTPS | Pull or publish execution environment images. | Outbound only unless hub is serving approved internal clients. |
| AAP VM | Managed Linux targets | 22 | SSH | Job execution against Linux targets. | Open only to approved target networks. |
| AAP VM | Managed Windows targets | 5986 | WinRM over HTTPS | Optional Windows automation. | Open only if Windows automation is in scope. |
| AAP VM | ITSM, chat, observability, or secrets platforms | 443 | HTTPS | Notifications, tickets, event sources, and secret lookups. | Outbound only with least-privilege credentials. |
| Platform services | Local PostgreSQL | 5432 | PostgreSQL | AAP component databases. | Keep internal to the VM or platform network for this topology. |
| Platform services | Local Redis | 6379 | Redis | Cache, queueing, and event processing support. | Keep internal to the VM or platform network. |
| Controller and execution nodes | Receptor peers | 27199 | Receptor | Automation mesh communication if execution nodes are added. | Not required for this single-node installation; open only when mesh is designed. |

## Security Controls For This Project

| Control | Current project position | Production recommendation |
| --- | --- | --- |
| TLS certificates | Installer-generated or project certificate posture. | Replace with organization-approved certificates. |
| Authentication | Local admin login for initial validation. | Integrate with SSO such as LDAP, SAML, or OIDC where supported. |
| Authorization | Baseline platform access after install. | Design organizations, teams, RBAC, and separation of duties. |
| Secrets | Public artifact uses `<redacted>` placeholders. | Store secrets in a private vault, SOPS, Ansible Vault, or approved enterprise secrets service. |
| Database access | Local PostgreSQL for this project. | Restrict database access and evaluate external PostgreSQL for production. |
| Registry access | Red Hat registry credentials used during install. | Prefer registry service accounts with scoped access and rotation. |
| SSH access | Installer user has sudo through `wheel`. | Restrict SSH by source network, use key-based auth, and audit sudo access. |
| Host firewall | Traffic requirements are documented in this file. | Define and enforce allowed inbound and outbound rules before production use. |
| Audit evidence | Browser and container validation captured. | Add API validation, audit logs, job history, and compliance evidence. |

## Firewall Design Notes

- Allow inbound HTTPS to platform gateway from approved users and API clients.
- Allow inbound SSH only from trusted administration workstations.
- Do not expose PostgreSQL or Redis directly to user networks.
- Keep container-to-container traffic local to the AAP host unless the topology expands.
- Open automation target ports only after the target domains are approved.
- For automation mesh, document receptor peers and TCP 27199 paths before opening firewall rules.

## DNS And Certificate Notes

- The AAP FQDN used by users, API clients, and certificates should remain consistent.
- This project environment uses `aap.lab.example.com`.
- Workstation and VM name resolution must both resolve the AAP FQDN to the correct host.
- Production should use a DNS name and TLS certificate trusted by the organization.

## References

- [Red Hat AAP 2.7 network ports and protocols](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/plan-assembly_network_ports_protocols)
- [Red Hat AAP 2.7 topology and networking guidance](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/secure-ref_architecture)
