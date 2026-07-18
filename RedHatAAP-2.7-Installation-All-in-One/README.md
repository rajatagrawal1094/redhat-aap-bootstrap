# Red Hat Ansible Automation Platform 2.7 All-in-One Installation

## Table of Contents

- [Introduction](#introduction)
- [Target Architecture](#target-architecture)
- [System Requirements](#system-requirements)
- [Lab Environment Used](#lab-environment-used)
- [Installation Steps](#installation-steps)
- [Post Installation Validation](#post-installation-validation)
- [Troubleshooting Notes](#troubleshooting-notes)
- [Summary](#summary)
- [References](#references)

## Introduction

This guide explains how to install Red Hat Ansible Automation Platform 2.7 as an all-in-one containerized deployment on a single Red Hat Enterprise Linux virtual machine.

The goal is to build a practical lab that includes the core AAP services on one host:

- platform gateway
- automation controller
- private automation hub
- Event-Driven Ansible controller
- Automation Metrics Service
- local PostgreSQL database
- Redis

This is not a high availability deployment. It is a lab-oriented container growth topology that is useful for learning, demos, configuration-as-code testing, and portfolio projects.

## Target Architecture

![AAP 2.7 containerized architecture](/images/aap-27-containerized-architecture.png)

The deployment uses the AAP 2.7 containerized installer and the `inventory-growth` inventory file. The installer is executed locally on the same VM where AAP is installed, so the inventory uses:

```ini
ansible_connection=local
```

## System Requirements

Before starting, make sure you have:

- Red Hat account with access to Ansible Automation Platform 2.7 downloads.
- Active Red Hat subscription for the RHEL VM.
- Red Hat registry credentials or service account credentials for `registry.redhat.io`.
- Red Hat Enterprise Linux host supported by the AAP 2.7 containerized installer.
- Non-root installation user with sudo access.
- Static IP address.
- Fully qualified domain name.
- Working DNS resolution from the VM and from the workstation.
- Time synchronization enabled.
- Internet access from the VM to Red Hat services.

The official AAP 2.7 containerized installer system requirements include:

| Requirement | Minimum / Supported Value |
| --- | --- |
| Operating system | RHEL 9.6 or later minor versions of RHEL 9, or RHEL 10 or later minor versions of RHEL 10 |
| CPU architecture | `x86_64`, `AArch64`, `s390x`, or `ppc64le` |
| CPU | 4 vCPU minimum |
| Memory | 16 GB minimum |
| Disk | 60 GB total available disk space minimum |
| Disk IOPS | 3000 minimum |
| Installation directory | 15 GB if using a dedicated partition |
| `/var/tmp` for online install | 1 GB |
| `/var/tmp` for offline or bundled install | 3 GB |
| Temporary directory for offline or bundled install | 10 GB |

> [!NOTE]
> For growth topology bundled installations with `hub_seed_collections=true`, Red Hat documents 32 GB memory as required. In this lab, `hub_seed_collections=false` was used.

## Lab Environment Used

The installation in this guide was completed with the following lab configuration:

| Setting | Value |
| --- | --- |
| AAP version | 2.7 |
| Installer package | `ansible-automation-platform-containerized-setup-2.7-2` |
| Topology | Container growth / all-in-one |
| Hostname/FQDN | `aap.lab.example.com` |
| Static IP | `192.168.34.155` |
| Operating system | Red Hat Enterprise Linux 10.2 |
| Architecture | ARM64 / AArch64 |
| Virtualization | VMware |
| Network interface | `enp2s0` |
| FIPS mode | Disabled |
| Installer user | `rajat` |
| Installer user sudo access | Enabled through `wheel` |
| vCPU | 8 |
| RAM | 48 GB |
| Disk | 500 GB |
| Podman version | 5.8.2 |
| Time zone | `America/Toronto` |

### FIPS Decision

This lab was installed in non-FIPS mode.

If you need FIPS mode, enable FIPS during the RHEL installation. Do not install AAP first and attempt to retrofit FIPS later.

## Installation Steps

### Step 1 - Create The RHEL VM

Create a RHEL VM with at least the official minimum resources. For this lab, the VM was created with:

- 8 vCPU
- 48 GB RAM
- 500 GB disk
- RHEL 10.2
- static IPv4 address
- non-FIPS mode

Set the hostname:

```console
[rajat@aap ~]$ sudo hostnamectl set-hostname aap.lab.example.com
```

Reboot if needed:

```console
[rajat@aap ~]$ sudo reboot
```

### Step 2 - Create A Sudo User

This lab used a non-root user named `rajat`.

Verify the user and group membership:

```console
[rajat@aap ~]$ id rajat
[rajat@aap ~]$ groups rajat
```

The user should be part of the `wheel` group:

```text
rajat : rajat wheel
```

If needed, add the user to `wheel`:

```console
[rajat@aap ~]$ sudo usermod -aG wheel rajat
```

Log out and log back in after changing group membership.

### Step 3 - Register The RHEL System

Register the VM to Red Hat Subscription Management. In this lab, `rhc status` was used for validation:

```console
[rajat@aap ~]$ sudo rhc status
```

Expected status:

- connected to Red Hat Subscription Management
- Red Hat repository file generated
- connected to Red Hat Lightspeed or Insights

Update the system:

```console
[rajat@aap ~]$ sudo dnf update -y
```

Verify Podman:

```console
[rajat@aap ~]$ podman --version
```

The lab showed:

```text
podman version 5.8.2
```

### Step 4 - Validate Hostname, IP, And Time

Run:

```console
[rajat@aap ~]$ hostnamectl
[rajat@aap ~]$ ip addr
[rajat@aap ~]$ timedatectl
```

The lab values were:

```text
Static hostname: aap.lab.example.com
Operating System: Red Hat Enterprise Linux 10.2
Architecture: arm64
Interface: enp2s0
IPv4 address: 192.168.34.155/24
System clock synchronized: yes
NTP service: active
```

### Step 5 - Configure Name Resolution

The VM must resolve its own FQDN to the static IPv4 address.

Edit `/etc/hosts`:

```console
[rajat@aap ~]$ sudo vi /etc/hosts
```

Add:

```text
192.168.34.155 aap.lab.example.com aap
```

Validate:

```console
[rajat@aap ~]$ getent hosts aap.lab.example.com
[rajat@aap ~]$ getent ahostsv4 aap.lab.example.com
```

In this lab, `getent hosts` returned an IPv6 link-local address through `myhostname`, but IPv4 lookup worked correctly:

```text
192.168.34.155  STREAM aap.lab.example.com
192.168.34.155  DGRAM
192.168.34.155  RAW
```

Confirm host lookup order:

```console
[rajat@aap ~]$ grep '^hosts:' /etc/nsswitch.conf
```

Expected:

```text
hosts:      files  dns myhostname
```

### Step 6 - Validate Workstation Access

From your workstation, confirm that the VM is reachable:

```console
$ ping 192.168.34.155
$ ping aap.lab.example.com
$ ssh rajat@aap.lab.example.com
```

If your workstation cannot resolve `aap.lab.example.com`, add the same entry to your local DNS or workstation hosts file.

### Step 7 - Validate Registry DNS And Login

The online containerized installer pulls images from `registry.redhat.io`.

Run on the VM:

```console
[rajat@aap ~]$ getent hosts registry.redhat.io
[rajat@aap ~]$ curl -I https://registry.redhat.io/v2/
```

An HTTP `401 Unauthorized` response from `curl` is acceptable before login. It confirms DNS, routing, and TLS connectivity.

Log in to the registry:

```console
[rajat@aap ~]$ podman login registry.redhat.io
```

Expected result:

```text
Login Succeeded!
```

### Step 8 - Fix DNS If Registry Lookup Fails

In this lab, the first registry login failed because the VM was using DNS server `192.168.34.2`, which did not resolve `registry.redhat.io`.

The error looked similar to:

```text
dial tcp: lookup registry.redhat.io on 192.168.34.2:53: no such host
```

The fix was to configure explicit DNS servers on the active NetworkManager connection:

```console
[rajat@aap ~]$ CON=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2=="enp2s0"{print $1; exit}')
[rajat@aap ~]$ sudo nmcli connection modify "$CON" ipv4.ignore-auto-dns yes
[rajat@aap ~]$ sudo nmcli connection modify "$CON" ipv4.dns "1.1.1.1 8.8.8.8"
[rajat@aap ~]$ sudo nmcli connection up "$CON"
```

Re-test:

```console
[rajat@aap ~]$ getent hosts registry.redhat.io
[rajat@aap ~]$ curl -I https://registry.redhat.io/v2/
[rajat@aap ~]$ podman login registry.redhat.io
```

### Step 9 - Download And Extract The AAP Installer

Download the AAP 2.7 containerized setup package from the Red Hat Customer Portal.

In this lab, the package was placed under `/home/rajat`:

```text
/home/rajat/ansible-automation-platform-containerized-setup-2.7-2.tar
/home/rajat/ansible-automation-platform-containerized-setup-2.7-2/
```

If you have the tar file, extract it:

```console
[rajat@aap ~]$ cd /home/rajat
[rajat@aap ~]$ tar -xf ansible-automation-platform-containerized-setup-2.7-2.tar
[rajat@aap ~]$ cd ansible-automation-platform-containerized-setup-2.7-2
```

Inspect the installer directory:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ls -la
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ls -la inventory*
```

### Step 10 - Back Up The Original Inventory

The installer includes inventory examples. This lab used `inventory-growth`.

Back up the original file:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ cp -p inventory-growth inventory-growth.original
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ chmod 400 inventory-growth.original
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ chmod 600 inventory-growth
```

This gives you a clean reference copy if the install fails.

### Step 11 - Configure `inventory-growth`

Edit `inventory-growth` directly:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ vi inventory-growth
```

The sanitized inventory used for this lab is included in this repository:

[inventory-growth](inventory-growth)

Key choices in this inventory:

- all components use `aap.lab.example.com`
- `ansible_connection=local`
- `[automationmetrics]` is enabled
- Ansible Lightspeed is deferred
- Ansible MCP Server is deferred
- `hub_seed_collections=false`
- `FEATURE_DASHBOARD_COLLECTION_ENABLED=false`
- all password values are hidden with `<hiddeen>`

### Step 12 - Validate The Inventory

Run:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-inventory -i inventory-growth --list
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-inventory -i inventory-growth --graph
```

Confirm the graph includes:

```text
@automationgateway:
  |--aap.lab.example.com
@automationcontroller:
  |--aap.lab.example.com
@automationhub:
  |--aap.lab.example.com
@automationeda:
  |--aap.lab.example.com
@automationmetrics:
  |--aap.lab.example.com
@database:
  |--aap.lab.example.com
```

Check for unresolved placeholders, example domains, and hostname typos:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ awk '!/^[[:space:]]*#/ && /CHANGE_ME|<[^>]+>|example[.]org|examaple|examle/ { print FNR ":" $0 }' inventory-growth
```

This command should return no output in your real VM inventory. If it returns active lines, fix them before running the installer.

### Step 13 - Run The Installer

From the extracted installer directory:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-playbook -i inventory-growth -K ansible.containerized_installer.install
```

Use `-K` because the `rajat` user uses sudo privilege escalation.

If you need more detail during troubleshooting:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ ansible-playbook -i inventory-growth -K -v ansible.containerized_installer.install
```

Wait for the playbook to complete successfully.

## Post Installation Validation

### Validate AAP From The Browser

Open:

```text
https://aap.lab.example.com
```

Log in with:

- username: `admin`
- password: value configured in `gateway_admin_password`

After login, the AAP overview dashboard should load.

![AAP overview dashboard](/images/aap-overview-dashboard.jpg)

### Validate Containers

Run:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman ps
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman pod ps
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman volume ls
```

Optional formatted view:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ podman ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

The successful lab showed containers for:

- `postgresql`
- `redis-unix`
- `redis-tcp`
- `automation-gateway-proxy`
- `automation-gateway`
- `receptor`
- `automation-controller-rsyslog`
- `automation-controller-task`
- `automation-controller-web`
- `automation-eda-api`
- `automation-eda-daphne`
- `automation-eda-web`
- `automation-eda-worker-1`
- `automation-eda-worker-2`
- `automation-eda-activation-worker-1`
- `automation-eda-activation-worker-2`
- `automation-hub-api`
- `automation-hub-content`
- `automation-hub-web`
- `automation-hub-worker-1`
- `automation-hub-worker-2`
- `automation-metrics-web`
- `automation-metrics-tasks`
- `automation-metrics-scheduler`

The successful lab also created local Podman volumes for PostgreSQL, Redis, gateway, receptor, controller, EDA, and hub data.

## Troubleshooting Notes

### Automation Metrics Preflight Failure

If the installer fails with:

```text
You must have a host set in the [automationmetrics] section
```

Enable this group:

```ini
[automationmetrics]
aap.lab.example.com
```

Also define the metrics database variables:

```ini
automationmetrics_pg_host=aap.lab.example.com
automationmetrics_pg_password=<hiddeen>
automationmetrics_controller_read_pg_host=aap.lab.example.com
automationmetrics_controller_read_pg_password=<hiddeen>
FEATURE_DASHBOARD_COLLECTION_ENABLED=false
```

### Registry DNS Failure

If `podman login registry.redhat.io` fails with a DNS lookup error, fix DNS first. This is not usually a registry password problem.

Validate:

```console
[rajat@aap ~]$ getent hosts registry.redhat.io
[rajat@aap ~]$ curl -I https://registry.redhat.io/v2/
```

Then adjust NetworkManager DNS if required:

```console
[rajat@aap ~]$ CON=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2=="enp2s0"{print $1; exit}')
[rajat@aap ~]$ sudo nmcli connection modify "$CON" ipv4.ignore-auto-dns yes
[rajat@aap ~]$ sudo nmcli connection modify "$CON" ipv4.dns "1.1.1.1 8.8.8.8"
[rajat@aap ~]$ sudo nmcli connection up "$CON"
```

### Hostname Typo

A small hostname typo can break database connectivity or component registration.

Check for common mistakes:

```console
[rajat@aap ansible-automation-platform-containerized-setup-2.7-2]$ awk '!/^[[:space:]]*#/ && /examaple|examle/ { print FNR ":" $0 }' inventory-growth
```

The correct lab FQDN is:

```text
aap.lab.example.com
```

### Certificate Warning In Browser

For a lab with installer-generated certificates, the browser might show a certificate warning.

For production, use certificates trusted by your organization. For a lab, you can either proceed through the browser warning or import the generated certificate into your workstation trust store after verifying its fingerprint.

## Summary

By following this guide, you installed Red Hat Ansible Automation Platform 2.7 as an all-in-one containerized lab on Red Hat Enterprise Linux 10.2.

You completed:

- VM preparation
- hostname and DNS validation
- Red Hat subscription validation using `rhc status`
- Podman and registry access validation
- AAP 2.7 installer extraction
- `inventory-growth` backup and configuration
- all-in-one AAP 2.7 installation
- browser and container-level validation

The platform is now ready for the next phase: configuring AAP as code with organizations, teams, RBAC, inventories, projects, job templates, execution environments, workflows, notifications, and enterprise integrations.

## References

- [Red Hat Ansible Automation Platform 2.7 documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/)
- [Red Hat AAP 2.7 system requirements](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/install-ref_cont_aap_system_requirements)
- [Install containerized Ansible Automation Platform](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/install-proc_installing_containerized_aap)
- [Install metrics service with containerized installer](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/install-task_install_metrics_service_with_containerized_installer)
