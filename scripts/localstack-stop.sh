#!/usr/bin/env bash
# Stops LocalStack. Its fake resources are lost when the container is removed,
# so run `terraform destroy` first, or delete local state afterwards.
set -euo pipefail

if [[ "${1:-}" == "--reset" ]]; then
  docker rm -f localstack >/dev/null 2>&1 && echo "LocalStack container removed (all fake resources gone)."
else
  docker stop localstack >/dev/null 2>&1 && echo "LocalStack stopped. Use --reset to remove it completely."
fi
