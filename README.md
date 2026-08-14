# ITL.Claude.PluginMarketplace

Private Claude Code plugin marketplace. Add each plugin as its own folder under `plugins/`,
register it in `.claude-plugin/marketplace.json`, and it's installable on any machine with:

```
/plugin marketplace add https://github.com/ITlusions/ITL.Claude.PluginMarketplace.git
/plugin install <plugin-name>@itl-claude-tools
```

Or locally, before pushing:

```
/plugin marketplace add ./ITL.Claude.PluginMarketplace
/plugin install <plugin-name>@itl-claude-tools
```

## Plugins

| Plugin | Description |
|---|---|
| [`nexustrade-plugin`](plugins/nexustrade-plugin) | Quantitative trading analysis — 7-step technical/fundamental analysis, position sizing, risk/reward validation, adversarial risk review. Agents: `nexustrade`, `nexustrade-analyst`, `nexustrade-portfolio`, `nexustrade-risk`. Skill: `nexustrade` (methodology + Jupyter calculator notebooks). |

## Adding a new plugin

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json      # name, description, version, author, repository, license
├── agents/               # optional: *.md subagent definitions
├── skills/               # optional: <skill-name>/SKILL.md + supporting files
├── hooks/                # optional
└── ...                   # mcp, lsp, output-style, etc. as needed
```

Then add an entry to the root `.claude-plugin/marketplace.json`:

```json
{
  "name": "<plugin-name>",
  "source": "./plugins/<plugin-name>",
  "description": "..."
}
```

Validate before committing:

```
claude plugin validate --strict plugins/<plugin-name>
claude plugin validate --strict .
```

Set an initial `"version": "1.0.0"` in the new plugin's `plugin.json` — that's its one-time
manual baseline. From then on the CI pipeline (see below) computes and bumps the version itself
on every commit that touches the plugin's directory; don't hand-edit `version` after that.
After the pipeline tags a new version, run `/plugin marketplace update itl-claude-tools` on other
machines to pick up the change.

## CI/CD

One pipeline, `.github/workflows/ci.yml`, built from reusable templates. It discovers every
plugin under `plugins/*/` at runtime — **adding a new plugin needs zero pipeline changes.**
**The pipeline owns `version` in every `plugin.json` — don't hand-edit it.**

```
ci.yml (single entry point, runs on every push/PR)
├─ discover           finds every plugins/*/ with a plugin.json
├─ validate-marketplace   ─┐
├─ validate-plugins  (matrix)├─ both call the reusable _validate.yml template
├─ version-and-tag    master-branch pushes only; sequential (not matrix — it
│                      commits+pushes per plugin and builds the aggregated
│                      list the release stage needs). Per-plugin semver
│                      logic lives in .github/scripts/bump-plugin-version.sh,
│                      called once per changed plugin, not duplicated inline.
└─ release            (matrix over every plugin just tagged) calls the
                       reusable _release.yml template
```

| File | Role |
|---|---|
| `ci.yml` | the only workflow you watch/trigger; orchestrates everything below |
| `_validate.yml` | reusable (`workflow_call`) — `claude plugin validate --strict` on one path |
| `_release.yml` | reusable (`workflow_call`, also `push: tags` + `workflow_dispatch` as fallbacks) — zips a tagged plugin and publishes a GitHub Release |
| `scripts/bump-plugin-version.sh` | shared per-plugin version-bump logic, called from `version-and-tag` |

**To ship a new version**: just commit changes under `plugins/<name>/` to `master` using a
[conventional commit](https://www.conventionalcommits.org/) prefix, and push:

| Commit message touches the plugin dir | Bump |
|---|---|
| `feat!: ...` or contains a `BREAKING CHANGE` footer | major |
| `feat: ...` / `feat(scope): ...` | minor |
| anything else (`fix:`, `chore:`, `docs:`, no changes) | patch (or skipped if nothing changed) |

No manual `git tag`, `gh release`, or `plugin.json` edits needed — the pipeline computes the
version, bumps it, tags it, and releases it in one run. A plugin with no tag yet keeps whatever
version is currently committed as its v1 baseline; every bump after that is pipeline-owned.

Release zip URLs (`https://github.com/ITlusions/ITL.Claude.PluginMarketplace/releases/download/...`)
are usable directly with `claude --plugin-url <url>` for one-off session loads, in addition to the
normal `/plugin marketplace add` + `/plugin install` flow via the git HTTPS URL.

## Notes

- Plugin content is bundled into `~/.claude/plugins/cache/` on install — don't reference files
  outside the plugin directory with `../`, and keep paths inside `SKILL.md`/agent files relative,
  not absolute machine-specific paths.
- Private repo works fine as a marketplace source; Claude Code uses your normal git credentials.
