# SYN_004: Forbidden Cells

## Difficulty: Expert

## PDK: Sky130HD

## Problem Description

You received a synthesized netlist for verification. Your job is to check for **forbidden cells** before the design proceeds to P&R.

However, the verification check is **disabled**! This means dangerous cells can slip through undetected.

## Symptoms

When you run `openroad run.tcl`:
- ">>> WARNING: Forbidden cell check is DISABLED! <<<"
- "PUZZLE FAILED - Verification disabled!"

## Your Task

Enable the forbidden cell verification in `run.tcl`.

## Background

### Why Some Cells Are Forbidden

Standard cell libraries contain cells for various purposes:

| Cell Type | Purpose | Why Forbidden in Logic |
|-----------|---------|----------------------|
| `dlygate*` | Timing fixes | High variability, yield issues |
| `clkdlybuf*` | CTS delays | Clock tree only, not logic |
| `dlymetal*` | Analog delays | Special routing, DRC issues |

### Real-World Scenario

In production:
1. Synthesis team delivers netlist
2. PD team runs forbidden cell check
3. If forbidden cells found → reject netlist
4. Synthesis team adds `set_dont_use` and re-synthesizes

### The Cost of Missing This Check

If forbidden cells reach manufacturing:
- 10-20% yield loss
- DRC violations at signoff
- Timing unpredictability
- Potential design respin ($$$)

## Files

- `run.tcl` - **FIX THIS FILE** - Enable the check
- `resources/fsm.v` - Netlist with forbidden cells
- `resources/constraints.sdc` - Timing constraints

## Success Criteria

After fixing:
1. Verification runs and detects forbidden cells
2. "PUZZLE PASSED - Verification enabled!"

## Hints

See `hints.md` if you get stuck.

## Verification

```bash
openroad run.tcl
```
