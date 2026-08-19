---
description: Calculate position size only, using the 1% risk rule
argument-hint: portfolio=$X entry=$X stop=$X
---

Use the `nexustrade` skill to calculate position size ONLY (skip the full 7-step analysis) for:

$ARGUMENTS

Apply the 1% risk rule: `Risk Amount = Portfolio × 0.01`, `Risk Per Share = |Entry − Stop|`, `Shares = Risk Amount ÷ Risk Per Share`, `Position Value = Shares × Entry`. If a portfolio size isn't given, output the table for all three standard sizes ($5,000 / $10,000 / $25,000). Use notebook `01_position_sizing.ipynb` if available, otherwise compute the formula directly and say so.
