#!/bin/bash
# agent-push.sh — Push code from any AI agent to GitHub
# Usage:
#   ./scripts/agent-push.sh "commit message"
#   ./scripts/agent-push.sh                 (uses auto-generated message)
#   ./scripts/agent-push.sh --force         (force push, use carefully)

set -e

cd "$(dirname "$0")/.."

FORCE=""
if [ "$1" = "--force" ]; then
  FORCE="--force"
  shift
fi

if [ -n "$1" ]; then
  MSG="$1"
else
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  MSG="AI agent update at $TIMESTAMP"
fi

echo "=========================================="
echo "Agent Push — pushing to GitHub"
echo "=========================================="
echo "Repo:   $(git config --get remote.origin.url)"
echo "Branch: $(git rev-parse --abbrev-ref HEAD)"
echo "Commit: $MSG"
echo ""

# Status check
echo "→ git status"
git status --short

# Stage everything
echo "→ git add -A"
git add -A

if git diff --cached --quiet; then
  echo "→ No changes to commit. Pulling latest instead..."
  git pull --rebase --autostash
  echo "✓ Already up to date."
  exit 0
fi

# Commit
echo "→ git commit"
git commit -m "$MSG

Co-Authored-By: AI Agent <noreply@hackathon.local>"

# Pull with rebase before push
echo "→ git pull --rebase"
git pull --rebase --autostash || {
  echo "✗ Pull failed. Resolve conflicts then re-run."
  exit 1
}

# Push
echo "→ git push $FORCE"
if [ -n "$FORCE" ]; then
  git push --force-with-lease origin HEAD
else
  git push origin HEAD
fi

echo ""
echo "✓ Pushed successfully!"
echo "View at: https://github.com/elham715/AI_agent_hackathon"
