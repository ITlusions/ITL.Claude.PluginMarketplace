---
model: claude-haiku-4-5-20251001
---

# Save to BrainCell — Generic Data Persistence Skill

## Purpose
Persist any analysis, research, findings, or structured data to braincell-cache with automatic formatting, validation, and reindexing.

Works across all domains: trading, security, infrastructure, planning, research, etc.

---

## Usage

```
/save-to-braincell [data] [category] [tags] [title]
```

### Parameters

| Param | Required | Format | Example |
|-------|----------|--------|---------|
| `data` | ✅ Yes | Text, JSON, markdown | Analysis output, report content |
| `category` | ✅ Yes | kebab-case | `trading-analysis`, `threat-intelligence` |
| `tags` | ❌ No | Comma-separated | `MU,technical-analysis,nexustrade` |
| `title` | ❌ No | String | Auto-extracted from metadata if not provided |

---

## Supported Categories

**Trading & Investment:**
- `trading-analysis` — Quantitative trade analyses
- `trading-automation` — Trading bots, automation systems
- `nexustrade-portfolio` — Positions, trades, journal entries
- `investment-thesis` — Long-term theses
- `portfolio-strategy` — Asset allocation, rebalancing
- `day-trading` — Short-term day trades
- `momentum-trading` — Momentum setups
- `semiconductor-market` — MU, ASML, TSM specific

**Security & Research:**
- `threat-intelligence` — Threat feeds, indicators, reports
- `security-research` — Security research papers, findings
- `security-analysis` — Vulnerability analysis, risk assessment
- `security-offensive` — Offensive PoC, red team operations
- `kernel-exploitation` — Low-level exploitation research
- `vulnerability-analysis` — CVE analysis, exploit code

**Infrastructure & Architecture:**
- `infrastructure-architecture` — System design, deployment patterns
- `network-infrastructure` — Network topology, protocols
- `sdr-adsb` — Software-defined radio, ADS-B tracking
- `amalia` — Platform architecture ideas

**Protocols & Frameworks:**
- `aicp-protocol` — AICP protocol analysis, specs, design
- `a2a-protocol` — A2A security, rules of engagement
- `itl-platform` — ITL platform components

**Business & Planning:**
- `ib-aangifte-2025` — Tax filing 2025
- `ib-aangifte-2026` — Tax filing 2026
- `ib-tooling` — Tax automation, conversions
- `planning` — Project planning, roadmaps, sprints
- `braincell` — BrainCell platform audits, planning

**AI & Emerging Tech:**
- `ai-ml-research` — AI/ML research, papers, experiments
- `ai-security-threats` — AI worm research, prompt injection
- `quantum-emerging-tech` — Quantum computing, emerging technologies

**Other:**
- `overig` — Miscellaneous (default fallback)

---

## Workflow

### Step 1: Validate Input
- ✅ Data is not empty
- ✅ Category is valid (or will auto-infer)
- ✅ Tags are comma-separated strings (or empty)

### Step 2: Format for BrainCell
Wrap in **ReplayCacheFile** schema:

```json
{
  "braincell_url": "http://localhost:9504",
  "cached_at": "YYYY-MM-DD",
  "created_at": "ISO-8601-datetime",
  "status": "pending_replay",
  "records": [
    {
      "cell": "[category]",
      "title": "[extracted or provided title]",
      "content": "[data]",
      "tags": ["tag1", "tag2", ...]
    }
  ]
}
```

### Step 3: Generate Filename
**Convention:** `bc-[namespace]-[description]-[YYYY-MM-DD].[extension]`

**Pattern breakdown:**
- `bc-` — BrainCell prefix (required)
- `[namespace]` — Topic/domain (nexustrade, threat-intelligence, aicp, etc.)
- `[description]` — Human-readable descriptor (kebab-case)
- `[YYYY-MM-DD]` — Date created (ISO format)
- `.[extension]` — json, md, yaml

**Examples:**
- `bc-nexustrade-mu-analysis-2026-08-01.json`
- `bc-threat-intelligence-copy-fail-2026-08-01.json`
- `bc-security-research-aicp-protocol-2026-08-01.json`
- `bc-itl-k8s-upgrade-runbook-2026-08-01.md`
- `bc-trading-analysis-portfolio-asml-2026-08-01.json`

### Step 4: Save to BrainCell Cache
Location: `C:\Users\NielsWeistra\.itl\braincell-cache\[filename]`

### Step 5: Reindex Automatically
Run: `.github\scripts\rebuild-cache-index.ps1`

This updates `_index.json` with:
- New file entry
- Extracted metadata
- Updated category counts
- File size tracking

### Step 6: Confirm to User
Output format:
```
✅ Saved: [filename]
✅ Size: XXX bytes
✅ Category: [category]
✅ Tags: [tag1, tag2, ...]
✅ Status: pending_replay
✅ Reindexed: [total files] files in [total categories] categories
✅ Path: C:\Users\NielsWeistra\.itl\braincell-cache\[filename]
```

---

## Auto-Categorization

If `category` is not provided, inferred from filename patterns:

| Pattern | → Category |
|---------|-----------|
| `nexustrade-*` | `trading-analysis` |
| `threat-*` | `threat-intelligence` |
| `aicp-*` | `aicp-protocol` |
| `security-*` | `security-analysis` |
| `ib2026-*` or `ib-*` | `ib-aangifte-2026` |
| `ib2025-*` | `ib-aangifte-2025` |
| `amalia-*` | `amalia` |
| `braincell-*` | `braincell` |
| `a2a-*` | `a2a-protocol` |
| `sdr-*` | `sdr-adsb` |
| `momentum-*` or `*dvlt*` | `momentum-trading` |
| (other) | `overig` |

---

## Examples

### Example 1: Save Trading Analysis

```
Input:
/save-to-braincell [7-step MU analysis] trading-analysis MU,technical-analysis,fibonacci,nexustrade,semiconductor

Output:
✅ Saved: bc-nexustrade-mu-analysis-2026-08-01.json
✅ Size: 8.2 KB
✅ Category: trading-analysis
✅ Tags: MU, technical-analysis, fibonacci, nexustrade, semiconductor
✅ Status: pending_replay
✅ Reindexed: 245 files in 35 categories
✅ Path: C:\Users\NielsWeistra\.itl\braincell-cache\bc-nexustrade-mu-analysis-2026-08-01.json
```

### Example 2: Save Threat Intelligence

```
Input:
/save-to-braincell [CVE-2026-31431 report] threat-intelligence CVE-2026-31431,copy-fail,linux,kernel,privilege-escalation

Output:
✅ Saved: bc-threat-intelligence-copy-fail-2026-08-01.json
✅ Size: 15.4 KB
✅ Category: threat-intelligence
✅ Tags: CVE-2026-31431, copy-fail, linux, kernel, privilege-escalation
✅ Status: pending_replay
✅ Reindexed: 246 files in 35 categories
```

### Example 3: Save Architecture Notes

```
Input:
/save-to-braincell [AICP protocol design notes] aicp-protocol AICP,multiplexing,protocol,message-framing

Output:
✅ Saved: bc-aicp-protocol-design-2026-08-01.json
✅ Size: 12.1 KB
✅ Category: aicp-protocol
✅ Tags: AICP, multiplexing, protocol, message-framing
✅ Status: pending_replay
✅ Reindexed: 247 files in 35 categories
```

### Example 4: Auto-Categorization

```
Input:
/save-to-braincell [Position review] nexustrade-portfolio-asml [no category provided]

Process:
- Filename pattern: nexustrade-portfolio-*
- Auto-category: trading-analysis
- Auto-topic: portfolio-asml
- Auto-title: Position Review (extracted from context)

Output:
✅ Saved: trading-analysis-portfolio-asml-2026-08-01.json
✅ Auto-categorized as: trading-analysis
```

---

## Replay to BrainCell API

Once BrainCell API is running (`http://localhost:9504`):

```bash
# Check API health
curl http://localhost:9504/health

# Files marked "pending_replay" are ready to send
# API will ingest them via POST /api/[cell]
```

Files with `"status": "replayed"` have already been sent.  
Files with `"status": "partial"` are incomplete/draft.

---

## Error Handling

| Error | Handling |
|-------|----------|
| **Invalid JSON** | Reject + show schema + offer to wrap as text |
| **Missing category** | Auto-infer from filename or prompt user |
| **Empty data** | Reject + prompt for content |
| **Reindex fails** | Save file anyway, warn user, suggest manual reindex |
| **File exists** | Append `-v2`, `-v3`, etc. or ask user to overwrite |

---

## Integration with NexusTrade

**After `/analyze MU`:**
```
Claude: [7-step analysis output]
User: /save-to-braincell [analysis] trading-analysis MU,nexustrade

Result:
- Analysis saved as: bc-nexustrade-mu-analysis-2026-08-01.json
- _index.json updated
- Ready for /journal MU to reference
- Searchable in braincell index
```

---

## Workflow Summary

```
Analysis/Research Complete
        ↓
/save-to-braincell [data] [category] [tags]
        ↓
Format as ReplayCacheFile
        ↓
Generate filename
        ↓
Save to C:\Users\NielsWeistra\.itl\braincell-cache\
        ↓
Run rebuild-cache-index.ps1
        ↓
_index.json auto-updates
        ↓
Ready for BrainCell API replay (when available)
        ↓
Searchable, indexed, persistent
```

---

## Notes

- **Idempotent**: Multiple saves with same data creates versioned files (`-v2`, `-v3`)
- **Metadata-aware**: Extracts title, date, tags from input if present
- **Schema-validated**: Ensures ReplayCacheFile compliance before saving
- **Status-tracked**: All files start as `pending_replay`
- **Fully indexed**: `_index.json` auto-regenerates with each save

---

**Ready to persist any data to braincell-cache.**
