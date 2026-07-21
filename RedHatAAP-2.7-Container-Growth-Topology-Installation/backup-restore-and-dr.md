# Backup, Restore, And Disaster Recovery

This runbook defines the backup and disaster recovery posture for the AAP 2.7 container growth topology lab.

## Design Position

This Phase 1 lab uses a single RHEL VM with local PostgreSQL and local Podman volumes. The design is appropriate for learning, PoC, demo, and consulting validation, but it has one failure domain.

For production, the backup and restore design must be tested before the platform is used for critical automation.

## Recovery Objectives

| Objective | Phase 1 lab target | Production recommendation |
| --- | --- | --- |
| RPO | Best effort; backup before major platform changes. | Define based on automation criticality and job history retention requirements. |
| RTO | Manual restore. | Define a tested restore procedure and recovery time target. |
| Backup owner | Platform administrator. | Platform operations team with documented handoff to database/storage teams if externalized. |
| Restore owner | Platform administrator. | Platform operations team with change, security, and application owner coordination. |
| Restore validation | UI, container, volume, and API validation. | Add job launch, RBAC, credentials, projects, hub content, and audit validation. |

## What Must Be Protected

| Data or artifact | Why it matters |
| --- | --- |
| PostgreSQL databases | Platform configuration, controller state, hub data, EDA data, gateway data, and job history. |
| Podman named volumes | Component state, web configuration, hub data, receptor data, Redis data, and platform content. |
| Installer inventory | Required to repeat backup, restore, upgrade, and topology operations. |
| Secrets and keys | Required for encrypted platform data and secure communication. |
| Subscription manifest | Required to activate AAP entitlement. |
| Custom certificates | Required for trusted access in production. |
| Architecture and runbooks | Required for repeatable recovery and handoff. |

## Backup Procedure

Run from the AAP installer directory on the RHEL VM as the non-root installer user:

```console
[rajat@aap ~]$ cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
```

Run the supported containerized installer backup playbook:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-playbook -i inventory-growth -K ansible.containerized_installer.backup
```

By default, backup artifacts are written under the installer backup directory. Red Hat documents `backup_dir` as the variable for changing the backup destination.

Recommended lab backup destination:

```ini
backup_dir=/home/rajat/aap-backups
```

Recommended validation after backup:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ find /home/rajat/aap-backups -maxdepth 2 -type f -ls
```

Record:

- backup date and time
- installer version
- AAP version
- inventory file used
- backup directory
- whether compression was enabled
- whether backup artifacts were copied off the VM

## Restore Procedure

Before restore:

- Confirm the backup was created with a compatible AAP installer version.
- Confirm the target environment uses the same topology unless a migration plan exists.
- Confirm the target host can resolve the same platform FQDN.
- Confirm the inventory used for restore matches the intended topology.
- Preserve the failed environment if a root-cause investigation is required.

Run from the installer directory:

```console
[rajat@aap ~]$ cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
```

Run the supported restore playbook:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-playbook -i inventory-growth -K ansible.containerized_installer.restore
```

## Post-Restore Validation

| Validation | Command or check | Expected result |
| --- | --- | --- |
| Gateway UI | Open `https://aap.lab.example.com` | UI loads successfully. |
| Containers | `podman ps --format 'table {{.Names}}\t{{.Status}}'` | Required AAP containers are running. |
| Volumes | `podman volume ls` | Required platform volumes exist. |
| Podman pods | `podman pod ps` | No pods are expected for this lab. |
| Controller objects | UI or API check | Organizations, inventories, projects, and templates are visible if configured before backup. |
| Hub content | UI or API check | Hub content is visible if synced before backup. |
| EDA | UI or API check | EDA service is reachable if configured before backup. |
| Metrics | UI, API, or service check | Metrics service containers are running. |

## DR Scenarios

| Scenario | Expected response |
| --- | --- |
| VM filesystem issue | Restore from latest backup onto the same VM if possible. |
| VM loss | Build a replacement RHEL VM with the same hostname and topology, then restore from backup. |
| Bad configuration change | Restore to the last known-good backup or reverse the change using the supported configuration path. |
| Failed upgrade | Restore from the pre-upgrade backup and review installer logs before retrying. |
| Certificate/key loss | Restore required key material from secure backup or replace certificates through a controlled change. |

## Operational Recommendations

- Back up before AAP upgrades, topology changes, certificate changes, and large configuration changes.
- Copy backup artifacts off the AAP VM.
- Protect backup artifacts as sensitive data.
- Test restore on a non-production clone before relying on the procedure.
- Keep installer packages aligned with the installed AAP version.
- Document each backup and restore with date, operator, command, outcome, and validation evidence.

## References

- [Red Hat AAP 2.7 back up and restore your containerized deployment](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/administer-back_up_and_restore_your_containerized_deployment)

