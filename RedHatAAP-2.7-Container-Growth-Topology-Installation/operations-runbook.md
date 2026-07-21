# Operations Runbook

This runbook defines day-2 operating checks for the AAP 2.7 container growth topology project.

## Operating Model

| Area | Project owner | Production owner |
| --- | --- | --- |
| RHEL host | Platform administrator | Linux/platform operations |
| AAP platform | Platform administrator | Automation platform team |
| Database | Platform administrator | Database or platform operations team |
| Certificates | Platform administrator | Security or PKI team |
| Backups | Platform administrator | Platform operations with storage/backup team |
| Red Hat subscriptions | Platform administrator | Subscription or platform operations team |
| Automation content | Automation developer | Automation platform and domain teams |

## Daily Health Checks

Run on the AAP VM:

```console
[rajat@aap ~]$ hostnamectl
```

```console
[rajat@aap ~]$ timedatectl
```

```console
[rajat@aap ~]$ sudo rhc status
```

```console
[rajat@aap ~]$ podman ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

```console
[rajat@aap ~]$ podman volume ls
```

Expected result:

- hostname remains `aap.lab.example.com`
- time is synchronized
- Red Hat content access is healthy
- AAP containers are running
- required named volumes are present

## Browser Validation

Open:

```text
https://aap.lab.example.com
```

Confirm:

- platform gateway loads
- admin login works
- automation controller tile or navigation is reachable
- automation hub tile or navigation is reachable
- Event-Driven Ansible tile or navigation is reachable
- Automation Metrics Service is present if enabled in the platform UI

## Container-Level Validation

Required running containers for this project environment:

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

Inspect logs for a specific container:

```console
[rajat@aap ~]$ podman logs --tail 100 automation-gateway
```

Inspect the most recent container failures:

```console
[rajat@aap ~]$ podman ps --all --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
```

## Capacity Checks

Run:

```console
[rajat@aap ~]$ free -h
```

```console
[rajat@aap ~]$ df -h
```

```console
[rajat@aap ~]$ podman system df
```

Watch for:

- low free memory
- disk pressure under root, `/var`, or AAP volume paths
- large unused container image cache
- fast growth in hub, database, or log data

## Change Management Checklist

Before platform changes:

- Confirm a recent backup exists.
- Confirm the installer inventory is available.
- Confirm the change owner and rollback path.
- Capture current `podman ps` output.
- Capture current `rhc status` output if Red Hat content access is involved.

After platform changes:

- Re-run container validation.
- Re-open the UI.
- Validate affected services.
- Record screenshots or command outputs.
- Update the acceptance evidence if the change is part of the project evidence.

## Certificate Operations

This project uses project certificate posture. Before production:

- replace project certificates with organization-approved certificates
- document certificate source and owner
- document expiration date
- monitor expiration
- test browser and API clients after replacement

## Subscription Operations

After installation, attach or validate the AAP subscription manifest through the platform UI.

Record:

- subscription activation date
- manifest source
- platform account used
- screenshot that confirms activation

Do not commit subscription manifest files.

## Incident Triage

| Symptom | First checks |
| --- | --- |
| Browser cannot reach AAP | DNS, IP reachability, TCP 443, gateway containers, certificate warning. |
| Login fails | Admin password, SSO settings if configured, gateway health, browser session. |
| Controller unavailable | Gateway route, controller web/task containers, PostgreSQL, Redis. |
| Hub unavailable | Hub web/API/content containers, PostgreSQL, hub volume. |
| EDA unavailable | EDA API, daphne, web, worker containers, Redis, PostgreSQL. |
| Registry pull fails | DNS, outbound HTTPS, `podman login registry.redhat.io`, registry credentials. |
| Database issue | PostgreSQL container, PostgreSQL volume, disk space, restore plan. |

## Operational Evidence To Keep

- installer inventory without secrets
- architecture diagram
- `podman ps` output
- `podman volume ls` output
- browser screenshot
- backup command output
- restore test output
- certificate replacement evidence if performed
- subscription activation screenshot
- post-change validation results
