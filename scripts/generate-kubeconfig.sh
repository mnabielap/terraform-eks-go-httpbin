#!/usr/bin/env bash
set -euo pipefail

# This script generates a kubeconfig file based on the Terraform output
# from the selected environment. It is intended to be run from the
# project root directory or from anywhere with a POSIX-compatible shell.

ENVIRONMENT="${ENVIRONMENT:-dev}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

TF_ENV_DIR="${ROOT_DIR}/terraform/envs/${ENVIRONMENT}"

KUBECONFIG_FILE="${ROOT_DIR}/kubeconfig"

echo "[INFO] Generating kubeconfig for environment: ${ENVIRONMENT}"
echo "[INFO] Terraform environment directory: ${TF_ENV_DIR}"
echo "[INFO] Output kubeconfig file: ${KUBECONFIG_FILE}"

# Run terraform output to get the kubeconfig content.
terraform -chdir="${TF_ENV_DIR}" init -input=false >/dev/null
terraform -chdir="${TF_ENV_DIR}" output -raw kubeconfig > "${KUBECONFIG_FILE}"

echo "[SUCCESS] Kubeconfig has been written to: ${KUBECONFIG_FILE}"
echo
echo "To use this kubeconfig with kubectl, you can run:"
echo "  export KUBECONFIG=\"${KUBECONFIG_FILE}\""
echo "  kubectl get nodes"
