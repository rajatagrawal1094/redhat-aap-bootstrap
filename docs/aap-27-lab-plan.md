---
title: AAP 2.7 Lab Plan
---

# AAP 2.7 Lab Plan

This project targets Red Hat Ansible Automation Platform 2.7.

## Target Operating System

This lab uses Red Hat Enterprise Linux 10.

AAP 2.7 supports containerized installation on RHEL 10. Do not plan an RPM-based AAP installation for this lab; the project assumes the containerized installer path.

## Recommended Lab Topology

Start with a single-node containerized AAP lab using the growth topology pattern.

Recommended VM sizing:

- RHEL 10.2 host supported by the AAP 2.7 containerized installer
- 8 vCPU preferred
- 32 GB RAM preferred
- 150 GB or more disk preferred
- static IP address
- resolvable FQDN
- SSH access from the workstation
- HTTPS access from the workstation

## Current Lab VM

The current lab VM is planned as:

- IP address: `192.168.34.155`
- Hostname/FQDN: `aap.lab.example.com`
- OS version: RHEL 10.2
- Architecture: ARM64 / AArch64
- Virtualization: VMware
- Network interface: `enp2s0`
- FIPS mode: disabled
- Red Hat subscription: registered
- Time synchronization: enabled
- Installer user: `rajat`
- Installer user sudo access: enabled through `wheel`
- RAM: 48 GB
- CPU: 8 vCPU
- Disk: 500 GB

## Current Status

- IP reachability from workstation: verified
- FQDN resolution from workstation: verified
- Hostname configured: verified
- Static IP configured: verified
- Time synchronization: verified
- Red Hat content access through `rhc status`: verified
- Podman installed: verified, version 5.8.2
- IPv4 hostname resolution: verified with `getent ahostsv4 aap.lab.example.com`
- Host lookup note: `getent hosts aap.lab.example.com` may return the local IPv6 link-local address through `myhostname`; use `192.168.34.155` as the concrete installer connection address.
- AAP 2.7 containerized installer: downloaded and extracted under `/home/rajat`
- Installer directory: `/home/rajat/ansible-automation-platform-containerized-setup-2.7-2`
- Base AAP 2.7 containerized install: completed
- Next milestone: configure the installed platform from this repository using configuration-as-code

The goal of this lab is not high availability. The goal is to provide a realistic enterprise AAP endpoint for configuration-as-code, execution environment, Private Automation Hub, RBAC, and workflow automation demonstrations.

## Components

The initial lab should include:

- platform gateway
- automation controller
- private automation hub
- database
- Event-Driven Ansible controller

Event-Driven Ansible can be installed in the initial all-in-one topology, but portfolio workflows that use it can wait until a later milestone.

## FIPS Decision

The primary portfolio lab is expected to run without FIPS mode unless the project is explicitly expanded to demonstrate regulated-environment installation requirements.

For RHEL 10, FIPS must be enabled during the operating system installation. Do not install AAP first and then attempt to retrofit FIPS mode later.

Recommended path:

1. Build the first AAP 2.7 lab on RHEL 10 without FIPS.
2. Complete the platform bootstrap, controller configuration, execution environment, and workflow demos.
3. Add a separate FIPS-focused lab or documentation extension later if the portfolio needs regulated-environment coverage.

## Installation Inputs To Keep Private

Do not commit these values to this repository:

- Red Hat registry service account credentials
- Red Hat subscription manifest
- installer inventory with real passwords
- admin password
- database passwords
- TLS private keys
- real hostnames or internal IPs if the repository is public

Use sanitized examples in documentation and keep real installation files outside the repository.

## Immediate Pre-Install Checklist

Run these checks on the RHEL VM before downloading or running the installer:

```bash
hostnamectl
ip addr
timedatectl
rhc status
sudo dnf update -y
podman --version
```

Confirm local hostname resolution on the VM:

```bash
getent hosts aap.lab.example.com
getent ahostsv4 aap.lab.example.com
```

Expected result:

```text
192.168.34.155 aap.lab.example.com aap
```

If `getent hosts` returns only an IPv6 link-local address, but `/etc/hosts` contains the correct IPv4 entry, inspect the host lookup order:

```bash
grep '^hosts:' /etc/nsswitch.conf
getent ahostsv4 aap.lab.example.com
```

If IPv4 resolution works with `getent ahostsv4`, continue with the install but ensure the AAP inventory uses `192.168.34.155` where a concrete connection address is needed. Keep `aap.lab.example.com` as the user-facing FQDN and certificate name.

If IPv4 resolution does not work, fix `/etc/hosts` before installing AAP:

```bash
sudo cp /etc/hosts /etc/hosts.bak
sudo tee -a /etc/hosts <<'EOF'
192.168.34.155 aap.lab.example.com aap
EOF
getent hosts aap.lab.example.com
getent ahostsv4 aap.lab.example.com
```

If `nss-myhostname` still takes precedence and only returns the IPv6 link-local address, update the host lookup order so `files` is checked first:

```bash
sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
sudo sed -i 's/^hosts:.*/hosts: files dns myhostname/' /etc/nsswitch.conf
grep '^hosts:' /etc/nsswitch.conf
getent hosts aap.lab.example.com
getent ahostsv4 aap.lab.example.com
```

Confirm SSH access from the workstation:

```bash
ssh rajat@aap.lab.example.com
```

Use the dedicated non-root installer user `rajat`, which has sudo access through the `wheel` group, for the containerized installation.

## Post-Install Success Criteria

Before connecting this repository to AAP, verify:

1. The AAP UI opens in a browser.
2. You can log in as an administrator.
3. The subscription is attached.
4. Automation controller is reachable.
5. Private Automation Hub is reachable.
6. The platform gateway endpoint is reachable.
7. The workstation can reach the AAP FQDN over HTTPS.

## Repository Connection Plan

After AAP is installed:

1. Copy `inventories/group_vars/all.example.yml` to a private, ignored file:

   ```bash
   cp inventories/group_vars/all.example.yml inventories/group_vars/all.yml
   ```

2. Update `inventories/group_vars/all.yml` with the lab URL and credentials.
3. Run:

   ```bash
   make validate-prereqs
   ```

4. Implement and run the AAP health check role against the real platform endpoint.

## AAP 2.7 Execution Environment Base Image

This repository uses the AAP 2.7 minimal RHEL 9 execution environment base image:

```text
registry.redhat.io/ansible-automation-platform-27/ee-minimal-rhel9:latest
```

Pin the image by digest later if repeatability becomes more important than tracking current patch updates.
