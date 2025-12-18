# RTE_002: The Adjustment Agony

## Difficulty: Intermediate

## PDK: Sky130HD

## Problem Description

You're routing a shift register design but the global router reports severe congestion on the lower metal layers. The router can't find valid routes and keeps hitting overflow errors.

The layer adjustment values are misconfigured, causing the router to overuse congested layers instead of spreading traffic to higher layers.

## Symptoms

When you run `openroad run.tcl`, you see:
- High congestion on met2 and met3
- Global routing overflow > 0
- "Total wire length" unreasonably high
- Many routing iterations without convergence

## Your Task

Find and fix the layer adjustment configuration in `run.tcl`.

## Background

### Sky130 Metal Stack

```
    met5   ─────────────  (thickest, power/signals)
    met4   ─────────────
    met3   ─────────────  ← Signal routing
    met2   ─────────────  ← Signal routing
    met1   ─────────────  ← Local connections (congested)
    ═══════════════════   (substrate)
```

### Layer Adjustments

`set_global_routing_layer_adjustment` reduces the available routing capacity on a layer:
- Value 0.0 = layer fully available (0% reduction)
- Value 0.5 = 50% capacity reduction
- Value 1.0 = layer completely blocked (100% reduction)

### Why Adjustments Matter

Lower metal layers (met1, met2) are often congested because:
1. Cell pins connect on met1
2. Local routing uses met1-met2
3. Many signals compete for limited tracks

Higher metal layers (met4, met5) have:
1. Fewer obstructions
2. Wider pitch = fewer tracks but less congestion
3. Lower resistance (good for long wires)

### Adjustment Strategy

| Layer | Typical Adjustment | Reason |
|-------|-------------------|--------|
| met1  | 0.8-1.0 | Very congested, cell pins |
| met2  | 0.3-0.5 | Moderate congestion |
| met3  | 0.2-0.3 | Less congested |
| met4  | 0.0-0.2 | Usually available |
| met5  | 0.0-0.1 | Most available |

## Files

- `run.tcl` - Main script with bug (fix the TODO)
- `resources/shift_reg.v` - 32-bit shift register design
- `resources/constraints.sdc` - Timing constraints

## Success Criteria

After fixing the bug:
1. Global routing completes without overflow
2. Total congestion significantly reduced
3. Route completion with reasonable wire length

## Hints

See `hints.md` for progressive hints if you get stuck.

## Verification

Run your fixed script:
```bash
openroad run.tcl
```

Check for:
- "Routing complete" message
- Overflow = 0
- Reasonable congestion reports

Good luck!
