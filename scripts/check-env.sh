#!/usr/bin/env bash
# Prints the version of every tool in the environment and whether LocalStack is up.
export PATH="$HOME/.local/bin:$PATH"

row() { printf "%-12s %s\n" "$1" "$2"; }

echo "== Tool versions =="
row "terraform" "$(terraform version 2>/dev/null | head -1 || echo 'MISSING')"
row "aws cli"   "$(aws --version 2>/dev/null || echo 'MISSING')"
row "tflint"    "$(tflint --version 2>/dev/null | head -1 || echo 'MISSING')"
row "checkov"   "$(checkov --version 2>/dev/null || echo 'MISSING')"
row "python"    "$(python3 --version 2>/dev/null || echo 'MISSING')"
row "docker"    "$(docker --version 2>/dev/null || echo 'MISSING')"

echo ""
echo "== LocalStack (needed from Day 3 only) =="
if [[ -z "${LOCALSTACK_AUTH_TOKEN:-}" ]]; then
  echo "LOCALSTACK_AUTH_TOKEN: not set (fine for Lessons 1-2)"
else
  echo "LOCALSTACK_AUTH_TOKEN: set"
fi
if curl -s --max-time 2 http://localhost:4566/_localstack/health >/dev/null; then
  echo "LocalStack: running on http://localhost:4566"
else
  echo "LocalStack: not running (start it with ./scripts/localstack-start.sh)"
fi
