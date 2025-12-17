# 03_placement Puzzles

## Overview

Placement determines where cells are positioned on the chip. These puzzles cover:
- Placement density and congestion
- Timing-driven placement
- Placement blockages
- Macro placement

---

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| plc_001_density | [The Density Dilemma](plc_001_density/PROBLEM.md) | Beginner | Nangate45 | Completed |

---

## Progression Path

1. **plc_001_density** - Placement density basics (15-20 min)
   - *Bug*: Density too high (0.95)
   - *Skills*: Density parameter, placement quality metrics

---

## Key Concepts

### Global vs Detailed Placement

```
Global Placement:
- Cells can overlap
- Optimizes wirelength (HPWL)
- Uses density as target

Detailed Placement (Legalization):
- Snaps cells to legal sites
- Removes all overlaps
- May increase wirelength
```

### Placement Density

The `-density` parameter controls cell packing:
```
density = 0.95 → Very tight (5% whitespace)
density = 0.60 → Balanced (40% whitespace)
density = 0.40 → Relaxed (60% whitespace)
```

### Quality Metrics

| Metric | Description |
|--------|-------------|
| HPWL | Half-Perimeter Wire Length |
| delta HPWL | Change during legalization |
| displacement | How far cells moved |

### Common Placement Errors

- High delta HPWL: Density too high
- Routing congestion: Not enough space
- Timing failures: Poor cell positions
