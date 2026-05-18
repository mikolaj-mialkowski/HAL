#!/usr/bin/env bash
# Native Ollama install + Gemma 4 e2b pull, for Apple Silicon Macs.
# Docker can't access Metal/MLX on Mac, so the LLM piece runs natively.
# Idempotent: re-running is safe.
set -euo pipefail

MODEL="${MODEL:-gemma4:e2b}"
OLLAMA_HOST_VALUE="0.0.0.0:11434"   # so HA's Docker container can reach via host.docker.internal

say() { printf '\n==> %s\n' "$*"; }

if ! command -v brew >/dev/null 2>&1; then
  say "Installing Homebrew (you'll be prompted for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  say "Homebrew present"
fi

if ! command -v ollama >/dev/null 2>&1; then
  say "Installing Ollama"
  brew install ollama
else
  say "Ollama already installed ($(ollama --version 2>/dev/null | head -1 || echo 'version unknown'))"
fi

current=$(launchctl getenv OLLAMA_HOST 2>/dev/null || true)
if [[ "$current" != "$OLLAMA_HOST_VALUE" ]]; then
  say "Setting OLLAMA_HOST=$OLLAMA_HOST_VALUE for launchd"
  launchctl setenv OLLAMA_HOST "$OLLAMA_HOST_VALUE"
fi

say "Starting/restarting Ollama service"
brew services restart ollama >/dev/null

for _ in {1..15}; do
  if curl -s --max-time 1 http://localhost:11434/ >/dev/null 2>&1; then break; fi
  sleep 1
done
if ! curl -s --max-time 2 http://localhost:11434/ >/dev/null 2>&1; then
  echo "Ollama isn't responding on :11434. Check 'brew services list'." >&2
  exit 1
fi

if ollama list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$MODEL"; then
  say "$MODEL already pulled"
else
  say "Pulling $MODEL (~7 GB, takes a few minutes)"
  ollama pull "$MODEL"
fi

say "Ready. Installed models:"
ollama list

cat <<EOF

Next: in Home Assistant
  Settings -> Devices & Services -> Add Integration -> Ollama
  URL:   http://host.docker.internal:11434
  Model: $MODEL
EOF
