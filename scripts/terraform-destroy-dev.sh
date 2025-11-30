#!/usr/bin/env bash
set -euo pipefail

# Convenience script to destroy the dev environment.

ENVIRONMENT="dev"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TF_ENV_DIR="${ROOT_DIR}/terraform/envs/${ENVIRONMENT}"

echo "[INFO] Destroying Terraform resources for environment: ${ENVIRONMENT}"
echo "[INFO] Working directory: ${TF_ENV_DIR}"

terraform -chdir="${TF_ENV_DIR}" init
terraform -chdir="${TF_ENV_DIR}" destroy -var="environment=${ENVIRONMENT}" -auto-approve

echo "[SUCCESS] Terraform destroy completed for environment: ${ENVIRONMENT}"
