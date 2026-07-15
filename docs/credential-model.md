---
title: Credential Model
---

# Credential Model

Credentials are represented in example files, but real secrets must be supplied through private local files, Ansible Vault, SOPS, or an external secret manager.

## Credential Types

- machine credentials
- source control credentials
- container registry credentials
- automation hub tokens
- cloud credentials
- notification webhooks
- ticketing API tokens

## Rules

- Do not commit real credential values.
- Prefer token-based access over shared passwords.
- Scope tokens to the minimum required permission.
- Rotate demo credentials after screenshots or recordings.
- Keep public examples fake but structurally realistic.
