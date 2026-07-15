---
title: AAP 2.7 Containerized Install Runbook
---

# AAP 2.7 Containerized Install Runbook

This runbook tracks the private VM-side installation process for the AAP 2.7 lab.

## Lab Host

- Hostname/FQDN: `aap.lab.example.com`
- Static IP: `192.168.34.155`
- OS: RHEL 10.2
- Architecture: ARM64 / AArch64
- Installer user: `rajat`
- Installer directory: `/home/rajat/ansible-automation-platform-containerized-setup-2.7-2`

## Install Outcome

Status: base AAP 2.7 containerized install completed on 2026-07-15.

Installed components:

- platform gateway
- automation controller
- private automation hub
- Event-Driven Ansible controller
- Automation Metrics Service
- local database

Install notes:

- `[automationmetrics]` was required by installer preflight for this growth topology.
- `registry.redhat.io` access failed until the VM DNS configuration was changed from `192.168.34.2` to explicit public resolvers.
- Ansible Lightspeed and Ansible MCP Server were deferred until after the base platform install.

## Safety Rules

Do not commit the installer inventory or secret values to this public repository.

Keep these values only on the VM or in a private password manager:

- `registry_username`
- `registry_password`
- `postgresql_admin_password`
- `automationmetrics_pg_password`
- `automationmetrics_controller_read_pg_password`
- `gateway_admin_password`
- `gateway_pg_password`
- `controller_admin_password`
- `controller_pg_password`
- `hub_admin_password`
- `hub_pg_password`
- `eda_admin_password`
- `eda_pg_password`
- `lightspeed_admin_password`
- `lightspeed_pg_password`
- `lightspeed_wca_model_api_key`
- `lightspeed_chatbot_model_api_key`
- MCP TLS private keys

## Step 1 - Inspect Installer Directory

Run on the VM as `rajat`:

```bash
cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
ls -la
ls -la inventory*
sed -n '1,220p' README.md
```

The Red Hat installer package includes inventory examples. For this lab, start from the growth topology inventory because this is an all-in-one containerized install.

## Step 2 - Back Up The Original Inventory

Run:

```bash
cd /home/rajat/ansible-automation-platform-containerized-setup-2.7-2
cp -p inventory-growth inventory-growth.original
chmod 400 inventory-growth.original
chmod 600 inventory-growth
```

Keep `inventory-growth.original` as the untouched reference copy. Modify `inventory-growth` directly for the lab install.

## Step 3 - Configure Inventory

Use this sanitized structure as the successful base-install shape for `inventory-growth`. Replace every `CHANGE_ME` value with a private value.

```ini
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

# [ansiblelightspeed]
# aap.lab.example.com

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

# Ansible Lightspeed was deferred for the base install. When enabling it,
# use the exact variable names from your installer template and Red Hat
# subscription guidance.
# lightspeed_admin_password=CHANGE_ME
# lightspeed_pg_host=aap.lab.example.com
# lightspeed_pg_password=CHANGE_ME

# Ansible MCP Server was deferred for the base install.
# mcp_allow_write_operations=false
# mcp_ignore_certificate_errors=false
# mcp_tls_cert=/path/to/tls.crt
# mcp_tls_key=/path/to/tls.key
```

Notes:

- Use `ansible_connection=local` because the installer runs on the same host where AAP is installed.
- Keep `aap.lab.example.com` as the product FQDN.
- If a concrete SSH connection address is needed elsewhere, use `192.168.34.155`.
- For online setup installer packages, registry service account credentials are required.
- For disconnected setup bundle packages, registry credentials are not required; use bundle variables instead.
- AAP 2.7 containerized installer preflight requires a host in `[automationmetrics]` for this growth topology. Do not comment out the metrics group for the first install.
- Keep `automationmetrics_pg_host` and `automationmetrics_controller_read_pg_host` pointed at `aap.lab.example.com` for this single-node lab.
- Keep `FEATURE_DASHBOARD_COLLECTION_ENABLED=false` for the first install. The automation dashboard data collection path can be enabled later after the platform is stable.
- Keep `mcp_allow_write_operations=false` for the first install. This makes the MCP server read-only for connected AI clients until you intentionally allow job execution/write operations.
- If you do not yet have Ansible Lightspeed model/API/provider details, consider commenting out `[ansiblelightspeed]` for the first successful AAP install, then add Lightspeed as a second milestone.

## Step 4 - Run A Syntax/Inventory Check

Run:

```bash
ansible-inventory -i inventory-growth --list
diff -u inventory-growth.original inventory-growth
```

Resolve inventory syntax errors before running the installer.

Also check for unresolved placeholders, example domains, and common hostname typos:

```bash
awk '!/^[[:space:]]*#/ && /CHANGE_ME|<[^>]+>|example[.]org|examaple|examle/ { print FNR ":" $0 }' inventory-growth
```

The command should return no output. If it returns anything, resolve those lines before running the installer.

## Step 5 - Verify Registry Access

The online containerized installer must resolve and authenticate to `registry.redhat.io` before it can pull AAP images.

Run:

```bash
getent hosts registry.redhat.io
curl -I https://registry.redhat.io/v2/
podman login registry.redhat.io
```

Expected behavior:

- `getent hosts` returns at least one IP address.
- `curl` reaches the registry. An HTTP `401 Unauthorized` response is acceptable before login because it confirms DNS and TLS connectivity.
- `podman login` completes with `Login Succeeded!`.

If DNS fails, inspect the active NetworkManager connection and resolver configuration before running the installer:

```bash
nmcli -t -f NAME,DEVICE connection show --active
nmcli device show enp2s0 | grep -E 'IP4.DNS|IP4.GATEWAY'
cat /etc/resolv.conf
```

In this VMware lab, DNS resolution for `registry.redhat.io` failed while using `192.168.34.2`. The install proceeded successfully after setting explicit public DNS resolvers on the active `enp2s0` connection:

```bash
CON=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2=="enp2s0"{print $1; exit}')

sudo nmcli connection modify "$CON" ipv4.ignore-auto-dns yes
sudo nmcli connection modify "$CON" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli connection up "$CON"
```

## Step 6 - Run The Installer

Run:

```bash
ansible-playbook -i inventory-growth -K ansible.containerized_installer.install
```

Use `-K` because `rajat` uses sudo privilege escalation.

If Red Hat support or troubleshooting requires more detail, add verbosity:

```bash
ansible-playbook -i inventory-growth -K -v ansible.containerized_installer.install
```

## Step 7 - Verify After Install

After the install completes, verify from the workstation:

```text
https://aap.lab.example.com
```

Log in with:

- username: `admin`
- password: value configured in `gateway_admin_password`

Then verify:

- platform gateway loads
- automation controller is accessible
- private automation hub is accessible
- Event-Driven Ansible controller is accessible
- subscription activation can be completed

On the VM, capture service health after the first successful install:

```bash
systemctl --user status podman.socket
podman ps
podman pod ps
podman volume ls
```

## Step 8 - Next Bootstrap Milestone

After the UI and containers are healthy, move to configuration-as-code bootstrap from this repository:

- create organizations and teams
- create credentials and credential types
- create inventories and inventory sources
- create projects linked to GitHub
- create job templates and workflow templates
- register execution environments
- configure notifications
- run an end-to-end demo job
