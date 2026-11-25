#!/usr/bin/env bash
# Runs once when the Jenkins Lab codespace is created.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

echo ">> Installing helper commands: jenkinsctl, agent-vm"
sudo install -m 755 "$HERE/jenkinsctl" /usr/local/bin/jenkinsctl
sudo install -m 755 "$HERE/agent-vm" /usr/local/bin/agent-vm
sudo mkdir -p /usr/local/share/jenkins-lab
sudo cp "$HERE/agent-vm.Dockerfile" "$HERE/agent-vm-entrypoint.sh" /usr/local/share/jenkins-lab/

echo ">> Installing small tools (curl, tree, jq)"
sudo apt-get update -qq
sudo apt-get install -y -qq curl tree jq >/dev/null

echo ""
echo "Jenkins Lab ready. Jenkins is NOT installed yet: install it by following the video."
echo "Read .devcontainer/jenkins-lab/README.md for the commands that differ from EC2."
