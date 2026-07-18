---
title: AAP API Connectivity
---

# AAP API Connectivity

After the base AAP 2.7 installation is complete, this project validates the platform through the platform gateway API before creating configuration-as-code objects.

## Why Gateway And Token Authentication

AAP 2.7 centralizes API access through the platform gateway. Programmatic access should use OAuth2 bearer tokens against gateway-routed APIs, such as:

- `https://<gateway>/api/gateway/v1/`
- `https://<gateway>/api/controller/v2/`
- `https://<gateway>/api/eda/v1/`

The playbooks in this repository use an `AAP_TOKEN` value and do not commit API tokens, passwords, manifests, or registry credentials.

## Create A Local Token

Generate an OAuth2 token from the platform gateway token endpoint:

```bash
curl -k -u admin -X POST \
  https://aap.lab.example.com/api/gateway/v1/tokens/
```

Copy the returned `token` value into a private local environment file or export it for the current shell.

## Configure Local Environment Variables

Copy the example file:

```bash
cp .env.example .env
```

Set local values:

```bash
AAP_HOST=https://aap.lab.example.com
AAP_TOKEN=<oauth2-token-value>
AAP_VERIFY_SSL=false
```

Use `AAP_VERIFY_SSL=false` only for a lab that uses the generated self-signed certificate. Use `AAP_VERIFY_SSL=true` when the gateway certificate chains to a trusted certificate authority.

Load the file before running playbooks:

```bash
set -a
source .env
set +a
```

## Validate Connectivity

Run the prerequisite validation:

```bash
make validate-prereqs
```

This validates:

- local Ansible tooling
- platform gateway reachability
- OAuth2 token authentication
- automation controller API reachability through the gateway

## Validate Installed Services

Run the platform validation:

```bash
make validate-platform
```

This validates the installed AAP service APIs through the gateway and performs read-only checks against controller resources such as organizations, users, teams, inventories, projects, and job templates.

## Troubleshooting

- HTTP `401` usually means the token is missing, expired, or copied incorrectly.
- HTTP `403` means the token is valid but lacks permission for that API resource.
- Certificate errors in a lab can be handled with `AAP_VERIFY_SSL=false`.
- DNS errors should be fixed locally before disabling certificate validation.

## References

- [Red Hat AAP 2.7 API changes for platform gateway](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/assembly_upgrade_api_changes)
- [Red Hat AAP 2.7 basic authentication removal](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/secure-con_api_basic_auth_removal_27)
- [Red Hat AAP 2.7 OAuth2 token authentication](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/secure-con_controller_api_oauth2_token)
