#!/bin/bash
# test-auth.sh — Check if you can push to GitHub
set -e
cd "$(dirname "$0")/.."

echo "=========================================="
echo "Testing GitHub authentication"
echo "=========================================="
echo ""

# Show current remote
echo "Current remote:"
git remote -v
echo ""

# Test SSH
echo "→ SSH test (ssh -T git@github.com):"
if ssh -T -o StrictHostKeyChecking=no -o ConnectTimeout=5 git@github.com 2>&1 | grep -q "successfully authenticated\|Hi "; then
  echo "✓ SSH works! You can push via SSH."
  SSH_OK=1
else
  echo "✗ SSH not authorized. Add your public key at https://github.com/settings/keys"
  SSH_OK=0
fi
echo ""

# Test HTTPS
echo "→ HTTPS test:"
if git ls-remote https://github.com/elham715/AI_agent_hackathon.git HEAD >/dev/null 2>&1; then
  echo "✓ HTTPS works (no auth needed for public read)."
else
  echo "✗ HTTPS read failed."
fi
echo ""

echo "Public key to add to GitHub:"
echo "----------------------------------------"
cat ~/.ssh/id_ed25519.pub 2>/dev/null || echo "(no SSH key found at ~/.ssh/id_ed25519.pub)"
echo "----------------------------------------"
echo ""

if [ "$SSH_OK" = "1" ]; then
  echo "✓ You're ready to push! Try: ./scripts/agent-push.sh \"first commit\""
else
  echo "Next step: add the SSH key above to GitHub, OR create a PAT and run:"
  echo "  ./scripts/switch-remote.sh https"
  echo "Then push with your token as password."
fi
