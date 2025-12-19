# RTE_003 - NDR Nightmare (Min Layer Madness)

## Difficulty: Advanced

## PDK: ASAP7 (7nm)

## Problem Description

You're routing an 8-bit counter on ASAP7 (7nm technology). The routing runs but has severe congestion because the **minimum routing layer is set too low**.

At advanced nodes like 7nm:
- M1/M2 are extremely congested with cell internal wiring
- M3 is still busy with local connections
- Signal routing should start at M4 or higher

## Symptoms

When you run the puzzle without fixing it:
```
>>> WARNING: Min routing layer too low for 7nm! <<<
    M2/M3 are congested with cell connections.
    Signal routing should start at M4.
```

## The Bug

The script sets the minimum routing layer too low:
```tcl
set min_routing_layer "M2"    ;# <-- BUG! Too low for 7nm
```

## Your Task

1. Find the minimum routing layer configuration in `run.tcl`
2. Change it to an appropriate layer for ASAP7
3. Run the script until routing passes

## Hints

<details>
<summary>Hint 1: ASAP7 Metal Stack</summary>

```
M7 - Top metal (power, clock)
M6 - Global routing (good for signals)
M5 - Global routing (good for signals)
M4 - Semi-global (preferred for signals)  ← Start here!
M3 - Semi-global (congested at 7nm)
M2 - Local routing (very congested)
M1 - Cell internal (blocked)
```
</details>

<details>
<summary>Hint 2: Why M2 is problematic</summary>

At 7nm:
- Cell pins connect through M1/M2
- Standard cell internal routing uses M1/M2
- Power rails use M1
- Very little capacity left for signal routing

Using M2 for signals competes with cell connectivity!
</details>

<details>
<summary>Hint 3: The fix</summary>

```tcl
set min_routing_layer "M4"    ;# Good for ASAP7
```

M4 is high enough to avoid cell congestion while still having good routing capacity.
</details>

## Success Criteria

The routing passes when:
- Minimum routing layer is M4 or higher
- No critical congestion warnings

## Files

- `run.tcl` - Main script with the bug
- `resources/counter.v` - 8-bit counter netlist
- `resources/constraints.sdc` - Timing constraints (1.5 GHz)

## Learning Objectives

- Understand metal layer usage at advanced nodes
- Learn routing layer configuration
- Recognize congestion from improper layer selection
