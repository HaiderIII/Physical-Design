# 05_routing Puzzles - Global & Detailed Routing

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| rte_001_layers | [The Layer Labyrinth](rte_001_layers/PROBLEM.md) | Beginner | Nangate45 | Completed |
| rte_002_adjustment_agony | [The Adjustment Agony](rte_002_adjustment_agony/PROBLEM.md) | Intermediate | Sky130HD | Completed |
| rte_003_ndr_nightmare | [NDR Nightmare](rte_003_ndr_nightmare/PROBLEM.md) | Advanced | ASAP7 | ✅ |

---

## Progression Path

1. **rte_001_layers** - Routing layer configuration (15-20 min)
   - *Bug*: Using metal1-metal2 instead of metal2-metal6 for routing
   - *Skills*: Routing layer selection, congestion basics

2. **rte_002_adjustment_agony** - Layer adjustment values (20-25 min)
   - *Bug*: Inverted layer adjustments (blocking upper layers, freeing lower)
   - *Skills*: Layer adjustment strategy, congestion management, resource allocation

3. **rte_003_ndr_nightmare** - Min routing layer for 7nm (15-20 min)
   - *Bug*: Min routing layer set to M2 (too low for ASAP7)
   - *Skills*: Metal stack understanding, layer selection for advanced nodes

---

## Key Concepts

### Layer Adjustment Values

| Value | Meaning | Effect |
|-------|---------|--------|
| 0.0 | No reduction | Full capacity available |
| 0.5 | 50% reduction | Half capacity |
| 1.0 | 100% reduction | Layer blocked |

### Typical Adjustment Strategy

| Layer | Typical Adjustment | Reason |
|-------|-------------------|--------|
| met1 | 0.8-1.0 | Very congested (cell pins) |
| met2 | 0.5-0.7 | Moderate congestion |
| met3 | 0.3-0.5 | Less congested |
| met4 | 0.1-0.3 | Usually available |
| met5 | 0.0-0.2 | Most available |

### ASAP7 Metal Stack (7nm)

| Layer | Pitch | Primary Use |
|-------|-------|-------------|
| M1 | 36nm | Cell internal (blocked) |
| M2 | 36nm | Cell pins (congested) |
| M3 | 48nm | Local routing (limited) |
| M4 | 48nm | Signal routing (start here!) |
| M5-M6 | 48nm | Global routing |
| M7 | 80nm | Power/clock |

### Common Routing Errors

- Using wrong layer range for signals
- Inverted layer adjustments
- Not accounting for cell pin congestion on lower layers
- Over-restricting available routing layers
- Min layer too low for advanced nodes

---

## Prerequisites

Before starting routing puzzles, complete:
1. `flp_001_sizing` - Understanding floorplanning
2. `plc_001_density` - Understanding placement
3. `cts_001_skew` - Understanding CTS

Routing is the final step before physical verification.
