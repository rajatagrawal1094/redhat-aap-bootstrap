---
title: Troubleshooting
---

# Troubleshooting

## Common Issues

### Authentication Fails

- Confirm AAP URL.
- Confirm token or username/password.
- Confirm SSL certificate trust.
- Confirm API endpoint path for your AAP version.

### Collection Is Missing

Run:

```bash
make install-requirements
```

### Lint Fails

Run the linters directly for clearer output:

```bash
yamllint .
ansible-lint .
```

### Execution Environment Build Fails

- Confirm `ansible-builder` is installed.
- Confirm registry authentication.
- Confirm collection requirements are reachable.
