---
description: Log a trade to the NexusTrade journal format
argument-hint: [date] [ticker, side, entry, stop, targets, thesis, ...]
---

Use the `nexustrade` skill to log this trade to the journal:

$ARGUMENTS

Output the trade as a single JSON object matching the standard journal schema (id, date, ticker, side, entry, stop_loss, target_1, target_2, shares, portfolio_size, risk_pct, thesis, confidence, status, exit_price, exit_date, pnl, notes). Fill in every field you can infer from the input; ask for anything critical that's missing (entry, stop-loss, thesis) rather than guessing. Read the existing `data/trades.json` (relative to the skill's own directory) and append the new entry, creating the file with an empty array first if it doesn't exist.
