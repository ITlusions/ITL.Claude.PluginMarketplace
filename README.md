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

One pipeline, `.github/workflows/pipeline.yml`, with the same `ci` + `publish` shape used across
ITLusions repos (e.g. `ITL.Braincell.SDK/pipeline.yml`) — both jobs are thin `uses:` wrappers
around reusable templates centralized in
[ITlusions/ITL.Github](https://github.com/ITlusions/ITL.Github):

| Job | Calls | Does |
|---|---|---|
| `ci` | `_reusable-claude-plugins-ci.yml` (matrix: marketplace root + each plugin) | `claude plugin validate --strict` |
| `publish` | `_reusable-claude-plugins-publish.yml` (matrix, `master` pushes only) | per plugin: compute next semver from conventional commits touching its directory, bump `plugin.json`, commit, tag via `claude plugin tag`, then zip + publish a GitHub Release — idempotent, safe to run on every push |

**The pipeline owns `version` in every `plugin.json` — don't hand-edit it.** A plugin with no tag
yet keeps whatever version is currently committed as its v1 baseline; every bump after that is
pipeline-owned.

**Adding a new plugin**: add one entry to the `matrix.plugin` list in both the `ci` and `publish`
jobs of `pipeline.yml` (and to `path:` in `ci` if you want it explicit) — everything else scales
automatically via the shared templates.

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
