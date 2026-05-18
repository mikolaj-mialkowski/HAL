# HAL-assistant

The local LLM. Ollama + Gemma 4 e2b for the PoC.

## Install

```
./setup-mac.sh
```

Installs Ollama natively (Apple Silicon → Metal/MLX), binds it on
`0.0.0.0:11434` so HA's container can reach it via `host.docker.internal`,
starts it as a launchd service, pulls `gemma4:e2b`. Idempotent.

## Wire it to Home Assistant

Settings → Devices & Services → Add Integration → Ollama

- URL: `http://host.docker.internal:11434`
- Model: `gemma4:e2b`
