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

Bump `version` in the plugin's `plugin.json` on every content change — that's what triggers
`/plugin marketplace update itl-claude-tools` to actually pick up changes on other machines.

## CI/CD

Three GitHub Actions workflows handle validation and release automatically:

| Workflow | Trigger | Does |
|---|---|---|
| `validate.yml` | every push/PR, any branch | `claude plugin validate --strict` on the marketplace manifest and every `plugins/*/` |
| `tag.yml` | after `validate.yml` succeeds on `master` | for each plugin, compares `plugin.json`'s `version` against existing `{plugin}--v{version}` git tags; if it changed, creates and pushes a new tag via `claude plugin tag` |
| `release.yml` | push of a `*--v*` tag (i.e. triggered by `tag.yml`) | re-validates the tagged plugin, zips it, and publishes a GitHub Release with the zip attached |

**To ship a new version**: bump `version` in the plugin's `plugin.json`, commit, push to `master`.
The pipeline tags and releases it automatically — no manual `git tag`/`gh release` needed.

Release zip URLs (`https://github.com/ITlusions/ITL.Claude.PluginMarketplace/releases/download/...`)
are usable directly with `claude --plugin-url <url>` for one-off session loads, in addition to the
normal `/plugin marketplace add` + `/plugin install` flow via the git HTTPS URL.

## Notes

- Plugin content is bundled into `~/.claude/plugins/cache/` on install — don't reference files
  outside the plugin directory with `../`, and keep paths inside `SKILL.md`/agent files relative,
  not absolute machine-specific paths.
- Private repo works fine as a marketplace source; Claude Code uses your normal git credentials.
