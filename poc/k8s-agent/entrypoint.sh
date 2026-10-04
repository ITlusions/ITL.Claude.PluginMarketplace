#!/usr/bin/env bash
# PoC agent bootstrap: register the marketplace, install the plugin, then expose
# the session for remote control (Claude app / claude.ai/code).
set -euo pipefail

MARKETPLACE_SOURCE="${MARKETPLACE_SOURCE:-https://github.com/ITlusions/ITL.Claude.PluginMarketplace.git}"
MARKETPLACE_NAME="${MARKETPLACE_NAME:-itl-claude-tools}"
PLUGIN_NAME="${PLUGIN_NAME:-hello-plugin}"
AGENT_NAME="${AGENT_NAME:-itl-poc-agent}"
MODE="${MODE:-remote}"   # remote = Remote Control (needs interactive login) | headless = HTTP API + token/API-key auth

mkdir -p "$HOME/workspace"
cd "$HOME/workspace"

# Idempotent: PVC-backed $HOME means these may already exist after a restart.
claude plugin marketplace add "$MARKETPLACE_SOURCE" || claude plugin marketplace update "$MARKETPLACE_NAME" || true
claude plugin install "${PLUGIN_NAME}@${MARKETPLACE_NAME}" || echo "plugin already installed or install failed (see above)"
claude plugin list || true

if [ "$MODE" = "headless" ]; then
  if [ -z "${CLAUDE_CODE_OAUTH_TOKEN:-}" ] && [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "headless mode needs CLAUDE_CODE_OAUTH_TOKEN or ANTHROPIC_API_KEY (via the auth Secret)." >&2
    exit 1
  fi
  exec node /opt/agent/server.js
fi

# Login is one-time and persisted in $HOME/.claude on the PVC (see README: `kubectl exec ... claude`).
if [ ! -s "$HOME/.claude/.credentials.json" ] && [ -z "${CLAUDE_CODE_OAUTH_TOKEN:-}" ] && [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "No credentials yet. Run: kubectl -n itl-agent exec -it deploy/itl-poc-agent -- claude /login"
  echo "Sleeping so the pod stays up for login..."
  exec sleep infinity
fi

# Remote Control: shows up in the Claude app / claude.ai/code under this name.
#   REMOTE_STYLE=server      -> `claude remote-control` (headless server mode, no TTY needed)
#   REMOTE_STYLE=interactive -> `claude --remote-control <name>` (full session; needs tty+stdin on the container)
# If one style misbehaves on your CLI version, check `claude remote-control --help` in the pod and switch.
REMOTE_STYLE="${REMOTE_STYLE:-server}"
if [ "$REMOTE_STYLE" = "interactive" ]; then
  exec claude --remote-control "$AGENT_NAME"
fi
exec claude remote-control --name "$AGENT_NAME"
