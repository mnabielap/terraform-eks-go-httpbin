#!/usr/bin/env bash
set -euo pipefail

# This helper script only prints the environment variable export command
# for KUBECONFIG, without actually generating the file.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

KUBECONFIG_FILE="${ROOT_DIR}/kubeconfig"

echo "To use the kubeconfig file with kubectl, run the following command:"
echo
echo "  export KUBECONFIG=\"${KUBECONFIG_FILE}\""
echo
echo "After that you can verify the cluster with:"
echo
echo "  kubectl get nodes"
