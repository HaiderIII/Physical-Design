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
| plc_002_timing_driven | [The Timing Tunnel Vision](plc_002_timing_driven/PROBLEM.md) | Intermediate | Sky130HD | Completed |

---

## Progression Path

1. **plc_001_density** - Placement density basics (15-20 min)
   - *Bug*: Density too high (0.95)
   - *Skills*: Density parameter, placement quality metrics

2. **plc_002_timing_driven** - Timing-driven placement (20-25 min)
   - *Bug*: Missing `-timing_driven` flag
   - *Skills*: Timing optimization, SDC constraints in placement

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

### Timing-Driven Placement

```
Without timing-driven:
  All nets weighted equally → Critical paths may get long wires

With timing-driven (-timing_driven flag):
  Critical nets prioritized → Timing-critical paths stay short
```

### Quality Metrics

| Metric | Description |
|--------|-------------|
| HPWL | Half-Perimeter Wire Length |
| delta HPWL | Change during legalization |
| displacement | How far cells moved |
| slack | Timing margin (positive = good) |

### Common Placement Errors

- High delta HPWL: Density too high
- Routing congestion: Not enough space
- Timing failures: Missing `-timing_driven` flag
