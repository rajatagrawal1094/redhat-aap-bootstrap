---
title: AAP 2.7 Step-by-Step Installation Guide
---

# AAP 2.7 Step-by-Step Installation Guide

This guide explains how to build the single-node Red Hat Ansible Automation Platform 2.7 lab used by this project.

It is written for readers who want to understand the full setup path: VM planning, operating system preparation, network validation, installer inventory configuration, registry access, installation, and post-install verification.

## 1. Lab Goal

The goal is to create a working AAP 2.7 lab that can later be configured from this repository using configuration-as-code.

The lab is not designed for high availability. It is designed to demonstrate platform engineering, Ansible Automation Platform administration, execution environments, RBAC, Private Automation Hub, Event-Driven Ansible, and enterprise automation workflows.

## 2. Target Topology

This guide uses the AAP 2.7 containerized installer with the growth topology inventory.

Installed on one VM:

- platform gateway
- automation controller
- private automation hub
- Event-Driven Ansible controller
- Automation Metrics Service
- local database

Deferred until after the base platform install:

- Ansible Lightspeed
- Ansible MCP Server

## 3. Lab Values Used In This Project

The working lab used these values:

| Setting | Value |
| --- | --- |
| Hostname/FQDN | `aap.lab.example.com` |
| Static IP | `192.168.34.155` |
| Operating system | Red Hat Enterprise Linux 10.2 |
| Architecture | ARM64 / AArch64 |
| Virtualization | VMware |
| Network interface | `enp2s0` |
| FIPS mode | Disabled |
| Installer user | `rajat` |
| Installer user sudo access | Enabled through `wheel` |
| RAM | 48 GB |
| CPU | 8 vCPU |
| Disk | 500 GB |
| AAP installer | `ansible-automation-platform-containerized-setup-2.7-2` |

You can change the hostname, IP address, user, and resource values for your own lab. Keep the naming consistent across DNS, `/etc/hosts`, the AAP installer inventory, and browser access.

## 4. Prerequisites

Before starting, make sure you have:

- Red Hat account with access to AAP 2.7 downloads.
- Red Hat subscription available for the RHEL VM.
- Red Hat registry credentials or service account credentials for `registry.redhat.io`.
- RHEL 10.2 VM with static IP.
- DNS or local host file entry for the AAP FQDN.
- Internet access from the VM to Red Hat services and `registry.redhat.io`.
- SSH access from your workstation to the VM.
- Sudo access for the installer user.

Keep these values private:

- Red Hat registry username and password.
- Red Hat subscription information.
- AAP admin passwords.
- database passwords.
- TLS private keys.
- installer inventory containing real secrets.

Do not commit the real installer inventory to a public repository.

## 5. Create The VM

Create a RHEL 10.2 VM with these recommended resources:

- 8 vCPU
- 32 GB RAM minimum, 48 GB preferred for this lab
- 150 GB disk minimum, 500 GB used in this lab
- static IPv4 address
- resolvable FQDN
- time synchronization enabled
- non-FIPS mode for the first lab build

For this project, the VM was built with:

```text
Hostname: aap.lab.example.com
IP:       192.168.34.155
User:     rajat
```

FIPS note: if you need a FIPS-enabled environment, enable FIPS during the RHEL installation. Do not install AAP first and attempt to retrofit FIPS later.

## 6. Create The Installer User

Create or confirm a non-root installer user with sudo access.

Example:

```bash
id rajat
groups rajat
```

The user should be a member of `wheel`:

```text
rajat : rajat wheel
```

If needed, add the user to `wheel`:

```bash
sudo usermod -aG wheel rajat
```

Log out and log back in after changing group membership.

## 7. Register The RHEL VM

Register the VM to Red Hat and verify content access.

The lab used `rhc status` instead of `subscription-manager status`:

```bash
sudo rhc status
```

Expected result:

- connected to Red Hat Subscription Management
- Red Hat repository file generated
- connected to Red Hat Lightspeed or Insights

The Remote Management service can be inactive without blocking this AAP install.

Update the system:

```bash
sudo dnf update -y
```

Confirm Podman:

```bash
podman --version
```

The lab used Podman 5.8.2.

## 8. Validate Host And Time Configuration

Run:

```bash
hostnamectl
ip addr
timedatectl
```

Confirm:

- static hostname is `aap.lab.example.com`
- interface `enp2s0` has `192.168.34.155/24`
- system clock is synchronized
- NTP service is active

## 9. Configure Local Name Resolution

The VM should resolve its own FQDN to the static IPv4 address.

Confirm `/etc/hosts` has this entry:

```text
192.168.34.155 aap.lab.example.com aap
```

If it is missing, add it:

```bash
sudo cp /etc/hosts /etc/hosts.bak
sudo tee -a /etc/hosts <<'EOF'
192.168.34.155 aap.lab.example.com aap
EOF
```

Check host resolution:

```bash
getent hosts aap.lab.example.com
getent ahostsv4 aap.lab.example.com
```

In this lab, `getent hosts aap.lab.example.com` returned an IPv6 link-local address through `myhostname`, while IPv4 lookup worked correctly:

```bash
getent ahostsv4 aap.lab.example.com
```

Expected IPv4 result:

```text
192.168.34.155  STREAM aap.lab.example.com
192.168.34.155  DGRAM
192.168.34.155  RAW
```

If IPv4 lookup does not work, confirm the host lookup order:

```bash
grep '^hosts:' /etc/nsswitch.conf
```

Recommended order:

```text
hosts:      files  dns myhostname
```

## 10. Validate Workstation Access

From your workstation, confirm the VM is reachable:

```bash
ping 192.168.34.155
ping aap.lab.example.com
ssh rajat@aap.lab.example.com
```

If FQDN access does not work from the workstation, add an equivalent local DNS or hosts entry on the workstation.

## 11. Verify External DNS And Registry Access

The online containerized installer must pull images from `registry.redhat.io`.

Run on the VM:

```bash
getent hosts registry.redhat.io
curl -I https://registry.redhat.io/v2/
```

An HTTP `401 Unauthorized` response from `curl` is acceptable before login. It confirms that DNS, routing, and TLS connectivity work.

Then authenticate:

```bash
podman login registry.redhat.io
```

Expected result:

```text
Login Succeeded!
```

### DNS Fix Used In This Lab

The initial registry login failed because the VM used DNS server `192.168.34.2`, which did not resolve `registry.redhat.io`.

The fix was to set explicit DNS resolvers on the active `enp2s0` NetworkManager connection:

```bash
CON=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2=="enp2s0"{print $1; exit}')

sudo nmcli connection modify "$CON" ipv4.ignore-auto-dns yes
sudo nmcli connection modify "$CON" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli connection up "$CON"
```

Verify again:

```bash
getent hosts registry.redhat.io
curl -I https://registry.redhat.io/v2/
podman login registry.redhat.io
```

## 12. Download And Extract The AAP Installer

Download the AAP 2.7 containerized setup package from the Red Hat Customer Portal.

For this lab, the extracted installer directory was:

```text
/home/rajat/ansible-automation-platform-containerized-setup-2.7-2
```

Example layout:

```text
/home/rajat
|-- ansible-automation-platform-containerized-setup-2.7-2
|-- ansible-automation-platform-containerized-setup-2.7-2.tar
```

If you downloaded the tar file to `/home/rajat`, extract it:

```bash
cd /home/rajat
tar -xf ansible-automation-platform-containerized-setup-2.7-2.tar
cd ansible-automation-platform-containerized-setup-2.7-2
```

Inspect the installer directory:

```bash
ls -la
ls -la inventory*
sed -n '1,220p' README.md
```

## 13. Back Up The Original Inventory

The installer provides inventory examples. This lab used `inventory-growth`.

Create a protected reference copy and modify `inventory-growth` directly:

```bash
cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
cp -p inventory-growth inventory-growth.original
chmod 400 inventory-growth.original
chmod 600 inventory-growth
```

This gives you a clean original file for comparison if the install fails.

## 14. Configure The Installer Inventory

Edit `inventory-growth`.

Use this sanitized inventory as the successful base-install shape.

Replace every `CHANGE_ME` value with a private value on your VM. Do not commit the real file.

```ini
# This inventory is intended for the AAP 2.7 containerized growth topology.

[automationgateway]
aap.lab.example.com

[automationcontroller]
aap.lab.example.com

[automationhub]
aap.lab.example.com

[automationeda]
aap.lab.example.com

[automationmetrics]
aap.lab.example.com

# Ansible Lightspeed was deferred for the base install.
# [ansiblelightspeed]
# aap.lab.example.com

# Ansible MCP Server was deferred for the base install.
# [ansiblemcp]
# aap.lab.example.com

[database]
aap.lab.example.com

[all:vars]
ansible_connection=local

postgresql_admin_username=postgres
postgresql_admin_password=CHANGE_ME

registry_username=CHANGE_ME
registry_password=CHANGE_ME

redis_mode=standalone

gateway_admin_password=CHANGE_ME
gateway_pg_host=aap.lab.example.com
gateway_pg_password=CHANGE_ME

controller_admin_password=CHANGE_ME
controller_pg_host=aap.lab.example.com
controller_pg_password=CHANGE_ME
controller_percent_memory_capacity=0.5

hub_admin_password=CHANGE_ME
hub_pg_host=aap.lab.example.com
hub_pg_password=CHANGE_ME
hub_seed_collections=false

eda_admin_password=CHANGE_ME
eda_pg_host=aap.lab.example.com
eda_pg_password=CHANGE_ME

automationmetrics_pg_host=aap.lab.example.com
automationmetrics_pg_password=CHANGE_ME
automationmetrics_controller_read_pg_host=aap.lab.example.com
automationmetrics_controller_read_pg_password=CHANGE_ME
FEATURE_DASHBOARD_COLLECTION_ENABLED=false
```

Important notes:

- `ansible_connection=local` is used because the installer runs on the same VM where AAP is installed.
- `[automationmetrics]` is required by installer preflight for this growth topology.
- `FEATURE_DASHBOARD_COLLECTION_ENABLED=false` keeps the Automation Dashboard collection path disabled for the first install.
- Lightspeed and MCP are intentionally commented for the base install.
- Use unique strong passwords outside of throwaway labs.

## 15. Validate The Inventory

Run:

```bash
ansible-inventory -i inventory-growth --list
ansible-inventory -i inventory-growth --graph
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

Compare your edited inventory to the original:

```bash
diff -u inventory-growth.original inventory-growth
```

Check for active placeholders, example domains, or hostname typos:

```bash
awk '!/^[[:space:]]*#/ && /CHANGE_ME|<[^>]+>|example[.]org|examaple|examle/ { print FNR ":" $0 }' inventory-growth
```

This command should return no output. If it prints any active line, fix that line before installing.

## 16. Run The Installer

From the extracted installer directory:

```bash
cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
ansible-playbook -i inventory-growth -K ansible.containerized_installer.install
```

Use `-K` because the installer user needs sudo privilege escalation.

If you need more detail while troubleshooting:

```bash
ansible-playbook -i inventory-growth -K -v ansible.containerized_installer.install
```

## 17. Verify The Installation

Open the platform gateway from your workstation:

```text
https://aap.lab.example.com
```

Log in with:

- username: `admin`
- password: the value configured in `gateway_admin_password`

Verify these services from the UI:

- platform gateway loads
- automation controller is accessible
- private automation hub is accessible
- Event-Driven Ansible controller is accessible
- subscription activation can be completed

On the VM, verify container runtime state:

```bash
podman ps
podman pod ps
podman volume ls
```

Optional formatted view:

```bash
podman ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

## 18. Troubleshooting Notes

### Metrics Preflight Failure

If the installer fails with:

```text
You must have a host set in the [automationmetrics] section
```

Make sure this group is active:

```ini
[automationmetrics]
aap.lab.example.com
```

Also define:

```ini
automationmetrics_pg_host=aap.lab.example.com
automationmetrics_pg_password=CHANGE_ME
automationmetrics_controller_read_pg_host=aap.lab.example.com
automationmetrics_controller_read_pg_password=CHANGE_ME
FEATURE_DASHBOARD_COLLECTION_ENABLED=false
```

### Registry DNS Failure

If `podman login registry.redhat.io` fails with a message similar to:

```text
lookup registry.redhat.io on 192.168.34.2:53: no such host
```

Fix DNS first. This is not a registry password problem.

Use:

```bash
getent hosts registry.redhat.io
curl -I https://registry.redhat.io/v2/
```

Then update DNS with NetworkManager if needed:

```bash
CON=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2=="enp2s0"{print $1; exit}')

sudo nmcli connection modify "$CON" ipv4.ignore-auto-dns yes
sudo nmcli connection modify "$CON" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli connection up "$CON"
```

### Hostname Typo

A small hostname typo can break the install or database connectivity.

Check for common mistakes:

```bash
awk '!/^[[:space:]]*#/ && /examaple|examle/ { print FNR ":" $0 }' inventory-growth
```

The correct lab FQDN is:

```text
aap.lab.example.com
```

## 19. What To Do After The Base Install

After the base AAP platform is healthy, continue with this repository's configuration-as-code work:

1. Create organizations, teams, and RBAC.
2. Create credentials and credential types.
3. Create inventories and inventory sources.
4. Create projects linked to GitHub.
5. Create job templates and workflow templates.
6. Register execution environments.
7. Configure notifications.
8. Run an end-to-end demo job.
9. Add Ansible MCP Server after the base platform is stable.
10. Add Ansible Lightspeed after the model/API/provider requirements are ready.

## 20. Documentation Hygiene

This repository should contain sanitized examples only.

Do not commit:

- real registry credentials
- real AAP passwords
- subscription manifests
- TLS private keys
- private customer hostnames
- internal production IP addresses
- generated installer logs containing secrets

The successful private installer inventory should remain on the VM or in a private secrets store.
