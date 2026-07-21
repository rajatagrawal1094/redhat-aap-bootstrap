# Automation Implementation Roadmap

## Purpose

This document defines the recommended automation code structure for turning the current documentation project into a stronger Ansible SME portfolio project.

The current repository proves that AAP 2.7 can be installed and explained. The next step is to automate repeatable preflight, validation, inventory generation, backup validation, and post-install configuration tasks.

## Recommended Repository Structure

```text
.
|-- README.md
|-- inventory-growth
|-- playbooks/
|   |-- preflight.yml
|   |-- render_inventory.yml
|   |-- validate_inventory.yml
|   |-- post_install_validate.yml
|   |-- backup_validate.yml
|   `-- collect_evidence.yml
|-- roles/
|   |-- aap_host_preflight/
|   |-- aap_inventory_validate/
|   |-- aap_runtime_validate/
|   |-- aap_evidence_collect/
|   `-- aap_backup_validate/
|-- templates/
|   `-- inventory-growth.j2
|-- group_vars/
|   `-- example.yml
|-- vars/
|   `-- lab.yml
|-- collections/
|   `-- requirements.yml
|-- execution-environment.yml
|-- ansible-lint.yml
`-- molecule/
```

## Playbook Roadmap

| Playbook | Purpose | Portfolio Value |
| --- | --- | --- |
| `playbooks/preflight.yml` | Validate OS, CPU, memory, disk, DNS, time sync, subscription, Podman, and registry access. | Shows infrastructure readiness automation. |
| `playbooks/render_inventory.yml` | Render `inventory-growth` from a Jinja2 template and variable file. | Shows controlled inventory generation and repeatability. |
| `playbooks/validate_inventory.yml` | Run syntax, placeholder, hostname, and group validation. | Shows guardrails before installation. |
| `playbooks/post_install_validate.yml` | Validate gateway URL, containers, volumes, and expected service state. | Shows evidence-based platform validation. |
| `playbooks/backup_validate.yml` | Run or validate supported backup workflow and inspect backup artifacts. | Shows operational readiness thinking. |
| `playbooks/collect_evidence.yml` | Capture sanitized command output for GitHub evidence. | Shows consulting-style handoff and auditability. |

## Role Roadmap

| Role | Responsibility |
| --- | --- |
| `aap_host_preflight` | Validate host prerequisites and fail early with clear messages. |
| `aap_inventory_validate` | Validate inventory groups, hostnames, placeholders, and required variables. |
| `aap_runtime_validate` | Validate containers, volumes, gateway access, and service health. |
| `aap_evidence_collect` | Collect sanitized outputs into an evidence directory. |
| `aap_backup_validate` | Validate backup prerequisites and backup artifact presence. |

## Collection Opportunity

For a stronger Ansible SME demonstration, move reusable logic into a custom collection later:

```text
ansible_collections/
  rajat/
    aap_bootstrap/
      plugins/
        filter/
        lookup/
        modules/
      roles/
      playbooks/
      docs/
      galaxy.yml
```

Potential custom content:

| Plugin Or Module | Purpose |
| --- | --- |
| `aap_inventory_lint` module | Validate AAP installer inventory structure. |
| `aap_container_status` module | Return structured status for expected AAP containers. |
| `redact_aap_output` filter | Redact secrets from captured command output. |
| `aap_evidence_summary` filter | Convert raw validation results into markdown evidence tables. |

## CI And Quality Gates

| Gate | Tool |
| --- | --- |
| YAML syntax | `yamllint` |
| Ansible best practices | `ansible-lint` |
| Inventory validation | `ansible-inventory` |
| Markdown links | local link checker |
| Secret scanning | `gitleaks`, `trufflehog`, or equivalent |
| Role tests | Molecule where practical |
| Documentation checks | README link and anchor validation |

## Implementation Order

1. Create `playbooks/preflight.yml`.
2. Create `templates/inventory-growth.j2`.
3. Create `playbooks/render_inventory.yml`.
4. Create `playbooks/validate_inventory.yml`.
5. Create `playbooks/post_install_validate.yml`.
6. Create `playbooks/collect_evidence.yml`.
7. Add `ansible-lint` and YAML linting.
8. Add Molecule tests for roles where practical.
9. Package reusable logic into a custom collection.
10. Use the project to demonstrate AAP bootstrap, validation, and day-2 readiness.

## Public Safety Rules

- Do not commit real passwords.
- Do not commit registry tokens.
- Do not commit subscription manifests.
- Do not commit private keys.
- Do not commit raw installer logs without review.
- Redact host-specific sensitive values before publishing evidence.

