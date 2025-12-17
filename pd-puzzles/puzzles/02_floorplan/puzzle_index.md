# 02_floorplan Puzzles

## Overview

Floorplan is the foundation of physical design. These puzzles cover:
- Die and core area sizing
- Utilization calculations
- IO placement
- Macro placement
- Power planning basics

---

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| flp_001 | [The Impossible Floorplan](flp_001/PROBLEM.md) | Beginner | Nangate45 | Completed |

---

## Progression Path

1. **flp_001** - Die area sizing and utilization (15-20 min)
   - *Bug*: Die too small for the design
   - *Skills*: Area calculation, utilization concepts

---

## Key Concepts

### Die vs Core Area
- **Die Area**: Total chip area including pads
- **Core Area**: Placeable area for standard cells
- **Margins**: Space for IO ring (typically 2-5um)

### Utilization
```
Utilization = Cell Area / Core Area

Typical ranges:
- Simple designs: 60-70%
- Complex designs: 40-60%
- High-performance: 30-50%
```

### Common Floorplan Errors
- Utilization > 100%: Die too small
- Placement congestion: Not enough routing space
- Timing failures: Poor macro placement
