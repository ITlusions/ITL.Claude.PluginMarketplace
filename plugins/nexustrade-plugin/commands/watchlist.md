---
description: Summarize a pasted watchlist with quick bias/signal per ticker
argument-hint: [paste watchlist: tickers, or ticker + notes per line]
---

Use the `nexustrade` skill to summarize this watchlist:

$ARGUMENTS

For each ticker, give a compact one-line read: bias (LONG/SHORT/NEUTRAL), verdict (TRADE/PASS/WATCH), the key level to watch (support/resistance/entry trigger), and any active red flags (earnings soon, high short float, shelf registration, etc.). Present as a single table sorted by conviction (TRADE first, then WATCH, then PASS). Flag anything requiring immediate attention (e.g. earnings this week, breaking below 200MA). End with the educational-only disclaimer.
