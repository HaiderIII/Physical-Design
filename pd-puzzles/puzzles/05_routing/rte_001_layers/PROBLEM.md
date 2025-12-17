# RTE_001: The Layer Labyrinth

## Difficulty: Beginner

## Problem Description

You're routing a design but the router keeps failing with congestion errors. The routing layers are misconfigured, causing all signals to compete for the same metal layers.

## Symptoms

When you run `openroad run.tcl`, you see:
- High congestion on certain layers
- Routing overflow errors
- Many DRC violations
- "No routing solution found" messages

## Your Task

Find and fix the routing layer configuration bug in `run.tcl`.

## Background

### Metal Layer Stack (Nangate45)

```
    metal10  ─────────────  (top, power)
    metal9   ─────────────
    metal8   ─────────────
    metal7   ─────────────
    metal6   ─────────────  ← Signal routing (top)
    metal5   ─────────────
    metal4   ─────────────
    metal3   ─────────────
    metal2   ─────────────  ← Signal routing (bottom)
    metal1   ─────────────  ← Local connections only
    ═════════════════════   (substrate)
```

### Layer Usage Guidelines

| Layer | Typical Use | Direction |
|-------|-------------|-----------|
| metal1 | Local cell connections | Horizontal |
| metal2-metal3 | Short signal routes | Vertical/Horizontal |
| metal4-metal6 | Signal routing | Alternating |
| metal7+ | Power/clock distribution | Various |

### Key Routing Parameters

1. **`-signal` layers**: Which layers can be used for signal routing
2. **`-clock` layers**: Which layers for clock nets
3. **Layer adjustments**: Reduce capacity for congested layers

## Files

- `run.tcl` - Main script with bug (fix the TODO)
- `resources/counter.v` - Simple counter design
- `resources/constraints.sdc` - Timing constraints

## Success Criteria

After fixing the bug:
1. Global routing completes without overflow
2. Detailed routing finishes with minimal DRC violations
3. Design is fully routed

## Hints

See `hints.md` for progressive hints if you get stuck.

## Verification

Run your fixed script:
```bash
openroad run.tcl
```

Check for:
- "Routing complete" message
- No "overflow" errors
- Minimal DRC violations

Good luck!
