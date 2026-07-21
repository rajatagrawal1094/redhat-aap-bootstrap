# Acceptance Test Evidence

This file summarizes the acceptance criteria and evidence for the AAP 2.7 container growth topology installation.

## Acceptance Summary

| Area | Status | Evidence |
| --- | --- | --- |
| RHEL VM built | Passed | RHEL 10.2 VM with 8 vCPU, 48 GB RAM, and 500 GB disk. |
| Static hostname configured | Passed | `hostnamectl` shows `aap.lab.example.com`. |
| Static IP configured | Passed | `ip addr` shows `192.168.34.155/24` on `enp2s0`. |
| Time sync enabled | Passed | `timedatectl` shows synchronized clock and active NTP. |
| Red Hat content access | Passed | `rhc status` confirms connection to subscription management and content. |
| Registry access | Passed | `curl` to `registry.redhat.io/v2/` returns HTTP `401` before authentication and `podman login` succeeds after credentials. |
| Installer inventory configured | Passed | `inventory-growth` contains gateway, controller, hub, EDA, metrics, and database groups. |
| Inventory parse validation | Passed | `ansible-inventory --list` and `ansible-inventory --graph` parse the inventory. |
| Placeholder and typo scan | Passed | Active inventory values do not contain unresolved placeholders or hostname typos in the real VM-side inventory. |
| Installer completed | Passed | Installer completed successfully; public evidence records success criteria rather than private task output. |
| Gateway UI access | Passed | AAP overview dashboard screenshot is included. |
| Container health | Passed | Required AAP containers are running. |
| Persistence | Passed | Required Podman named volumes exist. |

## Installer Completion Evidence

The public artifact does not include the full private installer log because logs can contain environment-specific details.

The required installer acceptance condition for this lab is:

```text
unreachable=0
failed=0
```

Recommended sanitized evidence format for future updates:

```text
PLAY RECAP *********************************************************************
localhost                  : ok=<redacted> changed=<redacted> unreachable=0 failed=0 skipped=<redacted> rescued=0 ignored=0
```

## Platform Browser Evidence

The platform gateway was validated through the browser.

Evidence:

![AAP overview dashboard](images/aap-overview-dashboard.jpg)

Acceptance criteria:

- `https://aap.lab.example.com` loads.
- Login succeeds with the configured admin password.
- The AAP overview dashboard renders.
- Navigation exposes automation execution, automation decisions, automation analytics, automation content, access management, and settings.

## Container Runtime Evidence

Command:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Accepted running services:

```text
postgresql
redis-unix
redis-tcp
automation-gateway-proxy
automation-gateway
receptor
automation-controller-rsyslog
automation-controller-task
automation-controller-web
automation-eda-api
automation-eda-daphne
automation-eda-web
automation-eda-worker-1
automation-eda-worker-2
automation-eda-activation-worker-1
automation-eda-activation-worker-2
automation-hub-api
automation-hub-content
automation-hub-web
automation-hub-worker-1
automation-hub-worker-2
automation-metrics-web
automation-metrics-tasks
automation-metrics-scheduler
```

## Persistence Evidence

Command:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman volume ls
```

Accepted volumes:

```text
postgresql
redis_data_unix
redis_run
redis_data_tcp
gateway_nginx
receptor_run
receptor_runner
receptor_home
receptor_data
controller_nginx
eda_data
eda_nginx
hub_data
hub_nginx
```

## Topology Evidence

Command:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman pod ps
```

Accepted result:

```text
POD ID      NAME        STATUS      CREATED     INFRA ID    # OF CONTAINERS
```

Interpretation:

- The installer created standalone containers.
- No Podman pods were observed in this lab.

## Inventory Evidence

The committed `inventory-growth` file is sanitized and safe for public review.

Acceptance criteria:

- all required inventory groups are present
- all groups point to `aap.lab.example.com`
- `ansible_connection=local`
- all public secret values are replaced with `<redacted>`
- `hub_seed_collections=false`
- `redis_mode=standalone`
- `FEATURE_DASHBOARD_COLLECTION_ENABLED=false`

## Remaining Evidence To Capture In Later Phases

| Future evidence | Reason |
| --- | --- |
| Subscription activation screenshot | Proves entitlement activation after install. |
| Gateway API token validation | Proves API access through platform gateway. |
| Controller organization/team/RBAC screenshots | Proves governed platform configuration. |
| Project sync screenshot | Proves source control integration. |
| Job template launch screenshot | Proves execution readiness. |
| Workflow execution screenshot | Proves operational automation value. |
| Backup output | Proves recoverability. |
| Restore test output | Proves disaster recovery readiness. |

