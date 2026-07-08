# Git Push Setup Guide

## Current Status

- Repo initialized with remote: `git@github.com:elham715/AI_agent_hackathon.git`
- SSH key exists but not authorized on GitHub (needs to be added)
- HTTPS token path available as fallback

---

## Option A: Use SSH (Recommended for long-term)

Your SSH public key:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJkn3s5G860qrMqerj9hadUjKJDHoJl1RgYrQPRuwAY hetzner-omnia
```

### Steps
1. Open: https://github.com/settings/keys
2. Click **"New SSH key"**
3. Title: `hetzner-omnia` (or anything)
4. Key: paste the line above
5. Click **Add SSH key**
6. Verify with: `ssh -T git@github.com` (should say "Hi elham715!...")

After this, the `git@github.com:elham715/AI_agent_hackathon.git` remote will work automatically.

---

## Option B: Use HTTPS + Personal Access Token (Faster, works now)

### Steps
1. Create a token: https://github.com/settings/tokens/new
   - Note: `hackathon-push`
   - Expiration: your choice
   - Scopes: check **`repo`** only
2. Copy the token (you'll only see it once)
3. Run:
   ```bash
   cd /Users/admin/Desktop/Hackathon
   ./scripts/switch-remote.sh https
   git push -u origin main
   ```
4. When prompted, paste your token as the password

---

## For AI Agents (any agent, any time)

Once auth is configured, **any AI agent** can push by running:

```bash
cd /Users/admin/Desktop/Hackathon
./scripts/agent-push.sh "Your commit message here"
```

This script:
- Stages all changes
- Commits with the message
- Pulls/rebases to avoid conflicts
- Pushes to GitHub
- Reports success or clear errors

---

## Quick Auth Test

```bash
ssh -T git@github.com           # SSH test
./scripts/test-auth.sh          # Tests both SSH and HTTPS
```

See `scripts/agent-push.sh` for the full flow.
