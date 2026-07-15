.PHONY: help install-requirements lint validate-prereqs configure-controller configure-hub register-ee validate-platform demo clean

help:
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ {printf "%-28s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-requirements: ## Install public Ansible collection dependencies
	ansible-galaxy collection install -r requirements.yml

lint: ## Run YAML and Ansible lint checks
	yamllint .
	ansible-lint .

validate-prereqs: ## Validate local tooling and required variables
	ansible-playbook playbooks/00_validate_prereqs.yml

configure-controller: ## Apply controller configuration as code
	ansible-playbook playbooks/02_configure_controller.yml

configure-hub: ## Apply private automation hub configuration as code
	ansible-playbook playbooks/03_configure_hub.yml

register-ee: ## Register execution environments in AAP
	ansible-playbook playbooks/04_register_execution_environments.yml

validate-platform: ## Validate configured AAP objects and platform health
	ansible-playbook playbooks/99_validate_platform.yml

demo: ## Run the portfolio demo workflow
	ansible-playbook playbooks/05_create_demo_workflows.yml

clean: ## Remove local cache artifacts
	rm -rf .cache .pytest_cache .molecule build dist artifacts
