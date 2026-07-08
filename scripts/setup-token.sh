#!/bin/bash
# setup-token.sh — Configure HTTPS push with a Personal Access Token
# Usage:
#   ./scripts/setup-token.sh
# This script will ask for your token and store it in macOS keychain.

set -e
cd "$(dirname "$0")/.."

echo "=========================================="
echo "HTTPS Token Setup"
echo "=========================================="
echo ""
echo "Create a token at: https://github.com/settings/tokens/new"
echo "Required scope: repo"
echo ""
read -s -p "Paste your GitHub Personal Access Token: " TOKEN
echo ""

if [ -z "$TOKEN" ]; then
  echo "✗ No token provided."
  exit 1
fi

# Switch to HTTPS
./scripts/switch-remote.sh https

# Store credentials in macOS keychain (or git credential helper)
git config --global credential.helper osxkeychain

# Embed token in URL temporarily so first push works without re-prompt
ENC_URL="https://${TOKEN}@github.com/elham715/AI_agent_hackathon.git"
git remote set-url origin "$ENC_URL"

# First push to verify, then reset URL to clean form
echo ""
echo "Pushing to verify..."
if git push -u origin main 2>&1; then
  git remote set-url origin "https://github.com/elham715/AI_agent_hackathon.git"
  echo ""
  echo "✓ Token works! Credentials saved to macOS keychain."
  echo "Future pushes will use the stored credentials."
else
  echo "✗ Push failed. Check your token and try again."
  exit 1
fi
