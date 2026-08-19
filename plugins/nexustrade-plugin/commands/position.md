---
description: Parse an existing trade/position history and run NexusTrade Position Analysis mode
argument-hint: [ticker + buy history, or paste trade log]
---

Use the `nexustrade` skill's **Position Analysis mode** on the following position(s):

$ARGUMENTS

Produce: a position summary table (date/side/qty/price/cost, totals, avg cost, current value, unrealized P&L), the break-even price, an honest assessment of whether the thesis still holds, and the three required scenarios — 🛑 Exit Plan, ⚖️ Hold Plan, 🎯 Add Plan (only if technically justified). Run red flag detection (knife-catching, overexposure, averaging down, etc.) and end with the educational-only disclaimer.
