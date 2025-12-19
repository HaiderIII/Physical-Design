# SGN_003: Corner Catastrophe

## Difficulty: Advanced

## PDK: ASAP7 (7nm)

## Problem Description

You're running timing signoff on a counter design at 7nm. The script completes but only analyzes the **TT (Typical-Typical)** corner. At advanced nodes, multi-corner analysis is **CRITICAL** for proper signoff!

The current configuration misses worst-case timing scenarios that occur at process corners.

## Symptoms

When you run `openroad run.tcl`, you see:
- ">>> WARNING: Multi-corner analysis DISABLED! <<<"
- ">>> ERROR: SS corner NOT loaded! <<<"
- ">>> ERROR: FF corner NOT loaded! <<<"
- "SIGNOFF FAILED!"

## Your Task

Enable multi-corner analysis by setting the correct corner flags in `run.tcl`.

## Background

### Why Multi-Corner Analysis?

At 7nm, process variation is significant. A chip manufactured at the "slow" process corner behaves very differently from one at the "fast" corner.

```
Process Variation at 7nm:

    FAST (FF)      TYPICAL (TT)      SLOW (SS)
       |               |                |
       v               v                v
    [=====]         [=====]          [=====]
    Short Tpd       Normal Tpd       Long Tpd

    FF: Cells switch FASTER than typical
    SS: Cells switch SLOWER than typical
```

### Corner Selection for Timing Analysis

| Analysis Type | Worst Corner | Why |
|--------------|--------------|-----|
| **Setup** | SS (Slow-Slow) | Data arrives late, clock is slow too, but data path is critical |
| **Hold** | FF (Fast-Fast) | Data arrives too fast, might corrupt the next stage |

### The Problem with TT-Only Analysis

If you only analyze TT corner:
- Setup violations at SS corner are **HIDDEN**
- Hold violations at FF corner are **HIDDEN**
- Your chip may **FAIL in silicon** at process extremes!

### ASAP7 Liberty Files

ASAP7 provides three process corners:
- `*_TT_*.lib` - Typical-Typical (nominal)
- `*_SS_*.lib` - Slow-Slow (worst for setup)
- `*_FF_*.lib` - Fast-Fast (worst for hold)

## Files

- `run.tcl` - **FIX THIS FILE** - Enable multi-corner flags
- `resources/counter.v` - 8-bit counter netlist
- `resources/constraints.sdc` - Timing constraints

## Success Criteria

After fixing:
1. Both SS and FF corners are loaded
2. "Multi-corner analysis: ENABLED"
3. "SIGNOFF PASSED!"

## Hints

See `hints.md` for progressive hints if you get stuck.

## Verification

Run the script:
```bash
openroad run.tcl
```

Check that:
- SS corner is loaded for setup analysis
- FF corner is loaded for hold analysis
- Signoff status shows PASSED

Good luck!
