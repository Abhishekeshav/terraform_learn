#!/usr/bin/env bash
set -euo pipefail

echo ">> Installing helper tools..."
sudo apt-get update -qq
sudo apt-get install -y -qq jq tree unzip >/dev/null

echo ">> Installing checkov..."
python3 -m pip install --user --quiet --upgrade pip checkov

echo ">> Creating AWS CLI profile for LocalStack..."
mkdir -p "$HOME/.aws"
cat > "$HOME/.aws/config" <<'EOF'
[profile localstack]
region = us-east-1
output = json
endpoint_url = http://localhost:4566
EOF
cat > "$HOME/.aws/credentials" <<'EOF'
[localstack]
aws_access_key_id = test
aws_secret_access_key = test
EOF

{
  echo ''
  echo 'export PATH="$HOME/.local/bin:$PATH"'
  echo 'alias tf=terraform'
  echo 'alias awsl="aws --profile localstack"'
} >> "$HOME/.bashrc"
terraform -install-autocomplete >/dev/null 2>&1 || true
chmod +x scripts/*.sh

echo "Environment ready. Run ./scripts/check-env.sh to verify."
