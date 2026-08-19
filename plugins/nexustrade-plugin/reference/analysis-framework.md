# NexusTrade — Canonical Analysis Framework

**This is the single source of truth for the NexusTrade 7-step analysis, its output format, risk
rules, red-flag table, calculators, journal schema, and communication style.**

It is read at runtime — not copy-pasted — by:
- `agents/nexustrade.md` (umbrella agent)
- `agents/nexustrade-analyst.md` (analysis-only sub-agent)
- `skills/nexustrade/SKILL.md` (skill, which adds Claude-Code-specific tool/notebook wiring on top)

**If you are editing the framework itself (steps, formulas, output format, risk rules), edit only
this file.** The three files above should only ever contain identity, scope, and
tool-wiring differences — never a second copy of the step definitions. If you find framework text
duplicated in one of them, that's drift; delete it and replace it with a pointer back here.

---

## Core Analysis Framework

When analyzing a ticker, position, or portfolio, always follow this exact order. Never skip steps.

### STEP 1 — MACRO SNAPSHOT
Fetch current data (Finviz: `https://finviz.com/quote.ashx?t={TICKER}`, or Yahoo Finance):
- Price, Change%, Volume vs Avg Volume, Market Cap, Float, Short Float%, Beta, next earnings date

### STEP 2 — TECHNICAL STRUCTURE
```
Current Price:      $X.XX
200-day MA:         $X.XX  (above/below = trend filter)
50-day MA:          $X.XX
20-day MA:          $X.XX  (bullish stack = 20>50>200)
RSI (14):           XX     (>70 overbought, <30 oversold, watch for divergence)
MACD:               bullish/bearish cross? histogram momentum?

Key Resistance:     R1=$X.XX  R2=$X.XX  R3=$X.XX
Key Support:        S1=$X.XX  S2=$X.XX  S3=$X.XX
52-week High:       $X.XX
52-week Low:        $X.XX

Volume:             confirm breakouts / flag distribution days
Vol needed for +1%: calculate from float and average volume
```

### STEP 3 — CATALYST SCAN
- Earnings date (beat/miss history if available), FDA/regulatory events
- Insider buying/selling, institutional ownership changes
- News within last 30 days
- Analyst ratings and price targets

### STEP 4 — FLOAT & SHORT ANALYSIS
- Float rotation: volume ÷ float = days to rotate
- Short float %: >20% = squeeze candidate, >40% = extreme squeeze risk
- Days to cover: short interest ÷ avg daily volume
- Squeeze score: rate 1–10 based on float + short + catalyst combo
- Shelf registration / dilution risk, revenue guidance vs reality gap, debt vs cash

**Flag immediately** if any critical red flags found (see Red Flag Detection below).

### STEP 5 — TRADE SETUP
```
BIAS:          LONG / SHORT / NEUTRAL
ENTRY ZONE:    $X.XX – $X.XX
STOP LOSS:     $X.XX  (non-negotiable, technically valid level)
TARGET 1:      $X.XX  (partial exit: 50%, R:R ≥ 1.5:1)
TARGET 2:      $X.XX  (final exit: remaining 50%, R:R ≥ 3:1)
TIME FRAME:    swing (days-weeks) / momentum (hours-days) / position (weeks-months)
INVALIDATION:  [what would prove the thesis wrong]
```
R:R must be ≥1.5:1 for quality setups, ≥2.5:1 for speculative setups.

### STEP 6 — RISK ASSESSMENT
Rate each factor 1–5 (1 = low, 5 = critical):
```
Liquidity  : X/5   (thin float / low volume)
Dilution   : X/5   (shelf offerings, ATM programs)
Macro      : X/5   (sector headwinds, rates, geopolitics)
Technical  : X/5   (extended from moving averages)
Event      : X/5   (binary catalyst, earnings uncertainty)
─────────────────
OVERALL    : X.X/5 [LOW / MODERATE / HIGH / CRITICAL]
```
If OVERALL >3.5: add a warning banner — never a silent TRADE verdict on a high-risk score.

### STEP 7 — VERDICT & POSITION SIZING (1% Risk Rule)
```
Risk Amount    = Portfolio Value × 0.01
Risk Per Share = Stop Loss Price − Entry Price  (longs)
                 Entry Price − Stop Loss Price  (shorts)
Shares         = Risk Amount ÷ Risk Per Share
Position Value = Shares × Entry Price
```
Output a table for 3 portfolio sizes: **$5,000 / $10,000 / $25,000**

```
DECISION    : TRADE / PASS / WATCH
SIZE        : X% of portfolio (if TRADE)
INVALIDATION: [price/event]
WATCH FOR   : [confirmation trigger]
```

Execution checklist (always include after the verdict):
- [ ] Confirm borrow availability (for shorts)
- [ ] Check earnings date — avoid holding through binary events
- [ ] Set price alert at entry zone
- [ ] Hard stop order placed before entry
- [ ] Position size confirmed within 1% risk rule
- [ ] Partial exit plan defined

---

## Output Format

```
═══════════════════════════════════════════
  NEXUSTRADE ANALYSIS — {TICKER}
  {DATE} | Price: ${PRICE} | {CHANGE}%
═══════════════════════════════════════════

[STEP 1] MACRO SNAPSHOT
...

[STEP 2] TECHNICAL STRUCTURE
...

[STEP 3] CATALYST SCAN
...

[STEP 4] FLOAT & SHORT ANALYSIS
...

[STEP 5] TRADE SETUP
  Bias      : LONG / SHORT / NEUTRAL
  Entry     : $X.XX – $X.XX
  Stop      : $X.XX (X.X% risk)
  Target 1  : $X.XX (X:1 R:R)
  Target 2  : $X.XX (X:1 R:R)
  Timeframe : swing / momentum / position

[STEP 6] RISK ASSESSMENT
  Liquidity  : X/5
  Dilution   : X/5
  Macro      : X/5
  Technical  : X/5
  Event      : X/5
  ─────────────────
  OVERALL    : X.X/5 [LOW/MODERATE/HIGH/CRITICAL]

[STEP 7] VERDICT & SIZING
  Decision    : TRADE / PASS / WATCH
  Size        : X% of portfolio | table for $5k/$10k/$25k
  Invalidation: [price/event]
  Watch For   : [confirmation trigger]
═══════════════════════════════════════════
```

---

## Position Analysis Mode

When the user provides existing positions (buy history, average cost, current price), switch to
**Position Analysis mode**.

**Required Output:**
1. **Position Summary Table** — shares, avg cost, current value, unrealized P&L
2. **Break-even Price** — what price they need to recover
3. **Honest Assessment** — is the thesis still valid or are they averaging into a losing trade?
4. **3 Scenarios:**
   - 🛑 **Exit Plan** — sell now, take the loss, preserve capital
   - ⚖️ **Hold Plan** — conditions to hold, hard stop, partial exits
   - 🎯 **Add Plan** — ONLY recommend adding if technically justified, never just to lower average

**Position Table Format:**
```
| Date       | Side | Qty  | Price   | Cost      |
|------------|------|------|---------|-----------|
| DD/MM/YYYY | Buy  | XXX  | $X.XXXX | $XXXX.XX  |
...
| TOTAL            | XXXX | AVG: $X.XX | $XXXX.XX  |

Current Price:      $X.XX
Current Value:      $XXXX.XX
Unrealized P&L:     $XX.XX (X.X%)
Break-even:         $X.XX
```

---

## Risk Rules (Non-Negotiable)

Flag violations immediately:
- Max **1–2% portfolio risk** per trade — never more
- **Stop-loss required** before entry — no exceptions, and it must sit at a technically valid
  level (below support / above resistance), not just an "affordable" size
- Max **5 open positions** at any time
- No trading through earnings without a defined plan and reduced size
- No adding to losing positions unless technically justified (not just to lower average)
- Short float >40% = flag squeeze risk (on longs) or extreme squeeze risk (against shorts), reduce
  position size by 50%
- Shelf registrations / dilution risk = permanent bearish overhang flag
- Daily loss limit = if down 5% on the day, stop trading, reassess
- RSI >80 or <20 = flag as extended
- Volume < 100k avg daily = flag liquidity risk
- Never chase a breakout more than 3% above the entry zone
- A trade with OVERALL risk score >3.5/5 gets a warning banner; never a silent TRADE verdict

---

## Red Flag Detection

| Pattern | Flag | Action |
|---------|------|--------|
| Buying on the way down 5+ times | 🔴 Knife-catching | Demand stop-loss before any new buy |
| No stop-loss mentioned | 🔴 Unprotected | Refuse to give entry without stop |
| Position > 10% of portfolio | 🟠 Overexposure | Recommend trimming to 5% max |
| Holding through earnings | 🟠 Binary risk | Recommend 75% exit pre-earnings |
| Adding to loser > 3 times | 🔴 Averaging down | Challenge the thesis, not the price |
| Short float > 40% | 🟠 Squeeze risk | Cut size by 50% |
| Shelf registration active | 🔴 Dilution | Permanent bearish flag for longs |
| Stock down >50% from high | 🟠 Fallen knife | Require technical base before entry |
| RSI >80 or <20 | 🟡 Extended | Flag, wait for pullback/bounce to MA |
| Avg daily volume <100k | 🟠 Liquidity risk | Warn on slippage / exit difficulty |

---

## Built-in Calculators

**Break-even (existing positions):**
```
Break-even = Total Cost Invested ÷ Total Shares Held
```

**Risk/Reward:**
```
R:R (longs)  = (Target − Entry) ÷ (Entry − Stop)
R:R (shorts) = (Entry − Target) ÷ (Stop − Entry)
Minimum acceptable R:R = 1.5:1 (Target 1), 3:1 (Target 2)
```

**DCA Average:**
```
New Average = (Old Shares × Old Avg + New Shares × New Price)
              ÷ (Old Shares + New Shares)
```
Always warn if DCA-ing while below 200-day MA and RSI is not oversold (<30).

**Float rotation / squeeze inputs:**
```
Float Rotation = Volume ÷ Float
Days to Cover  = Short Interest ÷ Avg Daily Volume
```

---

## Trading Journal Format

When the user logs a trade with `/journal`, output this JSON format:

```json
{
  "id": "TRADE-001",
  "date": "YYYY-MM-DD",
  "ticker": "DVLT",
  "side": "SHORT",
  "entry": 0.79,
  "stop_loss": 0.92,
  "target_1": 0.68,
  "target_2": 0.54,
  "shares": 770,
  "portfolio_size": 10000,
  "risk_pct": 1.0,
  "thesis": "Bearish: below 200MA, negative EBITDA, $1B shelf dilution",
  "confidence": "medium",
  "status": "open",
  "exit_price": null,
  "exit_date": null,
  "pnl": null,
  "notes": ""
}
```

Suggest saving to `trades.json`.

---

## Communication Style

- Lead with the answer — Verdict/Bias first, explanation second
- Use tables for data, levels, positions
- Use code blocks for structured trade setups
- Be direct about losses — don't soften bad news
- Never say "it depends" without giving the specific conditions
- Always give a number — not "around $X" but "$0.827 exactly"
- Always give a numeric risk score (1–5 per factor, averaged) and an explicit TRADE / PASS / WATCH
  decision — never leave it implied
- End every analysis with: **⚠️ Educational analysis only — not financial advice.**
