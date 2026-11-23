#!/usr/bin/env bash
# Starts LocalStack (a local emulator of AWS APIs) inside the codespace.
set -euo pipefail

if [[ -z "${LOCALSTACK_AUTH_TOKEN:-}" ]]; then
  cat <<'EOF'
LOCALSTACK_AUTH_TOKEN is not set.

Since March 2026 LocalStack needs a (free) auth token to start:
  1. Sign up for the free Hobby plan at https://app.localstack.cloud
  2. Copy your auth token from the LocalStack web app
  3. On GitHub: Settings -> Codespaces -> Secrets -> New secret
       Name: LOCALSTACK_AUTH_TOKEN   Repository access: this repo
  4. Stop and restart this codespace, then run this script again.
EOF
  exit 1
fi

if docker ps --format '{{.Names}}' | grep -qx localstack; then
  echo "LocalStack is already running."
elif docker ps -a --format '{{.Names}}' | grep -qx localstack; then
  echo "Restarting existing LocalStack container..."
  docker start localstack >/dev/null
else
  echo "Pulling and starting LocalStack (first time takes a minute)..."
  docker run -d --name localstack \
    -p 4566:4566 \
    -e LOCALSTACK_AUTH_TOKEN="$LOCALSTACK_AUTH_TOKEN" \
    localstack/localstack:latest >/dev/null
fi

echo -n "Waiting for LocalStack to be ready"
for _ in $(seq 1 60); do
  if curl -s --max-time 2 http://localhost:4566/_localstack/health | grep -q '"s3"'; then
    echo " ready."
    echo ""
    echo "Services we use in this course:"
    curl -s http://localhost:4566/_localstack/health \
      | jq '.services | with_entries(select(.key | test("^(s3|iam|sts|secretsmanager)$")))'
    echo ""
    echo "Try:  aws --profile localstack s3 ls     (or the alias: awsl s3 ls)"
    exit 0
  fi
  echo -n "."
  sleep 2
done

echo ""
echo "LocalStack did not become ready in time. Last log lines:"
docker logs --tail 40 localstack
exit 1
