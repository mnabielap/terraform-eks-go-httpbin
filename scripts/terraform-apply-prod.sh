#!/usr/bin/env bash
set -euo pipefail

# Convenience script to apply the prod environment.

ENVIRONMENT="prod"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TF_ENV_DIR="${ROOT_DIR}/terraform/envs/${ENVIRONMENT}"

echo "[INFO] Applying Terraform for environment: ${ENVIRONMENT}"
echo "[INFO] Working directory: ${TF_ENV_DIR}"

terraform -chdir="${TF_ENV_DIR}" init
terraform -chdir="${TF_ENV_DIR}" apply -var="environment=${ENVIRONMENT}" -auto-approve

echo "[SUCCESS] Terraform apply completed for environment: ${ENVIRONMENT}"
