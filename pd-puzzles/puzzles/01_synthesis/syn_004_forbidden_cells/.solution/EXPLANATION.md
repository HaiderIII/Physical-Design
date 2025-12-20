# Solution Explanation - SYN_004: Forbidden Cells

## The Bug

The forbidden cell verification was disabled:

```tcl
set enable_forbidden_check false    ;# BUG!
```

## The Fix

Enable the check:

```tcl
set enable_forbidden_check true
```

## Why This Check Exists

### Cell Library Reality

Libraries contain many cell types, but not all should be used in synthesis:

```
Sky130HD Library:
├── Logic cells       ← Use freely
├── Clock cells       ← CTS only
├── Delay cells       ← NEVER in logic
└── Physical cells    ← P&R only
```

### The Forbidden Cells in This Netlist

The netlist contains:
1. `sky130_fd_sc_hd__dlygate4sd1_1` - A delay gate
2. `sky130_fd_sc_hd__clkdlybuf4s15_1` - A clock delay buffer

Both are HIGH VARIABILITY cells meant for special purposes.

### Production Workflow

```
1. Synthesis delivers netlist
         ↓
2. PD runs forbidden cell check  ← THIS PUZZLE
         ↓
   ┌─────┴─────┐
   │ Cells     │ No forbidden cells
   │ found?    │ → Proceed to P&R
   └─────┬─────┘
         │ Yes
         ↓
3. Reject netlist
         ↓
4. Synthesis adds dont_use:
   set_dont_use [get_lib_cells *dlygate*]
         ↓
5. Re-synthesize
```

### Why Delay Cells Are Dangerous

| Aspect | Regular Buffer | Delay Cell |
|--------|---------------|------------|
| Variation | ±5% | ±20-30% |
| Purpose | General logic | Timing fixes only |
| DRC | Clean | May violate |
| Yield | Normal | Reduced |

Using delay cells in logic is like using a race car engine in a daily commuter - it might work, but it's not designed for that purpose.
