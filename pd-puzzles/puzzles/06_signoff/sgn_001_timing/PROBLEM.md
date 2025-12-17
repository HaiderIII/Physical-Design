# SGN_001: The Timing Terror

## Difficulty: Beginner

## Problem Description

Your design has completed placement and routing, but the timing analysis is **unreliable**. A critical step is missing before timing signoff can be trusted. Look for warnings in the output!

## Symptoms

When you run `openroad run.tcl`, you see:
- A **warning** about parasitics during CTS or timing analysis
- Timing results based on **wire load models** instead of actual routing
- Results that may look okay but **cannot be trusted** for tape-out

## Your Task

Find the warning, understand what's missing, and fix `run.tcl` to make timing analysis reliable.

## Background

### Why Parasitics Matter

After routing, wires have physical properties that affect timing:

```
Without parasitics:                With parasitics:

Cell A ──────────── Cell B         Cell A ───[R]───[C]─── Cell B
       (ideal wire)                        (real wire RC)
       delay = 0                           delay = f(R,C,length)
```

**Wire load models** are approximations used early in the flow. For **signoff**, you need actual RC values extracted from the routed design.

### Timing Signoff Flow

```
┌─────────────────┐
│  Place & Route  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ??? MISSING ?? │  ← What step extracts wire R,C?
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  report_checks  │  ← Timing with real delays
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Signoff PASS?  │
└─────────────────┘
```

### Key Timing Concepts

| Term | Description |
|------|-------------|
| **Parasitics** | Wire resistance (R) and capacitance (C) |
| **Setup slack** | Time margin before clock edge (positive = good) |
| **Hold slack** | Time margin after clock edge (positive = good) |
| **Wire load model** | Approximation of wire RC (not accurate for signoff) |

### Timing Analysis Commands

```tcl
# Report worst setup path
report_checks -path_delay max

# Report worst hold path
report_checks -path_delay min

# Report all violating paths
report_checks -slack_max 0
```

## Files

- `run.tcl` - Main script with bug (fix the TODO around line 169)
- `resources/alu.v` - Simple 8-bit ALU netlist
- `resources/constraints.sdc` - Timing constraints (100 MHz)

## Success Criteria

After fixing the bug:
1. The warning about parasitics **disappears**
2. Timing analysis uses **extracted RC** instead of wire load models
3. Results are now **reliable for signoff**

## Hints

See `hints.md` for progressive hints if you get stuck.

## Verification

Run your fixed script:
```bash
openroad run.tcl
```

Look for:
- **Before fix**: Warning `[WARNING EST-0027] no estimated parasitics. Using wire load models.`
- **After fix**: Add the missing commands around line 167-168

The solution requires two things:
1. `set_wire_rc -signal` to define wire RC values
2. `estimate_parasitics -global_routing` to extract parasitics from routing

Good luck!
