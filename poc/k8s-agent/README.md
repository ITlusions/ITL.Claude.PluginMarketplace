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
