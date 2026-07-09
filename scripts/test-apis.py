#!/usr/bin/env python3
"""test-apis.py — Verify API keys work without exposing them in shell history.

Usage:
    python3 scripts/test-apis.py

Reads keys from .env file (which is gitignored).
"""
import os
import sys
import json
import urllib.request
import urllib.error
from pathlib import Path


def load_env():
    env_path = Path(__file__).resolve().parent.parent / ".env"
    if not env_path.exists():
        print(f"✗ .env file not found at {env_path}")
        print("  Copy .env.example to .env and fill in your keys.")
        sys.exit(1)
    env = {}
    for line in env_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        env[key.strip()] = value.strip()
    return env


def test_gemini(api_key: str) -> bool:
    print("\n→ Testing Gemini API (embedding model)...")
    url = (
        "https://generativelanguage.googleapis.com/v1beta/models/"
        "gemini-embedding-001:embedContent"
    )
    payload = {
        "model": "models/gemini-embedding-001",
        "content": {"parts": [{"text": "AI agents work"}]},
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode(),
        headers={
            "Content-Type": "application/json",
            "x-goog-api-key": api_key,
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read())
            values = data.get("embedding", {}).get("values", [])
            if values:
                print(f"  ✓ OK — embedding length: {len(values)}")
                print(f"  ✓ First 5 values: {values[:5]}")
                return True
            print(f"  ✗ Unexpected response: {data}")
            return False
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="ignore")
        print(f"  ✗ HTTP {e.code}: {body[:200]}")
        return False
    except Exception as e:
        print(f"  ✗ {type(e).__name__}: {e}")
        return False


def test_openrouter(api_key: str, model: str) -> bool:
    print(f"\n→ Testing OpenRouter API (model: {model})...")
    url = "https://openrouter.ai/api/v1/chat/completions"
    payload = {
        "model": model,
        "messages": [
            {"role": "user", "content": "Reply with just 'ok'."}
        ],
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode(),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://github.com/elham715/AI_agent_hackathon",
            "X-Title": "AI Agent Hackathon",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read())
            reply = data["choices"][0]["message"]["content"]
            print(f"  ✓ OK — reply: {reply!r}")
            return True
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="ignore")
        print(f"  ✗ HTTP {e.code}: {body[:200]}")
        return False
    except Exception as e:
        print(f"  ✗ {type(e).__name__}: {e}")
        return False


def main():
    env = load_env()
    gemini_ok = False
    openrouter_ok = False

    if env.get("GEMINI_API_KEY"):
        gemini_ok = test_gemini(env["GEMINI_API_KEY"])
    else:
        print("⚠ GEMINI_API_KEY not set in .env")

    if env.get("OPENROUTER_API_KEY"):
        model = env.get("OPENROUTER_MODEL", "google/gemini-flash-latest")
        openrouter_ok = test_openrouter(env["OPENROUTER_API_KEY"], model)
    else:
        print("⚠ OPENROUTER_API_KEY not set in .env")

    print("\n" + "=" * 40)
    print(f"Gemini:     {'✓ OK' if gemini_ok else '✗ FAIL'}")
    print(f"OpenRouter: {'✓ OK' if openrouter_ok else '✗ FAIL'}")
    sys.exit(0 if (gemini_ok and openrouter_ok) else 1)


if __name__ == "__main__":
    main()