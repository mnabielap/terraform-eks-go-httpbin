# Simple helper Makefile for Terraform and Kubernetes workflows.
# This file is intentionally simple and does not assume any specific OS shell.
# On Windows, you can use Git Bash or WSL to run these commands.

PROJECT_NAME ?= terraform-eks-go-httpbin
TF_DIR        := terraform
ENV           ?= dev

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make fmt           - Run 'terraform fmt' in the terraform directory"
	@echo "  make validate      - Run 'terraform validate' for the selected environment"
	@echo "  make plan          - Run 'terraform plan' for the selected environment"
	@echo "  make apply         - Run 'terraform apply' for the selected environment"
	@echo "  make destroy       - Run 'terraform destroy' for the selected environment"
	@echo "  make kubeconfig    - Generate kubeconfig using helper script"
	@echo "  make show-env      - Print current environment"

.PHONY: show-env
show-env:
	@echo "Current environment: $(ENV)"

.PHONY: fmt
fmt:
	cd $(TF_DIR) && terraform fmt -recursive

.PHONY: validate
validate:
	cd $(TF_DIR)/envs/$(ENV) && terraform init -backend=false
	cd $(TF_DIR) && terraform validate

.PHONY: plan
plan:
	cd $(TF_DIR)/envs/$(ENV) && terraform init
	cd $(TF_DIR)/envs/$(ENV) && terraform plan -var="environment=$(ENV)"

.PHONY: apply
apply:
	cd $(TF_DIR)/envs/$(ENV) && terraform init
	cd $(TF_DIR)/envs/$(ENV) && terraform apply -var="environment=$(ENV)"

.PHONY: destroy
destroy:
	cd $(TF_DIR)/envs/$(ENV) && terraform init
	cd $(TF_DIR)/envs/$(ENV) && terraform destroy -var="environment=$(ENV)"

.PHONY: kubeconfig
kubeconfig:
	chmod +x scripts/generate-kubeconfig.sh || true
	./scripts/generate-kubeconfig.sh
