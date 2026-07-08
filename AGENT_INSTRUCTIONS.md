# AI Agent Instructions

> **This file is read by AI coding agents (Claude Code, Cursor, Windsurf, Aider, Cline, etc.) to understand how to push code to this repository.**

## Repository

- **Owner:** elham715
- **Name:** AI_agent_hackathon
- **URL:** https://github.com/elham715/AI_agent_hackathon
- **Default branch:** main
- **Visibility:** public

## Authentication

Authentication is pre-configured on this machine. The user has set up one of:

1. **SSH key** — preferred, no prompts needed
2. **HTTPS + macOS Keychain** — fallback, credentials cached

If a push fails with auth errors, the user must complete setup. Do not attempt to add keys or tokens yourself.

## How to Push

**Always use the helper script.** Never run raw `git push` from an agent unless the script fails.

```bash
cd /Users/admin/Desktop/Hackathon
./scripts/agent-push.sh "Concise commit message"
```

The script handles: staging, committing, rebase-pull, push, and error reporting.

### Rules for commit messages

- Imperative mood: "Add login form", not "Added login form"
- 50 chars or less for the subject line
- Reference the issue or feature if relevant
- The script auto-appends `Co-Authored-By: AI Agent <noreply@hackathon.local>`

### What NOT to do

- Do not run `git push --force` (use `--force-with-lease` only via the script flag)
- Do not commit `.env` files, secrets, or credentials
- Do not push to branches other than `main` unless explicitly asked
- Do not amend commits that have been pushed

## Project Structure

```
/Users/admin/Desktop/Hackathon/
├── README.md                       # Project overview (required by hackathon)
├── PROJECT_REQUIREMENTS.md         # Hackathon rules & requirements
├── WINNING_PROJECT_IDEAS.md        # Curated project ideas
├── AGENT_INSTRUCTIONS.md           # This file
├── SETUP_GUIDE.md                  # Git/auth setup for the user
├── .gitignore
├── scripts/
│   ├── agent-push.sh               # ← USE THIS to push
│   ├── switch-remote.sh            # Toggle SSH/HTTPS remote
│   ├── setup-token.sh              # Configure HTTPS token
│   └── test-auth.sh                # Verify auth works
└── (your code goes here)
```

## Workflow

1. Make your changes
2. Test locally if possible
3. Run `./scripts/agent-push.sh "your message"`
4. Verify the push succeeded (script reports the GitHub URL)

## When You Can't Push

If `./scripts/agent-push.sh` fails:

1. Read the error message
2. If it's an auth error → tell the user: "GitHub auth is not configured. Run `./scripts/test-auth.sh` to diagnose, then follow `SETUP_GUIDE.md`."
3. If it's a conflict → do NOT auto-resolve; ask the user
4. If it's a network error → wait and retry once
5. Never try to bypass auth or rewrite history without explicit user permission
