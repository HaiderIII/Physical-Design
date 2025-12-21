# Solution: SGN_005 - DRC Disaster

## The Bug

The SDC file has very restrictive DRC constraints:

```tcl
set_max_fanout 5 [current_design]
set_max_transition 0.05 [current_design]
set_max_capacitance 0.01 [current_design]
```

And the flow is **missing `repair_design`** to fix these violations.

## Why This Causes Problems

1. **rst_n fanout violation**: Reset net fans out to 47 flops but limit is 5
2. **Clock buffer fanout**: Clock buffers drive 10-14 sinks, limit is 5
3. **Capacitance violations**: Load capacitance exceeds 0.01pF limit
4. **Slew violations**: Transition times exceed 0.05ns limit

## The Fix

### Option 1: Add repair_design (Recommended)

Add these lines after `estimate_parasitics`:

```tcl
estimate_parasitics -global_routing

# Fix DRC violations
repair_design -slew_margin 0.1 -cap_margin 0.1

detailed_placement
check_placement -verbose
estimate_parasitics -global_routing
```

### Option 2: Relax SDC constraints

Change to more reasonable values:

```tcl
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
set_max_capacitance 0.1 [current_design]
```

## After the Fix

```
=== DRC Violation Report ===
No slew violations found.
No capacitance violations found.
No fanout violations found.
```

## Key Concepts

| DRC Type | What it Checks | Fix Method |
|----------|---------------|------------|
| Fanout | # of sinks per driver | Insert buffers |
| Slew | Transition time | Upsize driver or add buffer |
| Capacitance | Load on driver | Upsize driver or add buffer |

## Quiz Answers

1. **B** - One driver is connected to too many sinks
2. **B** - Signal edges are too slow, causing noise and timing uncertainty
3. **C** - repair_design
4. **A** - limit=5, actual=47, slack=-42
5. **B** - Inserts buffers to split the load
6. **B** - Load exceeds driver capability
7. **B** - They indicate potential silicon failures
