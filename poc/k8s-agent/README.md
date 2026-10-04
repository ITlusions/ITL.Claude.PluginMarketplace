# PoC: Claude Code agent in Kubernetes

A single pod that runs Claude Code, installs a plugin from this marketplace on start, and
registers itself for **Remote Control** so you can drive it from the Claude app / claude.ai/code.

> Status: written but not yet run against a cluster. Treat as a starting point and expect to tweak flags.

## Build & deploy

```bash
docker build -t ghcr.io/itlusions/itl-poc-agent:latest poc/k8s-agent
docker push ghcr.io/itlusions/itl-poc-agent:latest
kubectl apply -f poc/k8s-agent/k8s/agent.yaml
```

### Or with Helm

```bash
helm install poc poc/k8s-agent/chart/itl-poc-agent -n itl-agent --create-namespace \
  --set agent.pluginName=hello-plugin
```

The Deployment is then named `poc-itl-poc-agent` (`<release>-itl-poc-agent`); substitute it for
`deploy/itl-poc-agent` in the commands below. Values: `image.*`, `agent.*`, `authSecret`,
`persistence.*`, `networkPolicy.*`.

## Network policy

Both variants ship a NetworkPolicy: no ingress (Remote Control is outbound-only), egress only to
cluster DNS and TCP 443 on public IPs (RFC1918/link-local blocked). Needs a CNI that enforces
NetworkPolicy. Tighten further by pinning CIDRs for Anthropic/GitHub/npm if your CNI supports FQDN rules.

## Log in (one time)

Credentials are stored on the PVC (`/home/agent/.claude`), so this survives restarts.
Until you log in, the pod idles instead of crash-looping.

```bash
kubectl -n itl-agent exec -it deploy/itl-poc-agent -- claude /login
kubectl -n itl-agent rollout restart deploy/itl-poc-agent
```

Headless alternative: run `claude setup-token` on your laptop, store it as secret
`itl-poc-agent-auth` (key `CLAUDE_CODE_OAUTH_TOKEN`). Note: Remote Control may require a full
claude.ai login rather than an inference-only token — if it refuses, use the `/login` route.

## Headless mode (no interactive login)

`MODE=headless` skips Remote Control and the `/login` step. Auth comes from a Secret, and the
agent is controlled through a small HTTP API (`server.js`) that wraps `claude -p`.

```bash
kubectl apply -f poc/k8s-agent/k8s/headless.yaml
kubectl -n itl-agent create secret generic itl-poc-agent-auth \
  --from-literal=CLAUDE_CODE_OAUTH_TOKEN=<from `claude setup-token`> \   # or ANTHROPIC_API_KEY=...
  --from-literal=CONTROL_TOKEN="$(openssl rand -hex 32)"
kubectl -n itl-agent set env deploy/itl-poc-agent MODE=headless
```

Helm: `--set mode=headless --set authSecret=itl-poc-agent-auth` (same Secret keys).

Use it:

```bash
kubectl -n itl-agent port-forward svc/itl-poc-agent 8080:8080 &
curl -H "Authorization: Bearer $CONTROL_TOKEN" -d '{"prompt":"List the installed plugins and what they do"}' localhost:8080/run
# continue a conversation: add "session_id": "<session_id from the previous result>"
```

- One run at a time (`429` when busy); `RUN_TIMEOUT_SECONDS` kills long runs.
- Unattended runs cannot answer permission prompts, so only `ALLOWED_TOOLS` (default `Read,Glob,Grep`)
  are permitted. Widen it deliberately (e.g. `Bash(git:*)`), since anyone with the control token can run it.
- The pod refuses to start without `CONTROL_TOKEN` (>=16 chars) and a Claude credential.
- Ingress is open on 8080 for same-namespace pods only (`headless.allowFromNamespaces` in Helm to extend).
  The API is plain HTTP: put TLS/ingress auth in front of it before exposing it outside the cluster.

## Remote Control from the Claude app

This is the default (`mode: remote`). After the one-time `/login` above, the pod runs
`claude remote-control --name itl-poc-agent` and the session appears in the Claude app / claude.ai/code
(Code tab) under that name; you chat with the agent, approve tool prompts and see output from there.

- The login must be a full claude.ai login (`/login`), not a `setup-token`/API-key credential.
- `REMOTE_STYLE=interactive` runs `claude --remote-control <name>` instead (a normal interactive session
  with Remote Control on; the manifests/chart then set `stdin`+`tty`). Use it if server style misbehaves on your CLI version.
- Not verified here: this cloud sandbox can't run Remote Control. Check the exact flags with
  `kubectl exec deploy/itl-poc-agent -- claude remote-control --help`.
- The agent runs tools inside the pod: tool prompts you approve in the app execute there.

## Control it

- Remote: open the Claude app → Code → the session named `itl-poc-agent`.
- Fallback: `kubectl -n itl-agent exec -it deploy/itl-poc-agent -- claude`
- Verify the plugin: `kubectl -n itl-agent exec deploy/itl-poc-agent -- claude plugin list`
- Logs: `kubectl -n itl-agent logs deploy/itl-poc-agent`

## Change the plugin

Edit `PLUGIN_NAME` in `k8s/agent.yaml` (any plugin in `.claude-plugin/marketplace.json`) and re-apply.
The marketplace is private-capable: for a private repo, mount a token/deploy key and change `MARKETPLACE_SOURCE`.

## Security notes

The agent can run tools inside the pod, controlled remotely. Keep it non-root (as set), restrict
egress with a NetworkPolicy, and don't mount cluster credentials or a service-account token
(add `automountServiceAccountToken: false` if you extend this).
