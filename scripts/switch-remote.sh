#!/bin/bash
# switch-remote.sh — Toggle between SSH and HTTPS for the remote
# Usage:
#   ./scripts/switch-remote.sh ssh
#   ./scripts/switch-remote.sh https

set -e
cd "$(dirname "$0")/.."

MODE="${1:-ssh}"

case "$MODE" in
  ssh)
    URL="git@github.com:elham715/AI_agent_hackathon.git"
    ;;
  https)
    URL="https://github.com/elham715/AI_agent_hackathon.git"
    ;;
  *)
    echo "Usage: $0 [ssh|https]"
    exit 1
    ;;
esac

git remote set-url origin "$URL"
echo "✓ Remote set to: $URL"
git remote -v
