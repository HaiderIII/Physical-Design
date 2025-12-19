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
| plc_003_padding_panic | [Padding Panic](plc_003_padding_panic/PROBLEM.md) | Advanced | ASAP7 | ✅ |

---

## Progression Path

1. **plc_001_density** - Placement density basics (15-20 min)
   - *Bug*: Density too high (0.95)
   - *Skills*: Density parameter, placement quality metrics

2. **plc_002_timing_driven** - Timing-driven placement (20-25 min)
   - *Bug*: Missing `-timing_driven` flag
   - *Skills*: Timing optimization, SDC constraints in placement

3. **plc_003_padding_panic** - Cell padding for advanced nodes (15-20 min)
   - *Bug*: No cell padding configured
   - *Skills*: Cell padding, routing congestion, DFF spacing

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

### Cell Padding (Advanced Nodes)

```tcl
# Add spacing between cells for routing
set_placement_padding -global -left 2 -right 2

# Extra padding for sequential cells
set_placement_padding -masters {DFF*} -left 4 -right 4
```

Why padding matters at 7nm:
- Tight metal pitches (36nm M1/M2)
- Need room for local routing
- Clock tree routing near flip-flops

### Common Placement Errors

- High delta HPWL: Density too high
- Routing congestion: Not enough space
- Timing failures: Missing `-timing_driven` flag
- DRC violations: Missing cell padding (advanced nodes)
