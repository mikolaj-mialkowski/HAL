# HAL

> Won't lock anyone out of any airlocks.

A private, locally-running home assistant.

## What this is

A repo for a smart-home setup whose brain — and eventually its voice — runs
entirely on local hardware. Stage one: [Home Assistant](https://www.home-assistant.io/).
Stage two, eventually: a locally-hosted LLM plugged into HA's *Assist* as the
conversation backend.

The home runs on Philips Hue + Apple Home today, with potential extras. HA is
being added as the automation brain. Apple Home stays primary.

## Layout

```
HAL/
├── home-assistant/   the HA stack
└── hal-assistant/    the LLM, when its phase arrives
```

Runtime data (HA's `config/`, secrets, future model files) lives outside the repo.

## Roadmap, roughly

1. Repo scaffold — *current*
2. HA running in Docker
3. First integrations + automations
4. Apple Home back-bridge
5. Local LLM via HA's Assist

LLM stack leaning OpenClaw + Ollama (likely Gemma) — not this phase to decide.
